# Synthesis #487: Binary/Ternary Neural Networks × RLCT — L1 Formalization

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Formal Definitions

### D1: Finite Parameter Space
Let the BNN parameter space be Theta_b = {-2^(b-1), ..., 2^(b-1)-1}^d, where b is the bit-width (b=1: binary {-1,+1}, b=2: ternary extended to 4 levels, etc.). For binary: |Theta_1| = 2^d. For k-bit: |Theta_b| = (2^b)^d. The variety V(Theta_b) is 0-dimensional — a finite set of isolated points in R^d.

### D2: Counting Measure Posterior
The discrete posterior over Theta_b is:
  p_b(w | D_n) = exp(-n K_n(w)) phi_b(w) / Z_b(n)
where Z_b(n) = Sum_{w in Theta_b} exp(-n K_n(w)) phi_b(w) is the counting-measure partition function (replacing the Lebesgue integral of continuous Watanabe theory). Here K_n(w) = (1/n) Sum_{i=1}^n L(f_w(x_i), y_i) is the empirical loss, and phi_b is a discrete prior (e.g., uniform = 1/|Theta_b|).

### D3: Discrete Free Energy
F_b(n) = -log Z_b(n) = -log Sum_{w in Theta_b} exp(-n K_n(w)) phi_b(w)

The discrete RLCT lambda_d is defined by the asymptotic expansion:
  F_b(n) ~ lambda_d * log(n) + O(1)  as n -> infinity
In the discrete setting, lambda_d is determined by the combinatorial structure of near-optimal configurations. Specifically, if M_delta = |{w in Theta_b : K(w) <= delta}| is the counting function of near-optimal configurations, then:
  lambda_d = lim_{delta->0} log(M_delta) / log(1/delta)  (when this limit exists)
This is the DISCRETE analogue of the RLCT, replacing the volume exponent with a counting exponent.

### D4: STE Phantom Loss
The Straight-Through Estimator defines a continuous surrogate:
  L_STE(w_cont) = L_discrete(Q_b(w_cont))
where Q_b: R^d -> Theta_b is the quantization function (sign for binary, round for k-bit), and the gradient is:
  nabla_{w_cont} L_STE = nabla_{w_cont} L_discrete(Q_b(w_cont))
using the STE approximation nabla Q_b ≈ 1 (identity). The phantom loss L_STE is piecewise constant on quantization cells C_sigma = {w_cont : Q_b(w_cont) = sigma} for sigma in Theta_b.

### D5: Orthant/Cell Decomposition
For binary BNN, each quantization cell C_sigma is an orthant {w_cont : sign(w_cont) = sigma}. For k-bit, each cell is a hypercube of side 2^(-b+1). The STE phantom loss defines a continuous function on R^d that is constant on each cell. The singular fiber of L_STE at level epsilon is:
  V_STE(epsilon) = Union_{sigma: K(sigma) <= epsilon} C_sigma
This is a union of full-dimensional cells — the phantom geometry INFLATES each discrete point to a cell of dimension d.

### D6: Effective Bit-Width RLCT
The effective RLCT as a function of bit-width:
  lambda_eff(b) = lambda_d(b)  for small b (discrete regime)
  lambda_eff(b) -> lambda_cont  as b -> infinity (continuous regime)
where lambda_cont is the classical Watanabe RLCT of the underlying continuous network architecture.

The transition point b* is defined by:
  lambda_d(b*) = lambda_cont
or more precisely, the point where the discrete counting structure and continuous geometric structure contribute equally to the free energy.

### D7: Finite Class Generalization Bound
Since |Theta_b| = (2^b)^d is finite:
  G_b(n) <= (log |Theta_b|) / n = (b * d) / n  (Occam/PAC bound)

The RLCT-refined bound:
  G_b(n) <= C * min(b*d/n, lambda_eff(b)/n + epsilon/sqrt(n))
where the first term is the combinatorial (capacity) bound and the second is the geometric (RLCT) bound. The minimum selects whichever is tighter.

## Formal Claims

### C1 (PROVEN): Discrete Watanabe Definability
The BNN loss K(w) for w in Theta_b is trivially R_an,exp-definable because Theta_b is a finite set and any function on a finite set is definable in any o-minimal structure. The discrete free energy F_b(n) is a finite sum of definable terms. Q.E.D.

### C2 (CONJECTURAL): STE Phantom Geometry Inflation
The STE surrogate L_STE(w_cont) = L_discrete(Q_b(w_cont)) is piecewise constant on quantization cells. The phantom RLCT lambda_STE satisfies:
  lambda_STE >= lambda_d
because V_STE(epsilon) = Union of cells has volume >= (2^(-b+1))^d * M_epsilon, inflating each point to a d-dimensional cell. The phantom geometry provides an UPPER BOUND on the true discrete complexity.

### C3 (CONJECTURAL): Bit-Width Phase Transition
There exists a critical bit-width b* such that:
  - For b < b*: lambda_eff(b) ≈ d (trivial, capacity-limited)
  - For b = b*: optimal tradeoff, lambda_eff minimized
  - For b > b*: lambda_eff(b) -> lambda_cont (continuous RLCT)
The function lambda_eff(b) is U-shaped with minimum at b*. The crossover from discrete-dominated to continuous-dominated occurs at b*.

### C4 (CONJECTURAL): Refined Generalization Bound
The generalization gap G_b(n) for BNNs satisfies:
  G_b(n) <= C * min(b*d/n, lambda_eff(b)/n + U/sqrt(n))
where U depends on the loss function's boundedness. At optimal b*, this interpolates between the PAC bound (capacity) and the Watanabe bound (geometry).

### C5 (CONJECTURAL): SGLD Observable Phase Transition
SGLD on the STE surrogate loss at different bit-widths b should reveal:
  - Low b: LLC flat (combinatorial regime, b-independent)
  - At b*: LLC kink (phase transition)
  - High b: LLC decreases with b (continuous regime, b-dependent)
The LLC measured via SGLD on L_STE provides an empirical probe of lambda_eff(b).

## Open Problems
1. Formalize the counting exponent lambda_d as a limit — existence and computability
2. Relate lambda_d to the combinatorial structure of the Boolean function class
3. Prove or disprove lambda_STE >= lambda_d rigorously
4. Characterize b* as a function of d, n, and the target function complexity
5. Connection to VC dimension and Rademacher complexity of the binary class
6. Ternary (b=1.58) vs binary (b=1): is the jump discontinuous or smooth?
7. Impact of weight initialization distribution on the phantom geometry

## Cross-References
#8 (ReLU singularity), #16 (permutation symmetry), #100 (transformer RLCT), #127 (MoE L0), #169 (dropout), #222 (spectral norm), #244 (post-training quantization), #319 (mixed precision), #354 (STE), #470 (QAT), #473 (spectral norm full), #486 (MoE)

## Status
L1 COMPLETE. Next: L2 novelty verification.
