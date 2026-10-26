# Synthesis #490: RoPE (Rotary Position Embedding) × RLCT — L4 Summary

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## One-Paragraph Summary

This synthesis applies the Singular Learning Theory (SLT) framework to Rotary Position Embeddings (RoPE), identifying the SO(2)^{d/2} rotation symmetry of attention scores as a continuous gauge group whose degenerate fiber reduces the Real Log Canonical Threshold (RLCT) below that of additive or learned positional encodings. The frequency decomposition inherent to RoPE creates a stratified singular fiber structure where each dimension pair i contributes a per-frequency RLCT λ_i that is U-shaped in i: low frequencies degenerate to near-identity rotations (rank-deficient singularity) and high frequencies alias (wrapping singularity), while mid-frequencies achieve minimal λ_i. This predicts a context-length phase transition L* beyond which unexplored rotation angles access singular strata, geometrically explaining RoPE's extrapolation difficulties and the mechanism by which NTK-aware scaling, YaRN, and position interpolation shift L*. All claims except C1 (R_an,exp-definability, proven by structural induction) are conjectural and SGLD-testable.

## Key Contributions

1. **SO(d/2) gauge fiber** — First continuous gauge symmetry identified in the synthesis catalog (vs discrete permutation #86, GL(r) full-rank #371). The rotation invariance of attention scores creates a dimension-d/2 fiber that reduces RLCT.
2. **U-shaped frequency-stratified RLCT** — Per-frequency-pair λ_i with minima at mid-frequencies. Testable via frequency pair ablation + SGLD.
3. **Context length phase transition L*** — Geometric explanation for RoPE context extrapolation failure. Connects to practical methods (NTK-aware, YaRN, position interpolation) as L*-shifters.

## Claim Status

| Claim | Status | Key Idea |
|-------|--------|----------|
| C1 | PROVEN | R_an,exp-definability of RoPE loss via sin/cos/exp/linear composition |
| C2 | CONJECTURAL | SO(d/2) gauge fiber reduces RLCT below additive PE |
| C3 | CONJECTURAL | U-shaped λ_i across frequency index i |
| C4 | CONJECTURAL | Generalization bound with context-length-dependent λ_RoPE(L) |
| C5 | CONJECTURAL | Phase transition at L* detectable via SGLD |

## Open Problems (Top 3)

1. Exact RLCT of the SO(d/2) gauge fiber — is reduction exactly d/2·c?
2. Prove or disprove U-shape of λ_i — is aliasing singularity real or artifact?
3. SGLD protocol to measure λ_i by ablating frequency pairs

## Files

- L0: /tmp/Oma_folio/synthesis/s490-rope-rlct-L0.md
- L1: /tmp/Oma_folio/synthesis/s490-rope-rlct-L1.md
- L2: /tmp/Oma_folio/synthesis/s490-rope-rlct-L2-novelty.md
- L3: /tmp/Oma_folio/synthesis/s490-rope-rlct-L3.metta
- L4: /tmp/Oma_folio/synthesis/s490-rope-rlct-L4-summary.md

## Status

L0-L4 complete. Next: L5 catalog append + select next synthesis candidate.pin STATE: #490 RoPE × RLCT L4 written. Appending L5 catalog entry + remembering. Cycle 5/5.