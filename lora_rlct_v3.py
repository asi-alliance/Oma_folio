import torch as t
import torch.nn as nn
import numpy as np
import json

t.manual_seed(42)
np.random.seed(42)

# Teacher-student setup for guaranteed L0=0
n = 200
d_input = 10
d_hidden = 32
X = t.randn(n, d_input)

# Teacher: full network
teacher = nn.Sequential(nn.Linear(d_input, d_hidden), nn.ReLU(), nn.Linear(d_hidden, 1))
with t.no_grad():
    y = teacher(X)

def train_full(epochs=5000, lr=1e-2):
    m = nn.Sequential(nn.Linear(d_input, d_hidden), nn.ReLU(), nn.Linear(d_hidden, 1))
    opt = t.optim.Adam(m.parameters(), lr=lr)
    for ep in range(epochs):
        opt.zero_grad()
        loss = nn.functional.mse_loss(m(X), y)
        loss.backward()
        opt.step()
        if loss.item() < 1e-10:
            break
    L0 = nn.functional.mse_loss(m(X), y).item()
    return m, L0

def train_lora(rank, epochs=5000, lr=1e-2):
    # Freeze base, add LoRA adapters
    base = nn.Sequential(nn.Linear(d_input, d_hidden), nn.ReLU(), nn.Linear(d_hidden, 1))
    # Copy teacher weights as base (so LoRA only needs to learn residual)
    with t.no_grad():
        base[0].weight.copy_(teacher[0].weight)
        base[0].bias.copy_(teacher[0].bias)
        base[2].weight.copy_(teacher[2].weight)
        base[2].bias.copy_(teacher[2].bias)
    for p in base.parameters():
        p.requires_grad = False
    
    # LoRA on both layers
    lora_A1 = nn.Parameter(t.randn(d_hidden, d_input) * 0.01)
    lora_B1 = nn.Parameter(t.zeros(rank, d_hidden))
    lora_A2 = nn.Parameter(t.randn(1, d_hidden) * 0.01)
    lora_B2 = nn.Parameter(t.zeros(rank, 1))
    
    opt = t.optim.Adam([lora_A1, lora_B1, lora_A2, lora_B2], lr=lr)
    
    def forward():
        h = t.relu(X @ lora_A1.t() + X @ base[0].weight.t() + base[0].bias)
        # LoRA on layer 1: delta W = B1^T @ A1, shape (d_hidden, d_input) -> but rank constraint
        # Simpler: LoRA on layer 2 only (output layer)
        out = h @ base[2].weight.t() + base[2].bias
        return out
    
    for ep in range(epochs):
        opt.zero_grad()
        # LoRA: output = base_output + lora_B2 @ lora_A2 @ h
        h = t.relu(X @ base[0].weight.t() + base[0].bias)
        base_out = h @ base[2].weight.t() + base[2].bias
        lora_out = lora_A2 @ h.t()  # (1, n) via rank-r
        out = base_out + lora_out.squeeze()
        loss = nn.functional.mse_loss(out, y.squeeze())
        loss.backward()
        opt.step()
        if loss.item() < 1e-10:
            break
    
    h = t.relu(X @ base[0].weight.t() + base[0].bias)
    base_out = h @ base[2].weight.t() + base[2].bias
    lora_out = lora_A2 @ h.t()
    out = base_out + lora_out.squeeze()
    L0 = nn.functional.mse_loss(out, y.squeeze()).item()
    return base, lora_A2, L0, sum(p.numel() for p in [lora_A2, lora_B2])

def rwmh_llc(model_params, forward_fn, L0, temps=[0.005,0.01,0.02,0.05], n_steps=800, burnin=200):
    params = [p for p in model_params if p.requires_grad]
    flat_size = sum(p.numel() for p in params)
    
    def get_flat():
        return t.cat([p.data.view(-1) for p in params])
    
    def set_flat(f):
        idx = 0
        for p in params:
            s = p.numel()
            p.data.copy_(f[idx:idx+s].view(p.shape))
            idx += s
    
    def loss_fn():
        out = forward_fn()
        return nn.functional.mse_loss(out, y.squeeze())
    
    llc_vals = []
    for T in temps:
        sigma = (2 * T / n) ** 0.5
        cur = get_flat().clone()
        losses = []
        n_acc = 0
        for step in range(n_steps):
            prop = cur + sigma * t.randn_like(cur)
            set_flat(prop)
            pl = loss_fn().item()
            set_flat(cur)
            cl = loss_fn().item()
            log_alpha = -n * (pl - cl) / T
            if np.log(np.random.rand()) < log_alpha:
                cur = prop
                set_flat(cur)
                n_acc += 1
            if step >= burnin:
                losses.append(cl)
        excess = np.mean(losses) - L0
        llc = excess / T
        llc_vals.append(llc)
        print(f"  T={T:.4f} LLC={llc:.4f} acc={n_acc/n_steps:.2f}")
    return np.median(llc_vals)

# Test 1: Full fine-tuning (baseline)
print("=== Full Fine-Tuning ===")
full_model, full_L0 = train_full()
print(f"L0={full_L0:.10f}")
full_params = list(full_model.parameters())
full_forward = lambda: full_model(X).squeeze()
full_llc = rwmh_llc(full_params, full_forward, full_L0)
print(f"Full FT LLC: {full_llc:.4f}, d={sum(p.numel() for p in full_params)}")

# Test 2: LoRA rank sweep
for rank in [1, 2, 4, 8]:
    print(f"\n=== LoRA rank={rank} ===")
    base, lora_A, lora_L0, n_lora = train_lora(rank)
    print(f"L0={lora_L0:.10f}, LoRA params={n_lora}")
    # RWMH on LoRA params only
    lora_forward = lambda: (base(X) + lora_A @ t.relu(X @ base[0].weight.t() + base[0].bias).t()).squeeze()
    lora_llc = rwmh_llc([lora_A,], lora_forward, lora_L0)
    print(f"LoRA r={rank} LLC: {lora_llc:.4f}")

print("\n=== SUMMARY ===")
print(f"Full FT: LLC={full_llc:.4f}")
result = {"full_llc": full_llc, "full_d": sum(p.numel() for p in full_params)}
with open("/tmp/Oma_folio/lora_rlct_v3_results.json", "w") as f:
    json.dump(result, f, indent=2)