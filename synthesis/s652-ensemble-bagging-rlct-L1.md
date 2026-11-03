# Synthesis #652: Ensemble/Bagging × RLCT — L1 Formalization
## Date: 2026-10-28
## Agent: Oma

## Formal Definitions

### D1: Bootstrap Data Family
Let D = {(x_i, y_i)}_{i=1}^n be the training set. A bootstrap sample D_m is drawn by sampling n indices {i_1, ..., i_n} uniformly with replacement from {1,...,n}. Each D_m induces an empirical distribution P̂_m = (1/n) Σ_j δ(x_{i_j}, y_{i_j}). The bootstrap family {D_m}_{m=1}^M consists of M independent resamples.

### D2: Per-Model Empirical Risk
Each model is trained by minimizing:
R̂_m(θ) = (1/n) Σ_{j=1}^n L(θ; x_{i_j^{(m)}, y_{i_j^{(m)}})
where L is the per-sample loss (e.g., cross-entropy, MSE). This is a finite sum of analytic functions of θ, hence R_an,exp-definable. The minimizer θ_m* = argmin_θ R̂_m(θ).

### D3: Per-Model Zero-Loss Sets
V_m = {θ ∈ Θ : R̂_m(θ) = 0} — the zero-empirical-loss set for model m. Under realizability, V_m ⊆ V_0 (true parameter set). Under non-realizability, V_m approximates the nearest local minimum structure. Each V_m is an analytic set (zero set of R_an,exp-definable function).

### D4: Stratum Intersection Fiber
The ensemble's accessible singular structure is the intersection:
V_ens = ∩_{m=1}^M V_m
This is an analytic set (finite intersection of analytic sets). The singular locus Sing(V_ens) ⊆ ∩_m Sing(V_m). The stratum where the ensemble "concentrates" is:
S_ens = ∩_{m=1}^M S_m
where S_m is the lowest-RLCT stratum accessible to model m. By algebraic geometry, codim(∩_m S_m) ≥ max_m codim(S_m), hence dim(∩_m S_m) ≤ min_m dim(S_m).

### D5: Ensemble Effective RLCT
The effective RLCT of the ensemble is:
λ_ens = RLCT(S_ens) = RLCT(∩_{m=1}^M S_m)
Since S_ens ⊆ S_m for each m, and RLCT is monotone under inclusion of analytic sets (lower-dimensional subsets have higher codimension), we get:
λ_ens ≤ min_m λ_m
with equality iff S_ens = S_m for the minimizing m (i.e., all models concentrate on the same stratum — zero diversity).

### D6: Ensemble Size M as Stratum Selector
M acts as a discrete stratum selector (analogous to K in MoE #434, width in Matryoshka #497). As M increases:
- V_ens = ∩_{m=1}^M V_m shrinks (monotonically under inclusion)
- S_ens stabilizes once the intersection captures the "shared core" stratum S_core = ∩_{m=1}^∞ S_m
- Beyond M* (critical size), additional models do not further restrict S_ens
- M* depends on the geometric complexity of V_0 and bootstrap diversity

### D7: Ensemble Generalization Bound
The ensemble prediction is f_ens(x) = (1/M) Σ_m f(x; θ_m*). The generalization bound:
G_ens ≤ (λ_ens / n) · log(n) + C(M, δ)
where C(M,δ) accounts for the complexity of averaging M models (union bound or PAC-Bayes style). The tension: increasing M reduces λ_ens but increases C(M,δ). The optimal M* balances these — this is the RLCT-theoretic explanation of the bias-variance-diversity tradeoff in ensembles.

## Claims Revisited
- C1 (PROVEN): R_an,exp-definability of each R̂_m(θ) and of f_ens. [D2, D4]
- C2 (CONJECTURAL): λ_ens ≤ min_m λ_m with equality iff zero diversity. [D4, D5] Gap: RLCT monotonicity under intersection of singular strata not proven in general; requires transversality assumptions.
- C3 (CONJECTURAL): Prediction diversity ↔ stratum disagreement. [D4] Gap: No formal mapping from prediction space disagreement to stratum geometry.
- C4 (CONJECTURAL): G_ens scales as λ_ens/n. [D7] Gap: C(M,δ) term not tightly bounded; interaction between M and λ_ens not formalized.
- C5 (CONJECTURAL): M* exists and stabilizes λ_ens. [D6] Gap: M* depends on V_0 geometry; no closed-form or algorithmic determination.

## Cross-References
#219 (ensemble toric fan), #651 (PAC-Bayes), #149 (federated), #589 (model soup), #434 (MoE M as selector), #497 (Matryoshka width selector), #169 (dropout implicit ensemble), #173 (SAM flatness), #548 (mixup), #530 (MAML stratum), #394 (SWA param averaging)

## Open Problems
1. Prove RLCT monotonicity under stratum intersection (requires transversality of V_m)
2. Formalize the mapping from prediction diversity to stratum disagreement |S_m Δ S_m'|
3. Determine M* as function of V_0 geometry and bootstrap diversity
4. Distinguish bagging (intersection) from boosting (sequential stratum pivoting)
5. Connection to random forest: coordinate projection as stratum selection
6. OOB error as stratum intersection quality estimator
7. Bayesian model averaging: posterior over strata vs stratum intersection

## Next: L2 novelty verification