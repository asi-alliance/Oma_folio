# Synthesis #498: Mixture-of-Depths (MoD) × RLCT — L0 Outline

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Topic
Mixture-of-Depths (MoD) — conditional computation at the layer level. A router/gating function decides for each token whether to process through a transformer block or skip it via a residual connection. This creates a dynamic-depth architecture where the effective computational graph varies per token.

## Motivation
MoD introduces a per-token, per-layer binary routing decision. From an SLT perspective, this creates a piecewise-defined loss landscape: the loss function is different on different regions of input/token space, depending on the routing path. Each routing configuration defines a different composed function and hence a different singular locus. The union of all possible routing paths creates a combinatorial singular structure.

## Novelty Assessment
- Zero prior SLT/RLCT work on mixture-of-depths (searches confirmed)
- Distinct from #127 (MoE × RLCT): MoE routes between experts within a layer (horizontal routing). MoD routes between processing vs skipping at each layer (vertical routing / depth routing). MoE changes width, MoD changes depth.
- Distinct from #296 (Stochastic Depth × RLCT): Stochastic depth drops layers randomly during training. MoD makes deterministic routing decisions via learned gating. Stochastic depth is a training regularizer; MoD is an architectural computation saver.
- Distinct from #220 (Pruning × RLCT): Pruning removes parameters permanently. MoD skips computation conditionally per-token.

## L0 Outline
1. Define MoD routing function and piecewise loss landscape
2. Formalize routing-path-dependent singular loci V_0^{(path)}
3. Prove C1: RLCT of piecewise loss is bounded by max over routing paths
4. Develop C2: Router gating singularity (sigmoid saturation creates boundary strata)
5. Develop C3: Combinatorial singular structure — 2^L routing paths for L layers
6. Develop C4: Optimal routing via RLCT — tokens assigned to paths minimizing local RLCT
7. Develop C5: Training dynamics — router learns to separate easy (shallow) vs hard (deep) tokens
8. Cross-references and open problems

## Cross-References
#8 (grokking), #65 (singular stratum), #94 (phase transition), #115 (emergent ability), #127 (MoE routing), #169 (dropout), #220 (pruning), #296 (stochastic depth), #302 (linear attention), #312 (multi-token prediction), #496 (CoT)

## Status
L0 written 2026-10-21. Next: L1 formalization.
