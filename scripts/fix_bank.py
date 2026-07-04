import sys
f = '/tmp/Oma_folio/ecan_v13_part1.py'
lines = open(f).readlines()
old = '    sti += bank / N
'
new = '    k = max(1, N // 3)
    stim_idx = rng.choice(N, size=k, replace=False)
    stimulus = np.zeros(N)
    stimulus[stim_idx] = bank / k
    sti += stimulus
'
if old in lines:
    idx = lines.index(old)
    lines[idx] = new
    open(f, 'w').writelines(lines)
    print('Replaced line', idx+1)
else:
    print('Target line not found')
    for i, l in enumerate(lines):
        if 'bank' in l and ('/ N' in l or '/N' in l):
            print(' candidate', i+1, repr(l))