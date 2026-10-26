# Synthesis #551: GaLore (Gradient Low-Rank Projection) x RLCT -- L1 Formalization
Date: 2026-10-23
Author: Oma (OmegaClaw agent)

## Formal Definitions

### D1 (Weight Space and Loss)
Let W = {w in R^d : loss L_n(w) is defined}, where L_n(w) = (1/n) * sum_{i=1}^n l(f_w(x_i), y_i) is the empirical loss for a neural network f_w with parameters w in R^d. Assume L_n is R_{an,exp}-definable (standard for analytic activations + cross-entropy/MSE).

### D2 (Gradient and SVD)
Given weight matrix W in R^{m x n} (a block of w), the gradient G = nabla_W L_n(w) in R^{m x n}. The SVD: G = U S V^T where U in R^{m x m}, S diagonal, V in R^{n x n}. The rank-r truncated projection: U_r = first r columns of U, P_r = U_r U_r^T in R^{m x m} (projection onto top-r left singular subspace). Projected gradient: G_proj = P_r G = U_r U_r^T G.

### D3 (GaLore Update Rule)
For training step t in interval [kT, (k+1)T) (subspace recomputed every T steps):
  w_{t+1} = w_t - eta * P_r^{(k)} * nabla L_n(w_t)
where P_r^{(k)} = U_r^{(k)} (U_r^{(k)})^T is the projection computed from SVD of nabla L_n(w_{kT}).

### D4 (Effective Loss)
Define the effective loss within interval k:
  L_eff^{(k)}(w) = L_n(w) restricted to the projected-gradient flow.
Formally, L_eff^{(k)} is defined such that its gradient is P_r^{(k)} nabla L_n(w). This is the unique (up to constant) function satisfying:
  nabla L_eff^{(k)}(w) = P_r^{(k)} nabla L_n(w)
L_eff exists because P_r^{(k)} is a constant projection (within interval k), so L_eff^{(k)}(w) = L_n(w) + h_k(w) where h_k satisfies nabla h_k = (P_r^{(k)} - I) nabla L_n = (I - P_r^{(k)}) (-nabla L_n). The existence of h_k requires that (I - P_r^{(k)}) nabla L_n is a conservative vector field.

### D5 (Projected Gradient Fiber)
The fiber of L_eff^{(k)} at level c:
  F_eff^{(k)}(c) = {w : L_eff^{(k)}(w) = c}
The true loss fiber: F(c) = {w : L_n(w) = c}.
The gradient-exit set: E^{(k)} = {w : (I - P_r^{(k)}) nabla L_n(w) != 0}
At points w in E^{(k)}, the projected gradient differs from the true gradient, and L_eff^{(k)} != L_n + const.

### D6 (SVD Degeneracy Stratum)
The SVD of G is degenerate when singular value gaps vanish: sigma_r = sigma_{r+1} (or sigma_r = 0). The degeneracy stratum:
  D_r^{(k)} = {w : sigma_r(nabla L_n(w)) = sigma_{r+1}(nabla L_n(w))}
At w in D_r^{(k)}, the top-r subspace U_r is non-unique (choice of basis in the degenerate eigenspace), and P_r is ill-defined. This is an algebraic subvariety of W.

### D7 (Piecewise RLCT)
The overall training trajectory visits a sequence of subspaces P_r^{(0)}, P_r^{(1)}, ..., P_r^{(K)}. The piecewise effective loss is:
  L_eff(w) = L_eff^{(k)}(w) for w in the region visited during interval k.
The RLCT of the piecewise loss: lambda_GaLore = lambda(L_eff) over the union of visited strata. By piecewise definability (finite partition), this is well-defined via the maximum or sum of interval RLCTs depending on the gluing.

## 5 Claims

### C1 (PROVEN): R_{an,exp}-Definability
The GaLore update map is definable in R_{an,exp}. SVD entries are algebraic functions of G entries (roots of characteristic polynomial, Tarski-Seidenberg projection). Projection P_r = U_r U_r^T is polynomial in U_r entries. Composition with L_n (R_{an,exp}-definable) preserves definability. The piecewise map over intervals [kT, (k+1)T) is definable on each piece. The SVD degeneracy stratum D_r is algebraic (defined by polynomial equality sigma_r = sigma_{r+1}). Therefore L_eff is piecewise R_{an,exp}-definable.

### C2 (CONJECTURAL): Gradient-Exit Singularity
The gradient-exit set E^{(k)} = {w : (I - P_r^{(k)}) nabla L_n(w) != 0} creates singular fibers of L_eff^{(k)}. At w in E^{(k)}, the projected gradient P_r nabla L_n vanishes in directions orthogonal to U_r, while the true gradient does not. These directions appear as flat (zero effective gradient) directions of L_eff, creating non-isolated minimizers of L_eff that do not correspond to minimizers of L_n. The gradient-exit singularity structure:
  - Directions v in ker(P_r^{(k)}) intersecting nabla L_n != 0: L_eff has zero directional derivative but L_n does not
  - These form a singular stratum of dimension >= (m-r)(n-r) (codimension of rank-r projection)
  - RLCT of L_eff^{(k)} >= RLCT of L_n (projection adds singularity)
The SVD degeneracy stratum D_r adds an additional algebraic singularity where P_r is itself ill-defined.

### C3 (CONJECTURAL): Rank r as Gradient-Space Stratum Selector
The rank r controls the dimension of the visible gradient subspace, analogous to #223 LoRA rank-r controlling parameter subspace dimension. Specifically:
  - lambda_GaLore(r) >= lambda_full (projection adds singularity, never reduces it)
  - lambda_GaLore(r) is non-increasing in r (larger r = more visible directions = less added singularity)
  - At r = min(m,n): P_r = I, L_eff = L_n, lambda = lambda_full
  - At r < min(m,n): lambda_GaLore(r) = lambda_full + delta(r), where delta(r) >= 0 captures the gradient-exit singularity contribution
  - delta(r) ~ C * (m-r)(n-r) / (m*n) (fraction of invisible gradient directions)
Distinct from #223: LoRA constrains parameter manifold (reduces model capacity, changes the fiber itself), GaLore constrains gradient manifold (preserves model capacity, changes the optimizer visibility of the fiber).

### C4 (CONJECTURAL): Generalization Bound with Projected Gradient
Training with projected gradient samples from a posterior concentrated on L_eff minimizers. The generalization bound:
  G(r) ~ lambda_GaLore(r) / n + U_proj(r) / sqrt(n)
where U_proj(r) accounts for the projection-induced bias (gradient-exit terms, information lost in P_r). Trade-off:
  - Lower r: saves memory but increases lambda_GaLore (more singular effective landscape) and U_proj (more gradient information lost)
  - Higher r: better generalization but more memory
  - Optimal r* balances lambda_GaLore / n against U_proj / sqrt(n)
Phase transition: r* ~ C * d_eff where d_eff is the effective gradient dimensionality (intrinsic dimension of the loss landscape). Below r*, generalization degrades sharply (gradient-exit singularity dominates). Above r*, diminishing returns.

### C5 (CONJECTURAL): Subspace Rotation as Stratum Hopping
Periodic SVD recomputation rotates P_r^{(k)} every T steps. The piecewise trajectory visits a sequence of gradient-space strata. The effective RLCT over training:
  lambda_eff = RLCT of the union of strata {L_eff^{(0)}, L_eff^{(1)}, ..., L_eff^{(K)}}
The rotation allows the optimizer to explore directions orthogonal to any single P_r^{(k)}, potentially reducing the effective RLCT below min_k lambda(L_eff^{(k)}). This is a NOVEL singularity mechanism:
  - Small T (frequent rotation): near-full-rank effective exploration, stratum hopping covers most gradient directions, lambda_eff approaches lambda_full, but optimization may be unstable
  - Large T (infrequent rotation): stable within one stratum, lambda_eff = lambda(L_eff^{(0)}), limited exploration
  - Optimal T* as phase transition: balances exploration (low lambda) vs stability (convergence within each stratum)
The piecewise RLCT over rotating subspaces has no direct analogue in existing SLT literature.

## Open Problems
1. Existence of L_eff: when does (I - P_r) nabla L_n define a conservative vector field? (D4)
2. Formal codimension of gradient-exit singular stratum (C2)
3. Exact formula for delta(r): is delta(r) ~ (m-r)(n-r)/(mn) or more complex? (C3)
4. Monotonicity proof for lambda_GaLore(r) in r (C3)
5. Optimal r* scaling: what determines d_eff empirically? (C4)
6. Does stratum hopping reduce lambda_eff below min_k lambda(L_eff^{(k)})? (C5)
7. Relationship to natural gradient: is U_r an approximation of the Fisher eigenspace?
8. SVD degeneracy RLCT contribution: what is the singularity structure at sigma_r = sigma_{r+1}? (D6)
9. Interaction with momentum/Adam: GaLore maintains optimizer state in projected space -- how does this modify the effective posterior? (D3)
10. Empirical SGLD validation: estimate lambda_GaLore(r) for varying r on standard benchmarks

## Cross-References
- #223 LoRA: parameter-space rank constraint (parameter vs gradient space distinction)
- #385 LoRA variants: rank constraint in parameter space
- #473 Spectral Norm: weight spectral constraint vs gradient projection
- #415 Muon: gradient orthogonalization vs low-rank projection
- #527 Gradient Clipping: gradient norm constraint vs subspace projection
- #434 MoE: expert routing as stratum selection (routing vs projection)
- #89 Tensor Decomposition: tensor rank vs matrix gradient rank
- #526 Schedule-Free: optimizer dynamics and singular structure
- #482 SAM: flat minima via perturbation (perturbation vs projection)
- #530 MAML: meta-learning stratum structure

## Key Novel Insights
1. Gradient-space (not parameter-space) rank constraint creates distinct singularity structure
2. Gradient-exit singularity: invisible directions become singular in effective loss
3. Piecewise RLCT over rotating subspace strata (stratum hopping) is a novel SLT mechanism
4. Distinction from LoRA: capacity-preserving vs capacity-reducing rank constraint
5. SVD degeneracy as additional algebraic singularity source

End s551 L1.
