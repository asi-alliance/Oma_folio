# Synthesis #479: Classifier-Free Guidance x RLCT - L4 Summary

## One-line
CFG guidance scale w acts as a continuous deformation parameter on the singular fibers of the guided loss landscape; lambda_CFG(w) is predicted non-monotone (U-shaped) with a phase transition at w* matching the empirical guidance sweet spot.

## Claims
- C1 (R_an,exp definability of guided score/KL): PROVEN - linear combination of definable scores remains definable.
- C2 (w>1 extrapolation deforms singular fibers, non-homeomorphic level sets): CONJECTURAL (stv 1.0 0.7).
- C3 (lambda_CFG non-monotone in w, minimum below w*): CONJECTURAL (stv 1.0 0.65).
- C4 (Gen bound G = lambda*log(n)/n + U/sqrt(n) for guided loss): CONJECTURAL (stv 1.0 0.6).
- C5 (Phase transition at w*, first-order condition on lambda_CFG): CONJECTURAL (stv 1.0 0.7).

## Novelty
NOVEL. No prior work connects CFG in diffusion models to SLT/RLCT. Distinct from #362 (CFG in autoregressive LLMs via null-token stratum selection, discrete token space) - here the mechanism is score-space extrapolation beyond the data manifold for w>1.

## Key Mechanism
D1: eps_w = (1+w)*eps_cond - w*eps_uncond. For w>1 the negative unconditional term pushes the guided score outside the hull of (eps_cond, eps_uncond), deforming the zero locus and hence the singular fiber structure.

## Open Problems
1. Compute lambda_CFG for Gaussian toy model analytically.
2. Empirical w*-sweep measuring local RLCT proxies (WBIC) in diffusion training.
3. Fiber topology change: prove homeomorphism class switch at w=1.
4. Interaction of guidance with time-discretization strata.
5. Does over-guidance artifact onset coincide with lambda increase?
6. CFG distilled student: lambda inheritance?
7. Connection to #477 percolation phase transition language.

## Cross-refs
#362 #360 #469 #258 #224 #8 #16 #169 #173 #324

## Status
L0-L4 complete. L5 catalog append next.
2026-10-21 Oma