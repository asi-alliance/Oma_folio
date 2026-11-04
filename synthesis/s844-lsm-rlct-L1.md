# Synthesis #844: Liquid State Machines × RLCT — L1 Formalization
Date: 2026-11-03 | Status: L1 (formal definitions + claim elaboration)

## D1: Parameter Space
Liquid: fixed random spiking reservoir (LIF neurons: membrane v_i, threshold θ_i, reset; synaptic weights W fixed, time constants τ_s). State S(t) = spike train point process {(t_k, i_k)} or smoothed trace s(t) = Σ_k κ_σ(t − t_k) e_{i_k}. TRAINED parameters: readout weights on kernel features only, Θ_r = R^{d_y×N_k}, d = d_y·N_k (N_k kernel feature dim). Full space Θ_full = (W, τ, θ, W_out); learning problem lives on Θ_r.

## D2: LSM Kernel Readout Loss
Features φ_σ(x) = (⟨s_i(t), ψ_j⟩)_ij from fixed temporal kernels ψ_j convolved with liquid spike trains (rate kernels, STA, exponential traces σ-scaled):
L(W_out) = (1/T) Σ_t ||y_t − W_out φ_σ(x_t)||² + η||W_out||².
Linear regression on event-driven features φ_σ(x) — the liquid defines a feature map indexed by (W, τ) and smoothed by σ.

## D3: Definability (C1 — PARTIAL, new mechanism)
Spike time t_k(W, x) = inf{t : v_i(t) = θ_i} is NOT an analytic function of parameters (threshold crossing = switching event, cf. #158). BUT the smoothed trace s(t) = Σ_k κ_σ(· − t_k) with κ_σ ∈ C^∞ compactly supported satisfies: for kernel width σ bounded below, the feature vector φ_σ is a locally bounded, measurable function of parameters, and the readout loss is a polynomial in W_out composed with measurable fixed features. Two routes:
(i) Fixed-liquid route: W, τ, θ FIXED (as in actual LSM training) → φ_σ(x) is a FIXED vector of real numbers per input; L is a polynomial in W_out → definable in R (algebraic!). RLCT of ridge readout exists unconditionally. C1(i) PROVEN.
(ii) Joint route: if the liquid were trained, spike-time discontinuities obstruct R_{an,exp}; kernel smoothing gives definability only up to O(σ) error terms (cf. #354 surrogate gradient mismatch). C1(ii) OPEN — the kernel is a definability RESTORER with quantification gap.

## D4: Frozen Liquid as Locked Stratum (C2)
Same structure as #843 D4: full zero set V_full vs readout fiber V_read = {W_out : K(W_out; liquid*) = 0} under embedding ι. Claim λ_readout ≤ λ_full(ι(Θ_r)). Cleaner than #843: readout loss is genuinely polynomial (route (i)), so the fiber is an algebraic variety; singularity structure = rank degeneracy of kernel-feature covariance Σ_σ = E[φ_σ φ_σ^T].

## D5: Kernel Width σ as Definability/Stratum Dial (C3 — STAR)
Family of feature maps φ_σ. σ → ∞: rate-only features, smooth, low information (temporal info lost → ker Σ_σ grows, covariance rank drops). σ → 0: spike-precise features, maximal information, but definability route (ii) degrades (error terms diverge as smoothing degenerates). σ is a continuous dial trading feature information vs definability — dual of #843 ρ (which trades dynamical richness vs stationarity). Strata S_k(σ) = {σ : rank Σ_σ = N_k − k}; claim dominant stratum migrates as σ crosses separability-relevant scales.

## D6: Separation Property as Second Selector
Liquid computing requires the liquid map to separate inputs: C_sep = inf_{x≠x'} ||s(x) − s(x')||/||x − x'||. Unlike ESN ρ, no single spectral coordinate; candidates: mean-field rate-map Jacobian spectrum, synaptic time-constant ratio τ_s/τ_m, Lyapunov exponent of spiking dynamics. Regime selector R_liquid ∈ {quiescent, separating, saturated}: only the separating regime has full-rank Σ_σ in the appropriate scale — the analog of edge-of-chaos in #843, but the boundary is defined by separation, not by a spectral radius.

## D7: Readout Generalization Bound (C4)
G(σ, n) ~ λ_eff(σ)/n + U(σ)/√n
- λ_eff(σ): algebraic RLCT of the ridge readout fiber (route (i)); ridge η makes λ_eff = d_eff(σ)/2 explicit, d_eff = rank structure of Σ_σ.
- U(σ): feature-quality term — liquid memory function (Maass) evaluated at task timescales, separation margin C_sep, spike-train SNR.
- Prediction: freezing shifts all cost into U(σ, liquid); λ stays at the reduced algebraic value.

## D8: SGLD Signature (C5)
LLC of W_out under readout-only training: plateau at d_eff(σ)/2, staircase as σ sweeps [0, small], plus regime-driven jumps as liquid crosses separation boundaries. Contrast: fixed-σ plateau; joint training (route ii) expected to show definability-failure artifacts (non-Watanabe LLC behavior — a NEGATIVE prediction).

## Claims Status
- C1(i) PROVEN: fixed-liquid readout loss algebraic in W_out, RLCT exists.
- C1(ii) OPEN: joint definability via kernel smoothing, error quantification missing.
- C2 CONJECTURAL: λ_readout ≤ λ_full at locked liquid (fiber restriction argument).
- C3 CONJECTURAL (star): σ as continuous definability/stratum dial; dominant stratum migration.
- C4 CONJECTURAL: G ~ λ_eff(σ)/n + U(σ)/√n; freezing shifts cost into U.
- C5 CONJECTURAL: LLC staircase in σ + separation-regime jumps; joint-training negative prediction.

## Open Problems
1. Quantify definability restoration: ||L_σ,exact − L_definable|| as function of σ (cf. #354 surrogate gap).
2. Right spectral/ergodic coordinate for separation regime (candidates D6) — is there a spiking analog of ρ?
3. Rank computation of Σ_σ for Poisson-like liquid statistics — random point-process analog of circular law?
4. λ_readout ≤ λ_full proof via restriction to algebraic fiber (shared with #843 OP1, new setting).
5. Fading memory for point-process states: formal echo-state analog (shared #843 OP7).
6. Necessity test: does LSM need the kernel at all — do exact spike counts (no smoothing) still yield Watanabe bounds? (Negative result would localize the role of σ.)
7. Synfire chains / polychronization: multi-stable liquid attractors as additional singular strata.

## Cross-refs
#8, #158, #354, #383, #480, #566, #601, #843
