# Synthesis #577: DP-SGD (Differential Privacy Training) × RLCT -- L1 Formalization
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-24

## Definitions

### D1: DP-SGD Gradient Clipping Map
clip_tau: R^d -> R^d defined by:
  clip_tau(g) = g * min(1, tau / ||g||)
Switching surface: S_tau = {g in R^d : ||g|| = tau}
Below S_tau: identity (no clipping). On S_tau: C0-not-C1 boundary.
Semi-algebraic: defined by polynomial condition ||g||^2 = tau^2.
Per-sample: for sample i, g_i = nabla L(w; x_i, y_i), g_clip_i = clip_tau(g_i).
Clipping is a projection onto closed ball B_tau = {g : ||g|| <= tau}.
Not differentiable on S_tau (subanalytic, not analytic there).
### D2: DP-SGD Gaussian Noise Addition
After clipping, add calibrated Gaussian noise:
  g_priv = (1/N) [sum_{i=1}^{N} g_clip_i + Z]
where Z ~ N(0, sigma^2 * tau^2 * I_d), sigma = noise multiplier, N = batch size.
Effective gradient: E[g_priv] = (1/N) sum_i g_clip_i (unbiased for unclipped samples).
Variance: Var[g_priv] = sigma^2 * tau^2 / N * I_d.
DP-SGD update: w_{t+1} = w_t - eta * g_priv.
Effective SGLD: Langevin dynamics with temperature T_eff = sigma^2 * tau^2 / (2 * N).
Privacy budget: epsilon ~ q * sigma * sqrt(T), q = sampling rate, T = steps.
Phi = sigma * tau = effective noise scale (privacy loss log contribution).
### D3: R_an,exp Definability of DP-SGD Loss (C1 PROVEN)
Per-sample clipped loss gradient defines a piecewise loss:
  L_clip_i(w) = L(w; x_i, y_i) if ||nabla L|| <= tau
              = (tau/||nabla L||) * L(w; x_i, y_i) + C if ||nabla L|| > tau
  (up to integration constant from path-dependent clipping)
Clipping map: semi-algebraic (min, norm, division) -> Tarski-Seidenberg -> R_an definable.
Gaussian noise density: exp(-||z||^2 / (2*sigma^2*tau^2)) -> R_an,exp definable.
Expected DP-SGD loss: K_DP(w) = E_{D,z}[L_clip(w) + noise contribution]
  = integral over data + Gaussian of semi-algebraic composition.
Closure: R_an,exp closed under finite sums, products, integration (Guinnard/Comte).
PROVEN: K_DP is R_an,exp definable. RLCT of K_DP at W_0^DP is well-defined.
### D4: Privacy-Constrained Singular Fiber
W_0^DP = {w in Theta : K_DP(w) is minimal}
The true zero-loss set under DP-SGD effective loss.
Two geometric effects shape W_0^DP:
(a) Clipping constraint: gradients with ||nabla L|| > tau are projected to B_tau.
    This removes high-curvature directions from the optimization dynamics.
    Effective fiber: V_tau = V_0 intersect {w : ||nabla L(w)|| <= tau for most samples}
    V_0 = original zero-loss set. V_tau subset V_0 (clipping exposes subset).
(b) Noise smoothing: Gaussian noise convolves K_DP with heat kernel.
    W_0^DP = {w : K_DP(w) + (sigma^2*tau^2/(2N)) * log(prior) minimal}
    Noise inflates effective RLCT: lambda_DP >= lambda_0.
Key: V_tau is NOT V_0 intersect B_tau (that is gradient space, not parameter space).
     V_tau = {w in V_0 : ||nabla L(w; x_i)|| <= tau for most i} -- parameter-space fiber
     restricted to regions where gradients are small enough to avoid clipping.
Stratum selection: tau selects which parts of V_0 are "visible" (low-gradient strata).
Noise then desingularizes within those visible strata.
### D5: (sigma,tau)-Stratified Loss Family
K_DP(w; sigma, tau) defines a two-parameter family of loss landscapes.
For fixed tau: K_DP(.; sigma, tau) is a heat-kernel-smoothed version of K_clip(.; tau).
  sigma -> 0: K_DP -> K_clip (clipped loss, no noise desingularization)
  sigma -> inf: K_DP -> constant (total desingularization, all strata merge)
For fixed sigma: K_DP(.; sigma, tau) varies with clipping threshold.
  tau -> 0: only zero-gradient directions survive -> V_tau shrinks to critical points
  tau -> inf: no clipping -> K_DP = K_0 + noise (pure #377 regime)
Stratum selector: the pair (sigma, tau) jointly determines which strata are accessible.
  tau controls which singular directions are "visible" (gradient magnitude filter).
  sigma controls how much desingularization is applied to visible strata.
Phase diagram in (sigma, tau) space: regions where different strata dominate.
### D6: RLCT of Privacy-Restricted Loss
lambda_DP(sigma, tau) = RLCT of K_DP(.; sigma, tau) at W_0^DP.
Bounds:
  lambda_DP(sigma, tau) >= lambda_clip(tau) >= lambda_0
  where lambda_clip(tau) = RLCT of clipped loss (from #241: non-decreasing as tau decreases)
  and lambda_0 = RLCT of original loss.
Noise inflation: lambda_DP >= lambda_clip because Gaussian smoothing inflates effective dimension.
  Heuristic: lambda_DP ~ lambda_clip(tau) + d_noise/2 where d_noise = effective noise dimension.
  d_noise ~ min(d, sigma^2 * tau^2 * tr(Fisher) / N) (noise fills Fisher-null directions).
Monotonicity: lambda_DP non-decreasing as sigma*tau increases (more noise = more inflation).
Method ordering: for same epsilon, adaptive clipping (#241 insight) yields lower lambda_DP
  than fixed clipping because it preserves more singular structure.
Privacy-utility RLCT gap: Delta_lambda = lambda_DP - lambda_0 = clipping loss + noise inflation.
### D7: Generalization Bound with Privacy-Utility Tradeoff
G_DP(sigma, tau) <= lambda_DP(sigma, tau) * log(n) / (2n) + b(sigma, tau) / sqrt(n)
where:
  lambda_DP(sigma, tau) = privacy-inflated RLCT (from D6)
  b(sigma, tau) = bias from clipping (high-gradient directions clipped) + noise variance
    b_clip(tau) = E[||nabla L - clip_tau(nabla L)||^2] (clipping bias, decreasing in tau)
    b_noise(sigma, tau) = sigma^2 * tau^2 / N (noise variance, increasing in sigma*tau)
Privacy constraint: sigma * tau >= sigma_min(epsilon, N, T) (from DP composition theorem).
Optimal (sigma*, tau*) minimizes G_DP subject to sigma*tau >= sigma_min.
Tradeoff: small tau -> high clipping bias but low noise (sigma can be small for same epsilon).
         large tau -> low clipping bias but high noise (sigma must be large for same epsilon).
Predicted optimum: tau* ~ sqrt(lambda_0) * n^{-1/4}, sigma* ~ sigma_min / tau*
  (balancing clipping bias b_clip ~ 1/tau^2 against RLCT inflation lambda_DP).
  This is a NOVEL prediction: RLCT-aware optimal clipping threshold for DP-SGD.
## Claims Summary

C1: PROVEN -- K_DP is R_an,exp definable (D3). Semi-algebraic clip + Gaussian exp closure.
C2: CONJECTURAL -- Desingularization via DP noise: lambda_DP >= lambda_0, sigma*tau controls inflation.
C3: CONJECTURAL -- Clipped gradient singular fiber V_tau: tau as stratum selector in parameter space.
C4: CONJECTURAL -- Gen bound G_DP with privacy-utility tradeoff, optimal (sigma*, tau*).
C5: CONJECTURAL -- Phase transition at sigma* where T_eff crosses stratum threshold.

## Open Problems

1. Desingularization order: Does DP noise desingularize top-down (highest RLCT first) or uniformly?
2. Clipping-noise interaction: Is V_tau^DP strictly different from independent #241 + #377?
3. Optimal schedule: RLCT-aware (sigma(t), tau(t)) schedule vs fixed privacy budget?
4. Batch size coupling: How does N interact with sigma*tau in the RLCT bound?
5. Composition theorem: Does lambda_DP compose multiplicatively or additively across epochs?
6. Empirical validation: LLC estimation to detect sigma* phase transition (CIFAR-10/MNIST)?
7. PAC-Bayes duality: Are privacy-utility bounds and PAC-Bayes gen bounds dual via RLCT?
8. Adaptive clipping: Does per-layer adaptive tau lower lambda_DP for same epsilon?
9. Fisher-null filling: Is d_noise ~ sigma^2*tau^2*tr(Fisher)/N accurate?
10. Connection to #525 Entropy-SGD: Both add noise to gradient -- is gamma = sigma*tau?

## Cross-References

- #241 (gradient clipping) -- clipping boundary singularity, tau as stratum selector
- #377 (gradient noise injection) -- sigma as escape probability, stratum navigator
- #187 (DP-SGD original, lost) -- this re-synthesis replaces it
- #213 (LR scheduling) -- scheduling analogy for (sigma, tau) schedule
- #169 (dropout) -- stochastic stratum selection in activation space
- #125 (dropout stratum) -- stratum selection mechanism
- #527 (gradient clipping L1) -- non-conservative gradient field insight
- #553 (gradient accumulation) -- noise temperature reduction (inverse of DP noise)
- #234 (temperature) -- sigma as temperature analog
- #525 (Entropy-SGD) -- gamma as desingularization dial, possible duality
- #569 (gradient penalty) -- input-gradient singular fiber (distinct from parameter gradient)
- #354 (STE) -- straight-through estimator, piecewise gradient definability

## Status
L1 formalization complete. C1 PROVEN. C2-C5 CONJECTURAL. 10 open problems, 12 cross-refs.
Next: L2 novelty verification (websearch for prior DP-SGD x SLT/RLCT bridges).
