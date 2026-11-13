
# Synthesis #891: ARIMA x RLCT --- L1 Formalization

## Date: 2026-11-12

## D1: Parameter Space
w = (phi_1, ..., phi_p, theta_1, ..., theta_q, sigma^2, d) in R^{p+q+2}.
Phi(B) = 1 - phi_1 B - ... - phi_p B^p (AR polynomial).
Theta(B) = 1 + theta_1 B + ... + theta_q B^q (MA polynomial).
sigma^2 > 0 (innovation variance).
d in {0, 1, 2, ...} (differencing order, discrete).
Constraint: Phi roots inside unit circle (stationary after differencing), Theta roots inside unit circle (invertible).
d is fixed during estimation; the parameter space is W_d = R^p x R^q x R_+ for each fixed d.

## D2: True Distribution
y_t observed for t = 1, ..., T. After d differences: z_t = (1-B)^d y_t.
z_t follows ARMA(p,q): Phi(B) z_t = Theta(B) e_t, e_t ~ N(0, sigma^2).
p(y_{1:T} | w) = (2 pi sigma^2)^{-T/2} |Sigma(w)|^{-1/2} exp(-1/(2 sigma^2) e(w)^T Sigma(w)^{-1} e(w))
where e(w) = Theta(B)^{-1} Phi(B) z(w) are innovations, Sigma(w) = Toeplitz(gamma_0, ..., gamma_{T-1}) from ARMA autocovariance function.
For d=0: z_t = y_t. For d>=1: z_t = Delta^d y_t.

## D3: Loss Function
L_T(w) = (1/2T) [T log(2 pi sigma^2) + log det(Sigma(w)) + (1/sigma^2) e(w)^T Sigma(w)^{-1} e(w)]
K(w) = lim_{T->inf} L_T(w).
For stationary ARMA: K(w) = log(sigma^2) + (1/2) log(2 pi) + (1/(2 sigma^2)) gamma_0(w) where gamma_0 is the process variance.
K(w*) = K* at true parameters w*.

## D4: Fisher Information
I(w) = E_q[nabla log p * nabla log p^T]. For ARMA:
I_{phi_i, phi_j} = (1/sigma^2) sum_{k=0}^{inf} psi_k psi_{k+|i-j|} where Psi(B) = Phi(B)^{-1}.
I_{phi_i, theta_j} = cross terms involving Theta(B)^{-1} Phi(B)^{-1}.
I_{sigma^2, sigma^2} = T/(2 sigma^4).
Regular: I(w) PD when Phi, Theta have no common roots and all roots strictly inside unit circle.
Singular directions: (1) unit root (root of Phi on |z|=1), (2) MA non-invertibility (root of Theta on |z|=1), (3) AR-MA common root (cancellation).

## D5: Singular Set
W_0 = {w : K(w) = K*}. Components:
(1) Unit root fiber: {w : exists z with |z|=1, Phi(z)=0}. Codim 1 per root on unit circle.
(2) MA invertibility boundary: {w : exists z with |z|=1, Theta(z)=0}. Codim 1.
(3) AR-MA cancellation fiber: {w : exists z0, Phi(z0)=0 AND Theta(z0)=0}. Codim 2 (z0 complex = 2 real params). Reducible model: ARMA(p-1,q-1) has same likelihood.
(4) Overdifferencing: {w : d > d*}, introduces cancelable root at z=1 in both Phi and Theta.

## D6: RLCT
lambda = limsup_{eps->0} log V(eps) / log(1/eps).
Regular (stationary, invertible, no cancellation): lambda = (p+q+1)/2.
Unit root (m roots on |z|=1): lambda = (p+q+1-m)/2 + m/2 = (p+q+1)/2. BUT the KL vanishes to higher order along the unit root direction (order 2 per root in the AR coefficient, but the process variance diverges, creating a non-standard singularity).
AR-MA cancellation (k common roots): lambda = (p+q+1-2k)/2 + k * lambda_cancel where lambda_cancel depends on KL order along cancellation direction.
C2 CONJECTURAL: lambda_UR = 1/2 per unit root (quadratic KL, codim-1 singular direction).
C5 CONJECTURAL: lambda_cancel = 1/2 per common root (quartic KL, codim-2 fiber, 2 * 1/4 = 1/2).

## D7: Generalization Bound
G(T) = lambda log(T)/(2T) + U/sqrt(T) + o(1/sqrt(T)).
Depends on: differencing order d, number of unit roots m, AR-MA cancellation count k.
C3 CONJECTURAL: G(d) = lambda(d) log(T)/(2T) + U(d)/sqrt(T), U-shaped in d with minimum at d* = d_true.
U(d) increases with |d - d*| due to spurious unit roots (overdifferencing) or residual non-stationarity (underdifferencing).

## C1 PROVEN (R_an,exp Definability)
The ARMA likelihood involves:
- Gaussian density: exp(-x^2/(2 sigma^2)) / (sqrt(2 pi) sigma) — R_an,exp definable.
- Autocovariance gamma_k(w) = (sigma^2 / 2 pi) integral_{-pi}^{pi} |Theta(e^{-i omega})/Phi(e^{-i omega})|^2 e^{i k omega} d omega — definable as rational function of phi, theta for fixed T (truncated autocovariance).
- Toeplitz determinant det(Sigma_T(w)) — polynomial in gamma_k(w), hence subanalytic in (phi, theta, sigma^2) when roots are bounded away from unit circle.
- Differencing (1-B)^d: finite linear operator, polynomial in y, preserves definability.
By closure properties of R_an,exp (composition, addition, multiplication, restriction to semianalytic sets), the ARIMA likelihood is R_an,exp-definable on the stationary+invertible domain. QED.

## C2 CONJECTURAL (Unit Root Singular Fiber)
When Phi(B) has a root z0 with |z0|=1, the companion matrix C_phi has eigenvalue z0 on the unit circle. The stationary distribution does not exist (variance diverges). The KL divergence K(w) approaches K* as the root approaches the unit circle, but the rate of approach changes.
For a single unit root (ARIMA(0,1,0) = random walk): K(w) - K* = O((1 - |z0|)^2) along the radial direction, but the process variance = sigma^2 / (1 - |z0|^2) diverges. The RLCT contribution is lambda_UR = 1/2 (one real singular direction, quadratic KL). For m unit roots: lambda_UR = m/2.
This parallels #883 Kalman unobservable subspace (n-rank(O))/2 but with algebraic (polynomial root) rather than geometric (observability matrix) structure.

## C3 CONJECTURAL (Differencing d as Stratum Selector)
d selects discrete strata:
- d=0: lambda = (p+q+1)/2 (regular ARMA)
- d=1: lambda = (p+q+1)/2 + 1/2 (one unit root) — BUT the differenced series removes the root, so the EFFECTIVE lambda = (p+q+1)/2 if d = d_true. The key is that correct differencing eliminates the singularity.
- d > d_true (overdifferencing): introduces cancelable root at z=1, lambda increases by 1/2 per excess d.
- d < d_true (underdifferencing): unit root remains in Phi, lambda = (p+q+1)/2 + m/2 where m = d_true - d.
Generalization: G(d) = lambda_eff(d) log(T)/(2T) + U(d)/sqrt(T), U-shaped, minimum at d* = d_true.

## C4 CONJECTURAL (Root Crossing Phase Transition)
As phi_1 -> 1 in AR(1): Phi(B) = 1 - phi_1 B. Root z = 1/phi_1.
- |phi_1| < 1: stationary, lambda = 2/2 = 1 (regular: p=1, q=0, sigma^2).
- phi_1 -> 1: root approaches unit circle, Fisher info degenerates.
- phi_1 = 1: unit root (random walk), lambda = 1/2 + 1/2 = 1 (but singular structure changes).
SGLD LLC trajectory: as phi_1 crosses 1, the LLC should show a kink or jump. The critical exponent at the crossing depends on root multiplicity.
This is the time-series analog of #883 Riccati convergence phase transition, but in parameter space (not time).

## C5 CONJECTURAL (AR-MA Cancellation Fiber)
When Phi(z0) = 0 and Theta(z0) = 0 for some z0 (complex, z0 = a + bi, 2 real params):
The model ARMA(p,q) = ARMA(p-1,q-1) * (1 - z0^{-1} B). The extra parameters lie on a codim-2 variety.
KL divergence: K(w) - K* = O(|common root|^4) along the cancellation direction (quartic, because both AR and MA contribute second-order terms that cancel).
RLCT contribution: lambda_cancel = 2 * (1/4) = 1/2 per common root.
This is the ARIMA analog of #885 ICA permutation non-identifiability, but with continuous (complex root) rather than discrete (permutation) quotient structure.

## Open Problems
1. Exact RLCT for random walk ARIMA(0,1,0): is lambda = 1/2 or 1?
2. ADF (augmented Dickey-Fuller) test as approximate RLCT estimator
3. SGLD LLC detection of overdifferencing in practice
4. Seasonal ARIMA: unit roots at seasonal frequencies (z = e^{2 pi i/s})
5. Fractional differencing (ARFIMA): continuous d, continuous phase transition?
6. Cointegration: shared stochastic trends = shared unit roots = shared singular fibers
7. GARCH: conditional variance singularity (volatility clustering as singularity)

## Cross-References
- #883 Kalman Filter (continuous state, Riccati, observability degeneracy)
- #879/#886 HMM (discrete latent, permutation fiber, temporal)
- #885 ICA (continuous quotient non-identifiability, permutation)
- #882 Naive Bayes (Gaussian variance collapse)
- #268 GMM (mixture singularity, no temporal structure)
- #887 UMAP (graph automorphism fiber)
- #107 RL policy gradient (Fisher singularity in sequential models)
- #69 Markov category identifiability
- #244 Multinomial uniform (tau stratum selector)
- #251 Neural ODE (continuous dynamics singularity)
