# Synthesis #826: Mixture of Experts (MoE) × RLCT — L1 Formalization
# Date: 2026-11-03
# Status: L1 DRAFT

## Formal Definitions

**D1 (MoE Architecture):** Let the MoE layer have K experts E_1,...,E_K (each an FFN with parameters θ_i ∈ R^{d_i}) and a router gate g(x; φ) = softmax(W_g x + b_g) with φ = (W_g, b_g) ∈ R^{K·d_in}. For top-k routing, define the active set S(x) = topk(g(x;φ), k) ⊂ {1,...,K}. The MoE output is:

  y(x) = Σ_{i∈S(x)} g_i(x;φ) · E_i(x; θ_i)

**D2 (Composite Loss):** The total MoE loss is:

  L_total(θ, φ) = L_task(θ, φ) + α · L_aux(φ)

where L_task = (1/n) Σ_j ℓ(y(x_j), y_j) with ℓ the task loss (CE or MSE), and L_aux = α · CV(g)² = α · (σ_g/μ_g)² is the load-balancing loss with CV = coefficient of variation of expert assignment frequencies.

**D3 (Routing Regions):** For a fixed k, the input space is partitioned into regions R_σ = {x : S(x) = σ} for each k-subset σ ⊂ {1,...,K}. On each region R_σ, the loss is analytic (sum of k analytic experts weighted by analytic softmax). The boundaries ∂R_σ = {x : g_i(x;φ) = g_j(x;φ) for some i∈σ, j∉σ} are codimension-1 semi-algebraic hypersurfaces (preimages of equality under analytic functions).

**D4 (Singular Fiber):** The zero-loss set V_0 = {(θ,φ) : L_total(θ,φ) = 0} decomposes by routing configuration:

  V_0 = ⋃_σ V_σ, where V_σ = {(θ,φ) : L_σ(θ,φ) = 0 AND routing config σ is active}

Each V_σ is a piece of the fiber corresponding to a specific expert assignment pattern. The full fiber is a union of C(K,k) pieces glued along routing boundaries.

**D5 (Expert Collapse):** An expert i is "collapsed" if P[i ∈ S(x)] → 0 for all x in the data distribution. Collapsed experts have free parameters θ_i (unconstrained by the data loss), creating a degenerate fiber component with local RLCT λ_i = d_i/2 (free parameters = regular model on that subspace).

**D6 (Stratum Selector):** k acts as a discrete stratum selector. Define λ(k) as the RLCT of the MoE loss with top-k routing. At k=K (dense), all experts are always active, routing boundaries vanish, λ(K) = λ_dense (standard dense FFN RLCT). At k=1 (hard routing), each token activates one expert, creating the sharpest piecewise structure and lowest λ(1).

**D7 (Load Balancing as Desingularization):** L_aux = α·CV(g)² penalizes non-uniform routing. At α → ∞, routing is forced uniform (all experts equally likely), eliminating routing boundaries (desingularization). At α = 0, routing is unconstrained, expert collapse possible. The auxiliary loss acts as a regularization term that controls the singular structure, analogous to weight decay (#323) but in routing probability space rather than parameter space.

## C1 Proof (Definability)

**Claim:** L_total(θ,φ) is R_{an,exp}-definable.

**Proof sketch:**
1. The router g(x;φ) = softmax(W_g x + b_g) = exp(W_g x + b_g) / Σ_k exp(W_g x + b_g)_k is a ratio of exp-analytic functions → R_{an,exp}-definable.
2. Top-k selection S(x) = argmax_k(g(x;φ)) is a piecewise operation determined by semi-algebraic inequalities g_i ≥ g_j (after log, these become linear inequalities on W_g x + b_g) → definable.
3. Each expert E_i(x;θ_i) is an analytic function (FFN with ReLU/GELU activations, both definable per #8, #219) → analytic on each routing region.
4. L_task is a composition of definable functions → definable.
5. L_aux = CV(g)² = (σ_g/μ_g)² is a rational function of gate outputs → definable.
6. L_total = L_task + α·L_aux is a sum of definable functions → definable.

By the definability theorem, the RLCT λ is well-defined for L_total. QED.

## C2-C5 Conjectures (Formal Statements)

**C2:** V_0 ≠ ∅. Specifically, the submanifold {(θ,φ) : θ_1 = θ_2 = ... = θ_K (symmetric experts)} ⊂ V_0 when the task is realizable by a single expert, because routing becomes irrelevant. This symmetric fiber has dimension ≥ d_expert (from the shared expert parameters).

**C3 (Formal):** λ(k) is non-increasing in k. For k=1: λ(1) = min_σ λ_σ (most singular routing config dominates). For k=K: λ(K) = λ_dense. Intermediate: λ(k) ≤ λ(k-1) because adding more active experts smooths the piecewise structure.

**C4 (Formal):** Gen(MoE) ≤ √(λ(k)·σ²/n) + C_route, where C_route = E_x[#routing boundary crossings along data manifold]. The routing complexity term counts how often the data distribution crosses expert boundaries, adding to generalization difficulty.

**C5 (Formal):** ∃ k* = O(log K) such that for k < k*, expert collapse creates high-λ regime (collapsed experts contribute d/2 free parameters each), and for k > k*, the system approaches dense computation with λ → λ_dense. At k*, the effective RLCT is minimized.

## Open Problems

1. Exact formula for λ(k) from {λ_σ} and routing entropy H(g)?
2. Does expert specialization (routing entropy decrease during training) constitute an RLCT phase transition?
3. How does λ_MoE scale with K (total experts) at fixed k?
4. Interaction with shared experts (DeepSeek-MoE): does a shared expert fix a stratum, reducing λ?
5. Capacity factor C (hard token limit per expert): does this create a new discrete singularity?
6. Noisy top-k gating (additive noise to logits before selection): stochastic stratum selector?
7. Hierarchical MoE (expert groups): nested singular fibers?
8. Router collapse dynamics: is the collapse path a gradient flow on the singular fiber?

## Cross-References
#8 (ReLU piecewise structure), #100 (dropout stochasticity), #169 (curriculum), #211 (dense MoE), #261 (MoD depth routing), #296 (stochastic depth), #323 (weight decay desingularization), #342 (GQA head grouping), #435 (beam search top-k), #539 (focal loss), #824 (Mamba data-dependent gates), #838 (RAG top-k retrieval), #839 (Gumbel-Softmax temperature)

Next: L2 novelty verification.