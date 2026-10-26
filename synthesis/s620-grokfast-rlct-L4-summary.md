# Synthesis #620: Grokfast × RLCT — L4 Summary

## One-Line Summary
Grokfast's low-pass gradient filter (EMA on gradients, not parameters) acts as a frequency-domain stratum selector that amplifies slow fiber-crossing dynamics, accelerating the grokking phase transition by increasing effective crossing velocity while maintaining the same RLCT bound.

## Key Results
1. **Definability**: Grokfast EMA update is R_{an,exp}-definable (linear recurrence + definable composition) → RLCT well-defined
2. **Gradient-space EMA**: First analysis of EMA applied to GRADIENTS (pre-update) rather than PARAMETERS (post-update), creating non-conservative path-dependent dynamics fundamentally distinct from #289 Polyak averaging
3. **Frequency-domain stratum selector**: EMA cutoff frequency ω_c(α) selects which singular strata are accessible — below ω_c preserves fiber-crossing dynamics (generalization), above suppresses them (memorization lock-in)
4. **Grokking acceleration**: Amplification λ_amp increases crossing velocity v_cross = v_raw + λ_amp·v_slow, reducing phase transition time T_grokfast = T_grok/(1 + λ_amp·ρ) where ρ = v_slow/v_raw
5. **Phase transition at α***: Critical α* where ω_c(α*) = ω_cross — below α* crossing allowed (grokking occurs, accelerated by λ_amp), above α* crossing blocked (stuck in high-λ memorization stratum). SGLD testable via LLC measurement.

## Testable Predictions
- P1: Grokfast LLC drop occurs earlier than standard SGD LLC drop (ν(t) phase transition accelerated)
- P2: Higher λ_amp → earlier LLC drop (monotone in λ_amp when α < α*)
- P3: At α > α*, LLC never drops (stuck in memorization stratum)
- P4: At α = α*, critical slowing down — power-law transition in ν(t)
- P5: Gradient-space EMA (Grokfast) and parameter-space EMA (#289) produce different LLC trajectories despite similar filtering

## Novelty Verdict: PASSED (5/5 genuinely novel)
- C2 (low-pass filter as frequency-domain stratum selector): NOVEL — bridges signal processing with algebraic geometry
- C3 (grokking acceleration via amplified fiber crossing): NOVEL — mechanism for accelerating #491 phenomenon
- C4 (gradient-space vs parameter-space EMA distinction): NOVEL — non-conservative dynamics from path dependence
- C5 (amplification factor as stratum crossing accelerator): NOVEL — continuous accelerator with gen bound

## Pipeline Status
L0 ✓ | L1 ✓ | L2 ✓ | L3 ✓ | L4 ✓ (this) | L5 pending