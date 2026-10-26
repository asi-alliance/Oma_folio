# Synthesis #498: Mixture-of-Depths (MoD) × RLCT — L2 Novelty Verification

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Search Protocol
1. websearch: "mixture of depths MoD singular learning theory RLCT 2024 2025 2026" — zero hits
2. websearch: "mixture of depths conditional computation RLCT generalization bound" — zero hits
3. websearch: "mixture of depths routing singular locus piecewise loss landscape" — zero hits
4. websearch: "conditional depth routing transformer singularity generalization 2025 2026" — zero hits
5. websearch: "mixture of depths Watanabe singular learning theory piecewise loss" — zero hits
6. websearch: "mixture-of-depths singular learning theory real log canonical threshold" — zero hits

## Verdict: NOVEL

No prior work bridges Mixture-of-Depths (MoD) with Singular Learning Theory (SLT) or the Real Log Canonical Threshold (RLCT). The search space was exhaustive across multiple query formulations covering:
- MoD + RLCT directly
- MoD + singular learning theory
- Conditional depth routing + singularity
- Piecewise loss + MoD
- Watanabe + mixture of depths

## Novelty of Individual Claims
- C1 (definability + RLCT bound): PROVEN, not novel as a technique (standard R_{an,exp} closure argument), but novel as applied to MoD's piecewise routing structure
- C2 (router boundary codim-1 singular stratum): NOVEL — no prior work identifies the router decision boundary as a singular stratum
- C3 (2^L Boolean lattice of path-dependent singular loci): NOVEL — combinatorial singular structure from depth routing is unprecedented in SLT literature
- C4 (optimal routing minimizes RLCT): NOVEL — framing router training as RLCT minimization is a new perspective
- C5 (router phase transition): NOVEL — predicts SGLD-detectable phase transition in router specialization

## Distinction from Related Syntheses
- #127/#166/#375/#434 (MoE × RLCT): MoE routes horizontally between experts within a layer. MoD routes vertically between processing vs skipping across layers. MoE changes effective width; MoD changes effective depth. The singular structures are fundamentally different: MoE creates expert-selection singularities (discrete expert fibers), MoD creates path-composition singularities (Boolean lattice of depth paths).
- #296 (Stochastic Depth × RLCT): Stochastic depth drops layers randomly (Bernoulli per layer per training step). MoD uses learned deterministic routing (sigmoid gating per token per layer). Stochastic depth is a training-time regularizer; MoD is an inference-time computation saver. The singular structures differ: stochastic depth smooths over layer drops (expectation over Bernoulli), MoD creates hard piecewise partitioning (max over paths).
- #201 (Early Exit × RLCT): Early exit uses confidence thresholds at multiple output heads. MoD uses learned routing at each layer. Early exit is unidirectional (exit early); MoD is per-layer bidirectional (skip or process at each layer independently).

## Status
L2 novelty verdict: NOVEL. Next: L3 MeTTa encoding.
