## Synthesis #478: SIREN × RLCT — L0 Outline

### Architecture
SIREN (Sitzmann et al. 2020): fully connected network with sinusoidal activations. Layer l: φ_l(x) = sin(ω_l · (W_l · φ_{l-1}(x) + b_l)), with φ_0 = input. Initial layer typically ω_0 = 30. Each layer applies sin after affine transform.

### C1 (Proven): R_an,exp Definability
sin is an entire analytic function, trivially definable in R_an,exp (Taylor series: sin(x) = Σ (-1)^k x^{2k+1}/(2k+1)!). Composition of analytic functions with affine maps preserves definability. The forward pass is a finite composition of sin ∘ affine, all definable in R_an,exp. The loss L(θ) = (1/n)Σ (f_θ(x_i) - y_i)² is a polynomial composition of definable functions → definable. C1 PROVEN.

### C2 (Conjectural): Infinite Periodic Zero Locus Singularity
Unlike ReLU (codim-1 kink at single point per neuron) or GELU (transcendental point singularity), sin(ωx) = 0 at x = kπ/ω for all k ∈ Z. Each zero is a codimension-1 analytic hypersurface. In a bounded input domain [-R, R], there are ⌊2Rω/π⌋ distinct zeros. As ω → ∞, the number of singular hypersurfaces grows linearly in ω.

The true parameter space singularity: for each layer l, the set {θ : φ_l(x; θ) = 0 ∀x} defines a degenerate fiber. With sin activations, the periodicity creates a Z-action on parameter space — shifting W_l or b_l by multiples of 2π/ω_l maps the network to an equivalent one. This Z-symmetry group is infinite (unlike finite symmetries in ReLU networks).

The singular set W = {θ : ∇L(θ) = 0} contains infinitely many isolated critical points in any bounded parameter region, one per period. The RLCT λ_SIREN is determined by the local singularity type at each periodic copy, but the multiplicity is infinite globally. Under Hironaka resolution, a single blow-up template applies to all periodic copies (by periodicity), giving λ_SIREN = λ_local × (effective number of active periods in training domain).

C2: λ_SIREN > λ_ReLU for sufficiently high ω, because the periodic Z-symmetry creates additional degenerate fibers not present in non-periodic activations.

### C3 (Conjectural): ω as Continuous Stratum Selector
The initial frequency ω_0 controls the density of zero hypersurfaces. Higher ω_0 → more zeros in bounded domain → denser singular strata → higher effective RLCT. This makes ω_0 a continuous stratum selector (analogous to γ in Layer Scale #421, p in Dropout #169, but acting on periodicity rather than magnitude).

Claim: λ_SIREN(ω) is monotonically non-decreasing in ω for ω > 0. Each increment adds another period's worth of singular hypersurfaces to the effective training domain.

The relationship is approximately λ_SIREN(ω) ~ λ_0 + c·⌊2Rω/π⌋ where λ_0 is the base singularity and c is the per-period RLCT increment. For large ω, this becomes approximately linear: λ_SIREN(ω) ≈ λ_0 + (2Rc/π)·ω.

### C4 (Conjectural): Generalization Bound
G_SIREN(ω, n) = λ_SIREN(ω)·log(n)/n + U_SIREN(ω)/√n

where U_SIREN(ω) captures the variance from periodic critical points. At low ω, U is low (few critical points, smooth landscape). At high ω, U increases (many shallow minima, higher variance across initializations). The optimal ω* balances RLCT regularization (favoring low ω) against representational capacity (favoring high ω).

Testable via SGLD: measure λ_SIREN(ω) by tracking loss curvature during Langevin sampling at fixed ω values.

### C5 (Conjectural): ω* Phase Transition
There exists a critical frequency ω* ~ O(d) where d is the intrinsic signal bandwidth, such that:
- ω < ω*: SIREN underfits — too few periodic features to represent high-frequency signal. RLCT is low but so is capacity.
- ω > ω*: SIREN overfits — excessive periodic minima create high RLCT and poor generalization.
- ω = ω*: Optimal balance — just enough periodic features to represent signal bandwidth. λ_SIREN(ω*) is minimized subject to capacity constraint.

This parallels the spectral bias phenomenon: neural networks learn low frequencies first. In SLT terms, low ω corresponds to a simpler singularity structure (fewer periodic fibers) that gradient descent preferentially selects.

### Open Problems (8)
1. Exact λ_SIREN(ω) for single-layer vs multi-layer networks
2. Periodic Z-symmetry: does it contribute to RLCT or quotient out?
3. Multi-layer ω: interaction between ω_l across layers (composition of periodic structures)
4. Oscillatory integral computation: stationary phase with infinitely many saddles
5. SGLD empirical validation of λ_SIREN(ω) dependence
6. Connection to spectral bias: is spectral bias a singularity selection effect?
7. Initialization sensitivity: SIREN requires careful init — does this correspond to singularity basin selection?
8. Relationship to Fourier features and random Fourier features RLCT

### Cross-References
#8 (ReLU RLCT — single kink vs infinite periodic zeros), #65 (tanh/sigmoid toric fan — compact domain vs unbounded periodicity), #355 (perceptual loss — feature space singularity), #421 (Layer Scale — continuous stratum selector analogy), #433 (PolyLoss — polynomial frequency expansion), #169 (Dropout — stochastic vs deterministic stratum selection), #222 (Spectral Norm — frequency control via Lipschitz constraint)

2026-10-21 Oma