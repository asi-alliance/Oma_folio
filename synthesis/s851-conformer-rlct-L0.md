# Synthesis #851: Conformer (Convolution-augmented Transformer) × RLCT
## Date: 2026-11-06
## Status: L0 — Exploration & Claims

## Topic
Conformer architecture (Gulati et al. 2020) — a neural network block that interleaves multi-head self-attention, depthwise convolution, and Macaron-style dual feedforward modules to capture both local and global sequential dependencies. Used primarily in speech recognition (ASR) and sequence modeling.

## Architecture Structure
A Conformer block processes input x through four sub-modules in sequence:
1. **FFN-1 (half-step)**: LayerNorm → FFN → ×0.5 residual. Macaron-style half-step feedforward.
2. **MHSA**: Multi-head self-attention with relative positional encoding.
3. **Conv module**: LayerNorm → Pointwise Conv → GLU → Depthwise Conv → BN → Swish → Pointwise Conv → ×0.5 residual.
4. **FFN-2 (half-step)**: LayerNorm → FFN → ×0.5 residual.

The key architectural feature is the INTERLEAVING of attention (global) and convolution (local) computation paths within a single block, creating a product-like computational structure.

## Core SLT Bridge
The Conformer block defines a composite function f(x) = x + 0.5·FFN1(x) + MHSA(x) + Conv(x) + 0.5·FFN2(x). From an SLT perspective:

- **Attention singular fiber** (from #134/#302): The self-attention module has singularities at attention weight rank degeneracy (QK^T rank collapse, softmax saturation, head collapse). The attention fiber V_attn = {W : attention output loses rank}.

- **Convolution singular fiber** (from #653): The depthwise convolution module has singularities at filter symmetry (kernel permutation, channel scaling degeneracy, GLU gating boundary). The conv fiber V_conv = {W : conv output loses effective kernel rank}.

- **Product stratum interaction**: Unlike sequential composition (where singularities compose through chain rule), the Conformer ADDITIVE residual structure means both V_attn and V_conv live in the SAME parameter space W and contribute to the SAME loss landscape simultaneously. The composite fiber V_conformer = {W : L(W) = 0} requires BOTH attention and convolution to achieve zero loss. This creates a PRODUCT STRATUM where:
  - V_attn ∩ V_conv defines the most singular locus (both paths degenerate)
  - V_attn \ V_conv and V_conv \ V_attn define intermediate strata
  - The RLCT of the composite λ_conformer satisfies λ_conformer ≥ max(λ_attn, λ_conv)

- **Macaron nesting**: The half-step FFN modules (×0.5 scaling) create a DEPTHWISE STRATUM NESTING. The 0.5 factor means FFN singularities are scaled but present. This creates a three-level stratum: outer (FFN+MHSA+Conv), middle (MHSA+Conv interaction), inner (attention or conv alone). The Macaron structure is a stratum SELECTOR via the half-step coefficient.

- **GLU gating boundary**: The GLU activation in the conv module (σ(W_g x) ⊙ (W_x x)) creates a SWITCHING SURFACE where W_g x = 0. This is a piecewise-semi-analytic boundary that adds a conditional singularity structure to the conv fiber, analogous to #396 (GLA gating boundary) but in the convolutional context.

## Claims

### C1: Definability [PROVEN]
The Conformer block is R_{an,exp}-definable. All components are built from: matrix multiplication (polynomial), softmax (analytic), LayerNorm/BatchNorm (rational, subanalytic), Swish/SiLU (analytic: x·σ(x)), GLU (sigmoid × linear, analytic), depthwise conv (polynomial), and residual addition (polynomial). Composition closure of R_{an,exp} guarantees definability.

### C2: Product Stratum Singular Fiber [CONJECTURAL]
The composite zero-loss fiber V_conformer = V_attn ∩ V_conv ∩ V_ffn1 ∩ V_ffn2 (intersection of all sub-module fibers, since additive residuals with non-negative loss contributions). The product stratum structure means:
- The MOST singular locus is where ALL sub-modules simultaneously degenerate: V_attn ∩ V_conv (both attention rank collapse AND convolution filter symmetry).
- LESS singular strata exist where only one path degenerates.
- The RLCT λ_conformer ≥ max(λ_attn, λ_conv, λ_ffn1, λ_ffn2) due to intersection codimension.
- This is DISTINCT from #823 (MLP-Mixer, where the product is between spatial and channel mixing without attention) and #653 (depthwise conv alone, no attention interaction).

### C3: Kernel Size as Stratum Selector [CONJECTURAL]
The convolution kernel size k acts as a DISCRETE stratum selector:
- k=1: depthwise conv reduces to channel-wise scaling (trivial conv fiber, same as #466 RMSNorm scale singularity).
- k>1: conv captures local patterns, creating non-trivial filter symmetry singularities.
- The transition from k=1 to k>1 is a DISCRETE phase transition in the conv fiber structure.
- Optimal k* balances local pattern richness (higher k → more filter symmetry strata) against RLCT increase (higher k → more singular strata → higher λ_conv → harder optimization).
- This extends #653's group-count selector to include kernel size as an additional stratum dimension.

### C4: Generalization Bound [CONJECTURAL]
Gen bound: G_conformer ~ λ_conformer/(2n) · log(n) + U_conformer/√n.
The Conformer advantage over pure Transformer (attention only) comes from the PRODUCT STRATUM providing richer singular structure that:
(a) Increases λ_conformer (more singular strata → higher RLCT) but
(b) Decreases U_conformer (product stratum constrains the effective hypothesis space, reducing empirical process fluctuation).
The net effect depends on the n regime: for small n, fluctuation reduction dominates (Conformer better); for large n, RLCT increase dominates (Transformer catches up). This predicts Conformer advantage diminishes with dataset size.

### C5: Attention-Convolution Stratum Coupling Phase Transition [CONJECTURAL]
During training, the model undergoes a phase transition at iteration t* where the optimizer shifts from attention-dominated to convolution-dominated (or vice versa). At t*:
- The local learning coefficient (LLC) shows a kink or plateau, detectable via SGLD.
- The Fisher information matrix rank shifts as the dominant singular stratum changes.
- The attention-convolution coupling factor ρ(t) = λ_attn(t)/(λ_attn(t) + λ_conv(t)) transitions sharply.
This is analogous to #850's alpha phase transition but between architectural components rather than loss terms.

## Key Novel Contributions
1. First SLT analysis of Conformer as product stratum (attention × convolution interaction)
2. Product stratum structure: intersection fiber V_attn ∩ V_conv, NOT sequential composition
3. Kernel size as discrete stratum selector extending #653
4. Conformer generalization advantage from fluctuation reduction, not RLCT reduction (parallels #850)
5. Attention-convolution coupling phase transition during training (SGLD-detectable)
6. Macaron half-step as depthwise stratum nesting selector

## Distinction from Prior Work
- #823 (MLP-Mixer × RLCT): Product orbifold between spatial/channel mixing — no attention, no convolution. Conformer has attention × convolution product, fundamentally different fiber interaction.
- #653 (Depthwise Conv × RLCT): Convolution singularity alone. No attention interaction. Conformer's product stratum is novel.
- #134 (Attention Singularity): Attention rank degeneracy via Plücker-toric resolution. No convolution. Conformer adds conv fiber interaction.
- #302 (Linear Attention × RLCT): Rank-deficient linear attention fiber. No convolution interaction.
- #466 (RMSNorm × RLCT): Scale singularity from normalization. Conformer's k=1 limit connects but full k>1 structure is distinct.
- #396 (GLA × RLCT): Gating boundary switching surface. Conformer's GLU gating is analogous but in convolutional context.
- #434 (MoE × RLCT): Routing gate singularity. Conformer's strata are architectural, not routing-based.

## Open Problems
1. Compute λ_conformer for specific Conformer block configurations (d_model, n_heads, kernel_size)
2. Is the product stratum V_attn ∩ V_conv always non-empty? (Existence of simultaneous degeneracy)
3. How does relative positional encoding interact with the attention fiber? (Extends #134)
4. Macaron half-step coefficient: optimal 0.5 or stratum-dependent?
5. Multi-block Conformer: does product stratum structure compose across depth?
6. GLU gating boundary interaction with conv filter symmetry — combined singularity type?
7. Empirical SGLD validation: measure LLC for Conformer vs Transformer vs Conv-only at matched parameter counts

## Cross-References
- #134 (Attention Singularity × RLCT): Plücker-toric attention fiber
- #302 (Linear Attention × RLCT): Rank-deficient attention fiber
- #396 (GLA × RLCT): Gating boundary switching surface
- #434 (MoE × RLCT): Routing gate singularity
- #466 (RMSNorm × RLCT): Scale singularity (k=1 conv connection)
- #653 (Depthwise Conv × RLCT): Convolution factorization singularity
- #823 (MLP-Mixer × RLCT): Product orbifold structure
- #850 (Knowledge Distillation × RLCT): Fluctuation reduction parallel
- #8 (SGD × RLCT): Optimizer dynamics
- #16 (Architecture × RLCT): Foundational model singularity

## Next Steps
L1: Formal definitions (D1-D7) for conformer block structure, product stratum fiber, RLCT decomposition, kernel size selector, gen bound, phase transition.query Oma synthesis L1 formalization format template structure recent examples s850 s848 s846 L1 D1-D7 definitions method