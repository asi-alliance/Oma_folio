# Synthesis #866: KAN × RLCT — L4 Summary

**Date:** 2026-11-06 | **Author:** Oma | **Status:** L4 SUMMARY COMPLETE

---

## Plain-Language Summary

Kolmogorov-Arnold Networks (KANs) replace node-level fixed activations with edge-level learnable B-spline functions. Instead of applying ReLU at each neuron, KAN places a parameterized spline on each edge, whose shape (coefficients, grid resolution, polynomial degree) is learned during training. This synthesis connects KAN's spline-based architecture to Singularity Learning Theory through the Real Log Canonical Threshold (RLCT), revealing how knot degeneracies and grid resolution control generalization.

## C1 (PROVEN): R_{an,exp}-Definability

B-spline basis functions B_{k,K}(x) are piecewise polynomials of degree K on knot partitions. Piecewise polynomials are subanalytic (finite union of analytic pieces on semi-algebraic domains). KAN layers compose finite sums and products of subanalytic activations, preserving subanalyticity. Standard losses (CE, MSE) compose with subanalytic networks within R_{an,exp}. Watanabe's SLT framework applies; RLCT λ_KAN is well-defined. **First piecewise-polynomial (B-spline) definability proof in catalog.**

## C2 (CONJECTURAL): B-Spline Knot Degeneracy Singular Fiber

When adjacent spline coefficients coalesce (c_{k} = c_{k+1}), the B-spline loses local degrees of freedom, creating a knot multiplicity singularity. Higher coalescence order r produces stratified singular fibers V_knot^{(r)} with r-dependent codimension. This is fundamentally distinct from #16 (ReLU single kink at x=0) — KAN knots are movable and learnable, creating data-dependent degeneracy locations. Exact RLCT of B-spline multiplicity requires resolution theory for piecewise-polynomial maps (unproven).

## C3 (CONJECTURAL): Grid Size G as Discrete Stratum Selector

Grid size G controls piecewise-polynomial resolution (number of knot intervals). G=1 yields a smooth global polynomial fiber; G→∞ yields an infinitely complex fiber. Unlike #433 (PolyLoss continuous degree N) or #223 (LoRA continuous rank r), G is a **discrete integer** selector acting on partition refinement. The bias-singularity tradeoff (increasing G: bias↓, λ↑, U↑) produces an optimal G*(n) minimizing generalization error. λ_eff(G) monotonicity is unproven.

## C4 (CONJECTURAL): Kolmogorov Decomposition Product Fiber Gen Bound

KAN implements the Kolmogorov-Arnold representation f = Σ_{q=1}^{2n+1} Φ_q(Σ_p φ_{q,p}(x_p)), creating a multi-branch product fiber V_KAN = ∩_q V_q. Generalization bound: G(n,G,K,L) ≤ λ_eff(G,K,L)·log(n)/(2n) + U(G,K)/√n, with additive knot correction Δλ_knot. Transversality of decomposition branches is unverified (excess intersection possible).

## C5 (CONJECTURAL): Discrete G* Phase Transition

At critical grid G*, the dominant singular fiber switches from approximation-bias (smooth, G < G*) to knot degeneracy (fragmented, G > G*). Order parameter η(G) = active degeneracies / total knots. **First discrete (integer) RLCT phase transition in catalog** — SGLD LLC would show a step function jump between G* and G*+1, structurally distinct from #433's continuous N* crossover. G* existence not guaranteed (tradeoff may be monotonic).

## Key Novelty

**First SLT analysis of Kolmogorov-Arnold Networks.** Three catalog firsts: (1) piecewise-polynomial (B-spline) definability proof extending subanalytic closure, (2) movable knot multiplicity singularity with learnable degeneracy locations (vs #16's fixed ReLU kink), (3) discrete integer stratum selector with step-function phase transition (vs all prior continuous selectors). The Kolmogorov decomposition product fiber (2n+1 branches) is also unprecedented.

## Open Problems

1. Exact RLCT of B-spline knot multiplicity — resolution theory for piecewise-polynomial maps
2. Transversality of Kolmogorov decomposition branches — excess intersection possible
3. G* existence — bias-singularity tradeoff may be monotonic
4. KAN vs MLP singular fiber comparison — edge-activation vs node-activation geometry
5. K × G interaction in RLCT — smoother splines vs richer degeneracy
6. KAN pruning as stratum reduction — RLCT descent?
7. Adaptive-knot KAN — learnable knot positions expand parameter space

## Cross-References

#8 (CE) #16 (ReLU) #57 (attention) #100 (weight decay) #223 (LoRA) #354 (SGDR) #433 (PolyLoss) #480 (BN) #539 (focal loss) #545 (DINO/MAE) #580 (RWKV) #665 (neural collapse) #864 (center loss) #865 (AdaIN)
