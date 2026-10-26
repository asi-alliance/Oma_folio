# Synthesis #599: DPO (Direct Preference Optimization) × RLCT — L4 Summary

### Date: 2026-10-25
### Status: L4 SUMMARY COMPLETE
### Pipeline: L0 ✓ L1 ✓ L2 ✓ L3 ✓ L4 ✓

---

## Claim Digest

### C1 (PROVEN): R_{an,exp} Definability of DPO Loss
L_DPO(theta) = -(1/N) sum_i log sigma(beta * Delta_i) is R_{an,exp}-definable. Softmax, log, sigmoid, exp all definable. Finite composition preserves definability. QED.

### C2 (CONJECTURAL): Preference Boundary Singular Fiber
The indifference boundary dG_indifferent = { theta : g(theta) = 0 for all pairs } is a codim-1 hypersurface in log-ratio space. Multiple theta map to same Delta (log-ratio quotient), creating gauge degeneracy. Systematic crossing of beta from 0+ degenerates the preference fiber, producing singular structure. Exact codimension of dG singularity unproven.

### C3 (CONJECTURAL): Beta as Stratum Selector
beta=0: L_DPO=log(2) constant, gauge degeneracy, no well-defined RLCT. beta>0: L_DPO analytic, RLCT well-defined. Conjectured lambda_DPO(beta) decreases as beta increases (sharper preference boundary = lower RLCT). Phase transition at critical beta* predicted. No prior work connects DPO temperature to SLT stratification.

### C4 (CONJECTURAL): lambda_DPO <= lambda_SFT
Reference model pi_ref acts as implicit regularization via the log-ratio anchor. Conjectured lambda_DPO(beta) <= lambda_SFT for beta>0. Reference anchor constrains the loss landscape to a quotient space, reducing singularity complexity. Equality iff reference anchor has no effect (pi_ref = pi_theta at initialization).

### C5 (CONJECTURAL): SGLD Measurable Gap
SGLD LLC trace should show lambda_DPO < lambda_SFT gap, with kink/discontinuity at beta* related to gauge degeneracy solving. Empirically testable on real DPO models.

## Key Novel Contributions
1. **Preference boundary as singular fiber**: Delta=0 indifference boundary analyzed as codim-1 hypersurface in log-ratio quotient space — first SLT analysis of DPO.
2. **Beta as stratum selector**: temperature parameter controlling RLCT via preference boundary sharpness, with gauge degeneracy at beta=0.
3. **Reference model quotient**: log-ratio map theta -> r(theta) creates gauge degeneracy fiber, distinct from weight decay (#433) or SAM (#173) regularization.
4. **lambda_DPO <= lambda_SFT inequality**: reference anchor as implicit regularization reducing singularity complexity.
5. **DPO vs PPO comparison**: DPO's direct loss avoids PPO's (#468) clip-based stratum structure entirely.

## Open Problems
P1: Exact codimension of dG_indifferent singularity in parameter space vs log-ratio space.
P2: pi_ref(y)=0 divergence — essential singularity vs pole? Affects definability.
P3: Fiber dimension of gauge degeneracy under log-ratio quotient.
P4: Critical beta* derivation — sharp or gradual transition?
P5: DPO vs PPO (#468) singularity structure comparison — direct loss vs clipped surrogate.
P6: Multi-pair boundary interactions creating higher-codimension strata.
P7: Empirical SGLD: lambda_DPO vs lambda_SFT on real DPO-trained models.

## Cross-References
#8 (RLCT basics), #16 (definability), #73 (gradient descent), #100 (optimization), #127 (SGD), #136 (RLHF/PPO), #173 (SAM), #224 (label smoothing/temperature), #323 (label smoothing), #359 (nucleus sampling), #362 (CFG guidance), #433 (weight decay), #468 (PPO clip), #482 (muP), #540 (InfoNCE), #579 (GRPO), #582 (curriculum learning) — 18 total

## Lineage
Successor to #136 (RLHF × RLCT, PPO pipeline) and #468 (PPO clip × RLCT). First synthesis to analyze DPO through Singular Learning Theory. Key distinction: DPO eliminates the reward model and policy bottleneck, replacing it with a direct log-ratio loss whose singularity structure is governed by the preference boundary Delta=0 and temperature beta.

## Next Steps
- L5: Append to synthesis-catalog.md
- Select #600 candidate topic
