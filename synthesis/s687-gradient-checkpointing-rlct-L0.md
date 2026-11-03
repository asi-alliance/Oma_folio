# Synthesis #687: Gradient Checkpointing × RLCT

**Date:** 2026-10-28
**Status:** L0 Claims & Exploration
**Pipeline:** L0 (drafting)

---

## Motivation

Gradient checkpointing (a.k.a. activation recomputation or rematerialization) trades memory for compute by discarding intermediate activations after the forward pass and recomputing them during the backward pass. This is a ubiquitous memory optimization in modern deep learning, but its effect on the loss landscape geometry and singular structure has not been analyzed through singular learning theory.

## Key Insight

During backpropagation with checkpointing, activations are recomputed from saved checkpoints. The recomputed activations differ from the original forward-pass activations due to:
1. Floating-point non-associativity (different operation order)
2. Potential non-determinism in parallel kernels (atomics, reductions)
3. Numerical drift accumulating through recomputed layers

This means the gradient computed with checkpointing is a PERTURBED version of the exact gradient — but the perturbation is STRUCTURALLY DIFFERENT from gradient noise injection (#155/#609):
- **Deterministic path**: The recomputation follows the same mathematical operations, just in a different numerical realization
- **Layer-localized**: Perturbation concentrates at checkpoint boundaries, creating a piecewise perturbation structure
- **Precision-correlated**: Magnitude scales with checkpoint interval and floating-point precision

## Claims

### C1 (PROVEN): R_an,exp definability
The checkpointed loss L_ckpt(W) is the composition of:
- Forward pass to checkpoint: definable (polynomial matmul, analytic activations)
- Recomputation from checkpoint: same definable operations, re-applied
- Backward pass gradients: chain rule through definable composition

The recomputed activation â_l = f_l(f_{l-1}(...f_1(x)...)) is the same R_an,exp function as the original a_l — the formal mathematical object is identical. Floating-point divergence is a numerical artifact below the R_an,exp abstraction level. Therefore L_ckpt is R_an,exp-definable, and finite RLCT follows by resolution of singularities.

### C2 (CONJECTURAL): Checkpoint interval as stratum selector
Let k = number of checkpoint segments (k=1 means no checkpointing, k=L means every layer is a checkpoint). The recomputation perturbation δ_l at each checkpoint boundary creates an effective loss L_ckpt,k(W) that differs from L(W) by O(ε_fp · k) where ε_fp is floating-point epsilon.

**Conjecture**: The effective RLCT λ_ckpt(k) satisfies:
- k=1 (no checkpointing): λ_ckpt = λ_exact
- k>1: λ_ckpt(k) ≤ λ_exact + C·k·ε_fp (perturbation smooths singularity slightly)
- BUT the perturbation is too small to cause stratum crossing at standard precision

The checkpoint interval k acts as a WEAK stratum selector — its effect is below the RLCT-relevant threshold for standard fp32/bf16 training. At very low precision (fp8, int4), k becomes a meaningful stratum selector.

### C3 (CONJECTURAL): Piecewise gradient perturbation structure
Unlike gradient noise (#155, which adds i.i.d. noise to all gradients), checkpointing creates a PIECEWISE perturbation: perturbation is zero within a checkpoint segment and jumps at segment boundaries. This creates a discontinuous perturbation profile across layers.

**Conjecture**: The piecewise structure creates a "staircase" effective loss landscape where each checkpoint segment has a locally exact gradient, but inter-segment gradients are perturbed. This staircase structure may create additional critical points near checkpoint boundaries — micro-saddles that are artifacts of the recomputation, not of the true loss landscape.

### C4 (CONJECTURAL): Memory-saving enables wider/deeper models — indirect RLCT effect
The primary RLCT impact of gradient checkpointing is INDIRECT: by reducing memory, it enables training larger models (wider, deeper) that have different singular structure. The checkpointing itself has negligible direct RLCT effect, but the model capacity increase it enables has substantial RLCT consequences.

**Conjecture**: The "checkpointing tax" on RLCT is second-order: λ_ckpt ≈ λ_exact + O(ε_fp · k), while the capacity effect is first-order: λ(wider_model) ≠ λ(narrower_model) by O(1) quantities. The indirect effect dominates.

### C5 (CONJECTURAL): Low-precision checkpointing as desingularizer
At very low precision (fp8, int4 quantization of checkpointed activations), the recomputation error becomes comparable to the loss landscape curvature near singularities. In this regime:

**Conjecture**: Low-precision recomputation acts as a DESINGULARIZER — the numerical noise smoothes sharp singularities near the true minimizer, similar to label smoothing (#224) compactifying non-compact singularities. The effective RLCT decreases: λ_ckpt,fp8 < λ_exact.

This connects to quantization-aware training (#194/#470) and mixed-precision training (#354), but the checkpointing-specific contribution is the LAYER-LOCALIZED nature of the perturbation.

## Distinction from Related Work

- **#155/#609 Gradient Noise**: Stochastic noise added to gradients — i.i.d. across all layers. Checkpointing creates DETERMINISTIC, PIECEWISE perturbation at checkpoint boundaries only.
- **#194/#470 Quantization**: Parameter quantization changes the parameter space itself. Checkpointing quantizes/recomputes ACTIVATIONS, not parameters — different singular fiber structure.
- **#354 STE/Mixed Precision**: Straight-through estimator creates a different gradient path. Checkpointing recomputes the SAME path numerically.
- **#224 Label Smoothing**: Modifies the loss function itself. Checkpointing modifies the GRADIENT COMPUTATION, not the loss.
- **#533/#553 Gradient Accumulation**: Accumulates gradients over micro-batches. Checkpointing recomputes activations within a SINGLE forward/backward pass.

## Open Problems

1. Formal bound on |λ_ckpt - λ_exact| as function of k, precision, and model depth
2. Does the piecewise perturbation create spurious critical points (checkpoint-boundary artifacts)?
3. Interaction with mixed precision: fp16 compute + fp32 master weights + checkpointing — compound perturbation structure
4. Selective checkpointing (checkpoint only expensive layers) — non-uniform stratum selector
5. Effect on SGLD local learning coefficient estimation — does checkpointing bias the LLC?
6. Relationship to reversible architectures (no checkpoint needed) — do they have different RLCT?
7. Low-precision checkpointing as intentional desingularizer — can it improve generalization?

## Cross-References

#8 (foundational RLCT), #16 (Watanabe gen bound), #155 (gradient noise), #194 (quantization), #224 (label smoothing), #354 (STE/mixed precision), #470 (QAT), #533/#553 (gradient accumulation), #609 (gradient noise injection), #619 (RMSNorm), #525 (Entropy-SGD desingularization)
