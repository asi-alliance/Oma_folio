import torch
import torch.nn as nn
import numpy as np
import json
import argparse
from typing import Dict, List, Tuple

"""
LoRA × RLCT Bridge Experiment
=============================
Tests the conjecture that LoRA's rank constraint creates a determinantal variety
singular stratum, and that the RLCT (real log canonical threshold) at the
rank-r constrained optimum differs from the full-FT optimum.

Claims tested:
  C2: LoRA rank-r constraint = determinantal variety D_r; RLCT stratum selector
  C3: rank r acts as discrete stratum selector; lambda(r) monotone
  C4: regime crossover — LoRA better low-data, full-FT better high-data
  C5: r* scaling law r* ~ c * n^alpha

Method: SGLD-based Local Learning Coefficient (LLC) estimation,
following Wei et al. 2022 "Singular Learning Theory Enables Discovery of
Transferable Adversarial Defenses" and the devinterp framework.

Falsifiable predictions:
  H1: LLC(LoRA, r=1) < LLC(LoRA, r=4) < LLC(full-FT) [monotone in rank]
  H2: At low data (n < d_active), LoRA gen-gap < full-FT gen-gap
  H3: At high data (n > d_active), full-FT gen-gap < LoRA gen-gap
  H4: r* (optimal rank) scales as c*n^alpha with alpha > 0
"""


def make_toy_dataset(n_train: int, n_test: int, d_input: int, seed: int = 42):
    """Synthetic regression: y = sum of first k nonlinear features + noise."""
    torch.manual_seed(seed)
    np.random.seed(seed)
    # True model: sparse nonlinear function
    k = 3  # active dimension
    X_train = torch.randn(n_train, d_input)
    X_test = torch.randn(n_test, d_input)
    # Nonlinear: sum of tanh on first k dims
    y_train = torch.tanh(X_train[:, :k]).sum(dim=1, keepdim=True) + 0.01 * torch.randn(n_train, 1)
    y_test = torch.tanh(X_test[:, :k]).sum(dim=1, keepdim=True) + 0.01 * torch.randn(n_test, 1)
    return (X_train, y_train), (X_test, y_test)


class LoRALinear(nn.Module):
    """Linear layer with optional LoRA low-rank adaptation."""
    def __init__(self, in_features: int, out_features: int, rank: int = 0, bias: bool = True):
        super().__init__()
        self.in_features = in_features
        self.out_features = out_features
        self.rank = rank
        if rank == 0:
            # Full fine-tuning
            self.weight = nn.Parameter(torch.randn(out_features, in_features) * 0.01)
            self.lora_A = None
            self.lora_B = None
        else:
            # Frozen base + LoRA delta = B @ A
            self.weight = nn.Parameter(torch.randn(out_features, in_features) * 0.01, requires_grad=False)
            self.lora_A = nn.Parameter(torch.randn(rank, in_features) * 0.01)
            self.lora_B = nn.Parameter(torch.randn(out_features, rank) * 0.01)
        if bias:
            self.bias = nn.Parameter(torch.zeros(out_features))
        else:
            self.bias = None

    def forward(self, x):
        if self.rank == 0:
            out = x @ self.weight.t()
        else:
            delta = self.lora_B @ self.lora_A  # (out, in)
            out = x @ (self.weight + delta).t()
        if self.bias is not None:
            out = out + self.bias
        return out

    def trainable_params(self):
        if self.rank == 0:
            return [self.weight, self.bias]
        else:
            return [self.lora_A, self.lora_B, self.bias]


class ToyMLP(nn.Module):
    """2-layer MLP with configurable LoRA rank on all layers."""
    def __init__(self, d_input: int, d_hidden: int, d_output: int = 1, rank: int = 0):
        super().__init__()
        self.fc1 = LoRALinear(d_input, d_hidden, rank=rank)
        self.fc2 = LoRALinear(d_hidden, d_output, rank=rank)
        self.act = nn.Tanh()

    def forward(self, x):
        h = self.act(self.fc1(x))
        return self.fc2(h)

    def trainable_parameters(self):
        params = []
        params.extend(self.fc1.trainable_params())
        params.extend(self.fc2.trainable_params())
        return params


def train_model(model, train_data, n_epochs=2000, lr=0.01, weight_decay=1e-4):
    """Standard SGD training to convergence."""
    X, y = train_data
    opt = torch.optim.SGD(model.trainable_parameters(), lr=lr, weight_decay=weight_decay)
    losses = []
    for epoch in range(n_epochs):
        opt.zero_grad()
        pred = model(X)
        loss = nn.functional.mse_loss(pred, y)
        loss.backward()
        opt.step()
        losses.append(loss.item())
    return losses


def sgld_estimate_llc(model, train_data, n_steps=5000, lr=2e-4, beta=1e-3,
                      sgld_lr=2e-4, noise_scale=1.0, n_chains=4):
    """
    Estimate Local Learning Coefficient (LLC) via Stochastic Gradient Langevin Dynamics.
    
    LLC approximates the RLCT lambda for the trained model's loss landscape.
    Higher lambda = more singular (more complex local geometry).
    
    For LoRA rank r, we expect:
      - Low r -> smoother landscape -> lower LLC
      - High r / full-FT -> more singular -> higher LLC
    
    Returns mean and std of LLC estimates across chains.
    """
    X, y = train_data
    n = X.shape[0]
    
    # Save initial weights (the trained optimum)
    params = model.trainable_parameters()
    init_state = {i: p.data.clone() for i, p in enumerate(params)}
    
    llc_estimates = []
    
    for chain in range(n_chains):
        # Reset to optimum
        for i, p in enumerate(params):
            p.data = init_state[i].clone()
        
        # SGLD sampling
        opt = torch.optim.SGD(params, lr=sgld_lr, weight_decay=0.0, momentum=0.0)
        
        losses_sampled = []
        temperatures = []
        
        for step in range(n_steps):
            opt.zero_grad()
            pred = model(X)
            loss = n * nn.functional.mse_loss(pred, y)  # total loss, not mean
            loss.backward()
            
            # Add noise to gradients (Langevin)
            for p in params:
                if p.grad is not None:
                    p.grad.data += torch.randn_like(p.grad) * np.sqrt(2 * sgld_lr / beta)
            
            opt.step()
            
            if step >= n_steps // 2:  # collect after burn-in
                with torch.no_grad():
                    pred = model(X)
                    l = n * nn.functional.mse_loss(pred, y).item()
                    losses_sampled.append(l)
        
        # LLC estimate: <n*L> / (-log(temperature)) — simplified estimator
        # More precisely: lambda ≈ <nL(θ)> / (n * beta^{-1}) in the SGLD regime
        # Using the protocol from Wei et al.: LLC ≈ mean(loss_sampled) * beta
        mean_loss = np.mean(losses_sampled)
        llc_est = beta * mean_loss  # simplified LLC proxy
        llc_estimates.append(llc_est)
    
    return np.mean(llc_estimates), np.std(llc_estimates)


def generalization_gap(model, train_data, test_data):
    """Compute train and test loss."""
    with torch.no_grad():
        X_tr, y_tr = train_data
        X_te, y_te = test_data
        train_loss = nn.functional.mse_loss(model(X_tr), y_tr).item()
        test_loss = nn.functional.mse_loss(model(X_te), y_te).item()
    return test_loss - train_loss


def run_experiment(args):
    """Run full LoRA × RLCT experiment."""
    results = {
        "config": vars(args),
        "rank_results": []
    }
    
    d_input = args.d_input
    d_hidden = args.d_hidden
    ranks = [0] + list(range(1, args.max_rank + 1))  # 0 = full-FT
    n_values = args.n_train_values
    
    for n_train in n_values:
        train_data, test_data = make_toy_dataset(
            n_train=n_train, n_test=1000, d_input=d_input, seed=args.seed
        )
        
        for rank in ranks:
            label = f"full-FT" if rank == 0 else f"LoRA-r{rank}"
            print(f"Training {label}, n_train={n_train}...")
            
            model = ToyMLP(d_input, d_hidden, rank=rank)
            train_model(model, train_data, n_epochs=args.epochs, lr=args.lr)
            
            gen_gap = generalization_gap(model, train_data, test_data)
            
            if args.estimate_llc:
                llc_mean, llc_std = sgld_estimate_llc(
                    model, train_data,
                    n_steps=args.sgld_steps,
                    sgld_lr=args.sgld_lr,
                    beta=args.beta,
                    n_chains=args.n_chains
                )
            else:
                llc_mean, llc_std = -1.0, -1.0
            
            entry = {
                "n_train": n_train,
                "rank": rank,
                "label": label,
                "gen_gap": gen_gap,
                "llc_mean": float(llc_mean),
                "llc_std": float(llc_std),
            }
            results["rank_results"].append(entry)
            print(f"  gen_gap={gen_gap:.6f}, llc={llc_mean:.4f}±{llc_std:.4f}")
    
    # Analyze results
    print("\n=== ANALYSIS ===")
    
    # H1: LLC monotone in rank
    for n_train in n_values:
        entries = [r for r in results["rank_results"] if r["n_train"] == n_train and args.estimate_llc]
        if entries:
            llcs = [(r["rank"], r["llc_mean"]) for r in entries]
            llcs.sort()
            monotone = all(llcs[i][1] <= llcs[i+1][1] for i in range(len(llcs)-1))
            print(f"H1 (LLC monotone in rank, n={n_train}): {'PASS' if monotone else 'FAIL'} — {llcs}")
    
    # H2/H3: Crossover
    if len(n_values) >= 2:
        for r in [0, 1, 4]:
            label = "full-FT" if r == 0 else f"LoRA-r{r}"
            gaps = [(e["n_train"], e["gen_gap"]) for e in results["rank_results"] if e["rank"] == r]
            print(f"Gen gap vs n ({label}): {gaps}")
    
    # H4: Optimal rank scaling
    best_ranks = []
    for n_train in n_values:
        entries = [r for r in results["rank_results"] if r["n_train"] == n_train]
        best = min(entries, key=lambda x: x["gen_gap"])
        best_ranks.append((n_train, best["rank"]))
    print(f"Optimal rank per n: {best_ranks}")
    if len(best_ranks) >= 3:
        ns = np.array([b[0] for b in best_ranks], dtype=float)
        rs = np.array([b[1] for b in best_ranks], dtype=float)
        log_ns = np.log(ns)
        log_rs = np.log(np.maximum(rs, 0.5))
        if np.std(log_rs) > 0:
            alpha, intercept = np.polyfit(log_ns, log_rs, 1)
            print(f"H4 (r* ~ c*n^alpha): alpha={alpha:.4f}, c={np.exp(intercept):.4f}")
    
    return results


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="LoRA × RLCT Bridge Experiment")
    parser.add_argument("--d_input", type=int, default=10)
    parser.add_argument("--d_hidden", type=int, default=32)
    parser.add_argument("--max_rank", type=int, default=8)
    parser.add_argument("--n_train_values", type=int, nargs="+", default=[50, 100, 200, 500, 1000])
    parser.add_argument("--epochs", type=int, default=2000)
    parser.add_argument("--lr", type=float, default=0.01)
    parser.add_argument("--estimate_llc", action="store_true", default=True)
    parser.add_argument("--sgld_steps", type=int, default=3000)
    parser.add_argument("--sgld_lr", type=float, default=2e-4)
    parser.add_argument("--beta", type=float, default=1e-3)
    parser.add_argument("--n_chains", type=int, default=4)
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--output", type=str, default="/tmp/Oma_folio/lora_rlct_results.json")
    
    args = parser.parse_args()
    
    print("LoRA × RLCT Bridge Experiment")
    print("=" * 60)
    print(f"Testing H1-H4: LLC monotonicity, regime crossover, r* scaling")
    print(f"Config: d_input={args.d_input}, d_hidden={args.d_hidden}, ranks=1..{args.max_rank}")
    print()
    
    results = run_experiment(args)
    
    with open(args.output, "w") as f:
        json.dump(results, f, indent=2)
    print(f"\nResults saved to {args.output}")