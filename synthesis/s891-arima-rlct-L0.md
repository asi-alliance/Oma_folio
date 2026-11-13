# Synthesis #891: ARIMA x RLCT --- L0 Exploration

## Date: 2026-11-12

## Topic
ARIMA(p,d,q) viewed through Singular Learning Theory. The autoregressive integrated moving average model creates singular fibers from unit root degeneracy, differencing operator non-identifiability, and AR/MA polynomial root crossings. Unlike #883 Kalman Filter (continuous state-space filtering), ARIMA has explicit polynomial factoring structure where roots crossing the unit circle create algebraic singularities directly accessible via SLT.

## Motivation
ARIMA(p,d,q) models a time series y_t as:
- After d differences: (1-B)^d y_t = w_t
- AR component: Phi(B) w_t = Theta(B) e_t
- Phi(B) = 1 - phi_1 B - ... - phi_p B^p (AR polynomial)
- Theta(B) = 1 + theta_1 B + ... + theta_q B^q (MA polynomial)

The negative log-likelihood as a function of parameters w = (phi_1,...,phi_p, theta_1,...,theta_q, sigma^2, d) involves:
1. Gaussian innovations e_t ~ N(0, sigma^2)
2. Polynomial matrix inversion via Phi(B)^{-1} (infinite-order AR representation)
3. Differencing operator (1-B)^d creating non-invertibility at d

Singular structure arises from:

1. Unit root singularity: When Phi(B) has a root z with |z|=1, the process becomes non-stationary. The likelihood surface develops a singularity because the stationary distribution does not exist. The Fisher information matrix degenerates along directions that move roots toward the unit circle.

2. Differencing order d as stratum selector: d=0 (stationary ARMA), d=1 (single unit root, ARIMA(p,1,q)), d=2 (double unit root). Each d creates a different singular stratum. Overdifferencing (d too high) introduces an artificial unit root in the MA polynomial, creating a cancelable root singularity.

3. AR polynomial root crossing unit circle = phase transition: As parameters vary, roots of Phi(B) cross the unit circle. Inside (stationary) vs outside (explosive) vs on (unit root). The RLCT changes discontinuously at the crossing — a genuine phase transition in the SLT sense.

4. MA invertibility singularity: Theta(B) roots on unit circle make the process non-invertible. The AR-infinity representation has diverging coefficients. Creates a singular fiber analogous to AR unit root but in the noise representation.

5. AR-MA root cancellation: When Phi(B) and Theta(B) share a common root, the model is overparameterized — same likelihood with fewer parameters. This creates a non-identifiability fiber (parameter redundancy), directly analogous to #883 Kalman observability degeneracy but in polynomial root space.

## Key RLCT Bridges

### Bridge 1: R_an,exp Definability of ARIMA Likelihood
The ARMA likelihood involves: Gaussian innovations (R_an-definable), polynomial Phi(B) inversion (rational function of parameters — R_an-definable when roots are bounded away from unit circle), and sigma^2 scaling. The log-likelihood is a sum of quadratic forms in e_t plus T/2 log(sigma^2).

C1 PROVEN: The ARMA (d=0) likelihood is R_an,exp-definable for stationary, invertible parameters (roots strictly inside unit circle). The ARIMA (d>0) likelihood involves differencing (finite polynomial) + ARMA on differenced series, preserving R_an,exp definability.

### Bridge 2: Unit Root Singular Fiber
When Phi(B) = (1-B) * Phi'(B), the parameter phi lies on a codimension-1 algebraic variety (det of companion matrix has eigenvalue 1). The likelihood becomes singular because:
- The stationary distribution does not exist (variance diverges)
- The information matrix has a zero eigenvalue along the direction pushing the root onto the unit circle
- The KL divergence to the true model vanishes to higher order along this direction

C2 CONJECTURAL: RLCT contribution from unit root proximity is lambda_UR = 1/2 per unit root (dimension 1 singular direction, quadratic KL). Total ARIMA RLCT: lambda = p_active/2 + lambda_UR * m where m = number of roots on unit circle. Parallels #883 Kalman unobservable subspace (n-rank(O))/2 but with algebraic variety structure.

### Bridge 3: Differencing Order d as Continuous Stratum Selector
d acts as discrete stratum selector: d=0 (regular, lambda = (p+q)/2), d=1 (single unit root fiber, lambda = (p+q-1)/2 + 1/2), d=2 (double unit root, lambda = (p+q-2)/2 + 1). The differencing operator (1-B)^d is non-invertible at B=1, creating a pole in the transfer function.

C3 CONJECTURAL: lambda(d) is non-decreasing in d for correctly specified models. Overdifferencing (d > d_true) introduces cancelable AR-MA root at B=1, increasing lambda by 1/2 per excess difference. Under-differencing (d < d_true) leaves unit root in Phi, also increasing lambda. Optimal d* = d_true minimizes lambda. U-shaped generalization bound G(d) = lambda(d) log(T)/(2T) + U(d)/sqrt(T).

### Bridge 4: AR Polynomial Root Crossing as Phase Transition
As phi varies, roots of Phi(B) move. Crossing |z|=1 changes the process from stationary to non-stationary. The RLCT changes:
- Inside unit circle (|z|<1): regular, lambda = p/2
- Approaching unit circle (|z| -> 1): singular, lambda increases
- On unit circle (|z|=1): singular fiber, lambda = (p-1)/2 + 1/2
- Outside (|z|>1): explosive, likelihood ill-defined (not R_an for fixed T)

C4 CONJECTURAL: SGLD LLC shows a kink/discontinuity at the parameter value where a root crosses the unit circle. This is the time-series analog of #883 Riccati convergence phase transition but occurs in parameter space (not time). The critical exponent at the crossing is governed by the multiplicity of the crossing root.

### Bridge 5: AR-MA Root Cancellation Fiber
When Phi(B) and Theta(B) share a common root (z - z0), the model ARIMA(p,d,q) has the same likelihood as ARIMA(p-1,d,q-1). The extra parameters (phi, theta) lie on an algebraic variety defined by Phi(z0)=0 AND Theta(z0)=0. This is a parameter redundancy fiber.

C5 CONJECTURAL: AR-MA cancellation creates a singular fiber of dimension 2 (one shared root location z0 = complex, encoded as 2 real params) with KL vanishing to order 4 (quartic) along the cancellation direction. RLCT contribution = 2 * 1/4 = 1/2. This is the ARIMA analog of #885 ICA permutation non-identifiability but with continuous root-space structure.

## Distinction from #883 Kalman Filter
| Property | Kalman Filter (#883) | ARIMA (#891) |
|----------|----------------------|--------------|
| State space | Continuous R^n, hidden | Observed directly, differenced |
| Non-identifiability | Observability subspace degeneracy | Polynomial root cancellation |
| Singularity source | Riccati fixed point multiplicity | Unit root / root crossing |
| Stratum selector | R (continuous, measurement noise) | d (discrete, differencing order) |
| Phase transition | Riccati convergence time t* | Root crossing unit circle in param space |
| Singularity type | Semi-algebraic + analytic | Algebraic (polynomial roots) |

## Distinction from #879/#886 HMM
| Property | HMM (#879/886) | ARIMA (#891) |
|----------|----------------|--------------|
| Hidden state | Discrete (K states) | None (observed, differenced) |
| Non-identifiability | Permutation S_K | Root cancellation + unit root |
| Temporal structure | Markov transition matrix | AR/MA polynomial operators |
| Singularity type | Simplex algebraic + emission collision | Companion matrix eigenvalue = 1 |

## Claims
| Claim | Description | Status |
|-------|-------------|--------|
| C1 | R_an,exp-definability of ARIMA likelihood | PROVEN |
| C2 | Unit root singular fiber RLCT = m/2 | CONJECTURAL |
| C3 | Differencing d as discrete stratum selector, U-shaped lambda(d) | CONJECTURAL |
| C4 | AR root crossing unit circle = phase transition | CONJECTURAL |
| C5 | AR-MA root cancellation fiber, quartic KL, RLCT contribution 1/2 | CONJECTURAL |

## Open Problems
1. Derive exact RLCT for unit root model ARIMA(0,1,0) = random walk analytically
2. Connection between ADF test (augmented Dickey-Fuller) and RLCT estimation
3. Does SGLD LLC detect overdifferencing in practice?
4. AR-MA cancellation: is KL truly quartic along cancellation direction?
5. Seasonal ARIMA: unit roots at seasonal frequencies create additional singular fibers
6. Relationship to cointegration: multiple unit root series with shared stochastic trend
7. GARCH extension: conditional variance singularity structure

## Cross-References
- #883 Kalman Filter (continuous state filtering, Riccati)
- #879/#886 HMM (discrete latent, permutation fiber)
- #885 ICA (continuous quotient non-identifiability)
- #882 Naive Bayes (Gaussian variance collapse singularity)
- #268 GMM (mixture singularity, no temporal structure)
- #107 RL policy gradient (Fisher singularity in sequential models)
- #69 Markov category identifiability (monicity = identifiability)
- #244 Multinomial uniform (tau as stratum selector)
- #251 Neural ODE (continuous dynamics singularity)
