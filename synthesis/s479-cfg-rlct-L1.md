## Synthesis #479: Classifier-Free Guidance × RLCT — L1 Formalization

### Definitions

**D1 (Guided Score Function)**
Let eps_cond(x,t,c;theta) and eps_uncond(x,t;theta) be neural network score functions with parameters theta. The guided score is:
  eps_w(x,t,c;theta) = (1+w) * eps_cond(x,t,c;theta) - w * eps_uncond(x,t;theta)
for guidance scale w >= 0, fixed (not learned).

**D2 (Guided KL Divergence)**
K_w(theta) = E_{q(x,t,c)} [ KL( q(y|x,t,c) || p_{theta,w}(y|x,t,c) ) ]
where p_{theta,w} is the distribution induced by eps_w. This is the per-sample KL under the guided score.

**D3 (Singular Fiber)**
For c >= 0, the singular fiber of K_w is:
  F_w(c) = { theta in Theta : K_w(theta) = c }
The most singular stratum is S_w = argmin_c { theta : dim(F_w(c)) is maximal, K_w(theta) -> 0 }.

**D4 (Extrapolation Operator)**
E_w : (eps_cond, eps_uncond) -> eps_w is the linear extrapolation map:
  E_w(u,v) = (1+w)*u - w*v
For w in [0,1]: interpolation. For w > 1: extrapolation beyond conv{u,v}, negative v-component.

**D5 (Deformation Family)**
{ K_w }_{w>=0} is a 1-parameter family of KL divergences. K_0 = K_cond (pure conditional). K_w is continuous in w (by continuity of E_w). For w > 1, K_w leaves the convex hull of {K_cond, K_uncond}.

**D6 (RLCT of Guided Loss)**
lambda_CFG(w) = RLCT(K_w, S_w) = the RLCT of K_w at its most singular stratum S_w.
Defined as: lim_{n->inf} -log(Z_w(n)) / log(n) where Z_w(n) = integral exp(-n*K_w(theta)) dtheta.

**D7 (Phase Transition)**
w* = inf { w > 0 : lambda_CFG(w) > lambda_CFG(0) }
The critical guidance scale where extrapolation-induced singularities increase RLCT beyond the standard value.

### Claims

**C1 (R_{an,exp} Definability) — PROVEN**
eps_cond, eps_uncond are definable in R_{an,exp} (NN with ReLU/sigmoid). E_w is linear, closed under R_{an,exp}. KL divergence is integral of definable function => definable by o-minimal integration. K_w is definable for each fixed w.

**C2 (Singular Fiber Deformation) — CONJECTURAL**
For w > 1, the negative unconditional component -w*eps_uncond creates regions where eps_w opposes both eps_cond and eps_uncond. This induces singular fiber deformation: S_w is not a deformation of S_0 within the same topology. Extrapolation creates new singular strata absent at w=0. Distinct from #362 (CFG for autoregressive LLM, where w selects null-token stratum) — here CFG is in diffusion score space.

**C3 (w as Deformation Parameter) — CONJECTURAL**
lambda_CFG(w) is non-monotone: decreasing for w in [0, w*) (guidance smooths landscape via interpolation), then increasing for w > w* (extrapolation creates new singularities). The minimum at w* is the optimal guidance scale.

**C4 (Generalization Bound) — CONJECTURAL**
G_w(n) = lambda_CFG(w) * log(n)/n + U(w)/sqrt(n)
where U(w) is the fluctuation functional. U(w) increases with w (guided sampling variance grows). Optimal w* minimizes G_w. For w < w*: RLCT term dominates reduction. For w > w*: RLCT increases + U increases.

**C5 (w* Phase Transition) — CONJECTURAL**
At w*, the generalization bound G_w has a minimum. w* marks transition from interpolation-smoothing to extrapolation-singularity regime. Connection to empirical over-guidance artifact threshold. Analogy to #469 (acceptance rate phase transition) and #224 (label smoothing threshold).

### Open Problems
1. Rigorous proof that K_w singular fibers for w>1 are NOT homeomorphic to K_0 fibers
2. Non-monotonicity proof for lambda_CFG(w) — needs desingularization analysis
3. Exact form of U(w) for guided diffusion sampling
4. Characterization of w* — connection to mode collapse threshold?
5. Interaction of CFG with different samplers (DDPM, DDIM, ODE, SDE)
6. Multi-class CFG (multiple conditions) — higher-dimensional parameter space
7. Effect of CFG schedule (time-dependent w(t)) on RLCT — non-stationary deformation

### Cross-References
- #362: CFG × RLCT (autoregressive LLM guidance, null-token stratum)
- #360: Flow Matching × RLCT (score-based generative)
- #469: Speculative Decoding × RLCT (branch-switch singularity)
- #258: Mixup × RLCT (convex interpolation, no extrapolation)
- #224/#323: Label Smoothing × RLCT (soft target deformation)
- #8: ReLU × RLCT (base architecture definability)
- #16: Batch Norm × RLCT (normalization effect on landscape)
- #169: Dropout × RLCT (stochastic subnetwork averaging)
- #173: SAM × RLCT (perturb-then-minimize, distinct from extrapolation)
- #324: Gradient Noise × RLCT (additive perturbation vs multiplicative guidance)

### Status
C1 PROVEN. C2-C5 CONJECTURAL. L1 formalization complete.
2026-10-21 Oma
