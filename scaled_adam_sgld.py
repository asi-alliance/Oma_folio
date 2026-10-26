import numpy as np
from numpy.random import default_rng

d_in = 56
d_h = 8
d_o = 10
d = d_h*d_in + d_h + d_o*d_h + d_o

def gen_teacher():
    r = default_rng(123)
    W1 = r.normal(0,1,(d_h,d_in))
    b1 = r.normal(0,.1,d_h)
    W2 = r.normal(0,1,(d_o,d_h))
    b2 = r.normal(0,.1,d_o)
    return W1,b1,W2,b2

def gen_data(t,n=500):
    r = default_rng(999)
    W1,b1,W2,b2 = t
    X = r.normal(0,1,(n,56))
    h = np.maximum(X@W1.T+b1,0)
    pred = h@W2.T+b2
    y = np.zeros((n,10))
    y[np.arange(n),np.argmax(pred,axis=1)] = 1.0
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

def train_adam(X,Y,ep=10000,lr=0.001,b1=0.9,b2=0.999,eps=1e-8):
    r = default_rng(42)
    th = r.normal(0,.1,d)
    M = len(X)
    m = np.zeros(d)
    v = np.zeros(d)
    for e in range(ep):
        W1 = th[:d_h*d_in].reshape(d_h,d_in)
        b1p = th[d_h*d_in:d_h*(d_in+1)]
        W2 = th[d_h*(d_in+1):d_h*(d_in+1)+d_o*d_h].reshape(d_o,d_h)
        b2p = th[-d_o:]
        h = np.maximum(X@W1.T+b1p,0)
        err = (h@W2.T+b2p)-Y
        gW2 = (err.T@h)/M
        gb2 = err.mean(0)
        dh = (err@W2)*(h>0)
        gW1 = (dh.T@X)/M
        gb1 = dh.mean(0)
        
        grad = np.zeros(d)
        grad[:d_h*d_in] = gW1.ravel()
        grad[d_h*d_in:d_h*(d_in+1)] = gb1
        grad[d_h*(d_in+1):d_h*(d_in+1)+d_o*d_h] = gW2.ravel()
        grad[-d_o:] = err.mean(0)
        m = b1*m + (1-b1)*grad
        v = b2*v + (1-b2)*grad**2
        mh = m/(1-b1**(e+1))
        vh = v/(1-b2**(e+1))
        th -= lr*mh/(np.sqrt(vh)+eps)
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

print('=== Scaled MLP SGLD LLC (Adam 10k) ===')
print(f'Arch: {d_in}-{d_h}-{d_o} params={d}')
t = gen_teacher()
X,Y = gen_data(t)
print('Training with Adam 10k epochs...')
th = train_adam(X,Y)
L0 = float(vloss(th[None,:],X,Y)[0])
print(f'L0={L0:.8f}')
if L0 > 0.01:
    print(f'WARNING: L0={L0:.6f} not close to 0! RWMH will likely fail.')
    print('Trying 20000 epochs...')
    th = train_adam(X,Y,ep=20000)
    L0 = float(vloss(th[None,:],X,Y)[0])
    print(f'L0 after 20k={L0:.8f}')
print('\n## RWMH LLC')
ts = [0.001,0.002,0.005,0.01,0.02]
lc,vs = rwmh(th,X,Y,ts)
print(f'RWMH LLC median = {lc:.4f}')
print(f'\n=== Summary ===')
print(f'Params={d} n=500 LLC={lc:.4f} params/2={d/2:.1f}')
print('=== DONE ===')
