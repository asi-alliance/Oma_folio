# Synthesis #606: RMSProp × RLCT — L4 Plain-Language Summary
## Date: 2026-10-25
## Status: L4 Summary

## One-Sentence Summary
RMSProp's exponential moving average of squared gradients creates a reversible
stratum selector — parameters can freeze AND unfreeze — producing a fundamentally
different singular geometry than Adagrad's irreversible freezing, with a
gamma-mediated exploration-stability tradeoff and a conjectural "breathing singularity."

## Key Ideas in Plain Language

### The Reversibility Difference
Adagrad accumulates squared gradients forever. Once a parameter's gradient
history gets large, its learning rate shrinks permanently — it's frozen for good.
RMSProp replaces this with a forgetting factor gamma: it only remembers recent
gradients. This means a parameter that was frozen can WAKE UP again if its recent
gradient magnitude drops. The stratum commitment is reversible.

### The Forgetting Factor as a Continuous Knob
Gamma controls how much RMSProp remembers. Low gamma = short memory = lots of
unfreezing = more exploration of the loss landscape's singular structure (higher
effective RLCT). High gamma = long memory = approaches Adagrad's behavior = less
exploration (lower RLCT) but more stability. Unlike Adagrad's monotone tradeoff,
RMSProp has a genuine interior optimum gamma* — too much or too little forgetting
hurts generalization.

### The Breathing Singularity
In Adagrad, the degenerate Fisher fiber shrinks monotonically — it's a one-way
contraction. In RMSProp, the fiber RANK OSCILLATES: it grows and shrinks as
parameters freeze and unfreeze. We hypothesize this creates a new type of
singularity — a "breathing singularity" — that is neither fixed-stratum nor
monotonic-projection. This is entirely novel: no prior work in singular learning
theory discusses oscillating singular strata.

### No Sharp Phase Transition
Adagrad has a sharp phase transition t* ~ n^{1/(lambda_0+1)} where the optimizer
abruptly shifts from exploration to exploitation. RMSProp should NOT have this
kink because the EMA prevents irreversible freezing. Instead, the frozen fraction
smoothly approaches an equilibrium value with relaxation time ~1/(1-gamma).

### Falsifiable Prediction
SGLD on RMSProp should show higher LOCAL CLUSTER VARIANCE (not just mean) compared
to Adagrad at the same effective learning rate. The oscillating fibers create
fluctuations that monotonic freezing does not. If LC variance is identical, the
breathing singularity hypothesis is falsified.

## Why It Matters
This synthesis isolates the EFFECT of the forgetting factor on singular geometry.
Adam (which adds momentum to RMSProp) is harder to analyze because momentum
introduces a second EMA. RMSProp is the pure EMA case — the minimal model for
understanding how memory-based preconditioning shapes the optimizer's trajectory
through singular strata.

## Status
- L0: Claims C1-C5 written and filed
- L1: Formalization D1-D7 written and filed
- L2: Novelty verified (4 websearches, 0 catalog hits, C2-C5 genuinely novel)
- L3: MeTTa encoding written and filed
- L4: This summary
- L5: Cross-link to catalog — pending

## Cross-References
- #605 Adagrad (irreversible freezing — DIRECT CONTRAST)
- #289/#304 Adam (EMA + momentum + bias correction)
- #591 AdaBelief (belief discrepancy denominator)
- #354 SGD (vanilla baseline)
- #604 One-Cycle LR (schedule-based selector)
- #516 K-FAC/Shampoo (full-matrix preconditioning)
- #433 Weight Decay (variety modification)
- #559 SAM (perturbation-based flatness)
- #526 Schedule-Free (adaptive averaging)
