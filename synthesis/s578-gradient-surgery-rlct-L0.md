# Synthesis #578: Gradient Surgery (PCGrad) x RLCT -- L0 Sketch
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-24
# Continues lost #291 (L1 formalized 2026-09-28, files lost)

## Motivation

Multi-task learning (MTL) trains a single model on T tasks simultaneously, minimizing L(w) = sum_t alpha_t * L_t(w). When task gradients conflict (negative inner product), the shared update deviates from each task optimum. PCGrad (Yu et al. 2020) projects each task gradient onto the normal plane of conflicting task gradients, removing antagonistic components. No prior work connects this to singular learning theory.

## Key Questions

Q1: What is the singular structure of a multi-task loss landscape vs single-task?
Q2: How does PCGrad projection alter the singular fibers of the multi-task loss?
Q3: Is PCGrad a partial desingularization? Does it increase the RLCT?
Q4: What is the generalization bound for PCGrad-trained models vs vanilla MTL?
Q5: Does the non-conservative gradient field (PCGrad update is not a gradient of any scalar function) affect the Bayesian free energy / RLCT framework?
Q6: Is there a phase transition in the number of active tasks T*?
Q7: How does gradient conflict frequency relate to singular stratum overlap?

## Claims

C1 (PROVEN): The multi-task loss K_MTL(w) = sum_t alpha_t * L_t(w) is R_an,exp definable if each L_t is R_an,exp definable. The PCGrad projection map is semi-algebraic (projection onto normal plane = polynomial subtraction when conflict detected, identity otherwise), hence R_an,exp definable. Thus the effective loss K_PCGrad is R_an,exp definable.

C2 (CONJECTURAL): The multi-task loss landscape has T distinct singular loci {V_t^0} (one per task optimum), and the global fiber V_MTL^0 = intersection of task optima. PCGrad projection effectively replaces the multi-task loss geometry with a modified landscape where conflicting gradient directions are suppressed, creating a partial desingularization: lambda_PCGrad >= lambda_MTL when tasks conflict.

C3 (CONJECTURAL): The gradient conflict angle theta_ij = angle(grad_i, grad_j) acts as a stratum selector. At theta = pi/2 (orthogonal), no projection occurs. At theta -> pi (opposing), full projection removes the conflicting component. The set of active conflicts at each w defines a piecewise-stratified fiber V_conflict(w) whose structure depends on the pairwise conflict pattern.

C4 (CONJECTURAL): Generalization bound for PCGrad: G_PCGrad <= lambda_PCGrad * log(n) / (2n) + U_PCGrad / sqrt(n), where U_PCGrad captures the variance reduction from projection. When tasks are highly conflicting, lambda_PCGrad > lambda_MTL (desingularization) but U_PCGrad < U_MTL (variance reduction), creating a tradeoff. Optimal performance at intermediate conflict frequency.

C5 (CONJECTURAL): Phase transition at critical number of tasks T*. For T < T*, conflicts are rare, PCGrad ~ vanilla MTL. For T > T*, conflicts dominate, PCGrad provides significant desingularization. T* ~ d / lambda_0 where d is parameter dimension. SGLD-detectable: LLC increases discontinuously at T*.

## Open Problems

1. Non-conservative field: PCGrad update is NOT the gradient of any scalar loss function. Does the standard RLCT/free energy framework apply? Need generalized SLT for non-conservative vector fields.
2. Desingularization mechanism: Does projection increase RLCT by removing narrow sharp directions, or by creating new wider singularities?
3. Fiber structure: Is V_conflict(w) a genuine algebraic variety or only piecewise-algebraic?
4. Conflict frequency: How does the expected number of conflicts scale with T, d, batch size?
5. Optimal alpha_t: Can task weights be chosen to minimize lambda_PCGrad? RLCT-aware task weighting.
6. MGDA vs PCGrad: Does MGDA (which solves a quadratic program) have different RLCT than PCGrad (which uses sequential projection)?
7. Continuous conflict: What happens at theta near pi/2? Is the projection discontinuous at the conflict threshold?

## Cross-References

#8 (NN RLCT foundations), #16 (SLT core), #169 (dropout stochastic stratum), #201 (early exit multi-head), #234 (temperature analog), #241 (gradient clipping stratum), #296 (depth as stratum selector), #377 (gradient noise navigator), #470 (multi-task via task-specific heads), #577 (DP-SGD clip+noise desingularization), #553 (gradient accumulation), #569 (gradient penalty)
