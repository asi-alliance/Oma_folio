%233 note: avoids hash-header confusion; see title line
#580: Mamba / Selective SSM x RLCT - L1: Formal Specification
Date: 2026-11-01 (resumed as %840)

## D1: Architecture
Selective SSM layer, state dim N, sequence length L:
 h_t = exp(Delta(x_t) A(x_t)) h_{t-1} + (Delta(x_t) A(x_t))^{-1}(exp(Delta(x_t) A(x_t)) - I) B(x_t) x_t
 y_t = C(x_t)^T h_t + D x_t
where A, B, C, Delta are analytic functions (SiLU-gated linear projections) of input x_t. ZOH discretization: A_bar = exp(Delta A), B_bar = Delta B (first-order) or exact inverse form.

## D2: Cost Function
L(theta) = E_{q(x)} E_{y~p(y|x)} [ -log p_theta(y|x) ], p_theta a softmax over stacked selective SSM layers. K(theta) = L(theta) - L_min.

## D3: Definability (C1, PROVEN)
K is definable in R_{an,exp}: input projections are polynomial maps, SiLU in R_{an,exp}, matrix exponential in R_{an,exp}, rational inverse where det(A_bar) != 0, finite depth composition. Standard Watanabe conditions hold on the domain det(A_bar) != 0.

## D4: True Parameter Set (C2, CONJECTURAL)
W(q, theta-distribution) = { theta : K(theta) = L_min }. Unlike fixed-parameter models, the singularity structure of W depends on input distribution q(x) through A(x), B(x), C(x), Delta(x). Conjectured strata:
 S_id: Delta(x) -> 0 a.s. (identity/pass-through, effectively frozen state)
 S_reset: A(x) -> 0 a.s. (reset regime, degenerate dynamics)
 S_sel: generic selective regime
 S_over: Delta(x) -> inf (state saturation)

## D5: Selectivity-Stratified Loss Family (C3, CONJECTURAL)
Define g = E_x[ Delta(x) ||A(x)||_F ] as global selectivity scale. Conjecture: lambda(g) is non-increasing on [0, g*], with lambda(0) = d/2 (identity stratum, maximum singularity) and lambda(g*) < d/2.

## D6: Generalization Bound (C4, CONJECTURAL)
G(n, g) <= lambda(g)/n + U(g)/sqrt(n), where U(g) grows with selectivity (more input-dependent parameters in effective use). Optimal g*(n) ~ C sqrt(1/n) heuristic.

## D7: Phase Transition (C5, CONJECTURAL)
At g = g*, the minimizer moves from S_id to S_sel and the local RLCT lambda jumps discontinuously. Testable via SGLD LLC estimates on models trained at varying selectivity scales.

## Caveats
1. det(A_bar(x)) = 0 locus unanalyzed; definability restricted to complement.
2. Monotonicity of lambda(g) unproven; may be non-monotonic.
3. Data-conditioned W challenges standard SLT assumption of fixed K map; needs rigorous treatment via jointly extended parameter space (theta, q) or conditional KL.
4. Per-token selectivity aggregation into global lambda undefined formally.
