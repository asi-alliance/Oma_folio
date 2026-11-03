import torch as t
import torch.nn as nn
import numpy as np
import json, sys
sys.path.insert(0, '/tmp/Oma_folio')
from lora_rlct_experiment import make_toy_dataset, ToyMLP, train_model

def compute_loss_grad(model, X, y):
    model.zero_grad()
    out = model(X)
    loss = nn.functional.mse_loss(out, y)
    loss.backward()
    return loss.item()

def get_flat(model):
    return t.cat([p.data.view(-1) for p in model.parameters()])

def set_flat(model, flat):
    idx = 0
    for p in model.parameters():
        n = p.numel()
        p.data.copy_(flat[idx:idx+n].view(p.shape))
        idx += n

def get_grad(model):
    return t.cat([p.grad.view(-1) for p in model.parameters() if p.grad is not None]).detach()

def mala_llc(model, X, y, temps, n_steps, burnin, epsilon_scale=100.0):
    n = X.shape[0]
    params = [p for p in model.parameters()]
    flat_size = sum(p.numel() for p in params)
    with t.no_grad():
        L0 = nn.functional.mse_loss(model(X), y).item()
    llc_vals = []
    for T in temps:
        ep = epsilon_scale * T / n
        sigma = (2 * ep * T / n) ** 0.5
        cur_flat = get_flat(model).clone()
        cur_loss = compute_loss_grad(model, X, y)
        cur_grad = get_grad(model).clone()
        losses = []
        n_accept = 0
        for step in range(n_steps):
            prop = cur_flat - (ep/2) * cur_grad + sigma * t.randn_like(cur_flat)
            set_flat(model, prop)
            prop_loss = compute_loss_grad(model, X, y)
            prop_grad = get_grad(model).clone()
            q_fwd = 0.5 * ((cur_flat - prop + (ep/2)*prop_grad)**2 / ep).sum().item()
            q_rev = 0.5 * ((prop - cur_flat + (ep/2)*cur_grad)**2 / ep).sum().item()
            log_alpha = -n*(prop_loss - cur_loss)/T + q_rev - q_fwd
            if np.log(np.random.rand()) < log_alpha:
                cur_flat = prop
                cur_loss = prop_loss
                cur_grad = prop_grad
                n_accept += 1
            else:
                set_flat(model, cur_flat)
            if step >= burnin:
                losses.append(cur_loss)
        excess = np.mean(losses) - L0
        llc = excess / T
        llc_vals.append(llc)
        print(f"  T={T:.4f} L0={L0:.6f} E[L]={np.mean(losses):.6f} excess={excess:.6f} LLC={llc:.4f} accept={n_accept/n_steps:.2f}")
    return llc_vals, L0

if __name__ == '__main__':
    t.manual_seed(42)
    np.random.seed(42)
    d_input, d_hidden = 4, 8
    n_train = 30
    (X, y), (X_test, y_test) = make_toy_dataset(n_train=n_train, n_test=60, d_input=d_input)
    model = ToyMLP(d_input, d_hidden)
    train_model(model, (X,y), n_epochs=500, lr=1e-3)
    L0_check = nn.functional.mse_loss(model(X), y).item()
    print(f"Trained L0={L0_check:.8f}")
    if L0_check > 0.01:
        print("WARNING: L0 not zero, LLC may be unreliable")
    temps = [0.01, 0.05]
    llc_vals, L0 = mala_llc(model, X, y, temps, n_steps=500, burnin=200)
    result = {"L0": L0, "temps": temps, "llc_vals": llc_vals, "llc_median": float(np.median(llc_vals))}
    with open('/tmp/Oma_folio/mala_results.json', 'w') as f:
        json.dump(result, f, indent=2)
    print(f"\nLLC median: {np.median(llc_vals):.4f}")
    print(json.dumps(result, indent=2))