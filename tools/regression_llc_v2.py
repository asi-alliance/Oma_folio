import numpy as np
from numpy.random import default_rng
from scipy.optimize import minimize

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
    # Normalize targets
    y = y / np.std(y)
    return X,y

def loss_fn(th,X,Y):
    W1 = th[:d_h*d_in].reshape(d_h,d_in)
    b1 = th[d_h*d_in:d_h*(d_in+1)]
    W2 = th[d_h*(d_in+1):d_h*(d_in+1)+d_o*d_h].reshape(d_o,d_h)
    b2 = th[-d_o:]
    h = np.maximum(X@W1.T+b1,0)
    pred = h@W2.T+b2
    return float(((pred-Y)**2).mean())

def loss_grad(th,X,Y):
    M = len(X)
    W1 = th[:d_h*d_in].reshape(d_h,d_in)
    b1 = th[d_h*d_in:d_h*(d_in+1)]
    W2 = th[d_h*(d_in+1):d_h*(d_in+1)+d_o*d_h].reshape(d_o,d_h)
    b2 = th[-d_o:]
    h = np.maximum(X@W1.T+b1,0)
    err = (h@W2.T+b2)-Y
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
    return grad

def vloss(th,X,Y):
    B = th.shape[0]
    W1 = th[:,:d_h*d_in].reshape(B,d_h,d_in)
    b1 = th[:,d_h*d_in:d_h*(d_in+1)]
    W2 = th[:,d_h*(d_in+1):d_h*(d_in+1)+d_o*d_h].reshape(B,d_o,d_h)
    b2 = th[:,-d_o:]
    h = np.maximum(np.einsum('bij,nj->bni',W1,X)+b1[:,None,:],0)
    pred = np.einsum('boj,bni->bno',W2,h)+b2[:,None]
    return ((pred-Y[None,:,:])**2).mean(axis=(1,2))

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

print('=== Regression MLP SGLD LLC (L-BFGS, normalized targets) ===')
print(f'Arch: {d_in}-{d_h}-{d_o} params={d} n=20')
t = gen_teacher()
X,Y = gen_data(t)
print(f'Y range: [{Y.min():.3f}, {Y.max():.3f}] std={Y.std():.3f}')

# L-BFGS optimization
r = default_rng(42)
th0 = r.normal(0,0.1,d)
res = minimize(loss_fn, th0, args=(X,Y), jac=loss_grad, method='L-BFGS-B',
               options={'maxiter':50000,'ftol':1e-20,'gtol':1e-15})
th = res.x
L0 = loss_fn(th,X,Y)
print(f'L-BFGS: L0={L0:.15f} grad_norm={np.linalg.norm(loss_grad(th,X,Y)):.2e} converged={res.success}')
if L0 > 1e-6:
    print(f'WARNING: L0={L0:.10f} not zero! Trying multiple restarts...')
    for restart in range(10):
        th0 = r.normal(0,0.1,d)
        res2 = minimize(loss_fn, th0, args=(X,Y), jac=loss_grad, method='L-BFGS-B',
                       options={'maxiter':50000,'ftol':1e-20,'gtol':1e-15})
        if loss_fn(res2.x,X,Y) < L0:
            th = res2.x
            L0 = loss_fn(th,X,Y)
            print(f'  Restart {restart}: L0={L0:.15f}')
            if L0 < 1e-10:
                break

print(f'\nFinal L0={L0:.15f}')
print('\n## RWMH LLC')
ts = [0.001,0.002,0.005,0.01,0.02]
lc,vs = rwmh(th,X,Y,ts)
print(f'RWMH LLC median = {lc:.4f}')
print(f'\n=== Summary ===')
print(f'Params={d} n=20 LLC={lc:.4f} params/2={d/2:.1f}')
print(f'Singular? {"YES" if lc < d/2 * 0.5 else "NO/MILD"}')
print('=== DONE ===')
