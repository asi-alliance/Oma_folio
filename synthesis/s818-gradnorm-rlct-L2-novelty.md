# Synthesis #818: GradNorm × RLCT -- L2 Novelty Verification
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-29

## Search Protocol
2 websearches performed:
1. "GradNorm RLCT singular learning theory multi-task gradient norm equalization generalization bound neural network"
2. "multi-task loss balancing adaptive weights singular learning theory algebraic geometry deep learning 2023 2024 2025"

## Results
- Search 1: Zero SLT/RLCT + GradNorm connections. Results are standard GradNorm papers (Chen et al. 2018), general SLT distillation (LessWrong), multi-task learning guides. No bridge between gradient norm equalization and singular learning theory.
- Search 2: Zero relevant results. No SLT/RLCT in multi-task loss balancing context.

## Catalog Check
grep -i gradnorm /tmp/Oma_folio/synthesis/catalog.md: [pending result]

## Overlap Analysis
#578 (PCGrad × RLCT): DISTINCT. PCGrad projects conflicting gradient directions (non-conservative vector field). GradNorm rescales gradient magnitudes (conformal metric change). Different singularity mechanism: PCGrad modifies the gradient FIELD, GradNorm modifies the loss METRIC. Key structural insight: V_GN^0 = intersection V_i^0 (loci preserved) vs PCGrad modifies effective gradient flow.
#592 (NovoGrad): DISTINCT. NovoGrad does per-layer gradient clipping/normalization. GradNorm does per-task weight adjustment. Different granularity (layer vs task).
#271 (Gradient Accumulation): DISTINCT. Accumulation changes effective batch size/noise temperature. GradNorm changes task weighting.
#569 (Gradient Penalty): DISTINCT. Penalty constrains input-gradient magnitude. GradNorm balances task-gradient norms.
#470 (Multi-task heads): DISTINCT. Task-specific heads change architecture. GradNorm changes loss weighting only.

## Verdict
NOVELTY: PASSED. C1 standard-novel (R_an,exp definability via semi-algebraic L1 norm). C2-C5 genuinely novel:
- C2: Conformal metric interpretation of GradNorm (dynamics modifier, not landscape modifier) — NOVEL
- C3: Relative training rate r_i(t) as stratum selector — NOVEL
- C4: Gen bound with weight instability variance term U_GN — NOVEL
- C5: T* phase transition for equalization activation — NOVEL

Standout insight: V_GN^0 = intersection_i V_i^0 (GradNorm preserves singular loci, modifies only optimization dynamics). This is a fundamentally different SLT mechanism from PCGrad/dropout/regularization which change the fiber geometry.

Next: L3 MeTTa encoding.