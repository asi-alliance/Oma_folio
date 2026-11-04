# Synthesis #667: Gradient Clipping × RLCT — L0 Hypothesis
## Date: 2026-10-28

## Topic
Gradient Clipping — constraining the gradient norm ||∇L(θ)|| ≤ c during training, either by clipping per-parameter or by global norm clipping: g ← g · min(1, c/||g||). This is one of the most ubiquitous training stabilization techniques, used in nearly all LLM training (e.g., clip_grad_norm_ in PyTorch).

## Why RLCT?
Gradient clipping fundamentally alters the trajectory geometry of SGD in the loss landscape:
1. The clipping boundary ||∇K(θ)|| = c defines a definable hypersurface in parameter space. Training trajectories are confined to the region where ||∇K|| ≤ c — a fiber restriction.
2. Near singularities (where ∇K → 0), clipping is inactive (gradients are already small). But the clipping boundary creates a barrier that prevents trajectories from accessing certain strata of W* — specifically those requiring large gradient excursions to reach.
3. The effective RLCT λ_eff under clipping is ≤ λ_unclipped because clipping restricts the accessible singular fibers to those reachable within the gradient-norm ball.

## Hypothesis
Gradient clipping reduces the effective RLCT by restricting accessible singular strata:
- **H1**: The clipping boundary S_c = {θ : ||∇K(θ)|| = c} is R_{an,exp}-definable (norm of definable function gradient is definable).
- **H2**: λ_clipped ≤ λ_unclipped, with equality iff all singular fibers are reachable without exceeding gradient norm c.
- **H3**: As c → ∞, λ_clipped → λ_unclipped (clipping becomes inactive).
- **H4**: As c → 0, λ_clipped → 0 (all strata become inaccessible; model frozen at initialization).
- **H5**: The optimal clipping threshold c* minimizes the generalization gap by balancing stratum accessibility (want high c for low λ) against training stability (want low c to avoid overshooting singularities).

## Key Questions
1. Is the clipping region {||∇K|| ≤ c} a definable set? Does it interact with W* to create new singular strata at the intersection W* ∩ S_c?
2. Does clipping create a phase transition at critical c* where new strata become accessible?
3. How does clipping interact with sharpness/flatness (SAM #173, #482, #559)? Clipping limits sharpness by capping gradient magnitude.
4. Connection to constrained optimization: clipping = projected gradient descent onto ||g|| ≤ c ball in gradient space, but unconstrained in parameter space. The singularity structure of the constrained problem differs from the unconstrained one.

## Cross-References (anticipated)
#8 (RLCT foundation), #16 (gen bound), #173 (SAM), #482 (sharpness), #559 (sharpness-aware), #155 (curiosity/SGLD/noise), #433 (weight decay), #241 (gradient clipping mentioned in passing), #665 (fiber bundle geometry), #666 (ECC phase transitions)

## Next: L1 formalization
