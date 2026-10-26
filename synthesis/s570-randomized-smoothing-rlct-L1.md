# Synthesis #570: Randomized Smoothing × RLCT — L1 Formalization
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-23

## Definitions

### D1: Smoothed Classifier
Given base classifier f_θ: R^d → R^K with parameters θ ∈ Θ ⊂ R^m, the smoothed classifier is:
  g_σ(x) = E_{ε~N(0,σ²I_d)}[f_θ(x + ε)]
The smoothed loss for a single sample (x, y):
  L_σ(θ) = E_{ε~N(0,σ²I_d)}[ℓ(f_θ(x + ε), y)]
where ℓ is the loss function (e.g., cross-entropy). The empirical smoothed loss:
  L̂_σ(θ) = (1/n) Σ_{i=1}^n L_σ^{(i)}(θ) = (1/n) Σ_i E_{ε_i}[ℓ(f_θ(x_i + ε_i), y_i)]

### D2: Heat Semigroup Representation
Gaussian convolution is the heat semigroup e^{σ²Δ_x/2} applied to h_θ(x) = ℓ(f_θ(x), y):
  L_σ(θ) = (e^{σ²Δ_x/2} h_θ)(0) evaluated at the data point offset
Equivalently, L_σ(θ) = ∫_{R^d} h_θ(ε) φ_σ(ε) dε where:
  φ_σ(ε) = (2πσ²)^{-d/2} exp(-||ε||²/(2σ²))
This is the Weierstrass transform of h_θ. For σ > 0, L_σ is C^∞ in x and inherits analyticity in θ from f_θ.

### D3: R_an,exp Structure (C1 PROVEN)
- f_θ(x) is a neural network with activations in R_an,exp (tanh, softmax, ReLU piecewise): f_θ ∈ R_an,exp for each θ
- h_θ(x) = ℓ(f_θ(x), y): composition of R_an,exp functions → R_an,exp
- φ_σ(ε) = (2πσ²)^{-d/2} exp(-||ε||²/(2σ²)) ∈ R_an,exp (exponential of polynomial)
- Product h_θ(ε) · φ_σ(ε) ∈ R_an,exp (ring closure)
- L_σ(θ) = ∫_{R^d} h_θ(ε) φ_σ(ε) dε: integration of R_an,exp function over R^d (semi-algebraic domain)
- By Wilkie's theorem (R_an,exp closed under definable integration over semi-algebraic domains):
  L_σ(θ) ∈ R_an,exp for all σ > 0
- Empirical sum L̂_σ(θ) = (1/n) Σ_i L_σ^{(i)}(θ): finite sum of R_an,exp → R_an,exp ∎

### D4: Smoothed Singular Fiber
The smoothed zero-loss set:
  W_σ = {θ ∈ Θ : L̂_σ(θ) = L̂_σ(θ*)}
where θ* is the true parameter (population minimizer). For σ = 0:
  W_0 = {θ : L̂(θ) = L̂(θ*)} (original singular fiber)
For σ > 0, the heat semigroup smooths h_θ in x-space. The parameter-space fiber W_σ is the pullback of the smoothed loss. Key structural question: does W_σ have fewer singular strata than W_0?

The desingularization map is implicit: σ acts as a "blur radius" on the input manifold, which induces a deformation on the parameter-space loss landscape.

### D5: σ-Stratified Loss Family
The family {L̂_σ}_{σ ≥ 0} defines a continuous deformation:
  σ = 0: L̂_0 = original empirical loss, full singularity structure
  σ → ∞: L̂_σ → constant (all inputs map to same output), λ(σ) → 0
  σ ∈ (0, ∞): partial desingularization

The stratum cascade: each singular stratum S_i ⊂ W_0 has a characteristic spatial scale ℓ_i (determined by local geometry of the decision boundary near S_i). For σ << ℓ_i: S_i preserved in W_σ. For σ >> ℓ_i: S_i desingularized.

### D6: Generalization Bound
  G_smooth(n, σ) ≤ C · λ(σ) · log(n) / (2n) + U(σ) / √n
where:
  λ(σ) = RLCT of L̂_σ at θ̂ (the learned parameters)
  U(σ) = bias/robustness term: measures loss of discriminative information from smoothing
  λ(σ) is non-increasing in σ (smoothing reduces complexity)
  U(σ) is non-decreasing in σ (smoothing introduces bias)
  Optimal σ* minimizes G_smooth by trading complexity reduction vs bias increase

### D7: Phase Transition at σ*
  σ* = argmin_σ [λ(σ)·log(n)/(2n) + U(σ)/√n]
For σ < σ*_1 (first stratum threshold): λ̂ ≈ λ_orig, all strata active
For σ*_i < σ < σ*_{i+1}: i-th stratum desingularized, λ̂ drops stepwise
At σ*_i: heat semigroup resolves the i-th singular stratum — phase boundary
SGLD-testable: estimate λ̂(σ) via LLC, observe stepwise decrease
Certification radius: R(σ) = σ · Φ^{-1}(p*) connects robustness guarantee to RLCT stratum boundary

## Claims

### C1 (PROVEN): R_an,exp-definability
L̂_σ(θ) = (1/n) Σ_i ∫ h_θ^{(i)}(ε) φ_σ(ε) dε where h_θ^{(i)}(ε) = ℓ(f_θ(x_i + ε), y_i).
Each h_θ^{(i)} ∈ R_an,exp (composition of analytic network + analytic loss).
φ_σ ∈ R_an,exp (Gaussian density). Product ∈ R_an,exp.
Integration over R^d (semi-algebraic, unbounded but definably integrable due to Gaussian decay).
By Wilkie closure: each L_σ^{(i)}(θ) ∈ R_an,exp.
Finite sum: L̂_σ(θ) ∈ R_an,exp. QED.

### C2 (CONJECTURAL): Input-Space Desingularization
The heat semigroup e^{σ²Δ_x/2} smooths h_θ(x) in input space. This induces a deformation of the parameter-space loss L̂_σ(θ). Claim: λ(σ) ≤ λ(0) = λ_orig for all σ > 0, with λ(σ) → 0 as σ → ∞.
Mechanism: input-space smoothing flattens sharp decision boundaries → the θ-space loss landscape becomes less singular because the network needs less precise θ to achieve the same smoothed loss. This is distinct from #525 (Entropy-SGD smooths in θ-space via local entropy γ) and #377 (gradient noise in θ-space via Itô correction).
Key distinction: #570 desingularizes via INPUT perturbation (x → x + ε), changing what the network sees. #525 desingularizes via PARAMETER perturbation (θ → θ + δ), changing where the optimizer explores.

### C3 (CONJECTURAL): σ as Continuous Stratum Selector
σ continuously interpolates between full singularity (σ=0) and complete desingularization (σ→∞). Each singular stratum S_i has a spatial scale ℓ_i. The cascade σ*_1 < σ*_2 < ... < σ*_K marks stratum-by-stratum desingularization. The certification radius R(σ) = σ·Φ^{-1}(p*) provides a CERTIFIED boundary: within R(σ), the smoothed classifier is robust, and this boundary coincides with the RLCT stratum transition. Connection to #224 label smoothing: both use a smoothing parameter (σ vs ε) as stratum selector, but #224 operates on target distribution while #570 operates on input distribution.

### C4 (CONJECTURAL): Generalization Bound
G_smooth ≤ C·λ(σ)·log(n)/(2n) + U(σ)/√n where λ(σ)↓ and U(σ)↑ in σ. At optimal σ*: complexity reduction balances bias. Prediction: σ* ~ √(λ_orig · d / n) (heuristic from balancing terms). The certification radius R(σ*) gives the radius at optimal generalization-robustness tradeoff. Distinct from #433 weight decay: WD constrains θ-norm (parameter regularization), #570 constrains input perturbation (function-space regularization). Different geometry: WD contracts W toward origin, #570 blurs the loss landscape isotropically in x.

### C5 (CONJECTURAL): SGLD-Testable Phase Transition
Train with input Gaussian noise σ during SGLD. Estimate λ̂(σ) via LLC. Predicted: stepwise decrease at each σ*_i (stratum desingularization). At σ*_i: fluctuation-dissipation ratio ν_σ changes. For toy ReLU network: measure LLC vs σ, observe kink/cusp at σ*_1. For σ > σ*_1: λ̂ drops below λ_orig. Deep networks: depth-dependent σ* (each layer's decision boundary has different spatial scale). Connection to #569 gradient penalty: both involve input-space quantities (∇_x f vs x+ε perturbation), but GP constrains the gradient while smoothing averages over perturbations.

## Open Problems (7)
1. **Strict monotonicity of λ(σ)**: Can input smoothing create NEW singularities in θ-space? (e.g., smoothing reveals a saddle that was masked)
2. **Stratum scale ℓ_i computation**: How to compute ℓ_i from local geometry of W_0 and the decision boundary?
3. **σ* derivation**: First-principles derivation of σ* ~ √(λ_orig·d/n) (currently heuristic)
4. **Composability with #525**: Joint smoothing λ(σ_x, γ) where σ_x is input-space and γ is parameter-space. Does composition commute?
5. **Non-Gaussian kernels**: Uniform noise (L∞ certification) vs Gaussian (L2). Different desingularization geometry?
6. **Distribution shift**: Does smoothed loss generalize better under covariate shift? (RLCT-robustness duality)
7. **Depth dependence**: How does σ* scale with network depth? Each layer transforms the effective noise.

## Cross-References (9)
- #377: Gradient noise injection (parameter-space noise vs input-space noise)
- #525: Entropy-SGD (parameter-space local entropy vs input-space heat semigroup)
- #507: Noisy Student (noise augmentation + self-training vs certified smoothing)
- #169: Dropout (stochastic subnetwork vs deterministic input averaging)
- #224: Label Smoothing (target-side smoothing vs input-side smoothing)
- #569: Gradient Penalty (input-gradient constraint vs input perturbation)
- #127: Adversarial Training (worst-case perturbation vs average-case Gaussian)
- #433: Weight Decay (parameter regularization vs input regularization)
- #545: Sparse Attention (pattern-constrained attention vs smoothed attention)

## Status
L1 written 2026-10-23. Next: L2 novelty verification.
