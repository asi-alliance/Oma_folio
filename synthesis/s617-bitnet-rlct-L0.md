# Synthesis #617: BitNet b1.58 × RLCT
## Date: 2026-10-25
## Candidate: BitNet b1.58 (scratch ternary weight training) × RLCT

### Background
BitNet b1.58 trains LLMs from scratch with ternary weights w ∈ {-1, 0, +1} using a quantization-aware forward pass. Unlike QAT (#470, STE backward) or PTQ (#244/#194/#576, post-hoc lattice), BitNet bakes ternary projection into the architecture itself — the model never sees continuous weights during training.

### Key Atoms
1. Ternary projection Q: R^d → {-1,0,+1}^d is a non-injective map with 3-level quantization (vs binary ±1 or continuous R)
2. Ternary fiber: W_0^Q = Q^{-1}(W_0) — preimage of true parameter under ternary grid. Fiber is union of 3^d cells (hypercube partition with deadzone at |w|<threshold → 0)
3. Deadzone singularity: the {0} level creates a codimension-d subvariety where weights are exactly zero — structurally distinct from binary ±1 (no zero) or continuous (no quantization)
4. From-scratch training dynamics: gradient descent navigates ternary cell boundaries during training, not just at inference — the loss landscape is piecewise-constant on ternary cells throughout training
5. Scale factor s: controls deadzone width; s as stratum selector selecting among binary-like (s→0) and ternary (s→∞) regimes

### Five Claims

**C1 (PROVEN):** R_{an,exp} definability of ternary quantized loss. The ternary projection Q(w) = sign(w) * 1[|w| > s] is subanalytic (composition of sign function and indicator of semi-algebraic set). Cross-entropy with ternary-prefixed forward pass is in R_{an,exp} by closure under composition with subanalytic maps.

**C2 (CONJECTURAL):** Ternary fiber collapse and non-identifiability. W_0^Q = Q^{-1}(f*) is a union of 3^d open cells (one per ternary assignment). The RLCT λ_Q of the quantized loss is determined by the geometry of cell boundary crossings, not the continuous RLCT λ. The deadzone (w=0 cells) introduces a new singular stratum absent in binary quantization — codimension contribution from zero-weight directions.

**C3 (CONJECTURAL):** Bit-width as stratum selector. For ternary (b=1.58 bits), the effective RLCT λ_eff(b) satisfies λ_binary ≤ λ_ternary ≤ λ_continuous. The ternary deadzone adds an intermediate stratum between binary (no zeros, coarser) and continuous (full resolution). The factor log(3)/log(2) ≈ 1.585 controls the information-theoretic resolution of the ternary grid.

**C4 (CONJECTURAL):** Generalization bound for ternary-trained models. G_BitNet ≤ λ_ternary * log(n) / (2n) + U(ternary) / sqrt(n), where U(ternary) captures the quantization bias from ternary projection. The from-scratch training means the model never optimizes in continuous space — the generalization bound reflects the discrete loss landscape directly, unlike QAT (#470) which has a forward/backward RLCT split.

**C5 (CONJECTURAL):** Phase transition at critical bit-width b*. There exists b* ∈ (1, 2) such that below b* the ternary deadzone dominates (zero-weights create pruned subnetworks dynamically), and above b* the quantization error dominates (continuous-like behavior). The transition b* ≈ 1.58 (log2(3)) is conjectured to be the natural information-theoretic threshold where ternary resolution matches the model's intrinsic complexity.

### Distinction from Prior Syntheses
- #470 (QAT × RLCT): QAT uses STE for backward pass → forward/backward RLCT split. BitNet trains on ternary loss directly, no STE split.
- #244/#194 (PTQ): Post-training quantization — model trained in continuous space then quantized. BitNet never trains in continuous space.
- #354 (STE alone): STE as a general technique. BitNet uses a specific ternary projection, not generic STE.
- #576 (GPTQ/AWQ): Hessian-based or activation-aware lattice methods for PTQ. BitNet is from-scratch, no Hessian information.
- #319 (Mixed Precision): FP16/BF16 floating-point quantization. BitNet is integer-level ternary, fundamentally different grid structure.

### Seven Open Problems
1. Does the ternary deadzone (w=0) create a qualitatively different singular stratum than binary ±1 quantization? (C2)
2. What is the exact RLCT of the piecewise-constant ternary loss? Is it well-defined under Watanabe's framework? (C2)
3. How does from-scratch ternary training dynamics differ from QAT in terms of RLCT navigation? (C2)
4. Is the phase transition b* ≈ log2(3) universal across architectures, or architecture-dependent? (C5)
5. Can the deadzone scale s be optimized as a stratum selector during training (analogous to #470)? (C3)
6. Does BitNet's ternary projection create a toric fan refinement (cf. toric quantization synthesis) with 3-ray cones? (C2)
7. How does the generalization bound change when ternary training is combined with attention head pruning or MoE routing? (C4)

### Cross-References
#470 (QAT), #244 (PTQ quantization), #194 (model quantization), #354 (STE), #576 (GPTQ/AWQ), #319 (mixed precision), #88/#98 (pruning), #100 (weight decay), #162 (LoRA rank), #199 (skip connections), #556 (VQ-VAE codebook), #89 (scaling laws), #8/#16 (baseline)
