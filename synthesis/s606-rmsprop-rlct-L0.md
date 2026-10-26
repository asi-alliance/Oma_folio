# Synthesis #606: RMSProp × RLCT — L0 Conceptual Claims
## Date: 2026-10-25
## Status: L0 Conceptual Claims

## Motivation
RMSProp (Hinton, unpublished lecture notes) replaces Adagrad's irreversible
cumulative squared gradient G_t = sum_{k<=t} g_k^2 with an exponential moving
average: E_t = gamma * E_{t-1} + (1-gamma) * g_t^2, where gamma in [0,1) is the
forgetting factor. This creates a fundamentally different singular structure:
the preconditioner is no longer monotonic — parameters can "unfreeze" if their
recent gradient magnitude drops. The key RLCT question: does reversibility
of stratum commitment raise or lower the effective RLCT compared to Adagrad?

## Claims

C1 (PROVABLE): The RMSProp update map Phi_t is definable in R_{n,exp}.
  g_t definable (composition of definable NN functions), g_t^2 definable
  (polynomial), E_t = gamma*E_{t-1} + (1-gamma)*g_t^2 definable (affine
  combination), (E_t + eps)^{-1/2} definable for E_t >= 0, eps > 0.
  Update w_{t+1} = w_t - eta * diag(E_t + eps)^{-1/2} . g_t definable.

C2 (CONJECTURAL): RMSProp creates a REVERSIBLE stratum selector, unlike
  Adagrad's irreversible freezing. The EMA E_t has bounded memory: the
  effective horizon is ~1/(1-gamma) steps. Parameters can re-enter the active
  set if gradient magnitude drops below threshold. This creates an
  oscillating fiber structure: the degenerate Fisher fiber F_eff(t) =
  D_t . F . D_t has time-varying rank that can both increase and decrease,
  unlike Adagrad's monotonic rank decrease.

C3 (CONJECTURAL): The forgetting factor gamma controls the effective RLCT
  via a tradeoff: low gamma (short memory) = high adaptability = larger
  effective stratum exploration = potentially higher lambda_eff. High gamma
  (long memory) = approaches Adagrad behavior = lower lambda_eff but more
  stable. There exists an optimal gamma* that minimizes the generalization
  bound, analogous to the optimal temperature in SGLD.

C4 (CONJECTURAL): The generalization bound for RMSProp:
  G_RMSProp(t) <= lambda_eff(gamma) / n + U(gamma) / sqrt(n)
  where lambda_eff(gamma) is a decreasing function of gamma (more forgetting
  = more exploration = higher lambda_eff) and U(gamma) captures the
  complexity of the oscillating fiber structure. Unlike Adagrad's
  lambda_eff/n_eff tension, RMSProp has a gamma-mediated exploration-
  stability tradeoff. The bound is NOT monotonically improving — it has
  an optimal gamma*.

C5 (CONJECTURAL): RMSProp does NOT exhibit the sharp phase transition t*
  that Adagrad does, because the EMA prevents irreversible freezing.
  Instead, RMSProp has a smooth crossover governed by gamma: the
  "effective frozen fraction" |S_t|/d oscillates around an equilibrium
  value S_eq(gamma) that depends on the gradient statistics. SGLD on
  RMSProp should show a smooth LC trajectory without the Adagrad kink.

## Open Problems
1. Is the equilibrium frozen fraction S_eq(gamma) computable from gradient
   statistics? Does it follow S_eq ~ 1 - (1-gamma)^{1/2}?
2. Does the oscillating fiber structure create a NEW type of singularity
   (neither fixed stratum nor monotonic projection)? Is this a "breathing
   singularity"?
3. How does gamma interact with batch size n? Is there a gamma-n
   scaling law analogous to lr-n scaling?
4. Cross-optimizer: is RMSProp's lambda_eff between Adagrad (lowest) and
   SGD (highest)? Does Adam (with both EMA and momentum) occupy a
   different regime?
5. Can the "breathing singularity" hypothesis be tested via SGLD by
   measuring LC variance (not just mean) — oscillating fibers should
   produce higher LC variance than monotonic freezing?
6. Is gamma* related to the RLCT of the loss landscape lambda_0?
   Conjecture: gamma* ~ 1 - 1/lambda_0 (faster forgetting for sharper
   landscapes).
7. Falsification: if SGLD shows identical LC trajectories for RMSProp
   and Adagrad (after controlling for effective LR), the reversibility
   hypothesis (C2-C5) is falsified.

## Cross-References
- #289/#304: Adam (EMA + momentum + bias correction)
- #605: Adagrad (irreversible freezing — DIRECT CONTRAST)
- #591: AdaBelief (belief discrepancy as denominator)
- #433: Weight Decay (variety modification)
- #604: One-Cycle LR (schedule-based selector)
- #516: K-FAC/Shampoo (full-matrix preconditioning)
- #354: SGD (vanilla baseline)
- #533/#553: Gradient Accumulation (noise-temperature)
- #559: SAM (perturbation-based flatness)
- #526: Schedule-Free (adaptive averaging)
- #298/#528: Orthogonal Initialization
- #415: Muon (O(d) projection)
