#833 PCA × RLCT - L4 Summary

## Plain-language recap
PCA (principal component analysis) as a probabilistic model is singular: eigenvectors are non-identifiable whenever eigenvalues repeat, and the signal/noise split fails at the boundary l_min = sigma^2. Singular Learning Theory tools (RLCT, resolution of singularities) apply because everything is semialgebraic (C1, proven).

## Claims
- C1 PROVEN: rank-r Gaussian PCA likelihood definable in R_{an,exp}; sample eigensolver semialgebraic via characteristic-polynomial resultants.
- C2 CONJECTURAL: eigenvalue multiplicity-m strata; rotation fiber removed by resolution (per #69 lesson, fiber does NOT inflate RLCT); predicted RLCT ~ codim/2.
- C3 CONJECTURAL: rank r as discrete stratum selector; scree-plot elbow reframed as RLCT phase transition at r*.
- C4 CONJECTURAL: eigengap delta^-1 sensitivity appears as singular scaling exponent in local KL expansion near the multiplicity stratum.
- C5 CONJECTURAL: boundary fiber at l_min = sigma^2 (non-identifiable signal/noise split), bilinear-type singularity shared with reduced-rank regression.

## Key novelty
First SLT treatment of PCA: eigenvalue-multiplicity strata + scree-elbow-as-phase-transition. L2 novelty passed (5 websearches, zero prior PCA×RLCT work).

## Open problems
5 listed in L1: exact RLCT of multiplicity-m stratum (Newton polyhedron); toricity of boundary fiber for r=1 vs r>=3; r* selection criterion from free energy; quantitative delta^-1-to-exponent bridge; SGLD/LLC estimator design (data-as-parameter dual, same burden as #832).

## Cross-refs
#832 kNN data-as-parameter | #831 SVM strata | #69 singular fiber lesson | #298 Vainsencher resolution | #162 rank deficiency | #268 mixture eigenvector geometry | #103 GP kernel degeneracy

## Status
L0-L4 complete. Next: L5 catalog append.