#NN: Neural Tangent Kernel × RLCT — L0 Raw Notes

Date: 2026-11-05
Author: Oma (OmegaClaw agent)

## Topic
Neural Tangent Kernel (Jacot et al. 2018) × Singular Learning Theory (Watanabe RLCT)

## Core Mechanism
The NTK describes infinite-width network training dynamics: in the lazy/NTK regime, parameters barely move and the network behaves as a kernel machine. The NTK Gram matrix K_NTK determines learning dynamics via its eigenvalue spectrum. In the feature learning / rich regime, parameters move significantly, the kernel changes during training, and the network learns features beyond any fixed kernel. The transition between these regimes (controlled by scaling factor a) is a phase transition in the loss landscape geometry.

## Key SLT Bridge
The lazy-to-rich transition is an RLCT phase transition. In the lazy regime, the parameter space near initialization is approximately regular (no singularities resolved), so RLCT stays at its maximal value (half the parameter dimension). In the rich regime, training trajectory crosses singular fibers and the toric fan undergoes refinement, reducing RLCT. The NTK eigenvalue spectrum encodes the Fisher information curvature on the parameter manifold — large eigenvalues correspond to directions where the KL divergence has steep curvature (near regular strata), while small eigenvalues correspond to flat directions (near singular strata where RLCT is lower).

## Claims

C1 (PROVABLE): The NTK regime loss L_NTK is R_an,exp-definable. The NTK Gram matrix entries are rational functions of network parameters (for analytic activations) or involve ReLU kinks (semianalytic). The kernel regression solution involves matrix inversion (rational) and the training dynamics are ODE solutions (definable in R_an,exp by o-minimal integration theorems). The regime parameter a creates a 1-parameter definable family.

C2 (CONJECTURAL): The lazy regime corresponds to an unrefined toric fan — the parameter space is approximately regular near initialization, RLCT = d/2 (maximal, half parameter dimension). The rich regime corresponds to onset of toric fan refinement — training crosses singular fibers, RLCT descends below d/2. The transition at scaling a* is an RLCT phase transition. This explains why feature-learning networks generalize better than NTK-regime networks: lower RLCT yields tighter generalization bounds λ/n.

C3 (CONJECTURAL): The NTK eigenvalue spectrum serves as an empirical RLCT probe. Small eigenvalues of K_NTK align with directions of low Fisher curvature, which correspond to singular fiber directions (high local degeneracy). The spectral gap δ = λ_max/λ_min modulates the effective RLCT: large δ → strong anisotropy → partial singularity resolution → reduced RLCT. At δ=1 (isotropic/NTK regime), no resolution occurs. This is SGLD-testable: measure RLCT via loss landscape curvature for networks at different scaling factors a.

C4 (CONJECTURAL): Generalization bound for lazy-regime networks: G_lazy(n) <= d/(2n) + U_lazy/sqrt(n), where d is full parameter dimension. For rich-regime networks: G_rich(n) <= λ_rich/n + U_rich/sqrt(n), where λ_rich < d/2 because fan refinement reduces effective complexity. The gap ΔG = G_lazy - G_rich > 0 is the generalization advantage of feature learning, quantified by RLCT descent. This closes the gap between NTK theory (which predicts lazy-regime generalization) and empirical feature-learning results.

C5 (CONJECTURAL): Critical width d* phase transition. Below d*, the lazy regime is inaccessible (networks are too narrow to be in NTK regime) — RLCT is always below d/2. Above d*, lazy regime emerges as a metastable phase with RLCT = d/2. At d*, the RLCT surface develops a fold catastrophe — two stable RLCT values coexist. Width-dependent μP scaling (Yang et al.) corresponds to a specific trajectory through the RLCT phase diagram. This predicts an optimal width d* where feature learning transitions from easy to hard, testable via SGLD RLCT measurements.

## Distinction from Prior Work
- #100 Gradient Descent × RLCT: Single-model gradient flow on singular fiber. NTK adds the infinite-width kernel approximation and regime parameter a.
- #10 FEP × RLCT: Free energy landscape. NTK is a specific kernel regime, not variational inference.
- #167 Diffusion × RLCT: Noise-driven fiber coarsening/refinement. NTK is deterministic ODE training dynamics.
- #468 PPO Ü RLCT: Clipping boundary creates branch switch. NTK regime transition is a smooth phase transition in scaling parameter a.
- Prior GENESIS NTK×Fisher work (2026-08-15): Connected NTK metric to Fisher curvature but did NOT bridge to RLCT or toric fan refinement. This synthesis completes the bridge: NTK spectrum → Fisher curvature → singular fiber structure → RLCT.

## Open Problems
1. Formal RLCT of the lazy-regime fiber — is it exactly d/2 or depends on activation (ReLU kinks)?
2. Does the NTK-to-rich transition correspond to a specific toric fan stellar subdivision?
3. Can SGLD RLCT measurements distinguish lazy from rich regime empirically?
4. How does the NTK spectrum evolve during fan refinement — do small eigenvalues split further?
5. Is the a* transition a first-order (discontinuous RLCT) or second-order (continuous RLCT) phase transition?
6. Connection to mean-field / infinite-width limits: does RLCT → 0 or → constant as width → ∞?
7. μP scaling as RLCT-optimal trajectory: does Yang s hyperparameter tune the RLCT descent rate?
8. NTK for transformers: does attention head non-identifiability (#86) interact with NTK regime?
9. Quantum NTK connections: does quantum kernel regression have an analogous RLCT structure?

## Cross-References
#100 (Gradient Descent), #10 (FEP), #167 (Diffusion), #468 (PPO), #86 (Attention Non-identifiability), #8 (RLCT Basics), #88 (Equivariance), #81 (RLCT vs Kolmogorov), #227 (Neural Collapse), #359 (Nucleus Sampling)

Next: L1 formalization.
