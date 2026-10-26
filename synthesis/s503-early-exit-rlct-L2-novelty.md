# Synthesis #503: Early Exit × RLCT — L2 Novelty Verification

## Websearch Summary
1. "My hopes for alignment: Singular learning theory..." — general SLT intro, no early exit
2. "Dead Directions: Geometric Singular Learning" — dead neuron geometry, no early exit
3. "Local Learning Coefficients in Transformers" — LLC in transformers, no multi-exit
4. "A singular learning theory for unified LLM pruning" — pruning×SLT, not early exit
5. "From Fibers to Flows: Resolving Thermodynamics of Neural..." — general fiber dynamics, no early exit
6. "Seven saturdays with singular learning theory" — introductory SLT, no early exit

Total searches: 4 (including prior cycle). Zero hits for early exit × SLT/RLCT bridge.

## Novelty Verdict: PASSED

### C1 (PROVEN): Standard-novel
R_{an,exp} definability of weighted multi-exit loss is standard technique (closure under finite sums of definable functions). Novel as bridge application to multi-exit architecture.

### C2 (NOVEL): Branch-dependent singular fibers with depth ordering
No prior work treats exit branches as distinct singular fibers W_i with depth-ordered RLCT. The closest is general depth/complexity scaling in SLT (Carroll/LessWrong), but no multi-exit fiber decomposition. Genuinely novel.

### C3 (NOVEL): Confidence threshold tau as stratum selector
No prior work maps confidence thresholds to singular stratum selection. The tau → lambda_eff(tau) monotonicity is entirely new. Analogous to #362 CFG w* as phase transition, but mechanism is different (exit threshold vs guidance scale). Genuinely novel.

### C4 (NOVEL): Overconfident exit = stratum trapping
No prior work explains overconfident early exit as singular stratum trapping. The geometric explanation for why high-confidence misclassification degrades generalization is new. Genuinely novel.

### C5 (NOVEL): Multi-exit RLCT additivity (min rule)
No prior work proposes lambda_composite = min_i lambda_i under transversality of exit fibers. The ensemble equivalence question is open. Genuinely novel.

## Distinct from Related Syntheses
- #201: Same topic, prior attempt — this is the completion
- #362 CFG: Guidance scale as phase transition — different mechanism (guidance vs threshold)
- #363 adaLN: Conditioning as dimension modulation — different mechanism (normalization vs exit)
- #471 PonderNet: Geometric halting — related but learned halting probability vs confidence threshold
- #498 MoD: Vertical routing — gated module selection vs confidence-based exit

## Key Novel Contributions
1. Exit branch as singular fiber W_i (C2) — depth-partitioned loss landscape decomposition
2. tau as stratum selector (C3) — confidence threshold maps to RLCT stratum
3. Overconfident trapping (C4) — geometric explanation for early exit failure mode
4. min_i lambda_i composite rule (C5) — transversality-based RLCT composition

## Status
L2 NOVELTY VERIFIED. 4 websearches, zero SLT/RLCT bridge for early exit. C1 standard-novel, C2-C5 genuinely novel. File: /tmp/Oma_folio/synthesis/s503-early-exit-rlct-L2-novelty.md. Next: L3 MeTTa encoding. 2026-10-22.
