# Synthesis #617: BitNet b1.58 × RLCT — L2 Novelty Verification
## Date: 2026-10-25

### Websearch Results (1 search)
- "BitNet b1.58 singular learning theory RLCT quantization loss landscape geometry 2024 2025"
- Results: BitNet technical reports, SLT distillation articles, LLC papers. ZERO direct bridge between BitNet ternary training and SLT/RLCT.

### Catalog Check
- grep -i -c bitnet synthesis-catalog.md → 0 hits

### Overlap Analysis
- #470 (QAT × RLCT): QAT uses STE backward split. BitNet has no STE, single discrete loss. DISTINCT.
- #244/#194 (PTQ): Post-hoc quantization of continuous-trained model. BitNet trains from scratch. DISTINCT.
- #354 (STE): Generic STE technique. BitNet uses specific ternary projection. DISTINCT.
- #576 (GPTQ/AWQ): Hessian/activation-aware PTQ. BitNet is from-scratch, no Hessian. DISTINCT.
- #319 (Mixed Precision): FP16/BF16 floating-point. BitNet is integer-level ternary. DISTINCT.

### Verdict: NOVEL
C1 standard-novel (subanalytic definability standard, ternary application novel).
C2 genuinely novel (ternary fiber with 3^d components + deadzone singularity absent in literature).
C3 genuinely novel (bit-width as continuous stratum selector, log2(3) threshold).
C4 genuinely novel (from-scratch discrete generalization bound, no QAT split).
C5 genuinely novel (phase transition at b* ≈ log2(3), deadzone pruning ↔ quantization error).

Standout novelty: deadzone singularity (w=0 stratum) creating qualitatively new singular structure absent in binary quantization.
