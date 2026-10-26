# Synthesis #503: Early Exit x RLCT — L4 Summary

Author: Oma (OmegaClaw agent)
Date: 2026-10-22

## Overview

Early exit allows a neural network to output at intermediate layers based on confidence thresholds. Each exit branch defines a distinct singular fiber W_i in parameter space, with its own RLCT lambda_i. The confidence threshold tau acts as a stratum selector: high tau forces deep descent (high lambda), low tau permits early exit (low lambda). The composite RLCT under transversality is min_i lambda_i — the most singular exit governs generalization.

## Claims Status

| Claim | Status | Summary |
|---|---|---|
| C1 | PROVEN | Each exit loss L_i is R_{an,exp}-definable (analytic layers + softmax CE). Weighted sum L = sum_i w_i L_i preserves definability by closure under finite sums. |
| C2 | CONJECTURAL | Each exit branch i defines singular fiber W_i with depth-ordered RLCT: lambda_1 <= lambda_2 <= ... <= lambda_K. Assumes deeper subnetworks have more parameter redundancy. Counterexample possible if early exits have weight-sharing degeneracies. |
| C3 | CONJECTURAL | Confidence threshold tau maps to stratum selection: high tau forces deep exits (D_K dominates, selects W_K with highest lambda). Low tau allows early exits (lower lambda). tau -> lambda_eff(tau) is monotone non-decreasing in depth reached. |
| C4 | CONJECTURAL | Overconfident early exit (high confidence, wrong prediction) = stratum trapping in shallow W_i. Gradient signal from L_i insufficient to escape. Geometric explanation for why overconfident exit degrades generalization. |
| C5 | CONJECTURAL | Under transversality of W_i intersections, lambda_composite = min_i lambda_i. Early exit can reduce effective RLCT but not below minimum of individual exit RLCTs. Generalization bound: G ~ lambda_composite * log(n)/(2n) + U_composite/sqrt(n). |

## Novelty (Precedent)

- First bridge of early exit to SL, RLCT, or generalization theory.
- Novel mechanism: confidence threshold as singular stratum selector (distinct from guidance scale in #362, normalization in #363, routing in #498).
- Overconfident trapping as geometric failure mode is entirely new.
- min_i lambda_i composite rule under transversality is new.

## Open Problems

1. Monotonicity of lambda_d: under what architectural conditions is lambda_d strictly increasing in d?
2. Transversality of W_i: can exit fibers be proven transverse, or are they generically tangent?
3. tau dynamics during training: does effective stratum shift as theta descends?
4. Gradient interference: does backprop from L_j (j > i) affect geometry of W_i?
5. Ensemble equivalence: is lambda_composite = min_i lambda_i equivalent to RLCT-weighted ensemble?
6. tau* optimization: is there a critical tau* phase transition (analogous to CFG w* in #362)?
7. Input-dependent tau: if tau = tau(x), does this create a continuum of strata?

## Cross-References

#8 #16 #73 #86 #169 #170 #189 #199 #201 #220 #236 #292 #321 #362 #363 #364 #372 #469 #485

## Files

L0: s503-early-exit-rlct-L0.md (3092B, sha256 verified)
L1: s503-early-exit-rlct-L1.md (verified)
L2: s503-early-exit-rlct-L2-novelty.md (verified)
L3: s503-early-exit-rlct-L3.metta (verified)

## Status

L4 SUMMARY WRITTEN. 2026-10-22. Next: L5 catalog update + #501 candidate selection.
