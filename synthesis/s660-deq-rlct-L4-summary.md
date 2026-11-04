# Synthesis #660: Deep Equilibrium Models x RLCT — L4 Summary

**Date:** 2026-10-27  
**Status:** L4 Summary Complete  
**Pipeline:** L0-L1-L2-L3-L4 complete, L5 pending

## Plain-Language Summary

Deep Equilibrium Models (DEQ) find a fixed point z* = f_theta(z*, x) instead
of stacking L explicit layers. We analyze DEQ through Singular Learning Theory
(SLT), treating the equilibrium condition as an algebraic variety whose
singularities control the real log canonical threshold (RLCT).

### C1 (PROVEN): R_an,exp Definability
DEQ loss is definable in the real exponential field. The fixed-point equation
z = f_theta(z, x) is an analytic equation; its solution set is a semi-analytic
set. Standard SLT applies: the RLCT lambda_DEQ exists and bounds generalization.

### C2 (CONJECTURAL): Fixed-Point Variety as Singular Variety
The fixed-point variety V_theta(x) = {z : z - f_theta(z,x) = 0} has a singular
locus S_theta = {det(I - J_f) = 0}. At singular points, the implicit function
theorem fails, creating a bifurcation singularity. We conjecture
lambda_local = dim(V)/2 + (k-1)/2 where k is the vanishing order of det(I-J_f).
The total RLCT is the maximum over singular fibers.

### C3 (CONJECTURAL): Damping Factor as Stratum Selector
The damping family f_alpha = (1-alpha)z + alpha*f_theta interpolates between
identity (alpha=0, trivial lambda=d_phi/2) and full DEQ (alpha=1, lambda_DEQ).
At alpha* = 2/(1+rho(J_f)), the spectral radius crosses 1, causing bifurcation.
Lambda(alpha) is conjectured U-shaped: regular-trivial-singular-regular.

### C4 (CONJECTURAL): Generalization Bound
G_DEQ <= (lambda_DEQ / 2n) * log(n) + U(T_eff)/n
The equilibrium constraint concentrates singularities compared to explicit
depth-L weight-tied networks. Conjecture: lambda_DEQ <= lambda_explicit ~ L*lambda_0
because weight tying removes L-fold permutation non-identifiability.

### C5 (CONJECTURAL): Spectral Radius Phase Transition
rho(J_f) < 1: contraction, unique fixed point, lambda ~ d/2 (regular).
rho(J_f) = 1: bifurcation, loss of hyperbolicity, singular fiber.
rho(J_f) > 1: instability, multiple or no fixed points.
This links convergence basin (algorithmic) to RLCT (geometric).

## Key Novelty
The fixed-point variety as an implicit singular variety is a new singularity
type in the synthesis catalog. Unlike #251 (Neural ODE, continuous flow) or
#568 (ResNet, explicit depth), DEQ has an equilibrium constraint that creates
bifurcation singularities from Jacobian degeneracy, not from layer count or
vector field degeneracy. The damping factor provides a natural stratum selector
(like alpha in #363 adaLN or gamma in #606 RMSProp) but with a bifurcation
mechanism (spectral radius crossing) rather than smooth interpolation.

## Open Problems (7)
1. Anderson acceleration rational mixing singularity
2. det(I-J_f) vanishing order k vs lambda_local = dim(V)/2 + (k-1)/2
3. Multi-equilibrium fiber: max or sum of per-equilibrium RLCTs?
4. Formal proof lambda_DEQ <= lambda_explicit(L)
5. Monotone operator regularity: lambda = d/2 exactly?
6. Stochastic DEQ regularization: does noise smooth singularities?
7. Effective depth-RLCT: lambda_DEQ ~ lambda_0 * log(T_eff)?

## Cross-References (10)
#251 Neural ODE, #568 ResNet, #557 Mamba/SSM, #163 Normalizing Flow,
#515 Weight-tied Networks, #465 Kaiming Init, #606 RMSProp, #199 SGLD,
#562 Stochastic Depth, #485 RNN
