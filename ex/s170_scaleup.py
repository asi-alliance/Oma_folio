import torch as t, math, copy; t.set_num_threads(3); ce=t.nn.CrossEntropyLoss(label_smoothing=0.1); t.manual_seed(7)
X=t.randint(0,2,(64,3)).float(); Y=X.prod(1).long()
def mono(): return t.nn.Sequential(t.nn.Linear(3,16), t.nn.ReLU(), t.nn.Linear(16,16), t.nn.ReLU(), t.nn.Linear(16,2))
def step1(): return t.nn.Sequential(t.nn.Linear(3,8), t.nn.ReLU(), t.nn.Linear(8,4))
def step2(): return t.nn.Sequential(t.nn.Linear(4,2))
def train(m, steps=4000, lr=0.05):
    opt = t.optim.Adam(m.parameters(), lr=lr)
    for k in range(steps):
        opt.zero_grad(); L = ce(m(X), Y); L.backward(); opt.step()
        if k%200==0 and ce(m(X), Y).item() < 1e-6: break
def sgld_slope(m, eps=(0.004,0.008,0.016,0.032,0.064), steps=600, lr=0.02, temp=0.05):
    base=copy.deepcopy(m); pts=[]
    for e in eps:
        mb = copy.deepcopy(base); losses=[]
        for k in range(steps):
            for p in mb.parameters(): p.data += t.randn_like(p.data)*(lr*temp)
            L = ce(mb(X), Y); losses.append(L.item())
            L.backward()
            for p in mb.parameters(): p.data -= lr*p.grad
        pts.append((math.log(e), losses[-40:]))
    return pts
def run(seed):
    t.manual_seed(seed)
    m = mono(); train(m)
    s1 = step1(); train(s1)
    global X; Xs=X; X=s1(Xs).detach(); s2 = step2(); train(s2, steps=2000); X=Xs
    mono_pts = sgld_slope(m)
    class D(t.nn.Module):
        def forward(self, x): return s2(s1(x))
    d = D()
    dec_pts = sgld_slope(d)
    return mono_pts, dec_pts
for sd in (7, 42):
    mp, dp = run(sd)
    ms = [round(sum(x[1])/len(x[1]), 3) for x in mp]
    ds = [round(sum(x[1])/len(x[1]), 3) for x in dp]
    print("seed", sd, "mono", ms, "dec", ds)
