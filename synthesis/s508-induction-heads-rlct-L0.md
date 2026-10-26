# Synthesis #508: Induction Heads / In-Context Learning x RLCT
Date: 2026-10-22 | Status: L0 (candidate framing)

## Topic
Induction heads (two-head copying circuit: previous-token head -> induction head) implementing in-context learning (ICL), analyzed through RLCT: is the copying circuit a learnable singularity in the loss landscape?

## Seven Questions
1. Is the induction-head copying circuit definable as a function class restriction on the loss? (C1)
2. Is ICL accuracy jump (Olsson et al. phase transition) an RLCT singularity? (C2)
3. Does lag compensation (identity map, +1 offset) form a singularity stratum?
4. Is composition (previous-token head composing with induction head) distinct from a single-head mechanism in RLCT terms? (C3)
5. Do ICL-copying circuits share RLCT across layers, depths, and models?
6. Is RLCT of the copying circuit measurable with realistic model sizes?
7. Is copying-circuit RLCT discontinuous from surrounding non-ICL attention circuitry?

## Five Claims
- C1 (definability, provable): previous-token head + induction head composition is expressible as a function-class restriction; loss definability holds.
- C2 (conjecture): ICL accuracy phase transition corresponds to an RLCT phase transition in r.
- C3 (conjecture): composition of the two heads has strictly higher RLCT than any single head, explaining multi-layer necessity (reinforcement by depth).
- C4 (conjecture): copying-circuit singularity is distinct from RLCT singularities of broader attention mechanisms.
- C5 (conjecture): RLCT of the ICL circuit is model-size stable, enabling cross-model measurement.

## Key distinctness
Distinct from: #485 (self-attention heads x RLCT, no copying circuit), #502 (RAG, retrieval external not in-circuit), #507 (Noisy Student, training noise not circuit mechanism), toric fan synthesis (ICL via toric geometry lens, not RLCT).
## Cross-refs
#8 #100 #234 #396 #485 #502 #507 + toric fan ICL notes (2026-09)
