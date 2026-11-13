## Synthesis #893: Random Forest x RPLCT - L4 Executive Summary

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L4 COMPLETE | **Layers:** L0-L3-L1-L2-L3-L4 done, L5 pending
**Builds on:** #893 L0-L3 | **Distinct from:** #877 (single DT), #652 (bagging), #892 (GBM), #846 (AdaBoost)

---

## Claim Summary

| Claim | Title | Status | Key Insight |
|--------|--------------------------|-----------------------|-------------------------|
| C1 | R {an,ep}-definability of RF loss | PROVEN | Piecewise constant trees + analytic loss for cross-entropy |
| C2 | Decorrelation-induced desingularization | CONJECTURAL | Correlation-weighted fiber intersection bound |
| C3 | mtry as stratum selector | CONJECTURAL | m controls coordinate projection dimension |
| C4 | Generalization bound with projection complexity | CONJECTURAL | SHT bound + combinatorial C(d,m)^D term |
| C5 | Phase transition at critical mtry m* | CONJECTURAL | First SLT explanation for Breiman m* aprox d/3 heuristic |

## Star Contribution

**C3 + C5 combined:** mtry as a coordinate-projection-based stratum selector with a phase transition at m* approx d/3. First formal SLT explanation for Breimans empirical mtry heuristic. Mechanism: coordinate projection via feature subsampling creates per-tree fibers in different m-dimensional subspaces; at m*, decorrelation saturates so ensemble singular set shrinks.

## Open Problems
1. Formalize correlation-fiber overlap bound
1. Prove monotonicity of lambda_RF in m
2. Extend to Extra Trees (random thresholds)
3. Bootstrap overlap interaction
Bn Gutting watches your main moves
. Data sparsity interaction

## Cross-References

- #877 (Decision Tree): Base learner, depth D Selector
- #652 (Bagging): Parallel independent fiber intersection in full D subspace
- #892 (GBM): Sequential path-dependent fiber, shrinkage S!1 selector
- #846 (AdaBoost): Sequential reweighting, discrete M selector
- #371, #383, #354, #491, #504:* L4 executive summary complete. 2026-11-12. Next: L5 catalog append + #894 candidate.*