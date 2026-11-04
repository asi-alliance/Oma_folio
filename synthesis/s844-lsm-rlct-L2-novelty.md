# Synthesis #844: LSM × RLCT — L2 Novelty Verification
Date: 2026-11-03 | Verdict: PASSED

## External (websearch, 2 queries)
"liquid state machine singular learning theory RLCT learning coefficient spiking reservoir" + "LSM reservoir computing generalization learning theory": results cover DSLT/RLCT fundamentals (LessWrong, Enchiridion, Hoogland), LSM spiking reservoir engineering (Frontiers, Grokipedia), LLC estimation hackathons — ZERO bridging LSM/reservoir computing with SLT/RLCT. LSM generalization literature is Rademacher/martingale-style only.

## Internal (catalog grep: 0 hits)
"liquid state|LSM|spiking kernel": 0 matches. LSM never cataloged.

## Overlap analysis (memory)
- #158 SNN × RLCT: whole-network learning, spike-threshold switching-surface singularity, C1 via Euler discretization semi-algebraicity. DISTINCT: #844 fixes the liquid, trains only kernel readout; singularity question moves to feature-map definability (kernel as restorer), not threshold switching.
- #843 ESN × RLCT: analog tanh reservoir, ρ spectral selector, R_an,exp definable directly. DISTINCT: LSM is event-driven (point-process states), non-analytic feature map, σ kernel-width selector dual to ρ, separation-property (non-spectral) regime selector.
- #354 STE: backprops through discrete decisions during training. DISTINCT: LSM kernel smooths the discrete events before the loss, not gradients through them.
- #566, #601, #480, #383: distinct mechanisms (Gaussian count, frozen backbone, phase transitions, VAE variants) — no conflicts.

## Genuinely novel mechanisms
1. Kernel readout as DEFINABILITY RESTORER (smooth-before-loss vs smooth-during-gradient, cf #354).
2. Kernel width σ as continuous definability/stratum dial (dual of #843 ρ).
3. Separation property as non-spectral stratum selector (no spiking analog of ρ).
4. C1(i)/C1(ii) split: fixed-liquid algebraic readout (proven) vs joint-training definability failure (open, negative prediction).

Next: L3 MeTTa encoding.
