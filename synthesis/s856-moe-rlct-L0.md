# Synthesis #856: Mixture of Experts (MoE) × RLCT
## L0: Claims and Definitions
## Date: 2026-11-06

### Topic
Mixture of Experts (MoE) — top-k gating, expert selection, load balancing, expert collapse — analyzed through Singular Learning Theory (RLCT).

### Background
MoE layers route tokens to a subset of k experts via a gating network g(x;theta_gate). The top-k selection picks the k highest-scoring experts. Output: y = sum_{i in TopK(g(x))} g_i(x) * E_i(x). Load-balancing auxiliary loss L_balance encourages uniform expert utilization.

### Key Definitions
- D1: Gating function g(x;theta) = softmax(W_gate x + b_gate), producing logits over m experts
- D2: Top-k selection: TopK(g) = set of k indices with highest g_i values. This is a piecewise function — the active set changes discontinuously across gating boundaries.
- D3: Expert capacity: hard limit C on tokens per expert per batch. Tokens exceeding capacity are dropped (zero output). Creates capacity boundary singularity.
- D4: Load-balancing loss: L_balance = m * sum_i f_i * P_i where f_i = fraction of tokens routed to expert i, P_i = mean gate probability for expert i. Auxiliary loss added to task loss: L_total = L_task + alpha * L_balance.
- D5: Expert collapse: degenerate state where most tokens route to few experts. Utilization entropy H_util = -sum_i f_i log(f_i) drops. Counterposed to load-balancing.

### Claims
- C1 (PROVEN): Piecewise analytic definability. Top-k selection is piecewise analytic on regions where the active set is fixed. Each region is an open cone in input/gating space. RLCT applies per-region via piecewise preparation. Definability: piecewise R_{an,exp} (not globally analytic due to discrete selection boundaries).
- C2 (CONJECTURAL): Expert-selection singular fiber — at gating boundaries (where expert i and expert j have equal logits and both are near the k/k+1 threshold), the local Fisher information loses rank in the gating direction. This creates (k+1)-choose-k boundary varieties of codimension 2 (two equal logits at the selection threshold). Distinct from #855 routing non-injectivity (MoE has no iterative feedback; selection is single-pass competitive).
- C3 (CONJECTURAL): Load-balancing auxiliary loss contributes a separate RLCT term. Compound bound: G_MoE ~ [lambda_task + lambda_balance] * log(n)/(2n) + V(k,m)/sqrt(n). The balance term L_balance is smooth (polynomial in f_i, P_i) but creates a bias toward uniform-utilization singularities (where all f_i = 1/m). These are higher-codimension varieties in expert-utilization space.
- C4 (CONJECTURAL): Expert capacity constraint creates capacity-limited singular fibers. When expert i is at capacity C, additional tokens mapped to it are dropped. The effective loss function becomes discontinuous (piecewise with hard boundary). This is analogous to #556 VQ-VAE quantization boundaries but in gating space. Capacity boundary contributes additional RLCT via non-smooth boundary.
- C5 (CONJECTURAL): Expert collapse phase transition — during training, at step t*, expert utilization undergoes transition from balanced (H_util ~ log m) to collapsed (H_util << log m). Order parameter: utilization entropy H_util. SGLD-detectable: LLC spike (balance singularity deactivates), Fisher rank change (in gating directions of collapsed experts), H_util drops sharply. Counter-transition possible (load-balancing recovery).

### Falsifiable Predictions
1. Gating boundary Fisher rank loss: at theta where g_i = g_j = threshold_{k/k+1}, Fisher information matrix loses rank in the (g_i, g_j) plane. Measurable via Hessian eigenvalue analysis.
2. LLC contribution from load balancing: training with vs without L_balance should show different LLC values (lambda_balance > 0 when balance active).
3. Capacity boundary singularity: training with capacity C < n_tokens/m should show higher LLC than C >= n_tokens/m (boundary active vs inactive).
4. Expert collapse transition: H_util should show sharp drop at t*, coinciding with LLC change. SGLD detectable.

### Open Problems
1. Exact RLCT of top-k boundary: is it exactly (m-k)/2 per boundary pair or does the piecewise structure modify it?
2. Interaction between gating boundaries and capacity boundaries: are they independent (additive) or coupled?
3. Expert collapse as phase transition: is it first-order (discontinuous H_util) or second-order (continuous with derivative change)?
4. Optimal k: what k minimizes G_MoE? Connection to expert specialization geometry?
5. Load-balancing loss RLCT: is lambda_balance exactly computable for uniform-utilization fiber?
6. Capacity constraint definability: is the hard capacity boundary subanalytic or merely piecewise?
7. Soft MoE (continuous mixture without top-k) vs hard MoE: does removing top-k eliminate the gating boundary singularity entirely?
8. Expert dropout (random expert deactivation): how does stochastic expert masking interact with the gating boundary structure?
9. Deep MoE (MoE at multiple layers): do gating boundaries at different layers interact multiplicatively or additively?
10. Comparison with #855 capsule routing: both involve expert/capsule selection but via different mechanisms (agreement feedback vs competitive gating). Is the RLCT structure fundamentally different?

### Cross-References
#8 (RLCT basics), #16 (definability), #134 (attention rank degeneracy), #161 (GNN message passing), #233 (Mamba), #394 (SWA), #468 (PPO piecewise), #480 (muP), #505 (weight norm), #530 (MAML bilevel), #556 (VQ-VAE quantization), #605 (Adagrad), #847 (group equivariant), #850 (alpha phase transition), #855 (capsule routing), #853 (DARTS architecture search)

### Next Step
L1: Formalization.