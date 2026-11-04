import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
import sys, time

torch.manual_seed(42)
np.random.seed(42)

INPUT_SIZE = 784
HIDDEN1 = 1024
HIDDEN2 = 512
N_CLASS = 10
DEVICE = torch.device("cpu")

class MLP(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc1 = nn.Linear(INPUT_SIZE, HIDDEN1)
        self.fc2 = nn.Linear(HIDDEN1, HIDDEN2)
        self.fc3 = nn.Linear(HIDDEN2, N_CLASS)
        self.act = nn.ReLU()
    def forward(self, x):
        x = x.view(x.size(0), -1)
        x = self.act(self.fc1(x))
        x = self.act(self.fc2(x))
        x = self.fc3(x)
        return x
    def nparams(self):
        return sum(p.numel() for p in self.parameters())

class LoRALinear(nn.Module):
    def __init__(self, linear, rank=8):
        super().__init__()
        self.linear = linear
        for p in self.linear.parameters():
            p.requires_grad = False
        in_f = linear.in_features
        out_f = linear.out_features
        self.A = nn.Parameter(torch.zeros(rank, in_f))
        self.B = nn.Parameter(torch.zeros(out_f, rank))
        nn.init.normal_(self.A, std=0.01)
        self.scale = nn.Parameter(torch.ones(1))
    def forward(self, x):
        return self.linear(x) + (self.B @ (self.A @ x.T)).T * self.scale

class LoRAModel(nn.Module):
    def __init__(self, base, rank=8, adapt_names=None):
        super().__init__()
        self.base = base
        self.loras = {}
        if adapt_names is None:
            adapt_names = ["fc1", "fc2"]
        for name in adapt_names:
            mod = getattr(base, name)
            lora = LoRALinear(mod, rank)
            setattr(self, name + "_lora", lora)
            self.loras[name] = lora
    def forward(self, x):
        x = x.view(x.size(0), -1)
        if "fc1" in self.loras:
            x = self.loras["fc1"](x)
        else:
            x = self.base.fc1(x)
        x = self.base.act(x)
        if "fc2" in self.loras:
            x = self.loras["fc2"](x)
        else:
            x = self.base.fc2(x)
        x = self.base.act(x)
        x = self.base.fc3(x)
        return x
    def trainable_params(self):
        return sum(p.numel() for p in self.parameters() if p.requires_grad)

def gen_synthetic_data(n_train=5000, n_test=1000):
    rng = np.random.RandomState(42)
    W = rng.randn(INPUT_SIZE, N_CLASS) * 0.1
    Xtr = rng.randn(n_train, INPUT_SIZE).astype(np.float32)
    logits_tr = Xtr @ W + 0.5 * np.sin(Xtr[:, :10]).sum(axis=1, keepdims=True)
    Ytr = np.argmax(logits_tr, axis=1)
    Xte = rng.randn(n_test, INPUT_SIZE).astype(np.float32)
    logits_te = Xte @ W + 0.5 * np.sin(Xte[:, :10]).sum(axis=1, keepdims=True)
    Yte = np.argmax(logits_te, axis=1)
    return (torch.tensor(Xtr), torch.tensor(Ytr, dtype=torch.long),
            torch.tensor(Xte), torch.tensor(Yte, dtype=torch.long))

def evaluate(model, X, Y, bs=256):
    model.eval()
    correct = 0
    total = 0
    with torch.no_grad():
        for i in range(0, len(X), bs):
            out = model(X[i:i+bs])
            pred = out.argmax(dim=1)
            correct += (pred == Y[i:i+bs]).sum().item()
            total += Y[i:i+bs].size(0)
    return correct / total

def train_model(model, Xtr, Ytr, Xte, Yte, epochs=20, lr=1e-3, bs=64, label="FULL"):
    params = [p for p in model.parameters() if p.requires_grad]
    opt = optim.Adam(params, lr=lr)
    loss_fn = nn.CrossEntropyLoss()
    n = len(Xtr)
    for ep in range(epochs):
        model.train()
        perm = torch.randperm(n)
        total_loss = 0.0
        for i in range(0, n, bs):
            idx = perm[i:i+bs]
            xb, yb = Xtr[idx], Ytr[idx]
            opt.zero_grad()
            out = model(xb)
            loss = loss_fn(out, yb)
            loss.backward()
            opt.step()
            total_loss += loss.item() * xb.size(0)
        tr_acc = evaluate(model, Xtr, Ytr)
        te_acc = evaluate(model, Xte, Yte)
        print(f"[{label}] Epoch {ep+1}/{epochs} loss={total_loss/n:.4f} tr_acc={tr_acc:.4f} te_acc={te_acc:.4f}", flush=True)
    return model

def main():
    print("=== LoRA vs Full Fine-Tuning Experiment ===", flush=True)
    Xtr, Ytr, Xte, Yte = gen_synthetic_data(5000, 1000)
    print(f"Data: train={Xtr.shape} test={Xte.shape}", flush=True)
    print("--- Phase 1: Pretrain base model ---", flush=True)
    base = MLP()
    print(f"Base MLP params: {base.nparams()}", flush=True)
    base = train_model(base, Xtr, Ytr, Xte, Yte, epochs=15, lr=1e-3, label="PRETRAIN")
    print("--- Phase 2: Full Fine-Tuning ---", flush=True)
    full_model = MLP()
    full_model.load_state_dict(base.state_dict())
    full_model = train_model(full_model, Xtr, Ytr, Xte, Yte, epochs=10, lr=5e-4, label="FULL-FT")
    for rank in [4, 8, 16, 32]:
        print(f"--- Phase 3: LoRA rank={rank} ---", flush=True)
        lora_base = MLP()
        lora_base.load_state_dict(base.state_dict())
        lora_model = LoRAModel(lora_base, rank=rank, adapt_names=["fc1", "fc2"])
        tp = lora_model.trainable_params()
        print(f"LoRA rank={rank} trainable: {tp} (vs {base.nparams()} total)", flush=True)
        lora_model = train_model(lora_model, Xtr, Ytr, Xte, Yte, epochs=10, lr=5e-4, label=f"LORA-r{rank}")
    print("=== EXPERIMENT COMPLETE ===", flush=True)

if __name__ == "__main__":
    main()
