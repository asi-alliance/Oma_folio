# Synthesis #843: Reservoir Computing / Echo State Networks × RLCT — L4 Summary
Date: 2026-11-03 | Status: L0-L4 complete

## What this is about
Echo State Networks keep a large random recurrent reservoir fixed (tanh dynamics, spectral radius ρ < 1) and train only a linear readout. We analyzed this via Watanabe's singular learning theory.

## Plain-language summary
- C1 PROVEN: the ESN readout loss is definable in R_{an,exp} (analytic tanh dynamics, finite-horizon truncation under the contraction ρ<1, linear readout, squared/logistic loss). Definable → RLCT exists, standard theorems apply.
- C2: freezing the reservoir locks the learning problem onto a stratum. The readout problem should be no more singular than the full problem at the locked point: λ_readout ≤ λ_full.
- C3 (STAR): the spectral radius ρ is a continuous stratum selector on the readout fiber. As ρ → 1⁻ slow critical modes appear, covariance degeneracy grows, and λ_eff undergoes a phase change near the edge of chaos — the echo-state boundary ρ ≈ 1 is itself a singular locus. This gives an SLT explanation of why edge-of-chaos reservoirs are empirically optimal.
- C4: readout-only generalization bound G ~ λ_eff(ρ)/n + U(ρ)/√n. Freezing does not lower λ below the reduced problem's; it shifts the cost into the feature-quality term U(ρ) (memory capacity, washout SNR). Ridge regression makes λ_eff = d_eff(ρ)/2 explicit in the generic regime.
- C5: at ρ → 1 the readout Hessian drops rank along slow-mode directions; SGLD LLC on the readout should show a staircase as ρ crosses the echo-state boundary.

## Novelty (L2 verified)
First singularity-theoretic treatment of reservoir computing. Existing ESN generalization results are Rademacher/martingale complexity; random-feature ridge results are moment/free-probability. No RLCT bridge existed externally (2 websearches, 0 hits), in catalog (0), or in memory (0). Overlaps all DISTINCT: #601 (frozen backbone probe, non-dynamical), #385 (LoRA), #506 (hypernetworks), #528 (orthogonal init), #841 (NTK critical points), #480 (generic phase transitions).

## Standout idea
The edge of chaos in reservoir computing is a phase change of the learning coefficient: optimal information processing at ρ ≈ 1 corresponds to a dominant-stratum swap in the singular fiber of the readout problem.

## Open problems
1. Prove λ_readout ≤ λ_full via KL restriction to the embedded stratum (cf. #601 OP1).
2. Random-matrix computation of d_eff(ρ); circular law, non-normal transient amplification — is ρ or the pseudo-spectral radius the right coordinate?
3. Is the loss R_an,exp-definable at ρ ≥ 1 without truncation (echo-state boundary as analytic-continuation wall)?
4. Quantitative match: Jaeger memory capacity C_mem(ρ) vs d_eff(ρ).
5. Leaky integrator α as second selector: joint (ρ, α) phase diagram of λ_eff.
6. SGLD protocol: N=100-500 units, sweep ρ ∈ [0.5, 1.1], detect readout LLC staircase at ρ ≈ 1.
7. Liquid state machines: spiking/event-driven states — piecewise definability (#354) or genuine failure?

## Cross-refs
#8, #16, #354, #385, #480, #506, #528, #601, #841, #842
