# Synthesis #616: Sparsemax / Entmax × RLCT — L1 Formalization

## D1: Sparsemax Projection
Sparsemax(z) = argmin_{p ∈ Δ^K} ||p - z||² where Δ^K = {p ∈ R^K : p_i ≥ 0, Σ p_i = 1}.
Closed form: p_i = max(z_i - τ, 0) where τ = (Σ_{j∈S} z_j - 1)/|S|, S = {i : z_i > τ}.
The map z ↦ sparsemax(z) is piecewise-linear: on each chamber C_S = {z : support = S}, it is an affine projection onto the face of Δ^K corresponding to S. Chambers partition R^K into at most 2^K regions (one per support subset). Boundary ∂C_S where an index enters/leaves S: z_i = τ (threshold equality). These are semi-algebraic hypersurfaces.

Definability: piecewise-linear on semi-algebraic partition → definable in R_an.

## D2: Entmax α-Family
Entmax_α(z) = argmin_{p ∈ Δ^K} -Σ_i p_i z_i + (1/(α-1)) Σ_i p_i^α, α > 1.
- α = 1: limit → softmax(z) = exp(z_i)/Σ exp(z_j) (smooth, full support)
- α = 2: → sparsemax(z) (piecewise-linear, sparse)
- α → ∞: → argmax(z) (piecewise-constant, one-hot)
Closed form: p_i = max((α·z_i - τ_α)^{1/(α-1)} - 1, 0)^{(α-1)/α} · (α-1)^{(α-1)/α} (Martins & Astudillo 2016).
For α ∈ (1,2): p_i involves fractional powers → definable in R_{an,exp} via x^β = exp(β log x) for x > 0.
The subdifferential ∂p_i/∂z_j involves α-power terms — subanalytic for α ≥ 1 (tame geometry per van den Dries-Miller).

## D3: R_{an,exp} Structure of Sparsemax/Entmax Loss
Sparsemax loss: L_sp(z, y) = -z_y + (1/2)||sparsemax(z)||² + (1/2)||sparsemax(z) - e_y||² - 1/2.
- ||sparsemax(z)||² = Σ_i (max(z_i - τ, 0))²: polynomial on each chamber, piecewise-polynomial globally → R_an-definable.
- e_y is constant → ||sparsemax(z) - e_y||² is also piecewise-polynomial.
- Sum/difference of R_an functions → R_an.
Entmax loss: L_α(z, y) = -z_y + (1/(α-1)) Σ_i p_i^α + (1/2)(Σ p_i² - 1) (Peters et al. 2019 formulation).
- p_i^α terms: definable in R_{an,exp} for real α > 1.
- The entmax map z ↦ p is definable in R_{an,exp} (argmin of definable objective on definable set, by definable choice).
Thus L_α ∈ R_{an,exp}. By Watanabe's theorem, RLCT λ_α is well-defined for all α > 1.

## D4: Support-Change Singular Fiber
For training loss L_sp(θ) = Σ_{(x,y)} L_sp(f_θ(x), y):
Each (x,θ) defines support S(x,θ) = {i : sparsemax_i(f_θ(x)) > 0}.
Kink locus: K(x) = {θ : ∃i, sparsemax_i(f_θ(x)) = 0 and f_θ,i(x) = τ(x,θ)} — boundary where index i enters/leaves support.
Global kink locus: K = ∪_x K(x) — union over all training inputs.
On each chamber (fixed support pattern), L_sp is piecewise-smooth (composition of smooth f_θ with piecewise-linear projection). Across K, the gradient jumps (projection Jacobian rank changes).
Singular fiber: V_sp = {θ : L_sp(θ) = L_min} ⊂ R^d. Near minimizers on K, the loss is not C¹ → V_sp has singular strata Σ_k indexed by support cardinality k = |S|.
Claim: V_sp = ∪_{k=1}^{K} Σ_k ∪ (smooth part). Each Σ_k has codimension increasing in k (more constraints: k active indices each satisfying threshold equality).

## D5: α-Stratified Loss Family
Define L_α(θ) = Σ_{(x,y)} L_α(f_θ(x), y) for α ∈ [1, ∞).
- α = 1: L_1 = L_CE (cross-entropy, smooth, standard SLT fiber #8).
- α = 2: L_2 = L_sp (sparsemax, piecewise-linear, kink strata).
- α ∈ (1,2): intermediate regularity — p_i transitions from smooth to piecewise-linear. The α-power subdifferential creates a "soft kink" — continuous but with α-dependent modulus of non-smoothness.
- α → ∞: L_∞ → 0-1 loss (piecewise-constant, maximal singularity).
The family {L_α} is a deformation of the loss landscape. The singular fiber V_α = {θ : L_α(θ) = L_min} transitions:
  - α = 1: smooth fiber (codim d - rank Fisher, standard RLCT λ_CE)
  - α > 1: kink strata appear, fiber acquires singular locus
  - α → ∞: fiber becomes maximal (all θ achieving argmax correct → degenerate)
Conjecture: λ(α) is right-continuous, non-increasing. Jump at α* if phase transition exists.

## D6: Generalization Bound with Sparsity-Modified RLCT
Standard SLT bound: G(n) ≤ λ·log(n)/(2n) + U/√n + B.
For entmax at α: G_α(n) ≤ λ_α·log(n)/(2n) + U_α/√n + B_α.
- λ_α: RLCT of L_α at minimizer. Conjectured λ_α ≤ λ_CE for α > 1.
  Mechanism: each zeroed-out probability dimension removes one DOF from the local fiber, reducing effective codimension by 1. Each codim reduction ~ 1/2 reduction in λ (analogy: rank deficiency in matrix factorization reduces RLCT by (rank_deficit)/2).
- B_α: bias term. Hard support truncation (large α) discards soft probability information → B_α increases with α. At α = 1, B_1 = 0 (no truncation). At α → ∞, B_∞ → large (0-1 loss is biased estimator).
- U_α: fluctuation term. Kink boundaries create non-smooth loss → U_α may increase (discontinuous gradient complicates SGLD mixing).
Optimal α* minimizes λ_α·log(n)/(2n) + B_α (ignoring U_α which is O(1/√n)).
Testable: SGLD at various α, measure LLC ν_α. Predict ν_α monotonically non-increasing in α with possible kink at α*.

## D7: Phase Transition at Critical α*
The dominant singular fiber changes at α*:
- α < α*: full-support fiber dominates. All p_i > 0 generically. Loss is effectively smooth (α near 1). λ_α ≈ λ_CE.
- α > α*: sparse-support fiber dominates. Some p_i = 0 generically. Kink strata Σ_k active. λ_α < λ_CE.
- α = α*: phase transition. The fraction of zeroed probabilities transitions from 0 to positive. LLC ν_α shows discontinuity or kink.
α* depends on:
  - K (number of classes): larger K → more potential support truncation → lower α*.
  - Data geometry: well-separated classes → easier support truncation → lower α*.
  - Network capacity: more parameters → more room for support selection → lower α*.
Distinct from #539 Focal Loss γ*: FL modulates loss magnitude (continuous vanishing), no support change. Entmax α* changes the probability mapping itself (discrete support set change).
Distinct from #234 Temperature τ*: temperature scales logits (smooth), entmax α changes the projection geometry (non-smooth). Both can create phase transitions but via different mechanisms.
