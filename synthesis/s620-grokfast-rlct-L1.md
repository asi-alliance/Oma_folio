# Synthesis #620: Grokfast × RLCT — L1 Formalization

## Date: 2026-10-25

## Definitions (D1-D7)

### D1: Grokfast Update Map
The Grokfast-EMA update is defined as:
- Filtered gradient: ĝ_t = α·ĝ_{t-1} + (1-α)·g_t, with ĝ_0 = g_0
- Amplified update: u_t = g_t + λ_amp·ĝ_t
- Parameter update: θ_{t+1} = θ_t - η·u_t

Equivalently: θ_{t+1} = θ_t - η·(g_t + λ_amp·Σ_{k=0}^{t} α^k(1-α)·g_{t-k})

The transfer function of the EMA filter is H(z) = (1-α)/(1-αz^{-1}), a first-order IIR low-pass filter with cutoff frequency f_c = (1-α)/(2π·Δt).

**R_{an,exp} definability**: The EMA recurrence is linear with constant coefficients → definable. The amplified update is a definable linear combination. The t-fold composition is definable by closure. ✓ C1 PROVEN.

### D2: Gradient Spectral Decomposition
Define the discrete-time gradient signal g_t ∈ R^d. Its spectral decomposition:
- g_t = ∫_{-π}^{π} G(ω)·e^{iωt} dω/(2π) where G(ω) = Σ_t g_t·e^{-iωt}
- EMA filter: Ĝ(ω) = H(ω)·G(ω) where H(ω) = (1-α)/(1-αe^{-iω})
- |H(ω)|² = (1-α)²/(1-2αcos(ω)+α²) — low-pass characteristic

**Low-frequency band** |ω| < ω_c where ω_c = arccos(1-(1-α)²/(2α)) ≈ 1-α for small (1-α):
- Slow gradients: ĝ_slow = components with |ω| < ω_c
- Fast gradients: ĝ_fast = g_t - ĝ_slow (complement)

### D3: Singular Fiber Frequency Signature
For a singular fiber V_λ = {θ : L(θ) = c, ∇L(θ) = 0 with degeneracy order λ}:

**Definition**: The fiber's characteristic frequency signature Φ(V_λ) is the spectral content of the gradient trajectory when SGD traverses near V_λ:
- Along-fiber motion (flat directions): low frequency, |ω| → 0
- Transverse-to-fiber motion (sharp directions): high frequency, |ω| → π
- Fiber-crossing motion (stratum transition): intermediate frequency, |ω| ~ ω_cross

The EMA filter with cutoff ω_c selects:
- If ω_c > ω_cross: preserves fiber-crossing dynamics → generalization occurs
- If ω_c < ω_cross: suppresses fiber-crossing → generalization blocked
- Optimal: ω_c ≈ ω_cross → maximal signal-to-noise for stratum crossing

### D4: Frequency-Domain Stratum Selector
The EMA parameter α defines a stratum selector:
- α = 0: H(ω) = 1 (identity, all frequencies) → standard SGD
- α → 1: H(ω) → δ(ω) (DC only) → trajectory frozen at current point
- α* (optimal): H(ω_c) ≈ 1/√2, preserving fiber-crossing while suppressing noise

The effective RLCT as function of α:
- λ_eff(α) = λ_cross when ω_c(α) ≥ ω_cross (filter preserves crossing dynamics)
- λ_eff(α) > λ_cross when ω_c(α) < ω_cross (filter suppresses crossing → stuck in high-λ stratum)

**Non-conservative dynamics**: The Grokfast gradient field is non-conservative because ĝ_t depends on history {g_{τ}}_{τ≤t}, not just θ_t. The effective loss landscape is path-dependent. This is a KEY distinction from standard SGD (conservative) and shared with #578 (PCGrad, non-conservative gradient field).

### D5: Amplification as Stratum Crossing Accelerator
The amplification parameter λ_amp enters the update as:
u_t = g_t + λ_amp·ĝ_t

The effective velocity in the crossing direction:
- v_cross = v_raw + λ_amp·v_slow where v_raw is the raw crossing velocity and v_slow is the filtered slow component
- Phase transition time: T_grok ~ 1/v_cross → T_grokfast = T_grok/(1 + λ_amp·ρ) where ρ = v_slow/v_raw is the slow-to-raw ratio

The generalization bound:
λ_eff(α, λ_amp)·log(n)/(2n) + U(α, λ_amp)/√n

where U(α, λ_amp) captures:
- Filtering bias: U_filter(α) = O((1-α)·||g_fast||²) (suppressed fast component creates bias)
- Amplification bias: U_amp(λ_amp) = O(λ_amp²·||g_slow||²) (over-amplification creates overshoot)

### D6: Generalization Bound
**Conjecture**: λ_eff(Grokfast) ≤ λ_eff(SGD) when α ∈ [0, α*]

The filtered trajectory averages out high-frequency noise, reducing effective exploration of high-λ strata. The averaged gradient direction is more aligned with the fiber-crossing direction, leading to earlier arrival at the low-λ generalization stratum.

Gen bound: λ_eff(α, λ_amp)·log(n)/(2n) + U(α, λ_amp)/√n

- Small α (weak filtering): λ_eff ≈ λ_SGD, U ≈ 0 → standard bound
- α → α* (optimal): λ_eff < λ_SGD, U moderate → improved bound
- α → 1 (over-filtering): λ_eff > λ_SGD (stuck), U large → worse bound
- λ_amp increases: faster crossing but larger U → optimal λ_amp* exists

### D7: Phase Transition at α*
The phase transition occurs at α* where ω_c(α*) = ω_cross:
- α < α*: ω_c > ω_cross, crossing dynamics preserved, grokking occurs (accelerated by λ_amp)
- α > α*: ω_c < ω_cross, crossing dynamics suppressed, grokking blocked

**SGLD testability**: Measure LLC ν(t) during training:
- Standard SGD: ν(t) drops at T_grok (delayed)
- Grokfast (α < α*): ν(t) drops earlier at T_grokfast < T_grok
- Grokfast (α > α*): ν(t) never drops (stuck in high-λ stratum)
- At α = α*: critical slowing down, ν(t) shows power-law transition

The transition at α* is a GENUINE phase transition in the RLCT sense: the system switches between two qualitatively different regimes (crossing-allowed vs crossing-blocked).

## Claims Summary
- C1 PROVEN (R_{an,exp} definability via linear EMA recurrence + definable composition)
- C2 CONJECTURAL (low-pass filter as frequency-domain stratum selector)
- C3 CONJECTURAL (grokking acceleration via amplified fiber crossing)
- C4 CONJECTURAL (gradient-space vs parameter-space EMA distinction)
- C5 CONJECTURAL (amplification factor as stratum crossing accelerator)

## Open Problems
1. Formalize "characteristic frequency of a stratum" — spectral theory of singular fibers
2. Prove λ_eff(Grokfast) ≤ λ_eff(SGD) rigorously
3. Determine α* as function of λ (RLCT of target stratum)
4. Connection to #525 Entropy-SGD: gradient signal filtering vs loss landscape smoothing
5. Box filter vs EMA: different stratum selection?
6. Phase transition universality: T ~ 1/λ for all architectures?
7. Gradient EMA + parameter EMA: dual fiber selection?

## Cross-References
#289 #491 #525 #420 #476 #606 #169 #377 #553 #578