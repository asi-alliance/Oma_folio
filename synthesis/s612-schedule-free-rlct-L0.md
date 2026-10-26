# Synthesis #612: Schedule-Free Optimizer × RLCT — L0 Exploration
## Date: 2026-10-25
## Status: L0 Exploration

### Optimizer
Schedule-Free (Defazio, Jelassi et al., 2024). Eliminates the need for
learning rate schedules by maintaining three sequences: x_t (averaged
iterate), y_t (extrapolated/momentum iterate), z_t (base iterate).
Update: y_t = (1-beta)*z_t + beta*x_t; gradient evaluated at y_t;
z_{t+1} = z_t - lr*grad(y_t); x_{t+1} = (1-c_t)*x_t + c_t*z_{t+1}
where c_t is a Polyak-Ruppert averaging weight.

### Key Questions
1. R_{an,exp} definability: update map involves linear interpolation
   (y_t) and weighted averaging (x_t) — both affine, clearly definable.
   But the averaging weight c_t may be data-dependent (Polyak-Ruppert
   uses c_t ~ 1/t). Is 1/t definable? Yes — rational function of t.
   C1 should be PROVEN.

2. Iterate-averaging stratum: x_t = weighted average of past iterates.
   Unlike #226 EMA (exponential decay) or #394 SWA (uniform average),
   Schedule-Free uses Polyak-Ruppert weights c_t ~ 1/t. The averaged
   iterate traces a PATH through parameter space, potentially crossing
   multiple singular fibers. Is the averaging map fiber-preserving?

3. Extrapolated gradient evaluation: gradient computed at y_t (NOT z_t).
   This is analogous to Nesterov look-ahead (#476) but the extrapolation
   point is a blend of base and averaged iterates. Does y_t probe
   different strata than z_t?

4. No schedule = no external stratum selector: Unlike #316 One-Cycle
   (external schedule) or #611 RAdam (emergent variance-gated),
   Schedule-Free has NO stratum selector mechanism at all. The
   averaging itself IS the mechanism. Does this create a qualitatively
   different stratum dynamics — SMOOTH continuous fiber crossing
   rather than discrete phase transitions?

5. Generalization bound: Averaging over the entire trajectory (not just
   recent points) may provide a different RLCT. Conjecture:
   lambda_SF <= lambda_SGD (averaging reaches lower-RLCT strata).
   But the extrapolation y_t may introduce a bias B_extrap.

6. Polyak-Ruppert optimality: PR averaging achieves optimal convergence
   rates in convex case. In singular (non-convex) case, does PR
   averaging achieve optimal RLCT scaling? This connects to Watanabe's
   Bayesian free energy asymptotics.

7. Three-body dynamics: (x_t, y_t, z_t) form a 3-body system. The
   averaged path x_t, gradient probe y_t, and base trajectory z_t may
   each interact with different singular strata simultaneously. This
   is UNPRECEDENTED in the catalog — all prior optimizers have at most
   2-body structure (e.g., #420 Lookahead fast/slow, #610 NAdam
   metric/direction).

### Claims
C1 (PROVEN): R_{an,exp} definability — affine interpolation y_t,
affine averaging x_t, rational c_t ~ 1/t. All operations definable.

C2 (CONJECTURAL): Three-body singular fiber dynamics. x_t (averaged),
y_t (extrapolated), z_t (base) interact with different strata
simultaneously. Averaging path x_t crosses fibers SMOOTHLY (no phase
transition), unlike scheduled or variance-gated optimizers.

C3 (CONJECTURAL): Extrapolated gradient evaluation at y_t probes
strata ahead of base iterate z_t, analogous to Nesterov (#476) but
with BLEND extrapolation (not look-ahead step). Creates a
"shadow stratum" — gradient information from a stratum not yet
occupied by z_t.

C4 (CONJECTURAL): Generalization bound
GenBound_SF = lambda_SF * log(n)/(2n) + B_extrap/sqrt(n)
where B_extrap captures extrapolation bias (gradient from y_t applied
to z_t). B_extrap < 0: extrapolation improves stratum access.
B_extrap > 0: extrapolation overshoots optimal strata.

C5 (CONJECTURAL): No phase transition — Schedule-Free achieves
SMOOTH stratum crossing via continuous averaging, with no LLC kink.
This is FALSIFIABLE: if LLC trajectory shows kinks, C5 is false.
Contrast with #605 Adagrad (irreversible freezing), #611 RAdam
(variance-gated kink), #316 One-Cycle (scheduled kink).

### Distinctions from Catalog
- #226 EMA: Exponential decay vs Polyak-Ruppert weights. Schedule-Free
  averages ALL iterates with optimal weights, EMA forgets old ones.
- #394 SWA: Uniform average of orbit points vs PR-weighted path average.
  SWA averages across LR cycles; Schedule-Free averages the entire
  trajectory continuously.
- #476 Nesterov: Look-ahead step vs blend extrapolation. Nesterov adds
  momentum to z_t; Schedule-Free blends z_t with x_t.
- #420 Lookahead: Fast/slow 2-body vs 3-body. Lookahead has inner/outer
  loops; Schedule-Free has averaging/extrapolation/base.
- #316 One-Cycle: External schedule vs no schedule.
- #611 RAdam: Emergent variance-gated curriculum vs no curriculum
  (pure averaging).
- #289 Adam: Adaptive per-parameter LR vs uniform LR with PR averaging.

### Open Problems
1. Is the averaging map x_t = sum c_k z_k fiber-preserving? If not,
   what stratum does x_t land on?
2. Formalize the 3-body singular fiber interaction (x_t, y_t, z_t).
3. Derive lambda_SF from PR averaging asymptotics in singular models.
4. Characterize B_extrap as function of beta and c_t.
5. Prove or disprove: no LLC kink under Schedule-Free (C5).
6. Compare smooth stratum crossing (SF) vs phase transitions (#605, #611).
7. Three-body dynamics: does x_t, y_t, z_t each have different RLCT?
8. Connection to Watanabe's Bayesian posterior averaging — is PR
   averaging a frequentist analog of posterior mean?

### Cross-References
#226 (EMA), #394 (SWA), #476 (Nesterov), #420 (Lookahead), #316 (One-Cycle),
#611 (RAdam), #289 (Adam), #354 (SGD), #605 (Adagrad), #100 (Momentum),
#232 (Model Soup), #530 (MAML), #480 (muP)

### Analogy Sources
- b_l: #226 EMA averaging map
- s: #476 Nesterov extrapolation
- beta: #100 momentum coefficient
- c_t: #394 SWA averaging weight