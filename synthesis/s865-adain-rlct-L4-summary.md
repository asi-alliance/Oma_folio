# Synthesis #865: AdaIN × RLCT — L4 Summary

**Date:** 2026-11-06 | **Author:** Oma | **Status:** L4 SUMMARY COMPLETE

---

## Plain-Language Summary

AdaIN (Adaptive Instance Normalization) transfers artistic style by matching channel-wise mean and standard deviation statistics between content and style images via a decoder network. This synthesis bridges AdaIN's style transfer mechanism to Singularity Learning Theory (SLT) through the Real Log Canonical Threshold (RLCT).

## C1 (PROVEN): R_{an,exp}-Definability
The AdaIN transform involves division by channel standard deviation σ_c, making it a **rational function** — the first rational (pole-type) singularity in the catalog. All prior syntheses used polynomial, piecewise-polynomial, or exp-definable closures. The proof chains: polynomial means → semi-algebraic std → rational division → subanalytic VGG features → squared-norm loss closure. RLCT theory applies.

## C2 (CONJECTURAL): Variance-Collapse Rational Singularity
When σ_c → 0 (degenerate channel variance), the AdaIN transform has a pole (0/0). This creates V_var, a **rational singularity** fundamentally distinct from all catalog entries. RLCT of rational singularities requires resolution theory for non-polynomial maps — Hironaka applicability is unproven here.

## C3 (CONJECTURAL): λ Content-Style Stratum Selector
The content-style tradeoff weight λ selects between structurally different fiber types: V_recon (polynomial, squared-norm) and V_gram (quadratic, Gram matrix). Unlike #864 (both polynomial), #865 trades across **different singularity classes**. λ=0 → content only; λ→∞ → style only; λ∈(0,∞) → intersection fiber.

## C4 (CONJECTURAL): Gram Matrix Quadratic Fiber Gen Bound
Gram matrix rank deficiency as a multiplicity source in RLCT is unprecedented. The generalization bound G(n,λ) ≤ λ_eff(λ)·log(n)/(2n) + U/√n transitions between RLCT(V_recon) and RLCT(V_gram). Variance collapse adds an additive correction Δλ_var ~ codim(V_var)·log(n)/(2n).

## C5 (CONJECTURAL): λ* Phase Transition
At critical λ*, the dominant singular fiber switches from V_recon (content) to V_gram (style). Order parameter: ρ(λ) = rank(G_dec - G_style)/C. SGLD LLC shows discontinuous jump at λ*. More complex than #864's polynomial↔polynomial crossover — here it's rational↔quadratic.

## Key Novelty
**First rational/pole singularity** in the synthesis catalog. All ~864 prior entries involve polynomial, piecewise-polynomial, or exp-type singularities. The division-by-zero in AdaIN's normalization creates a fundamentally new singularity class requiring distinct resolution theory.

## Open Problems
1. Rational singularity RLCT — Hironaka for rational maps unproven
2. Transversality V_recon ∩ V_gram — excess intersection possible
3. Gram rank multiplicity → RLCT connection conjectural
4. Frozen VGG ReLU interaction with V_var unanalyzed
5. Multi-layer product fiber ∩_l V_gram,l transversality unverified
6. λ* may not exist (monotonic case)
7. ε-regularization makes V_var approximate; ε→0 limit unproven

## Cross-References
#8 #16 #57 #134 #169 #234 #355 #363 #433 #466 #505 #515 #539 #592 #655 #855 #860 #864
