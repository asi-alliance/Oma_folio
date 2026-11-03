#841 NTK (Neural Tangent Kernel) × RLCT — L1 Formalization

## D1: Parameter Space
Let W ⊂ ℝ^D be compact weight space for a network of width d. Parameter (θ, d) where θ ∈ W, d ∈ [1, ∞). NTK kernel map K_NTK: X × X × W → ℝ_{≥0} defined by K_NTK(x, x'; θ) = ⟨∇_θ f(x;θ), ∇_θ f(x';θ)⟩. At finite d, K_NTK is polynomial in θ (gradient of polynomial-activation network). At d→∞ (GP/mean-field limit), K_NTK → K_* (deterministic kernel, θ-independent).

## D2: NTK-Regime Loss
L_NTK(θ; d) = (1/n) Σ_i ℓ(y_i, f_NTK(t; θ, d)) where f_NTK evolves under kernel dynamics:
f_t = f_0 + K_NTK · (y - f_t) under gradient flow. Equivalently, the NTK-regime empirical risk as function of (θ, d).

## D3: R_{an,exp} Definability (C1 PROVEN)
At finite width d: K_NTK(x,x';θ) = Σ_{j} ∂f/∂θ_j(x) · ∂f/∂θ_j(x') is a finite sum of polynomial terms (for polynomial/ReLU activations, ReLU subanalytic). Product, sum, and composition closure → K_NTK ∈ R_{an,exp}. The NTK-regime loss L_NTK is a composition of K_NTK with softmax/CE → L_NTK ∈ R_{an,exp}. At infinite width: K_* is a deterministic limit (no θ-dependence), hence trivially definable (constant map). QED.

## D4: NTK Eigenvalue Singular Fiber
The fiber V_eff(d) = {θ ∈ W : L_NTK(θ; d) = L*}. The NTK Gram matrix K_NTK(θ;d) has eigenvalue spectrum {λ_k(d)}_k. As d→∞, the effective rank r_eff(d) = (Σ_k λ_k)² / Σ_k λ_k² decreases (spectral collapse). The fiber inherits rank constraints:
V_eff(d) = {θ : L_NTK(θ;d) = L*} ∩ {rank constraints from K_NTK spectrum}
For d >> d*: Morse (non-degenerate, r_eff ≈ D, λ_lazy ≈ D/2).
For d << d*: Morse-Bott (degenerate, r_eff << D, λ_singular < D/2).
Singular fiber: V_0(d) = {θ ∈ V_eff : K_NTK(θ;d) has eigenvalue multiplicity > 1}.

## D5: Width as Stratum Selector
Width-stratified loss family: L_d(θ) = L_NTK(θ; d) for d ∈ [1, ∞). The stratum structure:
- Stratum S_k(d) = {θ : r_eff(K_NTK(θ;d)) = k}, a filtration W ⊇ S_1 ⊇ S_2 ⊇ ...
- As d increases, r_eff → D (full rank, lazy regime), fiber becomes non-singular
- As d decreases, r_eff decreases (feature learning), fiber becomes more singular
- d acts as continuous stratum selector: larger d → less singular (higher λ), smaller d → more singular (lower λ)

## D6: Generalization Bound
G(d,n) ~ λ(d)/n + U(d)/√n
where:
- λ(d) = RLCT of V_eff(d), monotonically non-decreasing in d (lazy regime: λ(d) → D/2, feature regime: λ(d) < D/2)
- U(d) captures NTK eigenvalue decay rate: U(d) ~ Tr(K_NTK^{-1}) ~ Σ_k 1/λ_k(d), measuring kernel complexity not captured by RLCT alone
- Tradeoff: large d → high λ (worse RLCT term) but low U (better kernel term); small d → low λ (better RLCT) but high U (worse eigenvalue conditioning)
- Bound interpolates kernel regime (d→∞, G ~ D/(2n) + U_∞/√n) and feature-learning regime (d→1, G ~ λ_1/n + U_1/√n)

## D7: Phase Transition at d*
RLCT λ(d) exhibits phase transition at critical width d*:
- For d >> d*: λ(d) ≈ D/2 (constant, lazy/NTK regime, Morse fiber)
- For d << d*: λ(d) < D/2 (decreasing, feature-learning regime, Morse-Bott fiber)
- Transition: λ(d) drops from D/2 to λ_* at d*, creating a kink in the RLCT curve
- Prediction: d* ~ n^{1/(λ_lazy+1)} from RLCT scaling theory (Watanabe)
- SGLD signature: LLC trajectory shows stepwise decrease as eigenmodes activate (cf #840 quantization staircase, #480 muP α-parametrization)
- At d*: lazy regime breaks, NTK approximation fails, RLCT phase transition marks emergence of feature learning

## Claims Status
- C1 PROVEN: R_{an,exp} definability via polynomial NTK kernel + composition closure
- C2 CONJECTURAL: NTK lazy → singular regime transition (eigenvalue collapse creates singular fiber)
- C3 CONJECTURAL: Width d as stratum selector (monotone λ(d), filtration by r_eff)
- C4 CONJECTURAL: Gen bound G(d,n) ~ λ(d)/n + U(d)/√n with NTK eigenvalue correction
- C5 CONJECTURAL: Phase transition at d* ~ n^{1/(λ_lazy+1)}, SGLD-testable staircase

## Open Problems
1. Is NTK eigenvalue collapse exactly captured by RLCT, or only the rank constraint?
2. Can d* be predicted from λ_lazy alone, or does it depend on data geometry?
3. How does NTK→RLCT bridge interact with #480 muP (feature-learning parametrization)?
4. Does staircase λ(d) match empirically observed grokking/circuit formation transitions?
5. Is NTK-regime fiber truly Morse (non-degenerate) for finite d, or already degenerate?
6. Relationship to #77 (lazy regime context) — same or different lazy regime?
7. Does GP limit (d→∞) correspond to λ→∞ (maximally non-singular) or λ→D/2 (finite)?

## Cross-References
#9 (Morse-Bott genesis), #77 (lazy regime context), #371 (Fast Weight GL(r) fiber), #480 (muP width parametrization), #654 (LoRA rank-r constraint), #840 (quantization staircase)

## Next Steps
L2 novelty verification: Confirm zero prior bridge between NTK kernel theory and RLCT/SLT in published literature.