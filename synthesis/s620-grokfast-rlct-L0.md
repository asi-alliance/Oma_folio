# Synthesis #620: Grokfast × RLCT — L0 Exploration

## Date: 2026-10-25

## Topic
Grokfast (Accelerated Grokking by Amplifying Slow Gradients) × Singular Learning Theory (RLCT)

## Method Description
Grokfast applies a low-pass filter (EMA or box filter) to the gradient time series g_1, g_2, ..., g_t during training. The filtered gradient ĝ_t = α·ĝ_{t-1} + (1-α)·g_t (EMA variant) or ĝ_t = (1/K)·Σ_{k=0}^{K-1} g_{t-k} (box filter variant) replaces the raw gradient in the update rule: θ_{t+1} = θ_t - η·ĝ_t (or amplified: θ_{t+1} = θ_t - η·(g_t + λ·ĝ_t)).

The key insight: slow-varying (low-frequency) gradient components drive generalization, while fast-varying (high-frequency) components drive memorization/overfitting.

## RLCT Bridge

### Core Hypothesis
The gradient time series {g_t} encodes the trajectory of SGD through the singular fiber landscape. Decomposing into frequency components:

- **Low-frequency (slow) gradients**: Directions where the loss landscape changes slowly → these correspond to movements ALONG singular strata (within a fiber) or gentle crossings between nearby strata. These are the generalization-inducing directions.

- **High-frequency (fast) gradients**: Directions where the loss landscape oscillates rapidly → these correspond to memorization dynamics, bouncing within a narrow basin without changing the fiber structure. These contribute to overfitting.

### RLCT Connection
The RLCT λ governs the volume scaling near singularities: V({L < ε}) ~ ε^λ. The gradient signal's frequency content reflects the local geometry:

1. **Near a regular point (λ=1/2)**: Gradient is smooth, all frequencies present, no special filtering needed
2. **Near a singular fiber (λ < 1/2)**: Gradient has dominant low-frequency components along the fiber (flat directions) and high-frequency components in the transverse (sharp) directions. The low-pass filter SELECTS the fiber-aligned directions.

### Key Claims

**C1 (Standard-Novel): R_{an,exp} definability**
The Grokfast update map is R_{an,exp}-definable: EMA is a linear recurrence with constant coefficients (definable), the amplified update g_t + λ·ĝ_t is a definable operation, and composition preserves definability. RLCT is well-defined.

**C2 (Genuinely Novel): Low-pass filter as frequency-domain stratum selector**
The EMA parameter α acts as a frequency-domain stratum selector:
- α → 0: No filtering, raw gradient (all frequencies) → standard SGD dynamics, trajectory explores all strata
- α → 1: Maximum smoothing, only DC component → trajectory locked to coarsest stratum
- Intermediate α*: Optimal filtering that preserves fiber-crossing (generalization) while suppressing noise (memorization)

The cutoff frequency f_c = (1-α)/(2π) separates signal from noise in the gradient spectrum. This maps to a stratum resolution: strata with "characteristic frequency" below f_c are explored, above are suppressed.

**C3 (Genuinely Novel): Grokking as phase transition accelerated by fiber selection**
Grokking = delayed phase transition where trajectory crosses from high-λ (memorization) stratum to low-λ (generalization) stratum. Grokfast accelerates this by:
- Amplifying the low-frequency component that drives the stratum crossing
- The amplified slow gradient increases the effective velocity ALONG the crossing direction
- Phase transition time T_grok ~ 1/(amplitude × velocity_crossing) → T_grokfast < T_standard

RLCT prediction: λ_eff(Grokfast) ≤ λ_eff(SGD) because the filtered trajectory averages over high-frequency noise, analogous to EMA weight averaging (#289) but in GRADIENT space rather than parameter space.

**C4 (Genuinely Novel): Gradient-space vs parameter-space EMA distinction**
Critical distinction from #289 (EMA/Polyak weight averaging):
- #289: EMA of PARAMETERS θ_t → averaged weight may exit SGD fiber to different stratum
- #620 (Grokfast): EMA of GRADIENTS g_t → filtered update direction selects fiber-aligned components
- Parameter EMA averages across strata (post-hoc), gradient EMA filters within-stratum dynamics (intra-trajectory)
- The gradient filter operates BEFORE the update step, while weight averaging operates AFTER
- This is a fundamentally different singularity mechanism: pre-update filtering vs post-update averaging

**C5 (Genuinely Novel): Amplification factor λ as stratum crossing accelerator**
The amplified variant θ_{t+1} = θ_t - η·(g_t + λ_amp·ĝ_t) introduces an amplification parameter λ_amp:
- λ_amp = 0: Standard SGD (no Grokfast)
- λ_amp > 0: Amplified slow gradients → faster stratum crossing
- λ_amp as continuous accelerator of the phase transition
- SGLD testable: measure LLC ν(t) over training. Grokfast should show earlier RLCT drop (phase transition) with higher λ_amp
- Gen bound: λ_eff(α, λ_amp)·log(n)/(2n) + U(α, λ_amp)/√n where U captures the bias from gradient filtering

## Open Problems
1. Formalize "characteristic frequency of a stratum" — need a spectral theory of singular fibers
2. Prove λ_eff(Grokfast) ≤ λ_eff(SGD) rigorously
3. Determine optimal α* as function of λ (RLCT of target stratum)
4. Connection to #525 Entropy-SGD: both smooth the loss, but Grokfast smooths the GRADIENT SIGNAL while Entropy-SGD smooths the LOSS LANDSCAPE
5. Box filter (K-window) vs EMA (α): do they select different stratum structures?
6. Phase transition universality: is grokking time T ~ 1/λ for all architectures?
7. Gradient EMA vs parameter EMA: can they be combined for dual fiber selection?

## Cross-References
- #289 (EMA/Polyak weight averaging): parameter-space EMA, this is gradient-space EMA
- #491 (Grokking × RLCT): grokking as phase transition, this accelerates it
- #525 (Entropy-SGD): loss landscape smoothing vs gradient signal filtering
- #420 (Lookahead): two-phase optimization, Grokfast is single-phase with filtering
- #476 (Nesterov): anticipatory gradient, Grokfast is retrospective (backward-looking EMA)
- #606 (RMSProp): EMA of squared gradients (second moment), Grokfast is EMA of gradients (first moment)
- #169 (Dropout): stochastic regularization, Grokfast is deterministic filtering
- #377 (Gradient noise injection): adds noise, Grokfast removes noise (spectral dual)
- #553 (Gradient accumulation): variance reduction via averaging, Grokfast is frequency selection via filtering

## Next: L1 formalization (D1-D7 definitions)