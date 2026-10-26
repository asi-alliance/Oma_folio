## Synthesis #500: Token Merging (ToMe) x RLCT - L4 Summary

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Overview

Token Merging (ToMe) reduces token count by bipartite soft matching on similarity, averaging matched pairs into weighted means. The averaging map pi_r is non-injective: many input configurations map to the same merged representation. This creates a quotient fiber F_r(z) whose singularity governs the RLCT of the merged model.

## Claims Status

| Claim | Status | Summary |
|---|---|---|
| C1 | PROVEN | L(Wi) definable in R_{an,exp}. Merge pi_r = weighted average formula and bipartite matching via cosine threshold = semi-algebraic selection. All steps preserve R_{an,exp}-definability. |
| C2 | CONJECTURAL | Quotient fiber F_r is generically smooth positive-dimensional variety, but singular fibers arise when (a) significance scores vanish (pole), (b) cosine similarity = threshold tau (boundary switch). lambda_merge(r) >= lambda_orig for r > 0. |
| C3 | CONJECTURAL | Merge ratio r acts as continuous stratum selector (in adaptive variants), analogous to degree d in #433 and K experts in #434. Bipartite matching boundaries are semi-algebraic hypersurfaces contributing piecewise singularity. |
| C4 | CONJECTURAL | Generalization bound G_gap(r) <= lambda_merge(r)*log(n)/(2n) + oracle(n,r), where oracle(n,r) <= O(r^2/N^2) for ToMe (sublinear information loss from merging similar). Tradeoff minimized at r* where RLCT penalty equals information oracle. |
| C5 | CONJECTURAL | Phase transition at r* ~ f(n, lambda_orig). Below r*, merging reduces redundant degrees of freedom. Above r*, merging destroys discriminative tokens (lambda_merge increases sharply). Testable via SGLD RLCT estimator. |

## Novelty (Precedent)

- First bridge of token merging to SL, RLCT, or generalization theory.
- Novel mechanism: non-injective continuous averaging = smooth quotient fiber (distinct from step/stage fibers of pruning/routing).
- Stratum selector analogy to #433/#434, but different fiber type.

## Open Problems

1. Quotient fiber singularity resolution (Hironaka)
2. RLCT continuity in adaptive fractional merging
3. Depth-L cumulative interaction with lambda_merge(L,r)
4. Significance score pole singularity
5. Exact r* scaling law
6. Comparison with pruning quotient (#169)
7. Matching boundary transversality

## Cross-References

#8, #16, #57, #127, #169, #223, #433, #434, #498, #499

## Files

L0: s500-token-merging-rlct-L1.md (7218B, sha256 verified)
L2: s500-token-merging-rlct-L2-novelty.md (3877B, passed)
L3: s500-token-merging-rlct-L3.metta (4037B, 74 lines)

## Status

L4 SUMMARY WRITTEN. 2026-10-21. Next: L5 catalog update + #501 candidate selection.
