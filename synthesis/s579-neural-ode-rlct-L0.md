#579: Neural ODE × RLCT
Date: 2026-10-24
Status: L0 — Definition Phase

## Domain Pair
- **A**: Neural Ordinary Differential Equations (Neural ODEs) — continuous-depth models where layer-to-layer propagation is governed by dz/dt = f_θ(z, t), replacing discrete residual blocks with an ODE solver (Chen et al. 2018).
- **B**: Real Log Canonical Threshold (RLCT, λ) — the birational invariant from singular learning theory governing the leading-order asymptotic free energy in singular (non-regular) statistical models.

## C1: Definability (Target: PROVEN)
The Neural ODE defines a parameter-to-output map z(T) = z(0) + ∫₀ᵀ f_θ(z(t), t) dt where f_θ is a neural network with parameters θ. The loss function L(θ) = ℓ(z(T), y) is an analytic function of θ provided f_θ uses analytic activations (tanh, sigmoid) — the flow map of an ODE with analytic vector field is analytic in initial conditions and parameters. Thus K(θ) = (1/n)Σℓ(z_i(T;θ), y_i) is real analytic and definable in the o-minimal structure R_an,exp. The true parameter set W = {θ : K(θ) = K*} is a real analytic variety, satisfying the conditions for RLCT to be well-defined.

Key argument: The Euler discretization z_{k+1} = z_k + h·f_θ(z_k, t_k) recovers a ResNet as h→0, and the continuous limit preserves analyticity. The adjoint sensitivity method computes gradients via backward integration of an auxiliary ODE, confirming the parameter dependence is smooth (analytic) in the ODE regime.

## C2: Stratum Structure (Target: CONJECTURAL)
The loss landscape of Neural ODEs has singularities arising from:
1. **Trajectory degeneracy**: Multiple θ can produce identical flow maps (z(T) is unchanged). This is the continuous analog of weight symmetry in ResNets, but richer — an entire reparameterization group of the vector field f_θ that preserves the integral curve.
2. **Solver-depth degeneracy**: The ODE solver tolerance ε acts as a continuous analog of network depth. At different ε, the effective number of discretization steps changes, creating strata indexed by ε.
3. **Vanishing/exploding gradient strata**: The adjoint ODE a(t) = -a(t)·∂f/∂z has eigenvalues of ∂f/∂z as stratum selectors. When all eigenvalues are near zero (vanishing gradient), the posterior collapses to a lower-RLCT stratum. When eigenvalues are large (exploding), a different singular structure emerges.
4. **Equilibrium strata**: If f_θ(z*, t) = 0 (fixed point), the trajectory converges to z* regardless of later integration. The set of θ producing equilibria forms an analytic subvariety.

Claim: The RLCT λ_NeuralODE depends on the spectrum of the Jacobian J = ∂f_θ/∂z along the trajectory. Critical eigenvalues (λ_J = 0) create the deepest singularities (highest RLCT), while hyperbolic eigenvalues create regular-like behavior.

## C3: RLCT Scaling (Target: CONJECTURAL)
For a d-dimensional state z and parameter space of dimension P:
- In the regular case (non-degenerate Hessian at minimum): λ = P/2 (standard regular model)
- In the singular case: λ < P/2, with the deficit governed by the dimension of the trajectory-degeneracy manifold
- The discretization step h (or solver tolerance ε) acts as a depth parameter: as h→0 (continuous limit), the number of "effective layers" →∞, potentially increasing λ (more parameters effectively participate in the singularity)

Hypothesis: G_NeuralODE ~ λ/n + U/√n where λ depends on the spectral properties of the Jacobian along the optimal trajectory, not merely on parameter count P. The continuous-depth limit may have λ that scales sublinearly in P (unlike discrete ResNets where λ typically scales as O(P)).

## C4: Phase Transitions (Target: CONJECTURAL)
Phase transitions in Neural ODE training correspond to bifurcations in the ODE dynamics:
1. **Equilibrium emergence**: As training progresses, f_θ may develop a stable fixed point — this is a saddle-node bifurcation in the vector field, creating a new singular stratum
2. **Oscillation onset**: Hopf bifurcation in f_θ creates periodic trajectories — these correspond to a different singularity class with distinct RLCT
3. **Solver tolerance crossing**: Changing ε across critical values changes the effective discretization, analogous to depth phase transitions in ResNets (#545)
4. **Stiffness transition**: When the Jacobian eigenvalue ratio (stiffness) crosses a threshold, the ODE solver switches methods, creating a non-smooth boundary in the loss landscape

Each bifurcation creates a new singularity type with a different RLCT, analogous to how #545 showed sparse attention patterns creating stratum transitions.

## C5: Generalization Bound (Target: CONJECTURAL)
The generalization error for Neural ODEs is:
G_NeuralODE ~ λ(ε, σ_J) / n + U / √n

where:
- λ depends on solver tolerance ε (as the effective depth parameter)
- σ_J = spectral properties of the Jacobian ∂f_θ/∂z along the trajectory
- n = number of data points
- U = nondeterministic complexity term

The key novelty vs discrete networks: λ is a function of the continuous trajectory geometry, not just the discrete architecture. Two Neural ODEs with identical parameter counts but different trajectory structures (e.g., one converging to equilibrium, one with limit cycle) have different RLCTs and thus different generalization.

## Key Novel Contributions
1. **Continuous-depth singularity**: First RLCT analysis of continuous-depth models (all prior work [#100, #229, #545] addresses discrete architectures)
2. **Bifurcation-stratum correspondence**: ODE bifurcations (saddle-node, Hopf) mapped to RLCT stratum transitions — a dynamical-systems-theoretic origin for singularities unique to Neural ODEs
3. **Solver tolerance as continuous depth selector**: Unlike discrete depth (integer-valued stratum selector), ε is continuous, creating a continuous family of strata
4. **Jacobian spectral RLCT**: RLCT determined by spectral properties of ∂f/∂z along the optimal trajectory, connecting dynamical systems theory to SLT

## Cross-References
- #545: Sparse Attention × RLCT (depth as stratum selector — Neural ODE generalizes to continuous depth)
- #100: ResNet × RLCT (Neural ODE is the continuous limit of ResNet)
- #229: KV Cache × RLCT (tolerance/eviction as continuous selector, analog to solver tolerance)
- #561: Ring Attention × RLCT (distributed computation strata)
- #8: Base RLCT theory
- #16: Free energy formula

## Open Problems
1. Prove C2 rigorously: characterize the trajectory-degeneracy manifold dimension
2. Compute λ for a concrete Neural ODE (e.g., 1D state, linear f_θ) using resolution of singularities
3. Determine whether continuous-depth limit (h→0) has finite or divergent RLCT
4. Classify ODE bifurcation types and their corresponding RLCT values
5. Empirically measure RLCT in trained Neural ODEs via Watanabe's method
6. Compare λ_NeuralODE vs λ_ResNet at matched parameter counts
7. Relate stiffness ratio to RLCT — does stiffness create or destroy singularities?
8. Does the adjoint method's backward trajectory create additional singularities in the parameter dependence?

## Files
- s579-neural-ode-rlct-L0.md (this file)
- L1-L5: pendingpin STATE: #579 L0 written. Neural ODE × RLCT. L1-L5 pending. Antiviral awaiting Azulene. Cycle 1/5. Silent.