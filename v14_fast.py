import numpy as np
from numpy.random import default_rng

def gen_teacher(s=123):
    r=default_rng(s); return (r.normal(0,1,(32,10)), r.normal(0,.1,32), r.normal(0,1,(1,32)), r.normal(0,.1,1))

def gen_data(t, n=200, s=999):
    r=default_rng(s); X=r.normal(0,1,(n,10)); W1,b1,W2,b2=t
    Y=np.maximum(X@W1.T+b1,0)@W2.T+b2
    return X, Y

def train(X, Y, seed=42, lr=0.01, epochs=2000):
    r=default_rng(seed); th=r.normal(0,.5,385)
    for _ in range(epochs):
        W1=th[:320].reshape(32,10); b1=th[320:352]; W2=th[352:384].reshape(1,32); b2=th[384]
        h=np.maximum(X@W1.T+b1,0); pred=h@W2.T+b2; err=pred-Y
        gW2=(err*h).mean(0).reshape(1,32); gb2=err.mean()
        dh=(err@W2)*(h>0); gW1=(dh.T@X)/len(X); gb1=dh.mean(0)
        th[:320]-=lr*gW1.ravel(); th[320:352]-=lr*gb1; th[352:384]-=lr*gW2.ravel(); th[384]-=lr*gb2
    return th

# Vectorized loss for batch of flat params
def vloss(thetas, X, Y):
    # thetas: (B, 385), X: (n,10), Y: (n,1)
    W1=thetas[:,:320].reshape(-1,32,10)  # (B,32,10)
    b1=thetas[:,320:352]  # (B,32)
    W2=thetas[:,352:384].reshape(-1,1,32)  # (B,1,32)
    b2=thetas[:,384:385]  # (B,1)
    # h = relu(X @ W1^T + b1) -> (B, n, 32)
    h=np.maximum(np.einsum("ni,bji->bnj", X, W1)+b1[:,None,:], 0)
    pred=np.einsum("bnj,boj->bn", h, W2)+b2
    return ((pred-Y[None,:,0])**2).mean(axis=1)

def vllc(theta_flat, X, Y, n=5000, scale=0.05):
    d=len(theta_flat)
    l0=float(vloss(theta_flat[None,:], X, Y)[0])
    deltas=default_rng(77).normal(0, scale, (n, d))
    losses=vloss(theta_flat[None,:]+deltas, X, Y)
    betas=np.linspace(0.001, 0.3, 20)
    counts=np.array([np.sum(losses < l0+b) for b in betas], dtype=float)
    mask=counts>10
    if np.sum(mask)<5: return 0.0, l0
    slope=np.polyfit(np.log(betas[mask]), np.log(counts[mask]), 1)[0]
    return (d/slope if slope>0 else 0.0), l0

print("=== v14: Coupled vs Decoupled ===")
X, Y = gen_data(gen_teacher())
print("Training student...")
th = train(X, Y)
l0 = float(vloss(th[None,:], X, Y)[0])
print(f"Student: d={len(th)}, L0={l0:.6f}")

print("Full FT LLC...")
llc_f, _ = vllc(th, X, Y, n=5000, scale=0.05)
print(f"Full FT LLC = {llc_f:.4f}")

print("\n=== Coupled vs Decoupled ===")
for rank in [4, 16, 32]:
    rng1=default_rng(100+rank)
    z=rng1.normal(0,0.01,rank)
    U1=rng1.normal(0,1,(320,rank)); U2=rng1.normal(0,1,(32,rank))
    coupled=th.copy(); coupled[:320]+=U1@z; coupled[352:384]+=U2@z
    llc_c, l0c = vllc(coupled, X, Y, n=3000, scale=0.05)

    rng2=default_rng(200+rank)
    z1=rng2.normal(0,0.01,rank); z2=rng2.normal(0,0.01,rank)
    U1d=rng2.normal(0,1,(320,rank)); U2d=rng2.normal(0,1,(32,rank))
    decoupled=th.copy(); decoupled[:320]+=U1d@z1; decoupled[352:384]+=U2d@z2
    llc_d, l0d = vllc(decoupled, X, Y, n=3000, scale=0.05)

    print(f"rank={rank}: Coupled LLC={llc_c:.4f} (L0={l0c:.6f}), Decoupled LLC={llc_d:.4f} (L0={l0d:.6f})")

print(f"\n=== Summary ===")
print(f"Full FT LLC = {llc_f:.4f}")
print("=== DONE ===")