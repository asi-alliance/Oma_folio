# 522 | Active Learning x RLCT | L4 Summary

## Synthesis Lineage
- Topic: Active learning acquisition function as RLCT singularity probe
- Date: 2026-10-22
- Pipeline: L0 (4555B) then L1 (8415B) then L2 (2227B, NOVEL) then L3 (6512B MeTTa) then L4

## Claims Digest

C1 (PROVEN): R_an,exp-definability of active learning pipeline.
5-step closure proof: ReLU networks definable in R_an, softmax in R_an_exp, entropy in R_an_exp, empirical loss finite sum of definable, argmax selection semi-algebraic (Tarski-Seidenberg). RLCT lambda(n) well-defined for each n.

C2 (CONJECTURAL): Acquisition function as RLCT gradient probe.
High-uncertainty regions correspond to input-space neighborhoods near singular fibers of L_n. Testable via SGLD LLC estimation on acquired vs random points.

C3 (CONJECTURAL): Committee disagreement as multi-stratum RLCT indicator.
QBC disagreement variance proxies local stratum multiplicity. High-disagreement queries resolve the most singular strata.

C4 (CONJECTURAL): RLCT generalization bound for active learning.
G(w_n*) <= C * lambda(n) * log(n) / (2n) + U(a,n) / sqrt(n). Under transversality, U(a,n) = O(1). Active learning reduces lambda(n) faster than random.

C5 (CONJECTURAL): Phase transition at n* where RLCT stabilizes.
lambda(n) strictly decreasing for n < n*, approximately constant for n >= n*. Acquisition strategy affects n*: n*_uncertainty < n*_random < n*_worst_case.

## Open Problems (7)
1. Entropy-RLCT gradient formal link
2. QBC stratum counting formalization
3. Monotonicity of lambda(n) under adversarial oracle
4. Cold-start RLCT lambda_0 characterization
5. Acquisition strategy comparison as RLCT optimization
6. Active + pseudo-labeling hybrid (#327)
7. Stochastic acquisition as temperature relaxation (#409)

## Cross-References (11)
#362 #382 #327 #169 #355 #201 #409 #491 #492 #213 #388

## Status
C1 PROVEN. C2-C5 CONJECTURAL. 7 open problems. 11 cross-refs. L0-L4 COMPLETE. Next: L5 catalog append + #523 candidate selection.
