import numpy as np
from numpy.random import default_rng

def gen_teacher(s=123):
    r=default_rng(s)
    return (r.normal(0,1,(32,10)), r.normal(0,.1,32), r.normal(0,1,(1,32)), r.normal(0,.1,1))

def gen_data(t, n=200, s=999):
    r=default_rng(s); X=r.normal(0,1,(n,10)); W1,b1,W2,b2=t
    Y=np.maximum(X@W1.T+b1,0)@W2.T+b2
    return X,Y

def vloss(thetas, X, Y):
    W1=thetas[:,:320].reshape(-1,32,10); b1=thetas[:,320:352]
    W2=thetas[:,352:384].reshape(-1,1,32); b2=thetas[:,384:385]
    h=np.maximum(np.einsum('ni,bji->bnj',X,W1)+b1[:,None,:],0)
    pred=np.einsum('bnj,boj->bn',h,W2)+b2
    return ((pred-Y[None,:])**2).mean(axis=1)

def train(X,Y,seed=42,lr=.02,epochs=3000):
    r=default_rng(seed); th=r.normal(0,.5,385)
    for ep in range(epochs):
        W1=th[:320].reshape(32,10); b1=th[320:352]; W2=th[352:384].reshape(1,32); b2=th[384]
        h=np.maximum(X@W1.T+b1,0); p=h@W2.T+b2
        err=p-Y; g2=err.mean(); gW2=(err*h).mean(0).reshape(1,32); gb2=g2
        dh=(err@W2)*(h>0); gW1=(dh.T@X)/len(X); gb1=dh.mean(0)
        th[:320]-=lr*gW1.ravel(); th[320:352]-=lr*gb1; th[352:384]-=lr*gW2.ravel(); th[384]-=lr*gb2
        if ep%2000==0: lr*=.5
    return th

def vslc(th,X,Y,n=3000,scale=0.01):
    d=len(th); l0=float(vloss(th[None,:],X,Y)[0])
    deltas=default_rng(77).normal(0,scale,(n,d))
    losses=vloss(th[None,:]+deltas,X,Y)
    ls=np.sort(losses); betas=np.linspace(ls[10]-l0,ls[int(n*.5)]-l0,20)
    counts=np.array([np.sum(losses<l0+b) for b in betas],dtype=float)
    mask=(counts>10)&(counts<n*.99)
    if np.sum(mask)<4: return 0.0,l0
    slope=np.polyfit(np.log(betas[mask]),np.log(counts[mask]+.1),1)[0]
    return (d/slope if slope>0 else 0.0),l0

print('=== v14: Coupled vs Decoupled Perturbation ===')
X,Y = gen_data(gen_teacher())
print('Training student (10000 epochs)...')
th = train(X,Y,epochs=3000)
l0 = float(vloss(th[None,:],X,Y)[0])
print(f'Student: d={len(th)}, L0={l0:.6f}')

print('\nFull FT LLC...')
llc_f,_ = vslc(th,X,Y,n=3000,scale=0.01)
print(f'Full FT LLC={llc_f:.4f}')

print('\n=== Coupled vs Decoupled ===')
for rank in [4,16,32]:
    # Coupled: shared latent z, both layers get U1@z and U2@z
    r1=default_rng(100+rank)
    z=r1.normal(0,.01,rank); U1=r1.normal(0,1,(320,rank)); U2=r1.normal(0,1,(32,rank))
    c=th.copy(); c[:320]+=U1@z; c[352:384]+=U2@z
    llc_c,l0c = vslc(c,X,Y,n=3000,scale=0.01)

    # Decoupled: independent latents z1,z2
    r2=default_rng(200+rank)
    z1=r2.normal(0,.01,rank); z2=r2.normal(0,.01,rank)
    U1d=r2.normal(0,1,(320,rank)); U2d=r2.normal(0,1,(32,rank))
    d=th.copy(); d[:320]+=U1d@z1; d[352:384]+=U2d@z2
    llc_d,l0d = vslc(d,X,Y,n=3000,scale=0.01)

    print(f'rank={rank}: Coupled LLC={llc_c:.4f} (L0={l0c:.6f}), Decoupled LLC={llc_d:.4f} (L0={l0d:.6f})')

print('\n=== Summary ===')
print(f'Full FT LLC = {llc_f:.4f}')
print('If Coupled LLC > Decoupled LLC across ranks, coupling mechanism confirmed.')
print('=== DONE ===')