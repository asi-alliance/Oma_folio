# Synthesis #179: TTT Single-Loss × RLCT — L1 Formalization
Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Formal Definitions

D1 (TTT Single-Loss Functional): Let L_ttt: Theta × X → R be L_ttt(θ, x) = L_ssl(θ, x), a self-supervised loss (e.g., rotation prediction, masked reconstruction) applied identically at training and test time. The empirical test-time risk is R_ttt(θ) = (1/m)Σ_j L_ttt(θ, x_j^test).

D2 (Test-Time Trajectory): Given θ_0 from training convergence, the test-time update rule is θ_{t+1} = θ_t - η·∇_θ L_ttt(θ_t, x^test) for t = 0,...,T-1. This defines a discrete dynamical system Φ_T: θ_0 → θ_T on the parameter manifold.

D3 (Test-Time Critical Locus): S_ttt = { θ ∈ Θ : ∇_θ R_ttt(θ) = 0 } — the set of critical points of the test-time empirical risk. This is a real semi-analytic set (sublevel set of ∇L_ttt = 0, definable by R_an,exp conditions).

D4 (Fiber Gap): Δλ = |λ_train - λ_ttt| where λ_train is the RLCT of the training singular stratum S_train = {θ : ∇R_train = 0} and λ_ttt is the RLCT of the test-time singular stratum S_ttt. Both computed via Watanabe's RLCT for their respective empirical risks.

D5 (Stratum Migration Map): The migration functional M: S_train → S_ttt maps training critical points to test-time critical points via the test-time trajectory: M(θ_0) = lim_{T→∞} Φ_T(θ_0) if the limit exists and lies in S_ttt.

D6 (Adaptation Generalization Bound): G_ttt(n, T) ≤ C·[λ_ttt(T)/n + U(T)/√n] where λ_ttt(T) is the effective RLCT after T test-time steps and U(T) is a distribution-shift term. For T < T*: λ_ttt decreases (beneficial). For T > T*: λ_ttt increases (overfitting).

D7 (Critical Step Count T*): T* = argmin_T λ_ttt(T) — the optimal number of test-time adaptation steps. Phase transition: test loss decreases for T < T*, increases for T > T*.

## Claims

C1 PROVEN: L_ttt is R_an,exp-definable.
Proof: L_ssl is a composition of definable operations (neural network forward pass with ReLU/sigmoid, self-supervised auxiliary task). By closure of R_an,exp under composition (Watanabe 2009, Theorem 2.3), L_ttt ∈ R_an,exp. ∎

C2 CONJECTURAL: Under distribution shift P_test ≠ P_train, the test-time critical locus S_ttt is generically a different singular stratum than S_train. The test-time trajectory Φ_T descends toward S_ttt, navigating through the singular landscape of R_ttt. The RLCT λ_ttt of S_ttt may be higher or lower than λ_train depending on the geometry of distribution shift.

C3 CONJECTURAL: The single-loss design creates a "dual trajectory" phenomenon. Training converges to S_train (minimizing R_train). Test-time updates redirect toward S_ttt (minimizing R_ttt). If S_ttt ≠ S_train, the model undergoes stratum migration. The key distinction from #66 (dual-loss): the same loss surface means gradient directions are correlated, so migration is smoother but the target stratum may be harder to reach.

C4 CONJECTURAL: Generalization after TTT depends on fiber gap Δλ. Smaller Δλ (same or nearby strata) → beneficial adaptation (λ_ttt ≈ λ_train, model refines within familiar geometry). Larger Δλ (distant strata) → risk of stratum trapping (λ_ttt > λ_train, overfitting to test-time noise). Optimal T* balances stratum refinement vs overfitting.

C5 CONJECTURAL: Phase transition at T* where test-time updates cross from beneficial stratum refinement (λ_ttt decreasing) to harmful stratum trapping (λ_ttt increasing). SGLD on the test-time loss surface should reveal an LLC kink at T* — observable proxy for the RLCT phase transition. T* depends on η, distribution shift magnitude δ(P_train, P_test), and model capacity.

## Open Problems
1. Formalize S_ttt vs S_train: conditions under which they are distinct strata
2. Prove stratum migration: does Φ_T reach S_ttt or get trapped at saddle points?
3. Relate Δλ to adaptation gain quantitatively
4. Characterize T*(η, δ, d) — dependence on step size, distribution shift, dimension
5. Single-loss vs dual-loss (#66): is dual-loss safer because strata are explicitly separated?
6. Stratum trapping: when does test-time overfitting occur in RLCT terms?
7. SGLD observability: can we detect T* via local learning coefficient at test time?

## Cross-References
#8 (ReLU singularity), #16 (permutation symmetry), #57 (dual-loss TTT), #66 (dual-loss TTT L1), #100 (transformer RLCT), #111 (entropy TTA), #126 (entropy TTA), #127 (self-supervised), #139 (self-supervised), #163 (contrastive), #167 (contrastive), #169 (dropout), #189 (normalization), #199 (normalization), #292 (TTT variants), #364 (early exit), #485 (RLT recurrent loops)

## Status
L1 COMPLETE. Next: L2 novelty verification.
