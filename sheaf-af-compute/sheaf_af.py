#!/usr/bin/env python3
"""
sheaf_af.py — Compute H^0 of cellular sheaf over Dung Argumentation Framework.

Sheaf construction:
  - Base space: attack graph (vertices = arguments, edges = attacks)
  - Stalks: {IN, OUT, UNDEC} (pointed set, UNDEC = basepoint)
  - Edge constraint (restriction): for attack (a,b), NOT(IN_a AND IN_b)
  - H^0 = global sections = complete labellings of the Dung AF
  - Stable extensions = complete labellings with no UNDEC

Usage:
  python sheaf_af.py "a->b,b->a"          # 2-cycle
  python sheaf_af.py "a->b,b->c,c->a"      # 3-cycle
  python sheaf_af.py --random 5 42         # random AF, 5 args, seed 42
"""

import sys
import itertools
from collections import defaultdict

IN, OUT, UNDEC = "IN", "OUT", "UNDEC"

def parse_af(spec):
    """Parse AF spec like 'a->b,b->c' into (args, attacks)."""
    args = set()
    attacks = []
    if not spec.strip():
        return args, attacks
    for pair in spec.split(","):
        a, b = pair.strip().split("->")
        args.add(a.strip())
        args.add(b.strip())
        attacks.append((a.strip(), b.strip()))
    return args, attacks

def random_af(n, seed):
    """Generate random AF with n arguments."""
    import random
    rng = random.Random(seed)
    args = [chr(ord('a') + i) for i in range(n)]
    attacks = []
    for i in range(n):
        for j in range(n):
            if i != j and rng.random() < 0.4:
                attacks.append((args[i], args[j]))
    return set(args), attacks

def conflict_free(labeling, attacks):
    """Check: no IN argument attacks another IN argument."""
    in_set = {a for a, l in labeling.items() if l == IN}
    for a, b in attacks:
        if a in in_set and b in in_set:
            return False
    return True

def is_complete(labeling, attacks, args):
    in_set = {a for a, l in labeling.items() if l == IN}
    out_set = {a for a, l in labeling.items() if l == OUT}
    if not conflict_free(labeling, attacks):
        return False
    attacked_by_in = {b for a, b in attacks if a in in_set}
    if out_set != attacked_by_in:
        return False
    for a in in_set:
        attackers = {src for src, tgt in attacks if tgt == a}
        if not attackers.issubset(out_set):
            return False
    for a in args:
        if a not in in_set:
            attackers = {src for src, tgt in attacks if tgt == a}
            if attackers and attackers.issubset(out_set):
                return False
    return True

def compute_h0(args, attacks):
    """
    Compute H^0 = global sections of the sheaf.
    Global section = labeling satisfying edge constraints (conflict-free)
    that is also complete under Dung semantics.
    
    Brute force over all 3^n labelings, filter for complete.
    """
    arg_list = sorted(args)
    n = len(arg_list)
    h0 = []
    for combo in itertools.product([IN, OUT, UNDEC], repeat=n):
        labeling = dict(zip(arg_list, combo))
        if is_complete(labeling, attacks, args):
            h0.append(labeling)
    return h0

def stable_extensions(h0):
    """Stable = complete labelings with no UNDEC."""
    return [lab for lab in h0 if UNDEC not in lab.values()]

def main():
    if "--random" in sys.argv:
        idx = sys.argv.index("--random")
        n = int(sys.argv[idx + 1])
        seed = int(sys.argv[idx + 2])
        args, attacks = random_af(n, seed)
    else:
        spec = sys.argv[1] if len(sys.argv) > 1 else ""
        args, attacks = parse_af(spec)

    if not args:
        print("No arguments. Usage: python sheaf_af.py 'a->b,b->a'")
        return

    print(f"Arguments: {sorted(args)}")
    print(f"Attacks: {attacks}")
    print(f"|Attacks|: {len(attacks)}")

    h0 = compute_h0(args, attacks)
    stable = stable_extensions(h0)

    print(f"\nH^0 (complete labellings): {len(h0)}")
    for i, lab in enumerate(h0):
        print(f"  [{i}] " + ", ".join(f"{a}={l}" for a, l in sorted(lab.items())))

    print(f"\nStable extensions (no UNDEC): {len(stable)}")
    for i, lab in enumerate(stable):
        ext = sorted(a for a, l in lab.items() if l == IN)
        print(f"  [{i}] {{{', '.join(ext)}}}")

    # Obstruction: if no stable extensions, H^1-like obstruction exists
    if len(stable) == 0 and len(h0) > 0:
        print("\n*** H^1 OBSTRUCTION: local consistency exists but no global stable resolution ***")
        print(f"  {len(h0)} complete labelings, all contain UNDEC — argumentation paradox")
    elif len(h0) == 0:
        print("\n*** H^0 = 0: no complete labelings (degenerate AF) ***")

if __name__ == "__main__":
    main()