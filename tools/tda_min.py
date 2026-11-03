import numpy as np
from itertools import combinations
import random
random.seed(42)
n = 32
X = np.random.rand(n, 15)
norms = np.linalg.norm(X, axis=1, keepdims=True)
norms[norms==0] = 1
Xn = X / norms
S = Xn @ Xn.T
D = 1 - S
edges = [(D[i,j],i,j) for i in range(n) for j in range(i+1,n)]
edges.sort()
par = list(range(n))
def find(x):
    while par[x]!=x:
        par[x]=par[par[x]]
        x=par[x]
    return x
def uni(x,y):
    px,py=find(x),find(y)
    if px!=py:
        par[px]=py
        return True
    return False
b0=[]
par=list(range(n))
comps=n
ei=0
for t in np.linspace(0,1.0,50):
    while ei<len(edges) and edges[ei][0]<=t:
        d,i,j=edges[ei]
        if uni(i,j): comps-=1
        ei+=1
    b0.append(comps)
h1c=0
for i,j,k in combinations(range(n),3):
    if D[i,j]<0.5 and D[j,k]<0.5 and D[i,k]<0.5:
        h1c+=1
merges=[]
par=list(range(n))
for d,i,j in edges:
    if uni(i,j): merges.append((d,i,j))
print(n)
print(b0[::5])
print(h1c)
print(round(D.min(),4), round(D.max(),4))
for d,i,j in merges[:5]:
    print(round(d,4), i, j)
for d,i,j in merges[-3:]:
    print(round(d,4), i, j)