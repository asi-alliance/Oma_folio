#579: Neural ODE × RLCT — L1: Formal Claims & Definitions
Date: 2026-10-24

## D1: Neural ODE Model Definition
A Neural ODE with state z ∈ ℝ^d, parameter θ ∈ ℝ^P, and integration time T > 0 defines:
  z(T; θ) = z(0) + ∫₀ᵀ f_θ(z(t), t) dt
where f_θ: ℝ^d × ℝ → ℝ^d is a neural network with analytic activations (tanh/sigmoid).

The empirical loss:
  K_n(θ) = (1/n) Σᵢ ℓ(z(T; θ), yᵢ)
where ℓ is a loss function (e.g., cross-entropy, MSE).

The true loss:
  K(θ) = E_{(x,y)~q}[ℓ(z(T; θ), y)]

## D2: Flow Map
The flow map Φ_θ: ℝ^d → ℝ^d maps z(0) → z(T). For analytic f_θ, Φ_θ is analytic in (z(0), θ) by the analytic dependence theorem for ODEs (Theorem: if f is analytic in all variables, the solution is analytic in all variables including parameters).

## D3: True Parameter Set
W = {θ ∈ ℝ^P : K(θ) = K*} where K* = inf_θ K(θ).
Since K is real analytic (composition of analytic flow map + analytic loss), W is a real analytic variety. This satisfies the preconditions for RLCT.

## D4: Discretization Continuum
For solver step size h = T/N (N steps), the Euler discretization:
  z_{k+1} = z_k + h · f_θ(z_k, t_k)
recovers a ResNet with N residual blocks. As h → 0 (N → ∞), the continuous limit is the Neural ODE.

The effective depth D_eff = T/h, which is continuous (unlike discrete networks where depth is integer-valued).

## D5: Jacobian Spectrum
J_θ(t) = ∂f_θ/∂z |_{z(t)} ∈ ℝ^{d×d} — the Jacobian of the vector field along the trajectory.

The adjoint state a(t) = ∂L/∂z(t) satisfies:
  da/dt = -a(t) · J_θ(t)

Eigenvalues of J_θ(t): σ₁(t), ..., σ_d(t). The spectral profile along the trajectory σ(t) = (σ₁(t),...,σ_d(t)) determines gradient flow properties.

## D6: Bifurcation Types
- **Saddle-node**: A real eigenvalue of J_θ crosses zero → equilibrium appears/disappears
- **Hopf**: Complex conjugate pair crosses imaginary axis → limit cycle emerges
- **Transcritical**: Two equilibria exchange stability
- **Pitchfork**: Symmetry-breaking creates new equilibrium branches

Each bifurcation creates a qualitative change in the flow map topology → new singularity class in W.

## D7: RLCT for Neural ODE
The RLCT λ at the true parameter set W is:
  λ = lim_{β→∞} [∂/∂β · (-log ∫ exp(-β·K(θ))·φ(θ) dθ)] / (β → ∞ interpretation)

By Watanabe's theorem:
  F(β) = -log ∫ exp(-β·K(θ))·φ(θ) dθ ~ λ·log(β) + O(1) as β → ∞

where λ = RLCT(W) depends on the singularity structure of W.

## Formal Claims

### C1 (PROVEN): K(θ) is real analytic in θ
**Proof sketch**: f_θ uses analytic activations (tanh: analytic on ℝ; sigmoid: analytic on ℝ). By the theorem on analytic dependence of ODE solutions on parameters (cf. Arnol'd, Ordinary Differential Equations, Ch. 1), the flow map Φ_θ(z(0), T) is jointly analytic in (z(0), θ, T). The loss ℓ is analytic (e.g., MSE is polynomial, cross-entropy is analytic on the probability simplex). Composition K_n(θ) = (1/n)Σℓ(Φ_θ(xᵢ, T), yᵢ) is analytic. The expectation K(θ) is analytic under standard integrability conditions. Therefore W = K⁻¹({K*}) is a real analytic set, and RLCT is well-defined. ∎

### C2 (CONJECTURAL): Stratum decomposition by trajectory topology
**Claim**: W decomposes into strata W = ⊔_α W_α where each W_α corresponds to a distinct trajectory topology (equilibrium, periodic, chaotic, transient) determined by the Jacobian spectral profile σ(t).

The codimension of each stratum codim(W_α) relates to the number of bifurcation conditions satisfied (eigenvalue crossing conditions). The deepest singularity (highest λ) occurs at the stratum where the trajectory has the highest degeneracy — e.g., an equilibrium point with all Jacobian eigenvalues zero (fully degenerate fixed point).

**Evidence**: In ResNets (#100, #545), depth-related strata correspond to different numbers of active blocks. The continuous analog generalizes this: the "number of active blocks" becomes the trajectory's effective dimensionality, determined by σ(t).

### C3 (CONJECTURAL): λ scales with Jacobian spectral profile
**Claim**: For a Neural ODE with state dimension d and parameter dimension P:
  λ = P/2 - Σ_j δ_j
where δ_j > 0 are corrections from each singular direction, determined by the order of vanishing of K along the degeneracy directions.

For a trajectory with k eigenvalues of J_θ near zero along the entire trajectory, the degeneracy manifold has dimension ~k·(P/d), giving:
  λ ≈ P/2 - k·(P/d)·c
where c is a constant depending on the order of the singularity.

**Evidence**: In regular models (all eigenvalues bounded away from zero), λ = P/2. Vanishing eigenvalues create flat directions in the loss landscape → higher-dimensional singularity → lower λ.

### C4 (CONJECTURAL): Bifurcations create phase transitions
**Claim**: During training, as θ crosses a bifurcation value θ_bif, the trajectory topology changes, and λ jumps discontinuously. This manifests as:
- Loss decrease (better fit) — consistent with SLT prediction that phase transitions reduce loss
- RLCT increase (more complex singularity) — consistent with SLT phase transition theory
- Generalization gap change — governed by new λ value

**Evidence**: #545 showed discrete depth changes creating phase transitions. Neural ODE bifurcations are the continuous-depth generalization. The ICLR 2026 paper on Mamba's training dynamics (found in websearch) provides empirical evidence of phase transitions in continuous-depth-like models.

### C5 (CONJECTURAL): Generalization bound
**Claim**:
  G_NeuralODE ~ λ(ε, σ_J) / n + U(ε, σ_J) / √n

where:
- λ depends on solver tolerance ε (effective depth) and Jacobian spectral profile σ_J
- U depends on the same but captures stochastic complexity
- As ε → 0 (finer solver), λ may increase (more singular) or saturate (if singularity is ODE-intrinsic, not discretization-dependent)

**Key distinction from discrete networks**: λ is a function of the trajectory's dynamical properties, not just architecture. Two networks with the same P but different trajectory types have different λ.

## Open Problems (refined from L0)
1. Prove the stratum decomposition in C2 — characterize trajectory-degeneracy manifold dimension
2. Compute λ for the simplest case: 1D state, linear f_θ(z,t) = az, loss = (z(T) - y)²
3. Does λ diverge or converge as ε → 0? (Continuous limit RLCT)
4. Classify all ODE bifurcation types and compute their RLCT contributions
5. Empirical: measure λ in trained Neural ODEs using Watanabe's local singularity dimension estimation
6. Compare λ_NeuralODE vs λ_ResNet at matched P and matched effective depth
7. Does stiffness (eigenvalue ratio) affect λ or only U?
8. Can the adjoint backward trajectory create singularities not present in the forward?

## Cross-References
- #545: Sparse Attention × RLCT (discrete depth strata → continuous depth generalization)
- #100: ResNet × RLCT (Neural ODE = continuous limit of ResNet)
- #229: KV Cache × RLCT (eviction boundary → solver tolerance boundary)
- #8: Base RLCT theory
- #16: Free energy formula
- #469, #538: Speculative Decoding × RLCT (draft/target coupling → adjoint forward/backward coupling)