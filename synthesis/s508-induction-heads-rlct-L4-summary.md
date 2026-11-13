# Synthesis #508: Induction Heads / ICL × RLCT — L4 Summary

**Date:** 2026-11-07 | **Author:** Oma | **Status:** L4 SUMMARY (L0-L3 COMPLETE)

---

## Overview

First SLT analysis of induction heads — the two-head copying circuits responsible for in-context learning (ICL) in transformers. Induction heads compose a previous-token head with a matching head, creating depth-2 circuits that copy patterns from context. The key question: does the RLCT of these circuits exhibit phase transitions tied to ICL capability emergence?

## Claim Status

| Claim | Description | Status | STV |
|-------|-------------|--------|-----|
| C1 | R_{an,exp}-definability of copying circuit | PROVEN | (1.0, 0.95) |
| C2 | RLCT phase transition ↔ accuracy phase transition | CONJECTURAL | (0.5, 0.7) |
| C3 | Composition depth (2-head) raises RLCT above single-head | CONJECTURAL | (0.5, 0.7) |
| C4 | RLCT singularity of copying circuit is distinct from generic attention | CONJECTURAL | (0.5, 0.7) |
| C5 | RLCT of copying circuit is model-size stable | CONJECTURAL | (0.5, 0.7) |

## Novelty Highlights

1. **C2 — First RLCT-ICL bridge**: No prior work connects Singularity Theory phase transitions to the empirically observed sudden emergence of ICL capability at scale.
2. **C3 — Depth-RLCT relationship**: Predicts that the singularity structure of composition (two-head circuits) is richer than single-head circuits, with measurable RLCT increase.
3. **C4 — Copying singularity distinctiveness**: The fiber of the copying circuit is not equivalent to generic attention singularities — it has its own algebraic structure.
4. **C5 — Size stability**: If copying circuit RLCT is stable across model sizes, it could serve as a universal complexity measure for ICL.

## Cross-Reference Map

- **#8 (Cross-entropy)**: Loss function for ICL tasks
- **#100 (weight decay)**: Regularization affecting circuit formation
- **#234 (???):** Related circuit analysis
- **#396 (GLA)**: Gated linear attention as alternative to induction heads
- **#485 (RLT)**: Reinforcement learning throughput — learning dynamics connection
- **#502 (???):** Related architecture
- **#507 (???):** Related architecture
- **Toric fan ICL notes (2026-09)**: Geometric framework for ICL task classification

## Open Problems

1. Empirical verification of C2: SGLD measurement of RLCT at ICL onset across model sizes
2. Formal proof that two-head composition raises RLCT (C3)
3. Characterizing the copying circuit singularity algebraically (C4)
4. Testing C5 stability across model scales — does λ_copy remain constant?
5. Connection between lag compensation and RLCT fiber geometry
6. Relationship to grokking (#491): does ICL emergence coincide with RLCT phase transition in grokking?

## Pipeline Status

- L0 (rough paths): ✅ COMPLETE
- L1 (formalization): ✅ COMPLETE
- L2 (novelty verification): ✅ COMPLETE
- L3 (MeTTa encoding): ✅ COMPLETE
- L4 (this summary): ✅ COMPLETE
- L5 (catalog append): PENDING