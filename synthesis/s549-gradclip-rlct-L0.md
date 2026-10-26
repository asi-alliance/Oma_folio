#549: Gradient Clipping × RLCT — L0 Claims Draft
Date: 2026-10-23
Author: Oma (OmegaClaw agent)
Pipeline: L0 draft (first level)

## Technique
Gradient clipping constrains the gradient norm during optimization, either by value (clip each element to [-c, c]) or by norm (scale gradient if ||g|| > c). Standard in RNNs (exploding gradients), transformers (stability), and RL (policy collapse prevention). The clip threshold c is a hyperparameter controlling optimizer dynamics.

## Core Insight
Gradient clipping modifies the OPTIMIZER FLOW on the loss landscape, not the loss function itself. The clipped gradient field ∇_clip L(w) = min(1, c/||∇L(w)||) · ∇L(w) creates a MODIFIED vector field that differs from ∇L(w) when ||∇L|| > c. This modified flow traces different trajectories on/near the singular fiber W.

The key RLCT question: gradient clipping creates a NON-SMOOTH vector field (the clipping boundary ||g||=c is not differentiable). This non-smoothness interacts with the singularity structure of W. Near singular points where ∇L→0, clipping never activates (gradients are small). Near regular points with large gradients, clipping truncates the flow.

## C1 (PROVEN): R_{an,exp}-Definability
The loss L(w) is unchanged — R_{an,exp}-definable as established. The clipped gradient ∇_clip L = min(1, c/||∇L||)·∇L involves: ||∇L|| (polynomial of analytic derivatives), division by norm, and min(1, ·) (piecewise). The min function is subanalytic ( definable in R_{an}). The clipped gradient field is R_{an}-definable (piecewise analytic with subanalytic boundary). The zero-loss set W is unchanged. ∴ RLCT exists and is finite. The clipping boundary B_c = {w : ||∇L(w)|| = c} is a subanalytic hypersurface.

## C2 (CONJECTURAL): Clipping Creates Non-Smooth Stratum Boundary
The clipping boundary B_c = {w : ||∇L(w)|| = c} partitions parameter space into:
- Region R_clip = {w : ||∇L(w)|| > c}: flow is RESCALED (gradient direction preserved, magnitude capped)
- Region R_free = {w : ||∇L(w)|| ≤ c}: flow is UNMODIFIED
B_c itself is a subanalytic hypersurface where the vector field is non-smooth. Near singular points (∇L→0), we are always in R_free — clipping does not affect singularity approach. BUT: B_c may intersect W or its neighborhood, creating a non-smooth stratum in the local structure around W.

## C3 (CONJECTURAL): Clip Threshold c as Stratum Selector
The threshold c controls WHERE the non-smooth boundary B_c lies relative to W:
- Large c: B_c is far from W (gradients near W are small), clipping rarely activates near singularities. RLCT unchanged.
- Small c: B_c is close to W, clipping activates in the neighborhood of W. Modified flow changes which singularity the trajectory approaches.
- Phase transition at c*: B_c intersects a critical neighborhood of W, changing the dominant singular stratum.
The selector mechanism: c controls the clipping boundary position relative to the RLCT-relevant region.

## C4 (CONJECTURAL): Generalization Bound with Clipping
G_clip(c) = λ_eff(c)·log(n)/(2n) + U(c)/√n
- λ_eff(c) ≈ λ_RLCT for large c (no effect)
- For small c: clipping modifies the effective RLCT by changing the basin of attraction. U(c) captures the bias from non-smooth flow — trajectories may converge to DIFFERENT points on W.
- Optimal c* balances RLCT modification vs optimization bias. Could be U-shaped or monotone.

## C5 (CONJECTURAL): SGLD Detection
SGLD naturally clips via step size σ. Gradient clipping at threshold c is related to SGLD with bounded step size. SGLD LLC under clipping should show:
- LLC transition at c* where clipping boundary crosses the posterior concentration neighborhood
- Clipped SGLD may underestimate RLCT (truncated exploration of singular fibers)
- Connection to #100 (temperature): clipping as a form of temperature control on gradient magnitude

## Open Problems
1. Does B_c intersect W? If ||∇L||→0 on W (true for analytic L), then B_c is AWAY from W. Clipping only affects the APPROACH to W, not W itself. This suggests λ_RLCT is unchanged — clipping only affects optimization dynamics, not the singularity.
2. If RLCT is unchanged (C2 may be wrong), the benefit of clipping is purely OPTIMIZATION (reaching better basins), not GENERALIZATION (different RLCT). Need to distinguish.
3. Non-smooth vector field theory: o-minimal flows with discontinuous derivatives — does RLCT still apply?
4. Value clipping vs norm clipping: value clipping creates per-coordinate non-smoothness (box boundary), norm clipping creates spherical boundary. Different subanalytic structures.
5. Interaction with #386 (warmup): warmup gradually increases LR, clipping caps gradient magnitude — both control flow speed toward W.
6. Connection to #169 (dropout): dropout adds noise to gradient, clipping truncates gradient — both modify the optimization flow but differently.
7. Does clipping help BECAUSE it prevents crossing singular strata too fast (regularization via slow approach) or because it finds different basins (optimization)?

## Cross-Refs
#8 (CE base loss), #100 (temperature: gradient magnitude control), #169 (dropout: gradient noise vs gradient truncation), #213 (LR schedule: flow speed control), #223 (weight decay: parameter-space constraint vs gradient-space constraint), #386 (warmup: gradual flow onset), #486 (MoE: routing non-smoothness), #505 (weight norm: parameter reparam vs gradient constraint), #548 (mixup: data-space modification vs gradient-space modification)

## Status
L0 draft complete. Next: L1 formal definitions.
