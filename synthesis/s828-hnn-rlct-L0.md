# Synthesis #828: Hamiltonian Neural Networks × RLCT
## Date: 2026-10-30
## Level: L0 (Domain Framing)

### Motivation

Hamiltonian Neural Networks (HNNs, Greydanian et al. 2019) constrain the learned vector field to Hamiltonian structure: the dynamics satisfy dq/dt = ∂H_θ/∂p, dp/dt = -∂H_θ/∂q, where H_θ is a neural network parameterizing the Hamiltonian scalar. This symplectic constraint enforces energy conservation and phase-space volume preservation. 

From a Singular Learning Theory perspective, this constraint is fundamentally different from unconstrained Neural ODEs (#251). The symplectic structure imposes an algebraic constraint on the parameter space: not all (θ, dynamics) pairs are admissible—only those where the vector field decomposes as J∇H_θ for some scalar H_θ. This creates a constrained zero-loss set V_0 that is a submanifold of the unconstrained Neural ODE zero-loss set, potentially with different codimension, singularity structure, and RLCT.

### RLCT Bridge

1. **Constraint submanifold**: The symplectic constraint {θ : f_θ = J∇H_θ} defines an algebraic subset of parameter space. The loss function L_HNN(θ) = ||ẋ - J∇H_θ(x)||² is R_{an,exp}-definable (J is constant antisymmetric, ∇ is polynomial in network activations, H_θ is definable).

2. **Constrained zero-loss fiber**: V_0^HNN ⊂ V_0^ODE because every Hamiltonian vector field is an ODE, but not vice versa. The constraint increases codimension, potentially increasing RLCT.

3. **Energy conservation degeneracy**: On V_0^HNN, the Hamiltonian H_θ is conserved along trajectories. This creates a continuous family of solutions parametrized by energy level sets—degenerate fibers that may have higher multiplicity (lower RLCT).

4. **Symplectic gauge freedom**: The symplectic form ω provides a gauge: H → H + const, and canonical transformations preserve the dynamics but change θ. This gauge freedom is a continuous fiber on V_0.

### Key Claims

**C1 (PROVEN)**: The HNN loss L_HNN(θ) is R_{an,exp}-definable. H_θ is a feedforward network (definable), ∇H_θ is definable (gradient of definable function), J∇H_θ is definable (linear algebraic operation), and L = ||ẋ - J∇H_θ||² is definable (squared norm of definable functions). By Wilkie's theorem, the class R_{an,exp} is closed under these operations.

**C2 (CONJECTURAL)**: The HNN zero-loss set V_0^HNN is a constrained submanifold of the Neural ODE zero-loss set V_0^ODE, with codim(V_0^HNN) ≥ codim(V_0^ODE). The symplectic constraint imposes additional algebraic equations that generically increase codimension.

**C3 (CONJECTURAL)**: λ_HNN ≥ λ_ODE for the same network architecture and data. The constraint increases the effective complexity of the singularity (higher codimension → potentially higher RLCT), but energy conservation degeneracy (continuous family of energy-parametrized solutions) may partially offset this.

**C4 (CONJECTURAL)**: The generalization bound for HNNs takes the form G_HNN ≤ (λ_eff · log n)/n + U/√n where λ_eff = λ_HNN - λ_gauge accounts for the gauge freedom contribution. The optimal energy regularization strength ε* corresponds to a phase transition in RLCT: below ε* the gauge fiber dominates (overfitting to energy level sets), above ε* the constraint fiber dominates (underfitting dynamics).

**C5 (CONJECTURAL)**: There exists a critical symplectic regularity parameter (e.g., symplectic integrator step size h or number of Hamiltonian decomposition layers) at which the RLCT undergoes a phase transition. For h < h*, energy is approximately conserved and the singularity is dominated by the energy conservation degeneracy; for h > h*, symplectic structure breaks and the singularity approaches the unconstrained Neural ODE.

### Open Problems

1. Formalize the codimension relationship codim(V_0^HNN) vs codim(V_0^ODE) as an algebraic geometry problem on the constraint {f = J∇H}.
2. Quantify the gauge freedom fiber: what is the dimension of the canonical transformation group acting on V_0^HNN?
3. Prove or disprove λ_HNN ≥ λ_ODE: does the constraint increase or the degeneracy decrease the RLCT?
4. Characterize the energy conservation degeneracy: is the continuous family of energy-parametrized solutions a Morse-Bott nondegenerate critical manifold or a more singular fiber?
5. Determine the symplectic integrator step size h* phase transition empirically via SGLD on HNN training.
6. Relate HNN RLCT to symplectic integrator order (Stormer-Verlet vs higher-order): does higher-order integration create additional singular strata?
7. Contrast HNN with Lagrangian Neural Networks (LNNs): does the variational principle constraint produce a different singularity class than the symplectic constraint?

### Cross-References

#8 RLCT Foundation | #16 Generalization Bound | #25 Neural ODE | #57 Loss Landscape | #73 Definability | #86 Singularity | #92 HMC (sampling, not architecture) | #97 ODE Solver | #100 SGD | #111 Stratum | #127 Discretization | #163 Neural ODE Deep | #167 Continuous Depth | #169 ODE Integrator | #189 Flow Models | #199 Neural ODE Training | #213 Symplectic Structure | #251 Neural ODE × RLCT (primary contrast) | #302 Linear Attention | #313 Liquid Neural Networks × RLCT | #424 Neural Operator | #515 VAE | #557 Neural ODE Adaptive Solver

### Next: L1 Formalization
