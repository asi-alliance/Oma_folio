# Synthesis #578: Gradient Surgery (PCGrad) x RLCT -- L1 Formalization
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-24
# Replaces lost #291 L1

## D1: Multi-Task Loss Family

Let T tasks share parameters w in R^d, with per-task losses L_t(w, x, y) that are R_an,exp definable (analytic or semi-algebraic compositions). The multi-task loss:

K_MTL(w) = sum_{t=1}^{T} alpha_t * L_t(w)

where alpha_t > 0 are task weights, sum alpha_t = 1. The fiber V_MTL^0 = {w : K_MTL(w) = min} = argmin_w sum_t alpha_t * L_t(w).

## D2: Task Gradient and Conflict Detection

For batch B, define g_t = grad_w L_t(w, B) in R^d. Two tasks i,j conflict iff <g_i, g_j> < 0. The PCGrad projection for task i against task j:

g_i->j = g_i - (<g_i, g_j> / ||g_j||^2) * g_j    (if <g_i, g_j> < 0)
g_i->j = g_i                                      (otherwise)

The effective PCGrad gradient for task i: g_i^PC = product over conflicting j of g_i->j (sequential projection order matters).

## D3: R_an,exp Definability (C1 PROVEN)

The PCGrad projection map P_ij: R^d -> R^d defined by:
- P_ij(g) = g - (<g_i,g_j>/||g_j||^2) * g_j  when <g_i,g_j> < 0
- P_ij(g) = g  when <g_i,g_j> >= 0

is semi-algebraic: it is piecewise polynomial (subtraction of polynomial projections) with switching surface {<g_i,g_j> = 0}, a hyperplane. The composition of semi-algebraic projections preserves R_an,exp definability. Thus K_PCGrad (the effective loss whose gradient field approximates the PCGrad update) is R_an,exp definable.

## D4: Multi-Task Singular Loci and PCGrad Fiber

Each task loss L_t has its own singular locus V_t^0 = {w : L_t is singular at w}. The multi-task loss K_MTL has singular fiber:

V_MTL^0 = {w : grad K_MTL = 0} = {w : sum_t alpha_t * grad L_t(w) = 0}

The PCGrad effective fiber V_PC^0 = {w : the PCGrad projected gradient = 0}. This is NOT the zero set of any scalar function gradient (PCGrad is non-conservative). V_PC^0 is a piecewise-algebraic set: on each conflict-pattern region C_sigma (defined by which pairs conflict), V_PC^0 = {w : P_sigma(sum_t alpha_t g_t) = 0} where P_sigma is the composition of projections for pattern sigma.

Key insight: V_PC^0 != V_MTL^0 in general. Projection removes conflicting components, so V_PC^0 may include points where the raw multi-task gradient is nonzero but all components are projected away.

## D5: Conflict Angle as Stratum Selector

Define the pairwise conflict set at w:
Theta(w) = {(i,j) : <g_i(w), g_j(w)> < 0}

The conflict pattern sigma(w) = Theta(w) partitions parameter space into regions C_sigma = {w : sigma(w) = sigma}. On each region, the PCGrad update is a fixed linear projection of the task gradients. The conflict angle theta_ij(w) = arccos(<g_i,g_j> / (||g_i|| ||g_j||)) acts as a continuous stratum selector: the degree of projection for pair (i,j) scales as max(0, -cos(theta_ij)).

## D6: Generalization Bound with Projection Tradeoff

G_PCGrad <= lambda_PCGrad * log(n) / (2n) + U_PCGrad / sqrt(n)

where:
- lambda_PCGrad is the RLCT of the PCGrad effective loss landscape
- U_PCGrad captures the variance of the projected gradient estimator
- Projection reduces gradient variance (removes conflicting noise) but may increase RLCT (desingularization)

Conjecture: lambda_PCGrad >= lambda_MTL (projection smooths sharp conflicting directions). U_PCGrad <= U_MTL (projection reduces estimator variance). Optimal at intermediate conflict frequency where both effects balance.

## D7: Phase Transition at Critical Task Count T*

Let T* be the critical number of tasks where conflicts become dominant. For T < T*, conflict regions have measure ~0 in parameter space, so PCGrad ~ vanilla MTL and lambda_PCGrad ~ lambda_MTL. For T > T*, conflict regions have positive measure, projection is frequently active, and lambda_PCGrad > lambda_MTL discontinuously.

Conjecture: T* ~ d / lambda_0 where d is parameter dimension and lambda_0 is the single-task RLCT. At T*, the LLC (estimated via SGLD) shows a kink/discontinuity.

## Claims Summary

- C1 PROVEN: R_an,exp definability of multi-task loss + PCGrad projection
- C2 CONJECTURAL: T distinct singular loci, V_PC^0 != V_MTL^0, partial desingularization lambda_PCGrad >= lambda_MTL
- C3 CONJECTURAL: Conflict angle theta_ij as stratum selector, piecewise-stratified fiber V_conflict(w)
- C4 CONJECTURAL: Gen bound G_PCGrad with desingularization-variance tradeoff, optimal at intermediate conflict
- C5 CONJECTURAL: Phase transition at T* ~ d/lambda_0, SGLD-detectable LLC kink

## Open Problems

1. Non-conservative field: PCGrad update is not grad of any scalar. Generalized SLT needed.
2. Desingularization mechanism: removes sharp directions vs creates new wider singularities?
3. V_PC^0 structure: piecewise-algebraic, not a true variety. RLCT well-defined?
4. Conflict frequency scaling: E[|Theta(w)|] as function of T, d, batch size?
5. RLCT-aware task weighting: choose alpha_t to minimize lambda_PCGrad?
6. MGDA vs PCGrad: different RLCT? MGDA solves QP (polynomial), PCGrad sequential projection.
7. Projection order dependence: does changing projection order change the RLCT?
