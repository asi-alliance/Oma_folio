import sys
print("v13 START", flush=True)
import torch as t
import torch.nn as nn
import numpy as np
import json
import sys

n = 200
d_input = 10
d_hidden = 32
seeds = [42, 123, 456]
configs = [(32, 32), (64, 32), (128, 32)]

def run_seed(seed):
    t.manual_seed(seed)
    np.random.seed(seed)
    X = t.randn(n, d_input)
    teacher = nn.Sequential(nn.Linear(d_input, d_hidden), nn.ReLU(), nn.Linear(d_hidden, 1))
    with t.no_grad():
        y = teacher(X).squeeze()

    def make_base():
        base = nn.Sequential(nn.Linear(d_input, d_hidden), nn.ReLU(), nn.Linear(d_hidden, 1))
        with t.no_grad():
            base[0].weight.copy_(teacher[0].weight)
            base[0].bias.copy_(teacher[0].bias)
            base[2].weight.copy_(teacher[2].weight)
            base[2].bias.copy_(teacher[2].bias)
        for p in base.parameters():
            p.requires_grad = False
        return base

    def train_full(epochs=1000, lr=1e-2):
        m = nn.Sequential(nn.Linear(d_input, d_hidden), nn.ReLU(), nn.Linear(d_hidden, 1))
        opt = t.optim.Adam(m.parameters(), lr=lr)
        for ep in range(epochs):
            opt.zero_grad()
            loss = nn.functional.mse_loss(m(X).squeeze(), y)
            loss.backward()
            opt.step()
            if loss.item() < 1e-8: break
        L0 = nn.functional.mse_loss(m(X).squeeze(), y).item()
        return m, L0

    def train_lora(r1, r2, epochs=1000, lr=1e-2):
        base = make_base()
        A1 = nn.Parameter(t.randn(r1, d_input) * 0.01)
        B1 = nn.Parameter(t.zeros(d_hidden, r1))
        A2 = nn.Parameter(t.randn(r2, d_hidden) * 0.01)
        B2 = nn.Parameter(t.zeros(1, r2))
        params = [A1, B1, A2, B2]
        opt = t.optim.Adam(params, lr=lr)
        def fwd(X):
            dW1 = B1 @ A1
            h = t.relu(X @ (base[0].weight + dW1).t() + base[0].bias)
            dW2 = B2 @ A2
            out = h @ (base[2].weight + dW2).t() + base[2].bias
            return out.squeeze()
        for ep in range(epochs):
            opt.zero_grad()
            loss = nn.functional.mse_loss(fwd(X), y)
            loss.backward()
            opt.step()
            if loss.item() < 1e-8: break
        L0 = nn.functional.mse_loss(fwd(X), y).item()
        return params, L0, fwd

    def train_svd(r1, r2, epochs=1000, lr=1e-2):
        base = make_base()
        dW1 = nn.Parameter(t.zeros(d_hidden, d_input))
        dW2 = nn.Parameter(t.zeros(1, d_hidden))
        params = [dW1, dW2]
        opt = t.optim.Adam(params, lr=lr)
        def fwd_raw(X):
            W1 = base[0].weight + dW1
            h = t.relu(X @ W1.t() + base[0].bias)
            W2 = base[2].weight + dW2
            out = h @ W2.t() + base[2].bias
            return out.squeeze()
        for ep in range(epochs):
            opt.zero_grad()
            loss = nn.functional.mse_loss(fwd_raw(X), y)
            loss.backward()
            opt.step()
            if loss.item() < 1e-8: break
        with t.no_grad():
            U1, S1, Vh1 = t.linalg.svd(dW1.data, full_matrices=False)
            k1 = min(r1, S1.shape[0])
            dW1_proj = U1[:, :k1] @ t.diag(S1[:k1]) @ Vh1[:k1, :]
            U2, S2, Vh2 = t.linalg.svd(dW2.data, full_matrices=False)
            k2 = min(r2, S2.shape[0])
            dW2_proj = U2[:, :k2] @ t.diag(S2[:k2]) @ Vh2[:k2, :]
        proj_params = [nn.Parameter(dW1_proj), nn.Parameter(dW2_proj)]
        def fwd_proj(X):
            W1 = base[0].weight + proj_params[0]
            h = t.relu(X @ W1.t() + base[0].bias)
            W2 = base[2].weight + proj_params[1]
            out = h @ W2.t() + base[2].bias
            return out.squeeze()
        L0 = nn.functional.mse_loss(fwd_proj(X), y).item()
        return proj_params, L0, fwd_proj

    def rwmh(params, fwd_fn, L0, temps=[0.01, 0.02, 0.05], n_steps=1500, burnin=400, target_acc=0.234):
        def get_flat(): return t.cat([p.data.view(-1) for p in params])
        def set_flat(f):
            idx = 0
            for p in params:
                s = p.numel()
                p.data.copy_(f[idx:idx+s].view(p.shape))
                idx += s
        llc_vals = []
        for T in temps:
            d = sum(p.numel() for p in params)
            sigma = (2 * T / n) ** 0.5 / max(1, (d / 10) ** 0.5)
            cur = get_flat().clone()
            cl = fwd_fn(X).item()
            losses = []
            n_acc = 0
            recent = 0
            for step in range(n_steps):
                prop = cur + sigma * t.randn_like(cur)
                set_flat(prop)
                pl = fwd_fn(X).item()
                la = -n * (pl - cl) / T
                if np.log(np.random.rand()) < la:
                    cur = prop.clone()
                    cl = pl
                    n_acc += 1
                    recent += 1
                else:
                    set_flat(cur)
                if step < burnin and (step + 1) % 50 == 0:
                    rate = recent / 50
                    sigma *= np.exp((rate - target_acc) * 0.5)
                    sigma = max(sigma, 1e-8)
                    recent = 0
                if step >= burnin:
                    losses.append(cl)
            excess = np.mean(losses) - L0
            llc_vals.append(excess / T)
        return np.median(llc_vals)

    res = {}
    fm, fL0 = train_full()
    fp = list(fm.parameters())
    fd = sum(p.numel() for p in fp)
    fllc = rwmh(fp, lambda X: nn.functional.mse_loss(fm(X).squeeze(), y), fL0)
    res["full"] = {"llc": fllc, "d": fd}
    print(f"  Full FT LLC={fllc:.4f} d={fd}")
    for r1, r2 in configs:
        p, L0, fwd = train_lora(r1, r2)
        llc = rwmh(p, lambda X: nn.functional.mse_loss(fwd(X), y), L0)
        res[f"lora_{r1}_{r2}"] = {"llc": llc, "np": sum(x.numel() for x in p)}
        print(f"  LoRA({r1},{r2}) LLC={llc:.4f} ({llc/fllc*100:.0f}%)")
    for r1, r2 in configs:
        p, L0, fwd = train_svd(r1, r2)
        llc = rwmh(p, lambda X: nn.functional.mse_loss(fwd(X), y), L0)
        res[f"svd_{r1}_{r2}"] = {"llc": llc, "np": sum(x.numel() for x in p)}
        print(f"  SVD({r1},{r2}) LLC={llc:.4f} ({llc/fllc*100:.0f}%)")
    return res

all_res = {}
for s in seeds:
    print(f"\n=== Seed {s} ===")
    all_res[str(s)] = run_seed(s)

print("\n=== MEAN +/- STD ===")
fl = [all_res[str(s)]["full"]["llc"] for s in seeds]
fm, fs = np.mean(fl), np.std(fl)
print(f"Full FT: {fm:.4f} +/- {fs:.4f}")
for r1, r2 in configs:
    ll = [all_res[str(s)][f"lora_{r1}_{r2}"]["llc"] for s in seeds]
    sl = [all_res[str(s)][f"svd_{r1}_{r2}"]["llc"] for s in seeds]
    print(f"LoRA({r1},{r2}): {np.mean(ll):.4f} +/- {np.std(ll):.4f} ({np.mean(ll)/fm*100:.0f}%)")
    print(f"SVD ({r1},{r2}): {np.mean(sl):.4f} +/- {np.std(sl):.4f} ({np.mean(sl)/fm*100:.0f}%)")

with open("/tmp/Oma_folio/lora_rlct_v13_results.json", "w") as f:
    json.dump(all_res, f, indent=2, default=float)
print("\nSaved to v13_results.json")
