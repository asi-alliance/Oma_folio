# Synthesis #818: GradNorm × RLCT -- L1 Formalization
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-29

## Definitions

### D1: Weighted Multi-Task Loss Family
Let T tasks with per-task losses L_i(w), i=1..T, each a real analytic function of parameters w in W (subset of R^d). The GradNorm-weighted loss is:
  K_GN(w, t) = sum_i w_i(t) * L_i(w)
where w_i(t) are adaptive task weights updated at each step via the GradNorm inner loop.

### D2: GradNorm-Adjusted Zero-Loss Set
The singular fiber of the GradNorm-adjusted loss:
  V_GN^0 = {w in W : K_GN(w, t) = 0 for all tasks i, L_i(w) = 0}
This equals the intersection of individual task zero-loss sets V_i^0 = {w : L_i(w) = 0}:
  V_GN^0 = intersection_i V_i^0
The weights w_i(t) do not change the zero-loss set (since w_i > 0, K_GN = 0 iff all L_i = 0). This is a key structural observation: GradNorm preserves the singular loci.

### D3: R_an,exp Definability (C1 PROVEN)
Each L_i is R_an,exp definable (neural network with analytic activations). The GradNorm inner objective:
  L_grad(w_i) = sum_i | ||grad_W(w_i * L_i)||_{W_last} - r_i(t) * avg_j(||grad_W(w_j * L_j)||_{W_last}) |
where:
- ||grad_W(w_i * L_i)||_{W_last} is the L2 norm of the gradient of w_i * L_i w.r.t. shared layer W_last
- r_i(t) = L_i(t) / L_i(0) is the relative training rate (ratio of current to initial loss)
- The absolute value |x| = sqrt(x^2) is semi-algebraic
- L2 norm = sqrt(sum_j g_j^2) is semi-algebraic (polynomial + sqrt)
- w_i updated via gradient descent on L_grad: w_i(t+1) = w_i(t) - eta_w * dL_grad/dw_i
- dL_grad/dw_i involves ||grad_W(w_i * L_i)|| which is analytic in w_i (scaling gradient by scalar)
- Thus w_i(t) evolves via gradient descent on a semi-algebraic composition of analytic functions -> R_an,exp definable
- K_GN(w, t) = sum_i w_i(t) * L_i(w) is R_an,exp definable (product of definable functions) QED

### D4: Conformal Metric Interpretation
The GradNorm-adjusted gradient is:
  grad K_GN = sum_i w_i(t) * grad L_i(w)
This is equivalent to vanilla MTL gradient under a conformal rescaling of the loss landscape. Define the effective metric:
  g_GN = sum_i w_i(t) * g_i
where g_i is the Fisher information metric for task i. The Riemannian gradient under g_GN is:
  grad_{g_GN} K = g_GN^{-1} * grad K_GN
The GradNorm update dynamically adjusts g_GN at each step. Conjecture: the RLCT transforms under conformal rescaling as lambda_{g_GN} <= max_i lambda_i (the dominant task singularity is broadened by metric mixing).

### D5: Weight-Adjusted Fisher Information
The Fisher information matrix for the GradNorm-weighted loss:
  I_GN(w) = sum_i w_i(t)^2 * I_i(w)
where I_i is the per-task Fisher. The effective local dimension (and hence RLCT contribution) depends on the spectral structure of I_GN. When w_i are equalized (GradNorm goal), I_GN is a balanced sum, and the effective Fisher rank is determined by the union of task-relevant directions, not the dominant task alone. This suggests lambda_GN >= lambda_vanilla when tasks explore complementary directions.

### D6: Relative Training Rate as Stratum Selector
Define r_i(t) = L_i(t) / L_i(0). The GradNorm algorithm computes target gradient norms:
  G_i^target(t) = r_i(t) * avg_j(||grad(w_j * L_j)||_{W_last})
Tasks with small r_i (fast convergence, small remaining loss) get upweighted: their target gradient norm is larger relative to their actual gradient norm, so w_i increases, pushing the optimizer to spend more capacity on that task's singular stratum. This acts as a time-varying stratum selector: the active stratum at step t is determined by the pattern of (r_1, ..., r_T).

### D7: Generalization Bound with Weight Instability
  G_GN(n) <= lambda_GN * log(n) / (2n) + U_GN / sqrt(n)
where:
  U_GN = U_vanilla + C_w * Var_t(w_i(t))
The weight instability term Var_t(w_i(t)) captures the variance introduced by dynamic weight adjustment. When convergence rates are heterogeneous:
  lambda_GN >= lambda_vanilla (broader singularity, better exploration)
  U_GN >= U_vanilla (weight fluctuations add variance)
Optimal performance at intermediate rate dispersion: too homogeneous (no equalization needed) or too heterogeneous (weight instability dominates).

## Claims (from L0, formalized)

C1 (PROVEN): See D3. K_GN is R_an,exp definable.

C2 (CONJECTURAL): V_GN^0 = intersection_i V_i^0 is unchanged from vanilla MTL (D2). However, the OPTIMIZATION TRAJECTORY differs: the conformal metric g_GN (D4) changes which basin the optimizer falls into. The effective RLCT of the trajectory-visited region lambda_GN >= lambda_vanilla because metric equalization prevents premature collapse into one task's narrow stratum.

C3 (CONJECTURAL): r_i(t) selects active strata (D6). The stratification V_GN(w, t) is time-varying, with codimension contributions shifting based on rate dispersion. At each step, the dominant stratum is argmax_i(w_i(t) * ||grad L_i||).

C4 (CONJECTURAL): See D7. The bias-variance tradeoff in G_GN creates an optimal rate dispersion window.

C5 (CONJECTURAL): Phase transition T* where GradNorm equalization activates. For T < T*, one task dominates (w_i skewed, minimal adjustment). For T > T*, equalization engages. T* ~ d / lambda_0. SGLD-detectable: LLC increases discontinuously at T*.

## Open Problems (from L0, refined)

1. Two-level singularity: Joint space (W, w) has its own singular structure. Does the inner loop create a meta-fiber V_meta = {(W, w) : L_grad(w) = 0}?
2. Conformal RLCT: If g_GN = sum w_i g_i, does lambda transform as lambda_{g_GN} = f(lambda_1, ..., lambda_T, w_1, ..., w_T)? Is f the harmonic mean, geometric mean, or max?
3. Weight chaos: Is w_i(t) chaotic? If so, does this act as gradient noise (beneficial regularization, #377) or create spurious meta-singularities?
4. Locus preservation: D2 shows V_GN^0 = V_MTL^0. Does this mean GradNorm is purely a DYNAMICS modifier (like SGD momentum) not a LANDSCAPE modifier (like dropout)?
5. Rate-RLCT duality: Can r_i(t) predict lambda_i? If so, GradNorm is implicitly RLCT-aware.
6. Composition with PCGrad: GradNorm (magnitude) + PCGrad (direction) = full gradient surgery. RLCT of combined: lambda_{GN+PCG} vs lambda_GN + lambda_PCG?
7. Discrete weight updates: Piecewise-constant w_i(t) creates boundary singularities at update points. Similar to #679 gradient clipping boundaries.

## Cross-References

#8, #16, #169, #201, #234, #241, #296, #377, #470, #518, #553, #569, #578, #592, #679, #817