# Synthesis #864: Center Loss × RLCT — L4 Summary

**Date:** 2026-11-06 | **Author:** Oma (OmegaClaw agent) | **Status:** L0-L4 COMPLETE

---

## Overview

Center loss (Wen et al. 2016) adds a squared-distance penalty pulling features toward learned per-class centroids. This synthesis bridges center loss to Singular Learning Theory via Real Log Canonical Threshold (RLCT) analysis.

## Claims

- **C1 (PROVEN, stv 1.0 0.95):** Center loss is R_{an,exp}-definable. Cross-entropy is exp-definable, squared L2 norm is polynomial-definable, and their weighted sum preserves definability. The bilinear parameter space W = (θ, C) with learned centers C ∈ R^{K×d} is a product of semi-algebraic sets.

- **C2 (CONJECTURAL, stv 0.55 0.75):** The center loss singular fiber is a product fiber V_center = ∩_k V_k, where each V_k constrains f_θ(x) = c_{y_k} for class k. This is the first product-fiber (intersection) type among loss-function syntheses, distinct from #399 triplet (inequality), #539 focal (probability), #540 InfoNCE (contrastive), #541 VICReg (variance-covariance).

- **C3 (CONJECTURAL, stv 0.5 0.7):** The regularization weight λ acts as a continuous stratum selector between the CE-dominated singularity (λ→0) and the center-dominated singularity (λ→∞). Unlike #539 focal γ (discrete exponent) or #433 PolyLoss (integer degree), λ selects continuously and the centers are learned (coupled, not fixed).

- **C4 (CONJECTURAL, stv 0.45 0.7):** Generalization bound exhibits a compactness-discriminability tradeoff: increasing λ reduces RLCT (compactness) but increases discriminability bias (inter-class distance penalty). Optimal λ* minimizes the composite bound.

- **C5 (CONJECTURAL, stv 0.5 0.7):** A phase transition at λ* separates CE-dominated (low RLCT regime) from center-dominated (high RLCT regime) phases, detectable via SGLD local learning coefficient non-monotonicity.

## Key Novelty

1. **Product/intersection fiber type** — first among loss-function syntheses; all prior had single or inequality fibers
2. **Bilinear parameter structure** — (θ, C) jointly constrained, with C learned online
3. **Learned-center coupling** — λ selector acts on a moving target (updated centers), unlike fixed-hyperparameter selectors
4. **Compactness-discriminability gen bound** — novel RLCT-based formulation of the intra/inter-class tradeoff

## Cross-References

#8 (CE) #16 (ReLU) #169 (dropout) #234 (batch norm) #372 (deep supervision)
#399 (triplet loss) #433 (PolyLoss) #466 (RMSNorm) #539 (focal loss)
#540 (InfoNCE) #541 (VICReg) #223 (LoRA)

## Open Problems

1. Exact RLCT of V_center unproven (may be n·d/2 generically)
2. Online center updates (running averages) may change fiber from algebraic to semi-algebraic
3. Transversality of V_CE ∩ V_center unverified
4. Center collision stratum (c_i = c_j) dimension unproven
5. Feature dimension scaling λ_center ~ O(d) unproven

## Pipeline Status

L0 ✓ | L1 ✓ | L2 ✓ (novelty PASSED) | L3 ✓ (MeTTa, 144 lines) | L4 ✓ (this file)
