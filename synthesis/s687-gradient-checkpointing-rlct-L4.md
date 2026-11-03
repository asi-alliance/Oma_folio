# Synthesis #687: Gradient Checkpointing × RLCT — L4 Summary

**Date:** 2026-10-28
**Status:** L4 Plain-Language Summary
**Pipeline:** L0 ✓ → L1 ✓ → L2 ✓ → L3 ✓ → L4 (this file) → L5 (catalog)

---

## Overview

Gradient checkpointing (activation recomputation) saves memory by discarding intermediate activations after the forward pass and recomputing them during backpropagation. This synthesis examines whether the recomputation process affects the singular structure of the loss landscape.

## Key Findings

**C1 (PROVEN):** The checkpointed loss is formally identical to the exact loss as an R_an,exp-definable function. Recomputation uses the same mathematical operations — floating-point divergence is a numerical artifact below the SLT abstraction level. Finite RLCT is guaranteed.

**C2 (CONJECTURAL):** The checkpoint count k acts as a weak stratum selector. At standard precision (fp32), the perturbation from recomputation (O(ε_fp · k)) is far below the scale of singular structure — effectively invisible. At low precision (fp8), k becomes a meaningful selector.

**C3 (CONJECTURAL):** Unlike gradient noise injection which perturbs all layers uniformly with stochastic noise, checkpointing creates deterministic, piecewise perturbation — zero within segments, jumping at checkpoint boundaries. This staircase structure may create micro-saddles at boundaries.

**C4 (CONJECTURAL):** The direct RLCT effect of checkpointing is second-order (negligible perturbation). The indirect effect — enabling training of larger models or larger batch sizes — is first-order and dominates. Checkpointing's RLCT impact is primarily through capacity, not perturbation.

**C5 (CONJECTURAL):** At very low precision (fp8), intentional checkpointing could act as a desingularizer. Predicted phase transition: k* ~ 1/ε_fp. At fp32, k* ~ 10^7 (unobservable); at fp8, k* ~ 100 (potentially testable).

## Core Novelty

The framing that checkpointing's singular structure impact is precision-dependent and primarily indirect is new. The piecewise perturbation characterization (vs. i.i.d. gradient noise) and the k* ~ 1/ε_fp scaling prediction are original contributions.

## Open Problems

1. Tight bound on |λ_ckpt - λ_exact| as function of (k, ε_fp, L, d)
2. Do checkpoint-boundary micro-saddles exist and affect training dynamics?
3. Non-deterministic kernels (atomics): stochastic RLCT from recomputation variance?
4. Selective checkpointing: non-uniform stratum selector
5. SGLD LLC estimation bias under checkpointing
6. Reversible architectures: same RLCT as checkpointed equivalents?
7. Low-precision checkpointing as intentional desingularizer — empirically testable?

## Cross-References

#8 (foundational RLCT), #16 (Watanabe gen bound), #155 (gradient noise), #194 (quantization), #224 (label smoothing), #354 (STE/mixed precision), #470 (QAT), #525 (Entropy-SGD), #533/#553 (gradient accumulation), #609 (gradient noise injection), #619 (RMSNorm)
