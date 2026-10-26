# Synthesis #653: Depthwise Separable Convolution × RLCT
## L2 — Novelty Verification

**Date:** 2026-10-26
**Status:** NOVELTY VERIFIED

### Websearch Results (5 searches)

1. "singular learning theory depthwise separable convolution RLCT algebraic geometry loss landscape" → 0 hits
2. "singular learning theory RLCT depthwise convolution separable convolution neural network 2025 2026" → 0 hits
3. "RLCT singular learning theory grouped convolution channel factorization neural network generalization" → 0 hits
4. "singular learning theory MobileNet Xception efficient architecture generalization bound algebraic geometry" → 0 hits
5. "singular learning theory channel group convolution factorization algebraic singularity generalization bound 2025 2026" → 0 hits

**Verdict:** Zero SLT/RLCT bridge to depthwise/separable/grouped convolution found.

### Catalog Overlap Analysis

Grep for depthwise|separable|mobile|block-diagonal|grouped|conv|channel|spatial|factor in synthesis-catalog.md → 0 direct hits.

Related entries checked and confirmed DISTINCT:

- **#223 LoRA × RLCT:** Learned low-rank adaptation (ΔW=BA, rank-r constraint on weight UPDATES). Depthwise conv is ARCHITECTURAL factorization (block-diagonal structure baked into forward pass). LoRA constrains the parameter update space; depthwise constrains the computation graph. Different singularity mechanism: LoRA limits which fibers are reachable during fine-tuning; depthwise creates a different fiber structure from the start.

- **#472 SE-Net × RLCT:** Channel attention via squeeze (GAP) + excitation (MLP→sigmoid). SE-Net MULTIPLICATIVELY rescales channels after a dense conv. Depthwise conv FACTORIZES the conv operation itself. SE-Net singularity: GAP quotient + sigmoid saturation. Depthwise singularity: block-diagonal Jacobian rank deficiency. Completely different singularity types.

- **#535 Word2Vec × RLCT:** Embedding dimension as stratum selector. Depthwise uses GROUP COUNT g as stratum selector. Word2Vec stratum is about representation dimension; depthwise stratum is about computational factorization granularity. Different mechanisms.

- **#134 Self-Attention × RLCT:** Full pairwise mixing via QK^T softmax. Depthwise explicitly AVOIDS cross-channel mixing in spatial step. Attention singularity: softmax saturation + rank deficiency of attention matrix. Depthwise singularity: block-diagonal determinantal variety. Orthogonal architectures.

- **#303 Skip Connections × RLCT:** Alternative gradient paths bypassing singular strata. Depthwise creates DIFFERENT singular strata, not bypass paths. Different mechanism entirely.

### Key Novel Contributions

1. **Architectural factorization singularity** — first RLCT analysis of decomposing a dense operation into block-diagonal + full-rank stages (not learned low-rank like LoRA, not parameter sparsity like pruning)
2. **Block-diagonal Jacobian fiber** — V_dw = ∪_c V_c (union of C independent determinantal varieties), RLCT by independence = max_c RLCT(V_c)
3. **Group count g as continuous stratum selector** — interpolates dense (g=1) to depthwise (g=C), controlling singular locus dimension
4. **Hierarchical singularity** — two-stage composition J_total = J_pw ∘ J_dw creates V_total = V_dw ∪ V_pw ∪ V_comp
5. **Phase transition g*** — predicted step-like RLCT decrease at critical group count, SGLD testable

### Distinction Summary

| Feature | #223 LoRA | #472 SE-Net | #220 Pruning | #653 Depthwise |
|---------|-----------|-------------|--------------|---------------|
| Mechanism | Learned low-rank | Channel attention | Parameter removal | Architectural factorization |
| Singularity type | BA product fiber | GAP quotient + sigmoid | Sparse support fiber | Block-diagonal determinantal |
| Stratum selector | Rank r | Reduction ratio r | Sparsity s | Group count g |
| Where applied | Fine-tuning updates | Post-conv rescaling | Weight mask | Forward pass structure |
| Novel? | Yes | Yes | Yes | Yes |

### Verdict: NOVEL

All related catalog entries are distinct. Zero websearch SLT/RLCT bridge. C1 standard-novel (R_an,exp definability via composition closure). C2-C5 genuinely novel (block-diagonal fiber, group-count stratification, subadditive gen bound, g* phase transition).
