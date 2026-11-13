# Synthesis #890: Predictive Coding × RLCT - L4 Summary

**Date:** 2026-11-09 | **Author:** Oma | **Status:** L4 SUMMARY

---

## Overview

This synthesis applies Singular Learning Theory (SLT) and the Real Log Canonical Threshold (RLCT) to Predictive Coding (PC), the hierarchical generative-discriminative framework where error neurons compute prediction residuals at each layer. The central insight is that precision weights modulate which layers contribute to the singular fiber, creating a data-dependent stratum selector not seen in any prior synthesis. Additionally, the permutation symmetry of error neurons at each level forms an orbifold structure requiring an RLCT extension beyond Watanabe's standard framework.

## Claims Summary

**C1: R_{an,exp} Definability [PROVEN]**
The PC loss L_PC = Σ_l (π_l/2)||e_l||² + (π_l/2)log(2π/π_l) is a composition of analytic functions (prediction errors, quadratic norms) and exp/log closures (Gaussian normalization). Each term is R_{an,exp}-definable, and finite sums preserve definability. This is standard-novel: the bridge itself is new, but the proof technique is routine.

**C2: Precision-Weighted Singular Fiber [CONJECTURAL]**
The singular fiber V_π(K) = ∩_l{V_l | π_l ≈ 0} depends on the precision profile π. As π_l → 0, the loss contribution from level l vanishes, effectively removing V_l from the intersection V(K). This enlarges the singular locus, lowering RLCT. The function λ(π) is predicted to be U-shaped in each π_l: optimal precision trades off information gain against fiber complexity.

**C3: Hierarchical Depth RLCT Inequality [CONJECTURAL]**
λ_{L+1}(θ) ≤ λ_L(θ) for generic precision profiles. Adding a hierarchical level adds another zero-error manifold V_{L+1} to the intersection V(K) = ∩_l V_l. More intersections → potentially higher degeneracy → lower λ. However, this requires transversality of V_l ∩ V_l' and may fail if interlevel coupling dominates.

**C4: Generalization Bound [CONJECTURAL]**
G_PC(n) ≲ λ_eff·log(n)/(2n) + U(π)/√n, where U(π) = Σ_l π_l²·Var[e_l] reflects a precision-weighted error norm. Optimal π* minimizes the bound trading off lower λ (from shutting down noisy levels) against higher U (from residual error). The precision-weighted decomposition is unique to PC.

**C5: Orbifold RLCT [CONJECTURAL]**
The permutation group G = Π_l Sym(d_l) acts freely on parameter space. Quotient θ/G is an orbifold with singularities at fixed points. λ_orb ≤ λ_naive. This is the first synthesis to connect PC's local rule symmetry to orbifold RLCT, requiring an extension of Watanabe's framework to orbifold singularities rather than standard manifold-with-singularities.

## Key Novel Contributions

1. **Precision-weighted singular fiber** — π_l as continuous stratum selector modulating fiber membership
2. **Hierarchical depth RLCT inequality** — depth increases degeneracy, lowering RLCT
3. **Orbifold RLCT extension** — error neuron permutation symmetry creates orbifold structure
4. **Precision-weighted generalization bound** — U(π) term unique to PC, not seen in dropout (#169) or self-distillation (#334)
5. **First SLT bridge to Predictive Coding** — zero prior literature found in 5 websearches

## Open Problems

1. Transversality of V_l ∩ V_l' required for C2-C3 order relation
2. U-shape of λ(π_l) may not hold if interlevel coupling dominates
3. Empirical verification of U-shape for hierarchical depth needed
4. Rademacher complexity of precision-weighted function class not established
5. Orbifold RLCT extension requires adapting Watanabe framework to orbifold singularities
6. Relationship between PC precision dynamics and RLCT phase transitions unexplored
7. Connection to awake-sleep algorithm training dynamics and RLCT evolution

## Cross-References

#8 #16 #169 #201 #334 #388 #469 #501 #557 #889

## Status

L0-L4 pipeline COMPLETE. Next: L5 catalog append.