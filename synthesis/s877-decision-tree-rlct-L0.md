# Oma Synthesis #877: Decision Tree × RLCT

**Date:** 2026-11-09
**Status:** L0 draft
**Distinct from:** #846 (Boosting — sequential additive ensemble of weak learners; DT is a single tree with hierarchical splits, not additive weighted ensemble)

---

## Motivation

Decision trees (CART, C4.5) partition input space via axis-aligned splits into piecewise-constant regions. Unlike neural networks, the parameter space is partially discrete (split features, split thresholds are continuous but the tree structure is discrete). This creates a fundamentally different singularity structure: impurity minima at split boundaries, kink singularities at threshold transitions, and exponential growth of leaf regions with depth. No prior SLT/RLCT work covers decision trees. First non-NN model class in this catalog.

## Five Candidate Claims

### C1 (PROVEN): R_an-definability of impurity-based loss
**Claim:** The empirical loss L(θ) of a decision tree with fixed structure (feature indices, depth) is definable in R_an (sub-analytic, no exp needed).

**Proof sketch:** For fixed tree structure, L(θ) = Σ_{leaves ℓ} n_ℓ · Impurity(ℓ), where Impurity is Gini: 1 - Σ_c p_{ℓ,c}^2 or entropy: -Σ_c p_{ℓ,c} log p_{ℓ,c}. Each p_{ℓ,c} = (1/n_ℓ) Σ_{i∈ℓ} 1[y_i = c] — a ratio of indicator functions of the form 1[x_{i,j} ≤ θ_j] which are sub-analytic (semialgebraic via Tarski-Seidenberg). The sum over leaves and impurity computation are compositions of analytic and sub-analytic functions. For Gini, this is purely algebraic. For entropy, log requires R_an,exp but the tree loss is piecewise-polynomial in θ for Gini → R_an suffices.

### C2 (CONJECTURAL): Kink singularity at split boundaries — fold-type singularities
**Claim:** The loss surface has A_1 (fold) singularities along hypersurfaces where split thresholds pass through data points, creating discontinuous jumps in leaf assignments.

**Reasoning:** When a threshold θ_j crosses a data point x_{i,j}, the point migrates between leaves, causing a jump in n_ℓ and p_{ℓ,c} → discontinuous change in L(θ). The loss is piecewise-constant between these crossings, with A_1-fold-type singularities at each crossing hypersurface θ_j = x_{i,j}. The singular set is a union of hyperplanes in threshold space — a highly degenerate arrangement compared to smooth neural network singularities.

### C3 (CONJECTURAL): Tree depth D as stratum selector — exponential leaf count phase transition
**Claim:** The effective RLCT λ(D) increases with depth D, with a phase transition at D* where the number of leaves 2^D exceeds the sample size n.

**Reasoning:** For depth D, there are 2^D leaves. When 2^D << n, each leaf has sufficient statistics and impurity is well-defined → low λ. When 2^D > n, many leaves are empty or singletons (pure leaves, zero impurity) → the loss landscape becomes flat across many θ configurations (degenerate minima) → high λ from non-identifiability of split locations in empty regions. The critical depth D* ~ log_2(n) marks the transition from informative to degenerate singular structure.

### C4 (CONJECTURAL): Generalization bound with depth-dependent RLCT and overfitting penalty
**Claim:** The generalization error satisfies:
G(D, n) ≤ (λ(D) / (2n)) · log(n) + P(D, n)
where P(D, n) = O(2^D / n) is a complexity penalty from the exponentially growing hypothesis class.

**Reasoning:** Standard SLT bound applies with λ(D), but the discrete structure of the tree (exponentially many possible split configurations with depth) adds a model complexity term P(D,n). Below D*, λ(D) grows slowly and P is negligible. Above D*, both λ(D) and P(D,n) grow → U-shaped generalization curve, matching the empirical overfitting pattern.

### C5 (CONJECTURAL): Split ordering non-identifiability — permutation-invariant singular fiber
**Claim:** Swapping left/right subtrees at any internal node produces identical loss, creating a 2^(D) permutation-invariant singular fiber group that inflates the RLCT.

**Reasoning:** Each internal node has a left/right child assignment that is arbitrary — the tree is invariant under swapping children at any node. With D depth, there are 2^D internal nodes, each admitting a binary swap → 2^(2^D) equivalent configurations sharing the same loss value. This discrete symmetry group creates a large singular fiber, contributing to higher λ compared to models without this structural non-identifiability. Distinct from neural network weight permutation symmetries (continuous gauge group) — here the symmetry is discrete and exact.

## Open Problems

1. Formal connection between kink singularities and resolution of singularities for piecewise-constant functions
2. How does pruning interact with the D* phase transition — does it recover the pre-D* singularity structure?
3. Does the 2^(2^D) permutation fiber contribute additively or multiplicatively to λ?
4. Extension to random forests (#846-adjacent): does ensemble averaging desingularize the tree singularities?
5. Gini vs entropy impurity — does the log in entropy change the RLCT class (R_an vs R_an,exp)?
6. Interaction between continuous thresholds and discrete tree structure — mixed singularity analysis
7. Can SGLD on tree parameters (continuous relaxation of splits) estimate λ(D)?

## Cross-References

- #846 (Boosting): Sequential ensemble vs single tree — DT is base learner, not ensemble
- #268 (Mixture/EM): Latent variable non-identifiability analogy (leaf assignment as latent)
- #201 (Meta-learning): Task-dependent split structure
- #354 (STE): Continuous relaxation of discrete splits possible bridge
- #503 (Early Exit): Depth as stratum selector analogy
- #652 (Ensemble): Random forest extension
- #870 (GRPO): Discrete action space singularity
