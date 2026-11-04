# Synthesis #844: Liquid State Machines x RLCT — L4 Summary
Date: 2026-11-03 | Status: L0-L4 complete

## What this is about
Liquid State Machines keep a fixed random spiking reservoir (LIF dynamics, point-process states) and train only a readout on smoothed kernel features of the spike trains. We analyzed this via Watanabe's singular learning theory.

## Plain-language summary
- C1(i) PROVEN: with the liquid fixed (actual LSM practice), kernel features are fixed real vectors and the readout loss is polynomial in W_out — algebraic, RLCT exists unconditionally.
- C1(ii) OPEN: for joint training, spike-time discontinuities obstruct R_{an,exp}; kernel smoothing acts as a definability RESTORER up to unquantified O(sigma) error. Smooth-before-loss, contrast #354 smooth-during-gradient.
- C2: lambda_readout <= lambda_full at the locked liquid (algebraic fiber restriction, cleaner than #843).
- C3 (STAR): kernel width sigma is a continuous definability/stratum dial — sigma to infinity: rate-only smooth low-info; sigma to 0: spike-precise high-info degrading definability. Dual of #843's rho.
- C4: G ~ lambda_eff(sigma)/n + U(sigma)/sqrt(n). Freezing shifts cost into feature quality U (liquid memory function, separation margin).
- C5: readout LLC plateau at d_eff(sigma)/2, staircase as sigma sweeps; joint training predicted to show non-Watanabe LLC artifacts (negative prediction). Separation regime (quiescent/separating/saturated) as non-spectral second selector — no spiking analog of rho.

## Novelty (L2 verified)
First singularity-theoretic treatment of liquid state machines / spiking reservoirs. Novel mechanisms: kernel readout as definability restorer, sigma dial, separation-property selector, C1(i)/C1(ii) split. External 0 hits (2 websearches), catalog 0, overlaps #158/#843/#354 all DISTINCT.

## Standout idea
The kernel is a definability restorer: smoothing spike trains before the loss makes Watanabe's theory apply to event-driven computation — and sigma measures exactly how much smoothing the theory costs.

## Open problems
1. Quantify ||L_sigma,exact - L_definable|| vs sigma.
2. Right spectral/ergodic coordinate for spiking separation (mean-field spectrum? Lyapunov? tau_s/tau_m?).
3. Rank of Sigma_sigma under Poisson-like liquid statistics — random point-process circular law?
4. lambda_readout <= lambda_full proof (shared #843 OP1).
5. Fading memory for point-process states (shared #843 OP7).
6. Necessity test: exact spike counts without smoothing — does Watanabe survive?
7. Synfire/polychronization attractors as extra singular strata.

## Cross-refs
#8, #158, #354, #383, #480, #566, #601, #843
