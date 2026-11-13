# Synthesis #893: Random Forest × RLCT — L0 Formalization

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L0 (initial formalization)

---

## Motivation

Random Forest (RF) combines bagging (#652) with decision tree base learners (#877) and adds a third structural element: **feature subsampling** (mtry). Each of B bootstrap trees sees only a random subset of mtry ≤ d features at each split. This creates a fundamentally new singular fiber geometry that neither bagging nor individual decision trees possess alone.

## Setup

Let X ∈ ℝ^d, Y ∈ {1,...,K}. A random forest with B trees, depth D, and feature subsampling rate mtry = m is:

F_B(x) = (1/B) Σ_{b=1}^{B} T_{θ_b}(x)

where each tree T_{θ_b} is trained on a bootstrap sample S_b of size n, and at each split only m features are considered. Each θ_b = (splits_b, leaves_b, feature-subsets_b).

## Claims

### C1 (PROVEN): RF Loss Is R_{an,exp}-Definable

**Claim:** The empirical loss L_n(θ_1,...,θ_B) = (1/n) Σ ℓ(y_i, (1/B)Σ T_{θ_b}(x_i)) is R_{an,exp}-definable.

**Reasoning:** Each tree T_{θ_b} is piecewise constant in x (from #877 C1). The average F_B is piecewise constant. The loss ℓ is analytic (squared error, logistic). Composition of analytic with piecewise-polynomial yields R_{an,exp}-definable function. The feature subsampling only restricts which dimensions appear in the split conditions — it does not introduce new analytic structure beyond what #877 already establishes. SLT applies.

### C2 (CONJECTURAL): Coordinate-Projected Singular Fiber

**Claim:** Feature subsampling at rate m creates coordinate-projected singular fibers. Each tree b sees only a random projection π_b: ℝ^d → ℝ^m selecting m coordinates. The singular fiber for tree b is W_b = {w: K_b(π_b(w)) = 0}, a fiber in the projected space. The ensemble fiber is:

W_RF = ∩_{b=1}^{B} π_b^{-1}(W_b)

This is the intersection of B coordinate-projected fibers, each living in a random m-dimensional subspace.

**Reasoning:** In #652 (bagging), each tree sees all d features — the fiber intersection is in full ℝ^d. In RF, each tree's fiber is projected to a random m-subspace. Singularities that depend on feature j are invisible to trees where j ∉ π_b. This creates a second-order singularity structure: not only are the trees bagged (bootstrap noise, #652), but their singular fibers are coordinate-projected (mtry noise). The projection reduces effective singularity dimension per tree, but the intersection across B trees with different projections recovers coverage.

### C3 (CONJECTURAL): mtry as Continuous Stratum Selector

**Claim:** mtry = m ∈ {1,...,d} is a stratum selector (discrete, but treatable as continuous via m/d ∈ [1/d, 1]):

- m = d: standard bagging fiber (#652) — all features visible to every tree
- m = 1: product of 1D fibers — each tree is a decision stump on a single feature, ensemble fiber = ∩ of 1D projections
- m = m*: critical transition where decorrelation sufficient for ensemble diversity

The effective RLCT λ_RF(m, B, D) interpolates between:
- λ_bagging (m=d) = λ_ens from #652
- λ_stump_product (m=1) = product of 1D kink singularities

**Reasoning:** m controls how much of the feature space each tree can see. Small m → trees are weak (low complexity, low individual RLCT) but decorrelated. Large m → trees are strong (high complexity, high individual RLCT) but correlated. The optimal m* balances individual complexity vs ensemble decorrelation — analogous to the bias-variance tradeoff but in RLCT terms.

### C4 (CONJECTURAL): Generalization Bound with Projection-Controlled Complexity

**Claim:** The generalization error satisfies:

G(m, B, D, n) ≤ (λ_RF(m,B,D) / (2n)) · log(n) + Q(m, B, D, n)

where Q(m,B,D,n) = O(d·C(m,d)·2^D·B/n) accounts for the combinatorial complexity of feature subsampling choices C(m,d) = (d choose m)^D·B.

**Reasoning:** Standard SLT bound with λ_RF, plus complexity term from the exponentially many feature-subset assignments. The projection C(m,d) grows with m (more subsets available), while λ_RF decreases with smaller m (simpler trees). The tradeoff creates an optimal m* minimizing the bound.

### C5 (CONJECTURAL): Phase Transition at Critical mtry*

**Claim:** As m decreases from d, a phase transition occurs at m* where ensemble decorrelation becomes sufficient. Above m*: trees highly correlated, ensemble fiber ≈ single tree fiber (λ_RF ≈ λ_DT). Below m*: trees decorrelated, ensemble fiber shrinks (λ_RF < λ_DT), kink singularities from #877 average out across B trees with different feature projections.

The critical m* ≈ d/3 (empirical heuristic from Breiman) should manifest as a kink in the LLC trajectory.

**Reasoning:** Breiman's heuristic m* ≈ d/3 for classification (d/1 for regression) corresponds to the point where the correlation between trees drops below a threshold where averaging becomes effective. In RLCT terms, this is where the coordinate-projected fibers become sufficiently "orthogonal" that their intersection is much smaller than any individual fiber.

## Open Problems

1. Formal calculation of λ_RF(m,B,D) via resolution of singularities for coordinate-projected fiber intersections
2. Does m* ≈ d/3 correspond to a measurable LLC phase transition?
3. Interaction between bootstrap noise (#652) and feature subsampling noise — additive or multiplicative on λ?
4. Extension to Extra Trees (random split thresholds + random features) — does random threshold add another stratum selector?
5. How does OOB (out-of-bag) estimation relate to fiber structure — does OOB error correlate with λ_RF?
6. Feature importance as fiber sensitivity: does the RLCT-based importance differ from Gini importance?
7. Can SGLD estimate λ_RF when tree parameters are discrete? Need continuous relaxation.

## Cross-References

- #877 (Decision Tree): Base learner — single tree kink singularities at A_1, depth D selector. RF composes B such trees with feature projection.
- #652 (Ensemble/Bagging): Parallel independent fiber intersection. RF = bagging + feature subsampling = coordinate projection added.
- #846 (AdaBoost): Sequential ensemble vs RF parallel. Different fiber conditioning.
- #892 (Gradient Boosting): Sequential path-dependent fiber vs RF parallel coordinate-projected fiber.
- #383 (Data Pruning): Bootstrap = data subsampling; mtry = feature subsampling — dual stratum restriction.
- #371 (Dropout): Feature dropout in neural nets vs feature subsampling in RF — both create stochastic subnetworks.
- #608 (Class Balancing): Per-class fiber structure — does RF preserve class-indexed fibers under feature projection?
- #504 (MoE): Gating = feature-based routing; RF feature subsampling = feature-based projection. Different stratum mechanisms.
