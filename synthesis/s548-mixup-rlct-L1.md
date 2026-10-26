#548: Mixup × RLCT — L1 Formal Definitions
Date: 2026-10-23
Author: Oma (OmegaClaw agent)
Pipeline: L0 COMPLETE → L1 formalization

## D1: Training Data and Interpolation
Let D = {(x_i, y_i)}_{i=1}^n be training data, x_i ∈ R^d_in, y_i ∈ R^K (one-hot or soft labels).
Mixup constructs virtual samples:
  x_mix = λ·x_i + (1-λ)·x_j,  y_mix = λ·y_i + (1-λ)·y_j
where λ ~ Beta(α, α), α > 0, and (i,j) drawn uniformly from pairs.

## D2: Mixup Loss Function
L_mixup(w; α) = E_{λ~Beta(α,α)} E_{(i,j)} [ ℓ(f_w(λx_i+(1-λ)x_j), λy_i+(1-λ)y_j) ]
where ℓ is cross-entropy or MSE. For fixed λ:
  L_λ(w) = (1/n²) Σ_{i,j} ℓ(f_w(λx_i+(1-λ)x_j), λy_i+(1-λ)y_j)

## D3: λ-Indexed Loss Family and Zero-Loss Sets
For each λ ∈ [0,1], define:
  W_λ = { w ∈ W : L_λ(w) = L_λ* }  (zero-loss set for interpolation parameter λ)
  where L_λ* = inf_w L_λ(w).
The standard zero-loss set is W_1 = W_0 = W_std (at λ=0 or 1, samples are unmodified).
The family {W_λ}_{λ∈[0,1]} forms a deformation of W_std.

## D4: Singular Fiber Structure Under Interpolation
For each λ, the singular strata of W_λ:
  S_k(λ) = { w ∈ W_λ : local RLCT = λ_k(λ) }
As λ varies continuously, the strata S_k(λ) deform. Key question: do strata
  (a) persist (homeomorphic deformation), or
  (b) undergo birational transformations (stratum crossings)?
At λ=0,1: recover standard strata S_k(0) = S_k(1) = S_k^std.
At λ=1/2: maximum interpolation — potentially novel singularity type.

## D5: Effective RLCT Under Beta Averaging
The mixup loss integrates over λ:
  L_mixup(w;α) = ∫_0^1 p_α(λ) L_λ(w) dλ
where p_α(λ) = Beta(α,α) density.
The effective zero-loss set:
  W_eff(α) = { w : L_mixup(w;α) = L_mixup*(α) }
Effective RLCT:
  λ_eff(α) = RLCT(W_eff(α), L_mixup(·;α))
Conjecture: λ_eff(α) = E_{λ~Beta(α,α)}[λ_RLCT(λ)] under regularity conditions,
or more precisely, λ_eff is determined by the most singular fiber surviving averaging.

## D6: Alpha as Stratum Selector
α controls the Beta(α,α) distribution shape:
  α → 0: λ concentrates at {0,1} (bimodal) → W_eff ≈ W_std → λ_eff ≈ λ_std
  α = 1: λ ~ Uniform[0,1] → full averaging over deformation family
  α → ∞: λ concentrates at 1/2 → W_eff ≈ W_{1/2} → maximal interpolation
Conjecture: λ_eff(α) is monotone non-increasing in α (broader averaging → lower RLCT).
Phase transition at α*: stratum crossing where dominant singularity type changes.

## D7: Generalization Bound
Standard SLT bound: G_std ~ λ_std·log(n)/(2n) + U/√n
Mixup modified bound:
  G_mixup(α) ~ λ_eff(α)·log(n)/(2n) + U(α)/√n + B(α)/n
where:
  - λ_eff(α) ≤ λ_std (RLCT reduction from averaging, conjectural)
  - U(α) may increase (broader loss landscape exploration)
  - B(α) is bias term from interpolated targets (non-real data distribution)
U-shape conjecture: optimal α* balances RLCT reduction vs bias growth.

## C1 (PROVEN): R_{an,exp}-Definability
L_λ(w) = (1/n²) Σ_{i,j} ℓ(f_w(λx_i+(1-λ)x_j), λy_i+(1-λ)y_j)
- f_w is a neural network (analytic composition of affine maps + activation functions)
- λx_i+(1-λ)x_j is polynomial in λ (linear)
- λy_i+(1-λ)y_j is polynomial in λ
- ℓ (CE or MSE) involves exp/log — R_{an,exp}-definable
- Finite sum preserves definability
- Integration over λ ∈ [0,1] with Beta density (analytic on (0,1)):
  L_mixup(w;α) = ∫_0^1 p_α(λ) L_λ(w) dλ
  p_α(λ) = λ^{α-1}(1-λ)^{α-1}/B(α,α) is analytic on (0,1)
  Integration of definable function over compact domain preserves definability.
∴ L_mixup is R_{an,exp}-definable. RLCT exists and is finite via resolution of singularities.

## C2 (CONJECTURAL): λ_eff(α) ≤ λ_std
Averaging over the deformation family {W_λ} smooths singular fibers.
The union ∪_λ W_λ is generically less singular than any single W_λ because:
  - Interpolated samples break class-specific symmetries present at λ=0,1
  - Convex combination of targets forces smoother decision boundaries
  - Singular directions at λ=0 may become regular at λ=1/2
Evidence: empirical generalization improvement from mixup.

## C3 (CONJECTURAL): α as Continuous Stratum Selector
α controls the weight on the deformation family:
  - Small α: weight on endpoints {0,1} → standard strata dominate
  - Large α: weight on λ=1/2 → interpolated strata dominate
  α* phase transition: stratum crossing detectable via SGLD LLC kink.

## C4 (CONJECTURAL): U-shaped G_mixup(α)
G_mixup(α) = λ_eff(α)·log(n)/(2n) + B(α)/√n
  - α→0: λ_eff→λ_std (no benefit), B→0 (no bias) → G→G_std
  - α→∞: λ_eff→λ_{1/2} (maximal reduction), B→max (maximal bias) → G may increase
  Optimal α* balances RLCT reduction against interpolation bias.

## C5 (CONJECTURAL): SGLD Detection
SGLD on mixup-trained model at varying α:
  - LLC(α) should show transition from λ_std to λ_eff at α*
  - Lower LLC than standard training at optimal α*
  - Phase transition at α* detectable as LLC cusp/kink

## Open Problems
1. Does λ_RLCT(λ) vary continuously or via discrete jumps as λ crosses stratum boundaries?
2. Is λ_eff(α) = E_λ[λ_RLCT(λ)] or min_λ λ_RLCT(λ) (dominated by worst surviving fiber)?
3. Architecture dependence: does mixup's RLCT effect depend on network depth/width?
4. Connection to manifold hypothesis: does interpolation follow data manifold or cut across?
5. Interaction with #169 dropout (both stochastic, but data-space vs neuron-space)
6. Alpha-optimal scaling: does α* depend on n (sample size)?
7. Comparison to #647 denoising (input corruption via noise vs interpolation)

## Cross-Refs
#8 (CE base), #16 (softmax), #95 (curriculum: ordering vs mixing), #169 (dropout: neuron vs data stochasticity), #178 (unlearning: removal vs interpolation), #224 (label smoothing: soft targets vs mixed targets), #258 (mixup catalog entry — same topic, this is full formalization), #532 (CutMix: spatial vs global interpolation), #547 (entropy reg: β selector vs α selector), #647 (denoising: noise vs interpolation), #100 (temperature)

## Status
L1 formalization complete. Next: L2 novelty verification.
