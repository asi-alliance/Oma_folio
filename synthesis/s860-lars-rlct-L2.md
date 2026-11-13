# Synthesis #860: LARS × RLCT — L2 Novelty Verification

## Catalog Search
- grep -ic lars /tmp/Oma_folio/synthesis/synthesis-catalog.md → 0 hits (confirmed across multiple cycles)
- No prior synthesis covers LARS or layer-wise adaptive rate scaling × RLCT

## Literature Search
- "LARS optimizer singular learning theory RLCT" → 0 results (2024-2026)
- "layer-wise adaptive rate scaling trust ratio singularity geometry" → 0 results
- "LARS layer-wise trust ratio quotient singularity product fiber generalization" → 0 results
- "layer-wise learning rate scaling per-layer norm ratio singularity algebraic geometry" → 0 results
- Zero SLT literature connecting LARS trust ratio to RLCT or singular fibers

## Distinctness Analysis

### vs #606 RMSProp × RLCT
RMSProp uses diagonal EMA of squared gradients (r_t = ρr_{t-1} + (1-ρ)g_t²) creating a single global diagonal stratum. LARS uses per-layer norm RATIO φ_l=||w_l||/||g_l|| creating a PRODUCT of per-layer quotient fibers. RMSProp rescales coordinates individually; LARS rescales entire layers as units with quotient geometry. Distinct: product fiber vs diagonal fiber, norm ratio vs EMA.

### vs #289 Adam × RLCT
Adam applies global bias correction (m_t/(1-β₁), v_t/(1-β₂)) with element-wise EMA. LARS applies per-layer TRUST RATIO using norms (not per-element). Adam's fiber is element-wise; LARS's fiber is layer-wise product. Distinct: quotient structure (norm ratio vs EMA ratio), granularity (layer vs element).

### vs #818 GradNorm × RLCT
GradNorm rescales gradient magnitudes to balance task losses via a single global rescaling factor. LARS uses independent per-layer trust ratios φ_l. GradNorm modifies gradient magnitude; LARS modifies learning rate via norm quotient. Distinct: single rescaling vs per-layer quotient, gradient modification vs learning rate modification.

### vs #476 Nesterov × RLCT
Nesterov shifts gradient evaluation point (lookahead) creating a displaced singular fiber. LARS uses norm-based per-layer rescaling. Nesterov's singularity is a displacement; LARS's singularity is a per-layer quotient product. Distinct: shifted fiber vs product quotient fiber.

### vs #505 WeightNorm × RLCT
WeightNorm decomposes weights into scale + direction (w = g·v/||v||) creating scale-direction fiber. LARS uses trust ratio φ_l=||w||/||g|| as dynamic rescaling, not parameter reparameterization. WeightNorm changes parameter space; LARS changes update geometry. Distinct: reparameterization vs update rescaling, scale-direction vs norm-quotient.

## Novelty Summary
1. PRODUCT-SPACE QUOTIENT FIBER: No prior synthesis or literature uses per-layer product fibers with additive RLCT (λ_LARS=Σλ_l). Each layer independently singular.
2. TRUST RATIO AS STRATUM SELECTOR: φ_l creates a continuous 2^L stratum lattice. No prior work formalizes norm ratios as stratum selectors.
3. COMPOSITE GEN BOUND: Gen ≤ (1/n)Σλ_l(φ_l) + O(L/√n) with per-layer RLCT contributions. Novel depth-dependent tradeoff.
4. SEQUENTIAL LAYER ACTIVATION: D7 predicts depth-dependent cascade phase transitions, SGLD-testable. No prior prediction.

## Verdict
NOVELTY CONFIRMED. LARS × RLCT is genuinely distinct from all 860 prior syntheses and all available literature. The product-space quotient fiber and additive RLCT structure represent a new class of singular geometry in the catalog.

## Cross-References
#173 (SGD), #289 (Adam), #476 (Nesterov), #606 (RMSProp), #505 (WeightNorm), #818 (GradNorm), #433 (Weight Decay), #415 (Muon), #807 (Path Norm), #466 (RMSNorm), #221 (BatchNorm), #421 (Layer Scale), #484 (ReZero)