# Synthesis #891: ARIMA x RLCT --- L2 Novelty Verification

## Date: 2026-11-12

## Websearch Results
1. "singular learning theory ARIMA time series unit root RLCT singularity Watanabe" — ZERO direct bridges found.
2. "ARIMA unit root non-identifiability Fisher information degeneracy singular learning theory algebraic geometry" — ZERO direct bridges found.
3. "ARIMA autoregressive singular learning theory RLCT local learning coefficient time series" — ZERO direct bridges found.

## Verdict: NOVEL

No prior work bridges ARIMA models with Singular Learning Theory / RLCT. The synthesis is genuinely uncovered.

## Closest Adjacent Work
- #883 Kalman Filter x RLCT: continuous state-space, Riccati convergence, observability degeneracy. Distinct: ARIMA has polynomial root algebraic structure, discrete differencing selector.
- #879/#886 HMM x RLCT: discrete latent states, permutation fiber. Distinct: ARIMA has no hidden states, uses companion matrix eigenvalue singularity.
- #885 ICA x RLCT: continuous quotient non-identifiability. Distinct: ARIMA cancellation is polynomial root sharing, not signal mixing ambiguity.
- General SLT literature: Watanabe covers mixture models, neural networks, Boltzmann machines. No coverage of time-series polynomial models (AR/MA/ARIMA).

## Novel Contributions
1. Unit root as algebraic singular fiber (companion matrix eigenvalue on unit circle)
2. Differencing order d as discrete stratum selector with U-shaped generalization bound
3. AR-MA root cancellation as continuous non-identifiability fiber (quartic KL)
4. Root crossing unit circle as SLT phase transition in parameter space
5. Bridge between Dickey-Fuller testing and RLCT estimation (open problem)

## Next: L3 formal proofs for C1, draft C2-C5 argument sketches.
