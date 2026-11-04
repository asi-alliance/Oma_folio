import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
import json

torch.manual_seed(42)
np.random.seed(42)

D_IN, H, D_OUT = 10, 32, 1

class MLP(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc1 = nn.Linear(D_IN, H)
        self.fc2 = nn.Linear(H, D_OUT)
        self.act = nn.ReLU()
    def forward(self, x):
        return self.fc2(self.act(self.fc1(x)))
    def nparams(self):
        return sum(p.numel() for p in self.parameters())

class LoRALinear(nn.Module):
    def __init__(self, linear, rank):
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
    def __init__(self, base, rank):
        super().__init__()
        self.base = base
        self.fc1_lora = LoRALinear(base.fc1, rank)
        self.fc2_lora = LoRALinear(base.fc2, rank)
    def forward(self, x):
        x = self.fc1_lora(x)
        x = self.base.act(x)
        return self.fc2_lora(x)
    def trainable_params(self):
        return sum(p.numel() for p in self.parameters() if p.requires_grad)

def gen_data(ntr=200, nte=100):
    rng = np.random.RandomState(42)
    W = rng.randn(D_IN, D_OUT) * 0.5
    Xtr = rng.randn(ntr, D_IN).astype(np.float32)
    Ytr = (Xtr @ W + 0.3 * np.sin(Xtr[:, :3]).sum(1, keepdims=True)).astype(np.float32)
    Xte = rng.randn(nte, D_IN).astype(np.float32)
    Yte = (Xte @ W + 0.3 * np.sin(Xte[:, :3]).sum(1, keepdims=True)).astype(np.float32)
    return torch.tensor(Xtr), torch.tensor(Ytr), torch.tensor(Xte), torch.tensor(Yte)

def train_model(model, X, Y, epochs=2000, lr=1e-3, label="FULL"):
    params = [p for p in model.parameters() if p.requires_grad]
    opt = optim.Adam(params, lr=lr)
    lf = nn.MSELoss()
    for ep in range(epochs):
        model.train()
        opt.zero_grad()
        loss = lf(model(X), Y)
        loss.backward()
        opt.step()
        if (ep+1) % 500 == 0 or ep == 0:
            print(f"  [{label}] ep {ep+1}/{epochs} loss={loss.item():.8f}", flush=True)
    return model

def compute_loss(model, X, Y):
    model.eval()
    lf = nn.MSELoss(reduction="sum")
    with torch.no_grad():
        return lf(model(X), Y).item() / len(X)

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

def rwmh_llc(model, X, Y, temps, n_steps=5000, burnin=2000, label="LLC"):
    ps, theta0 = get_flat(model)
    d = len(theta0)
    n = len(X)
    L0 = compute_loss(model, X, Y)
    print(f"  [{label}] d={d} n={n} L0={L0:.10f}", flush=True)
    rng = np.random.RandomState(77)
    results = []
    for T in temps:
        sigma = max((2.0*T/n)**0.5, 1e-4)
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
                if rate < 0.15:
                    sigma *= 0.8
                elif rate > 0.35:
                    sigma *= 1.2
                acc_win = 0
            if step >= burnin:
                losses.append(cur_loss - L_min)
        llc = [l/T for l in losses]
        acc = n_acc / n_steps
        llc_med = float(np.median(llc))
        print(f"  [{label}] T={T:.4f} LLC_med={llc_med:.4f} acc={acc:.3f} sigma={sigma:.6f} L_min={L_min:.10f}", flush=True)
        results.append({"T": T, "LLC_med": llc_med, "acc": acc})
    set_flat(model, theta0)
    return results

def main():
    print("=== LLC: LoRA vs Full-FT (10-32-1, adaptive RWMH v2) ===", flush=True)
    Xtr, Ytr, Xte, Yte = gen_data(200, 100)
    print(f"Data: {Xtr.shape} {Ytr.shape}", flush=True)
    print("--- Pretrain base ---", flush=True)
    base = MLP()
    print(f"Params: {base.nparams()}", flush=True)
    base = train_model(base, Xtr, Ytr, epochs=2000, label="PRE")
    base_state = {k: v.clone() for k, v in base.state_dict().items()}
    temps = [0.001, 0.002, 0.005, 0.01, 0.02]
    all_res = {}
    print("\n--- Full-FT LLC ---", flush=True)
    fm = MLP()
    fm.load_state_dict(base_state)
    fm = train_model(fm, Xtr, Ytr, epochs=2000, lr=5e-4, label="FULL-FT")
    L0f = compute_loss(fm, Xtr, Ytr)
    rf = rwmh_llc(fm, Xtr, Ytr, temps, label="FULL-FT")
    all_res["full_ft"] = {"L0": L0f, "d": fm.nparams(), "llc": rf}
    for rank in [1, 2, 4, 8, 16, 32]:
        print(f"\n--- LoRA r={rank} LLC ---", flush=True)
        lb = MLP()
        lb.load_state_dict(base_state)
        lm = LoRAModel(lb, rank=rank)
        tp = lm.trainable_params()
        print(f"Trainable: {tp}", flush=True)
        lm = train_model(lm, Xtr, Ytr, epochs=2000, lr=5e-4, label=f"LORA-r{rank}")
        L0l = compute_loss(lm, Xtr, Ytr)
        rl = rwmh_llc(lm, Xtr, Ytr, temps, label=f"LORA-r{rank}")
        all_res[f"lora_r{rank}"] = {"L0": L0l, "d": tp, "llc": rl}
    print("\n=== SUMMARY ===", flush=True)
    for k, v in all_res.items():
        ml = np.median([r["LLC_med"] for r in v["llc"]])
        ma = np.median([r["acc"] for r in v["llc"]])
        print(f"{k:<15} d={v['d']:>6} L0={v['L0']:.6e} LLC_med={ml:.4f} acc={ma:.3f}", flush=True)
    with open("/tmp/Oma_folio/llc_lora_small.json", "w") as f:
        json.dump(all_res, f, indent=2)
    print("=== DONE ===", flush=True)

if __name__ == "__main__":
    main()
