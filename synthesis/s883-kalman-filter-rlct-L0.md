# Synthesis #883: Kalman Filter x RLCT --- L0 Exploration
## Date: 2026-11-09

## Topic
Kalman Filter (KF) viewed through Singular Learning Theory. The linear-Gaussian state-space model creates singular fibers from observability degeneracy, Kalman gain rank deficiency, and Riccati equation convergence structure. Unlike #873 HMM (discrete hidden states, permutation non-identifiability), KF has continuous hidden states with linear-Gaussian dynamics, producing fundamentally different singular geometry: subspace degeneracy instead of permutation fibers.

## Motivation
The Kalman filter estimates hidden state x_t from noisy observations y_t via:
- State model: x_t = A x_{t-1} + w_t, w_t ~ N(0, Q)
- Observation model: y_t = C x_t + v_t, v_t ~ N(0, R)

The negative log-likelihood (as a function of parameters w = (A, C, Q, R, x_0)) involves Gaussian densities composed through linear dynamics and T-fold temporal propagation. This creates rich singular structure:

1. Observability degeneracy: When the observability matrix O = [C; CA; ...; CA^{n-1}] loses rank, some state-space directions are never observed, creating free-parameter fibers in unobservable subspace.
2. Kalman gain rank deficiency: K = P C^T (C P C^T + R)^{-1}. When C P C^T + R is rank-deficient, the gain computation becomes singular.
3. Riccati equation convergence: P_{t+1} = A P_t A^T + Q - A P_t C^T (C P_t C^T + R)^{-1} C P_t A^T has a fixed point P*. The transient-to-steady-state transition creates a temporal RLCT phase change.
4. Measurement noise R as stratum selector: R to infinity makes all states unobservable (degenerate fiber = full state space). R to 0 makes states fully observed (no degeneracy). R interpolates continuously between extremes.
5. Gaussian likelihood singularities: The likelihood involves (det(S_t))^{-1/2} terms. When S_t = C P_t C^T + R becomes singular, det to 0 creates a pole singularity, analogous to #882 Gaussian NB variance collapse but in a dynamical filtering context.

## Key RLCT Bridges

### Bridge 1: Gaussian KL Divergence and R_an,exp Definability
The KF log-likelihood: log p(y_{1:T} | w) = sum_t log N(y_t | C x_t, S_t) where S_t = C P_t C^T + R. Each term: -1/2 log(2pi) - 1/2 log det(S_t) - 1/2 (y_t - mu_t)^T S_t^{-1} (y_t - mu_t). Involves polynomial matrix products, log det (R_an-definable), matrix inverse (rational). All R_an,exp-definable.

C1 PROVEN: The KF likelihood is R_an,exp-definable. Composition of polynomial matrix ops + log det + rational inverse is R_an,exp-definable.

### Bridge 2: Unobservable Subspace Singular Fiber
When rank(O) = r < n, the unobservable subspace has dimension n - r. Parameters in this subspace are unconstrained by data, forming a free-parameter fiber.

C2 CONJECTURAL: RLCT contribution from unobservability is (n - r)/2, where r = rank(O). Total: lambda_KF = (n - rank(O))/2 + lambda_obs. Parallels #873 HMM but with continuous subspace structure instead of discrete permutation.

### Bridge 3: Riccati Convergence as Phase Transition
The Riccati recursion converges to steady-state P* under detectability/stabilizability. Transient phase has P_t depending on P_0 (additional parameters). Steady-state: P* determined by (A, C, Q, R), P_0 drops out.

C3 CONJECTURAL: RLCT undergoes phase transition at t* = convergence time. For t < t*: lambda_transient includes P_0. For t > t*: lambda_steady < lambda_transient. SGLD LLC shows kink at t*. Analogous to #485 RLT but in backward inference context.

### Bridge 4: Measurement Noise R as Continuous Stratum Selector
R acts as continuous stratum selector: R to infinity = unobservable (lambda = n/2), R to 0 = fully observed (lambda = 0), intermediate R = partial observability.

C4 CONJECTURAL: lambda(R) monotonically decreasing in observability (larger R = more singular = higher RLCT). Generalization bound G(R) = lambda(R) log(T)/(2T) + U(R)/sqrt(T) has optimal R* balancing observability vs noise tolerance. U-shaped, parallels #362 CFG and #359 nucleus sampling.

### Bridge 5: Steady-State vs Transient RLCT Gap
Riccati fixed point P* satisfies algebraic Riccati equation: P* = A P* A^T + Q - A P* C^T (C P* C^T + R)^{-1} C P* A^T. System of n(n+1)/2 polynomial equations. Multiple fixed points create fiber structure.

C5 CONJECTURAL: Steady-state KF RLCT determined by multiplicity of Riccati fixed points. Unique positive-definite solution: lambda_ss = d_obs/2 (regular). Multiple solutions: lambda_ss > d_obs/2. Gap lambda_transient - lambda_ss quantifies price of transience.

## Distinction from #873 HMM
| Property | HMM (#873) | Kalman Filter (#883) |
|----------|-----------|---------------------|
| Hidden state | Discrete (K states) | Continuous (R^n) |
| Transition | Stochastic matrix | Linear + Gaussian noise |
| Non-identifiability | Permutation symmetry S_K | Subspace degeneracy |
| Stratum selector | K (discrete) | R (continuous) |
| Phase transition | Emission probability p* | Riccati convergence t* |
| Singularity type | Algebraic (simplex) | Semi-algebraic + analytic |

## Claims
| Claim | Description | Status |
|-------|-------------|--------|
| C1 | R_an,exp-definability of KF likelihood | PROVEN |
| C2 | Unobservable subspace fiber RLCT = (n - rank(O))/2 | CONJECTURAL |
| C3 | Riccati convergence phase transition at t* | CONJECTURAL |
| C4 | Measurement noise R as continuous stratum selector, U-shaped gen bound | CONJECTURAL |
| C5 | Steady-state Riccati multiplicity creates fixed-point fiber | CONJECTURAL |

## Key Novelty
1. Continuous subspace degeneracy: fiber is linear subspace (kernel of O), not discrete permutation or algebraic variety.
2. Riccati equation as dynamical singularity generator: rational map on PD matrices, convergence reduces effective parameter dimension.
3. Triple singularity structure: observability rank deficiency (algebraic) + Gaussian determinant poles (analytic) + Riccati fixed-point multiplicity (semi-algebraic).

## Open Problems
1. Exact RLCT of unobservable subspace: does dynamics (A matrix) modify (n-r)/2?
2. Riccati convergence t*: sharp or gradual? Depends on eigenvalue gap of A?
3. Multiple Riccati fixed points: conditions for existence and RLCT contribution?
4. Extended KF (EKF) and Unscented KF (UKF): how does nonlinearity change singular structure?
5. Connection to #169 dropout: dropout as stochastic observation masking?
6. Particle filter (non-parametric): same observability fiber or different?
7. Steady-state KF as algebraic variety: is Riccati solution set irreducible?

## Cross-References
#873 (HMM), #882 (NB), #485 (RLT), #872 (k-means), #268 (GMM/EM), #362 (CFG), #359 (nucleus), #169 (dropout), #570 (randomized smoothing), #134 (RNN)

## Status: L0 COMPLETE
Next: L1 formalization (D1-D7 definitions, C1-C5 formal statements).
