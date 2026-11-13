# Synthesis #865: AdaIN × RLCT — L1 Formalization

**Date:** 2026-11-06 | **Author:** Oma | **Status:** L1 FORMALIZATION

---

## D1: Parameter Space

Let θ ∈ Θ ⊂ R^P denote decoder parameters g_θ. The content encoder f_c (VGG) and style encoder f_s are frozen — their activations define a fixed piecewise-polynomial feature space.

**Extended parameter space:** Θ_ext = Θ × R^C × R^C_+ × R^C × R^C_+ where (μ_style, σ_style) ∈ R^C × R^C_+ are style statistics (treated as input-dependent constants per style image, not free parameters) and (μ_content, σ_content) are computed from content features.

**Effective parameter space:** Θ = {θ: decoder g_θ parameters} ⊂ R^P, P = decoder parameter count.

## D2: Loss Function

The AdaIN style transfer loss decomposes as:

  L_n(θ; x_c, x_s) = L_content(θ) + λ · L_style(θ)

where:
  L_content(θ) = (1/n) Σ_i ||g_θ(AdaIN(f_c(x_c^i), f_s(x_s^i))) - f_c(x_c^i)||²_F

  L_style(θ) = (1/n) Σ_i Σ_l [ ||μ(Φ_l(g_θ(z_i))) - μ(Φ_l(x_s^i))||² + ||σ(Φ_l(g_θ(z_i))) - σ(Φ_l(x_s^i))||² ]

Here Φ_l denotes the l-th frozen VGG feature extractor, z_i = AdaIN(f_c(x_c^i), f_s(x_s^i)), and μ, σ are channel-wise mean and standard deviation (Gram statistics).

The AdaIN transform itself:
  AdaIN(x, s) = σ_s · (x - μ_c) / σ_c + μ_s

where μ_c = (1/HW) Σ_{h,w} x_{c,h,w}, σ_c = sqrt((1/HW) Σ_{h,w} (x_{c,h,w} - μ_c)² + ε).

## D3: R_{an,exp}-Definability (C1 Proof Detail)

**Claim C1 (PROVEN):** L_n is R_{an,exp}-definable.

**Proof:**
1. μ_c is a finite sum (polynomial in x) — analytic.
2. σ_c = sqrt(Σ (x - μ_c)² + ε) — sqrt of polynomial + constant → semi-algebraic, subanalytic.
3. (x - μ_c)/σ_c is a rational function (polynomial / sqrt-polynomial) — definable in R_{an,exp} since division is definable where denominator ≠ 0.
4. AdaIN = σ_s · (x - μ_c)/σ_c + μ_s — affine in rational function → R_{an,exp}-definable on {σ_c > 0}.
5. VGG features Φ_l are compositions of convolutions (polynomial) and ReLU (semi-algebraic) — subanalytic.
6. Gram statistics μ(·), σ(·) are finite sums/sqrt — subanalytic.
7. L_content is squared Frobenius norm of R_{an,exp}-definable function → R_{an,exp}-definable.
8. L_style is sum of squared norms of R_{an,exp}-definable functions → R_{an,exp}-definable.
9. L_n = L_content + λ L_style — linear combination preserves definability.

Therefore L_n ∈ R_{an,exp} and RLCT theory applies. ∎

## D4: Singular Fiber Structure

**Variance-collapse fiber:**
  V_var = {θ ∈ Θ : ∃ channel j, σ_c(f_c(x_c))_j = 0}

At V_var, the AdaIN transform has a pole: (x - μ_c)/σ_c → 0/0. This is a **rational singularity** — the first in the catalog. The fiber has codimension = (number of zero-variance channels) × (spatial dimension per channel).

**Gram matrix style fiber:**
  V_gram = {θ ∈ Θ : ∀l, G_l(g_θ(z)) = G_l(x_s)}

where G_l(y) = (1/C_l) Φ_l(y)^T Φ_l(y) is the Gram matrix at layer l. This is a **quadratic fiber** (polynomial equations of degree 2 in θ).

**Content reconstruction fiber:**
  V_recon = {θ ∈ Θ : g_θ(AdaIN(f_c(x_c), f_s(x_s))) = f_c(x_c)}

This is a **polynomial fiber** (squared-norm zero condition).

**Composite fiber:**
  V(λ) = {θ : L_n(θ) = 0} = V_recon ∩ V_gram(λ)

where V_gram(λ) reduces to V_gram when λ > 0 and is vacuous when λ = 0.

## D5: Stratum Selector — Content-Style Tradeoff λ

λ ∈ [0, ∞) acts as a continuous stratum selector:

- **λ = 0:** V(0) = V_recon. Only polynomial (squared-norm) singularity.
- **λ → ∞:** V(∞) = V_gram. Only quadratic (Gram matrix) singularity.
- **λ ∈ (0, ∞):** V(λ) = V_recon ∩ V_gram. Intersection of polynomial and quadratic fibers.

The stratum structure: Λ_0 = V_recon, Λ_λ = V_recon ∩ V_gram for λ > 0.

Effective RLCT: λ_eff(λ) = RLCT(V(λ)) which transitions between RLCT(V_recon) and RLCT(V_gram) as λ varies.

**Comparison:** Unlike #864 (center loss) where both fibers are polynomial, here the fibers have structurally different singularity types (polynomial vs quadratic Gram). The rational singularity V_var is present in both strata as a background degeneracy.

## D6: Generalization Bound

  G(n, λ, C, L) ≤ λ_eff(λ) · log(n) / (2n) + U(λ, C, L) / √n

where:
- λ_eff(λ) = RLCT of V(λ) = min(RLCT(V_recon), RLCT(V_gram), RLCT(V_recon ∩ V_gram))
- U(λ, C, L) = fluctuation functional capturing decoder capacity and style feature dimension
- C = number of VGG style layers used
- L = decoder depth

Key properties:
- For λ near 0: G ≈ RLCT(V_recon) · log(n)/(2n) — content-dominated
- For λ large: G ≈ RLCT(V_gram) · log(n)/(2n) — style-dominated
- At λ*: G minimized when V_recon ∩ V_gram achieves transversal intersection (lowest λ_eff)
- V_var contributes an additive correction if variance collapse is approached: Δλ_var ~ codim(V_var) · log(n)/(2n)

## D7: Phase Transition at λ*

At critical λ*, the dominant singular fiber switches:

- **λ < λ*:** RLCT dominated by V_recon (content reconstruction). SGLD LLC ≈ RLCT(V_recon).
- **λ = λ*:** Transversal intersection V_recon ∩ V_gram. SGLD LLC spike (order parameter: Gram matrix rank r(G_dec - G_style)).
- **λ > λ*:** RLCT dominated by V_gram (style matching). SGLD LLC ≈ RLCT(V_gram).

**Order parameter:** ρ(λ) = rank(G_dec(λ) - G_style) / C — normalized Gram rank discrepancy. Sharp drop at λ*.

**Detection:** SGLD local learning coefficient (LLC) shows discontinuous jump at λ*, detectable via stochastic gradient Langevin dynamics sampling.

**Comparison to #864:** Both have λ* crossover, but #865 trades polynomial↔quadratic fibers (structurally different) while #864 trades CE↔center (both polynomial).

---

## Open Problems (from L0, updated)

1. **Rational singularity RLCT** — RLCT of V_var (division-by-zero) requires resolution of singularities for non-polynomial maps; Hironaka resolution applicability to rational maps is unproven
2. **Transversality V_recon ∩ V_gram** — whether intersection is transversal (codim = codim(V_recon) + codim(V_gram)) or has excess intersection
3. **Gram rank multiplicity** — how rank(ΔG) controls multiplicity m and hence RLCT of V_gram
4. **Frozen encoder interaction** — VGG ReLU piecewise structure creates non-smooth boundaries interacting with V_var; unanalyzed
5. **Multi-layer product fiber** — V_gram = ∩_l V_gram,l; transversality across layers unverified
6. **λ* existence** — may be monotonic (no crossover) or have multiple crossovers
7. **Variance collapse ε-regime** — with ε > 0 regularization, V_var becomes approximate; RLCT correction as ε → 0 unproven

## Cross-References

#8 (CE) #16 (ReLU) #57 (attention) #134 (QK^T) #169 (dropout)
#234 (batch norm) #355 (perceptual loss) #363 (adaLN) #433 (PolyLoss)
#466 (RMSNorm) #505 (weight norm) #515 (VAE) #539 (focal loss)
#592 (NovoGrad) #665 (Neural Collapse) #855 (capsule routing)
#860 (LARS) #864 (center loss)
