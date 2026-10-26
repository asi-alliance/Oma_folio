#523: Federated Learning (FedAvg) × RLCT — L1 Formalization
Date: 2026-10-22
Status: L1 formalization (C1 proven, C2-C5 conjectural)

## Definitions

### D1: Local Loss Function
For client k with data distribution P_k over X×Y, define:
L_k(θ) = E_{(x,y)~P_k}[-log p_θ(y|x)]
where p_θ(y|x) is a definable probabilistic model (R_an,exp). L_k: R^d → R is definable in R_an,exp when p_θ is a definable family.

### D2: Singular Fiber
For client k, the singular fiber at level ε:
F_k(ε) = {θ ∈ R^d : L_k(θ) = L_k* + ε}
where L_k* = inf_θ L_k(θ). The minimal fiber F_k(0) = {θ : L_k(θ) = L_k*} is the set of true minima. By Watanabe's theorem, F_k(0) is a definable set (union of analytic manifolds / strata) when L_k is definable.

### D3: Heterogeneity Measure
Define distributional heterogeneity:
σ² = (1/K) · Σ_{k=1}^K KL(P_k || P̄)
where P̄ = (1/K)·Σ_k P_k is the mixture distribution. Equivalently, gradient heterogeneity:
σ²_grad = (1/K)·Σ_k ||∇L_k(θ_0) - ∇L̄(θ_0)||²
at initialization θ_0. Both are definable quantities when P_k are definable.

### D4: FedAvg Aggregation Map
The FedAvg map after one round:
A: (θ_1,...,θ_K) → θ_avg = Σ_{k=1}^K (n_k/N)·θ_k
where n_k is the sample count for client k, N = Σ n_k. The full one-round map is:
Φ(θ_0) = A(T_1(θ_0),...,T_K(θ_0))
where T_k(θ_0) = θ_0 - η·∇L_k(θ_0) (one gradient step; E steps via composition). A is linear (polynomial map), T_k is definable in R_an via automatic differentiation chain. Φ is definable in R_an. ✓

### D5: Composite Fiber (Minkowski Sum)
Define the composite fiber at level ε:
F_avg(ε) = {Σ_k w_k·θ_k : θ_k ∈ F_k(ε) for all k}
= Σ_k w_k · F_k(ε)  (Minkowski sum with weights w_k = n_k/N)
This is the set of all achievable θ_avg when each client's parameter lies on its own singular fiber. F_avg is definable when each F_k is definable (Minkowski sum of definable sets is definable in R_an). ✓

### D6: Composite RLCT
Define the composite RLCT:
λ_avg = RLCT_{θ_avg ~ F_avg(0)} [L̄(θ_avg)]
where L̄ = (1/K)·Σ_k L_k is the average loss. More precisely, λ_avg is the RLCT of the composite fiber F_avg(0) with respect to the average loss landscape L̄. The local free energy:
F_avg(β,n) = -log ∫_{F_avg(0)} exp(-n·β·L̄(θ)) dθ ~ -(nβ)^λ_avg · Φ(θ_avg)
where Φ is the flanking factor on the composite fiber.

### D7: Critical Heterogeneity Threshold
Define σ* = inf{σ > 0 : λ_avg(σ) ≠ λ_centralized}
where λ_centralized is the RLCT of the centralized model trained on P̄. The phase transition:
- σ < σ*: stratum-preserving regime, λ_avg ≈ λ_centralized
- σ > σ*: stratum-crossing regime, λ_avg jumps to different stratum
- σ = σ*: phase transition, discrete jump in λ_avg

## Claims

### C1: R_an-definability of FedAvg (PROVEN)
The FedAvg aggregation map Φ(θ_0) = A(T_1(θ_0),...,T_K(θ_0)) is definable in R_an:
- Each T_k = θ_0 → θ_0 - η·∇L_k(θ_0) is definable in R_an (gradient of definable function via automatic differentiation preserves definability)
- A = linear weighted sum is polynomial (definable in R_an)
- Composition of definable maps is definable
- Therefore Φ: R^d → R^d is R_an-definable ✓

Proof: By induction on the computational graph. Each autograd node is either addition, multiplication, or a known definable function (ReLU, sigmoid, etc.), all definable in R_an. The chain graph is finite, so the composite T_k is definable. Linear combination A is a polynomial map, definable. Composition of definable maps remains definable (o-minimal structures are closed under composition). QED.

### C2: Singular Fiber Non-Convexity and Non-Preservation (CONJECTURAL)
Claim: For K ≥ 2 clients with heterogeneous distributions (σ > 0), the FedAvg averaged point θ_avg = Σ w_k·θ_k may NOT lie on any individual singular fiber F_k(0).

Structural claim: The Minkowski sum F_avg = Σ w_k·F_k(0) is generally NOT contained in any single F_k(0) when the fibers F_k differ (σ > 0). This is because:
- Each F_k(0) is a level set of L_k, which is generally non-convex (neural loss landscapes have multiple minima basins)
- Non-convexity means the convex combination of points from F_k(0) need not remain in F_k(0)
- Heterogeneity means F_k ≠ F_j for k ≠ j, so even the "intersection" interpretation fails

Gaps: (a) For linear regression with L2 loss, fibers are convex (affine), so averaging IS fiber-preserving — this is a degenerate case. (b) For deep networks with ReLU, non-convexity is expected but not proven in general. (c) The relationship between fiber non-convexity and heterogeneity is not yet formalized.

### C3: Heterogeneity as Stratum Selector (CONJECTURAL)
Claim: σ controls which stratum of the average loss L̄ the composite point θ_avg lands on.

At σ = 0: all P_k = P̄, so all F_k = F̄, all θ_k ∈ F̄(0), and θ_avg ∈ F̄(0). The averaging map is fiber-preserving: λ_avg = λ_centralized.

As σ → ∞: fibers F_k diverge maximally, the Minkowski sum F_avg may intersect higher-RLCT strata of L̄. The composite fiber "smears" across strata.

Conjecture: σ acts as a stratum selector in the sense of Watanabe's resolution of singularities. As σ increases, the composite point θ_avg crosses from the generic stratum (low RLCT, good generalization) to exceptional strata (high RLCT, poor generalization) or vice versa.

Gaps: (a) The direction of stratum crossing (higher or lower RLCT) is not determined — depends on fiber geometry. (b) No proof that σ monotonically controls stratum index. (c) The precise relationship between KL(P_k||P̄) and fiber divergence needs formalization.

### C4: Composite RLCT Generalization Bound (CONJECTURAL)
Conjecture: min_k λ_k ≤ λ_avg ≤ max_k λ_k

The lower bound: the composite fiber F_avg contains points near each individual fiber (when weights are concentrated), so λ_avg ≥ min_k λ_k (the best client's RLCT is achievable).

The upper bound: Minkowski sum of varieties tends to smooth singularities (resolution of singularities by averaging), so λ_avg ≤ max_k λ_k.

Distributional refinement: |λ_avg - λ_hom| ≤ C·σ for small σ, where λ_hom is the homogeneous RLCT (σ=0 case). The constant C depends on the fiber geometry (curvature, dimension of intersection).

Generalization bound: the generalization error of θ_avg satisfies:
E[L_test(θ_avg)] - L_train(θ_avg) ~ O(√(λ_avg · d_eff / n))
where d_eff is the effective dimension and n is total data. The composite RLCT λ_avg replaces the standard RLCT in the generalization bound.

Gaps: (a) No proof that Minkowski sum of singular varieties reduces RLCT (counterexample possible). (b) The Lipschitz bound |λ_avg - λ_hom| ≤ C·σ is unproven. (c) The generalization bound form needs rigorous derivation from the free energy asymptotics.

### C5: Heterogeneity Phase Transition (CONJECTURAL)
There exists σ* (critical heterogeneity) such that:
- σ < σ*: λ_avg(σ) = λ_centralized (constant, stratum-preserving)
- σ > σ*: λ_avg(σ) > λ_centralized or λ_avg(σ) ≠ λ_centralized (stratum-crossing, discrete jump)
- σ = σ*: phase transition

The phase transition is testable via SGLD: run FedAvg with synthetic heterogeneity (controlled σ), measure local RLCT via SGLD on the average loss. Predict: λ_avg(σ) is piecewise constant with discrete jumps at σ* values.

Connection to neural scaling: σ* may depend on model dimension d, local epochs E, learning rate η, client count K. Conjecture: σ* ~ 1/√d (decreasing with model complexity — larger models are more sensitive to heterogeneity).

Gaps: (a) Existence of σ* is conjectured from analogy with phase transitions in statistical mechanics, not proven. (b) The 1/√d scaling is speculative. (c) Multiple phase transitions (multiple σ* values) possible. (d) No experimental verification yet.

## Open Problems
1. Is F_avg = Σ w_k·F_k always definable for ReLU networks? (Expected: yes for R_an, but non-trivial for R_an,exp with exponentials)
2. Can λ_avg ≤ max_k λ_k fail? (Non-convex averaging may INCREASE RLCT in pathological cases)
3. Analytical σ* for linear regression (Gaussian noise): compute the exact phase transition boundary
4. How do local epochs E modulate fiber divergence? (E → ∞: full convergence to P_k-specific minima, maximal fiber divergence)
5. Communication compression: if θ_k is quantized, does F_avg acquire additional singular structure from the quantization lattice?
6. Free energy interpretation: is FedAvg performing variational inference over the composite fiber with a mean-field approximation?
7. Client selection bias: non-uniform sampling of clients K' ⊂ [K] — does this bias λ_avg toward certain strata?
8. Connection to #394 SWA: SWA averages along a single trajectory (temporal), FedAvg averages across clients (spatial). Can both be unified under a single "averaging over singular fibers" framework?
9. Does the FedProx variant (with proximal term) have a different composite RLCT? The proximal term constrains θ_k to a ball around θ_0, potentially modifying fiber structure.

## Cross-References
#119 (FL×RLCT initial), #149 (FL×RLCT formalized), #226 (EMA), #232 (model soup), #394 (SWA fiber averaging), #420 (Lookahead), #506 (hypernetwork), #522 (active learning)

## Key Novelties vs Prior Syntheses
- #394 SWA: same distribution, temporal averaging — #523: heterogeneous distributions, spatial averaging
- #232 Soup: same task, post-training — #523: concurrent training, different tasks/data
- #226 EMA: single model temporal — #523: multi-model spatial
- #201 Meta-learning: bi-level (inner/outer) — #523: flat aggregation (no bilevel)

Next: L2 novelty verification (websearch for prior FedAvg × SLT bridges)