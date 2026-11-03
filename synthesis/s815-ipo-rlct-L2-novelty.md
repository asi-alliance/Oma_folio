# Synthesis #815: IPO × RLCT — L2 Novelty Verification
**Date:** 2026-10-28
**Status:** L2 NOVELTY VERDICT

## Search Log
1. "IPO identity preference optimization singular learning theory RLCT" → 0 results
2. "IPO loss polynomial degree 2 real log canonical threshold neural network" → 0 results
3. "IPO squared loss preference optimization generalization bound algebraic geometry" → 0 results
4. "IPO Azar 2024 preference optimization algebraic geometry singularity analysis" → 0 results
5. "identity preference optimization overfitting regularization theoretical analysis" → 0 results bridging SLT

## Catalog Cross-Check
- No prior synthesis covers IPO specifically
- Closest analogs:
  - #532/#599/#567 (DPO × RLCT): DPO uses log-sigmoid cross-entropy. IPO REMOVES the sigmoid entirely — polynomial degree 2. Distinct singularity mechanism.
  - #468 (PPO × RLCT): Non-analytic branch-switch from clipping. IPO has NO branch-switch. Distinct.
  - #668 (SimPO): Removes reference model. Not yet synthesized but listed as open problem #7. IPO retains reference model.
  - #667 (KTO): Uses pointwise sigmoid. IPO replaces with L2. Distinct.

## Novelty Verdict

### C1 (R_an,exp definability): STANDARD-NOVEL
The R_an,exp argument follows the same pattern as all prior preference losses (#532, #468, #567). The novelty is that NO softplus/sigmoid composition is needed — the loss is purely polynomial after the log-ratio. This is a simplification, not a new technique, but the absence of the transcendental composition is itself the novel claim.

### C2 (Quadratic target fiber): GENUINELY NOVEL
The order-2 contact (quadratic vanishing) at the fiber S_IPO is qualitatively distinct from DPO's order-1 exponential vanishing. This predicts a HIGHER RLCT for IPO vs DPO, which is counterintuitive (IPO was designed to reduce overfitting but may have worse generalization in the SLT sense). No prior work connects IPO's quadratic structure to RLCT.

### C3 (Beta as stratum selector): GENUINELY NOVEL
Beta selects strata via target OFFSET c=1/(2β) rather than via threshold sharpening (DPO) or clipping width (PPO). The mechanism is a smooth shift of the fiber rather than a bifurcation. This is a new stratum selector mechanism in the catalog.

### C4 (Architecture-only RLCT regime): GENUINELY NOVEL
The claim that λ_IPO depends ONLY on network geometry (not loss-function nonlinearity) is a new regime in the catalog. All prior preference losses (#532, #468, #567) have λ = λ_arch + λ_loss. IPO is the first case where λ_loss = 0 (polynomial degree 2 doesn't create new singularities). This is the strongest novelty claim.

### C5 (β* phase transition): GENUINELY NOVEL
The architecture-limited vs loss-limited phase transition is specific to IPO's polynomial structure. No prior synthesis has this bifurcation type.

## Overall Verdict: GENUINELY NOVEL (4/5 claims novel, C1 standard-novel)
5 websearches, zero SLT/RLCT bridge found. Zero catalog hits for IPO. Distinct from all 800+ prior syntheses.
