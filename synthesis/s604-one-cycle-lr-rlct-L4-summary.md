# Synthesis #604: One-Cycle LR Policy x RLCT - L4 Summary

### Date: 2026-10-25
### Status: L0-L4 COMPLETE

---

## Overview

One-Cycle LR (Smith & Topin 2019) anneals learning rate from eta_max to 0 while inversely annealing momentum. This synthesis bridges it to RLCT by interpreting the momentum/LR ratio rho(t) = beta(t)/eta(t) as a **time-dependent stratum selector** that drives a **dual desingularization** trajectory: exploration (multi-stratum) early, commitment (single-stratum) late.

## Claim Digest

- **C1 (PROVEN)**: The coupled eta(t), beta(t) dynamics are R_{an,exp}-definable. Cosine schedules, gradient, and momentum are all definable in o-minimal structures.
- **C2 (CONJECTURAL)**: Low rho (high LR, low momentum) = multi-stratum fiber; high rho = single-stratum. Phase transition at rho*.
- **C3 (CONJECTURAL)**: Super-convergence achieves lower terminal RLCT than monotone decay, because dual annealing optimizes the desingularization path.
- **C4 (CONJECTURAL)**: Monotonic rho(t) makes stratum commitment irreversible — once you cross rho*, you cannot return to exploration.
- **C5 (CONJECTURAL)**: Generalization bound: GenBound <= lambda_eff(T)/n + U(rho*)/sqrt(n).

## Key Novelty

The **momentum-LR ratio as stratum selector** is novel. Prior syntheses treated LR schedules as temperature analogues (#213, #386). Here the *ratio* of two coupled schedules, not either alone, controls singularity structure. This is distinct from SAM/ASAM (#598) which modify the loss landscape geometry rather than the trajectory through it.

## Cross-References: #213 #386 #410 #242 #526 #88 #239 #143 #58 #100 #598 #530 #509

## Open Problems

1. Optimal t* vs cosine-symmetric T/2 — does the real transition occur earlier?
2. Analytical computation of rho* from fiber codimension
3. SGLD detectability of the t* phase transition
4. Non-cosine schedules (linear, warmup-constant) generalization
5. Interaction with weight decay — does decay create a third desingularization mechanism?
6. Large beta_max washing out exploration gains
7. Comparison to two-stage LR schedules as separate desingularization events

## Next Steps

L5 catalog append, then select #605 candidate topic.