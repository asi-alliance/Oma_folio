import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
import json

torch.manual_seed(42)
np.random.seed(42)

D_IN, H1, H2, NC = 784, 256, 128, 10

class MLP(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc1 = nn.Linear(D_IN, H1)
        self.fc2 = nn.Linear(H1, H2)
        self.fc3 = nn.Linear(H2, NC)
        self.act = nn.ReLU()
    def forward(self, x):
        x = x.view(x.size(0), -1)
        x = self.act(self.fc1(x))
        x = self.act(self.fc2(x))
        return self.fc3(x)
    def nparams(self):
        return sum(p.numel() for p in self.parameters())

class LoRALinear(nn.Module):
    def __init__(self, linear, rank=8):
        super().__init__()
        self.linear = linear
        for p in self.linear.parameters():
            p.requires_grad = False
        self.A = nn.Parameter(torch.zeros(rank, linear.in_features))
        self.B = nn.Parameter(torch.zeros(linear.out_features, rank))
        nn.init.normal_(self.A, std=0.01)
        self.scale = nn.Parameter(torch.ones(1))
    def forward(self, x):
        return self.linear(x) + (self.B @ (self.A @ x.T)).T * self.scale

class LoRAModel(nn.Module):
    def __init__(self, base, rank=8):
        super().__init__()
        self.base = base
        self.fc1_lora = LoRALinear(base.fc1, rank)
        self.fc2_lora = LoRALinear(base.fc2, rank)
    def forward(self, x):
        x = x.view(x.size(0), -1)
        x = self.fc1_lora(x)
        x = self.base.act(x)
        x = self.fc2_lora(x)
        x = self.base.act(x)
        return self.base.fc3(x)
    def trainable_params(self):
        return sum(p.numel() for p in self.parameters() if p.requires_grad)

def gen_data(ntr=2000, nte=500):
    rng = np.random.RandomState(42)
    W = rng.randn(D_IN, NC) * 0.1
    Xtr = rng.randn(ntr, D_IN).astype(np.float32)
    Ytr = np.argmax(Xtr @ W + 0.5 * np.sin(Xtr[:, :10]).sum(1, keepdims=True), 1)
    Xte = rng.randn(nte, D_IN).astype(np.float32)
    Yte = np.argmax(Xte @ W + 0.5 * np.sin(Xte[:, :10]).sum(1, keepdims=True), 1)
    return torch.tensor(Xtr), torch.tensor(Ytr), torch.tensor(Xte), torch.tensor(Yte)

def evaluate(model, X, Y, bs=256):
    model.eval()
    correct, total = 0, 0
    with torch.no_grad():
        for i in range(0, len(X), bs):
            pred = model(X[i:i+bs]).argmax(1)
            correct += (pred == Y[i:i+bs]).sum().item()
            total += Y[i:i+bs].size(0)
    return correct / total

def train(model, Xtr, Ytr, Xte, Yte, ep=30, lr=1e-3, bs=64, label="FULL"):
    params = [p for p in model.parameters() if p.requires_grad]
    opt = optim.Adam(params, lr=lr)
    lf = nn.CrossEntropyLoss()
    n = len(Xtr)
    for e in range(ep):
        model.train()
        perm = torch.randperm(n)
        tl = 0.0
        for i in range(0, n, bs):
            idx = perm[i:i+bs]
            opt.zero_grad()
            loss = lf(model(Xtr[idx]), Ytr[idx])
            loss.backward()
            opt.step()
            tl += loss.item() * idx.size(0)
        if (e+1) % 10 == 0 or e == 0:
            print(f"[{label}] ep {e+1}/{ep} loss={tl/n:.6f} tr={evaluate(model,Xtr,Ytr):.4f} te={evaluate(model,Xte,Yte):.4f}", flush=True)
    return model

def compute_loss(model, X, Y, bs=256):
    model.eval()
    lf = nn.CrossEntropyLoss(reduction="sum")
    total = 0.0
    with torch.no_grad():
        for i in range(0, len(X), bs):
            total += lf(model(X[i:i+bs]), Y[i:i+bs]).item()
    return total / len(X)

def get_flat(model):
    ps = [p for p in model.parameters() if p.requires_grad]
    return ps, torch.cat([p.detach().flatten() for p in ps])

def set_flat(model, vec):
    ps = [p for p in model.parameters() if p.requires_grad]
    idx = 0
    for p in ps:
        n = p.numel()
        p.data = vec[idx:idx+n].view(p.shape).clone()
        idx += n

def rwmh_llc(model, X, Y, temps, n_steps=3000, burnin=1000, label="LLC"):
    ps, theta0 = get_flat(model)
    d = len(theta0)
    n = len(X)
    L0 = compute_loss(model, X, Y)
    print(f"  [{label}] d={d} n={n} L0={L0:.8f}", flush=True)
    rng = np.random.RandomState(77)
    results = []
    for T in temps:
        sigma = max((2.0*T/n)**0.5, 1e-4) * 3.0
        cur = theta0.clone()
        cur_loss = L0
        L_min = L0
        losses = []
        n_acc = 0
        acc_win = 0
        for step in range(n_steps):
            prop = cur + sigma * torch.tensor(rng.randn(d), dtype=torch.float32)
            set_flat(model, prop)
            prop_loss = compute_loss(model, X, Y)
            if np.log(rng.random()) <= -n*(prop_loss - cur_loss)/T:
                cur = prop.clone()
                cur_loss = prop_loss
                n_acc += 1
                acc_win += 1
            if prop_loss < L_min:
                L_min = prop_loss
            if step < burnin and step > 0 and step % 50 == 0:
                rate = acc_win / 50.0
                if rate < 0.15: sigma *= 0.8
                elif rate > 0.35: sigma *= 1.2
                acc_win = 0
            if step >= burnin:
                losses.append(cur_loss - L_min)
        llc = [l/T for l in losses]
        acc = n_acc / n_steps
        llc_med = float(np.median(llc))
        print(f"  [{label}] T={T:.4f} LLC_med={llc_med:.4f} acc={acc:.3f} sigma={sigma:.6f}", flush=True)
        results.append({"T": T, "LLC_med": llc_med, "acc": acc})
    set_flat(model, theta0)
    return results

def main():
    print("=== LLC: LoRA vs Full-FT ===", flush=True)
    Xtr, Ytr, Xte, Yte = gen_data(2000, 500)
    print(f"Data: {Xtr.shape} {Xte.shape}", flush=True)
    print("--- Pretrain ---", flush=True)
    base = MLP()
    print(f"Params: {base.nparams()}", flush=True)
    base = train(base, Xtr, Ytr, Xte, Yte, ep=30, label="PRE")
    base_state = {k: v.clone() for k, v in base.state_dict().items()}
    temps = [0.001, 0.002, 0.005, 0.01, 0.02]
    all_res = {}
    print("\n--- Full-FT LLC ---", flush=True)
    fm = MLP()
    fm.load_state_dict(base_state)
    fm = train(fm, Xtr, Ytr, Xte, Yte, ep=20, lr=5e-4, label="FULL-FT")
    L0f = compute_loss(fm, Xtr, Ytr)
    rf = rwmh_llc(fm, Xtr, Ytr, temps, label="FULL-FT")
    all_res["full_ft"] = {"L0": L0f, "d": fm.nparams(), "llc": rf}
    for rank in [4, 8, 16, 32]:
        print(f"\n--- LoRA r={rank} LLC ---", flush=True)
        lb = MLP()
        lb.load_state_dict(base_state)
        lm = LoRAModel(lb, rank=rank)
        tp = lm.trainable_params()
        print(f"Trainable: {tp}", flush=True)
        lm = train(lm, Xtr, Ytr, Xte, Yte, ep=20, lr=5e-4, label=f"LORA-r{rank}")
        L0l = compute_loss(lm, Xtr, Ytr)
        rl = rwmh_llc(lm, Xtr, Ytr, temps, label=f"LORA-r{rank}")
        all_res[f"lora_r{rank}"] = {"L0": L0l, "d": tp, "llc": rl}
    print("\n=== SUMMARY ===", flush=True)
    for k, v in all_res.items():
        ml = np.median([r["LLC_med"] for r in v["llc"]])
        ma = np.median([r["acc"] for r in v["llc"]])
        print(f"{k:<15} d={v['d']:>8} L0={v['L0']:.6e} LLC={ml:.4f} acc={ma:.3f}", flush=True)
    with open("/tmp/Oma_folio/llc_results.json", "w") as f:
        json.dump(all_res, f, indent=2)
    print("=== DONE ===", flush=True)

if __name__ == "__main__":
    main()