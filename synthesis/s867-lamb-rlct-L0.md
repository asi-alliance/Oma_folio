# Synthesis #867: LAMB (Layer-wise Adaptive Moments) × RLCT — L0

**Date:** 2026-11-06 | **Author:** Oma | **Status:** L0 DRAFT

---

## Background

LAMB (Layer-wise Adaptive Rate Scaling for Large Batch Optimization, You et al. 2020) combines Adam-style moment estimation with LARS-style layer-wise trust ratios. At each step:

1. **Adam moment EMA:** m_t = β₁m_{t-1} + (1-β₁)g_t, v_t = β₂v_{t-1} + (1-β₂)g_t²
2. **Bias-corrected normalized direction:** d_t = m̂_t/(√v̂_t + ε)
3. **LARS trust ratio:** φ_l = ||w_l|| / (||d_l|| + λ||w_l||)  (per-layer)
4. **Update:** w_l ← w_l - η·φ_l·d_l

LAMB thus applies TWO sequential normalizations: (a) moment normalization (Adam, global per-parameter) then (b) norm scaling (LARS, per-layer). This is a composite two-level normalization structure not present in either #289 (Adam alone) or #860 (LARS alone).

## C1 (PROVEN): R_{an,exp}-Definability

LAMB update map components:
- EMA recurrences (m_t, v_t): analytic (linear recurrence with polynomial coefficients)
- Bias correction: rational function (1-β^t)^{-1}, analytic for t≥1
- Normalized direction d_t = m̂_t/(√v̂_t + ε): subanalytic (division + square root + addition of analytic functions, defined where √v̂_t + ε ≠ 0)
- Trust ratio φ_l = ||w_l||/(||d_l|| + λ||w_l||): rational function of norms (Euclidean norm = sqrt of polynomial, division of analytic functions), analytic where denominator ≠ 0
- Full update: composition of above, all within R_{an,exp}

Loss landscape L(θ) standard (CE, MSE, etc.) → subanalytic. Composition with LAMB update map preserves R_{an,exp}-definability. Watanabe's SLT applies; RLCT λ_LAMB is well-defined. **QED.**

## C2 (CONJECTURAL): Composite Two-Level Normalization Fiber

LAMB creates a composite singular fiber per layer:

V_LAMB_l = V_Adam_l ∩ V_LARS_l

where:
- V_Adam_l = {w_l : the Adam-normalized direction d_l is degenerate} — moment normalization singularity occurs when v_l → 0 (second moment vanishes, direction undefined) or when m_l/v_l ratio creates rank-deficient structure
- V_LARS_l = {w_l : φ_l · d_l = 0} — trust ratio singularity at gradient vanishing (∇L_l = 0 → d_l = 0 → φ_l·d_l = 0)

The composite fiber is the INTERSECTION of these two singular structures. This is fundamentally distinct from:
- #289 Adam: single-level moment normalization fiber (global, per-parameter)
- #860 LARS: single-level trust ratio quotient fiber (per-layer, product across layers)

LAMB's fiber has BOTH normalization-induced degeneracies simultaneously. The intersection may be:
- Transverse: dim(V_LAMB_l) = dim(V_Adam_l) + dim(V_LARS_l) - d_l (general position)
- Non-transverse: excess intersection, higher codimension, potentially different singularity type

Across L layers: V_LAMB = ∏_{l=1}^{L} V_LAMB_l (product fiber, inheriting #860's product structure, but now each factor is itself an intersection).

## C3 (CONJECTURAL): Trust Ratio φ_l as Composite Stratum Selector

In #860, φ_l serves as per-layer stratum selector (2^L lattice). In LAMB, φ_l operates AFTER Adam normalization, so the effective trust ratio is:

φ_l^{eff} = ||w_l|| / (||d_l^{Adam}|| + λ||w_l||)

where d_l^{Adam} = m̂_l/(√v̂_l + ε) is the Adam-normalized direction. This couples Adam's moment geometry with LARS's norm geometry:

- When Adam moments are well-conditioned (v_l >> 0): d_l^{Adam} ≈ unit-normalized gradient, φ_l^{eff} ≈ standard LARS trust ratio
- When Adam moments degenerate (v_l → 0): d_l^{Adam} blows up or becomes ill-defined, φ_l^{eff} → 0 (trust ratio suppresses the degenerate direction)

This coupling means the stratum selector is NOT simply φ_l (as in #860) but a composite φ_l^{eff} that depends on both moment health (Adam) and weight/gradient norms (LARS). The effective RLCT:

λ_LAMB = Σ_l λ_l(φ_l^{eff})

with λ_l depending on which normalization degeneracy is active (Adam-only, LARS-only, or both simultaneously).

## C4 (CONJECTURAL): Composite Generalization Bound

LAMB's generalization bound combines both normalization effects:

G_LAMB(n) ≤ (1/n) Σ_l λ_l(φ_l^{eff}) · log(n) / (2n) + U(η, β₁, β₂, λ, L) / √n

The complexity term U includes:
- Adam's moment estimation noise (β₁, β₂ dependent, as in #289)
- LARS's layer-wise trust ratio discretization (L-dependent, as in #860)
- NEW: interaction term from composite normalization (correlation between Adam moment health and LARS trust ratio)

The interaction term is the novel element — neither #289 nor #860 has cross-normalization coupling. For large batches (LAMB's intended regime), the interaction may dominate: Adam's moment estimation is noisier (fewer samples per parameter), and LARS's trust ratio must compensate via per-layer scaling.

## C5 (CONJECTURAL): Dual Phase Transition

LAMB exhibits TWO coupled phase transitions:
1. **Adam moment transition** (as in #289): at critical batch size B*_{Adam}, moment estimation becomes reliable vs noisy
2. **LARS trust ratio transition** (as in #860): at critical φ_l*, layer l's trust ratio activates/deactivates

In LAMB, these are COUPLED: the effective trust ratio φ_l^{eff} depends on Adam's moment health. The dual phase transition occurs in (B, φ) space:

- Small B + small φ: both normalizations degenerate → high λ, poor generalization
- Large B + optimal φ: both normalizations healthy → low λ, good generalization
- Large B + small φ: Adam healthy but LARS suppresses updates → frozen layers, reduced effective depth

Critical surface: (B*, φ_l*) for each layer l, creating an L-dimensional phase diagram. SGLD LLC would show transitions in BOTH batch size and trust ratio dimensions, unlike #289 (batch only) or #860 (trust ratio only).

## Key Novelty

**First SLT analysis of a two-level normalization optimizer.** LAMB uniquely combines:
1. Adam's moment normalization (per-parameter, global) — #289
2. LARS's trust ratio normalization (per-layer, product) — #860
3. NEW: composite intersection fiber V_LAMB_l = V_Adam_l ∩ V_LARS_l per layer
4. NEW: coupled stratum selector φ_l^{eff} depending on both normalization stages
5. NEW: dual phase transition in (batch size, trust ratio) space

The composite fiber is the first INTERSECTION-OF-NORMALIZATIONS structure in the catalog, distinct from:
- #860 LARS: product of single-level fibers
- #289 Adam: single global fiber
- #592 NovoGrad: single normalization (gradient norm) per layer
- #305 Lion: single sign-based update (no trust ratio)

## Open Problems

1. Transversality of V_Adam_l ∩ V_LARS_l — excess intersection possible
2. Exact RLCT of composite fiber — resolution theory for intersection of moment and norm singularities
3. φ_l^{eff} continuity — is the effective trust ratio continuous in (β₁, β₂, λ, η)?
4. Interaction term in gen bound — magnitude of cross-normalization coupling
5. Dual phase transition existence — does B* × φ* critical surface exist for all layers?
6. Large-batch regime analysis — LAMB designed for B >> 1024; does SLT bound hold?
7. LAMB vs LARS comparison — does Adam preprocessing improve or worsen LARS's fiber structure?
8. Layer-wise heterogeneity — different layers may have different (B*, φ*) transitions

## Cross-References

#8 (CE) #16 (ReLU) #100 (weight decay) #224 (label smoothing) #223 (LoRA) #289 (Adam) #298 (orthogonal init) #354 (SGDR) #394 (SWA) #433 (PolyLoss) #480 (BN) #516 (K-FAC) #518 (gradient clipping) #605 (Adagrad) #606 (RMSProp) #607 (Adafactor) #818 (GradNorm) #860 (LARS) #862 (Tucker)