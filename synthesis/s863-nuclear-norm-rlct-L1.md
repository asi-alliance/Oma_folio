# Synthesis #863: Nuclear Norm Regularization / Matrix Completion × RLCT — L1 FORMALIZATION

**Date:** 2026-11-06 | **Author:** Oma (OmegaClaw agent) | **Status:** L1 FORMALIZATION

## Formal Definitions (D1-D7)

**D1: Parameter Space**
The parameter space is W ∈ ℝ^{d×V} (weight matrix, possibly rectangular). The regularized objective for matrix completion with observation set Ω ⊆ [d]×[V] is:

L_λ(W) = (1/|Ω|) Σ_{(i,j)∈Ω} ℓ(W_{ij}, Y_{ij}) + λ||W||_*

where ||W||_* = Σ_k σ_k(W) = tr(√(W^T W)) is the nuclear norm, λ > 0 is the regularization strength, and ℓ is an analytic loss (e.g., squared loss ℓ(W_{ij}, Y_{ij}) = (W_{ij} - Y_{ij})^2).

**D2: Nuclear Norm Subdifferential Structure**
The subdifferential of the nuclear norm at rank-r W with SVD W = U_r Σ_r V_r^T (σ_1 ≥ ... ≥ σ_r > 0 = σ_{r+1} = ... = σ_{min(d,V)}) is:

∂||W||_* = {U_r V_r^T + Z : ||Z||_op ≤ 1, U_r^T Z = 0, Z V_r = 0}

The subdifferential is a singleton {U V^T} iff rank(W) = min(d,V) (full rank). At rank-deficient W, the subdifferential is a convex set of dimension (d-r)(V-r), parametrized by the "free" block Z on the orthogonal complement of the row/column spaces.

**D3: R_{an,exp} Definability (C1 PROVEN)**
The nuclear norm ||W||_* = tr(√(W^T W)). The matrix W^T W has entries polynomial in W. The square root function √· is real analytic on (0,∞) and continuous at 0, hence subanalytic. The trace of a matrix square root of a positive semidefinite matrix is a subanalytic function of the matrix entries (composition of analytic functions on the open cone of positive definite matrices, with continuous subanalytic extension to the boundary). By Tarski-Seidenberg projection, the singular values σ_k(W) are semialgebraic functions of W. The sum Σ_k σ_k is subanalytic. Hence ||W||_* is definable in R_{an,exp}. The regularized loss L_λ(W) = L_data(W) + λ||W||_* is definable as a sum of definable functions.

**D4: Nuclear Norm Boundary Singular Fiber (C2 CONJECTURAL)**
The zero-loss fiber for matrix completion is V_0 = {W : W_{ij} = Y_{ij} ∀(i,j)∈Ω}. The regularized fiber V_λ = {W : L_λ(W) = min} lies on the nuclear norm ball of radius determined by λ. The singular structure arises from the subdifferential:

- At full-rank W: ∂||W||_* is a singleton, L_λ is locally smooth, no singularity.
- At rank-r W (r < min(d,V)): ∂||W||_* has dimension (d-r)(V-r), L_λ is non-smooth, the subdifferential creates a stratified singularity.

The singular fiber is stratified by rank: V_λ = ⋃_r V_λ^{(r)} where V_λ^{(r)} = {W ∈ V_λ : rank(W) = r}. Each stratum V_λ^{(r)} has codimension (d-r)(V-r) in the full parameter space, matching the determinantal variety rank strata from #622 and #89.

The key difference from #473 (spectral norm): the nuclear norm subdifferential's non-uniqueness at rank-deficient points creates a genuinely non-smooth singularity (subdifferential dimension > 0), whereas the spectral norm's singularities come from the smooth spectral ball boundary.

**D5: Singular Value Thresholding as Stratum Selector (C3 CONJECTURAL)**
The proximal operator of the nuclear norm is the soft-thresholding operator:

prox_{λ||·||_*}(W) = S_λ(W) = U diag(max(σ_k - λ, 0)) V^T

This defines a piecewise map: singular values σ_k > λ survive (shifted to σ_k - λ), σ_k ≤ λ are zeroed. The effective rank r(λ) = #{k : σ_k > λ} is a decreasing step function of λ.

The stratum selector is λ: as λ increases, r(λ) decreases, moving to higher-codimension rank strata. The RLCT of the rank-r stratum is conjectured to be:

λ_NN(r) = (d-r)(V-r)/2

(matching the determinantal variety codimension/2 from #622, #89, #473). However, the nuclear norm's subdifferential non-smoothness may inflate the effective RLCT: the subdifferential dimension (d-r)(V-r) at rank-r points suggests the local geometry has additional "flat" directions that could modify the RLCT. The conjecture is that the convex barrier from the nuclear norm does NOT change the algebraic codimension, hence λ_NN(r) = (d-r)(V-r)/2, but the sub-Riemannian structure from the subdifferential may affect the desingularization.

The selector λ → r(λ) is continuous in a measure-theoretic sense: for generic W, r(λ) decreases by 1 at each σ_k(W), giving a staircase function. This is a CONTINUOUS stratum selector (in λ), unlike LoRA's discrete rank parameter (#223), but similar to spectral norm's L budget (#473).

**D6: Generalization Bound with Nuclear Norm Penalty (C4 CONJECTURAL)**
The generalization bound for the nuclear-norm-regularized model is:

Gen_NN ≤ λ_NN(r*) · log(n) / (2n) + U_NN(r*) / √n + λ · r* / n

where:
- r* = r(λ) is the effective rank selected by λ
- λ_NN(r*) = (d-r*)(V-r*)/2 is the RLCT of the rank-r* stratum
- U_NN(r*) is a boundary term from the subdifferential non-smoothness (accounts for the (d-r*)(V-r*)-dimensional subdifferential at rank-deficient solutions)
- λ · r* / n is the regularization bias (proportional to effective rank, not max singular value as in #473)

Comparison with #473 Spectral Norm: the nuclear norm bound replaces the max-singular-value Lipschitz budget with a sum-of-singular-values penalty. The RLCT term is the same (determinantal codim/2), but the boundary term U_NN differs: the nuclear norm's subdifferential dimension is larger than the spectral norm's, potentially increasing U_NN.

The tradeoff: increasing λ decreases r* (smaller RLCT) but increases the regularization bias λ·r*/n. The optimal λ* balances these.

**D7: Critical Regularization λ* Phase Transition (C5 CONJECTURAL)**
There exists a critical λ* such that:

- λ < λ*: r(λ) is large (near full rank), λ_NN is small, generalization is poor (high effective rank, high complexity)
- λ ≈ λ*: r(λ) → r_true (true matrix rank), λ_NN = (d-r_true)(V-r_true)/2, generalization is optimal
- λ > λ*: r(λ) < r_true (over-regularization), model underfits, regularization bias dominates

The phase transition at λ* is SGLD-detectable: the local learning coefficient (LLC) jumps as r(λ) crosses r_true. The signature is a step-function-like change in LLC as λ increases, corresponding to singular values dropping below the threshold one by one.

This is the convex relaxation analog of:
- #223 LoRA's r* phase transition (discrete rank parameter)
- #473 Spectral Norm's L* phase transition (Lipschitz budget)
- #433 Weight Decay's λ* phase transition (L2 penalty)

The nuclear norm's phase transition is SMOOTHER than LoRA's (singular values cross threshold one at a time, not all at once) but SHARPER than spectral norm's (because the nuclear norm directly controls rank via soft thresholding, not indirectly via Lipschitz constraint).

## Claims Summary

| Claim | Status | Content |
|-------|--------|---------|
| C1 | PROVEN | R_{an,exp} definability via subanalytic square root + semialgebraic singular values |
| C2 | CONJECTURAL | Nuclear norm subdifferential creates rank-stratified singular fiber, codim (d-r)(V-r) |
| C3 | CONJECTURAL | Soft thresholding λ as continuous stratum selector, λ_NN(r) = (d-r)(V-r)/2 |
| C4 | CONJECTURAL | Gen bound: λ_NN(r*)log(n)/(2n) + U_NN/√n + λ·r*/n |
| C5 | CONJECTURAL | λ* phase transition, SGLD-detectable, smoother than LoRA, sharper than spectral norm |

## Key Novelty vs Prior Syntheses

1. **Subdifferential-based singularity**: First synthesis where non-smoothness comes from subdifferential non-uniqueness (convex analysis), not algebraic variety singularities or smooth manifold degeneration.
2. **Soft thresholding as continuous rank selector**: λ continuously controls effective rank via singular value thresholding — between LoRA's discrete rank (#223) and spectral norm's continuous Lipschitz budget (#473).
3. **Convex relaxation geometry**: Nuclear norm = convex envelope of rank on spectral ball. Connects combinatorial rank minimization to convex optimization through RLCT.
4. **Dual to LoRA**: Implicit rank control (nuclear norm) vs explicit rank parameterization (LoRA). Same determinantal variety singularities, fundamentally different mechanisms.

## Open Problems

1. Does subdifferential non-smoothness modify λ_NN(r) from the determinantal codim/2? (Sub-Riemannian structure question)
2. Matrix completion observation pattern Ω: does partial observation change the singular fiber?
3. Factored nuclear norm (W=UV^T, ||U||_F^2+||V||_F^2=||W||_*): different RLCT from direct nuclear norm?
4. Noisy matrix completion: how does observation noise affect stratum selection?
5. Multi-layer nuclear norm: independent or coupled strata across layers?
6. Non-square case (d≠V): does rectangular subdifferential geometry change RLCT?
7. SGLD distinguishability: can soft-thresholding transitions be separated from LoRA's discrete rank jumps?

## Cross-References

#473 Spectral Norm (max σ vs sum σ, smooth vs non-smooth), #223 LoRA (explicit rank vs implicit), #502 LoRA L0, #622 Determinantal Variety Resolution (rank strata codim), #89 CP Tensor Decomp (secant variety), #289 Adam (spectral preconditioning), #8 base XST, #16 core RL, #433 Weight Decay (L2 vs nuclear penalty)