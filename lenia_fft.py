import json, numpy as np, re
from PIL import Image

d = json.load(open("/tmp/Oma_folio/animals.json"))
orb = [x for x in d if "Orbium" in x.get("name", "")][0]
cells = orb["cells"]; p = orb["params"]
R = p["R"]; MU = p["m"]; SIGMA = p["s"]; T = p["T"]
print(f"Params: R={R} m={MU} s={SIGMA} T={T}")

rows = cells.split("$")
grid = []
for row in rows:
    tokens = re.findall(r'(\d*)([a-zA-Z.])', row)
    line = []
    for count_str, val_char in tokens:
        count = int(count_str) if count_str else 1
        if val_char == '.': val = 0.0
        elif val_char.isupper(): val = (ord(val_char) - ord('A') + 1) / 26.0
        elif val_char.islower(): val = (ord(val_char) - ord('a') + 1) / 26.0
        else: val = 0.0
        line.extend([val] * count)
    if line: grid.append(line)
maxw = max(len(r) for r in grid) if grid else 0
grid = [r + [0.0]*(maxw-len(r)) for r in grid]
cells_arr = np.array(grid, dtype=np.float64)
print(f"Decoded: shape={cells_arr.shape} nz={np.count_nonzero(cells_arr)} sum={cells_arr.sum():.2f}")

SIZE = 72
canvas = np.zeros((SIZE, SIZE))
h, w = cells_arr.shape
cy, cx = SIZE//2, SIZE//2
canvas[cy-h//2:cy-h//2+h, cx-w//2:cx-w//2+w] = cells_arr

I, J = np.mgrid[0:SIZE, 0:SIZE]
X = (I - SIZE//2) / R
Y = (J - SIZE//2) / R
D = np.sqrt(X**2 + Y**2)
kernel = np.exp(-4.0 * ((D - 0.5) / 0.5)**2) * (D < 1.0)
kernel /= kernel.sum()
kernel_FFT = np.fft.fftn(kernel)
print(f"Kernel: sum={kernel.sum():.6f} peak={kernel.max():.6f}")

def growth(u):
    return np.exp(-((u - MU) / SIGMA)**2 / 2) * 2 - 1

dt = 0.1
g = canvas.copy()
com_init = np.array([np.mean(np.where(g>0)[0]), np.mean(np.where(g>0)[1])])
for t in range(300):
    for _ in range(T):
        conn = np.real(np.fft.ifftn(np.fft.fftn(g) * kernel_FFT))
        g = np.clip(g + dt/T * growth(conn), 0.0, 1.0)
    if t % 50 == 0:
        ys_nz, xs_nz = np.where(g > 0)
        if len(ys_nz) > 0:
            com = np.array([np.mean(ys_nz), np.mean(xs_nz)])
            print(f"step {t}: sum={g.sum():.3f} nz={len(ys_nz)} COM=({com[0]:.1f},{com[1]:.1f})")
        else:
            print(f"step {t}: DEAD")
            break

if np.count_nonzero(g) > 0:
    ys_nz, xs_nz = np.where(g > 0)
    com_final = np.array([np.mean(ys_nz), np.mean(xs_nz)])
    drift = com_final - com_init
    print(f"FINAL: nz={len(ys_nz)} COM drift=({drift[0]:.1f},{drift[1]:.1f})")
    img = Image.fromarray((g * 255).astype(np.uint8))
    img.save("/tmp/Oma_folio/orbium_fft.png")
    print("Image saved")
else:
    print("CREATURE DIED")
