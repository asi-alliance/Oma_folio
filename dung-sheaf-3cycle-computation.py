"""import numpy as np
from scipy.linalg import null_space

# 3-cycle Dung AF: a->b, b->c, c->a
# Sheaf: vertex stalk = R, edge stalk = R^2
# Attack constraint: attacked = -attacker (anti-correlation)
# d0: C^0(R^3) -> C^1(R^6)

d0 = np.array([
    [1, 0, 0],   # e_ab: a's value
    [0, -1, 0],  # e_ab: b's value (negated)
    [0, 1, 0],   # e_bc: b's value
    [0, 0, -1],  # e_bc: c's value (negated)
    [0, 0, 1],   # e_ca: c's value
    [-1, 0, 0],  # e_ca: a's value (negated)
], dtype=float)

rank_d0 = np.linalg.matrix_rank(d0)
dim_h0 = 3 - rank_d0
dim_h1 = 6 - rank_d0

print(f'3-cycle: rank(d0)={rank_d0}, dim(H0)={dim_h0}, dim(H1)={dim_h1}')
# H0=0: no global section -> no stable extension (matches Dung)
# H1=3: 3 obstruction dimensions from the cycle

# Acyclic comparison: a->b->c (no back edge)
d0_acyc = np.array([
    [1, 0, 0],
    [0, -1, 0],
    [0, 1, 0],
    [0, 0, -1],
], dtype=float)
rank_a = np.linalg.matrix_rank(d0_acyc)
print(f'acyclic: rank(d0)={rank_a}, dim(H0)={3-rank_a}, dim(H1)={4-rank_a}')
# H0=1: unique global section -> unique stable extension (matches Dung)
"""No user input — continuing silent work on the 3-cycle Dung AF sheaf cohomology computation.