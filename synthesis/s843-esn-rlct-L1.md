# Synthesis #843: Reservoir Computing / Echo State Networks × RLCT — L1 Formalization

## D1: Parameter Space
Reservoir W_r ∈ R^{N×N} fixed random (spectral radius ρ(W_r) = ρ), input map W_in ∈ R^{N×d_x} fixed, state update s_{t+1} = tanh(W_r s_t + W_in x_{t+1}) (optionally leaky: s ← (1-α_leak)s + α_leak tanh(...)). TRAINED parameters: W_out ∈ R^{d_y×N} only (plus optional bias). Full space Θ_full = (W_r, W_in, W_out); learning problem lives on Θ_r = R^{d_y×N}, d = d_y·N.

## D2: ESN Readout Loss
Given driven states {s_t(x)}_{t≤T} (washout discarded), ridge-readout loss:
L(W_out) = (1/T) Σ_t ||y_t − W_out s_t||² + η ||W_out||².
Equivalently linear regression on random features φ_ρ(x) = s_T(x; W_r(ρ), W_in) — the reservoir defines a fixed feature map indexed by ρ. KL-type proxy: L_n(W_out) = (1/n)Σ ℓ(y, W_out φ_ρ(x)) with ℓ exp-definable (squared / logistic).

## D3: R_{an,exp} Definability (C1 PROVEN)
tanh is real-analytic; s_t is a t-fold composition of analytic maps in (s_0, x_{1..t}) — definable in R_an for fixed t, and the washout limit inherits definability via the contraction (ρ<1) making the infinite composition a uniform limit of definable maps on the echo-state region (complement of indeterminate analytic continuation is handled by the basin condition; alternatively truncate at t=T fixed — finite composition, definable). W_out s_t linear, ℓ polynomial/exp, η||W_out||² polynomial. Closure under composition/sum → L ∈ R_{an,exp}. QED.

## D4: Singular Fiber — Frozen Reservoir as Locked Stratum
Full-model zero set V_full = {(W_r, W_in, W_out) : K(w) = 0}; ESN constrains (W_r, W_in) to a point (W_r*, W_in*) — a stratum selection exactly as in #601 (frozen backbone). Restricted fiber V_read = {W_out : K(W_out; W_r*, W_in*) = 0}. The KL restricted to W_out coordinates is the pullback of the full KL under the embedding ι: W_out ↦ (W_r*, W_in*, W_out). Claim (C2): λ_readout ≤ λ_full(ι(Θ_r)) — the reduced problem is no MORE singular than the full one at the locked point; singularity of the feature map φ_ρ (rank drop of state covariance Σ_ρ = E[s s^T]) descends to degeneracy in W_out (flat directions along ker Σ_ρ).

## D5: Spectral Radius ρ as Stratum Selector
Family of feature maps φ_ρ parameterized by ρ ∈ (0, 1+ε). Strata by covariance rank: S_k = {ρ : rank Σ_ρ = N − k}. As ρ → 1⁻, slow modes appear (transient decay time ~ (1−ρ)^{-1}), state covariance develops near-zero eigenvalues (circular-law / non-normal dynamics), ker Σ_ρ grows nontrivially → dominant stratum migrates. ρ acts as continuous stratum selector on the readout fiber; edge of chaos ρ ≈ 1 is where the stratum wall sits (echo-state property boundary itself a singular locus).

## D6: Readout Generalization Bound
G(ρ, n) ~ λ_eff(ρ)/n + U(ρ)/√n
- λ_eff(ρ): local RLCT of the readout problem on the feature image — in the generic (full-rank Σ_ρ, non-singular) regime λ_eff = d/2 with d = d_y·N; rank-k drop of Σ_ρ lowers the effective dimension along ker directions. Ridge η acts as Gaussian blow-up factor making λ_eff = d_eff(ρ)/2 explicit (cf. #601 probe bound, #385 LoRA).
- U(ρ): feature-quality term — memory capacity C_mem(ρ) ≈ N(1−ρ-ish) degradation, SNR of washout transients.
- Prediction: readout-only training enjoys the REDUCED bound; the price of freezing is shifted entirely into U(ρ), not λ.

## D7: Phase Transition at Edge of Chaos ρ ≈ 1
- ρ << 1: strong contraction, states saturate to a low-information fixed regime → Σ_ρ effectively low-rank, large ker, few informative directions.
- ρ ↑ 1: rich transient dynamics, d_eff grows, optimal information processing — λ_eff(ρ) non-monotone with optimum interior near ρ* < 1.
- ρ → 1⁻ / ρ ≥ 1: echo-state property fails, state statistics diverge / non-stationary, kernel degeneracy (critical slow modes = flat W_out directions) → dominant singular stratum.
- SGLD signature (C5): LLC of W_out under readout-only training shows a staircase as ρ sweeps [0.5, 1.1], with a jump at the echo-state boundary; contrast with fixed-ρ LLC ≈ d_eff/2 plateau.
- Deep/leaky ESNs: stacked contractions compose strata; leak α_leak is a second continuous selector (pair (ρ, α_leak) phase diagram).

## Claims Status
- C1 PROVEN: R_{an,exp} definability (analytic tanh dynamics, finite-T truncation, linear readout, exp-definable loss)
- C2 CONJECTURAL: frozen reservoir = locked stratum, λ_readout ≤ λ_full at the locked point
- C3 CONJECTURAL (star): ρ as continuous stratum selector; edge-of-chaos ρ≈1 = λ_eff phase change / stratum wall at echo-state boundary
- C4 CONJECTURAL: G ~ λ_eff(ρ)/n + U(ρ)/√n with ridge making λ_eff = d_eff/2 explicit; freezing shifts cost into U, not λ
- C5 CONJECTURAL: slow critical modes at ρ→1 create readout-Hessian rank drop; SGLD LLC staircase across echo-state boundary

## Open Problems
1. Prove λ_readout ≤ λ_full via restriction of the KL to the ι-embedded stratum (analog of #601 open problem 1).
2. Random-matrix computation of d_eff(ρ): circular law for W_r, rank/eigenvalue structure of Σ_ρ vs ρ, non-normal transient amplification (which disagrees with pure spectral-radius heuristics — is ρ the right coordinate or the pseudo-spectral radius?).
3. Echo-state boundary as analytic-continuation wall: is the loss even R_an,exp at ρ ≥ 1 without truncation?
4. Quantitative match: Jaeger memory capacity C_mem(ρ) vs d_eff(ρ) — same function up to constants?
5. Leaky integrator α_leak as second selector: joint (ρ, α) phase diagram of λ_eff.
6. SGLD protocol: N = 100–500 units, sweep ρ, readout LLC staircase detection at ρ ≈ 1.
7. Liquid state machines: spiking/event-driven states — STE-like piecewise definability (#354) or genuine failure of R_an,exp?

## Cross-refs
#8, #16, #354, #385, #480, #506, #528, #601, #841, #842
