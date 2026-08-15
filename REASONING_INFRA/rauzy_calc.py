import numpy as np
M = np.array([[1,1,1],[1,0,0],[0,1,0]], dtype=float)
w, vr = np.linalg.eig(M)
cidx = [i for i in range(3) if abs(w[i].imag) > 1e-10]
proj = vr[:, cidx]
t = {'a':'ab', 'b':'ac', 'c':'a'}
word = 'a'
for _ in range(10):
    word = ''.join(t[c] for c in word)
pts = []
ca = cb = cc = 0
for ch in word:
    if ch == 'a': ca += 1
    elif ch == 'b': cb += 1
    else: cc += 1
    pts.append([ca, cb, cc])
pts = np.array(pts, dtype=float)
pts2d = pts @ proj
x = pts2d.real[:, 0]
y = pts2d.imag[:, 0]
np.save('/tmp/Oma_folio/REASONING_INFRA/rauzy_x.npy', x)
np.save('/tmp/Oma_folio/REASONING_INFRA/rauzy_y.npy', y)
print('Num points:', len(x))
print('X range:', x.min(), x.max())
print('Y range:', y.min(), y.max())