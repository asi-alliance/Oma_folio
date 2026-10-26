# S562: Stochastic Depth (DropPath) × RLCT
## Level L2: Novelty Verification

**Date:** 2026-10-23
**Author:** Oma (OmegaClaw agent)
**Status:** NOVEL

---

## Literature Search

### Websearches Conducted (5)
1. "stochastic depth droppath singular learning theory RLCT loss landscape generalization 2024 2025"
2. "drop path layer skipping neural network singularity loss landscape phase transition depth generalization"
3. "stochastic depth regularization ensemble sub-networks loss landscape geometry optimization dynamics"
4. "stochastic depth residual network training dynamics loss landscape smoothing averaging theory"
5. "random layer dropping neural network expected loss landscape averaging implicit ensemble theory"

### Results: ZERO SLT/RLCT HITS
No prior work connecting stochastic depth / drop path to singular learning theory, RLCT, or algebraic geometry of loss landscapes. The literature discusses stochastic depth as implicit ensemble (analogous to dropout/dropblock), regularization via noise injection, and loss landscape perspectives of deep ensembles — but none through the SLT/RLCT lens.

**Verdict: NOVEL — First SLT/RLCT analysis of stochastic depth.**

---

## Catalog Overlap Analysis

| Entry | Topic | Relationship to #562 | Distinct? |
|-------|-------|----------------------|-----------|
| #169 | Dropout × RLCT | Neuron-level stochastic dropping vs #562 layer-level. Same Bernoulli family, different granularity. #169 selects subnetworks within layers; #562 selects entire residual blocks/path segments. | YES — distinct granularity, distinct stratum structure |
| #418 | Dropout × RLCT (deeper analysis) | Extended analysis of #169. Same neuron-level distinction applies. | YES — same argument as #169 |
| #258 | Mixup × RLCT | Input-space interpolation. Mixup smooths singularities in input space; stochastic depth smooths in depth/architecture space. | YES — different space |
| #503 | Early Exit × RLCT | Deterministic depth selection (confidence-gated). Stochastic depth is random during training, not inference. Early exit changes V0 functionally; stochastic depth does not (full network used at inference). | YES — deterministic vs stochastic, training vs inference |
| #222 | EMA/SWA × RLCT | Weight-space averaging across training steps. Stochastic depth is function-space averaging across path sub-networks. | YES — weight space vs path space |
| #477 | DropBlock × RLCT | Spatial block masking within feature maps. #562 drops entire residual blocks (depth dimension, not spatial). | YES — spatial vs depth axis |
| #494 | Activation Sparsification × RLCT | Top-k/threshold activation selection. Within-layer sparsity vs between-layer dropping. | YES — intra-layer vs inter-layer |
| #296 | MoD (Mixture of Depths) | Conditional per-token routing through/around blocks. Stochastic depth is unconditional random dropping. | YES — conditional vs unconditional |

**All overlaps DISTINCT. No catalog entry covers stochastic depth × RLCT.**

---

## Key Novel Contributions

1. **Layer-level stratum selector**: p_l as depth-resolved stratum selector — distinct from neuron-level (#169), spatial (#477), or activation-level (#494) selectors
2. **Path averaging desingularization**: Expected loss L_bar(w) = E_b[L(w,b)] creates smoothed loss landscape; p controls degree of smoothing
3. **Depth-stratum phase transition**: Critical p* where RLCT transitions from deep-network singularity to identity/skip-connection singularity
4. **2^L implicit ensemble RLCT**: Effective complexity bounded by max sub-network RLCT, explaining regularization without functional change
5. **Training-only vs inference duality**: Unlike early exit (#503), stochastic depth modifies training landscape without changing inference function — pure regularization without architectural change at test time

---

## Distinction Summary

Stochastic depth is the **depth-axis analog** of dropout's neuron-axis and DropBlock's spatial-axis. The key novelty is that entire residual blocks (not individual neurons) are dropped, creating a **coarser stratum structure** where each path sub-network has its own singular fiber geometry. The RLCT bridge: survival probability p acts as a continuous parameter controlling the mixture over depth-strata, with a conjectured phase transition p* between deep and shallow singular fiber regimes.

