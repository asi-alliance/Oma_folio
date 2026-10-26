# Synthesis #619: RMSNorm × RLCT — L1 Formalization (D1-D7)

## D1: R_{an,exp} Definability of RMSNorm
RMSNorm: y_i = γ_i · x_i / sqrt((1/d)Σ_j x_j² + ε).
- s(x) = (1/d)Σ_j x_j²: polynomial → R_an-definable.
- sqrt(s + ε): restricted sqrt is definable in R_an for s + ε > 0 (guaranteed by ε > 0).
- Division x_i / sqrt(s + ε): definable in R_an (division on {denominator > 0} is definable).
- Scale γ_i · (x_i / sqrt(s+ε)): definable (polynomial composition).
- For ε = 0: x/||x|| definable on R^d \ {0}, not extendable to origin.
- For ε > 0: definable everywhere. Composition through network preserves definability.
Thus L_RMS(θ) ∈ R_{an,exp}. By Watanabe, RLCT λ_RMS well-defined. QED (C1).

## D2: Origin Singularity Geometry
Without ε: map φ(x) = x/||x|| = projection onto unit sphere S^{d-1}.
- φ: R^d \ {0} → S^{d-1}, smooth, constant along radial rays.
- Singularity at x = 0: φ undefined, non-extendable (pole-type).
- Fiber structure: preimage of any y ∈ S^{d-1} is the ray {t·y : t > 0} (1-dimensional radial fiber).
- This is a quotient singularity: R^d / R_+ ≅ S^{d-1}, collapsing radial direction.
- Blow-up at origin: replace 0 with exceptional divisor E ≅ S^{d-1} (projective blow-up).
- The singular fiber V_RMS = {θ : L_RMS(θ) = L_min} inherits this radial structure near activation-collapse configurations θ* where ||h_l(x;θ*)|| → 0.
- Local model: near θ*, loss behaves like L(θ) ≈ L_min + ||h_l(θ)||^{2k} / (||h_l(θ)||² + ε) where k = order of vanishing of activation norm.
- For ε = 0: pole-type singularity, RLCT λ_0 determined by k and codim of collapse locus.
- For ε > 0: regularized, λ(ε) < λ_0.

## D3: R_{an,exp} Structure of RMSNorm Loss
L_RMS(θ) = Σ_{(x,y)} ℓ(f_θ(x), y) where f_θ includes RMSNorm layers.
Each layer l: h̃_l = γ_l ⊙ h_l / sqrt(mean(h_l²) + ε).
- mean(h_l²) = (1/d_l)Σ_j h_{l,j}²: polynomial in θ (via recursive composition).
- Division by sqrt(mean(h_l²) + ε): definable where mean(h_l²) + ε > 0 (always true for ε > 0).
- If ReLU activations: h_l = ReLU(W_l h̃_{l-1} + b_l) — ReLU is definable in R_an (piecewise-linear, definable).
- Full composition: polynomial → sqrt → division → ReLU → polynomial → ... all R_an-definable.
- Loss ℓ (CE, MSE, etc.): definable if softmax/polynomial → R_{an,exp}.
Thus L_RMS ∈ R_{an,exp}. RLCT well-defined for any network depth.

## D4: Activation-Collapse Singular Fiber
Define collapse locus: A = {θ : ∃ l, x such that RMS(h_l(x;θ)) → √ε}.
Near θ* ∈ A with RMS(h_l(θ*)) = √ε (boundary of regularization):
- Effective gradient amplification: ∂L/∂θ ∝ 1/sqrt(RMS² + ε) → 1/√(2ε) at boundary.
- Fisher information: F(θ) acquires large eigenvalues in directions normal to A (gradient amplification).
- Singular stratum: Σ_c = A ∩ V_RMS (collapse configurations that are also loss minimizers).
- Codimension: codim(Σ_c) = codim of activation-norm-zero condition = 1 (single scalar constraint RMS = 0, or RMS = √ε with ε → 0).
- Predicted RLCT: λ_c = 1/2 · codim(Σ_c) = 1/2 (if the collapse condition is a single smooth equation, RLCT = codim/2 by standard result for hypersurface singularities).
- Compare LayerNorm: collapse requires BOTH μ → 0 AND σ → 0 (two conditions, codim 2, λ_LN = 1). RMSNorm: one condition (RMS → 0), λ_RMS = 1/2 < 1 = λ_LN. Supports C4.

## D5: ε-Resolution Family
Family L_ε(θ) parameterized by ε ∈ (0, ∞):
- ε → 0: L_ε → L_0 (spherical projection, pole singularity at origin).
- ε > 0: regularized, singularity softened to removable singularity (denominator bounded below by √ε).
- ε → ∞: y_i → γ_i · x_i / √ε → 0 (normalization suppresses all activations, loss → constant).
Conjecture: λ(ε) is continuous, non-increasing in ε.
- λ(0) = λ_max (unresolved pole).
- λ(ε) for small ε: λ(ε) ≈ λ_max - c·ε^{α} for some α > 0 (resolution replaces pole with smooth cap).
- At ε → ∞: λ → 0 (trivial constant loss, no singularity).
The ε-resolution is analogous to Hironaka blow-up: the exceptional divisor E_ε ≅ S^{d-1} has "thickness" ~√ε, controlling the RLCT.
Phase transition: at ε* = ε*(n), the dominant stratum switches from collapse-dominated (small ε, high λ) to smooth-dominated (large ε, low λ). ε* increases with n (see D6).

## D6: Generalization Bound with ε-Resolution
G_ε(n) ≤ λ(ε)·log(n)/(2n) + U_ε/√n + B_ε.
- λ(ε): non-increasing in ε (resolution of singularity).
- B_ε: bias increases with ε (weaker normalization → worse representation). B_0 ≈ 0 (perfect normalization). B_ε → large as ε → ∞.
- U_ε: fluctuation. Near collapse (small ε), gradients amplified → U_ε large (SGLD mixing slow). At moderate ε, U moderate.
- Optimal ε* minimizes λ(ε)·log(n)/(2n) + B_ε.
  For large n: log(n)/(2n) → 0, so ε* → larger (bias dominates, prefer weaker normalization).
  For small n: λ·log(n)/(2n) dominates, so ε* → smaller (prefer lower λ, stronger normalization).
Testable prediction: optimal ε* increases with dataset size n. SGLD: measure LLC ν_ε as function of ε. Predict ν_ε decreasing in ε. Also predict ν_RMS < ν_LN at same ε.

## D7: RMSNorm vs LayerNorm RLCT Comparison
LayerNorm: y = (x - μ)/sqrt(σ² + ε)·γ where μ = mean(x), σ² = mean((x-μ)²).
- Two statistics: μ (translation), σ² (scale).
- Singular fiber: requires μ → arbitrary AND σ → 0. Two coupled conditions → codim 2 stratum.
- RLCT: λ_LN = 2/2 = 1 (two hypersurface conditions, each contributing 1/2).
- Also: translation fiber (μ-direction) is a free direction (no singularity in μ alone), but σ → 0 creates the singular part. The combined (μ, σ) fiber has codim 1 in σ, but the mean-direction adds a flat direction → effective RLCT contribution from σ-collapse only = 1/2. However, the coupling of μ and σ through (x-μ) creates a twisted fiber → λ_LN ≥ 1/2, likely λ_LN = 1 (full coupled singularity).
RMSNorm: y = x/sqrt(mean(x²) + ε)·γ.
- One statistic: RMS = sqrt(mean(x²)).
- Singular fiber: requires RMS → 0. One condition → codim 1 stratum.
- RLCT: λ_RMS = 1/2 (single hypersurface condition).
- No translation fiber (no mean centering) → no twisted coupling.
Conclusion: λ_RMS = 1/2 ≤ 1 = λ_LN (conjectured). RMSNorm has simpler fiber structure → lower RLCT → better generalization bound (modulo bias). This explains the empirical finding that RMSNorm generalizes comparably or better than LayerNorm with fewer parameters (no β bias, no mean computation).
