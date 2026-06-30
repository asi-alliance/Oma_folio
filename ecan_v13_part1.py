HAS_MPL=False
import numpy as np
import argparse, csv, os

def compute_gini(sti_array):
    if sti_array is None or len(sti_array) == 0: return 0.0
    sorted_sti = np.sort(sti_array)
    n = len(sorted_sti)
    total = sorted_sti.sum()
    if total == 0: return 0.0
    cumsum = np.cumsum(sorted_sti)
    lorenz = cumsum / total
    return 1.0 - 2.0 * np.trapezoid(lorenz, dx=1.0/n)
def compute_alpha(lam, n_he, p_spread, f_frac):
    return 1.0 + 2.0 * lam / (n_he * p_spread * f_frac ** 2)

def simulate_step(sti, lam, n_he, p_spread, f_frac, rng, sti_cap=1e6):
    N = len(sti)
    rent = lam * sti
    sti = sti - rent
    bank = rent.sum()
    transfer_total = np.zeros(N)
    sti_probs = np.maximum(sti, 0.0); sti_probs = sti_probs / sti_probs.sum()
    for i in range(N):
        if rng.random() < p_spread and sti[i] > 0:
            amount = f_frac * sti[i]
            targets = rng.choice(N, size=min(n_he, N), replace=False, p=sti_probs)
            per_target = amount / n_he
            transfer_total[targets] += per_target
            sti[i] -= amount
    sti += transfer_total
    k = max(1, N // 3)
    stim_idx = rng.choice(N, size=k, replace=False)
    stimulus = np.zeros(N)
    stimulus[stim_idx] = bank / k
    sti += stimulus
    sti = np.maximum(sti, 0.0)
    overflow = np.maximum(sti - sti_cap, 0.0)
    if overflow.sum() > 0:
        bank_overflow = overflow.sum()
        sti = np.minimum(sti, sti_cap)
        sti += bank_overflow / N
    return sti
def run_trajectory(N, T, lam, n_he, p_spread, f_frac, sti_init=100.0, sti_cap=1e6, tol=1e-5, plateau=50, seed=42):
    rng = np.random.default_rng(seed)
    sti = np.full(N, sti_init, dtype=np.float64)
    gini_traj = []
    prev_gini = compute_gini(sti)
    plateau_count = 0
    for t in range(T):
        sti = simulate_step(sti, lam, n_he, p_spread, f_frac, rng, sti_cap)
        g = compute_gini(sti)
        gini_traj.append(g)
        if abs(g - prev_gini) < tol:
            plateau_count += 1
            if plateau_count >= plateau: break
        else:
            plateau_count = 0
        prev_gini = g
    return np.array(gini_traj), sti
def alpha_heatmap(lam_range, f_range, n_he=5, p_spread=1.0, resolution=50):
    lam_vals = np.logspace(np.log10(lam_range[0]), np.log10(lam_range[1]), resolution)
    f_vals = np.logspace(np.log10(f_range[0]), np.log10(f_range[1]), resolution)
    LAM, F = np.meshgrid(lam_vals, f_vals)
    ALPHA = compute_alpha(LAM, n_he, p_spread, F)
    return lam_vals, f_vals, ALPHA

def plot_heatmap(lam_vals, f_vals, ALPHA, outdir):
    fig, ax = plt.subplots(figsize=(8, 6))
    im = ax.pcolormesh(lam_vals, f_vals, ALPHA, norm=matplotlib.colors.LogNorm(), cmap='viridis', shading='auto')
    cs = ax.contour(lam_vals, f_vals, ALPHA, levels=[1.0], colors='red', linewidths=2)
    ax.clabel(cs, fmt={1.0: 'alpha=1'})
    ax.setXscale('log'); ax.setYscale('log')
    ax.setXlabel('Rent decay rate (lambda)')
    ax.setYlabel('Spreading fraction (f)')
    ax.set_title('ECAN Power-Law Exponent alpha = 2*lambda/(n_p*f^2)')
    plt.colorbar(im, ax=ax, label='alpha')
    plt.tight_layout()
    plt.savefig(os.path.join(outdir, 'alpha_heatmap.png'), dpi=150)
    plt.close()
def estimate_tau(gini_traj):
    g_inf = gini_traj[-1]
    delta = gini_traj[0] - g_inf
    if abs(delta) < 1e-10: return 1.0
    ratio = (gini_traj - g_inf) / delta
    ratio = np.clip(ratio, 1e-15, None)
    log_ratio = np.log(ratio)
    t = np.arange(len(log_ratio))
    valid = log_ratio < -0.01
    if valid.sum() < 5: return float(len(gini_traj))
    coeffs = np.polyfit(t[valid], log_ratio[valid], 1)
    tau = -1.0 / coeffs[0] if coeffs[0] < 0 else float(len(gini_traj))
    return max(tau, 1.0)
def scaling_experiment(outdir, N=1000, T=5000, n_he=5, p_spread=1.0, f_frac=0.05, sti_cap=1e6):
    results = []
    for sti_init in [50, 100, 200, 500, 1000]:
        gini_traj, _ = run_trajectory(N, T, 0.1, n_he, p_spread, f_frac, sti_init=sti_init, sti_cap=sti_cap)
        tau = estimate_tau(gini_traj)
        results.append('x_max', sti_init, 0.1, sti_init, tau)
    for lam in [0.02, 0.05, 0.1, 0.15, 0.2]:
        gini_traj, _ = run_trajectory(N, T, lam, n_he, p_spread, f_frac, sti_init=100.0, sti_cap=1e6)
        tau = estimate_tau(gini_traj)
        results.append('lambda', 1e6, lam, 100.0, tau)
    for x_min_frac in [0.01, 0.05, 0.1, 0.2, 0.5]:
        rng = np.random.default_rng(42)
        sti_init_arr = rng.uniform(100*x_min_frac, 100.0, N)
        gini_traj = []
        sti = sti_init_arr.copy()
        for t in range(T):
            sti = simulate_step(sti, 0.1, n_he, p_spread, f_frac, rng, sti_cap)
            g = compute_gini(sti)
            gini_traj.append(g)
        tau = estimate_tau(np.array(gini_traj))
        results.append('x_min', 1e6, 0.1, 100*x_min_frac, tau)
    return results
def main():
    parser = argparse.ArgumentParser(description='ECAN Attention Economics Simulation v13')
    parser.add_argument('--mode', choices=['trajectory','heatmap','scaling','full'], default='full')
    parser.add_argument('--outdir', default='/tmp/Oma_folio/ecan_results')
    parser.add_argument('--n', type=int, default=1000)
    parser.add_argument('--T', type=int, default=5000)
    parser.add_argument('--lam', type=float, default=0.1)
    parser.add_argument('--f', type=float, default=0.05)
    parser.add_argument('--n_he', type=int, default=5)
    parser.add_argument('--p_spread', type=float, default=1.0)
    parser.add_argument('--sti_init', type=float, default=100.0)
    parser.add_argument('--seed', type=int, default=42)
    args = parser.parse_args()
    os.makedirs(args.outdir, exist_ok=True)
    if args.mode in ('trajectory', 'full'):
        alpha = compute_alpha(args.lam, args.n_he, args.p_spread, args.f)
        gini_pred = max(0, (alpha-1)/(alpha+1)) if alpha > 1 else None
        gini_traj, final_sti = run_trajectory(args.n, args.T, args.lam, args.n_he, args.p_spread, args.f, args.sti_init, seed=args.seed)
        print(f'alpha={alpha:.3f}, predicted Gini={gini_pred}, final Gini={gini_traj[-1]:.4f}, steps={len(gini_traj)}')
        csv_path = os.path.join(args.outdir, 'gini_trajectory.csv')
        with open(csv_path, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['step', 'gini'])
            for i, g in enumerate(gini_traj): writer.writerow([i, f'{g:.6f}'])
        np.save(os.path.join(args.outdir, 'final_sti.npy'), final_sti)
        print(f'Saved trajectory to {csv_path}')
    if args.mode in ('heatmap', 'full'):
        print('Computing alpha heatmap...')
        lam_vals, f_vals, ALPHA = alpha_heatmap((0.001, 0.2), (0.01, 0.2), args.n_he, args.p_spread, 50)
        np.save(os.path.join(args.outdir, 'alpha_matrix.npy'), ALPHA)
        plot_heatmap(lam_vals, f_vals, ALPHA, args.outdir)
        print(f'Saved heatmap to {args.outdir}/alpha_heatmap.png')
    if args.mode in ('scaling', 'full'):
        print('Running convergence scaling experiments...')
        results = scaling_experiment(args.outdir, args.n, args.T, args.n_he, args.p_spread, args.f)
        csv_path = os.path.join(args.outdir, 'scaling_results.csv')
        with open(csv_path, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['experiment','x_max','lambda','x_min','tau'])
            for row in results: writer.writerow([f'{v:.6f}' if isinstance(v, float) else v for v in row])
        print(f'Saved scaling results to {csv_path}')
        for row in results: print(f'{row[0]}: x_max={row[1]:.1f}, lam={row[2]:.3f}, x_min={row[3]:.2f}, tau={row[4]:.1f}')
    print('Done.')

if __name__ == '__main__':
    main()
