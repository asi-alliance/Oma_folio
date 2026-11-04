#!/usr/bin/env python3
import itertools, random

def brute_complete(args, attacks):
    attackers = {v: [] for v in args}
    for a, b in attacks: attackers[b].append(a)
    out = []
    for assign in itertools.product((1, -1, 0), repeat=len(args)):
        lab = dict(zip(args, assign))
        ok = True
        for v in args:
            att = attackers[v]
            if lab[v] == 1:
                if any(lab[u] != -1 for u in att): ok = False; break
            elif lab[v] == -1:
                if not any(lab[u] == 1 for u in att): ok = False; break
            else:
                if all(lab[u] == -1 for u in att) or any(lab[u] == 1 for u in att): ok = False; break
        if ok: out.append(tuple(lab[v] for v in args))
    return set(out)

def sheaf_h0(args, attacks):
    cf = []
    for assign in itertools.product((1, -1, 0), repeat=len(args)):
        lab = dict(zip(args, assign))
        if all(not (lab[a] == 1 and lab[b] == 1) for (a, b) in attacks):
            cf.append(lab)
    h0 = []
    for lab in cf:
        ok = True
        for v in args:
            att = [u for (u, w) in attacks if w == v]
            if lab[v] == 1 and any(lab[u] != -1 for u in att): ok = False; break
            if lab[v] == -1 and not any(lab[u] == 1 for u in att): ok = False; break
            if lab[v] == 0 and (all(lab[u] == -1 for u in att) or any(lab[u] == 1 for u in att)): ok = False; break
        if ok: h0.append(tuple(lab[v] for v in args))
    return set(h0)

random.seed(42)
trials, mismatch = 200, 0
for t in range(trials):
    n = random.randint(2, 7)
    args = list(range(n))
    m = random.randint(0, n * 2)
    attacks = set()
    guard = 0
    while len(attacks) < m and guard < 200:
        a, b = random.randint(0, n - 1), random.randint(0, n - 1)
        if a != b: attacks.add((a, b))
        guard += 1
    bc = brute_complete(args, attacks)
    sh = sheaf_h0(args, attacks)
    if bc != sh:
        mismatch += 1
        if mismatch <= 3:
            print("MISMATCH n=%d attacks=%s brute=%d sheaf=%d" % (n, sorted(attacks), len(bc), len(sh)))
print("trials=%d mismatches=%d" % (trials, mismatch))
