# Synthesis #607: AdaFactor × RLCT — L1 Formalization
## Date: 2026-10-25
## Status: L1 Formalization

## D1: State Space

Let W ∈ R^{m×n} be a parameter matrix. The AdaFactor state is:
  S_t = (W_t, R_t, C_t, t)
where:
  R_t ∈ R^m_≥0  : row second-moment EMA (row factor)
  C_t ∈ R^n_≥0  : column second-moment EMA (column factor)
  t ∈ N         : step counter

State space X = R^{m×n} × R^m_≥0 × R^n_≥0 × N

Contrast with #606 RMSProp: state = (W_t, v_t) with v ∈ R^d_≥0 (diagonal).
Contrast with #516 K-FAC: state = (W_t, A_t, B_t) with A ∈ R^{m×m}, B ∈ R^{n×n}.

## D2: Factored Update Map

The update map φ: X → X is:

  R_t = β_R · R_{t-1} + (1-β_R) · r_t      where r_t,i = Σ_j g_{t,ij}²
  C_t = β_C · C_{t-1} + (1-β_C) · c_t      where c_t,j = Σ_i g_{t,ij}²
  
  V_t = R_t ⊗ C_t / max(1, ||R_t ⊗ C_t|| / √d)    (normalized outer product)
  
  D_t = (V_t)^{-1/2}  (entrywise inverse sqrt with clipping)
  
  W_{t+1} = W_t - η_t · D_t ⊙ g_t
  η_t = η · max(ε_2, ||W_t||_2)              (relative step size)

This map is R_{an,exp}-definable (C1): EMA = polynomial + exp decay,
outer product = polynomial, normalization = rational, inverse sqrt = definable.

## D3: Rank-1 Preconditioner Fiber

The preconditioning metric is D = V^{-1/2} where V = R ⊗ C.
The outer product R ⊗ C has rank ≤ 1 (always rank-1 unless R=0 or C=0).

The preconditioner fiber over the loss landscape L: R^{m×n} → R is:
  Fib_φ(w) = { (R, C) ∈ R^m_≥0 × R^n_≥0 : 
                D(R,C) · ∇L(w) = 0 AND ∇L(w) ≠ 0 }

For the rank-1 outer product, the preconditioned gradient is:
  (D ⊙ g)_{ij} = g_{ij} / √(R_i · C_j / norm_factor)

Parameters (i,j) where R_i = 0 OR C_j = 0 are in the kernel — frozen.
The frozen set is the UNION of zero-row ∪ zero-column entries:
  Frozen(W) = { (i,j) : R_i < ε OR C_j < ε }

This is a GRID STRUCTURE: freezing is by rows and columns, not individual entries.
Fiber dimension: if k rows frozen and l columns frozen,
  dim(Frozen) = k·n + l·(m-k)  (union, not product)
  dim(Active) = (m-k)(n-l)

Contrast: #606 RMSProp freezes individual entries → dim(Active) = d - k.
AdaFactor: freezing k rows and l columns removes k·n + l·(m-k) parameters.
For square m=n: k frozen rows + l frozen cols removes n(k+l) - kl entries.

## D4: Dual EMA Stratum Family

The stratum family {Σ_{k,l}} is indexed by (k, l) = (frozen rows, frozen cols):
  Σ_{k,l} = { (W, R, C) : exactly k entries of R are < ε, exactly l entries of C are < ε }

The strata form a 2D lattice (not a chain like #605 Adagrad or #606 RMSProp):
  Σ_{0,0} ⊃ Σ_{1,0} ⊃ Σ_{1,1} ⊃ ... (partial order by (k,l) ≤ (k',l'))

Each stratum has dimension:
  dim(Σ_{k,l}) = (m-k)(n-l) + (m-k) + (n-l) + 1  (active params + active row/col stats + t)

The dual forgetting factors (β_R, β_C) control TRANSITION RATES between strata:
  - β_R controls row-factor freezing rate → row stratum transitions
  - β_C controls column-factor freezing rate → column stratum transitions
  - Transitions are INDEPENDENT (unlike single-EMA methods)

Prediction: optimal (β_R*, β_C*) depends on aspect ratio m/n.
  For m ≈ n: β_R* ≈ β_C* (symmetric).
  For m ≫ n: β_R* < β_C* (rows freeze faster, need shorter memory).

## D5: Generalization Bound with Factored Bias

The RLCT under rank-1 factored metric:
  G_n ≤ λ_factored · log(n) / (2n) + B_rank / √n

Where:
  λ_factored = RLCT of K(w) = L(w) under the rank-1 constrained metric D(R,C)
  B_rank = ||F - V||_F / σ_max(F)  (relative approximation error)
  F = true Fisher, V = R ⊗ C = rank-1 approximation

The rank-1 constraint means:
  - λ_factored ≤ λ_diagonal (fewer effective dimensions → smoother)
  - But B_rank ≥ B_diagonal (worse approximation than full diagonal)
  - Tension: rank-1 helps λ but hurts bias

There exists optimal rank r* for the tradeoff, but AdaFactor fixes r=1.
The bound is tightest when the true Fisher IS approximately rank-1
(spectral decay: σ_1 ≫ σ_2).

Contrast: #516 K-FAC has r = rank(A)·rank(B) (high rank, low bias, higher λ).
Contrast: #606 RMSProp diagonal has r = min(m,n) (axis-aligned, moderate both).

## D6: Dual Beta Stratum Selector

The transition dynamics between strata are governed by (β_R, β_C) independently:

  P(row i freezes by time t) ≈ 1 - exp(-t(1-β_R) · E[Σ_j g²_{ij}])
  P(col j freezes by time t) ≈ 1 - exp(-t(1-β_C) · E[Σ_i g²_{ij}])

The stationary distribution over strata {(k,l)} depends on:
  - The gradient structure (which rows/cols carry more signal)
  - The dual forgetting rates (β_R, β_C)
  - Their INTERACTION through the shared gradient g

Unlike #606 RMSProp (single γ → 1D stratum path), AdaFactor traces a 
2D TRAJECTORY through the (k,l) lattice. The path can be:
  - Diagonal: k≈l (symmetric freezing) — when β_R ≈ β_C and m ≈ n
  - Row-first: k ≫ l — when rows carry less gradient (β_R aggressive)
  - Column-first: l ≫ k — when columns carry less gradient

## D7: Phase Transition at Factor Rank Collapse

When gradient signal concentrates (late training), the row or column 
factor loses entries. The critical transition:

  t*_R: first row i where R_i(t) → 0 (row factor rank drops)
  t*_C: first column j where C_j(t) → 0 (column factor rank drops)

At t* = min(t*_R, t*_C), the factored metric dimension drops:
  Before: dim(Active) = m·n (full grid active)
  After t*_R: dim(Active) = (m-1)·n (one row frozen)

The SGLD signature:
  - Local Clustering mean: kink at t* (stratum dimension drops)
  - Direction of kink reveals whether row or column collapsed first
  - If row collapses: kink magnitude ∝ n (losing n parameters)
  - If column collapses: kink magnitude ∝ m (losing m parameters)
  - For m ≠ n: the kink is ASYMMETRIC — detectable signature

Falsifiable: if SGLD LC is smooth through t*, no phase transition in factored space.

Contrast with #606 RMSProp: no sharp transition (EMA prevents irreversible freezing).
AdaFactor: dual EMA does NOT prevent collapse — row/column sums can still reach
zero if the EMA decays faster than gradient replenishes. Whether collapse occurs
depends on the balance: (1-β)·E[g²] vs β·R_{t-1}.

## Open Formal Problems
1. Exact λ_factored for rank-1 metric on a concrete model
2. Whether the 2D stratum lattice has a product measure or coupled measure
3. Interaction of relative step size η_t = η·||W|| with factored metric
4. Whether normalization (dividing by ||V||) rescales or reshapes the fiber
5. Computation of t*_R, t*_C for specific gradient distributions
