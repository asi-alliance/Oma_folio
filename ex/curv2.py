import torch as t
t.set_num_threads(1)
t.manual_seed(7)
ce = t.nn.CrossEntropyLoss(label_smoothing=0.1)
X = t.randint(0, 2, (64, 3)).float()
Y = X.prod(dim=1).long()

def flat(m):
    return t.cat([p.detach().flatten() for p in m.parameters()])

def unflat(m, v):
    i = 0
    for p in m.parameters():
        n = p.numel()
        p.data.copy_(v[i:i+n].view(p.shape))
        i += n

def train(m, steps=2000, lr=0.05):
    opt = t.optim.Adam(m.parameters(), lr=lr)
    for k in range(steps):
        opt.zero_grad()
        L = ce(m(X), Y)
        L.backward()
        opt.step()
        if L.item() < 1e-6 and k > 500:
            break
    return m

def curv(m, K=20, eps=1e-3):
    v0 = flat(m)
    L0 = ce(m(X), Y).item()
    tot = 0.0
    mx = 0.0
    for k in range(K):
        t.manual_seed(100 + k)
        d = t.randn(v0.numel())
        d = d / d.norm()
        unflat(m, v0 + eps * d)
        Lp = ce(m(X), Y).item()
        unflat(m, v0 - eps * d)
        Lm = ce(m(X), Y).item()
        c = (Lp + Lm - 2 * L0) / (eps * eps)
        tot += c
        mx = max(mx, c)
    unflat(m, v0)
    return tot / K, mx

mono = train(t.nn.Sequential(t.nn
.Linear(3, 16), t.nn.ReLU(), t.nn.Linear(16, 16), t.nn.ReLU(), t.nn.Linear(16, 2)))
mc, mm = curv(mono)
print("mono_curv_mean %.4f mono_curv_max %.4f" % (mc, mm))

class Dec(t.nn.Module):
    def __init__(self):
        super().__init__()
        self.s1 = t.nn.Sequential(t.nn.Linear(3, 16), t.nn.ReLU())
        self.s2 = t.nn.Sequential(t.nn.Linear(16, 16), t.nn.ReLU(), t.nn.Linear(16, 2))
    def forward(self, x):
        return self.s2(self.s1(x))

dec = Dec()
h1 = t.nn.Linear(16, 2)
opt1 = t.optim.Adam(list(dec.s1.parameters()) + list(h1.parameters()), lr=0.05)
for k in range(2000):
    opt1.zero_grad()
    L = ce(h1(dec.s1(X)), Y)
    L.backward()
    opt1.step()
    if L.item() < 1e-6 and k > 500:
        break
opt2 = t.optim.Adam(dec.s2.parameters(), lr=0.05)
for k in range(2000):
    opt2.zero_grad()
    L = ce(dec.s2(dec.s1(X).detach()), Y)
    L.backward()
    opt2.step()
    if L.item() < 1e-6 and k > 500:
        break
dc, dmx = curv(dec)
print("dec_curv_mean %.4f dec_curv_max %.4f" % (dc, dmx))
