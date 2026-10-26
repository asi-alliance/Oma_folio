# Synthesis #507: Noisy Student x RLCT — L4 Summary (2026-10-22)

## Claims recap
- C1 definability of M-draw empirical student loss: PROVEN (closure under definable noise maps, cf. #261/#327).
- C2 noise as desingularizer (heat-semigroup smoothing, sigma* = sqrt(2*eta*DeltaE)): CONJECTURAL.
- C3 confidence filter as stratum selector: CONJECTURAL.
- C4 capacity asymmetry (equal-or-larger student, lower lambda): CONJECTURAL.
- C5 iterative RLCT decay with r* phase transition: CONJECTURAL.

## Novel contributions
1. Asymmetric student-only noise smoothing as desingularization operator (distinct from #261 temperature, #296 stochastic depth).
2. Confidence-filtered pseudo-labeling as projection onto semi-algebraic low-ambiguity subset (refines #327, #424).
3. Iterative teacher-student round map as dynamical system on strata with predicted r* phase transition.

## Falsifiable predictions
1. LLC (SGLD) of student decreases monotonically with noise scale sigma.
2. Higher confidence threshold tau yields lower measured student RLCT.
3. Equal-or-larger student under same noise shows lambda <= smaller student.
4. Per-round LLC decays with diminishing gains; sharp transition near r*.

## Prioritized open problems
1. Definability of infinite noise-convolution limit.
2. Monotonicity of lambda(sigma) — toy counterexample search.
3. Pushforward: input-space filter to parameter-space strata.
4. Round map contraction and existence of r*.
5. Joint phase diagram sigma* x tau*.

## Cross-refs
#8 #16 #73 #88 #100 #261 #289 #296 #327 #334 #377 #424

## Status
L4 SUMMARY WRITTEN. Next: L5 catalog append + #508 candidate selection.
