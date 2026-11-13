# Synthesis #846: Boosting (AdaBoost) × RLCT — L4 Summary
Date: 2026-11-06 | Status: L0-L4 COMPLETE

## Plain-Language Summary

AdaBoost builds an ensemble by sequentially adding weak learners, each focused on the samples the previous learners got wrong. This synthesis asks: what does singular learning theory (SLT) say about that sequential process?

**C1 (PROVEN):** The AdaBoost exponential loss L = (1/n)Σ exp(-y_i f_M(x_i)) is R_{an,exp}-definable when weak learners are analytic in their parameters. This places AdaBoost squarely in the SLT framework.

**C2 (CONJECTURAL):** Each round m adds a weak learner h_{θ_m}, embedding the previous singular fiber V_{M-1} into V_M. Crucially, the reweighting w_m(i) = exp(-y_i f_{m-1}(x_i))/Z_m depends on the *solutions* of all previous rounds — the fiber is path-dependent, not independent. This is distinct from bagging (#652, parallel fibers), adversarial training (#590, min-max), and class reweighting (#608, static).

**C3 (STAR):** The number of rounds M acts as a discrete stratum selector. Each added learner introduces new singular strata. We conjecture a critical M* where the effective per-parameter RLCT λ_eff(M) = λ(M)/(M(d+1)) stops decreasing — margin improvement saturates and singularity complexity dominates.

**C4 (CONJECTURAL):** Generalization bound G(M) ≤ λ(M)/(2n) + U(M)/√n + margin_term(M). The margin-RLCT bridge: larger margins create fatter singular strata → lower RLCT. This unifies AdaBoost margin theory with SLT complexity bounds.

**C5 (CONJECTURAL):** At M*, SGLD local learning coefficient (LLC) should stabilize or increase — adding learners beyond M* increases singularity complexity faster than it sharpens margins.

## Key Novelty
The margin-RLCT bridge (C4) and the cumulative path-dependent singular fiber (C2) are genuinely novel. No prior work connects AdaBoost's sequential reweighting to RLCT strata. The discrete stratum selector M (C3) is distinct from continuous selectors like spectral radius (#843) or dropout rate (#169).

## Open Problems (7)
1. Exact form of margin-RLCT function g(ρ_M): polynomial, logarithmic, or power-law?
2. Additive (λ(M) = λ(M-1) + δ_m) vs multiplicative structure of cumulative RLCT?
3. Weak learner capacity (stump vs depth-3 tree) effect on per-round δ_m?
4. SGLD LLC estimation on discrete M (not continuous) — protocol design?
5. Does AdaBoost weight α_m = 0.5 log((1-err_m)/err_m) naturally regularize λ(M)?
6. Gradient boosting vs discrete weak learner selection — does RLCT structure change?
7. Unifying parallel (#652) and sequential ensembling in a single RLCT framework?

## Cross-refs (8)
#652 (bagging/parallel), #590 (adversarial/min-max), #608 (class balancing/static), #539 (focal loss/down-weighting), #173 (SAM/flat minima), #169 (dropout/stochastic), #433 (weight decay), #843 (preceding/continuous rho)

## Next
L5 catalog append.
