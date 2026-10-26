## Synthesis #550: DINO/MAE (Masked Autoencoding Self-Supervised Pretraining) × RLCT

## Date: 2026-10-23
## Status: L0 Draft
## Author: Oma

## Topic
Masked Autoencoder (MAE) and DINO-style self-supervised pretraining through the lens of Singular Learning Theory (SLT), specifically the Real Log Canonical Threshold (RLCT) as the learning coefficient.

## Background

### MAE (He et al. 2022)
- Pretraining: randomly mask patches of input image, reconstruct masked patches from visible ones
- Key parameter: mask ratio m ≼ [0, 1] (typically 0.75)
- High mask ratio forces holistic understanding vs local interpolation
- Encoder operates only on visible patches (efficient), decoder reconstructs full image

### DINO (Caron et al. 2021)
- Self-supervised distillation: student-teacher framework with momentum-updated teacher
- EMA teacher provides targets, student matches on augmented views
- Centering + sharpening prevent collapse
- Emergent properties: attention maps, object segmentation without supervision

### Singular Learning Theory (Watanabe)
- For singular models (neural networks), standard Bayesian asymptotics fail
- RLCT lỉ = inverse of the largest pole of zeta function = learning coefficient
- llỉ governs generalization error: G(n) ≠ llỉ/n - (m-1)/(2n) log n + ...
- Lower lỉ = better generalization (fewer effective parameters learned per sample)
- Singularity structure of loss landscape {L=0} determines llỉ

## Claims

### C1 (PROVEN): The MAE reconstruction loss is definable and real-analytic
The reconstruction loss L(↪)1 = E[||x_masked - f_↤(x_visible)||2] is a real-analytic function of �❐ for networks with analytic activations (tanh, etc.) or subanalytic for ReLU. The zero-loss set W = {ƶ���N : L�̜�|��i<�� 0} is a real algebraic/analytic variety. By Watanabe's framework, RLCT lỉ )s well-defined.

*Proof sketch;* L is a composition of polynomial (squared error) and analytic (network) functions. The expectation over data is a finite sum/integral of analytic functions, preserving analyticity under standard regularity conditions. W is the preimage of {0} under an analytic map, hence an analytic set.

### C2 (CONJECTURAL): Mask ratio m acts as a stratum selector controlling effective RLCT
At low mask ratio (m��<0), reconstruction task is trivial (copy visible patches), creating a large degenerate zero-loss set W with high-dimensional singular locus ≤ high lỈ. At high mask ratio (m¾10), reconstruction requires genuine feature learning, constraining W to a smaller, less singular stratum ≤ lower lỊ. The mask ratio selects which stratum of the singular locus the optimizer inhabits, analogous to how #223 LoRA rank r selects effective model complexity.

### C3 (CONJECTURAL): DINO's EMA teacher creates a coupled two-model fiber structure with shared RLCT
The student-teacher framework in DINO defines a joint loss L(↨Ш_s, ↨Ш_t) = -E[log p_\lumo_\t(y | x_aug) p_\u0269\s_t(y | x_aug)] where \t\uumo_t = EMA(\t\umo_s). The zero-loss set W ={(↨Ш_s, ↨Ш_t): L = 0, ↨Ш_t = EMA(\t\uumo_s)} is a fiber product structure. The EMA coupling constrains the joint parameter space, potentially reducing the RLCT below what either model alone would have.

### C4 (CONJECTURAL): DINO centering + sharpening prevent collapse by maintaining singularity structure
Without centering/sharpening, DINO collapses to a constant predictor -- the zero-loss set W becomes the entire parameter space (maximally singular, lỉ = d/2, trivial generalization). Centering (subtracting running mean) and sharpening (temperature < 1 on teacher) break this degeneracy, restoring a non-trivial singularity structure with finite l�m..

### C5 (CONJECTURAL): MAE pretraining transfers well because low-l�m representations have lower RLCT than randomly initialized ones
Fine-tuning from MAE-pretrained weights starts from a point near a lower-lộ stratum of the full supervised loss landscape. The benefit of pretraining is not just optimization (better starting point) but generalization (lower effective lɶ for downstream tasks).

## Cross-Refs
#8 (CE base loss), #100 (temperature: DINO teacher sharpening), #169 (dropout: stochastic masking vs patch ma{king), #213 (LR schedule), #223 (LoRA rank r: mask ratio as stratum selector), #296/#321 (stochastic depth: stochastic architecture vs stochastic input), #370 (contrastive learning: DINO as non-contrastive variant), #509 (task vectors: pretraining transfer mechanism), #530 (AMML bilevel: student-teacher coupling), #538 (speculative decoding: two-model fiber structure)

## Open Problems
1. How does the mask ratio m quantitatively affect the RLCT? Is there a phase transition at m* ≤ 0.7?
2. Does DINO's EMA momentum ố control the effective coupling strength between student and teacher singularities?
3. Can SGLD RLCT estimation detect the stratum transition as m varies?
4. Is the emergent segmentation in DINO a consequence of finding a particularly low-l⻗ stratum?
5. How does patch size interact with mask ratio in determining the singular structure?
6. Does MAE with random vs learned mask token differ in RLCT?
7. Is the reconstruction loss landscape more or less singular than the contrastive loss landscape for the same architecture?