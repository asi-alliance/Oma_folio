import torch as t
import torch.nn as nn
import numpy as np
import json

t.manual_seed(42)
np.random.seed(42)

n = 200
d_input = 10
d_hidden = 32
X = t.randn(n, d_input)

teacher = nn.Sequential(nn.Linear(d_input, d_hidden), nn.ReLU(), nn.Linear(d_hidden, 1))
with t.no_grad():
    y = teacher(X).squeeze()

def train_full(epochs=5000, lr=1e-2):
    m = nn.Sequential(nn.Linear(d_input, d_hidden), nn.ReLU(), nn.Linear(d_hidden, 1))
    opt = t.optim.Adam(m.parameters(), lr=lr)
    for ep in range(epochs):
        opt.zero_grad()
        loss = nn.functional.mse_loss(m(X).squeeze(), y)
        loss.backward()
        opt.step()
        if loss.item() < 1e-10:
            break
    L0 = nn.functional.mse_loss(m(X).squeeze(), y).item()
    return m, L0

def train_lora_factored(rank_l1, rank_l2, epochs=5000, lr=1e-2):
    """Condition A: B·A factored LoRA"""
    base = nn.Sequential(nn.Linear(d_input, d_hidden), nn.ReLU(), nn.Linear(d_hidden, 1))
    with t.no_grad():
        base[0].weight.copy_(teacher[0].weight)
        base[0].bias.copy_(teacher[0].bias)
        base[2].weight.copy_(teacher[2].weight)
        base[2].bias.copy_(teacher[2].bias)
    for p in base.parameters():
        p.requires_grad = False
    A1 = nn.Parameter(t.randn(rank_l1, d_input) * 0.01)
    B1 = nn.Parameter(t.zeros(d_hidden, rank_l1))
    A2 = nn.Parameter(t.randn(rank_l2, d_hidden) * 0.01)
    B2 = nn.Parameter(t.zeros(1, rank_l2))
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
        if loss.item() < 1e-10:
            break
    L0 = nn.functional.mse_loss(fwd(X), y).item()
    return params, L0, fwd

def train_unfactored_svd(rank_l1, rank_l2, epochs=5000, lr=1e-2):
    """Condition B: Unfactored ΔW with SVD truncation to rank-r each step"""
    base = nn.Sequential(nn.Linear(d_input, d_hidden), nn.ReLU(), nn.Linear(d_hidden, 1))
    with t.no_grad():
        base[0].weight.copy_(teacher[0].weight)
        base[0].bias.copy_(teacher[0].bias)
        base[2].weight.copy_(teacher[2].weight)
        base[2].bias.copy_(teacher[2].bias)
    for p in base.parameters():
        p.requires_grad = False
    dW1 = nn.Parameter(t.zeros(d_hidden, d_input))
    dW2 = nn.Parameter(t.zeros(1, d_hidden))
    params = [dW1, dW2]
    opt = t.optim.Adam(params, lr=lr)
    def fwd(X):
        W1 = base[0].weight + dW1
        h = t.relu(X @ W1.t() + base[0].bias)
        W2 = base[2].weight + dW2
        out = h @ W2.t() + base[2].bias
        return out.squeeze()
    for ep in range(epochs):
        opt.zero_grad()
        loss = nn.functional.mse_loss(fwd(X), y)
        loss.backward()
        opt.step()
        with t.no_grad():
            U, S, Vh = t.linalg.svd(dW1.data, full_matrices=False)
            k = min(rank_l1, S.shape[0])
            dW1.data = (U[:, :k] @ t.diag(S[:k]) @ Vh[:k, :])
            U2, S2, Vh2 = t.linalg.svd(dW2.data, full_matrices=False)
            k2 = min(rank_l2, S2.shape[0])
            dW2.data = (U2[:, :k2] @ t.diag(S2[:k2]) @ Vh2[:k2, :])
        if loss.item() < 1e-10:
            break
    L0 = nn.functional.mse_loss(fwd(X), y).item()
    return params, L0, fwd

def rwmh_llc(params, forward_fn, L0, temps=[0.005,0.01,0.02,0.05], n_steps=2000, burnin=500, target_acc=0.234):
    def get_flat():
        return t.cat([p.data.view(-1) for p in params])
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
        cl = forward_fn(X).item()
        losses = []
        n_acc = 0
        recent_acc = 0
        for step in range(n_steps):
            prop = cur + sigma * t.randn_like(cur)
            set_flat(prop)
            pl = forward_fn(X).item()
            log_alpha = -n * (pl - cl) / T
            if np.log(np.random.rand()) < log_alpha:
                cur = prop.clone()
                cl = pl
                n_acc += 1
                recent_acc += 1
            else:
                set_flat(cur)
            if step < burnin and (step + 1) % 50 == 0:
                rate = recent_acc / 50
                sigma *= np.exp((rate - target_acc) * 0.5)
                sigma = max(sigma, 1e-8)
                recent_acc = 0
            if step >= burnin:
                losses.append(cl)
        excess = np.mean(losses) - L0
        llc = excess / T
        llc_vals.append(llc)
        print(f"  T={T:.4f} LLC={llc:.4f} acc={n_acc/n_steps:.2f} sigma={sigma:.6f}")
    return np.median(llc_vals)

print("=== Full Fine-Tuning ===")
full_model, full_L0 = train_full()
print(f"L0={full_L0:.10f}")
full_fwd = lambda X: nn.functional.mse_loss(full_model(X).squeeze(), y)
full_params = list(full_model.parameters())
full_llc = rwmh_llc(full_params, full_fwd, full_L0)
full_d = sum(p.numel() for p in full_params)
print(f"Full FT LLC: {full_llc:.4f}, d={full_d}")

results = {"full_llc": full_llc, "full_d": full_d, "experiments": []}

configs = [(4, 4), (8, 8), (16, 16), (16, 32), (32, 32)]

print("\n=== Condition A: Factored LoRA (B·A) ===")
for r1, r2 in configs:
    print(f"\n--- LoRA r1={r1}, r2={r2} ---")
    p, L0, fwd = train_lora_factored(r1, r2)
    n_params = sum(x.numel() for x in p)
    print(f"L0={L0:.10f}, params={n_params}")
    llc = rwmh_llc(p, lambda X: nn.functional.mse_loss(fwd(X), y), L0)
    print(f"Factored LoRA LLC: {llc:.4f}")
    results["experiments"].append({"type": "factored_lora", "r1": r1, "r2": r2, "llc": llc, "n_params": n_params})

print("\n=== Condition B: Unfactored SVD-Truncated ===")
for r1, r2 in configs:
    print(f"\n--- Unfactored r1={r1}, r2={r2} ---")
    p, L0, fwd = train_unfactored_svd(r1, r2)
    n_params = sum(x.numel() for x in p)
    print(f"L0={L0:.10f}, params={n_params}")
    llc = rwmh_llc(p, lambda X: nn.functional.mse_loss(fwd(X), y), L0)
    print(f"Unfactored SVD LLC: {llc:.4f}")
    results["experiments"].append({"type": "unfactored_svd", "r1": r1, "r2": r2, "llc": llc, "n_params": n_params})

print("\n=== SUMMARY ===")
print(f"Full FT: LLC={full_llc:.4f} d={full_d}")
for exp in results["experiments"]:
    pct = exp["llc"] / full_llc * 100
    print(f"  {exp['type']:16s} r=({exp['r1']},{exp['r2']}): LLC={exp['llc']:.4f} ({pct:.0f}% of FT) params={exp['n_params']}")

with open("/tmp/Oma_folio/lora_rlct_v9_results.json", "w") as f:
    json.dump(results, f, indent=2, default=float)
print(json.dumps(results, indent=2, default=float))
