# Synthesis #829: Test-Time Training (TTT) × RLCT — L1 Formalization
# Date: 2026-11-03
# Status: L1 DRAFT

## Definitions

**D1 (Inner Model)**: Let W ∈ R^{d×d} (TTT-Linear) or W parametrizing a 2-layer MLP (TTT-MLP). W serves as the hidden state, updated at inference time. The outer parameters are θ = (W_0, φ) where W_0 is the initialization and φ are projection head parameters.

**D2 (Inner Loss)**: The self-supervised inner loss ℓ_inner: R^{d×d} × R^d → R is real-analytic in (W, x). For TTT-Linear, ℓ_inner(W; x) = ||Wx - x||² (reconstruction loss). This is a polynomial in (W, x), hence real-analytic.

**D3 (Gradient Step Operator)**: Define G_η(W, x) = W - η ∇_W ℓ_inner(W; x). Since ℓ_inner is real-analytic, ∇_W ℓ_inner is real-analytic (derivative of analytic is analytic), so G_η is real-analytic in (W, x, η).

**D4 (Outer Loss)**: The outer loss ℓ_outer: R^{d×d} × R^d × R^d → R maps (W, x, y) to a prediction loss, e.g., cross-entropy. Assume ℓ_outer is R_{an,exp}-definable (satisfied by softmax cross-entropy).

**D5 (Bilevel Composite)**: The TTT loss for a single input (x, y) is:
  L_TTT(θ; x, y) = ℓ_outer(G_η^T(W_0, x), φ; x, y)
where G_η^T denotes T-fold composition of G_η(·, x). The empirical loss is L_n(θ) = (1/n) Σ_i L_TTT(θ; x_i, y_i).

**D6 (Data-Dependent Singular Fiber)**: For each input x, define the singular fiber:
  V_x = {θ ∈ Θ : L_TTT(θ; x, y) = 0}
Unlike standard models, V_x depends on x through the inner loop trajectory G_η^T(W_0, x).

**D7 (Stratum Selector)**: The pair (T, η) determines the geometry of V_x. For fixed η, increasing T moves W_T further from W_0 along the inner loss gradient, changing the effective loss landscape. The map (T, η) → (geometry of V_x) acts as a stratum selector analogous to resolution of singularities in algebraic geometry.

## C1 Proof Sketch (R_{an,exp}-Definability)

**Claim**: L_TTT(θ; x, y) is R_{an,exp}-definable when ℓ_inner and ℓ_outer are real-analytic.

**Proof**:
1. ℓ_inner(W; x) is real-analytic in (W, x) → ∇_W ℓ_inner is real-analytic (analytic functions are closed under differentiation).
2. G_η(W, x) = W - η ∇_W ℓ_inner(W, x) is real-analytic in (W, x, η).
3. Composition of real-analytic functions is real-analytic: G_η^T(W_0, x) = G_η(G_η(...G_η(W_0, x)...), x) is real-analytic in (W_0, x, η) for fixed T.
4. ℓ_outer(W_T, φ; x, y) composed with G_η^T is real-analytic in (W_0, φ, x, y, η).
5. Real-analytic functions are R_{an,exp}-definable (they belong to the class of restricted analytic functions).
6. Sum L_n(θ) = (1/n) Σ_i L_TTT(θ; x_i, y_i) preserves definability.
7. Therefore RLCT λ = lim_{t→∞} -t^{-1} log Θ_X(t) is well-defined by Watanabe's theorem. ∎

## C2-C5 Formal Statements

**C2**: λ_TTT(T, η) is a function of inner loop hyperparameters. For T₁ < T₂, the singular fiber V_x^{T₂} ⊆ V_x^{T₁} is not guaranteed — instead the fiber geometry changes non-monotonically. Conjecture: λ_TTT(T, η) ≥ λ_fixed for small T (insufficient adaptation) and λ_TTT(T, η) < λ_fixed for moderate T (desingularization via trajectory projection).

**C3**: The Jacobian J = ∂G_η^T/∂W_0 = Π_{t=1}^{T} [I - η ∇²_W ℓ_inner(W_{t-1}; x)] is a product of (I - η H_t) matrices. When H_t has eigenvalues λ_j(H_t) ≈ 1/η, the corresponding factor (1 - ηλ_j) ≈ 0, creating singular directions in the bilevel Jacobian. These are flat-direction singularities of the inner loss.

**C4**: For TTT-Linear with ℓ_inner = ||Wx - x||², the inner loss is quadratic in W. The gradient step G_η moves W along data-dependent directions, effectively projecting out flat directions of the outer loss that align with the inner loss gradient. This removes singular directions, yielding λ_TTT-Linear ≤ λ_standard.

**C5**: Define LLC(T) = E[SGLD energy at equilibrium with T inner steps]. Conjecture: LLC(T) shows a phase transition at T* ~ n^{1/(λ+1)}: below T*, LLC increases with T (more adaptation explores more of the fiber); above T*, LLC plateaus or increases (overfitting creates new singular fibers).

## Open Problems
1. Exact λ computation for TTT-Linear with squared-error inner loss (quadratic composition)
2. Continuity of V_x in x: is the map x → V_x continuous in an appropriate topology on fibers?
3. Hessian product chain singularity: characterize when Π(I - η H_t) becomes rank-deficient
4. SGLD LLC measurement protocol for TTT: how to disentangle inner-loop adaptation from outer-loop training in LLC estimation
5. MAML/Reptile RLCT: does the bilevel structure create similar data-dependent fibers?
6. TTT-MLP: does the inner MLP's ReLU nonlinearity create additional piecewise-analytic singular fibers?
7. Sequence dependence: for autoregressive TTT, does V_x depend on the full sequence {x_1,...,x_t} or just x_t?

## Cross-References
#825 (Titans neural memory), #554 (Mamba SSM), #169 (curriculum learning), #219 (GELU), #323 (weight decay desingularization), #428 (bi-level optimization), #480 (muP), #501 (weight tying)