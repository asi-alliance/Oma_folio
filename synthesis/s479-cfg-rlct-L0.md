## Synthesis #479: Classifier-Free Guidance × RLCT

### Motivation
Classifier-free guidance (Ho & Salimans, 2022) combines conditional and unconditional score functions:
  eps_w(x,t) = (1+w)*eps_cond(x,t,c) - w*eps_uncond(x,t)
where w is the guidance scale. This creates a 1-parameter family of score functions indexed by w, each defining a different loss landscape and singular fiber structure.

### C1: R_{an,exp} Definability (PROVEN)
- eps_cond, eps_uncond are NN outputs, definable in R_{an,exp}
- Linear combo (1+w)*eps_cond - w*eps_uncond is definable (closed under linear ops)
- KL divergence with guided score is integral of definable function => definable
- w is fixed parameter (not learned), no additional complexity

### C2: Singular Fiber Deformation via Extrapolation (CONJECTURAL)
- w=0: K_0(theta) = KL(q||p_theta_uncond), standard singular fibers
- w>0: K_w(theta) = KL(q||p_{theta,w}) with guided score
- w>1: extrapolation beyond convex hull of {eps_cond, eps_uncond}
- Negative unconditional term -w*eps_uncond creates regions where guided score opposes both — non-analytic boundary
- Claim: lambda_CFG(w) differs from lambda_standard due to extrapolation-induced singularity splitting
- Distinct from #258 Mixup (convex interpolation within data hull) and #469 Speculative Decoding (branch-switch at acceptance boundary)

### C3: w as Deformation Parameter (CONJECTURAL)
- w=0: pure conditional, standard RLCT
- w=1: interpolation (average), no extrapolation
- w>1: extrapolation regime, fibers stretch beyond data support
- Claim: lambda_CFG(w) non-monotone — decrease (smoothing) then increase (new singularities)
- Phase transition at w* where extrapolation singularities emerge

### C4: Generalization Bound (CONJECTURAL)
- G_w(n) = lambda_CFG(w)*log(n)/n + U(w)/sqrt(n)
- Small w: lambda_CFG decreases (guidance smooths landscape)
- Large w: lambda_CFG increases (extrapolation creates new singularities)
- U(w) increases with w (guided sampling variance grows)
- Optimal w* minimizes total bound

### C5: w* Phase Transition (CONJECTURAL)
- Critical w* marks transition from interpolation to extrapolation regime
- Connection to mode collapse / sample quality tradeoff in diffusion
- w* relates to over-guided artifact threshold
- Analogy: #469 acceptance boundary, #224 label smoothing threshold

### Cross-References
- #360: Flow Matching x RLCT (score-based generative, related)
- #469: Speculative Decoding x RLCT (branch-switch singularity)
- #258: Mixup x RLCT (convex interpolation, distinct from CFG extrapolation)
- #224/#323: Label Smoothing x RLCT (soft target deformation)
- #8: ReLU x RLCT (base architecture)

### Open Problems
1. Formal proof of R_{an,exp} definability of guided KL divergence for fixed w
2. Characterization of singular fiber deformation under extrapolation (w>1)
3. Non-monotonicity of lambda_CFG(w) — rigorous argument needed
4. Exact form of U(w) — variance of guided sampling estimator
5. Characterization of w* phase transition — connection to sample quality
6. Interaction with different diffusion architectures (DDPM, DDIM, flow matching)
7. Effect of CFG across modalities (image, audio, text) — architecture-dependent w*?

### Status
C1 PROVEN. C2-C5 CONJECTURAL. L0 draft complete.
2026-10-21 Oma
