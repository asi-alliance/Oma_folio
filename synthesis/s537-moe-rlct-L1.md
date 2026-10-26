# Synthesis #537: L1 - MoE × RLCT Formalization

## Date
2026-10-23

## D1: MoE Loss Function

Given input x, the MoE output is:

y(x) = sum_{i in S(x)} G_i(x; theta_g) * E_i(x; theta_{E_i})

where S(x) = top-k indices of G(x;theta_g) = softmax(W_g x + b_g).

The total loss is:

L(theta) = (1/N) sum_{n=1}^{N} l(y(x_n), y_n) + alpha * E * sum_{i=1}^{E} f_i * P_i

where:
- l is the task loss (e.g., cross-entropy)
- f_i = (1/N) sum_n 1[i in S(x_n)] (token fraction for expert i)
- P_i = (1/N) sum_n G_i(x_n) (mean gate probability for expert i)
- alpha is the load balancing coefficient

## D2: Piecewise-Analytic Structure

The top-k selection S(x) partitions input space into regions:

R_S = {x : G_{i_1}(x) >= G_{i_2}(x) >= ... >= G_{i_k}(x) >= G_j(x) for all j not in S}

for each k-subset S = {i_1,...,i_k}. Each region R_S is a semi-algebraic set defined by linear inequalities in x (since G is linear in x before softmax).

On each region R_S, the loss is analytic in theta (sum of k analytic expert outputs). The full loss is piecewise-analytic: L = L_S on R_S for each S.

## D3: R_{an,exp}-Definability (Claim C1)

Theorem: L(theta) is R_{an,exp}-definable.

Proof sketch:
- softmax: R_{an,exp}-definable (exp and division)
- top-k selection: the indicator 1[i in S(x)] can be written as a composition of sign functions of differences G_i - G_j, and sign is subanalytic (R_{an}-definable)
- The piecewise structure: L = sum_S 1_{R_S}(x) * L_S(theta) where 1_{R_S} is definable as sign(G_i - G_j) compositions
- Load balancing loss L_aux is polynomial in G_i and f_i, both definable
- Therefore L is R_{an,exp}-definable as a finite sum of definable functions on definable sets

This extends #307's definability claim (if #307 made it) by including the load balancing term explicitly.

## D4: Routing Boundary Variety (Claim C2)

The routing boundary between experts i and j is:

B_{i,j}(x) = {x in R^d : G_i(x;theta_g) = G_j(x;theta_g)}

Since G_i - G_j = (softmax(W_g x + b_g))_i - (softmax(W_g x + b_g))_j, this is an analytic hypersurface in x for fixed theta_g.

In parameter space (fixed x), the boundary:

B_{i,j}(theta_g) = {theta_g : G_i(x;theta_g) = G_j(x;theta_g) for data-distributed x}

is the zero set of an analytic function in theta_g. This is an analytic variety (not necessarily algebraic due to softmax/exponential, but R_{an,exp}-definable variety).

The routing partition induces a stratification of parameter space:

Theta = union_S Theta_S, where Theta_S = {theta : for all n, x_n in R_S(x_n; theta_g)}

Each stratum Theta_S corresponds to a fixed routing assignment across all training tokens. Within each stratum, the loss is analytic. Across strata, the loss changes form.

## D5: Expert-Specific Fiber Structure (Claim C2 continued)

For a fixed routing assignment S(x_n) for all n, the Fisher information matrix I(theta) is block-structured:

I(theta) = diag(I_{E_{S(x_1)}}, ..., I_{E_{S(x_N)}}, I_g)

where I_{E_i} depends only on theta_{E_i} and the inputs routed to expert i, and I_g depends on the gating parameters.

If expert i receives no tokens (expert collapse), then I_{E_i} = 0 — the parameters theta_{E_i} are in the fiber (zero Fisher information = non-identifiable direction). This is a singularity: the loss is flat along theta_{E_i} for collapsed experts.

The fiber of the MoE loss map Phi: theta -> L is:

F_L = {theta' : L(theta') = L(theta)} subset union_S Theta_S

This fiber can cross routing boundaries (changing S) while maintaining the same loss, creating a non-trivial topology.

## D6: Load Balancing Constraint Singularity (Claim C3)

The auxiliary loss L_aux = alpha * E * sum_i f_i * P_i constrains the routing distribution. Consider the effective loss:

L_eff = L_task + L_aux

The constraint manifold C = {theta : f_i = f_j for all i,j} (balanced load) is an algebraic variety in the routing statistics. When the optimizer crosses C (from balanced to unbalanced or vice versa), L_aux changes character:

- Balanced: gradient of L_aux ~ 0 (already balanced)
- Unbalanced: gradient of L_aux pushes toward balance

This creates a constraint-induced singularity analogous to Lagrangian singularities in constrained optimization. The RLCT of L_eff near C may differ from the RLCT of L_task alone.

Formally: if lambda_task is the RLCT of L_task and lambda_aux is the RLCT contribution from L_aux, then:

lambda_eff = lambda_task + lambda_aux (conjectured additive composition, analogous to #536 C5)

But this composition is CONJECTURAL (same gap as #536 — needs proof or toy model).

## D7: Expert Count as Stratum Selector (Claim C4)

Expert count E plays a role analogous to:
- Rank r in LoRA (#223): controls capacity/fiber dimension
- Beta in DPO (#536): controls boundary sharpness
- Temperature tau in temperature scaling (#531): controls distribution sharpness

Increasing E (more experts):
1. Increases parameter dimension d (more parameters)
2. Increases routing boundary complexity (more B_{i,j} pairs: C(E,2) boundaries)
3. Potentially increases fiber dimension (more expert-specific degeneracies)
4. Changes the RLCT lambda(E)

Conjecture: lambda(E) = lambda_dense + g(E) where g(E) captures the routing singularity contribution. For sparse MoE with top-1 routing and balanced load, g(E) may scale as log(E) or E^{1/2} (heuristic, unproven).

The scaling law prediction (C5): loss ~ N^{-lambda(E)} where lambda(E) != lambda_dense. If lambda(E) > lambda_dense, MoE has better sample efficiency; if lambda(E) < lambda_dense, MoE has worse sample efficiency per parameter (but better per-FLOP due to sparsity).

## Cross-References
- #307: MoE RLCT L1 (prior formalization — extends by adding D6 load balancing, D7 stratum selector)
- #381: MoE routing RLCT L1 (prior — extends by expert-specific fiber D5)
- #223: LoRA (rank as stratum selector analogy)
- #536: DPO (additive composition conjecture analogy, boundary variety analogy)
- #111: Scaling laws (E-dependent RLCT prediction)
- #169: Dropout (expert dropout non-stationarity)
- #498: Mixture-of-Depths (adaptive depth, related)
