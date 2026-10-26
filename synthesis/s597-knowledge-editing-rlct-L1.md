# Synthesis #597: Knowledge Editing (ROME/MEMIT) × RLCT — L1 Formalization

**Date:** 2026-10-25
**Status:** L1 — Formal Definitions
**Prereq:** L0 (s597-knowledge-editing-rlct-L0.md, verified)

## Formal Definitions

### D1: ROME Rank-One Edit
Let W_l in R^{m*n} be the weight matrix of MLP layer l. A ROME edit for (subject s, relation r, object o) computes:
  W'_l = W_l + (v - W_l k*)k*^T / (k*^T k*)
where k* = layer-l hidden representation of subject prompt, v = target hidden representation.
The edit operator E_ROME: (W_l, k*, v) -> W'_l = W_l + ab^T where a = (v - W_l k*), b = k*/(k*^T k*).
This is polynomial (degree 1) in (W_l, a, b), hence algebraic.

### D2: MEMIT Batch Edit
For N edits {(s_i, r_i, o_i)}_{i=1}^N, MEMIT applies:
  W'_l = W_l + dW where dW = (V - W_l K*)K*^T(K*^T K*)^{-1}
K* = [k*_1 | ... | k*_N] in R^{n*N}, V = [v_1 | ... | v_N] in R^{m*N}.
dW = AB^T where A = (V - W_l K*) in R^{m*N}, B = K*(K*^T K*)^{-1} in R^{n*N}.
rank(dW) = r_eff <= min(N, m, n). Polynomial in all variables.

### D3: Edited Loss Function
The edited loss L_edit(theta, W'_l) = E_{(x,y)~D}[CE(f(x; theta, W'_l), y)] where W'_l = W_l + dW.
Since dW is polynomial in (W_l, K*, V) and CE is R_an,exp, the composition L_edit is R_an,exp-definable.

### D4: Patched Singular Fiber
Define V_0(W_l) = {theta : L(theta, W_l) = 0} the original zero-loss variety.
The edited zero-loss variety V_0(W'_l) = {theta : L(theta, W_l + dW) = 0}.
The patched fiber is V_patch = V_0(W_l) intersect V_0(W'_l) (consistency constraint).
The edit locus is the parameter subspace {(theta, W_l) : W_l + ab^T = W'_l, L(theta, W'_l) = 0}.

### D5: Edit Rank as Stratum Selector
For MEMIT with N edits, r_eff = rank(dW) in {0, 1, ..., min(N, d)}.
The stratum S_r = {W'_l : rank(dW) = r} is an algebraic stratum (determinantal variety).
lambda(W'_l) as a function of r: lambda_r decreases with r (more constraints -> lower complexity) until r = d (full rank = retraining).

### D6: Edit Generalization Bound
G_edit(N) <= C * sqrt(lambda_edit(N) * d_eff(N) / n)
where lambda_edit(N) = RLCT of V_0(W'_l) restricted to edit-relevant data, d_eff(N) = effective dimension of edit stratum.

### D7: Edit Stability via Transversality
Edit is stable iff T_{W'_l}V_0(W'_l) transverse to T_{W_l}V_0(W_l) at the edit locus (transversality condition).
Non-transverse: tangent intersection -> higher-order singularity -> lambda jumps -> forgetting.
Transversality test: local SGLD around W'_l reveals lambda_local; stable edit has lambda_local approx lambda_orig.

## Claims

- **C1 (PROVEN):** L_edit is R_an,exp-definable. D3 shows composition of polynomial (D1/D2) with R_an,exp CE. QED
- **C2 (CONJECTURAL):** Patched singular fiber has codim-1 constraint. V_0(W_l) intersect V_0(W'_l) is codim-1 generically (single rank-one constraint). lambda_edit <= lambda_orig.
- **C3 (CONJECTURAL):** lambda_MEMIT(N) scales with r_eff. Subadditive for orthogonal edits. Saturates at N* where r_eff = d.
- **C4 (CONJECTURAL):** Edit capacity N* where lambda_edit(N*) = lambda_orig. Crossover generalization bound.
- **C5 (CONJECTURAL):** Edit stability = transversality of edit locus to V_0(W_l). SGLD-testable.

## Cross-References

#8 #16 #73 #100 #127 #178 #185 #190 #263 #350 #354 #502 #595 #596

Next: L2 novelty verification.