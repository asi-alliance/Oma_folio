# Synthesis #688: Mixture of Experts × RLCT — L1 Formalization

**Date:** 2026-10-28
**Status:** L1 Formalization
**Pipeline:** L0 ✓ → L1 (this file) → L2 → L3 → L4 → L5

---

## Formal Definitions

### D1: Parameter Space

Let W = (θ_r, θ_1, ..., θ_E) where:
- θ_r ∈ R^{d_in × E}: router weight matrix
- θ_i ∈ R^{d_in × d_exp}: i-th expert parameters, i = 1..E

Total parameters: d = d_in·E + E·d_in·d_exp = d_in·E(1 + d_exp).

The router produces logits g(x) = x·θ_r ∈ R^E. Top-k selection: S_k(x) = TopK(g(x), k) ⊂ {1,...,E}.

Routing weights: a_i(x) = softmax(g(x))_i · 1[i ∈ S_k(x)].

MoE layer output: y(x) = Σ_{i=1}^E a_i(x) · f_i(x; θ_i).

### D2: MoE Loss and R_an,exp Definability (C1 PROVEN)

L_MoE(W) = E_{(x,y)~D}[ℓ(y(x), y)] + λ_bal · L_bal(W)

where L_bal(W) = E · Σ_{i=1}^E f_i², f_i = (1/N) Σ_{x} a_i(x).

R_an,exp-definability:
- g(x) = x·θ_r: polynomial → definable
- TopK selection: defined by inequalities {g_i ≥ g_j : j ∉ S_k} → semi-algebraic → definable
- softmax: exp/Σexp → R_an,exp-definable
- f_i: standard neural layer → R_an,exp-definable by induction
- Indicator 1[i ∈ S_k(x)]: semi-algebraic → definable
- Product a_i · f_i: definable × definable → definable
- Sum over E: finite sum of definable → definable
- ℓ: cross-entropy etc → definable
- L_bal: polynomial in f_i → definable

Therefore L_MoE is R_an,exp-definable. By resolution of singularities, λ_MoE < ∞. ∎

### D3: Conditional Singular Fiber (C2 CONJECTURAL)

The standard singular fiber: V = {W : L_MoE(W) = L_min}.

For a fixed input x with active set S_k(x), define the conditional loss:
  L_x(W) = ℓ(Σ_{i∈S_k(x)} a_i(x) f_i(x), y)

The conditional fiber: V_x = {W : L_x(W) = L_min(x)}

V = ∩_x V_x (intersection over all inputs).

For each x, only {θ_i : i ∈ S_k(x)} ∪ {θ_r} participate in L_x. The parameters {θ_j : j ∉ S_k(x)} are in the null space of L_x — they form a "flat direction" in V_x.

Conjecture C2: The effective RLCT is determined by the active-parameter fiber:
  λ_MoE ≈ k · d_in · d_exp + C_router(d_in, E)

where C_router accounts for the router's contribution. This is closer to λ_{k-expert dense} than λ_{E-expert dense}.

### D4: Router as Stratum Selector (C3 CONJECTURAL)

The router partitions input space R^{d_in} into regions R_S = {x : S_k(x) = S} for each k-subset S ⊂ {1,...,E}. There are C(E,k) such regions.

Each region R_S defines a conditional fiber V_S = {W : Σ_{x∈R_S} L_x(W) = L_min(S)} using only experts in S.

The global fiber decomposes: V = ∪_S V_S (restricted union).

Conjecture C3: A well-trained router assigns each input class to the expert subset S minimizing the local RLCT λ_S. The effective RLCT is:
  λ_eff = Σ_S p(S) · λ_S + C_router

where p(S) is the routing probability for stratum S. The router learns optimal stratum assignment.

### D5: Generalization Bound (C4 CONJECTURAL)

Conjecture C4: For MoE with E experts, top-k routing, trained on n samples:
  G_MoE(n) ≈ λ_eff / n + U_routing / √n

where λ_eff = Σ_S p(S)·λ_S + C_router and U_routing captures routing variance across strata.

Key tension: expert collapse reduces λ_eff (fewer active strata) but increases U_routing (under-coverage). This explains why lower λ does not always mean better generalization — collapse creates a low-λ but high-U regime.

### D6: Expert Collapse Fiber (C4 CONJECTURAL)

Expert collapse: ∃ subset A ⊂ {1,...,E}, |A| < E, such that p(S) = 0 for all S ⊄ A.

Collapsed fiber: V_collapse = {W ∈ V : ∀i ∉ A, f_i ≡ 0 (inactive)}.

The collapsed model has effective parameters d_active = |A|·d_in·d_exp + d_router < d.

λ_collapse = λ_{|A|-expert model} < λ_MoE (fewer active parameters).

But generalization degrades: the model under-fits inputs not covered by experts in A. The strata {V_S : S ⊄ A} are empty — the router cannot route to uncovered regions.

### D7: Load Balancing as Desingularizer (C5 CONJECTURAL)

Load balancing loss: L_bal = E · Σ_i f_i², minimized when f_i = 1/E (uniform).

This is a quadratic penalty on the routing distribution {f_i}. It acts as a regularizer pushing the model toward uniform stratum coverage.

Conjecture C5: L_bal desingularizes the routing strata by preventing collapse to the degenerate fiber V_collapse. The load-balanced fiber V_bal = {W : L_MoE + λ_bal·L_bal = L_min} has:
- All strata S populated: ∀S, p(S) > 0
- λ_bal(V_bal) ≥ λ_collapse (more active parameters)
- But U_routing(V_bal) < U_routing(V_collapse) (better coverage)

Optimal λ_bal*: balances stratum coverage (higher λ) against routing specificity (lower U). Predicted phase transition at λ_bal* ~ C/n where C depends on (E, k, d_exp).

## Open Problems

1. Formal λ_MoE = f(E, k, d_exp, routing_arch) derivation via resolution of singularities
2. Router optimality: does learned routing achieve min_S λ_S?
3. Router capacity scaling: does d_router need to scale with E?
4. Soft vs hard routing: dense softmax (all experts) vs top-k — different fibers?
5. Stacked MoE: nested stratum selection across layers — compositional RLCT?
6. Expert capacity / token dropping interaction with routing strata
7. Predicting λ_bal* from SLT: phase transition scaling

## Cross-References

#8 (foundational RLCT), #16 (Watanabe gen bound), #111 (scaling exponents), #155 (gradient noise), #169 (sparse MoE routing), #224 (label smoothing desingularization), #354 (STE/mixed precision), #375 (MoE routing topology), #525 (Entropy-SGD), #609 (gradient noise injection), #686 (token dropping), #687 (gradient checkpointing)
