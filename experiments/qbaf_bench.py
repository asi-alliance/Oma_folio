# OP1 for Synthesis #847: QBAF gradual fixed point vs graded-sheaf H0 sections.
# Design: grid G={0,.25,.5,.75,1}; brute H0 = grid sections satisfying
# D3/D4 edge constraints (sup: s(v)>=s(u); att: s(v)<=1-s(u)) AND D5 gluing
# (weighted-sum Agg: s(v)=clamp(b(v)+sum_sup s(u)-sum_att s(u))).
# Dynamics: Jacobi fixed-point iteration of the Agg map, tol 1e-9, max 1000.
# Tests C1: is the fixed point a section (edge_ok + in brute H0)?
import random, itertools

G = [0.0, 0.25, 0.5, 0.75, 1.0]

def clamp(x): return max(0.0, min(1.0, x))

def gen_qbaf(rng, n):
    args = list(range(n))
    att = [(u, v) for u in args for v in args if u != v and rng.random() < 0.25]
    sup = [(u, v) for u in args for v in args if u != v and rng.random() < 0.25]
    b = {v: rng.choice(G) for v in args}
    return args, att, sup, b

def update(s, args, att, sup, b):
    s2 = {}
    for v in args:
        val = b[v] + sum(s[u] for (u, w) in sup if w == v) - sum(s[u] for (u, w) in att if w == v)
        s2[v] = clamp(val)
    return s2

def fixpoint(args, att, sup, b, tol=1e-9, maxit=1000):
    s = dict(b)
    for _ in range(maxit):
        s2 = update(s, args, att, sup, b)
        if all(abs(s2[v] - s[v]) < tol for v in args):
            return s2
        s = s2
    return None

def edge_ok(lab, att, sup):
    for (u, v) in sup:
        if lab[v] < lab[u]: return False
    for (u, v) in att:
        if lab[v] > 1 - lab[u]: return False
    return True

def glue_ok(lab, args, att, sup, b):
    for v in args:
        val = b[v] + sum(lab[u] for (u, w) in sup if w == v) - sum(lab[u] for (u, w) in att if w == v)
        if abs(clamp(val) - lab[v]) > 1e-9: return False
    return True

random.seed(42)
trials, mism, noconv, edgeviol, h0_sizes = 200, 0, 0, 0, []
for t in range(trials):
    n = random.randint(2, 7)
    args, att, sup, b = gen_qbaf(random, n)
    fp = fixpoint(args, att, sup, b)
    h0 = []
    for assign in itertools.product(G, repeat=n):
        lab = dict(zip(args, assign))
        if edge_ok(lab, att, sup) and glue_ok(lab, args, att, sup, b):
            h0.append(assign)
    h0_sizes.append(len(h0))
    if fp is None:
        noconv += 1
        continue
    if not edge_ok(fp, att, sup):
        edgeviol += 1
        continue
    rounded = tuple(min(G, key=lambda g: abs(g - fp[v])) for v in args)
    if rounded not in h0:
        mism += 1
print(f"trials={trials} noconv={noconv} edge_violations={edgeviol} h0_mismatch={mism}")
print(f"h0 sizes: min={min(h0_sizes)} max={max(h0_sizes)} mean={sum(h0_sizes)/len(h0_sizes):.1f}")
