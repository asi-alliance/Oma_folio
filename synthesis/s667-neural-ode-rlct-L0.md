# Synthesis #667: Neural ODE × RLCT — L0 Hypothesis
## Date: 2026-10-28

## Topic
Neural Ordinary Differential Equations (Neural ODEs) — continuous-depth models where hidden states evolve via d h/dt = f_θ(h(t), t) and the output is h(T) after integrating from h(0) = x. The loss L(θ) = ℓ(h_θ(T; x), y) depends on θ through the ODE solution, not through explicit layer composition.

## Why RLCT?
Neural ODEs pose a fundamentally different singularity structure from discrete networks:
1. The map θ → h_θ(T; x) is defined by an integral flow, not a finite composition. The singularity structure of K(θ) = KL(p* || p_θ) arises from the ODE flow's sensitivity to θ, not from weight-tied matrix products.
2. The Jacobian of the flow ∂h/∂θ satisfies a linear ODE (variational equation), so the zero-loss set W* may have continuous symmetries (time-reparameterization, gauge freedom in f_θ) that have no discrete analogue.
3. The RLCT of Neural ODEs connects to the singularity theory of flow maps — a much less studied domain than finite networks.

## Hypothesis
The RLCT λ of Neural ODEs is governed by the dimension and multiplicity of the zero-loss set in the space of flow maps, which depends on:
- The smoothness class of f_θ (C^k regularity determines which strata are accessible)
- The time horizon T (as T → ∞, the flow may converge to a fixed point, creating an attractor singularity with different RLCT than finite T)
- The solver tolerance ε (numerical ODE solvers introduce a definable perturbation to the exact flow, analogous to noise injection)

## Key Questions
1. Is K(θ) = ℓ(h_θ(T), y) R_{an,exp}-definable? (The ODE solution involves integration of definable functions, which should preserve definability under o-minimal theory — Wilkie's theorem for Pfaffian functions.)
2. Does the flow map θ → h_θ(T) have singularities that are qualitatively different from discrete networks?
3. What is the RLCT of the time-reparameterization symmetry? (If f_θ is replaced by f_θ · g(t) for any positive g, the trajectory changes but h(T) may be preserved under reparameterized time — a continuous gauge symmetry absent in discrete nets.)
4. Does the adjoint method (backprop through ODE) create a different loss landscape geometry than standard backprop?

## Cross-References (anticipated)
#8 (RLCT foundation), #16 (gen bound), #52 (phase transitions), #151 (Mamba/SSM — continuous-time analogue), #215 (Mamba × RLCT), #233 (S4 × RLCT), #665 (fiber bundle geometry)

## Next: L1 formalization
