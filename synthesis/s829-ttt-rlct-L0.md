# Synthesis #829: Test-Time Training (TTT) × RLCT — L0 Architecture & Claims
# Date: 2026-11-03
# Status: L0 DRAFT

## Architecture: Test-Time Training (TTT)

TTT (Sun et al., 2024) replaces the fixed hidden state of RNNs with an inner model W updated via gradient descent at inference time.

- **Inner model**: Parameters W (linear matrix or MLP) serving as hidden state
- **Inner loop**: At each input x_t, perform T gradient steps on self-supervised inner loss:
  W_t = W_{t-1} - η ∇_W ℓ_inner(W_{t-1}; x_t)
- **Outer loss**: After T inner steps, use W_T for output: ŷ_t = f_outer(W_T; x_t)
- **Outer loop**: Outer params (W_0 init, projection heads) trained end-to-end via backprop through inner loop

Variants: TTT-Linear (W ∈ R^{d×d}), TTT-MLP (2-layer MLP).

## RLCT Bridge

1. **Data-dependent singular fibers**: Zero-loss set V(θ) = {w : ℓ_outer(w; x) = 0} shifts with each input x_t because W_T is a function of x_t via inner loop. Input-conditioned singularity not present in fixed-parameter models.

2. **Inner loop as stratum selector**: Step count T and learning rate η determine how far W moves from W_0. Different (T, η) regimes create different effective loss landscapes — stratum selection analogy. Inner loop trajectory traces data-dependent path through parameter space.

3. **Bilevel optimization singularity**: Outer loss L_outer(f(W_T(x)), y) where W_T depends on W_0 through T gradient steps. Jacobian of W_T w.r.t. W_0 involves Hessian product chains (∂²ℓ_inner/∂W²), singular when inner loss has flat directions.

4. **Meta-learning connection**: TTT is bi-level optimization. RLCT of bi-level objectives unstudied. Effective parameter space {W_0, φ} shaped by inner loop dynamics.

## Claims

- **C1 (Provable)**: TTT outer loss is R_{an,exp}-definable when inner and outer losses are real-analytic. Gradient step operator preserves analyticity. RLCT well-defined.

- **C2 (Conjectural)**: Data-dependent singular fiber creates richer singularity structure. Effective RLCT λ_TTT depends on (T, η), with larger T creating more complex singular fibers.

- **C3 (Conjectural)**: Bilevel Jacobian singularity introduces singularities at points where ∇²ℓ_inner is rank-deficient, creating additional singular fibers in outer parameter space.

- **C4 (Conjectural)**: TTT-Linear has λ_TTT-Linear ≤ λ_standard-RNN because inner-loop adaptation desingularizes by projecting loss landscape along trajectories, removing flat directions.

- **C5 (Conjectural)**: Optimal inner step count T* corresponds to phase transition in effective RLCT: T < T* underfitting, T > T* overfitting/memorization. Detectable via SGLD LLC.

## Cross-References
#825 (Titans neural memory), #554 (Mamba SSM), #169 (curriculum learning), #219 (GELU), #323 (weight decay desingularization), #428 (bi-level optimization), #480 (muP), #501 (weight tying)

## Open Problems
1. Formal RLCT computation for TTT-Linear with squared-error inner loss
2. Data-dependent singular fiber: does fiber vary continuously with input x?
3. Bilevel Jacobian: when does Hessian product chain become singular?
4. T* phase transition: SGLD LLC measurement across T values
5. Connection to meta-learning RLCT (MAML, Reptile)
6. TTT-MLP vs TTT-Linear: does deeper inner model create more singular fibers?
7. Sequence dependence: does singular fiber depend on full sequence or just current input?
