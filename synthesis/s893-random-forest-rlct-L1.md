# Synthesis #893: Random Forest × RLCT — L1 Formalization

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L1 (formal definitions, pre-proof)
**Builds on:** #893 L0 | **Distinct from:** #877 (single DT), #652 (bagging w/o feature subsampling), #892 (sequential GBM)

---

## Definitions

### D1: Random Forest Parameter Space

A random forest with B trees, each of depth D, trained on bootstrap samples of size n from data {(x_i, y_i)}_{i=1}^n, x_i ∈ ℝ^d, y_i ∈ {1,...,K}, with feature subsampling rate m ∈ {1,...,d} (mtry), is parameterized by:

W_RF = {Θ_b}_{b=1}^B × {S_b}_{b=1}^B × {Π_b}_{b=1}^B

where for each tree b:
- Θ_b = (σ_b, θ_b, c_b): structure, thresholds, leaf predictions (as in #877 D1)
  - σ_b ∈ {1,...,d}^{2^D-1}: feature index at each internal node (but restricted to Π_b)
  - θ_b ∈ ℝ^{2^D-1}: split thresholds
  - c_b ∈ ℝ^{2^D}: leaf predictions
- S_b ⊂ {1,...,n}: bootstrap sample indices, |S_b| = n
- Π_b = (π_{b,1},...,π_{b,2^D-1}): feature subset assignments, each π_{b,k} ∈ {J ⊂ {1,...,d} : |J| = m}

Dimension per tree: d_DT = 2^{D+1} - 1 (continuous params). Total continuous dimension: d_RF = B·(2^{D+1} - 1).

The RF prediction (classification via majority vote or regression via averaging):

F_B(x) = (1/B) Σ_{b=1}^B T_{θ_b}(x | S_b, Π_b)

### D2: RF Empirical Loss

The training loss over the full dataset:

L_RF(w) = (1/n) Σ_{i=1}^n ℓ(y_i, F_B(x_i))

where ℓ is a differentiable analytic loss. For regression (squared error): ℓ(y, F) = (y - F)². For classification (logistic/cross-entropy): ℓ(y, F) = -log p_y(F) where p_y is the softmax.

Each tree T_{θ_b}(x) is piecewise constant in x (from #877 C1). The average F_B(x) is piecewise constant. For squared loss, L_RF is a piecewise-quadratic function of the leaf weights c = (c_1,...,c_B), and piecewise constant in the thresholds θ.

**C1 PROVEN (R_{an,exp}-definability):** Each tree T_{θ_b} is piecewise constant in x, with indicator functions 1[x_{i,j} ≤ θ_{b,j}] that are semialgebraic (hence in R_an). The bootstrap selection 1[i ∈ S_b] is a discrete constant. The feature subsampling restricts σ_b to Π_b but does not change the analytic structure of the indicators. The average F_B = (1/B)Σ T_{θ_b} is a finite sum of R_an-definable functions. For squared loss, ℓ(y, F) = (y-F)² is polynomial in F, so L_RF ∈ R_an. For cross-entropy loss, ℓ involves exp and log, requiring R_{an,exp}. In both cases, SLT applies.

### D3: Coordinate-Projected Singular Fiber

The singular fiber of the RF loss landscape:

V_RF = {w ∈ W_RF : K_RF(w) = K*_RF}

where K_RF(w) = L_RF(w) + (λ_reg/2)Σ_b ||c_b||² is the regularized loss (KL proxy).

For each tree b, define its individual fiber in the projected feature space:

V_b(π_b) = {θ_b, c_b : K_b(θ_b, c_b | S_b, π_b) = K*_b}

where K_b is the per-tree regularized loss on bootstrap sample S_b, using only features in π_b. This fiber lives in the m-dimensional projected subspace ℝ^m via the coordinate projection:

π_b: ℝ^d → ℝ^m, π_b(x) = (x_{j_1},...,x_{j_m}) for J_b = {j_1,...,j_m}

The ensemble fiber is the Cartesian product of per-tree fibers:

V_RF = V_1(π_1) × V_2(π_2) × ... × V_B(π_B)

**Key structural difference from #652 (bagging):** In bagging, all trees see the full feature space ℝ^d — the per-tree fibers V_b all live in the same d-dimensional space. In RF, each V_b lives in a *different* m-dimensional subspace determined by π_b. Two trees with disjoint feature subsets (π_b ∩ π_{b'} = ∅) have fibers in orthogonal subspaces — their singularities do not interact.

### D4: Feature Subsampling as Stratum Selector

The mtry parameter m ∈ {1,...,d} acts as a discrete stratum selector. Define the family:

{K_RF(·; m)}_{m=1}^d

For fixed B and D:

- **m = d (full features):** Each tree sees all d features. This reduces to standard bagging (#652). Per-tree fiber dimension = d_DT = 2^{D+1}-1. Trees are highly correlated → ensemble fiber ≈ single tree fiber. λ_RF ≈ λ_DT (from #877).

- **m = 1 (single feature per split):** Each tree is a decision stump on one feature per node. Per-tree fiber dimension ≈ 2 (one threshold + one leaf). Trees are maximally decorrelated → ensemble fiber = product of B near-orthogonal 1D fibers. λ_RF ≈ B · λ_stump where λ_stump ~ 1/2 (single A_1 fold singularity).

- **m = m* (critical):** Balance between individual tree complexity and ensemble decorrelation. The per-tree fiber dimension is O(m·2^D), but the intersection structure across B trees with different projections creates a *smaller* effective singular set than B·λ_DT.

**C3 CONJECTURAL:** The effective RLCT λ_RF(m, B, D) satisfies:
- λ_RF(d, B, D) ≈ λ_DT(D) (bagging limit, trees correlated)
- λ_RF(1, B, D) ≈ B/2 (stump limit, B independent fold singularities)
- λ_RF(m, B, D) decreases monotonically in m for fixed B, D — more subsampling = simpler per-tree fibers = lower λ per tree, but more trees needed for coverage

The monotonicity is conjectural because decreasing m also *increases* the number of distinct feature projections C(d,m), potentially creating new intersection singularities.

### D5: Decorrelation-Induced Singularity Reduction

Define the correlation coefficient between trees b and b':

ρ_{bb'} = Corr[T_{θ_b}(X), T_{θ_{b'}}(X)] over the data distribution

For bagging (m=d): ρ_{bb'} is high (both trees can use the same features → similar splits)
For RF (m < d): ρ_{bb'} decreases because trees are forced to use different features

**C2 CONJECTURAL:** The ensemble RLCT is bounded by:

λ_RF(m, B, D) ≤ B · λ_DT(D, m) · (1 + Σ_{b≠b'} ρ_{bb'}) / B²

where λ_DT(D, m) is the per-tree RLCT with m features (from #877, scaled to m dimensions). The correlation factor (1 + Σρ)/B² captures how much the fibers overlap:

- ρ → 1 (bagging): λ_RF ≈ λ_DT (fibers coincide, B trees = 1 tree)
- ρ → 0 (decorrelated): λ_RF ≈ B · λ_DT / B = λ_DT (fibers independent, averaging cancels singularities)
- ρ → 1/B (critical): λ_RF ≈ 2·λ_DT (transition zone)

Wait — this bound suggests λ_RF ≤ λ_DT in both extremes, which is the *desingularization* effect of ensembling. The intermediate regime (m*) is where λ_RF is minimized — consistent with the empirical finding that RF outperforms both single trees and fully decorrelated stumps.

### D6: Generalization Bound

**C4 CONJECTURAL:** The generalization error for RF satisfies:

G(m, B, D, n) ≤ (λ_RF(m, B, D) / (2n)) · log(n) + Q(m, B, D, n)

where:
- λ_RF(m, B, D) is the effective RLCT from D5
- Q(m, B, D, n) = C · (d·C(d,m)^D·B) / n is the complexity penalty from feature subset combinatorics
  - C(d,m) = (d choose m) = d!/(m!(d-m)!) is the number of possible m-subsets per split
  - C(d,m)^D is the number of possible feature-subset assignments per tree
  - C(d,m)^{D·B} is the total combinatorial complexity across B trees

The tradeoff:
- Small m: λ_RF small (simple trees) but Q large (many subset combinations C(d,m) grows with... actually C(d,m) is maximized at m=d/2)

Correction: C(d,m) = (d choose m) is *maximized* at m = d/2, not at small m. So:

- m = 1: C(d,1) = d (small), λ_RF small, Q ~ d^D·B/n (moderate)
- m = d/2: C(d,d/2) ~ 2^d/sqrt(d) (huge), λ_RF moderate, Q enormous
- m = d: C(d,d) = 1 (trivial), λ_RF = λ_DT (large), Q ~ B/n (small)

The optimal m* minimizes λ_RF·log(n)/(2n) + Q. The minimum is NOT at m=d/2 (where Q explodes) but at small m where Q is manageable and λ_RF is reduced. This is consistent with Breiman's heuristic m* ≈ d/3 for classification.

### D7: Phase Transition at Critical mtry

**C5 CONJECTURAL:** The phase transition occurs at m* where the decorrelation benefit saturates:

m* ≈ ⌈d/3⌉ (classification), m* ≈ ⌈d⌉ (regression — Breiman's heuristic)

- **Above m* (m > m*):** Trees are highly correlated (ρ → 1). Ensemble fiber ≈ single tree fiber. Adding more trees (increasing B) does not reduce λ_RF — the singularities persist because all trees see the same informative features. λ_RF ≈ λ_DT(D).

- **At m*:** Critical decorrelation. The coordinate-projected fibers V_b(π_b) begin to diverge — different trees optimize over different feature subspaces, so their kink singularities (from #877 D3) occur at *different* thresholds in *different* features. The intersection V_RF = ∩ V_b becomes much smaller than any individual V_b.

- **Below m* (m < m*):** Trees are decorrelated but individually weak (high bias). Each tree's fiber is simple (few features → few kinks → low λ_DT(D,m)). But the ensemble's approximation error increases because no single tree can capture complex interactions. The RLCT is low but the irreducible error is high.

**Connection to #877 D7 (DT depth transition):** The RF m* transition is dual to the DT D* transition:
- DT: D* ≈ log_2(n) — transition from informative to degenerate singularities as depth increases
- RF: m* ≈ d/3 — transition from correlated to decorrelated fibers as feature subsampling increases

Both are *stratum selector* phase transitions where the loss landscape geometry changes qualitatively at a critical parameter value.

## Claim Summary

| Claim | Description | Status | Key Evidence |
|-------|-------------|--------|-------------|
| C1 | R_{an,exp}-definability of RF loss | PROVEN | Piecewise constant trees + analytic loss → R_an (Gini) or R_{an,exp} (cross-entropy) |
| C2 | Decorrelation-induced desingularization bound | CONJECTURAL | Correlation-weighted fiber intersection; ρ→0 cancels singularities |
| C3 | mtry as stratum selector, λ_RF monotone in m | CONJECTURAL | Fiber dimension scales with m; C(d,m) interaction complicates monotonicity |
| C4 | Gen bound λ_RF·log(n)/(2n) + Q(m,B,D,n) | CONJECTURAL | SLT bound + combinatorial complexity from feature subsets |
| C5 | Phase transition at m* ≈ d/3 | CONJECTURAL | Breiman heuristic = fiber decorrelation saturation point |

## Open Problems

1. Rigorous computation of λ_RF(m,B,D) — requires resolution of singularities for products of coordinate-projected fiber intersections. Does the product structure V_RF = ∏ V_b simplify the calculation?
2. Is the decorrelation bound (C2) tight? Can ρ_{bb'} be computed in closed form for axis-aligned trees?
3. Does the C(d,m) combinatorial complexity in Q truly peak at m=d/2, or does the effective complexity differ from the combinatorial count because many subsets yield equivalent trees?
4. Interaction between bootstrap noise (#652) and feature subsampling — are the noise effects additive on λ_RF, or multiplicative?
5. Extension to Extremely Randomized Trees (Extra Trees): random thresholds + random features. Does random threshold selection create additional A_1 singularities or smooth existing ones?
6. Feature importance as fiber sensitivity: Var[T_{θ_b}(X) | remove feature j] vs RLCT contribution of feature j. Do these agree?
7. Can SGLD with continuous relaxation of split indicators (straight-through estimator, #354) estimate λ_RF empirically? The discrete structure (bootstrap, feature subsets) poses challenges.
8. Does the phase transition m* shift with B (number of trees)? More trees may allow smaller m while maintaining coverage.

## Cross-References

- #877 (Decision Tree): Base learner — single tree kink singularities at A_1, depth D* ≈ log_2(n) transition. RF composes B such trees with coordinate projection.
- #652 (Ensemble/Bagging): Parallel independent fiber intersection in full ℝ^d. RF = bagging + feature subsampling = coordinate projection added. RF generalizes bagging (m=d → bagging).
- #846 (AdaBoost): Sequential ensemble with reweighting. Different fiber conditioning (path-dependent vs parallel).
- #892 (Gradient Boosting): Sequential path-dependent fiber with shrinkage ν. RF is parallel with feature projection m. Different stratum selectors.
- #371 (Dropout): Feature dropout in neural nets vs feature subsampling in RF — both create stochastic subnetworks with projected parameter spaces.
- #383 (Data Pruning): Bootstrap = data subsampling; mtry = feature subsampling — dual stratum restriction.
- #354 (STE): Continuous relaxation needed for SGLD estimation of λ_RF on discrete tree parameters.
- #491 (Grokking): Phase transition methodology — m* is the RF analog of grokking transition.
- #504 (MoE): Gating = feature-based routing; RF feature subsampling = feature-based projection. Both restrict which parameters are active for which inputs.

---
*Next: L2 novelty verification via websearch.*