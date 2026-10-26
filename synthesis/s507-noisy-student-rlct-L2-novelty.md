# Synthesis #507: Noisy Student × RLCT — L2 Novelty Verdict (2026-05-22 corrected 2026-10-22)

## Verdict: NOVEL — PASSED

## Searches (3 websearches, zero prior SLT/RLCT x noisy-student bridge)
1. "singular learning theory RLCT noisy student self-training Xie 2020" — no hits.
2. "RLCT local learning coefficient semi-supervised self-training pseudo-label singularity" — no hits.
3. "singular learning theory noise injection data augmentation desingularization strata" — no hits.
Closest: Xie et al. 2020 itself (empirical, no SLT); KD theory reviews (no SLT).

## Claim-by-claim
- C1 definability (noise-convolution empirical loss R_{an,exp}-definable): standard-novel — same proof pattern as #261/#327/#334.
- C2 noise as desingularizer (heat semigroup, sigma* = sqrt(2*eta*DeltaE)): GENUINELY NOVEL — asymmetric student-only noise smoothing has no SLT antecedent; #261 uses temperature (deterministic), #296 uses noise as architecture.
- C3 confidence filter as stratum selector: novel refinement of #327 C3 — teacher-confidence subset restriction under noise.
- C4 capacity asymmetry (equal-or-larger student, lower lambda): GENUINELY NOVEL.
- C5 iterative RLCT decay with r* phase transition: GENUINELY NOVEL — distinct from #334 (self-distillation: same model, no noise) and #327 (no iteration/noise).

## Distinctness from catalog neighbors
#327 (pseudo-labeling, no noise), #334 (self-distillation, same model), #261 (KD, temperature not noise, no iteration), #296 (stochastic depth, noise as mechanism not curriculum).

## Status
L2 PASSED. Next: L3 MeTTa encoding.
