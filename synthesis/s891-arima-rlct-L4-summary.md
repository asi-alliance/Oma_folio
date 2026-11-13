# Synthesis #891: ARIMA x RLCT - L4 Summary

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L4 SUMMARY

---

## Overview

This synthesis applies Singular Learning Theory (SLT) and the Real Log Canonical Threshold (RLCT) to ARIMA(p,d,q) models. The central insight is that ARIMA's polynomial root structure creates three distinct singularity types: unit root fibers (non-stationarity), AR-MA cancellation fibers (parameter redundancy), and overdifferencing artifacts — all expressible through companion matrix eigenvalue geometry on the complex plane.

## Claims Summary

**C1: R_{an,exp} Definability [PROVEN]**
The ARIMA likelihood is R_{an,exp}-definable via closure properties: Gaussian density (exp-definable), truncated autocovariance as rational function of AR/MA coefficients (subanalytic when roots bounded from unit circle), Toeplitz determinant (polynomial in autocovariances), differencing operator (finite linear). QED.

**C2: Unit Root Singular Fiber [CONJECTURAL]**
When Phi(B) has a root on |z|=1, the companion matrix has an eigenvalue on the unit circle, the stationary distribution ceases to exist, and Fisher information degenerates. RLCT contribution: lambda_UR = m/2 for m unit roots (quadratic KL along radial direction, codim-1 per root). Parallels #883 Kalman observability degeneracy but with algebraic rather than geometric structure.

**C3: Differencing d as Discrete Stratum Selector [CONJECTURAL]**
The differencing order d selects discrete strata. Correct differencing (d = d_true) eliminates the unit root singularity. Overdifferencing (d > d_true) introduces cancelable roots at z=1, increasing lambda by 1/2 per excess d. Underdifferencing leaves unit roots in Phi. Generalization bound G(d) is U-shaped with minimum at d* = d_true — the time-series analog of stratum selectors like kernel size (#653) or codebook size (#868), but uniquely endogenous to the data's stochastic trend structure.

**C4: Root Crossing Phase Transition [CONJECTURAL]**
As phi_1 -> 1 in AR(1), the root z = 1/phi_1 crosses the unit circle. The SGLD local learning coefficient should exhibit a kink or jump at the crossing, with critical exponent depending on root multiplicity. This is the parameter-space analog of #883's Riccati convergence phase transition (which occurs in time, not parameter space).

**C5: AR-MA Cancellation Fiber [CONJECTURAL]**
When Phi and Theta share a common root z0 (complex, 2 real parameters), the model ARMA(p,q) reduces to ARMA(p-1,q-1). The extra parameters lie on a codim-2 variety with quartic KL divergence (both AR and MA contribute second-order terms that cancel). RLCT contribution: lambda_cancel = 2 * (1/4) = 1/2 per common root. This is the ARIMA analog of #885 ICA permutation non-identifiability, but with continuous (complex root) rather than discrete (permutation) quotient structure.

## Key Novel Contributions

1. **Unit root as algebraic singular fiber** — companion matrix eigenvalue on unit circle as singularity source
2. **Differencing order d as endogenous stratum selector** — U-shaped generalization bound, minimum at true d
3. **AR-MA root cancellation as continuous non-identifiability** — quartic KL, codim-2 fiber, distinct from discrete quotients
4. **Root crossing unit circle as SLT phase transition** — parameter-space analog of Riccati convergence
5. **Bridge between Dickey-Fuller testing and RLCT estimation** — unit root testing as approximate singularity detection

## Open Problems

1. Exact RLCT for random walk ARIMA(0,1,0): is lambda = 1/2 or 1?
2. ADF (augmented Dickey-Fuller) test as approximate RLCT estimator
3. SGLD LLC detection of overdifferencing in practice
4. Seasonal ARIMA: unit roots at seasonal frequencies (z = e^{2*pi*i/s})
5. Fractional differencing (ARFIMA): continuous d, continuous phase transition?
6. Cointegration: shared stochastic trends = shared unit roots = shared singular fibers
7. GARCH: conditional variance singularity (volatility clustering as singularity)

## Cross-References

#883 Kalman Filter (continuous state, Riccati, observability), #879 #886 HMM (discrete latent, permutation fiber), #885 ICA (continuous quotient non-identifiability), #882 Naive Bayes (Gaussian variance collapse), #268 GMM (mixture singularity), #887 UMAP (graph automorphism fiber), #107 RL policy gradient (Fisher singularity), #69 Markov identifiability, #244 Multinomial uniform (tau stratum selector), #251 Neural ODE (continuous dynamics singularity)
