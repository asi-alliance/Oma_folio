# Synthesis #860: LARS × RLCT — L4 Executive Summary

**Date:** 2026-11-06 | **Pipeline:** L0-L1-L2-L3-L4 COMPLETE | **Status:** C1 PROVEN, C2-C5 CONJECTURAL

## Overview
This synthesis bridges Layer-wise Adaptive Rate Scaling (LARS) with Watanabe's Singular Learning Theory (SLT). LARS normalizes each layer's update by the trust ratio φ_l = ||w_l|| / (||g_l|| + ε_w·||w_l||), clipped by trust coefficient τ. We show this creates a **product-space quotient singular fiber** where each layer independently contributes to the total RLCT.

  
## Claims Recap

**C1 (PROVEN):** The LARS update map U_l: (w_l, g_l) → w_{t+1,l} is R_{an,exp}-definable. The trust ratio φ_l is a rational function of L2 norms (subanalytic), division is analytic where denominator ≠ 0, and min(τ,·) is piecewise-analytic. Composition preserves definability. □

**C2 (CONJECTURAL):** Per-layer quotient singular fiber V_l^{LARS} = {w_l : φ_l·g_l = 0}. Two singularity sources: gradient vanishing (||g_l||→0) and weight vanishing (||w_l||→0). Product fiber V_LARS = ∏_l V_l^{LARS} with additive RLCT: λ_LARS = Σ_l λ_l.

**C3 (CONJECTURAL):** Trust ratio φ_l acts as a continuous per-layer stratum selector. φ_l→0: frozen layer (small weight stratum). φ_l→τ: saturated trust (large weight stratum). The stratum lattice ∏_l{stratum(φ_l)} gives 2^L possible configurations — each layer independently selects its local geometry.

**C4 (CONJECTURAL):** Composite generalization bound: Gen_LARS ≤ (1/n)Σ_l λ_l(φ_l) + O(L/√n). Per-layer RLCT contributions create a depth-dependent tradeoff: more active layers → more capacity but higher RLCT sum. Frozen layers contribute λ_l≈0.

**C5 (CONJECTURAL):** Sequential layer activation phase transition. Each layer has critical φ_l*; when φ_l crosses φ_l*, the layer activates (λ_l jumps from ~0 to >0). This produces a depth-dependent cascade, SGLD-testable via per-layer LLC monitoring.

## Key Novelty
The **product-space quotient fiber** is genuinely new in the catalog. Unlike:
- #606 RMSProp (single diagonal EMA stratum)
- #289 Adam (global element-wise bias correction)
- #818 GradNorm (single global gradient rescaling)
- #476 Nesterov (shifted fiber via lookahead)
- #505 WeightNorm (scale-direction reparameterization)

LARS creates **independent per-layer quotient geometries** whose product yields additive RLCT. The 2^L stratum lattice and sequential activation cascade have no precedent in SLT literature (zero search results, zero catalog hits).

## Open Problems
1. Exact codim(V_l^{LARS}) as function of d_l and gradient rank.
2. Independence assumption for product RLCT additivity — chain rule coupling between layers.
3. φ_l* critical value: data-dependent or universal scaling with d_l?
4. Momentum extension (LARS+momentum) adds velocity stratum not modeled.
5. min(τ,φ_l) piecewise boundary singularity at φ_l=τ.
6. Interaction with weight decay ε_w creating degenerate denominator.
7. SGLD sampling protocol for per-layer λ_l estimation.
8. LAMB comparison: LAMB normalizes by both ||w|| and ||g|| — different quotient structure?
9. Does sequential activation cascade appear empirically in large-batch LARS training?

## Cross-References
#173 (SGD), #289 (Adam), #476 (Nesterov), #606 (RMSProp), #505 (WeightNorm), #818 (GradNorm), #433 (Weight Decay), #415 (Muon), #807 (Path Norm), #466 (RMSNorm), #221 (BatchNorm), #421 (Layer Scale), #484 (ReZero)