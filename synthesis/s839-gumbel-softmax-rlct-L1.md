# Synthesis #839: Gumbel-Softmax (Concrete Distribution) x RLCT - L1 Formal Definitions
# Date: 2026-11-03
# Pipeline: L0 COMPLETE (s839-gumbel-softmax-rlct-L0.md) | L1 formalization

## D1: Gumbel-Softmax Output Function
Let K >= 2 be the number of categories, pi(w,x) = (pi_1,...,pi_K) in Delta^{K-1} be the
parametric probability vector (e.g., from softmax of network logits), tau > 0 be temperature.
Gumbel noise: g_i ~ Gumbel(0,1), i.e., g_i = -log(-log(u_i)), u_i ~ Uniform(0,1).
Gumbel-Softmax output:
  y_i(w, x, g, tau) = exp((log(pi_i(w,x)) + g_i) / tau) / sum_{j=1}^K exp((log(pi_j(w,x)) + g_j) / tau)
As tau -> 0: y converges pointwise to one-hot(argmax_i(log(pi_i) + g_i)).
As tau -> infinity: y converges to uniform (1/K,...,1/K).

## D2: Concrete Distribution Density
The Concrete distribution (Maddison et al. 2016) has density on the simplex interior:
  p(y | pi, tau) = Gamma(K) * tau^{K-1} * prod_{i=1}^K (pi_i * y_i^{-tau-1}) / (sum_{i=1}^K (pi_i * y_i^{-tau})^K
This is a definable function of (y, pi, tau) on the domain y_i > 0, sum y_i = 1, tau > 0, pi_i > 0.
The log-density log p(y | pi, tau) involves: Gamma constant, polynomial in tau, products of pi_i and
y_i powers, and log of a sum of powers. All components are in R_{an,exp} (polynomial, exp, log, division).

## D3: Expected Loss Function
For training data {(x_n, t_n)} and network parameters w in R^d:
  L_tau(w) = (1/N) sum_{n=1}^N E_{g ~ Gumbel(0,1)^K} [ l(y(w, x_n, g, tau), t_n) ]
where l is cross-entropy or MSE. By Fubini (finite N, bounded integrand on compact parameter domain):
  L_tau(w) = integral_{[0,1]^K} l(y(w, x, -log(-log(u)), tau), t) du
The integrand is R_{an,exp}-definable in (w, u, tau) since:
  - u -> -log(-log(u)) is definable on (0,1) (log composed with log, restricted domain)
  - y(w,x,g,tau) involves exp, division, log -- all definable
  - l(y,t) is polynomial + log (cross-entropy) -- definable
By the definable integration theorem (Loi, Watanabe), L_tau is R_{an,exp}-definable in w.

## D4: Temperature-Indexed Zero-Loss Fiber
For each tau > 0, define:
  V(tau) = { w in R^d : L_tau(w) = L_tau^* }
where L_tau^* = inf_w L_tau(w). By definability (D3), V(tau) is a definable set.
At tau = 0 (limit), the loss becomes:
  L_0(w) = (1/N) sum_n l(argmax_i(log(pi_i(w,x_n)) + g_i), t_n) averaged over g
This is piecewise-constant in w (combinatorial structure from argmax), defining a union of
polyhedral strata V_0 = union_{sigma} V_sigma, where sigma ranges over discrete assignments.
Each V_sigma = {w : argmax_i(log(pi_i(w,x_n)) + g_i) = sigma_n for all n} is a semi-algebraic set.

## D5: Temperature as Stratum Selector
The family {V(tau)}_{tau>0} defines a continuous deformation of singular fibers:
- tau large: V(tau) approximates {w : pi(w,x) = t/N for all x} (uniform fiber, low complexity)
- tau small: V(tau) approximates V_0 (combinatorial fiber, high complexity)
- Intermediate: V(tau) is a smoothed interpolation between these regimes
Conjecture: lambda(tau) (RLCT of V(tau)) is monotonically non-decreasing as tau -> 0,
with lambda(tau) -> lambda_0 (discrete RLCT) as tau -> 0.
Critical temperature tau* where strata begin to separate: conjectured tau* ~ O(1/K).

## D6: Generalization Bound with Temperature-Dependent RLCT
  E[L_test^tau] <= E[L_train^tau] + C * sqrt( lambda(tau) * log(n) / n ) + b(tau)
where:
- lambda(tau) is the RLCT of V(tau)
- b(tau) is a bias term measuring the discretization gap:
    b(tau) = |L_0(w*) - L_tau(w*)| for the optimal w*
  b(tau) -> 0 as tau -> 0 (relaxation becomes exact) but b(tau) -> L_0 - L_uniform as tau -> inf
- Optimal tau_opt minimizes lambda(tau)*log(n)/(2n) + b(tau):
    Too small tau: high lambda (combinatorial complexity)
    Too large tau: high b (loss of categorical structure)
  Interior optimum exists when both terms are non-trivial.

## D7: Annealing Schedule as Temporal Stratum Curriculum
Given annealing schedule tau(t) for t in [0,T], define the temporal RLCT trajectory:
  lambda_traj(t) = lambda(tau(t))
The annealing creates a curriculum: early training (high tau) explores smooth low-lambda fibers,
late training (low tau) commits to discrete high-lambda fibers.
Conjecture: optimal schedule satisfies tau(t) ~ tau* * (1 - t/T)^{alpha} where
  alpha = 1/(1 + lambda_0) (derived from free energy balance at phase transition).
SGLD detectability: LLC shows a kink/step when tau(t) crosses tau*.

## Claim Status

C1 PROVEN: L_tau is R_{an,exp}-definable in w.
  - Gumbel noise -log(-log(u)) is definable on (0,1)^K
  - y(w,x,g,tau) is exp/division/log composition -> definable
  - Cross-entropy l(y,t) is polynomial + log -> definable
  - Finite sum of definable integrals -> definable by Loi theorem
  - Finite RLCT follows from resolution of singularities for definable functions

C2 CONJECTURAL: V(tau) has temperature-dependent singular structure.
  - tau -> 0: combinatorial strata (finite union of polyhedral regions)
  - tau > 0: smoothed deformation, definable variety
  - lambda(tau) monotonically non-decreasing as tau -> 0 (UNPROVEN)
  - Gap: monotonicity requires controlling how Gumbel-Softmax smoothing affects
    the singularity order; no existing theorem covers this

C3 CONJECTURAL: tau as continuous stratum selector with phase transition at tau*.
  - tau* ~ O(1/K) conjectured from simplex geometry
  - Phase transition: lambda(tau) jumps or has a kink at tau*
  - Gap: existence of sharp phase transition (vs smooth crossover) unproven
  - SGLD testability: LLC estimation should show transition

C4 CONJECTURAL: Temperature-dependent generalization bound.
  - G(n,tau) ~ lambda(tau)*log(n)/(2n) + b(tau)
  - b(tau) = discretization gap, vanishes as tau->0
  - Interior optimum tau_opt exists
  - Gap: exact form of b(tau) unknown; coupling between lambda(tau) and b(tau) unclear

C5 CONJECTURAL: Annealing schedule creates temporal stratum curriculum.
  - tau(t) ~ tau* * (1-t/T)^alpha, alpha = 1/(1+lambda_0)
  - Gap: derivation is heuristic (free energy analogy); rigorous connection to
    SGD dynamics and RLCT phase transitions unproven

## Open Problems
1. Formalize V(tau) -> V_0 convergence topology (Hausdorff vs Zariski vs Thom)
2. Compute lambda(tau) explicitly for K=2 binary case (known RLCT achievable?)
3. Is the phase transition at tau* a genuine RLCT jump or smooth crossover?
4. Does Gumbel noise injection create additional singularities beyond discrete model?
5. ST-Gumbel-Softmax: does it inherit BOTH STE C^{-1} singularity AND temperature singularity?
6. Derive optimal annealing schedule from free energy minimization rigorously
7. Multi-level hierarchical Gumbel-Softmax: how do multiple temperatures interact in RLCT?

## Cross-References
#8 (NN RLCT), #16 (depth singularity), #100 (stratum selector), #169 (phase transition),
#224 (label smoothing), #244 (quantization), #258 (mixup interpolation), #354 (STE),
#377 (temperature dial), #433 (PolyLoss degree selector), #486 (MoE routing),
#513/#514/#517 (dials), #539 (focal loss), #647 (denoising noise injection)
