# Synthesis #570: Randomized Smoothing × RLCT
**Date:** 2026-10-23
**Status:** L0 Exploration
**Candidate:** Confirmed uncovered (zero catalog, zero SLT websearch)

## Background
Randomized smoothing (Cohen et al. 2019; Lécuyer et al. 2019) constructs a smoothed classifier g(x) = E_{ε~N(0,σ²I)}[f(x+ε)] by convolving the base classifier's decision function with a Gaussian kernel. This is exactly the Weierstrass transform (heat semigroup applied to the indicator function). Certification radius R(σ) guarantees robustness within an L2 ball.

## Key RLCT Bridge
Gaussian convolution with variance σ² is the heat semigroup e^{σ²Δ/2} applied to the loss landscape L(θ, x). This smooths singularities of the loss function in INPUT space, creating a desingularization-like effect:
- σ → 0: recovers original loss with full singularity structure (λ = λ_orig)
- σ → ∞: loss becomes constant (complete desingularization, λ → 0)
- Intermediate σ: partial desingularization, λ(σ) < λ_orig

This is fundamentally DISTINCT from:
- #377 (gradient noise in parameter space, Itô correction as stratum selector)
- #525 (Entropy-SGD: smoothing in PARAMETER space via local entropy, not input space)
- #507 (Noisy Student: noise as training augmentation + teacher-student, not certification)
- #169 (Dropout: stochastic subnetwork selection, not input-space smoothing)
- #224 (Label Smoothing: target-side smoothing, not input-side)

Randomized smoothing operates on the INPUT manifold, applying heat semigroup desingularization to the composite function h_θ(x) = L(f_θ(x), y). The smoothed loss L_σ(θ) = E_{ε}[L(f_θ(x+ε), y)] has different singular fiber geometry than L(θ).

## Five Claims

### C1: R_an,exp Definability (PROVEN)
- f_θ(x) is subanalytic + exp-definable (standard neural network assumption)
- Gaussian density φ_σ(ε) = (2πσ²)^{-d/2} exp(-||ε||²/(2σ²)) is in R_an,exp
- Convolution: L_σ(θ) = ∫ L(f_θ(x+ε), y) φ_σ(ε) dε
- R_an,exp is closed under definable integration over semi-algebraic domains (Wilkie, Van den Dries)
- The convolution integral is definable: integrand ∈ R_an,exp, domain = R^d (semi-algebraic)
- Therefore L_σ(θ) ∈ R_an,exp for all σ > 0 ∎

### C2: Input-Space Desingularization (CONJECTURAL)
- Heat semigroup e^{σ²Δ/2} smooths the composite loss h_θ(x) = L(f_θ(x), y)
- For fixed θ, singularities of x ↦ h_θ(x) are desingularized by Gaussian convolution
- The PARAMETER-SPACE singular fiber W_σ = {θ : ∇_θ L_σ(θ) = 0} differs from W_0
- Claim: λ(σ) ≤ λ_orig, with λ(σ) → 0 as σ → ∞ (loss becomes constant)
- Mechanism: input-space smoothing flattens decision boundaries → gradient flow in θ-space sees softened singularity structure
- Key distinction from #525: #525 smooths in θ-space (local entropy), #570 smooths in x-space (input perturbation)

### C3: σ as Continuous Stratum Selector (CONJECTURAL)
- σ controls the degree of input-space desingularization continuously
- Each singular stratum S_i of the original loss has a characteristic spatial scale ℓ_i
- For σ << ℓ_i: stratum S_i preserved in smoothed loss
- For σ >> ℓ_i: stratum S_i desingularized (absorbed into smooth region)
- Phase transition at σ*_i ≈ c_i · ℓ_i: stratum S_i crosses from singular to regular
- Cascade: as σ increases, strata desingularize one by one (σ*_1 < σ*_2 < ...)
- Certification radius R(σ) ≈ σ · Φ^{-1}(p*) provides a CERTIFIED stratum boundary
- This connects robustness certification to RLCT stratum selection

### C4: Generalization Bound (CONJECTURAL)
- G_smooth ~ λ(σ)·log(n)/(2n) + U(σ)/√n
- λ(σ): effective RLCT of smoothed loss (decreasing in σ)
- U(σ): bias term from input smoothing — large σ over-smooths, losing discriminative info
- Tradeoff: small σ → high λ (complex), large σ → high U (biased)
- Optimal σ* minimizes λ(σ)*log(n)/(2n) + U(σ)/√n
- Prediction: σ* scales with √(λ_orig · d / n) (heuristic)
- Connection to certified robustness: R(σ*) gives radius at optimal generalization-robustness tradeoff

### C5: SGLD-Testable Phase Transition (CONJECTURAL)
- Train with input-space Gaussian noise of variance σ² during SGLD sampling
- Estimate LLC λ̂(σ) via local learning coefficient
- Prediction: λ̂(σ) shows kink/cusp at each σ*_i (stratum desingularization threshold)
- At σ*_i: fluctuation-dissipation ratio ν_σ changes discontinuously
- Experimental design: train on toy singular model (e.g., toy ReLU network), vary σ, measure LLC
- For σ < σ*_1: λ̂ ≈ λ_orig (all strata active)
- For σ > σ*_1: λ̂ drops (first stratum desingularized)
- Stepwise decrease predicted, mirroring stratum cascade

## Open Problems
1. **Exact λ(σ) monotonicity**: Is λ(σ) strictly monotone in σ? Or can smoothing create NEW singularities?
2. **Stratum scale ℓ_i**: How to compute ℓ_i for a given singular stratum? Connection to local geometry of W?
3. **σ* scaling**: Derive σ* from first principles (currently heuristic √(λ·d/n))
4. **Interaction with #525**: Can input-space (σ_x) and parameter-space (γ) smoothing be composed? Joint λ(σ_x, γ)?
5. **Non-Gaussian smoothing**: Does uniform noise (L∞ certification) give different desingularization structure?
6. **Distribution shift**: Does smoothed loss generalize better under covariate shift? (RLCT vs robustness duality)
7. **Deep networks**: Does input smoothing propagate through layers non-trivially, creating depth-dependent σ*?

## Cross-References
- #377: Gradient noise injection (parameter-space noise vs input-space noise)
- #525: Entropy-SGD (parameter-space local entropy smoothing vs input-space Gaussian)
- #507: Noisy Student (noise augmentation + self-training vs certified smoothing)
- #169: Dropout (stochastic subnetwork selection vs deterministic input smoothing)
- #224: Label Smoothing (target-side smoothing vs input-side smoothing)
- #569: Gradient Penalty (input-gradient constraint vs input-perturbation smoothing)
- #527: Gradient Clipping (gradient norm constraint vs input smoothing)
- #127: Adversarial Training (worst-case perturbation vs average-case Gaussian)
- #433: Weight Decay (parameter regularization vs input regularization)
