# Synthesis #847 OP1 QBAF Benchmark Results
Date: 2026-11-04. Script: qbaf_bench.py (200 random QBAFs, n in [2,7], seed 42, grid G={0,.25,.5,.75,1}, weighted-sum Agg, Jacobi FP tol 1e-9).

## Output
trials=200 noconv=42 edge_violations=81 h0_mismatch=0
h0 sizes: min=0 max=5 mean=0.5

## Interpretation (per pinned rules)
- edge_violations=81 > 0: gradual fixed points do NOT satisfy D3/D4 monotone/anti-monotone edge constraints in general.
- h0_mismatch=0: whenever a fixed point does satisfy the edge constraints, it lies in the brute H^0 (grid+gluing) — rounding never caused a mismatch.
- h0 mean size 0.5, min 0: the fully-constrained section set is often EMPTY — D3/D4 are too strong to define the section space.

## Verdict
C1 REVISION REQUIRED: the sheaf H^0 must be GLUING-ONLY (D5 aggregation condition), not D3/D4-constrained. Polarity enters the sheaf through the aggregation terms (attacker contributions subtracted, supporters added) rather than as independent edge constraints. The "polarity = restriction direction" star insight of L1/L2 does not survive the benchmark as stated; polarity survives as the SIGN of edge contributions in the gluing map. L3 caveat 3 was prescient; edgeRestr clauses are to be reinterpreted or demoted to a derived/optional constraint layer.
