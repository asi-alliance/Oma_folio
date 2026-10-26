# Synthesis #502: Flow Matching (Generative ODE) × RLCT — L0 Exploration

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Motivation

Flow Matching (Lipman et al., 2022) learns a time-dependent vector field v(x,t;θ) that defines an ODE dx/dt = v(x,t;θ), transporting a simple noise distribution p_0 to a data distribution p_1 via a probability path. The training objective is a regression loss: L_FM(θ) = E_{t,x_0,x_1} ||v(x_t,t;θ) - u_t(x_t|x_1)||², where x_t = (1-t)x_0 + t*x_1 is the interpolation path and u_t is the conditional vector field. This is a clean, deterministic framework (no stochastic differential equations) with a well-defined loss landscape over θ.

The parameter space θ ∈ Θ parametrizes the vector field v, typically via a neural network. The loss L_FM is a sum of squared residuals over the probability path. Key questions:

1. What is the RLCT of the Flow Matching loss? The squared-norm structure suggests a determinantal/quadric variety, but the time-dependent interpolation and conditional vector field add structure.
2. Are there singular strata where the learned vector field degenerates (e.g., zero velocity, rank-deficient Jacobian)?
3. How does the probability path interpolation parameter t interact with the parameter space geometry?

## Key Observations

### 1. Quadratic Loss Structure
L_FM is a squared L² norm of the residual r(x,t;θ) = v(x_t,t;θ) - u_t(x_t|x_1). The zero-loss set V_0 = {θ : v(x_t,t;θ) = u_t ∀x_t,t} is the set of parameters achieving perfect vector field matching. When v is a neural network, V_0 is typically a real algebraic/analytic variety (assuming ReLU/tanh activations — #8, #16).

### 2. Singular Strata from Vector Field Degeneracy
The vector field v(x,t;θ) can degenerate in several ways:
- **Zero velocity stratum:** {θ : v(·,t;θ) = 0 for some t} — the model outputs no flow. This is a singular subset where the ODE has a fixed point everywhere.
- **Rank-deficient Jacobian stratum:** {θ : rank(∂v/∂x) < d} — the flow is not locally invertible. The Jacobian determinant det(∂v/∂x) = 0 defines a determinantal variety (#502-LoRA analog, #169 pruning).
- **Critical point stratum:** {θ : v(x*,t;θ) = 0 for some x*,t} — fixed points of the flow. These create non-generic trajectories.

### 3. Conditional Vector Field as Fiber Structure
The conditional vector field u_t(x_t|x_1) = (x_1 - x_0)/(1-0) = x_1 - x_0 for linear interpolation is a constant vector (independent of x_t). The learned field v must match this constant across all x_t. The fiber structure: for each target x_1, there is a fiber of θ values that correctly transport to x_1. The full zero-loss set V_0 is the intersection over all (x_0, x_1, t) of these fibers.

### 4. Time Parameter t as Continuous Stratum Selector
The time parameter t ∈ [0,1] indexes different "slices" of the vector field. At t=0, v must match the noise-to-data direction at the noise boundary; at t=1, at the data boundary. The loss integrates over all t, so the RLCT is determined by the worst (most singular) time-slice. Hypothesis: the t=0 and t=1 boundaries may have different singular structure (analogous to boundary vs interior in #201 early exit).

### 5. Connection to Diffusion Score Matching
Flow Matching generalizes diffusion score matching (which uses a specific SDE-based path). The score matching loss has known connections to SLT via the denoising score matching objective. Flow Matching's deterministic ODE formulation may have cleaner singular structure (no Itô calculus terms).

## Claims (Draft)

- **C1 (Definability):** The Flow Matching loss L_FM(θ) = E[||v(x_t,t;θ) - u_t||²] is R_{an,exp}-definable when v is a neural network with analytic activations. The squared norm is polynomial, v is analytic in θ, u_t is polynomial in (x_0, x_1), and x_t is linear in t. Composition preserves definability (#8, #16).

- **C2 (Singular stratum from vector field degeneracy):** The zero-velocity stratum S_0 = {θ : v(·,t;θ) ≡ 0} is a singular stratum of the loss landscape. At S_0, the loss is L_FM = E[||u_t||²] = E[||x_1 - x_0||²] > 0 (constant), so S_0 is NOT in V_0. However, the approach to S_0 (vanishing velocity) creates a high-RLCT region where the model fails to learn the flow. The RLCT at near-degenerate velocities λ_deg > λ_gen.

- **C3 (Rank-deficient Jacobian as singular stratum):** The set {θ : det(∂v/∂x) = 0} defines a determinantal variety in parameter space (as in #169 pruning, #502-LoRA rank deficiency). The RLCT restricted to this stratum is higher than the generic RLCT. Training trajectories that pass through rank-deficient regions experience higher local learning coefficients.

- **C4 (Generalization bound):** G_gap ≤ λ_FM · log(n)/(2n) + V_Θ/n, where λ_FM is the RLCT of the Flow Matching loss. The bound predicts that models with degenerate vector field regions (higher λ) generalize worse, consistent with empirical observations that well-conditioned flows train faster and generate better samples.

- **C5 (Probability path smoothness as RLCT modifier):** Smoother probability paths (e.g., using optimal transport paths rather than linear interpolation) reduce the RLCT by making the zero-loss set V_0 more regular. The interpolation kernel φ(t) (e.g., linear vs cosine vs OT) acts as a continuous modifier of the singularity structure. Hypothesis: λ(φ_OT) < λ(φ_linear) < λ(φ_diffusion).

## Open Problems

1. **Exact RLCT of the Flow Matching loss:** The loss is a quadratic form in the residual, so V_0 is a quadric variety intersection. For specific architectures (e.g., MLP, transformer), what is the explicit RLCT?

2. **OT paths and singularity reduction:** Does using optimal transport probability paths (as in rectified flow / Lipman 2023) genuinely reduce the RLCT, or does it only improve optimization landscape without changing the algebraic singularity structure?

3. **Connection to diffusion score matching RLCT:** Score matching has been analyzed via SLT. Is the RLCT of Flow Matching equal to, lower than, or different from the RLCT of score matching for the same data distribution?

4. **Vector field architecture and RLCT:** How does the choice of architecture for v (MLP vs U-Net vs transformer) affect the singular strata? Do attention layers (#86) introduce additional non-identifiability into the vector field?

5. **Multi-step distillation and RLCT:** Flow matching models are often distilled into fewer-step models. Does distillation change the RLCT (as in #334 self-distillation)? If the student has a different architecture, the RLCT may shift.

6. **Conditioning and conditional flow matching:** When the flow is conditioned on class y (v(x,t;θ,y)), the parameter space expands. Does conditioning introduce new singular strata or reduce existing ones?

7. **Discretization and RLCT:** The ODE is solved with a numerical integrator (Euler, midpoint, RK4). Does the discretization step affect the effective RLCT? Fine discretization → continuous limit; coarse discretization → discrete strata.

## Cross-References

#8 (ReLU definability), #16 (semi-algebraic foundation), #82 (autoencoder latent space), #86 (attention non-identifiability), #126 (TTA × RLCT — test-time adaptation of flows), #169 (pruning fiber — rank deficiency), #201 (early exit — boundary strata), #334 (self-distillation — multi-step distillation), #433 (PolyLoss — degree as selector), #501 (JEPA — capacity as selector), #502-aborted (LoRA — determinantal variety)

## Status

L0 EXPLORATION DRAFTED. 2026-10-21. Flow Matching × RLCT is genuinely uncovered (0 catalog hits, 0 SLT/RLCT web search hits). Next: L1 formalization.
