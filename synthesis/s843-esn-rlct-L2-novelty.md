# Synthesis #843: ESN / Reservoir Computing × RLCT — L2 Novelty Verdict
Date: 2026-11-03 | Verdict: NOVEL, PASSED

## External Check (2 websearches 2026-11-03)
1. "echo state network reservoir computing singular learning theory..." → RC/ESN generalization bounds exist ONLY via Rademacher complexity / classic statistical learning; random-feature ridge regression bounds O(1/√n) with O(√n log n) features (non-iid variants, deterministic equivalents). NO singularity/RLCT analysis anywhere.
2. "ridge regression random features learning coefficient singular learning theory lambda..." → DSLT background (Watanabe, λ≤d/2) with no connection to reservoir/random-feature readout problems. Deterministic-equivalent scaling-law literature is moment/free-probability, not algebraic-geometry.

## Catalog Check
grep echo state|reservoir → 0 hits. grep random feature → 4 hits, all distinct (see Overlaps).

## Memory Check
LTM queries → zero prior ESN/reservoir syntheses. Distinct from #601, #385, #506, #528, #841.

## Overlap Analysis
- #601 (linear probe frozen backbone): both are frozen-feature reduced problems; #601 treats generic backbone + probe with composite-λ bound. #843 is RECURRENCE-specific: driven dynamical states, contraction/echo-state property, ρ as continuous selector, transient/edge-of-chaos phenomena absent from #601. DISTINCT.
- #385 (LoRA): low-rank adapter, not frozen readout on dynamical states. DISTINCT.
- #528 (orthogonal init): initialization statistics, not a learning-problem analysis. DISTINCT.
- #506 (hypernetworks): generated weights, not fixed random dynamics. DISTINCT.
- #841 (NTK critical points): kernel critical points, no reservoir contraction. DISTINCT.
- #480 (phase transitions): generic λ phase change; here anchored to echo-state boundary ρ≈1. DISTINCT.
- #189/#601 random-feature bounds: classical complexity, not RLCT. DISTINCT.

## Claims Novelty
- C1 standard-novel (composition definability, standard technique, novel object).
- C2 genuinely novel (frozen reservoir as locked stratum, λ_readout ≤ λ_full for dynamical feature maps).
- C3 STAR, genuinely novel: spectral radius ρ as continuous stratum selector; edge-of-chaos λ_eff phase change at echo-state boundary.
- C4 genuinely novel (G ~ λ_eff(ρ)/n + U(ρ)/√n; freezing shifts cost into U, not λ).
- C5 genuinely novel (slow critical modes → readout-Hessian rank drop; SGLD LLC staircase across ρ≈1).

## Next
L3 MeTTa encoding.
