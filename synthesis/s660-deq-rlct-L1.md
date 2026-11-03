# Synthesis #660: Deep Equilibrium Models × RLCT — L1 Formalization

**Date:** 2026-10-27
**Status:** L1 Formalization

## Definitions

**D1 (Fixed-Point Variety).** Given input x ∈ R^{d_in}, the DEQ forward pass
finds z* ∈ R^{d_h} satisfying the equilibrium condition:
    g(z, θ, x) := z - f_θ(z, x) = 0
where f_θ: R^{d_h} × R^{d_in} → R^{d_h} is a single transformation (e.g., a
weight-tied residual block). The **fixed-point variety** is:
    V_θ(x) = { z ∈ R^{d_h} : g(z, θ, x) = 0 }
The loss is L(θ) = (1/n) Σ_i ℓ(g_φ(z*_i(θ), x_i), y_i) where z*_i is the
fixed point for sample i.

**D2 (Singular Locus).** The **singular locus** of the fixed-point variety is:
    S_θ(x) = { z ∈ V_θ(x) : det(I - J_{f_θ}(z, x)) = 0 }
where J_{f_θ} = ∂f_θ/∂z ∈ R^{d_h × d_h}. Points in S_θ are non-hyperbolic
fixed points where the implicit function theorem fails to guarantee local
uniqueness and smoothness of z*(θ).

**D3 (Damping Family).** The **damped iteration** is:
    f_α(z, x) = (1-α)z + α f_θ(z, x),  α ∈ (0, 1]
The fixed-point condition becomes: z = (1-α)z + α f_θ(z, x), equivalent to
z = f_θ(z, x) for all α > 0. However, the convergence dynamics depend on α.
The **spectral radius** of the damped Jacobian:
    ρ_α(z) = ρ((1-α)I + α J_{f_θ}(z, x))
determines contraction. The critical stratum is where ρ_α = 1.

**D4 (Implicit Depth).** The **effective depth** of a DEQ is:
    T_eff(θ, x) = min{ k : ||z_k - z_{k-1}|| < ε }
where z_k is the k-th iterate of the root-finding algorithm. This is a
data- and parameter-dependent quantity, not a fixed hyperparameter.

**D5 (DEQ Parameter Space).** The DEQ parameter space Θ_DEQ has dimension:
    d_DEQ = dim(θ) + dim(φ)
where θ parameterizes the shared block f_θ and φ the readout g_φ. Unlike
an explicit L-layer weight-tied network (same f_θ applied L times), the
DEQ has the SAME d_DEQ but uses implicit depth T_eff → ∞.

**D6 (Anderson Acceleration).** Anderson acceleration maintains a history
of m iterates {z_{k-m}, ..., z_k} and computes:
    z_{k+1} = (1-γ) Σ_j β_j z_{k-j} + γ Σ_j β_j f_θ(z_{k-j})
where β minimizes ||Σ β_j (z_{k-j} - f_θ(z_{k-j}))||. This is a rational
function of the evaluation history, introducing additional nonlinearity
beyond the fixed-point map itself.

**D7 (Loss Landscape Fiber).** The fiber of the DEQ loss landscape at a
parameter θ_0 is:
    W(θ_0) = { θ : L(θ) = L(θ_0) }
containing all parameters achieving the same loss. The singular fiber
structure arises from: (a) permutation symmetries in f_θ (neuron
permutations), (b) the fixed-point variety degeneracy (multiple z*
mapping to same output), (c) weight-tying identification (shared θ
across implicit layers).

## Claim Formalization

### C1 (PROVEN): R_an,exp Definability

**Statement.** The DEQ loss landscape L(θ) is definable over R_an,exp.

**Proof Sketch.**
1. f_θ is a composition of linear maps and ReLU (or analytic) activations,
   hence definable in R_an,exp (subanalytic for ReLU, analytic for
   smooth activations).
2. The fixed-point z*(θ, x) is the limit of the iteration z_{k+1} =
   f_θ(z_k, x). Where det(I - J_f) ≠ 0, z* is locally analytic by the
   implicit function theorem (IFT), hence definable.
3. Where det(I - J_f) = 0, z* is the limit of a subanalytic sequence.
   By Wilkie's theorem (o-minimal closure of R_an,exp under
   projection/limit), z* is definable at singular points as well.
4. For Anderson acceleration: the mixing coefficients β_j are rational
   functions of evaluations of f_θ (solving a least-squares problem),
   hence definable. The iterates are compositions of definable maps.
5. The loss ℓ(g_φ(z*(θ), x), y) is a composition of definable functions
   (cross-entropy, MSE, etc. are all definable in R_an,exp).
6. Therefore L(θ) is R_an,exp definable. □

### C2 (CONJECTURAL): Fixed-Point Singular Variety

**Statement.** For generic θ, the singular locus S_θ(x) is non-empty,
and the RLCT at points in S_θ satisfies λ_S > dim(V_θ)/2.

**Formal Argument.**
- det(I - J_{f_θ}) is a polynomial in z (for linear+ReLU f_θ, it is
  piecewise polynomial). Its zero set is a codimension-1 algebraic
  hypersurface in R^{d_h} (generically).
- At z ∈ S_θ, the fixed-point variety V_θ transitions from a smooth
  manifold (codim d_h in R^{d_h} generically, i.e., isolated points)
  to a singular variety with multiplicity.
- When det(I - J_f) vanishes to order k at z_0 ∈ S_θ, the local RLCT
  contribution is conjectured to be:
      λ_local = dim(V)/2 + (k-1)/2
  by analogy with the algebraic singularity formula (codim + multiplicity).
- The total RLCT λ_DEQ = max over fibers of the local RLCT, capturing
  the worst-case singularity.

**Key Gap.** The exact RLCT computation for the fixed-point variety
requires resolution of singularities of the ideal (g, det(I-J_f)),
which is generically a complete intersection. The RLCT of a complete
intersection singularity is known in some cases (ADE classification)
but not in general for high-dimensional fixed-point maps.

### C3 (CONJECTURAL): Damping Factor as Stratum Selector

**Statement.** The damping factor α acts as a stratum selector: λ(α)
is a function of α with a critical value α* where λ(α*) > λ(0) and
λ(α*) > λ(1).

**Formal Argument.**
- At α = 0: f_α = identity, every z is a fixed point, V_θ = R^{d_h}.
  The variety is maximally degenerate (full space, no constraint).
  Loss is constant in z, so L(θ) depends only on g_φ(0, x).
  λ(0) = d_φ/2 (only readout parameters contribute).
- At α = 1: f_α = f_θ, the full DEQ. The variety V_θ is generically
  discrete (isolated fixed points). λ(1) = λ_DEQ as in C2.
- At intermediate α: the spectral radius ρ_α = ρ((1-α)I + αJ_f)
  crosses 1 at α* = 2/(1 + ρ(J_f)) (for real eigenvalues). At this
  crossing, the fixed-point variety bifurcates, creating a singular
  stratum.
- The RLCT λ(α) is conjectured to be U-shaped: regular at α=0 (trivial),
  singular at α* (bifurcation), regular at α=1 (if contraction holds).

**Key Gap.** The U-shape conjecture requires proving that the
bifurcation at α* creates the unique maximal singularity, and that
no other singular strata exist for α ∈ (0,1).

### C4 (CONJECTURAL): Generalization Bound

**Statement.** The DEQ generalization gap satisfies:
    G_DEQ ≤ (λ_DEQ / (2n)) * log(n) + U(T_eff)/n

where U(T_eff) captures root-finding approximation error.

**Formal Argument.**
- By the standard SLT bound (Watanabe 2009): G ≤ (λ/n) * log(n) + O(1/n).
- For DEQ, the effective complexity is λ_DEQ, not d_DEQ/2 (which would
  be the regular case). The implicit depth does not increase the
  parameter count, so the bound depends on λ_DEQ ∈ [d_DEQ/2, d_DEQ].
- The root-finding error: if the solver stops at ||z_K - z*|| < ε,
  the loss perturbation is O(ε * ||J_g|| * ||J_{z*}||), bounded by
  U(ε) = C * ε for well-conditioned problems.
- Compared to explicit depth-L weight-tied network: λ_explicit ~ L * λ_0
  (conjectured in #568), while λ_DEQ ≤ λ_explicit because the
  equilibrium constraint concentrates singularities (weight tying
  removes L-fold non-identifiability).

**Key Gap.** Proving λ_DEQ ≤ λ_explicit requires showing that the
equilibrium constraint is more restrictive than explicit depth-L
composition, concentrating the singular fibers.

### C5 (CONJECTURAL): Convergence Basin Phase Transition

**Statement.** The spectral radius ρ(J_{f_θ}) controls a phase transition
in the RLCT: ρ < 1 gives λ ≈ d/2, ρ = 1 gives λ > d/2, ρ > 1 gives
training instability.

**Formal Argument.**
- ρ < 1 (contraction): By Banach fixed-point theorem, unique fixed
  point, IFT applies globally, z*(θ) is smooth in θ. Loss landscape
  is locally regular. λ ≈ d_DEQ/2.
- ρ = 1 (bifurcation): The fixed point loses hyperbolicity. The
  implicit function theorem fails. The local geometry of z*(θ)
  transitions from smooth to singular. This is a codimension-1
  phenomenon in θ-space (one condition: ρ = 1).
- ρ > 1 (instability): Multiple fixed points or no fixed point. The
  loss landscape develops high-multiplicity singularities. Training
  may not converge or may oscillate between fixed points.
- During training: early θ has large weights → large ρ → singular,
  exploratory. Late θ has regularized weights → small ρ → regular,
  stable. This mirrors the exploration→exploitation transition.

**Key Gap.** The phase transition at ρ = 1 needs to be formalized as
a bifurcation in the parameter space Θ, not just in the activation
space R^{d_h}. The codimension of the ρ = 1 stratum in Θ-space
determines the RLCT contribution.

## Open Problems (from L0, refined)

1. **Anderson acceleration singularity**: Does the rational mixing in
   Anderson acceleration create singularities distinct from the
   fixed-point variety? The mixing coefficients β_j solve a
   least-squares problem whose normal matrix can be rank-deficient.

2. **Jacobian determinant order and RLCT**: If det(I - J_f) vanishes
   to order k at z_0, is λ_local = dim(V)/2 + (k-1)/2? This follows
   the ADE pattern for hypersurface singularities but needs
   verification for fixed-point varieties.

3. **Multi-equilibrium fiber structure**: With multiple fixed points
   z*_1, ..., z*_m, the fiber W(θ) contains multiple components.
   Is the total RLCT the max or sum of per-equilibrium RLCTs?

4. **DEQ vs explicit depth RLCT**: Formal proof that λ_DEQ ≤
   λ_explicit(L) for equivalent functional capacity. Key: weight
   tying removes L-fold permutation non-identifiability, but the
   equilibrium constraint may introduce new singularities.

5. **Monotone operator regularity**: For monotone f_θ (I - J_f ≻ 0),
   the variety is always regular. Is λ = d/2 exactly? Or can
   monotonicity still have singular fibers from other symmetries?

6. **Stochastic DEQ regularization**: Noise z_{k+1} = f_θ(z_k) + ε_k
   creates a distribution over fixed points. Does this smooth
   singularities as SGLD does (#199)?

7. **Effective depth-RLCT relationship**: Is T_eff related to λ
   as L is to λ in #568? Conjecture: λ_DEQ ~ λ_0 * log(T_eff) rather
   than λ_0 * T_eff, because the equilibrium concentrates singularities
   logarithmically.

## Cross-References (from L0, confirmed)

- #251 Neural ODE × RLCT — continuous flow, IFT for ODE solution
- #568 ResNet × RLCT — explicit depth, λ ~ L * λ_0
- #557 Mamba/SSM × RLCT — sequential scan, input-dependent dynamics
- #163 Normalizing Flow × RLCT — bijective, regular (λ = d/2)
- #515 Weight-tied Networks × RLCT — shared weights, explicit depth
- #465 Kaiming Init × RLCT — scale as stratum selector
- #606 RMSProp × RLCT — γ as stratum selector
- #199 SGLD × RLCT — stochastic regularization
- #562 Stochastic Depth × RLCT — layer dropping vs equilibrium
- #485 RNN × RLCT — recurrence vs fixed point
