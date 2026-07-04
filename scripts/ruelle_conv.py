import numpy as np
eta = 1.839286755214161
for N in [250, 500, 1000]:
    M0 = np.zeros((N, N))
    Me = np.zeros((N, N))
    for i in range(N):
        x = i / N
        y1 = x / eta
        if 0 <= y1 < 1:
            j1 = int(y1 * N) % N
            M0[i, j1] += 1.0
            Me[i, j1] += 1.0 / eta
        if x < eta - 1:
            y2 = (x + 1) / eta
            if 0 <= y2 < 1:
                j2 = int(y2 * N) % N
                M0[i, j2] += 1.0
                Me[i, j2] += 1.0 / eta
    d0 = max(np.linalg.eigvals(M0), key=lambda z: abs(z))
    de = max(np.linalg.eigvals(Me), key=lambda z: abs(z))
    print(f"N={N}: L0 |lambda|={abs(d0):.6f} eta={eta:.6f} ratio={abs(d0)/eta:.6f}  RPF |lambda|={abs(de):.6f} ratio={abs(de):.6f}")