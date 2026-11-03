# Synthesis #688: Mixture of Experts × RLCT — L2 Novelty Verification

**Date:** 2026-10-28
**Status:** L2 Novelty Verification
**Pipeline:** L0 ✓ → L1 ✓ → L2 (this file) → L3 → L4 → L5

---

## Websearches

1. "mixture of experts singular learning theory RLCT real log canonical threshold 2024 2025" → Zero hits bridging MoE and SLT/RLCT. Results cover Gaussian mixture RLCT (Fokoue 2024) but not neural MoE routing.
2. "MoE routing loss landscape singularity generalization theory expert collapse" → Zero SLT/RLCT hits. Results cover MoE training/practical, not singular geometry.
3. "mixture of experts expert collapse generalization theory formal analysis singular fiber 2024 2025" → Zero SLT hits. Expert collapse discussed empirically only.
4. "MoE load balancing loss regularization desingularization theory expert utilization" → Zero SLT/RLCT hits. Load balancing studied as optimization, not as desingularizer.
5. "top-k routing conditional computation algebraic geometry learning theory 2024 2025" → Zero hits connecting top-k routing to algebraic geometry or singularities.
6. "mixture of experts effective dimension generalization advantage theoretical explanation RLCT lambda" → Zero RLCT hits. Generalization of MoE studied via capacity arguments, not singular learning theory.

## Catalog Overlap Analysis

Prior MoE-related entries:
- #169: Sparse MoE routing — routing topology, not RLCT formalization
- #375: MoE routing topology — graph structure of routing, not singular fiber
- #378: (related routing) — routing dynamics, not SLT
- #381: (related routing) — routing efficiency, not singular geometry

#688 is DISTINCT from all prior entries: introduces conditional singular fiber, router as stratum selector, expert collapse as low-λ/high-U pathology, load balancing as desingularizer. Prior entries do not formalize MoE in SLT framework.

## Overlap with Other Syntheses

- #155/#609 (gradient noise): Stochastic perturbation vs deterministic routing selection — DISTINCT
- #224 (label smoothing): Output desingularization vs routing desingularization — DISTINCT
- #354 (STE/mixed precision): Precision-based vs input-based stratum selection — DISTINCT
- #687 (gradient checkpointing): Checkpoint count as weak stratum selector vs router as strong learned stratum selector — DISTINCT
- #525 (Entropy-SGD): Entropy regularization of loss landscape vs load balancing of routing distribution — DISTINCT
- #686 (token dropping): Token-level capacity management vs expert-level stratum selection — DISTINCT

## Novelty Verdict: GENUINELY NOVEL

Zero prior work bridging MoE routing with SLT/RLCT. All 6 websearches returned no SLT/RLCT × MoE hits. Catalog has prior MoE entries but none formalize MoE in SLT framework. #688 introduces:
- C1: MoE loss definability (standard technique, novel application)
- C2: Effective RLCT scaling with active experts (genuinely novel)
- C3: Router as learned stratum selector (genuinely novel)
- C4: Expert collapse as low-λ/high-U pathology (genuinely novel)
- C5: Load balancing as routing desingularizer (genuinely novel)

Standout: C4 resolves the apparent paradox that expert collapse LOWERS λ but WORSENS generalization — the missing piece is the routing coverage term U. This is an original SLT insight.
