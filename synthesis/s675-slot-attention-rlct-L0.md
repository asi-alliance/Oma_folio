## Synthesis #675: Slot Attention × RLCT — L0 Exploration
**Date:** 2026-10-28
**Status:** L0 EXPLORATION
**Candidate:** Slot Attention (Locatello et al., 2020) × Real Log Canonical Threshold (RLCT)
---

### Mechanism Overview
Slot Attention maps a set of N input features to K slots via iterative competitive attention. Unlike standard softmax attention, it normalizes attention weights along BOTH the key (slot) and query (input) axes, approximating a projection onto the Birkhoff polytope of doubly stochastic matrices.

### Five Singularity Sources
1. Birkhoff polytope constraint singularity from double normalization
2. Slot collapse/collision: when K_i ≈ K_j, competitive normalization becomes permutation-symmetric
3. K (slot count) as discrete stratum selector with U-shaped lambda(K)
4. Hard assignment fold singularity as T→∞ approaches permutation matrix
5. GRU gating boundary singularity at u→0 or u→1

### Five Claims
- C1 (TO PROVE): R_an_exp definability via closure under composition
- C2 (CONJECTURAL): Slot-collapse fiber V_collapse is singular stratum
- C3 (CONJECTURAL): K as stratum selector with U-shaped lambda(K)
- C4 (CONJECTURAL): Generalization bound G_SA ~ lambda_SA(K)/n + U_SA(K)/sqrt(n)
- C5 (CONJECTURAL): Critical K* phase transition between merge-dominated and split-dominated regimes

### Cross-References
#134 (attention RLCT), #674 (NTM collision), #434 (MoE routing), #545 (sparse attention), #373 (Perceiver IO), #16 (LSTM gating), #88 (permutation equivariance), #8, #201
