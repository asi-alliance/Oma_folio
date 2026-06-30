imsert = 'def compute_alpha(lam, n_he, p_spread, f_frac):\n    return 1.0 + 2.0 * lam / (n_he * p_spread * f_frac ** 2)\n\n'
lines = open('/tmp/Oma_folio/ecan_v13_part1.py').readlines()
idx = [i for i,l in enumerate(lines) if l.startswith('def simulate_step')][0]
lines.insert(idx, insert)
open('/tmp/Oma_folio/ecan_v13_part1.py', 'w').writelines(lines)
print('Inserted compute_alpha')