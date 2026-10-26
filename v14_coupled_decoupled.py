import numpy as np
from numpy.random import default_rng
from scipy.optimize import minimize

# === Model: ReLU 8-4-1 (same as adaptive_rwmh_v2) ===
d_in = 8; d_h = 4; d_o = 1
d = d_h*d_in + d_h + d_o*d_h + d_o  # 41 params

def unpack(th):
    W1 = th[:d_h*d_in].reshape(d_h, d_in)
    b1 = th[d_h*d_in:d_h*(d_in+1)]
    W2 = th[d_h*(d_in+1):d_h*(d_in+1)+d_o*d_h].reshape(d_o, d_h)
    b2 = th[-d_o:]
    return W1, b1, W2, b2

def gen_teacher():
    r = default_rng(123)
    W1 = r.normal(0,1,(d_h,d_in)); b1 = r.normal(0,.1,d_h)
    W2 = r.normal(0,1,(d_o,d_h)); b2 = r.normal(0,.1,d_o)
    return W1, b1, W2, b2

def gen_data(t, n):
    r = default_rng(999)
    W1,b1,W2,b2 = t
    X = r.normal(0,1,(n,d_in))
    h = np.maximum(X@W1.T+b1,0); y = h@W2.T+b2
    y = y / np.std(y)
    return X, y

def loss_fn(th, X, Y):
    W1, b1, W2, b2 = unpack(th)
    h = np.maximum(X@W1.T+b1, 0)
    pred = h@W2.T+b2
    return float(((pred-Y)**2).mean())

def loss_grad(th, X, Y):
    M = len(X)
    W1, b1, W2, b2 = unpack(th)
    h = np.maximum(X@W1.T+b1, 0)
    err = (h@W2.T+b2) - Y
    gW2 = (err.T@h)/M; gb2 = err.mean(0)
    dh = (err@W2)*(h>0)
    gW1 = (dh.T@X)/M; gb1 = dh.mean(0)
    grad = np.zeros(d)
    grad[:d_h*d_in] = gW1.ravel()
    grad[d_h*d_in:d_h*(d_in+1)] = gb1
    grad[d_h*(d_in+1):d_h*(d_in+1)+d_o*d_h] = gW2.ravel()
    grad[-d_o:] = gb2
    return grad

def vloss_batch(th_batch, X, Y):
    B = th_batch.shape[0]
    W1, b1, W2, b2 = [th_batch[:, idx].reshape(B, *shp) for idx, shp in [
        (slice(0, d_h*d_in), (d_h, d_in)),
        (slice(d_h*d_in, d_h*(d_in+1)), (d_h,)),
        (slice(d_h*(d_in+1), d_h*(d_in+1)+d_o*d_h), (d_o, d_h)),
        (slice(-d_o, None), (d_o,))
    ]]
    # This unpack doesn't work cleanly for batches; do it manually
    W1 = th_batch[:, :d_h*d_in].reshape(B, d_h, d_in)
    b1 = th_batch[:, d_h*d_in:d_h*(d_in+1)]
    W2 = th_batch[:, d_h*(d_in+1):d_h*(d_in+1)+d_o*d_h].reshape(B, d_o, d_h)
    b2 = th_batch[:, -d_o:]
    h = np.maximum(np.einsum('bij,nj->bni', W1, X) + b1[:, None, :], 0)
    pred = np.einsum('boj,bnj->bno', W2, h) + b2[:, None]
    return ((pred - Y[None, :, :])**2).mean(axis=(1, 2))

# === Train student to near-zero loss ===
def train_student(X, Y, n_steps=5000, lr=0.01):
    rng = default_rng(42)
    th = rng.normal(0, 0.1, d)
    for i in range(n_steps):
        g = loss_grad(th, X, Y)
        th -= lr * g
        if i % 1000 == 0:
            l = loss_fn(th, X, Y)
            if l < 1e-8:
                break
    return th, loss_fn(th, X, Y)

# === Sublevel-set RLCT estimation ===
def estimate_rlct_sublevel(th0, X, Y, perturb_fn, n_samples=10000, eps_vals=None, seed=77):
    rng = default_rng(seed)
    L0 = loss_fn(th0, X, Y)
    if eps_vals is None:
        eps_vals = np.logspace(-2, -0.5, 15)
    counts = []
    for eps in eps_vals:
        perturbed = perturb_fn(th0, eps, n_samples, rng)
        losses = vloss_batch(perturbed, X, Y)
        frac_below = np.mean(losses - L0 < eps * 10)  # within eps*10 of L0
        counts.append(frac_below)
    # Fit log(V(eps)) ~ d_eff * log(eps) in the scaling region
    # V(eps) = fraction of points with L < L0 + eps
    # RLCT ~ d_eff / 2 where V(eps) ~ eps^d_eff
    log_eps = np.log(eps_vals)
    log_vol = np.log(np.maximum(counts, 1e-10))
    # Linear fit in log-log
    mask = (np.array(counts) > 0.01) & (np.array(counts) < 0.9)
    if mask.sum() < 3:
        return np.nan, np.nan
    A = np.vstack([log_eps[mask], np.ones(mask.sum())]).T
    slope, intercept = np.linalg.lstsq(A, log_vol[mask], rcond=None)[0]
    rlct = slope
    return rlct, slope

# === Perturbation functions ===
def coupled_perturb(th0, eps, n, rng):
    # Shared latent z, different projections for W1 and W2 parts
    noise = rng.normal(0, 1, (n, d)) * eps
    # Couple: W1 noise and W2 noise share a common factor
    W1_size = d_h * d_in + d_h  # W1 + b1
    W2_size = d_o * d_h + d_o    # W2 + b2
    z = rng.normal(0, 1, (n, 1))  # shared latent
    U1 = rng.normal(0, 1, (d, 1))  # fixed projection for coupled component
    coupled = z @ U1.T * eps
    # Mix coupled and independent noise: 50% coupled, 50% independent
    return th0[None, :] + 0.5 * noise + 0.5 * coupled

def decoupled_perturb(th0, eps, n, rng):
    # Independent noise for all parameters (standard)
    return th0[None, :] + rng.normal(0, 1, (n, d)) * eps

def full_ft_perturb(th0, eps, n, rng):
    # Full FT perturbation: independent noise on all params (same as decoupled)
    return th0[None, :] + rng.normal(0, 1, (n, d)) * eps

# === Main experiment ===
if __name__ == '__main__':
    t = gen_teacher()
    n_train = 50
    X, Y = gen_data(t, n_train)
    
    print(f"=== v14: Coupled vs Decoupled Perturbation (d={d}, ReLU 8-4-1, n={n_train}) ===")
    
    # Train student
    th0, L0 = train_student(X, Y, n_steps=10000, lr=0.01)
    print(f"Trained student: L0 = {L0:.6e}")
    grad_norm = np.linalg.norm(loss_grad(th0, X, Y))
    print(f"Grad norm at L0: {grad_norm:.6e}")
    
    if L0 > 1e-6:
        # Try BFGS for better convergence
        res = minimize(lambda th: loss_fn(th, X, Y), th0, 
                       jac=lambda th: loss_grad(th, X, Y), method='BFGS',
                       options={'maxiter': 5000, 'gtol': 1e-10})
        th0 = res.x
        L0 = loss_fn(th0, X, Y)
        grad_norm = np.linalg.norm(loss_grad(th0, X, Y))
        print(f"After BFGS: L0 = {L0:.6e}, grad_norm = {grad_norm:.6e}")
    
    eps_vals = np.logspace(-3, -0.5, 20)
    n_samples = 20000
    
    print(f"\n--- Sublevel-set RLCT estimation (n_samples={n_samples}) ---")
    
    for label, pfn in [("Decoupled (independent)", decoupled_perturb),
                        ("Coupled (shared latent)", coupled_perturb)]:
        rlct, slope = estimate_rlct_sublevel(th0, X, Y, pfn, 
                                               n_samples=n_samples, eps_vals=eps_vals)
        print(f"  {label}: RLCT = {rlct:.4f} (slope = {slope:.4f})")
    
    # Reference: d/2 for regular case
    print(f"\n  Reference d/2 = {d/2:.4f}")
    print(f"  Reference d/4 = {d/4:.4f} (strongly singular)")
    
    # Multiple seeds for robustness
    print("\n--- Multi-seed (3 seeds) ---")
    results = {"coupled": [], "decoupled": []}
    for seed in [42, 123, 456]:
        rng_teacher = default_rng(seed * 7 + 13)
        W1 = rng_teacher.normal(0,1,(d_h,d_in)); b1 = rng_teacher.normal(0,.1,d_h)
        W2 = rng_teacher.normal(0,1,(d_o,d_h)); b2 = rng_teacher.normal(0,.1,d_o)
        t_s = (W1, b1, W2, b2)
        X_s = default_rng(seed * 11).normal(0,1,(n_train, d_in))
        h = np.maximum(X_s @ W1.T + b1, 0)
        Y_s = h @ W2.T + b2
        Y_s = Y_s / np.std(Y_s)
        
        th0_s, L0_s = train_student(X_s, Y_s, n_steps=10000, lr=0.01)
        if L0_s > 1e-6:
            res = minimize(lambda th: loss_fn(th, X_s, Y_s), th0_s,
                          jac=lambda th: loss_grad(th, X_s, Y_s), method='BFGS',
                          options={'maxiter': 5000, 'gtol': 1e-10})
            th0_s = res.x
            L0_s = loss_fn(th0_s, X_s, Y_s)
        
        r_c, _ = estimate_rlct_sublevel(th0_s, X_s, Y_s, coupled_perturb, 
                                          n_samples=n_samples, eps_vals=eps_vals, seed=seed)
        r_d, _ = estimate_rlct_sublevel(th0_s, X_s, Y_s, decoupled_perturb,
                                          n_samples=n_samples, eps_vals=eps_vals, seed=seed)
        results["coupled"].append(r_c)
        results["decoupled"].append(r_d)
        print(f"  Seed {seed}: L0={L0_s:.2e} | coupled={r_c:.4f} | decoupled={r_d:.4f} | ratio={r_c/max(r_d,1e-6):.3f}")
    
    mc = np.median(results["coupled"])
    md = np.median(results["decoupled"])
    print(f"\n  Median coupled: {mc:.4f} | Median decoupled: {md:.4f} | Ratio: {mc/max(md,1e-6):.3f}")
    print("  If ratio > 1: coupled perturbation accesses more singularity structure")