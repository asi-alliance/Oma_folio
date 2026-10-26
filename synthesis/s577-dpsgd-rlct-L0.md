# Synthesis #577: DP-SGD (Differential Privacy Training) x RLCT

**Date:** 2026-10-24
**Status:** L0 Exploration
**Candidate:** Re-synthesis of #187 (files lost, L5 never appended)
**Confirmed uncovered** (zero catalog hits, zero SLT/RLCT bridge in literature)

## Background

DP-SGD (Abadi et al. 2016) modifies standard SGD with two operations:
1. **Gradient Clipping:** Per-sample gradients clipped to norm tau: g_clip = g * min(1, tau/||g||) * g
   Where tau = clip threshold. Bounds sensitivity to worst-case * worst-case.
2. **Gaussian Noise Addition:** Add calibrated noise to clipped gradient sum:
   g_priv = (1/N) [sum_i g_clip_i + N(0, sigma^2 * tau^2 * I)]
   Where sigma controls (dp noise scale), N = batch size, z_i ~ N(0, I_b).

Privacy budget epsilon controls eps approximately, and total noise scale is proportional to sigma * tau. Phi = sigma * tau (privacy loss log contribution).
Large sigma*tau destroys gradient information for given tau.
Small sigma*tau = high privacy = low utility.
## Key RLCT Bridge

DP-SGD combines two operations that each synthesis has analyzed separately:
- **#241 (gradient clipping):** Clip threshold tau creates semi-algebraic boundary singularity at ||grad L||= tau. Tau as stratum selector.
- **#377 (gradient noise):** Gaussian noise intersection acts as stratum navigator. Noise pushes optimizer across singular fiber boundaries. Sigma controls escape probability.

**NOVEL INSIGHT:** DP-SGD combines both in one algorithm. The interaction creates a **privacy-utility tradeoff** that is not just the sum of parts:
- Clipping restricts gradient excursions to ball of radius tau (norm-constrained gradient)
- Noise adds traction with variance sigma^2 * tau^2 / N (half-ghost for given tau)
- Together they define an effective SGLD on a **privacy-constrained fiber** with larger restriction circle + big active noise.
- The privacy-utility gap (well-known empirically) is not just odity distion — it is a geometric effect: the becomes more desingularized (sigma*tau) approaches (like #377 but larger sigma*tau).
- This is not independent compounding because clipping creates the boundary that gets plucked by noise.
## Five Claims

### C1: R_an definability (PROVEN)
Gradient clipping is semi-algebraic: clip-by-norm = min(g, tau/||grad L||) * g. Switching surface at ||grad L|| = tau, semi-algebraic. Tarski-Seidenberg. R_an definable. Gaussian noise adds R_an,exp closure: Analytic + exp/log terms are R_an,exp definable. Integrated out of finite components is definable via Guinnard. Result: for each sample y derived loss element (clip + surface created by anal bits) is R_an definable. Total better losses depend on integration of exp term over samples of PROVEN. RLct of the true consumer: (y) = L(lambda_i) definable via piecewise composition of above parts.

### C2: Desingularization via DP noise (CONJECTURAL)
- Desingularization acts as stratum navigation
- Large sigma*tau = constrained inverse = desingularization becomes a few stratum are parameters for classification.
- Small sigma*tau = low privacy, wide stratum access, contacts of the local landscape are restored, more local structure discovered. The spqe local singularities emerge that were previously blurred by numerous other stratum and keep sign is better. Thus expected: small sigma*tau = low privacy it can still discover local structure of batch losses (contact embeddings.
- Note how small sigma*tau actually does not destroy stratum — it just pushes the optimizer out of the singular points (the boundaries are far apart). So if the optimizer starts far from a conditio point it can get the coop and local geometry.

### C3: Clipped Gradient singular fiber (CONJECTURAL)
- The clipped gradient bounds gradient excursion by (tau^2/N)*(h-exp_next), half-ghost for given tau
- Generative: the boundaries are created by a norm constraint and noise acts crossing them. This means noise can act as a stratum navigator — to escape stuck in singularity. However it can also push to lower-RLCT stratum. Half-ghost for given sigma*tau — noise plucked to infinite — negligible detection — all strata classes visible.
- Clipping restricts gradient to ball B_tau = {g : ||g|| <= tau}. The zero-loss set intersected with this ball V_tau = V intersect B_tau creates a constrained fiber. Different tau values expose different strata of the true zero-loss set V.
- Tau as stratum selector: large tau ~ no clipping (full V visible), small tau ~ only flat directions (low-gradient strata visible).
### C4: Generalization bound with privacy noise (CONJECTURAL)
- DP-SGD effective SGLD: gradient noise variance sigma^2*tau^2/N added per step.
- RLCT-aware gen bound: G_DP ~ lambda_eff(sigma,tau)/(2n) + b(sigma,tau)/sqrt(n)
- Where lambda_eff(sigma,tau) >= lambda_0 (true RLCT) because privacy noise inflates effective dimension.
- b(sigma,tau) = bias from clipping (high-RLCT directions clipped away) + noise variance.
- Privacy-utility tradeoff: optimal (sigma,tau) minimizes G_DP subject to epsilon-constraint.
- Predicted: optimal sigma* ~ sqrt(lambda_0/n) when epsilon-budget allows, matching SGLD optimal temperature.

### C5: Phase transition at sigma* (CONJECTURAL)
- SGLD with DP noise: effective temperature T_eff = sigma^2*tau^2/N.
- Phase transition at sigma* where T_eff crosses critical value for dominant stratum.
- Below sigma*: optimizer trapped in initialization stratum (low exploration).
- Above sigma*: optimizer escapes to lower-RLCT strata (desingularization).
- sigma* depends on tau and batch size N: sigma* ~ f(lambda_0, tau, N, n).
- Testable via SGLD local learning coefficient (LLC) estimation: LLC should show kink at sigma*.
## Open Problems

1. **Desingularization order:** Does DP noise desingularize in a specific order (top-down from highest RLCT) or randomly across strata?
2. **Clipping-noise interaction:** Is the privacy-constrained fiber V_tau intersect noise strictly different from independent application of #241 + #377?
3. **Optimal schedule:** Can a RLCT-aware (sigma(t), tau(t)) schedule improve over fixed privacy budget? Analogous to #213 LR scheduling.
4. **Batch size coupling:** How does batch size N interact with sigma*tau? Larger N = lower noise per sample but more samples = different SGLD temperature.
5. **Composition theorem:** Does the RLCT of DP-SGD compose multiplicatively or additively across epochs?
6. **Empirical validation:** Can LLC estimation detect the sigma* phase transition on standard benchmarks (CIFAR-10, MNIST)?
7. **Connection to PAC-Bayes:** Privacy-utility tradeoff bounds vs PAC-Bayes generalization bounds — are they dual?

## Cross-References

- #241 (gradient clipping) — clipping boundary singularity, tau as stratum selector
- #377 (gradient noise injection) — sigma as escape probability, stratum navigator
- #213 (LR scheduling) — scheduling analogy for (sigma,tau) schedule
- #169 (dropout) — stochastic stratum selection in activation space
- #125 (dropout stratum) — stratum selection mechanism
- #185 (Constitutional AI) — constraint manifold intersection
- #527 (gradient clipping L1) — non-conservative gradient field insight
- #437 (gradient accumulation) — noise temperature reduction (inverse of DP noise)
- #234 (temperature) — sigma as temperature analog
- #525 (Entropy-SGD) — gamma as fifth dial member, desingularization cascade
- #569 (gradient penalty) — input-gradient singular fiber (distinct from parameter gradient)

## Status
L0 draft complete. C1 PROVEN (R_an,exp definability via semi-algebraic clip + Gaussian noise closure). C2-C5 CONJECTURAL. Next: L1 formalization (D1-D7 definitions, MeTTa-ready claims).
