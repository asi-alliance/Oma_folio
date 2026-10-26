# Synthesis #617: BitNet b1.58 × RLCT — L4 Summary
## Date: 2026-10-25

## Pipeline Status: L0-L4 COMPLETE, L5 pending

## Claims Digest
- C1 (PROVEN): Ternary projection Q_s(w)=sign(w)·1[|w|>s] is subanalytic; quantized loss K_Q=L∘Q_s is R_an,exp-definable. Standard closure argument applied to ternary grid.
- C2 (CONJECTURAL): Ternary fiber V_Q has 3^d components with deadzone S_0={|w_i|≤s} creating codimension-0 stratum absent in binary. RLCT determined by cell boundary geometry + deadzone. Key open question: RLCT well-definedness on piecewise-constant loss.
- C3 (CONJECTURAL): λ_binary ≤ λ_ternary ≤ λ_continuous. Bit-width b=log2(3)≈1.585 as stratum selector; deadzone scale s modulates within ternary stratum.
- C4 (CONJECTURAL): G_BitNet ≤ λ_ternary·log(n)/(2n) + U(ternary,s)/√n. From-scratch training = single discrete RLCT, no QAT forward/backward split.
- C5 (CONJECTURAL): Phase transition at b*≈log2(3) where deadzone pruning ↔ quantization error dominance switches. Detectable via SGLD LLC inflection.

## Key Novelty
Deadzone singularity: the {0} level in ternary {-1,0,+1} creates a fundamentally new singular stratum absent in binary ±1 quantization. This codimension-0 deadzone region (closed cube, not hypersurface) is unique to ternary and structurally distinct from both binary (no zero) and continuous (no quantization). The 3^d fiber components (vs 2^d binary, 1 continuous) create exponential non-identifiability with distinct geometry.

## Distinction from Prior Work
- #470 (QAT): STE backward split → two RLCTs. BitNet: single discrete loss, one RLCT.
- #244/#194 (PTQ): Continuous training then quantize. BitNet: never trains in continuous space.
- #576 (GPTQ/AWQ): Hessian-based PTQ. BitNet: from-scratch, no Hessian info.
- #354 (STE): Generic technique. BitNet: specific ternary projection.

## Open Problems (7)
1. RLCT well-definedness on piecewise-constant ternary loss
2. Toric geometry of 3^d ternary cells (3-ray cone fan?)
3. Deadzone scale s as learnable adaptive stratum selector
4. λ_BitNet vs λ_QAT formal comparison
5. SGLD LLC protocol for piecewise-constant losses
6. Ternary × MoE routing compound singularities
7. b* universality across architectures

## Cross-References
#470 #244 #194 #354 #576 #319 #88 #98 #100 #162 #199 #556 #89 #8 #16 #370

## Lineage
#8/#16 (baseline) → #194/#244 (PTQ) → #354 (STE) → #470 (QAT) → #576 (GPTQ/AWQ) → #617 (BitNet from-scratch ternary)
