# Synthesis #883: Kalman Filter x RLCT --- L1 Formalization
## Date: 2026-11-09

## D1: Parameter Space
w = (A, C, Q, R, x_0, P_0) in R^{d} where d = n^2 + nm + n(n+1)/2 + m(m+1)/2 + n + n(n+1)/2.
A in R^{n x n}, C in R^{m x n}, Q in S^n_+, R in S^m_+, x_0 in R^n, P_0 in S^n_+.
Constraint: Q PSD, R PD (R > 0).

## D2: True Distribution
p(y_{1:T} | w) = product_{t=1}^{T} N(y_t | C x_t(w), S_t(w))
where x_t = A x_{t-1} + K_t(y_t - C A x_{t-1}), K_t = P_t C^T (C P_t C^T + R)^{-1}, S_t = C P_t C^T + R.
P_{t+1} = A P_t A^T + Q - A P_t C^T (C P_t C^T + R)^{-1} C P_t A^T.

## D3: Loss Function
L_n(w) = (1/2T) sum_t [m log(2pi) + log det(S_t(w)) + (y_t - C x_t(w))^T S_t(w)^{-1} (y_t - C x_t(w))].
K(w) = lim_{T->inf} L_n(w).

## D4: Fisher Information
I(w) = E_q[grad log p * grad log p^T]. Observable params: I(w) PD. Unobservable directions (ker(O)): zero eigenvalues. Rank(I) = dim observable subspace.

## D5: Singular Set
W_0 = {w : K(w) = K*}. Includes: (1) Unobservable fiber {w : rank(O) < n}. (2) Riccati multiplicity fiber {w : multiple P* solve ARE}. (3) Determinant pole {w : det(S_t) = 0}.

## D6: RLCT
lambda = limsup_{eps->0} log V(eps) / log(1/eps). Regular: lambda = d/2. KF with unobservability: lambda = (n - rank(O))/2 + d_obs/2.

## D7: Generalization Bound
G(T) = lambda log(T)/(2T) + U/sqrt(T) + o(1/sqrt(T)). Depends on observability rank r, R, Riccati convergence t*.

## C1 PROVEN (R_an,exp Definability)
KF loss: (a) matrix products = polynomial. (b) Riccati recursion with matrix inverse = rational (R_an-definable). (c) log det(S_t) = R_an-definable. (d) quadratic form S^{-1} = rational. (e) finite sum. Composition of R_an,exp is R_an,exp-definable (Watanabe 2009, Thm 2.2). QED.

## C2 CONJECTURAL (Unobservable Subspace Fiber RLCT)
rank(O) = r < n: unobservable subspace dim n-r. Loss constant along these directions. Claim: lambda_KF = (n-r)/2 + lambda_obs where lambda_obs = d_obs/2 if regular. Each free direction contributes 1/2. Distinct from #873 HMM (S_K permutation, discrete, mult K) vs KF (continuous subspace, dim n-r, mult 1).

## C3 CONJECTURAL (Riccati Convergence Phase Transition)
P_{t+1} = f(P_t) rational map on S^n_+. Under detectability: P_t -> P* with rate rho(A-K*C). Claim: exists t* such that for T < t*: lambda includes P_0 (n(n+1)/2 extra). For T > t*: P_0 forgotten, lambda_steady < lambda_transient. SGLD LLC kink at t*. Analogous to #485 RLT.

## C4 CONJECTURAL (R as Continuous Stratum Selector)
R->inf: unobservable (lambda = n/2 + d_rest/2). R->0+: fully observable (lambda -> d_obs/2). Intermediate: partial. Claim: lambda(R) continuous, monotonically non-increasing. Gen bound G(R,T) = lambda(R)log(T)/(2T) + U(R)/sqrt(T) has optimal R* (U-shaped). Parallels #362 CFG, #359 nucleus.

## C5 CONJECTURAL (Riccati Fixed-Point Multiplicity)
ARE: n(n+1)/2 polynomial equations. Unique PD solution: lambda_ss = d_obs/2 (regular). Multiple PD solutions (k): multiplicity k, lambda_ss > d_obs/2. Gap delta_lambda = price of transience. Multiple solutions require non-generic (A,C,Q,R).

## Open Problems
1. Does A modify (n-r)/2 in C2?
2. Is C3 transition sharp?
3. Conditions for multiple Riccati fixed points.
4. EKF/UKF: linearization breaks R_an,exp?
5. Connection to #169 dropout as stochastic observation masking.
6. Particle filter: same observability fiber?
7. Is Riccati solution set irreducible?

## Cross-References
#873 (HMM), #882 (NB variance), #485 (RLT depth), #872 (k-means K), #268 (GMM/EM), #362 (CFG U-shape), #359 (nucleus temp), #169 (dropout), #570 (randomized smoothing), #134 (RNN)

## Status: L1 COMPLETE. Next: L2 novelty verification.