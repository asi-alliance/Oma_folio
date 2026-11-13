# Synthesis #846: Boosting (AdaBoost) × RLCT — L1 Formalization
Date: 2026-11-06 | Status: L1 (formal definitions, pre-proof)

## Definitions

### D1: Weak Learner Family
Let H = {h_θ : X → {-1,+1}} be a family of weak learners parametrized by θ ∈ Θ ⊂ R^d, where each h_θ is analytic in θ (e.g., decision stumps: h_θ(x) = sign(w·x - b), w ∈ R^d, b ∈ R). The weak learner family is a finite-dimensional analytic family.

The space of M-round boosting ensembles is:
F_M = {f_M(x) = Σ_{m=1}^{M} α_m h_{θ_m}(x) : θ_m ∈ Θ, α_m ∈ R}

The full parameter space is W_M = Θ^M × R^M (M copies of learner params + M weights), dimension d_M = M(d+1).

### D2: AdaBoost Loss Functional
The AdaBoost exponential loss over n training samples {(x_i, y_i)}_{i=1}^n is:
L_M(w) = (1/n) Σ_{i=1}^n exp(-y_i f_M(x_i)) = (1/n) Σ_{i=1}^n exp(-y_i Σ_{m=1}^M α_m h_{θ_m}(x_i))

where w = (θ_1,...,θ_M, α_1,...,α_M) ∈ W_M.

This is R_{an,exp}-definable when each h_{θ_m} is analytic: exp composed with finite sums of analytic functions and real parameters.

### D3: Sequential Fiber Structure
The cumulative singular fiber at round M is:
V_M = {w ∈ W_M : L_M(w) = L_M*}

where L_M* = inf_{w ∈ W_M} L_M(w). At each round m, the weak learner h_{θ_m} is selected to minimize the weighted error with weights:
w_m(i) = exp(-y_i f_{m-1}(x_i)) / Z_m,   Z_m = Σ_i exp(-y_i f_{m-1}(x_i))

The fiber V_M embeds the structure of V_{M-1} since f_M = f_{m-1} + α_M h_{θ_M}. The reweighting creates input-data-dependent fiber reshaping: the loss surface for θ_M concentrates on misclassified samples under f_{m-1}.

### D4: Round-Stratified Loss Family
Define the per-round partial loss:
L_m(θ_m, α_m | h_{θ_1},...,h_{θ_{m-1}}) = Σ_i w_m(i) exp(-y_i α_m h_{θ_m}(x_i))

This is the conditional loss for the m-th learner given fixed previous learners. The full loss decomposes as:
L_M = Z_M · Π_{m=1}^M (normalized L_m)

The round-stratified family {L_m}_{m=1}^M creates a sequence of loss landscapes, each conditioned on the fixed solutions of previous rounds.

### D5: Cumulative RLCT
The cumulative RLCT of the M-round ensemble is:
λ(M) = RLCT(L_M, V_M) = lim_{t→∞} t^{-1} log ∫_{w: L_M(w) < t·L_M*} exp(-L_M(w)/t) dw / (normalization)

Hypothesis: λ(M) ≤ λ(M-1) + δ_m, where δ_m is the marginal RLCT contribution of the m-th weak learner. The additive structure reflects that each learner adds at most d+1 dimensions to the parameter space, but the effective singularity contribution depends on the margin distribution after m-1 rounds.

### D6: M as Stratum Selector
The number of rounds M serves as a discrete stratum selector. Define:
- λ(M): cumulative RLCT of M-round ensemble
- λ_eff(M) = λ(M) / (M(d+1)): per-parameter effective RLCT

As M increases, new singular strata appear (from each new h_{θ_m}), but the empirical loss reduction per round diminishes (AdaBoost convergence). The stratum selector M controls the trade-off between loss reduction and singularity complexity.

Critical M* is defined as:
M* = argmin_M [λ(M)/n + U(M)/n]

where U(M) is the complexity penalty from the growing singular set.

### D7: Generalization Bound
The generalization bound for the M-round AdaBoost ensemble:
G(M) ≤ λ(M)/(2n) + U(M)/√n + margin_term(M)

where:
- λ(M)/(2n): RLCT-based complexity term (cumulative singularity)
- U(M)/√n: remainder/fluctuation term from the growing parameter space
- margin_term(M): margin distribution contribution

Margin connection: The AdaBoost margin distribution μ_M = {y_i f_M(x_i)}_i governs generalization. Conjecture: margin width ρ_M = min_i y_i f_M(x_i) relates to RLCT as:
λ(M) ≈ λ(0) · g(ρ_M)

where g is a decreasing function — larger margins → lower RLCT. This formalizes the margin-RLCT bridge.

## Claims (refined from L0)

### C1 (PROVEN): R_{an,exp}-definability
L_M(w) = (1/n) Σ_i exp(-y_i Σ_m α_m h_{θ_m}(x_i)) is R_{an,exp}-definable when each h_{θ_m} is analytic in θ_m.

Proof sketch: Each h_{θ_m}(x_i) is analytic in θ_m. The sum Σ_m α_m h_{θ_m}(x_i) is analytic in (θ_1,...,θ_M, α_1,...,α_M). The exponential exp(-y_i ·) of an analytic function is R_{an,exp}-definable. Finite sums preserve definability. ∎

### C2 (CONJECTURAL): Cumulative Singular Fiber
V_M embeds V_{M-1} via the addition of α_M h_{θ_M}. The reweighting w_m(i) = exp(-y_i f_{m-1}(x_i))/Z_m creates input-data-dependent fiber reshaping distinct from:
- #652 (bagging: independent parallel fibers)
- #590 (adversarial: min-max perturbation fibers)
- #608 (class balancing: static weight fibers)

The key novelty: the fiber at round M depends on the *solutions* of rounds 1..M-1, creating a path-dependent singular structure.

### C3 (CONJECTURAL): M as Stratum Selector
M is a discrete stratum selector. Each added weak learner creates new singular strata in W_M. The effective RLCT λ_eff(M) = λ(M)/(M(d+1)) may decrease initially (margin improvement dominates) then plateau (singularity complexity dominates). Critical M* marks the phase transition.

### C4 (CONJECTURAL): Generalization Bound
G(M) ≤ λ(M)/(2n) + U(M)/√n + margin_term(M), where λ(M) is the cumulative RLCT. The margin-RLCT connection: larger margins → fatter singular strata → lower λ(M). This unifies AdaBoost margin theory with SLT.

### C5 (CONJECTURAL): Phase Transition at M*
At M = M*, the effective RLCT stops decreasing — adding more weak learners increases singularity complexity faster than it reduces empirical loss. SGLD LLC signature: LLC decreases with M up to M*, then stabilizes or increases.

## Open Problems (for L2)
1. Formal specification of the margin-RLCT function g(ρ_M): is it polynomial, logarithmic, or power-law in margin width?
2. Additive vs multiplicative structure of λ(M): is δ_m independent of previous learners, or does it depend on the margin distribution after m-1 rounds?
3. Relationship between weak learner capacity (stump vs depth-3 tree) and δ_m: higher-capacity learners may create more complex singular strata per round.
4. Interaction with #652 (bagging): can parallel and sequential ensembling be unified in a single RLCT framework?
5. SGLD LLC estimation protocol for AdaBoost: how to run SGLD on the discrete round structure (M is discrete, not continuous)?
6. Does the AdaBoost weight decay α_m = 0.5 log((1-err_m)/err_m) create a natural regularization that bounds λ(M)?
7. Connection to gradient boosting: if h_{θ_m} is selected by gradient descent on L_m (not discrete weak learner selection), does the RLCT structure change?

## Cross-refs
#652 (bagging/parallel ensemble), #590 (adversarial/min-max), #608 (class balancing/static reweight), #539 (focal loss/down-weighting), #173 (SAM/flat minima), #169 (dropout/stochastic), #433 (weight decay), #843 (preceding synthesis)

## Next
L2 novelty verification.
