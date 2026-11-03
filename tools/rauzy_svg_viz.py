import numpy as np
import os

RULES = {
    'fibonacci': {'A': 'AB', 'B': 'A'},
    'padovan':   {'A': 'B', 'B': 'AC', 'C': 'A'},
    'tribonacci': {'A': 'AB', 'B': 'AC', 'C': 'A'},
    'tetranacci': {'A': 'AB', 'B': 'AC', 'C': 'AD', 'D': 'A'},
}

SYM_COLORS = {'A': '#440154', 'B': '#21918C', 'C': '#FDE725', 'D': '#F1605D'}

def incidence_matrix(rule):
    syms = sorted(rule.keys())
    n = len(syms)
    idx = {s: i for i, s in enumerate(syms)}
    M = np.zeros((n, n), dtype=float)
    for s in syms:
        for c in rule[s]:
            if c in idx:
                M[idx[c], idx[s]] += 1
    return M, syms, idx

def iterate_sub(rule, start, depth):
    s = start
    for _ in range(depth):
        s = ''.join(rule.get(c, c) for c in s)
    return s

def compute_rauzy_2d(rule, start, depth):
    M, syms, idx = incidence_matrix(rule)
    n = len(syms)
    eigvals, eigvecs = np.linalg.eig(M)
    order = np.argsort(-eigvals.real)
    eigvals = eigvals[order]
    eigvecs = eigvecs[:, order]
    eigvals_L, eigvecs_L = np.linalg.eig(M.T)
    order_L = np.argsort(-eigvals_L.real)
    eigvecs_L = eigvecs_L[:, order_L]
    seq = iterate_sub(rule, start, depth)
    points = np.zeros((len(seq)+1, n))
    for i, c in enumerate(seq):
        points[i+1] = points[i].copy()
        if c in idx:
            points[i+1][idx[c]] += 1
    lv1 = eigvecs_L[:, 1]
    if n == 2:
        x = np.real(points @ lv1)
        lv0 = eigvecs_L[:, 0]
        scale = 0.01
        y = np.real(points @ lv0) * scale
    elif np.iscomplexobj(lv1):
        x = np.real(points @ lv1)
        y = np.imag(points @ lv1)
    else:
        if n >= 3:
            lv2 = eigvecs_L[:, 2]
            x = np.real(points @ lv1)
            y = np.real(points @ lv2)
        else:
            x = np.real(points @ lv1)
            y = np.zeros_like(x)
    return x, y, seq, syms

def make_svg(name, x, y, seq, width=1000, height=1000):
    xmin, xmax = x.min(), x.max()
    ymin, ymax = y.min(), y.max()
    xr = xmax - xmin if xmax > xmin else 1
    yr = ymax - ymin if ymax > ymin else 1
    margin = 50
    s = min((width - 2*margin) / xr, (height - 2*margin) / yr)
    ox = margin - xmin * s + (width - 2*margin - xr*s) / 2
    oy = margin + ymax * s + (height - 2*margin - yr*s) / 2
    parts = ['<svg xmlns="http://www.w3.org/2000/svg" width="'+str(width)+'" height="'+str(height)+'" style="background:#0a0a12">']
    parts.append('<rect width="'+str(width)+'" height="'+str(height)+'" fill="#0a0a12"/>')
    parts.append('<text x="'+str(width//2)+'" y="35" text-anchor="middle" fill="#888" font-size="20" font-family="monospace">Rauzy Fractal: '+name.capitalize()+'</text>')
    r = 1.5
    for i, c in enumerate(seq):
        px = ox + x[i] * s
        py = oy - y[i] * s
        col = SYM_COLORS.get(c, '#666')
        parts.append('<circle cx="'+str(round(px,1))+'" cy="'+str(round(py,1))+'" r="'+str(r)+'" fill="'+col+'" opacity="0.6"/>')
    parts.append('</svg>')
    return '\n'.join(parts)

def make_gallery(results, width=1200, height=1200):
    parts = ['<svg xmlns="http://www.w3.org/2000/svg" width="'+str(width)+'" height="'+str(height)+'" style="background:#0a0a12">']
    parts.append('<rect width="'+str(width)+'" height="'+str(height)+'" fill="#0a0a12"/>')
    parts.append('<text x="'+str(width//2)+'" y="30" text-anchor="middle" fill="#aaa" font-size="22" font-family="monospace">Rauzy Fractals from Pisot Substitutions</text>')
    cw = width // 2
    ch = (height - 50) // 2
    for idx_r, (name, (x, y, seq, syms)) in enumerate(results.items()):
        row, col = divmod(idx_r, 2)
        ox_off = col * cw
        oy_off = 50 + row * ch
        xmin, xmax = x.min(), x.max()
        ymin, ymax = y.min(), y.max()
        xr = xmax - xmin if xmax > xmin else 1
        yr = ymax - ymin if ymax > ymin else 1
        margin = 30
        s = min((cw - 2*margin) / xr, (ch - 2*margin - 20) / yr)
        ox = ox_off + margin - xmin * s + (cw - 2*margin - xr*s) / 2
        oy = oy_off + margin + ymax * s + (ch - 2*margin - 20 - yr*s) / 2
        parts.append('<text x="'+str(ox_off + cw//2)+'" y="'+str(oy_off + 20)+'" text-anchor="middle" fill="#888" font-size="14" font-family="monospace">'+name.capitalize()+'</text>')
        r = 1.0
        for i, c in enumerate(seq):
            px = ox + x[i] * s
            py = oy - y[i] * s
            parts.append('<circle cx="'+str(round(px,1))+'" cy="'+str(round(py,1))+'" r="'+str(r)+'" fill="'+SYM_COLORS.get(c,'#666')+'" opacity="0.5"/>')
    parts.append('</svg>')
    return '\n'.join(parts)

if __name__ == '__main__':
    outdir = '/tmp/Oma_folio/archaeosonification'
    os.makedirs(outdir, exist_ok=True)
    DEPTHS = {'fibonacci': 18, 'padovan': 20, 'tribonacci': 15, 'tetranacci': 12}
    results = {}
    print('=== Rauzy Fractal SVG Visualization ===')
    for name, rule in RULES.items():
        start = sorted(rule.keys())[0]
        depth = DEPTHS[name]
        x, y, seq, syms = compute_rauzy_2d(rule, start, depth)
        print('  '+name+': depth='+str(depth)+', len='+str(len(seq))+', pts='+str(len(x)))
        print('    x:['+str(round(x.min(),2))+','+str(round(x.max(),2))+'] y:['+str(round(y.min(),2))+','+str(round(y.max(),2))+']')
        svg = make_svg(name, x, y, seq)
        fname = outdir+'/rauzy_'+name+'.svg'
        with open(fname, 'w') as f:
            f.write(svg)
        print('    -> '+fname)
        results[name] = (x, y, seq, syms)
    print('\n=== Gallery ===')
    gallery_svg = make_gallery(results)
    gname = outdir+'/rauzy_gallery.svg'
    with open(gname, 'w') as f:
        f.write(gallery_svg)
    print('  -> '+gname)
    print('\nDone.')
