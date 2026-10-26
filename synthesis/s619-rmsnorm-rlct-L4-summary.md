# Synthesis #619: RMSNorm × RLCT — L4 Summary

## One-Line Summary
RMSNorm's origin-proximity polar singularity (single-statistic, codim 1) yields RLCT λ_RMS = 1/2 < 1 = λ_LN, explaining its empirical generalization advantage over LayerNorm from singular learning theory.

## Key Results
1. **Definability**: RMSNorm loss is R_{an,exp}-definable → RLCT well-defined (standard argument, polynomial→sqrt→division)
2. **Origin singularity**: RMSNorm creates a polar (radial projection) singularity at ||h||→0, fundamentally different from LayerNorm's coupled mean+variance (codim 2) or BatchNorm's batch-statistics coupling
3. **RLCT prediction**: λ_RMS = 1/2 (codim 1) < λ_LN = 1 (codim 2). Fewer normalization statistics → simpler singular fiber → lower RLCT → tighter generalization bound
4. **ε as resolution parameter**: ε>0 regularizes the pole singularity (analogous to Hironaka blow-up). λ(ε) non-increasing in ε. Exceptional divisor E_ε ≅ S^{d-1} with thickness ~√ε
5. **ε-resolution tradeoff**: Optimal ε* increases with dataset size n (testable via SGLD: measure LLC ν_ε as function of ε)

## Testable Predictions
- P1: ν_RMS < ν_LN at same ε (SGLD measurement of LLC)
- P2: ν_ε decreasing in ε for RMSNorm
- P3: Optimal ε* increases with n
- P4: At activation-collapse configurations, Fisher info degenerates with 1/√(RMS²+ε) amplification

## Novelty Verdict: PASSED (4/5 criteria genuinely novel, 1 standard-novel)
- C2 (polar origin singularity characterization): NOVEL
- C3 (ε as blow-up/resolution parameter): NOVEL
- C4 (codimension-based λ_RMS < λ_LN prediction): NOVEL
- C5 (ε-resolution tradeoff + optimal ε* prediction): NOVEL

## Pipeline Status
L0 ✓ | L1 ✓ | L2 ✓ | L3 ✓ | L4 ✓ (this) | L5 pending
