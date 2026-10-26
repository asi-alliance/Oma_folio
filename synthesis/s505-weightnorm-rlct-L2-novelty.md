# Synthesis #505: Weight Normalization × RLCT — L2 Novelty Verification
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-22

## Websearch Summary

1. query: weight normalization singular learning theory RLCT Watanabe neural network reparameterization singularity 2024 2025
   Result: ZERO hits connecting WeightNorm to SLT/RLCT. Standard WeightNorm papers (Salimans & Kingma 2016) only.

2. query: "weight normalization" "real log canonical threshold" OR "RLCT" OR "singular learning" neural network 2024 2025
   Result: ZERO hits. No prior work bridging WeightNorm to singular learning theory.

3. query: weight normalization reparameterization singularity Fisher information degenerate neural network theory
   Result: Standard WeightNorm reparameterization papers, Fisher information in optimization context. NO SLT/RLCT bridge found.

## Novelty Assessment

C1 (PROVEN): Standard-novel. R_an definability of g*v/||v|| is straightforward (algebraic + rational). No prior work proves this in SLT context.

C2 (CONJECTURAL): Genuinely novel. Compact direction fiber S^{d-1} as singular fiber is distinct from all prior syntheses:
- #466 RMSNorm: R^d/R_+ (non-compact quotient, activation-level)
- #221 BatchNorm: R^d/R_+ x R (non-compact, batch statistics)
- #222 Spectral norm: boundary singularities at sigma_max=1 (operator-level)
- WeightNorm: S^{d-1} (COMPACT, weight-level) — first compact fiber in catalog

C3 (CONJECTURAL): Genuinely novel. Epsilon as stratum selector in WeightNorm context. Analogy to #466 RMSNorm but applied to weight space, not activation space.

C4 (CONJECTURAL): Genuinely novel. Generalization bound with compact fiber constraint. Compactness of S^{d-1} provides boundedness absent in non-compact fibers.

C5 (CONJECTURAL): Genuinely novel. Phase transition at eps* for weight-level normalization. Distinct from activation-level (#466) and batch-level (#221) phase transitions.

## Verdict

L2 NOVELTY: PASSED. 3 websearches, zero WeightNorm x SLT/RLCT bridge. C1 standard-novel, C2-C5 genuinely novel.

Key novel contributions:
1. First COMPACT singular fiber (S^{d-1}) in synthesis catalog
2. Scale-direction decomposition singularity at ||v||=0 (pole-type, codim d)
3. Weight-level vs activation-level (#466) vs batch-level (#221) normalization RLCT contrast
4. Compact fiber boundedness as generalization advantage
5. Epsilon as weight-space stratum selector

## Distinctness from Related Syntheses

- #466 RMSNorm: normalizes activations, quotient R^d/R_+ (non-compact). WeightNorm normalizes weights, fiber S^{d-1} (compact).
- #221 BatchNorm: batch statistics, non-compact fiber. WeightNorm: parameter-level, compact fiber.
- #222 Spectral norm: operator norm constraint, boundary singularity. WeightNorm: vector norm, interior singularity at origin.
- #424 Fixup: scale-based, no direction fiber. WeightNorm: explicit direction fiber.

File: /tmp/Oma_folio/synthesis/s505-weightnorm-rlct-L2-novelty.md
Next: L3 MeTTa encoding.
