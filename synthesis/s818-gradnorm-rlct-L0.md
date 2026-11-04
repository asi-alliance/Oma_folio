# Synthesis #818: GradNorm × RLCT -- L0 Sketch
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-29
# Distinct from #578 (PCGrad = direction projection), #592 (NovoGrad = per-layer clipping)

## Motivation

GradNorm (Chen et al. 2018) adaptively balances multi-task losses by dynamically adjusting per-task loss weights w_i(t) such that the gradient norms of each weighted task loss, measured at a shared layer, are equalized up to a relative training rate ratio r_i(t). The key update: a gradient loss L_grad = sum_i | ||grad(w_i * L_i)||_W - r_i(t) * avg_j(||grad(w_j * L_j)||_W) | is minimized w.r.t. w_i (not W), then W is updated with the adjusted weights. This is fundamentally different from PCGrad (#578), which projects conflicting gradient directions. GradNorm rescales gradient magnitudes — it changes the effective metric on parameter space, not the direction field. No prior work connects GradNorm to singular learning theory.

## Key Questions

Q1: What is the singular structure of the GradNorm-adjusted multi-task loss vs vanilla MTL?
Q2: How does adaptive weight rescaling alter the singular fibers? Does it act as a dynamic metric change on parameter space?
Q3: Does GradNorm increase the RLCT by equalizing task contributions (reducing dominance of one task's singularity)?
Q4: What is the generalization bound for GradNorm-trained models?
Q5: The GradNorm update is a two-level optimization (inner: adjust w_i; outer: update W). Does this create a meta-loss singularity distinct from the task-level singularity?
Q6: Is there a phase transition in the number of tasks T* where GradNorm's equalization becomes effective?
Q7: How does the relative training rate r_i(t) relate to the per-task RLCT lambda_i?

## Claims

C1 (PROVEN): The GradNorm-adjusted multi-task loss K_GN(w) = sum_i w_i(t) * L_i(w) is R_an,exp definable if each L_i is R_an,exp definable and w_i(t) are real analytic functions of the loss history (w_i updated via gradient descent on L_grad, which is L1 norm of gradient norms — semi-algebraic composition of analytic functions). Thus K_GN is R_an,exp definable.

C2 (CONJECTURAL): GradNorm acts as a dynamic Riemannian metric change on parameter space. The effective loss landscape seen by SGD has a modified singular fiber V_GN^0 where the dominant task's singularity is broadened (higher local RLCT) and minority tasks' singularities are sharpened. The global RLCT lambda_GN >= lambda_vanilla_MTL when tasks have heterogeneous convergence rates, because equalization prevents premature settling into one task's narrow basin.

C3 (CONJECTURAL): The relative training rate r_i(t) = L_i(t) / L_i(0) acts as a stratum selector. Tasks with small r_i (fast convergence) have their gradient norms upweighted, effectively increasing their singular stratum's codimension contribution. The set of active weight adjustments at each step defines a time-varying stratification V_GN(w, t) whose structure depends on the rate dispersion pattern.

C4 (CONJECTURAL): Generalization bound: G_GN <= lambda_GN * log(n) / (2n) + U_GN / sqrt(n), where U_GN captures the variance from dynamic weight fluctuation. When task convergence rates are highly heterogeneous, lambda_GN > lambda_vanilla (better exploration) but U_GN > U_vanilla (weight instability adds variance), creating a bias-variance tradeoff. Optimal performance at intermediate rate dispersion.

C5 (CONJECTURAL): Phase transition at critical number of tasks T*. For T < T*, one task dominates and GradNorm ~ vanilla MTL (weights barely adjust). For T > T*, rate equalization activates and GradNorm provides significant singularity broadening. T* ~ d / lambda_0 where d is parameter dimension. SGLD-detectable: LLC increases discontinuously at T*.

## Open Problems

1. Two-level optimization singularity: The inner loop (optimizing w_i) and outer loop (updating W) have different timescales. Does this create a meta-singularity in the (W, w) joint space distinct from the task-level singularity?
2. Metric interpretation: Is the GradNorm weight rescaling equivalent to a conformal metric change g_ij(w) = w_i(w) * delta_ij on the loss landscape? If so, does the RLCT transform predictably under conformal rescaling?
3. Weight instability: The dynamic w_i(t) trajectory itself may be chaotic. Does this add a noise-like regularizer analogous to SGLD, or does it create spurious singularities in the meta-loss?
4. Stratum interaction: Unlike PCGrad (which modifies gradient direction), GradNorm preserves direction but rescales magnitude. Does this mean the singular loci {V_i^0} are unchanged, only the traversal dynamics differ?
5. Rate-RLCT connection: Can r_i(t) be predicted from lambda_i? If fast-converging tasks have lower RLCT, GradNorm upweights them — is this RLCT-aware exploration?
6. GradNorm vs PCGrad interaction: What is the RLCT of GradNorm + PCGrad combined? Does magnitude equalization + direction projection compose multiplicatively or additively on the singular fiber?
7. Discrete weight updates: w_i are updated at discrete steps. Does this create a piecewise-defined loss with boundary singularities at weight update points, similar to gradient clipping (#679)?

## Cross-References

#8 (NN RLCT foundations), #16 (SLT core), #169 (dropout stochastic stratum), #201 (early exit multi-head), #234 (temperature scaling), #241 (gradient clipping stratum), #296 (depth as stratum selector), #377 (gradient noise navigator), #470 (multi-task via task-specific heads), #518 (gradient clipping non-conservative), #553 (gradient accumulation), #569 (gradient penalty), #578 (PCGrad non-conservative field), #592 (NovoGrad per-layer), #679 (gradient clipping boundary), #817 (cutout mask-intersection)