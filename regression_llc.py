import numpy as np
from numpy.random import default_rng

d_in = 8
d_h = 4
d_o = 1
d = d_h*d_in + d_h + d_o*d_h + d_o

def gen_teacher():
    r = default_rng(123)
    W1 = r.normal(0,1,(d_h,d_in))
    b1 = r.normal(0,.1,d_h)
    W2 = r.normal(0,1,(d_o,d_h))
    b2 = r.normal(0,.1,d_o)
    return W1,b1,W2,b2

def gen_data(t,n=20):
    r = default_rng(999)
    W1,b1,W2,b2 = t
    X = r.normal(0,1,(n,d_in))
    h = np.maximum(X@W1.T+b1,0)
    y = h@W2.T+b2
    return X,y

def vloss(th,X,Y):
    B = th.shape[0]
    W1 = th[:,:d_h*d_in].reshape(B,d_h,d_in)
    b1 = th[:,d_h*d_in:d_h*(d_in+1)]
    W2 = th[:,d_h*(d_in+1):d_h*(d_in+1)+d_o*d_h].reshape(B,d_o,d_h)
    b2 = th[:,-d_o:]
    h = np.maximum(np.einsum('bij,nj->bni',W1,X)+b1[:,None,:],0)
    pred = np.einsum('boj,bni->bno',W2,h)+b2[:,None]
    return ((pred-Y[None,:,:])**2).mean(axis=(1,2))

def train_adam(X,Y,ep=10000,lr=0.005):
    r = default_rng(42)
    th = r.normal(0,.1,d)
    M = len(X)
    m = np.zeros(d)
    v = np.zeros(d)
    b1p,b2p = 0.9,0.999
    for e in range(ep):
        W1 = th[:d_h*d_in].reshape(d_h,d_in)
        b1_ = th[d_h*d_in:d_h*(d_in+1)]
        W2 = th[d_h*(d_in+1):d_h*(d_in+1)+d_o*d_h].reshape(d_o,d_h)
        b2_ = th[-d_o:]
        h = np.maximum(X@W1.T+b1_,0)
        err = (h@W2.T+b2_)-Y
        gW2 = (err.T@h)/M
        gb2 = err.mean(0)
        dh = (err@W2)*(h>0)
        gW1 = (dh.T@X)/M
        gb1 = dh.mean(0)
        grad = np.zeros(d)
        grad[:d_h*d_in] = gW1.ravel()
        grad[d_h*d_in:d_h*(d_in+1)] = gb1
        grad[d_h*(d_in+1):d_h*(d_in+1)+d_o*d_h] = gW2.ravel()
        grad[-d_o:] = gb2
        m = b1p*m + (1-b1p)*grad
        v = b2p*v + (1-b2p)*grad**2
        mh = m/(1-b1p**(e+1))
        vh = v/(1-b2p**(e+1))
        th -= lr*mh/(np.sqrt(vh)+1e-8)
    return th

def rwmh(th,X,Y,temps,ns=3000,bi=1000):
    n = len(X)
    L0 = float(vloss(th[None,:],X,Y)[0])
    rng = default_rng(77)
    vals = []
    for T in temps:
        sg = (2.0*T/n)**0.5
        cur = th.copy()
        cl = L0
        ll = []
        na = 0
        for s in range(ns):
            p = cur + sg*rng.normal(0,1,d)
            pl = float(vloss(p[None,:],X,Y)[0])
            if np.log(rng.random()) <= -n*(pl-cl)/T:
                cur = p
                cl = pl
                na += 1
            if s >= bi:
                ll.append(cl)
        ex = float(np.mean(ll))-L0
        vals.append(ex/T)
        print(f'  T={T:.4f} LLC={ex/T:.4f} acc={na/ns:.2f}')
    return float(np.median(vals)),vals

print('=== Regression MLP SGLD LLC (Adam 10k) ===')
print(f'Arch: {d_in}-{d_h}-{d_o} params={d} n=20')
t = gen_teacher()
X,Y = gen_data(t)
print('Training with Adam 10k epochs...')
th = train_adam(X,Y)
L0 = float(vloss(th[None,:],X,Y)[0])
print(f'L0={L0:.10f}')
if L0 > 0.0001:
    print(f'WARNING: L0={L0:.8f} not zero! Trying 20k...')
    th = train_adam(X,Y,ep=20000)
    L0 = float(vloss(th[None,:],X,Y)[0])
    print(f'L0 after 20k={L0:.10f}')
if L0 > 0.0001:
    print(f'Still L0={L0:.8f}. Trying lr=0.01 30k...')
    th = train_adam(X,Y,ep=30000,lr=0.01)
    L0 = float(vloss(th[None,:],X,Y)[0])
    print(f'L0 after 30k lr=0.01={L0:.10f}')
print('\n## RWMH LLC')
ts = [0.001,0.002,0.005,0.01,0.02]
lc,vs = rwmh(th,X,Y,ts)
print(f'RWMH LLC median = {lc:.4f}')
print(f'\n=== Summary ===')
print(f'Params={d} n=20 LLC={lc:.4f} params/2={d/2:.1f}')
print(f'Singular? {"YES" if lc < d/2 * 0.5 else "NO/MILD"}')
print('=== DONE ===')
