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

def train_lora_two_layer(rank_l1, rank_l2, epochs=5000, lr=1e-2):
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
    def lora_forward(X):
        l1_delta = B1 @ A1
        h = t.relu(X @ (base[0].weight + l1_delta).t() + base[0].bias)
        l2_delta = B2 @ A2
        out = h @ (base[2].weight + l2_delta).t() + base[2].bias
        return out.squeeze()
    for ep in range(epochs):
        opt.zero_grad()
        out = lora_forward(X)
        loss = nn.functional.mse_loss(out, y)
        loss.backward()
        opt.step()
        if loss.item() < 1e-10:
            break
    L0 = nn.functional.mse_loss(lora_forward(X), y).item()
    return params, L0, lora_forward

def rwmh_llc_adaptive(params, forward_fn, L0, temps=[0.005,0.01,0.02,0.05], n_steps=2000, burnin=500, target_acc=0.234):
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
        cl = forward_fn().item()
        losses = []
        n_acc = 0
        recent_acc = 0
        for step in range(n_steps):
            prop = cur + sigma * t.randn_like(cur)
            set_flat(prop)
            pl = forward_fn().item()
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
full_fwd = lambda: nn.functional.mse_loss(full_model(X).squeeze(), y)
full_llc = rwmh_llc_adaptive(list(full_model.parameters()), full_fwd, full_L0)
full_d = sum(p.numel() for p in full_model.parameters())
print(f"Full FT LLC: {full_llc:.4f}, d={full_d}")

results = {"full_llc": full_llc, "full_d": full_d, "two_layer": []}

configs = [
    (4, 4), (8, 8), (10, 16), (10, 32), (16, 16), (16, 32), (32, 32)
]
print("\n=== Two-Layer LoRA with varying ranks ===")
for r1, r2 in configs:
    is_full_rank = (r1 >= d_input and r2 >= d_hidden)
    label = "FULL-RANK" if is_full_rank else f"r1={r1},r2={r2}"
    print(f"\n--- {label} ---")
    lora_params, lora_L0, lora_fwd_fn = train_lora_two_layer(r1, r2)
    n_lora = sum(p.numel() for p in lora_params)
    print(f"L0={lora_L0:.10f}, params={n_lora}")
    lora_fwd = lambda: nn.functional.mse_loss(lora_fwd_fn(X), y)
    lora_llc = rwmh_llc_adaptive(lora_params, lora_fwd, lora_L0)
    print(f"Two-layer {label} LLC: {lora_llc:.4f}")
    results["two_layer"].append({"r1": r1, "r2": r2, "llc": lora_llc, "n_params": n_lora, "full_rank": is_full_rank})

print("\n=== SUMMARY ===")
print(f"Full FT: LLC={full_llc:.4f} d={full_d}")
for r in results["two_layer"]:
    label = "FULL-RANK" if r["full_rank"] else f"r1={r['r1']},r2={r['r2']}"
    print(f"  {label}: LLC={r['llc']:.4f} params={r['n_params']} ({r['llc']/full_llc*100:.0f}% of FT)")

with open("/tmp/Oma_folio/lora_rlct_v8_results.json", "w") as f:
    json.dump(results, f, indent=2, default=float)
print(json.dumps(results, indent=2, default=float))
