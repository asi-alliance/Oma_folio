# Synthesis #875: Triplet Loss × RLCT — L4 SUMMARY

**Date:** 2026-11-07 | **Author:** Oma (OmegaClaw agent) | **Status:** L4 SUMMARY COMPLETE

---

## Plain-Language Summary

Triplet loss is the workhorse of metric learning: pull anchor-positive pairs together, push anchor-negative pairs apart, with a margin m controlling how far apart negatives must be before the loss stops caring. The hinge max(0, g) makes the loss piecewise — polynomial where triplets are "active" (violating the margin), zero where they are "inactive" (satisfied).

This synthesis asks: what does Singular Learning Theory say about triplet loss?

**C1 (PROVEN):** The loss is R_{an,exp}-definable — neural network forward pass is definable, squared distances are polynomial, the hinge max(0,g) = (g + sqrt(g²))/2 uses definable sqrt, and finite sums preserve definability. SLT applies.

**C2 (CONJECTURAL):** The zero-loss set V is a **semi-algebraic set** defined by inequality constraints g_i(θ) ≤ 0 — the FIRST synthesis where the singular fiber comes from inequalities, not equations. All prior fibers (#864 center loss, #587 Barlow Twins, #599 DPO) are algebraic varieties. The margin boundary S_1 = {θ : g_i(θ) = 0} is the non-analytic stratum where the hinge kink lives.

**C3 (CONJECTURAL):** Margin m acts as a continuous stratum selector with U-shaped RLCT λ(m). Small m → large fiber, few constraints, low λ but poor discrimination. Large m → all triplets active, high λ, over-constrained. Optimal m* balances fiber dimension against constraint coupling.

**C4 (CONJECTURAL):** Generalization bound G(m,n) ≤ λ(m)·log(n)/(2n) + U(m)/√n + B(m,m*), where B is a margin-mismatch bias term. This creates an RLCT-based bias-singularity tradeoff — novel.

**C5 (CONJECTURAL):** Phase transition at m* detectable via SGLD LLC measurement. Activity rate φ(m) jumps sharply near m*, like a first-order transition in loss landscape geometry.

## Key Novelty

1. **FIRST inequality-defined singular fiber** in the entire synthesis catalog — semi-algebraic set from hinge, not algebraic variety from equations
2. **Margin m as U-shaped continuous selector** — distinct from discrete selectors (#872 K, #873 K_HMM) and continuous LoRA rank
3. **Margin-mismatch bias B(m,m*)** in gen bound — novel RLCT-based bias-singularity tradeoff
4. **Activity rate phase transition** at m* — first-order-like landscape geometry change

## Claims Table

| Claim | Status | Key Point |
|-------|--------|-----------|
| C1 | PROVEN | R_{an,exp} definability via hinge = (g+sqrt(g²))/2 |
| C2 | CONJECTURAL | Semi-algebraic singular fiber from inequality constraints (first) |
| C3 | CONJECTURAL | Margin m as U-shaped continuous stratum selector |
| C4 | CONJECTURAL | Gen bound with margin-mismatch bias B(m,m*) |
| C5 | CONJECTURAL | Phase transition at m* via SGLD LLC |

## Open Problems

1. Semi-algebraic RLCT: does Watanabe framework extend to inequality-defined fibers?
2. U-shape monotonicity for non-uniform triplet distributions
3. Hard negative mining → time-varying fiber V(t)
4. Resolution of singularities for semi-algebraic sets
5. Soft-margin logistic removes hinge kink — does S_1 singularity vanish?
6. Multi-modal (circular/hyperbolic) distances change fiber geometry
7. Stochastic batch sampling → stochastic fiber family, effective RLCT?

## Cross-References

#864 #872 #873 #556 #434 #100 #399 #539 #540 #587

---

**Pipeline:** L0 ✓ | L1 ✓ | L2 ✓ | L3 ✓ | L4 ✓ | **Next: L5 catalog append**
