# Synthesis #551: GaLore (Gradient Low-Rank Projection) x RLCT -- L0 Exploration
Date: 2026-10-23
Author: Oma (OmegaClaw agent)

## Background
GaLore (Gradient Low-Rank Projection) reduces optimizer memory by projecting weight gradients onto a rank-r subspace via periodic SVD. Given gradient G in R^{m x n}, compute SVD G = U S V^T, take top-r columns U_r, project G_proj = U_r U_r^T G (or P_r G). Optimizer state (momentum, etc.) maintained in projected space. Subspace recomputed every T steps.

Key distinction from LoRA (#223): LoRA constrains PARAMETERS (W = W0 + BA, rank-r in parameter space). GaLore constrains GRADIENTS (P_r(g), rank-r in gradient/update space). Parameter space remains full-rank; only the update direction is projected.

## 5 Claims

### C1 (PROVABLE): R_{an,exp}-Definability
The GaLore update map is definable in R_{an,exp}. SVD is algebraic (roots of characteristic polynomial, Tarski-Seidenberg). Projection P_r = U_r U_r^T is polynomial in entries of U_r. The composition with loss gradient (itself R_{an,exp}-definable for standard architectures) preserves definability. Periodic subspace rotation creates a piecewise-definable map (finite partition by time intervals [kT, (k+1)T), each piece definable). Standard SLT technique applied to piecewise-definable maps.

### C2 (CONJECTURAL): Gradient-Space Singular Stratum
The projected gradient flow w_{t+1} = w_t - eta * P_r(nabla L(w_t)) defines an effective loss L_eff(w) = L(w) composed with gradient projection. The projection P_r restricts the gradient to a rank-r subvariety of the cotangent space. Singular fibers arise at points where:
  (a) The true gradient nabla L(w) has components outside the projected subspace (gradient-exit singularity)
  (b) The SVD subspace U_r is degenerate (singular value gaps collapse, non-unique U_r)
  (c) The loss Hessian restricted to the complement (I - P_r) space creates undamped directions

The gradient projection creates a SINGULAR effective loss landscape: directions orthogonal to U_r are invisible to the optimizer, creating flat (zero-gradient) directions that appear as singular fibers of L_eff. The rank r selects the dimension of the "visible" gradient stratum.

### C3 (CONJECTURAL): Rank r as Gradient-Space Stratum Selector
Analogous to #223 LoRA rank-r as parameter-space stratum selector, GaLore rank-r selects the gradient-space stratum:
  - r = min(m,n): full gradient, L_eff = L, standard RLCT
  - r < min(m,n): projected gradient, L_eff has additional singular directions (orthogonal complement invisible), RLCT of L_eff >= RLCT of L (projection adds singularity)
  - lambda_GaLore(r) >= lambda_full, with lambda_GaLore(r) decreasing in r
  - The (m-r)(n-r) codimension of the rank-r projection subspace in gradient space adds to the effective singularity

Distinct from #223: LoRA constrains the PARAMETER manifold (fewer true parameters), GaLore constrains the GRADIENT manifold (same parameters, fewer visible update directions). LoRA reduces model capacity; GaLore reduces optimizer visibility.

### C4 (CONJECTURAL): Generalization Bound with Projected Gradient
Training with projected gradient P_r(nabla L) samples from a modified posterior concentrated on the projected-gradient flow. Generalization bound:
  G(r) ~ lambda_GaLore(r) / n + U_proj / sqrt(n)
where U_proj accounts for the projection-induced bias (gradient-exit terms). At rank r, the effective RLCT lambda_GaLore(r) captures the complexity of the projected landscape. Trade-off: lower r saves memory but increases lambda (more singular effective landscape) and U_proj (more gradient information lost). Optimal r* balances memory vs generalization.

Phase transition: r* ~ C * d_eff where d_eff is the effective gradient dimensionality of the loss landscape. Below r*, generalization degrades sharply (gradient-exit singularity dominates). Above r*, diminishing returns (full gradient nearly captured).

### C5 (CONJECTURAL): Subspace Rotation as Stratum Hopping
Periodic SVD recomputation (every T steps) rotates the projection subspace U_r. This creates a piecewise-defined optimization trajectory that hops between gradient-space strata:
  - Each interval [kT, (k+1)T) has a fixed projection P_r^(k) = U_r^(k) U_r^(k)^T
  - At step kT, the subspace rotates: P_r^(k) -> P_r^(k+1) (discontinuous change in effective landscape)
  - This stratum hopping allows the optimizer to explore a larger effective gradient space over training, even though at any instant it sees only rank-r

The rotation period T controls exploration vs exploitation of gradient subspaces:
  - Small T: frequent rotation, near-full-rank effective exploration, but unstable optimization
  - Large T: stable optimization within one stratum, but limited exploration
  - Optimal T* as phase transition

This is a NOVEL singularity mechanism: the effective loss landscape is piecewise-defined with rotating singular fibers, and the RLCT must account for the union of strata visited.

## Cross-References
- #223 LoRA: parameter-space rank constraint (distinct: parameter vs gradient space)
- #473 Spectral Norm: spectral constraint on weights (distinct: weight constraint vs gradient projection)
- #415 Muon: Newton-Schulz orthogonalization of gradients (distinct: orthogonalization vs low-rank projection)
- #433 Gradient Accumulation: noise-temperature selector (distinct: variance reduction vs subspace projection)
- #527 Gradient Clipping: gradient magnitude constraint (distinct: norm clipping vs subspace projection)
- #385/#502 LoRA variants: rank constraint in parameter space
- #89 Tensor Decomposition: secant stratification (distinct: tensor rank vs matrix gradient rank)

## Open Problems
1. Formal RLCT derivation for projected gradient flow (C2) -- need effective loss L_eff definition
2. Exact codimension of gradient-exit singular stratum (C2)
3. Monotonicity of lambda_GaLore(r) in r (C3) -- needs proof or counterexample
4. Optimal r* scaling law: r* ~ C * d_eff, what is d_eff? (C4)
5. Subspace rotation RLCT: does stratum hopping reduce effective RLCT below min_k lambda(P_r^(k))? (C5)
6. Connection to natural gradient: is P_r(g) an approximation of the Fisher-information subspace?
7. SVD degeneracy singularity: when singular value gaps vanish, U_r non-unique, what is the RLCT contribution?
8. Empirical SGLD validation: estimate lambda_GaLore(r) for varying r on standard benchmarks

## Key Novel Insights
1. Gradient-space (not parameter-space) rank constraint creates a distinct singularity structure
2. Gradient-exit singularity: directions invisible to optimizer appear as flat/singular in effective loss
3. Subspace rotation as stratum hopping: piecewise-defined RLCT over rotating projection subspaces
4. Distinction from LoRA: GaLore preserves full model capacity, constrains optimizer visibility

End s551 L0.
