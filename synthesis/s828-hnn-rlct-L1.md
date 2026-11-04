# Synthesis #828: Hamiltonian Neural Networks × RLCT
## Level: L1 (Formalization)
## Date: 2026-10-30

### Definitions

**D1 (Phase Space & Hamiltonian Network)**
Let the phase space be M = R^{2d} with coordinates x = (q, p) where q, p ∈ R^d. The Hamiltonian H_θ: M → R is a feedforward neural network with parameters θ ∈ Θ ⊂ R^D. The symplectic matrix J = [[0, I_d], [-I_d, 0]] ∈ R^{2d×2d} is constant and antisymmetric (J^T = -J, J^2 = -I). The HNN dynamics are:
  ẋ = f_θ(x) = J ∇_x H_θ(x)

The HNN loss over training data {(x_i, ẋ_i)}_{i=1}^n is:
  L_HNN(θ) = (1/n) Σ_i ||ẋ_i - J ∇_x H_θ(x_i)||²

**D2 (Symplectic Constraint Fiber)**
Define the symplectic constraint set:
  C_sym = {θ ∈ Θ : f_θ decomposes as J∇H_θ for some scalar H_θ}
The HNN zero-loss set:
  V_0^HNN = {θ ∈ C_sym : L_HNN(θ) = 0}
By construction, V_0^HNN ⊆ V_0^ODE where V_0^ODE is the unconstrained Neural ODE zero-loss set (#251). The constraint C_sym is an algebraic subset defined by the condition that the vector field (ẋ₁,...,ẋ_{2d}) satisfies the integrability conditions: ∂f_j/∂x_i = -∂f_i/∂x_j for all (i,j) in the symplectic pairing (i.e., ∂²H/∂q_k∂p_l = ∂²H/∂p_l∂q_k, etc.).

**D3 (Energy Conservation Degeneracy)**
On V_0^HNN, the Hamiltonian H_θ is conserved along trajectories: dH_θ/dt = ∇H_θ^T · ẋ = ∇H_θ^T · J ∇H_θ = 0 (since J is antisymmetric). This means for each energy level E, the sub-level set {x : H_θ(x) = E} is invariant. The fiber over a given dynamics includes a continuous family parametrized by the energy function's level sets. Define:
  V_0^HNN(E) = {θ ∈ V_0^HNN : H_θ|_{trajectories} = E}
This is a potentially Morse-Bott nondegenerate critical submanifold if the energy level sets are smooth.

**D4 (Symplectic Gauge Fiber)**
The symplectic gauge group G_sym consists of:
  (a) Additive constant: H → H + c (c ∈ R), dimension 1
  (b) Canonical transformations: (q,p) → (Q(q,p), P(q,p)) preserving ω = dq∧dp, dimension dim(Sp(2d)) = d(2d+1)
The total gauge fiber dimension is d_gauge = 1 + d(2d+1). This acts freely on V_0^HNN, creating a continuous degeneracy that reduces the effective RLCT:
  λ_eff = λ_HNN - λ_gauge
where λ_gauge accounts for the gauge orbit dimension contribution.

**D5 (Stratum Selector: Symplectic Integrator Step)**
The symplectic integrator step size h ∈ (0, h_max] discretizes the HNN dynamics. For Stormer-Verlet:
  q_{k+1} = q_k + h ∂H_θ/∂p(q_k, p_{k+1/2})
  p_{k+1} = p_k - h ∂H_θ/∂q(q_{k+1}, p_{k+1/2})
The discretized loss L_HNN^h(θ) depends on h. The parameter h acts as a stratum selector: for different h, the zero-loss geometry V_0^HNN(h) changes. Define the RLCT as a function λ(h).

**D6 (Generalization Bound)**
The HNN generalization bound:
  G_HNN ≤ (λ_eff · log n) / n + U / √n
where:
  λ_eff = λ_HNN - λ_gauge
  λ_HNN = RLCT of (L_HNN, V_0^HNN, φ)
  λ_gauge = gauge orbit correction from D4
  U = bounded loss term (Hilbert-Schmidt norm of J∇H_θ)
This modifies the standard SLT bound (#16) by subtracting the gauge contribution, reflecting that symplectic symmetry reduces effective complexity.

**D7 (Phase Transition Parameter)**
The critical symplectic regularity h* is defined by:
  h* = inf{h : λ(h) > λ_eff + ε} for small ε > 0
Below h*: the singularity is dominated by energy conservation degeneracy (Morse-Bott fiber, lower λ). Above h*: symplectic structure breaks, λ → λ_ODE (unconstrained). The phase transition in λ(h) is testable via SGLD: measure local RLCT estimate λ̂(h) across step sizes.

### Formal Claims

**C1 (PROVEN):** L_HNN(θ) is R_{an,exp}-definable.
*Proof:* H_θ is a feedforward network → definable in R_{an,exp} (#73). ∇_x H_θ involves partial derivatives of definable functions → definable (R_{an,exp} closed under differentiation on definable domains). J is a constant matrix → trivially definable. J∇_x H_θ is a linear combination of definable functions → definable. ||ẋ - J∇H_θ||² is a sum of squares of definable functions → definable. (1/n)Σ is a finite sum → definable. By Wilkie's theorem, R_{an,exp} is closed under all these operations. ∎

**C2 (CONJECTURAL):** V_0^HNN is a constrained submanifold of V_0^ODE with codim(V_0^HNN) ≥ codim(V_0^ODE).
*Justification:* The symplectic constraint C_sym requires the integrability conditions ∂f_j/∂x_i + ∂f_i/∂x_j = 0 for symplectic pairs (i,j). These are additional algebraic equations beyond the ODE constraint. Generically, each independent constraint equation increases codimension by 1. The number of independent integrability conditions is d(2d-1) (the dimension of the complement of Sp(2d) in GL(2d)).

**C3 (CONJECTURAL):** λ_HNN ≥ λ_ODE (with possible offset from energy degeneracy).
*Justification:* Higher codimension of V_0^HNN suggests higher RLCT (more constraints → more singular). However, the energy conservation degeneracy (D3) and gauge freedom (D4) create continuous families that may reduce the effective singularity. The net effect depends on whether codim increase dominates gauge fiber dimension.

**C4 (CONJECTURAL):** G_HNN ≤ (λ_eff · log n)/n + U/√n with λ_eff = λ_HNN - λ_gauge.
*Justification:* Standard SLT bound applies with the constrained RLCT. The gauge group acts freely on V_0^HNN, so the effective singularity is the quotient V_0^HNN / G_sym. The RLCT of the quotient is λ_eff. The energy regularization ε controls which stratum dominates.

**C5 (CONJECTURAL):** There exists h* such that λ(h) undergoes a phase transition at h*.
*Justification:* For small h, Stormer-Verlet preserves energy to O(h²), so the dynamics stays on energy level sets — the Morse-Bott degeneracy dominates. For large h, energy drift breaks the conservation, and the constraint C_sym effectively weakens, approaching V_0^ODE. The transition is analogous to #127 (discretization) but specific to symplectic structure.

### Open Problems (Refined)

1. Compute the exact codimension: codim(V_0^HNN) = codim(V_0^ODE) + d(2d-1)? (The d(2d-1) counts independent integrability conditions.)
2. Is the energy conservation fiber Morse-Bott? Requires checking nondegeneracy of the Hessian of L restricted to energy level sets.
3. Compute λ_gauge precisely: is it d_gauge/2 or something else? (Depends on the singularity type of the gauge orbit.)
4. SGLD testable: estimate λ̂(h) for varying h and check for phase transition at h*.
5. Higher-order symplectic integrators (Yoshida 4th order): do they create additional singular strata or just shift h*?
6. LNN (Lagrangian NN) comparison: does the Euler-Lagrange constraint produce a different fiber than the symplectic constraint? (Variational vs. symplectic.)
7. Port-Hamiltonian NNs (dissipative extension): does adding dissipation D(x) break the energy conservation degeneracy, and how does this change λ?

### Cross-References
#8 RLCT | #16 Gen Bound | #25 Neural ODE | #57 Loss Landscape | #73 Definability | #86 Singularity | #92 HMC | #97 ODE Solver | #100 SGD | #111 Stratum | #127 Discretization | #163 Neural ODE Deep | #167 Continuous Depth | #169 ODE Integrator | #189 Flow Models | #199 Neural ODE Training | #213 Symplectic | #251 Neural ODE × RLCT | #302 Linear Attention | #313 Liquid NN | #424 Neural Operator | #515 VAE | #557 Neural ODE Adaptive

### Next: L2 Novelty Verification
