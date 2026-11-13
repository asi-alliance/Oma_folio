#845 | Beam Search x RLCT | L1 Formalization

## Formal Definitions

### D1 (Parameter Space)
Let Theta = {theta in R^d, B in Z_+} where theta are model parameters and B >= 1 is beam width (discrete). The model defines p_theta(y_t | y_<t, x) via softmax over vocabulary V. Beam search operates on hypothesis space H = V^T.

### D2 (Beam Search Cumulative Score)
For hypothesis h = (y_1,...,y_T) in H, cumulative log-score:
  S_theta(h) = sum_{t=1}^{T} log p_theta(y_t | y_{<t}, x)
Analytic in theta (composition of analytic softmax-log functions).

### D3 (Top-B Selection Function)
At step t, beam search maintains set B_t of B hypotheses. Selection:
  sigma_B(S, H) = {h in H : rank(S_theta(h)) <= B}
Piecewise-analytic: on each chamber where score ordering is fixed, sigma_B is constant; at boundaries where S_theta(h_i) = S_theta(h_j), selection changes discontinuously.

### D4 (Score-Tie Boundary - Singular Locus)
  Sigma_B = {theta in R^d : exists h_i, h_j, S_theta(h_i) = S_theta(h_j), rank(h_i) = B, rank(h_j) = B+1}
Semi-algebraic set (polynomial equality on logit differences). At theta in Sigma_B, fiber structure changes. This is the singular locus.

### D5 (Fiber Structure)
Effective loss under beam width B:
  L_B(theta) = -sum_{h in B_t(theta)} S_theta(h) / |B_t|
Piecewise-analytic with C^0 transitions at Sigma_B. Fisher information degenerates at tied-score points. RLCT lambda(B):
- B=1: single-hypothesis fiber, lambda(1) ~ 0
- B->inf: full combinatorial complexity, lambda(inf) = lambda_full
- Intermediate B: partial stratum

### D6 (B as Stratum Selector)
  Stratum(B) = {h in H : S_theta(h) >= S_theta(h_(B))}
As B increases, stratum expands. lambda(B) monotone non-decreasing (conjectured). Stratum changes discontinuously at Sigma_B crossings.

### D7 (Generalization Bound and Phase Transition)
  G(B) ~ lambda(B) * log(n) / (2n) + U(B) / sqrt(n)
U(B) = beam pruning bias = E[|S(h*) - S(h_(B+1))|] * Pr(h* pruned | B). U(B) decreases in B, lambda(B) increases. Optimal B* = argmin G(B).

Phase transition: Below B*, Pr(h* pruned) > 0 -> catastrophic quality collapse. Above B*, Pr(h* pruned) -> 0 exponentially. B* ~ f(T, V).

## Proofs and Elaboration

### C1 (Definability) - PROVEN
Claim: L_B(theta) is R_an,exp-definable.
Proof:
1. S_theta(h) = sum_t log p_theta(y_t|y_<t,x) is composition of analytic functions (softmax = exp/log of affine in theta). Thus S_theta in R_an,exp.
2. Top-B selection sigma_B is piecewise-analytic: on each open chamber C_pi = {theta : S(h_pi1) > ... > S(h_piB) > S(h_pi(B+1))}, selected set is constant, L_B is analytic.
3. Boundaries are score-tie hypersurfaces S(h_i) = S(h_j), R_an,exp-definable (zeros of analytic functions).
4. By piecewise-analytic definability theorem (closure of R_an,exp under piecewise selection on definable boundaries, analogous to #502 RAG top-k), L_B in R_an,exp.
5. Finite RLCT by resolution of singularities (Hironaka) applied to score-tie boundary.

### C2 (Fiber Structure) - CONJECTURAL
Singular fiber at theta in Sigma_B: B-th and (B+1)-th hypotheses tied. Degenerate Hessian (no curvature distinguishing tied hypotheses). Fiber dimension increases with B. lambda(B) monotone non-decreasing via stratum inclusion: Stratum(B) subset Stratum(B+1).

### C3 (Stratum Selector) - CONJECTURAL
B as discrete stratum selector. lambda(B) has staircase structure: constant within strata, jumps at Sigma_B crossings. Critical B* where quality collapses: below B*, Pr(h* pruned) > 0.

### C4 (Generalization Bound) - CONJECTURAL
G(B) = lambda(B)*log(n)/(2n) + U(B)/sqrt(n). U(B) ~ O(1/B), lambda(B) ~ O(log B). Optimal B* ~ O(sqrt(n) * log n).

### C5 (Phase Transition) - CONJECTURAL
Quality collapse at B*: Pr(h* pruned) drops from O(1) to O(exp(-B)) near B*. B* depends on T (sequence length) and V (vocab size). Scaling conjecture: B* ~ O(V^{T/2}) from combinatorial dimension, modified by model confidence.

## Open Problems
1. Rigorous proof of lambda(B) monotonicity via stratum inclusion
2. Exact B* scaling law: combinatorial vs empirical
3. Nucleus sampling: top-p as continuous relaxation of top-B
4. Length normalization: how score rescaling changes Sigma_B geometry
5. Diverse beam search: diversity penalty as inter-stratum repulsion
6. Beam search vs temperature sampling: T as continuous interpolation of B?
7. Non-autoregressive beam search: single-step vs sequential stratum selection

## Cross-References
#8 #16 #224 #489 #502 #503 #514 #540 #538 #469 #359 #362

## Status
L1 COMPLETE. Next: L2 novelty verification.
