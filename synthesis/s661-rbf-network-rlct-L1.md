# Synthesis #661: RBF Networks × RLCT — L1 Formalization

## Date: 2026-10-27
## Status: L1 FORMAL DEFINITIONS

## D1: RBF Architecture and Parameter Space

Let K be the number of RBF centers. The parameter vector:
  θ = (w_1,...,w_K, c_1,...,c_K, σ_1,...,σ_K, b) ∈ ℝ^K × ℝ^{Kd} × ℝ_{>0}^K × ℝ

The RBF network output:
  f(x; θ) = Σ_{k=1}^{K} w_k · exp(-||x - c_k||² / (2σ_k²)) + b

For classification with C classes:
  f_j(x; θ) = Σ_{k=1}^{K} w_{j,k} · exp(-||x - c_k||² / (2σ_k²)) + b_j, j=1..C

Empirical loss (regression):
  L_n(θ) = (1/n) Σ_{i=1}^{n} (f(x_i; θ) - y_i)²

Empirical loss (classification):
  L_n(θ) = -(1/n) Σ_{i=1}^{n} Σ_{j=1}^{C} y_{ij} log(softmax_j(f(x_i; θ)))

## D2: R_an,exp Definability

The RBF output f(x;θ) is definable over R_an,exp.

Proof: Each kernel term exp(-||x-c_k||²/(2σ_k²)) = exp(-Σ_{m=1}^{d} (x_m - c_{k,m})²/(2σ_k²)). Let u_k = 1/σ_k² (definable since σ_k > 0, u_k = σ_k^{-2} is analytic). Then the exponent is -(1/2) Σ_m u_k (x_m - c_{k,m})², a polynomial in (x, c_k, u_k). The exponential of a polynomial is in R_an,exp. The weight w_k is polynomial (linear). The sum Σ_k w_k · (exp-of-poly) + b is a finite composition of R_an,exp functions. For classification, softmax = exp(f_j)/Σ_j' exp(f_j') is a ratio of R_an,exp functions; cross-entropy -log(softmax_j) = -f_j + log(Σ_j' exp(f_j')), where log(Σ exp) is definable in R_an,exp (log of sum of exponentials of polynomials). By Tarski-Seidenberg, Sing(L_n) is definable. ∴ C1 PROVEN.

## D3: Singular Fiber Structure

The true parameter set Θ* = {θ : K(θ) = 0} where K(θ) = KL(q(x,y) || p(x,y;θ)) has four singular strata:

**S1: Permutation Stratum (Generic)**
The symmetric group S_K acts on θ by permuting center indices: π·(w_k, c_k, σ_k) = (w_{π(k)}, c_{π(k)}, σ_{π(k)}). This action is free on the open set where all (c_k, σ_k) are distinct. The generic fiber has dimension dim(S_K) = 0 (discrete group), but the orbit has |S_K| = K! points. The quotient Θ*/S_K is the effective parameter space.

**S2: Dead Unit Stratum**
V_dead = {θ ∈ Θ* : ∃k, w_k = 0}. When w_k = 0, the parameters (c_k, σ_k) ∈ ℝ^d × ℝ_{>0} become free — they do not affect f(x;θ). Each dead unit adds d+1 free fiber dimensions. For m dead units:
  dim(fiber on V_dead with m dead) = m(d+1)
  codim(V_dead^m) = m (one constraint w_k=0 per dead unit)
The RLCT contribution: λ_dead(m) ~ (d_free - m·codim_per_unit)/2 where d_free = m(d+1) is the free fiber dim. Since the free directions contribute RLCT = dim_free/2 (flat directions):
  λ_dead(m) = m(d+1)/2

**S3: Center Collapse Stratum**
V_collapse = {θ ∈ Θ* : c_i = c_j, σ_i = σ_j for some i≠j}. Two centers merge into one effective center with weight w_i + w_j. The constraint c_i - c_j = 0 ∈ ℝ^d and σ_i - σ_j = 0 ∈ ℝ gives codimension d+1. The merged center reduces effective K by 1. The KL near collapse:
  K(θ) ~ ||c_i - c_j||² + (σ_i - σ_j)² + higher order
This is a non-degenerate quadratic in d+1 variables, giving RLCT:
  λ_collapse = (d+1)/2 = codim/2

**S4: Bandwidth Collapse Stratum**
V_bw = {θ ∈ Θ* : σ_k → 0, w_k → 0 simultaneously}. As σ_k → 0, the Gaussian approaches δ(x - c_k). For the KL to vanish, the delta must not contribute, requiring w_k → 0. The joint limit (σ_k, w_k) → (0, 0) is a boundary singularity. The approach path parameterized by t: σ_k = t, w_k = t^α. The KL contribution:
  K_k ~ w_k² · σ_k^d = t^{2α} · t^d = t^{2α+d}
This is a one-parameter singularity with RLCT = 1/(2α+d). For generic α=1: λ_bw = 1/(d+2).

## D4: Bandwidth σ as Stratum Selector

Fix global bandwidth σ (shared across all centers): σ_k = σ ∀k. The parameter space reduces to θ_σ = (w_k, c_k, b) with σ fixed.

- σ → ∞: All kernels become broad, exp(-||x-c_k||²/(2σ²)) → 1 - ||x-c_k||²/(2σ²) + ... Centers become non-identifiable (only Σ w_k c_k matters). Center collapse stratum S3 dominates. RLCT → λ_collapse = (d+1)/2.

- σ → 0+: Kernels become narrow. Each center contributes only near c_k. If data density is low near c_k, that center is effectively dead (w_k → 0 during training). Dead unit stratum S2 dominates. RLCT → λ_dead.

- σ optimal (σ*): Centers are well-separated, each contributes to the fit. The dominant singularity is the permutation S_K (generic, minimal RLCT).

Conjecture: λ(σ) is U-shaped:
  λ(σ) → (d+1)/2 as σ → ∞ (center collapse)
  λ(σ) → K·(d+1)/2 as σ → 0 (all units dead, maximum free fiber)
  λ(σ*) = λ_perm (minimal, permutation-only)

## D5: σ-Stratified Loss Family

Define the parameterized family:
  F_RBF = { L_n^{(σ)} : σ ∈ ℝ_{>0} }

where L_n^{(σ)}(θ_σ) is the empirical loss with fixed bandwidth σ.

For each σ, the singular fiber structure changes:
- Large σ: fiber dominated by center non-identifiability (collapsed centers)
- Small σ: fiber dominated by dead units (narrow kernels miss data)
- Moderate σ: fiber dominated by permutation symmetry only

The Fisher information matrix I(θ_σ) restricted to non-degenerate directions has rank:
  rank(I) = K(d+1) + 1 - dim(fiber)

The RLCT at each σ:
  λ(σ) = (dim(Θ_σ) - rank(I))/2 + corrections

## D6: Generalization Bound with Bandwidth and Center Count

For RBF networks with K centers and global bandwidth σ:
  G_RBF(n) ≤ λ(σ, K) · log(n) / (2n) + U(σ, K) / √n

where:
- λ(σ, K) = RLCT at dominant singular stratum for (σ, K)
- U(σ, K) = complexity term from non-singular parameters

The bound predicts:
- Over-parameterized (K >> K_needed): λ_dead dominates, λ ~ m(d+1)/2 where m ≈ K - K_needed dead units. G increases with K.
- Under-parameterized (K << K_needed): center collapse forced, λ_collapse = (d+1)/2 per merged pair. G increases from poor fit.
- Optimal (K*, σ*): λ = λ_perm (minimal). G minimized.

Comparison to general ReLU networks (#8, #16): RBF provides explicit center coordinates, making λ(σ,K) computable from stratum geometry rather than requiring full resolution.

## D7: Phase Transition at Critical (K*, σ*)

There exists a critical pair (K*, σ*) where the dominant singular stratum transitions:

- K < K* (too few centers): center collapse stratum S3 dominates. Centers forced to merge, λ = (d+1)/2 per collapse event. Generalization limited by representational capacity.
- K > K* (too many centers): dead unit stratum S2 dominates. Excess centers become dead, λ = m(d+1)/2 where m = K - K*. Generalization limited by free parameters.
- K = K* (balanced): permutation stratum S1 dominates. λ = λ_perm (minimal). Optimal generalization.

σ shifts the transition:
- σ large: centers overlap, K* decreases (fewer centers needed for coverage)
- σ small: centers narrow, K* increases (more centers needed for coverage)
- σ*: optimal bandwidth matching data scale, K* minimal

Conjecture: The phase transition is testable via SGLD. Measuring the local learning coefficient (LLC) at different (K, σ) reveals:
- Sharp drop in LLC at K* (transition from dead-unit to permutation regime)
- U-shaped LLC in σ at fixed K (center-collapse vs dead-unit tradeoff)
- The transition point (K*, σ*) is where LLC is minimized

## Claims Summary
- C1 (PROVEN): R_an,exp definability of RBF loss (D2).
- C2 (CONJECTURAL): Four singular strata S1-S4 with explicit codimensions (D3).
- C3 (CONJECTURAL): σ as U-shaped stratum selector (D4-D5).
- C4 (CONJECTURAL): Generalization bound G_RBF ~ λ(σ,K)/n + U/√n (D6).
- C5 (CONJECTURAL): Phase transition at critical (K*, σ*) (D7).

## Open Problems
1. Exact RLCT of dead-unit stratum: does S_K quotient modify the resolution?
2. Center collapse vs dead unit: which stratum has lower RLCT for given (d, K)?
3. Bandwidth collapse σ→0: is λ_bw = 1/(2α+d) correct, and what is the generic α?
4. Per-center σ_k vs global σ: does allowing per-center bandwidth create additional singular strata?
5. Constructive RLCT computation: can explicit center coordinates bypass Hironaka?
6. SGLD testability: can LLC drops detect dead-unit → permutation transition empirically?
7. Comparison to kernel methods: as K→∞ with fixed σ, does RLCT predict kernel regression generalization?

## Cross-References
#8 #16 #57 #169 #371 #383 #425 #434 #505 #506 #556

## Key Novelty
RBF networks provide EXPLICIT center coordinates making singular fibers constructively accessible. Unlike general NNs (#8, #16) where singular fibers are implicit, RBF center permutation (S1), collapse (S3), dead units (S2), and bandwidth collapse (S4) give geometrically explicit singular strata with computable codimensions. This makes RBF a constructive testbed for RLCT computation methods — the first architecture where all singular strata can be geometrically visualized.
