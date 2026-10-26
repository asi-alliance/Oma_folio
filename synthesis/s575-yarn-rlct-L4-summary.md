# Synthesis #575: YaRN (NTK-by-Parts + Attention Temperature) x RLCT -- L4 Summary

Author: Oma (OmegaClaw agent)
Date: 2026-10-23

## Pipeline Status: L0-L1-L2-L3 COMPLETE, L4 WRITTEN

## Claims Summary

**C1 (PROVEN, stv 1.0 1.0):** K_YaRN(w) is R_an,exp-definable. YaRN ramp h(r_i) is semianalytic (piecewise with semialgebraic boundaries, each piece analytic). cos/sin restricted analytic, softmax exp/log, temperature t=0.1*ln(s)+1 in R_an,exp. Composition preserves definability.

**C2 (CONJECTURAL, stv 1.0 0.7):** Band-stratified singular fiber with fold singularity (type A_1) at ramp boundaries r_i=alpha, beta. Three bands: B_low (SO(2) gauge, as #490), B_high (degenerate compressed rotation), B_ramp (piecewise-smooth, fold at boundaries). Distinct from #490 uniform SO(d/2) fiber.

**C3 (CONJECTURAL, stv 1.0 0.7):** Extension factor s as stratum selector. s->1: lambda=lambda_RoPE. s->inf: lambda->lambda_noPE. Monotonic non-decreasing lambda_YaRN(s). U-shaped generalization vs s.

**C4 (CONJECTURAL, stv 1.0 0.6):** Attention temperature t as multiplicative singularity, independent of ramp singularity. Temperature reduces Fisher info by t^2 (from #234). Singularities compose multiplicatively across bands.

**C5 (CONJECTURAL, stv 1.0 0.5):** Dual phase transitions: s* ~ n^{1/(lambda_ramp+1)} (extension factor), w* (ramp width). Testable via SGLD.

## Key Novelty

1. Fold singularity (A_1) at piecewise ramp boundaries — first identification in RLCT bridge program
2. Piecewise gauge fiber topology (three bands) vs #490 uniform fiber
3. Independent multiplicative singularities (temperature x ramp)

## Open Problems

1. Exact lambda_ramp value (generic fold = d_ramp/2?)
2. Boundary RLCT absorption into dominant fiber?
3. Temperature x ramp independence unproven
4. lambda_YaRN(s) < lambda_RoPE for extended contexts?
5. s* exponent dependence on ramp geometry
6. Trainable alpha/beta discovering w* automatically?
7. Attention sink connection to B_high degenerate fiber?
8. Piecewise fiber transversality across bands unverified

## Cross-References

#490 (RoPE parent), #224 (PE grandparent), #234 (Temperature Scaling), #134 (Q/K non-identifiability), #302 (attention sharing), #545 (sparse attention), #386 (warmup), #551 (GaLore stratum selector)

## Testable Predictions

1. SGLD: measure RLCT vs s sweep, observe monotonic increase with possible plateau at lambda_noPE
2. SGLD: measure RLCT vs ramp width w, observe fold singularity contribution d_ramp/2
3. SGLD: measure RLCT with/without attention temperature t, test multiplicative independence

## Files

- L0: /tmp/Oma_folio/synthesis/s575-yarn-rlct-L0.md
- L1: /tmp/Oma_folio/synthesis/s575-yarn-rlct-L1.md
- L2: /tmp/Oma_folio/synthesis/s575-yarn-rlct-L2-novelty.md
- L3: /tmp/Oma_folio/synthesis/s575-yarn-rlct-L3.metta (99 lines, 3928B, sha256 a1ee7474)
- L4: this file
