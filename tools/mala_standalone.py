import torch as t
import torch.nn as nn
import numpy as np
import json

t.manual_seed(42)
np.random.seed(42)

# Teacher-student ReLU 2-2-1 (6 params) - guaranteed L0=0
n = 200
X = t.randn(n, 2)

# Teacher network
teacher = nn.Sequential(nn.Linear(2,2), nn.ReLU(), nn.Linear(2,1))
with t.no_grad():
    y = teacher(X)

# Student: same architecture, will be trained to match teacher exactly
student = nn.Sequential(nn.Linear(2,2), nn.ReLU(), nn.Linear(2,1))

# Train to L0=0 with Adam
opt = t.optim.Adam(student.parameters(), lr=1e-2)
for epoch in range(10000):
    opt.zero_grad()
    loss = nn.functional.mse_loss(student(X), y)
    loss.backward()
    opt.step()
    if loss.item() < 1e-12:
        break

L0 = nn.functional.mse_loss(student(X), y).item()
print(f"L0={L0:.10f} after {epoch+1} epochs")

# MALA LLC estimation
params = list(student.parameters())
flat_size = sum(p.numel() for p in params)

def get_flat():
    return t.cat([p.data.view(-1) for p in params])

def set_flat(f):
    idx = 0
    for p in params:
        s = p.numel()
        p.data.copy_(f[idx:idx+s].view(p.shape))
        idx += s

def loss_and_grad():
    student.zero_grad()
    loss = nn.functional.mse_loss(student(X), y)
    loss.backward()
    g = t.cat([p.grad.view(-1) for p in params]).detach()
    return loss.item(), g

def mala_llc(temps, n_steps=3000, burnin=1000, c=100.0):
    llc_vals = []
    for T in temps:
        ep = c * T / n
        sigma = (2 * ep * T / n) ** 0.5
        cur = get_flat().clone()
        cl, cg = loss_and_grad()
        losses = []
        n_acc = 0
        for step in range(n_steps):
            prop = cur - (ep/2)*cg + sigma * t.randn_like(cur)
            set_flat(prop)
            pl, pg = loss_and_grad()
            q_fwd = 0.5 * ((cur - prop + (ep/2)*pg)**2 / ep).sum().item()
            q_rev = 0.5 * ((prop - cur + (ep/2)*cg)**2 / ep).sum().item()
            log_alpha = -n*(pl - cl)/T + q_rev - q_fwd
            if np.log(np.random.rand()) < log_alpha:
                cur, cl, cg = prop, pl, pg
                n_acc += 1
            else:
                set_flat(cur)
            if step >= burnin:
                losses.append(cl)
        excess = np.mean(losses) - L0
        llc = excess / T
        llc_vals.append(llc)
        print(f"  T={T:.4f} E[L]={np.mean(losses):.6f} excess={excess:.6f} LLC={llc:.4f} accept={n_acc/n_steps:.2f}")
    return llc_vals

temps = [0.001, 0.002, 0.005, 0.01, 0.02, 0.05]
llc_vals = mala_llc(temps)
print(f"\nMALA LLC median: {np.median(llc_vals):.4f}")
print(f"RWMH v8 reference: ~2.0")
result = {"L0": L0, "temps": temps, "llc_vals": llc_vals, "llc_median": float(np.median(llc_vals))}
with open("/tmp/Oma_folio/mala_standalone_results.json", "w") as f:
    json.dump(result, f, indent=2)
print(json.dumps(result, indent=2))