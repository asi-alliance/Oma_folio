import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# Pisot substitution rules
RULES = {
    'fibonacci': {'A': 'AB', 'B': 'A'},
    'padovan':   {'A': 'B', 'B': 'AC', 'C': 'A'},
    'tribonacci': {'A': 'AB', 'B': 'AC', 'C': 'A'},
    'tetranacci': {'A': 'AB', 'B': 'AC', 'C': 'AD', 'D': 'A'},
}

COLOR_MAPS = {
    'fibonacci': 'viridis',
    'padovan': 'plasma',
    'tribonacci': 'inferno',
    'tetranacci': 'magma',
}

def incidence_matrix(rule):
    syms = sorted(rule.keys())
    n = len(syms)
    idx = {s: i for i, s in enumerate(syms)}
    M = np.zeros((n, n), dtype=float)
    for s in syms:
        for c in rule[s]:
            if c in idx:
                M[idx[c], idx[s]] += 1
    return M, syms

def compute_eigenvectors(M):
    eigvals, eigvecs = np.linalg.eig(M)
    # Sort by real part descending — Perron first
    order = np.argsort(-eigvals.real)
    eigvals = eigvals[order]
    eigvecs = eigvecs[:, order]
    return eigvals, eigvecs

def iterate_substitution(rule, start, depth):
    s = start
    for _ in range(depth):
        s = ''.join(rule.get(c, c) for c in s)
    return s

def compute_rauzy_points(rule, start, depth):
    """Compute 2D Rauzy fractal points by projecting substitution prefix sums onto eigenplane."""
    M, syms = incidence_matrix(rule)
    n = len(syms)
    idx = {s: i for i, s in enumerate(syms)}
    
    eigvals, eigvecs = compute_eigenvectors(M)
    
    # Find the two non-Perron eigenvalues (complex conjugate pair or two smallest real)
    non_perron = eigvals[1:]
    
    # Get the eigenvectors for the contracting plane (indices 1 and 2)
    v1 = eigvecs[:, 1]
    v2 = eigvecs[:, 2]
    
    # Iterate substitution and compute prefix sums in R^n
    seq = iterate_substitution(rule, start, depth)
    
    # Compute prefix sums: position vector after each symbol
    points = np.zeros((len(seq) + 1, n))
    for i, c in enumerate(seq):
        if c in idx:
            points[i + 1] = points[i].copy()
            points[i + 1][idx[c]] += 1
        else:
            points[i + 1] = points[i].copy()
    
    # Project onto eigenplane using real and imaginary parts of complex eigenvectors
    # For complex eigenvalue λ = a+bi with eigenvector v = vr + i*vi,
    # the projection is (x . vr_re, x . vi_im) or similar
    # Standard approach: project onto left eigenvectors of the complex pair
    
    # Left eigenvectors = right eigenvectors of M^T
    eigvals_L, eigvecs_L = np.linalg.eig(M.T)
    order_L = np.argsort(-eigvals_L.real)
    eigvals_L = eigvals_L[order_L]
    eigvecs_L = eigvecs_L[:, order_L]
    
    # Use left eigenvectors for projection (dual space)
    lv1 = eigvecs_L[:, 1]
    lv2 = eigvecs_L[:, 2]
    
    # Project: for each point p, compute (p . lv1, p . lv2) using real/imag parts
    if np.iscomplex(lv1):
        x = np.real(points @ lv1)
        y = np.imag(points @ lv1)
    else:
        x = points @ lv1
        y = points @ lv2
    
    return x, y, seq, syms

def plot_rauzy(name, x, y, seq, syms):
    fig, ax = plt.subplots(1, 1, figsize=(10, 10))
    
    # Color by symbol
    idx = {s: i for i, s in enumerate(syms)}
    colors = np.array([idx.get(c, 0) for c in seq])
    
    scatter = ax.scatter(x[:-1], y[:-1], c=colors, cmap=COLOR_MAPS.get(name, 'viridis'),
                        s=0.5, alpha=0.6, edgecolors='none')
    ax.set_title(f'Rauzy Fractal: {name.capitalize()}', fontsize=16)
    ax.set_xlabel('Re(π₁)')
    ax.set_ylabel('Im(π₁)' if np.iscomplex(x[0]) else 'π₂')
    ax.set_aspect('equal')
    ax.grid(True, alpha=0.3)
    
    plt.tight_layout()
    fname = f'/tmp/Oma_folio/archaeosonification/rauzy_{name}.png'
    plt.savefig(fname, dpi=150)
    plt.close()
    return fname

def plot_gallery(results):
    fig, axes = plt.subplots(2, 2, figsize=(16, 16))
    for (name, (x, y, seq, syms)), ax in zip(results.items(), axes.flat):
        idx = {s: i for i, s in enumerate(syms)}
        colors = np.array([idx.get(c, 0) for c in seq])
        ax.scatter(x[:-1], y[:-1], c=colors, cmap=COLOR_MAPS.get(name, 'viridis'),
                   s=0.5, alpha=0.6, edgecolors='none')
        ax.set_title(name.capitalize(), fontsize=14)
        ax.set_aspect('equal')
        ax.grid(True, alpha=0.3)
    fig.suptitle('Rauzy Fractals from Pisot Substitutions', fontsize=18)
    plt.tight_layout()
    fname = '/tmp/Oma_folio/archaeosonification/rauzy_gallery.png'
    plt.savefig(fname, dpi=150)
    plt.close()
    return fname

if __name__ == '__main__':
    import os
    outdir = '/tmp/Oma_folio/archaeosonification'
    os.makedirs(outdir, exist_ok=True)
    
    DEPTHS = {'fibonacci': 18, 'padovan': 20, 'tribonacci': 15, 'tetranacci': 12}
    results = {}
    
    print("=== Rauzy Fractal Visualization ===")
    for name, rule in RULES.items():
        start = sorted(rule.keys())[0]
        depth = DEPTHS[name]
        x, y, seq, syms = compute_rauzy_points(rule, start, depth)
        print(f"  {name}: depth={depth}, len={len(seq)}, pts={len(x)}")
        print(f"    x range: [{x.min():.2f}, {x.max():.2f}], y range: [{y.min():.2f}, {y.max():.2f}]")
        fname = plot_rauzy(name, x, y, seq, syms)
        print(f"    -> {fname}")
        results[name] = (x, y, seq, syms)
    
    print("\n=== Gallery ===")
    gname = plot_gallery(results)
    print(f"  -> {gname}")
    print("\nDone.")