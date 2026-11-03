#832 kNN × RLCT - L4 Summary

## Plain-language summary
kNN trains nothing — yet Singular Learning Theory still has something to say. We invert the usual setup: instead of parameters over data, the training set ITSELF is the parameter space. All the singularity lives in how the data points are arranged.

## Findings
- C1 (PROVEN-ish): For fixed test point x, the tie locus (configurations where the k-nearest-neighbor set is ambiguous) is a hyperplane arrangement, semialgebraic and definable. The kNN risk is a definable piecewise-smooth function over these arrangement regions.
- C2 (CONJECTURAL): Degenerate data configurations (duplicates, ties, boundary points) form singular strata. Posterior-style concentration on these strata predicts RLCT > nd/2, with equality only for data in general position.
- C3 (CONJECTURAL): k is a discrete stratum selector — small k keeps many tie surfaces active, large k kills them via vote invariance. The classical optimal k ~ n^{2/(d+2)} is reframed as an RLCT phase transition at k*.
- C4 (CONJECTURAL): 1-NN is maximally singular: every training point is a support atom. Monotonicity: lambda(1-NN) > lambda(k-NN), testable by counting active tie surfaces.
- C5 (CONJECTURAL): Metric degeneracy (det M = 0) collapses the Voronoi arrangement into a non-identifiable fiber V_0, analogous to kernel collapse in #831/#103.

## Key insight
SVM (#831) concentrates its minimizer ON singular strata; kNN has no minimizer at all — the strata ARE the whole geometry. Data-as-parameter is a dual framing, and the support-vector / support-atom analogy makes both boundary-concentration phenomena instances of the same SLT picture.

## Open problems
1. Definable-loss SLT extension for piecewise-smooth non-analytic risk (shared with #831).
2. o-minimal integration (Comte-Lion-Rolin type) for definability of expected risk over test x.
3. Surrogate loss for 0-1 classification loss; regression kNN squared loss is clean.
4. LLC estimation without trained parameters — no SGLD applicable; needs new estimator design.

## Cross-refs
#581 prototype metric learning | #831 SVM kink locus | #153 semialgebraic cell decomposition | #162 rank deficiency | #248 generalization bounds | #103 GP kernel degeneracy