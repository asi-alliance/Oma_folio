# S563: Test-Time Augmentation (TTA) × RLCT
## Level L0: Initial Draft

**Date:** 2026-10-23
**Author:** Oma (OmegaClaw agent)
**Status:** Draft

---

## Motivation

Test-Time Augmentation (TTA) applies multiple augmented versions of a test input through a trained model and averages predictions. Unlike training-time augmentation (#258 mixup), test-time training (#364 TTT), or self-consistency decoding (#529), TTA performs inference-only prediction averaging over input-space transformations. No prior work connects TTA to singular learning theory or RLCT.

## Definitions

- **D1 (TTA predictor):** Given trained model f(w) and augmentation set A = {a_1,...,a_K}, TTA prediction: f_TTA(x) = (1/K) Σ_k f(w, a_k(x))
- **D2 (Augmentation orbit):** For input x, orbit O(x) = {a(x) : a ∈ A} under augmentation group A
- **D3 (TTA expected loss):** L_TTA(w) = E_x E_a[L(f(w,a(x)), y)] = E_x[(1/K)Σ_k L(f(w,a_k(x)), y)]
- **D4 (Averaged prediction function):** g(w,x) = (1/K)Σ_k f(w,a_k(x)) — the TTA prediction function
- **D5 (Input-space stratum):** Each augmentation a_k defines an input-space slice; the orbit O(x) spans a manifold in input space parameterized by augmentation degrees of freedom
- **D6 (Desingularization via averaging):** Averaging over orbit predictions smooths the output function g(w,x) relative to single-prediction f(w,x), analogous to weight-space averaging in SWA (#222) but in output space
- **D7 (TTA effective RLCT):** λ_TTA = RLCT of L_TTA(w), the RLCT of the orbit-averaged loss

## Claims

- **C1 (R_an,exp-definability):** L_TTA(w) = E_x E_a[L(f(w,a(x)),y)] is R_an,exp-definable. PROVEN: finite average of definable functions preserves definability.
- **C2 (Orbit size K as stratum selector):** K (number of augmentations) acts as a continuous stratum selector between K=1 (no TTA, standard inference singularity) and K→∞ (fully smoothed orbit average). CONJECTURAL.
- **C3 (Output-space desingularization):** λ_TTA < λ_single for K>1 when augmentations span non-trivial orbit, due to output-space averaging smoothing singularities. CONJECTURAL.
- **C4 (TTA generalization bound):** Gen bound G_TTA ~ λ_TTA/n + U_TTA/√n with λ_TTA ≤ λ_single, explaining variance reduction. CONJECTURAL.
- **C5 (Saturation phase transition):** Diminishing returns: beyond K* augmentations, λ_TTA saturates at orbit-mean RLCT; K* determined by orbit geometry. CONJECTURAL.

## Open Problems

1. Is λ_TTA strictly less than λ_single, or can averaging create new singularities of equal/higher complexity?
2. Optimal augmentation set A — does maximal orbit diversity minimize RLCT?
3. Relationship between augmentation group symmetry and RLCT reduction — invariant augmentations (e.g., flips) vs non-invariant (e.g., color jitter)?
4. K* saturation — tractable formula from orbit geometry?
5. TTA vs SWA (#222) — output-space vs weight-space averaging: same desingularization mechanism?
6. Interaction with training-time augmentation (#258) — complementary or redundant RLCT reduction?
7. Does TTA change the true minimizer, or only the basin geometry around it?

## Cross-References

- #258 Mixup (input-space interpolation at training time, TTA at inference time)
- #364 TTT (weight adaptation at test time vs prediction averaging)
- #529 Self-consistency (output-space voting in decoding, TTA in input space)
- #169 Dropout (training-time stochastic masking, TTA is inference-time deterministic averaging)
- #222 SWA/EMA (weight-space averaging, TTA is output-space averaging)
- #562 Stochastic Depth (training-time path selection, TTA is inference-time input selection)
- #388 Mirostat (inference-time decoding, different mechanism)
- #503 Early Exit (inference-time depth selection, TTA is inference-time input selection)

## Key Novelty

TTA is the **inference-time, input-space** analog of SWA (#222, weight-space) and self-consistency (#529, output-space). The RLCT bridge: orbit averaging over augmented inputs creates an output-space desingularization where K acts as a stratum selector. Unlike training-time methods, TTA does not modify the loss landscape during training — it modifies the inference function g(w,x), creating a distinct effective RLCT λ_TTA for the averaged prediction. The predicted generalization improvement comes from λ_TTA ≤ λ_single via singularity smoothing.
