#622 Determinantal Variety Resolution × RLCT — L4 Scrutiny Summary

## Pipeline Status
- L0: Raw notes ✓
- L1: Formal definitions D1-D7, claims C1-C5 ✓
- L2: Novelty PASSED — zero external SLT/RLCT × determinantal variety bridges ✓
- L3: MeTTa encoding (10 type decls, D1-D7, 5 PLN chains, 5 caveats, 10 cross-refs) ✓

## Claim-by-Claim Scrutiny

### C1 (PROVEN, stv 1.0 0.95): R_an,exp Definability
**Confidence: HIGH.** Standard algebraic geometry. Determinantal varieties are polynomial zero-sets; polynomials are R_an,exp-definable. No dispute possible. Confidence could be 1.0 but 0.95 accounts for minor edge cases in non-standard loss functions.

### C2 (PROVEN-with-gap, stv 0.9 0.85): Exact RLCT = codim/2
**Confidence: HIGH (mathematically), MODERATE (NN applicability).** The RLCT=codim/2 formula under functorial resolution + transversality is established Watanabe theory. The gap is transversality: it's generic (Thom) but unverified for specific NN architectures. For non-transversal losses, λ > codim/2. Risk: if NN losses systematically violate transversality (e.g., due to symmetry), the exact formula fails and reverts to upper bound only.

### C3 (CONJECTURAL, stv 0.5 0.7): Rank as Stratum Selector
**Confidence: LOW-MODERATE.** The core idea — SGD biases toward low-rank solutions, selecting high-RLCT strata — is plausible but the mechanism is indirect. Key weakness: effective rank is continuous, but determinantal strata are discrete. The thresholding step is ad hoc. Evidence from weight decay (#222) and attention collapse (#134) is suggestive but not conclusive. Risk: the stratum selection may be a smooth phenomenon better modeled by continuous RLCT rather than discrete strata.

### C4 (CONJECTURAL, stv 0.6 0.75): Generalization Bound with Exact λ
**Confidence: MODERATE.** The formula G(n) ~ λ log(n)/(2n) + U/√n + B is standard Watanabe. The novelty is using EXACT λ = (m-r)(n-r)/2 rather than an upper bound. The boundary term U is unknown and depends on transversality defect. Multi-layer additivity (λ_total = λ_1 + λ_2) is unproven and likely false in general. Risk: without computing U, the bound's practical tightness is unclear.

### C5 (CONJECTURAL, stv 0.5 0.65): Phase Transition at r*
**Confidence: LOW-MODERATE.** The phase transition prediction is the most empirically testable claim. r* trades capacity (low rank = underfitting) vs generalization (high rank = lower λ = worse gen). SGLD should detect a jump in LLC at rank transitions. Key uncertainty: r* is data/architecture-dependent with no closed form. The transition may be smooth crossover rather than sharp phase change. Risk: SGLD resolution may be insufficient to distinguish discrete jumps from smooth gradients.

## Key Risks
1. **Transversality failure:** If NN losses are systematically non-transversal to determinantal strata, C2-C4 all weaken. This is the single biggest vulnerability.
2. **Discrete vs continuous:** The determinantal framework assumes integer rank strata, but neural network effective rank is continuous. The bridge between these is hand-waved.
3. **Multi-layer composition:** Real NNs have multiple weight matrices. The RLCT of compositions is not simply additive. This limits practical applicability.
4. **Empirical validation gap:** No SGLD experiments have been run. All predictions are theoretical.

## Predicted Empirical Signatures
1. SGLD LLC should show discrete jumps at rank transitions in LoRA adapters (varying r)
2. Attention heads should show LLC ≈ (d-1)²/2 at rank-1 collapse (D_1 stratum)
3. Generalization error vs LoRA rank r should show U-shape with minimum at r*
4. Adam second-moment degeneracy should correlate with LLC increase matching D_r codim/2

## Unification Value
This synthesis provides a GEOMETRIC BACKBONE unifying 10 prior syntheses:
- #134 (attention collapse → D_1 fiber)
- #289 (Adam degeneracy → D_r fiber)
- #371 (fast weights → D_r fiber)
- #502 (LoRA → explicit D_r constraint)
- #473 (spectral norm → D_r ∩ spectral ball)
- #89 (tensor decomp → secant = determinantal)
- #222 (weight decay → implicit low-rank bias → D_r selection)
- #415 (Muon → SO(d) fiber near D_r)
- #298 (orthogonal init → Stiefel ⊂ D_full)
- #253 (o-minimal cell decomposition → foundational)

## Overall Assessment
**Strongest claims:** C1 (trivially true), C2 (mathematically solid, NN-applicability gap)
**Weakest claims:** C3 (mechanism unclear), C5 (empirical prediction untested)
**Novelty:** Genuinely novel — no prior work bridges determinantal variety resolution with SLT/RLCT in the NN context. The exact-λ generalization bound and rank-as-stratum-selector concepts are new.
**Priority for empirical validation:** HIGH — this synthesis makes specific, testable predictions about SGLD LLC behavior at rank transitions.

Date: 2026-10-25
Status: L4 COMPLETE. Next: L5 catalog append.