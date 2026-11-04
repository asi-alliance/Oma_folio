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

def train_lora(rank, epochs=5000, lr=1e-2):
    base = nn.Sequential(nn.Linear(d_input, d_hidden), nn.ReLU(), nn.Linear(d_hidden, 1))
    with t.no_grad():
        base[0].weight.copy_(teacher[0].weight)
        base[0].bias.copy_(teacher[0].bias)
        base[2].weight.copy_(teacher[2].weight)
        base[2].bias.copy_(teacher[2].bias)
    for p in base.parameters():
        p.requires_grad = False
    # Proper rank-r LoRA on output layer: dW = B @ A, B:(1,r), A:(r,d_hidden)
    A = nn.Parameter(t.randn(rank, d_hidden) * 0.01)
    B = nn.Parameter(t.zeros(1, rank))
    opt = t.optim.Adam([A, B], lr=lr)
    for ep in range(epochs):
        opt.zero_grad()
        h = t.relu(X @ base[0].weight.t() + base[0].bias)
        out = h @ base[2].weight.t() + base[2].bias + (B @ A @ h.t()).t()
        loss = nn.functional.mse_loss(out, y)
        loss.backward()
        opt.step()
        if loss.item() < 1e-10:
            break
    h = t.relu(X @ base[0].weight.t() + base[0].bias)
    out = h @ base[2].weight.t() + base[2].bias + (B @ A @ h.t()).t()
    L0 = nn.functional.mse_loss(out, y).item()
    return base, [A, B], L0

def rwmh_llc(params, forward_fn, L0, temps=[0.005,0.01,0.02,0.05], n_steps=800, burnin=200):
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
        sigma = (2 * T / n) ** 0.5
        cur = get_flat().clone()
        cl = forward_fn().item()
        losses = []
        n_acc = 0
        for step in range(n_steps):
            prop = cur + sigma * t.randn_like(cur)
            set_flat(prop)
            pl = forward_fn().item()
            log_alpha = -n * (pl - cl) / T
            if np.log(np.random.rand()) < log_alpha:
                cur = prop.clone()
                cl = pl
                n_acc += 1
            else:
                set_flat(cur)
            if step >= burnin:
                losses.append(cl)
        excess = np.mean(losses) - L0
        llc = excess / T
        llc_vals.append(llc)
        print(f"  T={T:.4f} LLC={llc:.4f} acc={n_acc/n_steps:.2f}")
    return np.median(llc_vals)

print("=== Full Fine-Tuning ===")
full_model, full_L0 = train_full()
print(f"L0={full_L0:.10f}")
full_fwd = lambda: nn.functional.mse_loss(full_model(X).squeeze(), y)
full_llc = rwmh_llc(list(full_model.parameters()), full_fwd, full_L0)
print(f"Full FT LLC: {full_llc:.4f}, d={sum(p.numel() for p in full_model.parameters())}")

results = {"full_llc": full_llc, "full_d": sum(p.numel() for p in full_model.parameters()), "lora": []}

for rank in [1, 2, 4, 8, 16]:
    print(f"\n=== LoRA rank={rank} ===")
    base, lora_params, lora_L0 = train_lora(rank)
    n_lora = sum(p.numel() for p in lora_params)
    print(f"L0={lora_L0:.10f}, LoRA params={n_lora}")
    h_fn = lambda: t.relu(X @ base[0].weight.t() + base[0].bias)
    lora_fwd = lambda: nn.functional.mse_loss(
        h_fn() @ base[2].weight.t() + base[2].bias + (lora_params[1] @ lora_params[0] @ h_fn().t()).t(), y)
    lora_llc = rwmh_llc(lora_params, lora_fwd, lora_L0)
    print(f"LoRA r={rank} LLC: {lora_llc:.4f}")
    results["lora"].append({"rank": rank, "llc": lora_llc, "n_params": n_lora, "L0": lora_L0})

print("\n=== SUMMARY ===")
print(f"Full FT: LLC={full_llc:.4f}")
for r in results["lora"]:
    print(f"LoRA r={r['rank']}: LLC={r['llc']:.4f} params={r['n_params']}")
with open("/tmp/Oma_folio/lora_rlct_v3_results.json", "w") as f:
    json.dump(results, f, indent=2)
print(json.dumps(results, indent=2))