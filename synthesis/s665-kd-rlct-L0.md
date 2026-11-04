#665 Knowledge Distillation (KD) × RLCT
## Synthesis L0: Hypothesis & Overview

**Date:** 2026-10-28  
**Status:** L0 — Candidate synthesis, C1 PROVEN, C2-C5 CONJECTURAL  
**Prior coverage:** Zero direct catalog hits for KD × RLCT. Prior KD attempts (#109, #188, #224, #261, #293, #507, #560, #571, #600) all either duplicate selections or incomplete pipelines. This is the first L0 written with full cross-reference awareness.

---

### 1. Setup

Knowledge Distillation (Hinton et al. 2015) trains a student network f_s(θ) to match a pre-trained teacher f_t(φ) via a composite loss:

L_KD(θ, τ) = (1-α) · CE(y, f_s(θ)) + α · τ² · KL(softmax(z_t/τ) || softmax(z_s(θ)/τ))

where z_t, z_s are teacher/student logits, τ is the distillation temperature, α is the hard/soft loss weight, and τ² normalizes the gradient magnitude.

### 2. Five Claims

**C1 (PROVEN): R_{an,exp}-definability of KD loss.**
The KD loss is a composition of: (a) softmax = exp(·)/Σexp(·) — analytic, (b) KL divergence = Σ p_t log(p_t/p_s) — analytic on {p_s > 0}, (c) cross-entropy — analytic, (d) linear combination — closed. By closure properties of R_{an,exp}, L_KD ∈ R_{an,exp}(θ; τ). ∎

**C2 (CONJECTURAL): Teacher-student logit ratio defines intersection fiber.**
The zero-loss set V_KD(τ) = {θ : L_KD(θ,τ) = 0} decomposes as V_hard ∩ V_teacher(τ), where V_hard = {θ : f_s(θ) = y} and V_teacher(τ) = {θ : softmax(z_s(θ)/τ) = softmax(z_t/τ)}. The intersection V_hard ∩ V_teacher(τ) has codim ≥ max(codim V_hard, codim V_teacher). Under transversality, the RLCT of the intersection λ_KD(τ) ≤ λ_hard (the hard-label RLCT). Teacher "dark knowledge" (soft logit structure) raises effective codimension, reducing λ.

**C3 (CONJECTURAL): Temperature τ is a continuous stratum selector.**
As τ varies, V_teacher(τ) forms a filtration {V_teacher(τ)}_τ. At τ→0, softmax(z/τ) → onehot(argmax z), recovering hard-label singularity (full singular structure). At τ→∞, softmax(z/τ) → uniform, collapsing all logit information (no singularity from teacher term). Intermediate τ creates partial singular structure — a stratum interpolation. The family {V_KD(τ)} defines a 1-parameter stratum selection analogous to #234 (temperature scaling) but in the teacher-student relative geometry.

**C4 (CONJECTURAL): Generalization bound with τ-dependent effective RLCT.**
By the standard SLT bound, generalization gap G_KD(τ) ~ λ_KD(τ)/n + U(τ)/√n, where λ_KD(τ) is the RLCT of V_KD(τ) and U(τ) is the singular fluctuation. Conjecture: λ_KD(τ) is monotonically increasing in τ for τ ∈ (0, τ*] and decreasing for τ ∈ [τ*, ∞), yielding a U-shaped λ_KD(τ) with optimal τ* at the minimum. The student capacity d (parameter count) modulates τ*: smaller students benefit from higher τ (more smoothing), larger students from lower τ (less smoothing). This predicts the empirically observed capacity-dependent optimal temperature.

**C5 (CONJECTURAL): Phase transition at τ* between hard-target and soft-target regimes.**
At τ*, the dominant singularity switches from the hard-label stratum (V_hard) to the teacher-smoothed stratum (V_teacher(τ*)). SGLD local learning coefficient (LLC) estimation should show a discontinuity in dλ/dτ at τ*, observable as a phase transition in the learning coefficient landscape. Below τ*, the student converges to hard-label singular solutions; above τ*, to teacher-matched soft solutions. The transition is analogous to the U-shaped guidance scale in #362 (CFG × RLCT).

### 3. Key Novelty

- **Teacher-student fiber intersection:** KD is the first synthesis where the zero-loss set is an *intersection* of two model-defined varieties (student hard-label + teacher soft-label), not a single model variety.
- **τ as stratum selector with teacher reference:** Distinct from #234 (temperature scaling = self-calibration, no teacher reference) and #224 (label smoothing = fixed ε perturbation, no learned teacher).
- **Capacity-dependent τ*:** The optimal temperature depends on student capacity d, a novel prediction linking model size to distillation hyperparameter.
- **Dark knowledge = stratum information:** Teacher soft logits carry information about the teacher's singular stratum geometry, transferred to the student via the intersection fiber.

### 4. Cross-References

| # | Topic | Relation |
|---|-------|----------|
| #224 | Label Smoothing × RLCT | ε-perturbation (fixed, no teacher) vs τ-scaled softmax (learned teacher) |
| #234 | Temperature Scaling × RLCT | Self-calibration T vs teacher-guided τ |
| #169 | Dropout × RLCT | Stochastic stratum selector vs deterministic τ |
| #434 | MoE × RLCT | Routing strata vs teacher-student strata |
| #507 | Noisy Student × RLCT | Student-only noise vs teacher-guided smoothing |
| #560 | Prior KD attempt | This supersedes with complete pipeline |
| #362 | CFG × RLCT | U-shaped guidance scale analogy to U-shaped λ_KD(τ) |
| #100 | Weight Decay × RLCT | L2 regularization stratum vs teacher KL stratum |
| #226 | EMA × RLCT | Self-distillation via EMA teacher (special case of KD) |
| #582 | Curriculum Learning × RLCT | Data distribution modulation vs target distribution modulation |
| #544 | Continual Learning × RLCT | Stratum preservation (EWC) vs stratum transfer (KD) |
| #556 | VQ-VAE × RLCT | Codebook collapse vs teacher matching |

### 5. Open Problems

1. Prove λ_KD(τ) ≤ λ_hard under transversality (intersection fiber codim bound)
2. Characterize the filtration {V_teacher(τ)}_τ as a stratified family — is it constructible? semi-algebraic?
3. Derive explicit τ*(d) dependence on student capacity d — is it logarithmic, polynomial, or other?
4. SGLD LLC estimation: can the phase transition at τ* be empirically detected?
5. Feature-based KD (FitNets) — does intermediate-layer matching create additional singular strata?
6. Self-distillation limit: as f_s → f_t (same architecture), does V_KD → V_hard (trivial) or retain non-trivial structure?
7. Multi-teacher KD: does the intersection fiber V_KD = V_hard ∩ V_teacher1 ∩ V_teacher2 have RLCT bounded by min over teachers?

### 6. Distinction from Prior KD Work

This synthesis is distinct from all prior catalog entries:
- #560 (prior KD attempt, L0-L5 incomplete): L0 only, no L1-L5 pipeline completed
- #571 (prior KD attempt): L0 only, "logit-space heat semigroup" framing — different geometric framework
- #293 (prior KD attempt, L0-L5): Used "temperature is a singularity selector" — this synthesis formalizes the *intersection fiber* and *capacity-dependent τ* as novel contributions
- #261, #224, #188, #109: All abandoned at L0 or duplicate selections