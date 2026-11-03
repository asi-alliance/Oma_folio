# Synthesis #688: Mixture of Experts × RLCT — L0 Overview

**Date:** 2026-10-28
**Status:** L0 Overview and Claims
**Pipeline:** L0 (this file) → L1 → L2 → L3 → L4 → L5

---

## Background

### Mixture of Experts (MoE)

Mixture of Experts models use a learned router to conditionally activate subsets of parameters for each input token. In a top-k MoE layer, the router produces logits g(x) ∈ ℝ^E (E = number of experts), and the top-k experts are selected. The output is:

  y = Σ_{i ∈ TopK(g(x))} softmax(g(x))_i · f_i(x)

where f_i is the i-th expert (typically an MLP). Only k experts are activated per token, giving sparse conditional computation: the model has E·d parameters but only k·d are used per forward pass.

Key architectural choices: top-k routing (k=1 for Switch Transformer, k=2 for GShard/Mixtral), expert capacity factor (buffer size per expert), and load balancing loss (auxiliary loss to prevent expert collapse).

### RLCT and Singular Learning Theory

Singular Learning Theory (Watanabe) studies models where the Fisher information matrix is degenerate at the true parameter. The Real Log Canonical Threshold (RLCT) λ measures the effective complexity of the singularity and governs generalization: G(n) ≈ λ/n + O(1/√n). Lower λ → better generalization.

The RLCT is determined by the geometry of the singular fiber V = {W : L(W) = L_min}, which decomposes into strata of varying singularity.

## Core Hypothesis: MoE Routing as Stratum Selection

The central observation: MoE routing creates a **conditional singular fiber** — for each input x, only the parameters of the top-k experts participate in the loss. The effective loss landscape for a given token is determined by k·d parameters, not E·d.

This suggests that the **effective RLCT of an MoE model is closer to the RLCT of a k-expert dense model than an E-expert dense model**, even though the total parameter count is E·d. The routing mechanism selects which stratum of the parameter space is active, potentially accessing lower-λ strata.

## Claims

### C1 (PROVEN): MoE loss is R_an,exp-definable → finite RLCT

The MoE loss L_MoE(W) = E_{(x,y)~D}[ℓ(Σ_{i∈TopK(g(x))} softmax(g(x))_i · f_i(x), y)] + λ_bal · L_bal(W) is R_an,exp-definable:
- Router g is a linear projection (polynomial) + top-k selection (semi-algebraic, as top-k is definable by inequalities)
- softmax is analytic
- Experts f_i are R_an,exp-definable (same as standard layers)
- The sum over top-k experts is a piecewise-analytic function (piecewise in which experts are selected)
- Load balancing loss L_bal is polynomial in expert frequencies
- Therefore L_MoE is R_an,exp-definable and λ_MoE < ∞ by resolution of singularities

### C2 (CONJECTURAL): Effective RLCT scales with active experts, not total

For a top-k MoE with E experts, each expert of width d_exp:
- Dense model with E·d_exp parameters: λ_dense ~ E·d_exp (worst case)
- Dense model with k·d_exp parameters: λ_small ~ k·d_exp
- MoE model: λ_MoE ~ k·d_exp + C_router (conjectured)

The router selects the active sub-fiber per token. The effective singular fiber is a union of k-expert sub-fibers, and the RLCT is determined by the most singular active stratum. Conjecture: λ_MoE ≈ λ_{k-expert dense} + routing overhead.

This would explain why MoE models generalize better than dense models with the same total parameter count.

### C3 (CONJECTURAL): Router as optimal stratum selector

The router learns to map inputs to expert subsets. In SLT terms, the router learns to select the stratum (expert subset) with the lowest local loss for each input. This is **learned stratum selection** — the router discovers which sub-fiber each input belongs to.

**Conjecture**: A well-trained router selects the stratum with lowest RLCT for each input class, effectively decomposing the global singular fiber into input-dependent sub-fibers. The effective RLCT is:

  λ_eff = E_x[λ_active(x)] + O(router_complexity)

where λ_active(x) is the RLCT of the active experts for input x.

### C4 (CONJECTURAL): Expert collapse as singular fiber pathology

Expert collapse (all tokens routed to a few experts) corresponds to a degenerate singular fiber where only a subset of experts are ever activated. The collapsed experts' parameters are in a "dead zone" — they exist in the parameter space but never participate in the loss.

**Conjecture**: Expert collapse creates a non-generic singular fiber where the effective parameter space is reduced to the active experts. The RLCT of the collapsed model is λ_collapse = λ_{active experts} < λ_MoE (fewer active parameters), but generalization is worse because the model under-fits (the routing strata are not covering the input distribution). This is a case where lower λ does NOT mean better generalization — the model has insufficient capacity for the data distribution.

### C5 (CONJECTURAL): Load balancing loss as desingularizer

The load balancing auxiliary loss L_bal = E·Σ_i f_i² (where f_i is the fraction of tokens routed to expert i) penalizes uneven expert usage. This regularizer forces all experts to be activated, preventing the stratum selection from collapsing.

**Conjecture**: L_bal acts as a desingularizer on the routing strata — it pushes the model away from the degenerate collapsed fiber and toward a more uniform stratum coverage. The load-balanced model has a higher effective RLCT than the collapsed model (more active parameters) but better generalization because the strata cover the input distribution. This is analogous to label smoothing (#224) preventing collapse to a degenerate solution.

The load balancing coefficient λ_bal controls the trade-off: too low → collapse, too high → uniform routing (defeating the purpose of MoE). There may be an optimal λ_bal* that balances stratum coverage against routing specificity.

## Distinction from Related Work

- **#155/#609 (gradient noise)**: Stochastic perturbation of all parameters. MoE routing is deterministic per-input selection of parameter subsets.
- **#224 (label smoothing)**: Desingularization of the output distribution. MoE load balancing desingularizes the routing distribution.
- **#354 (STE/mixed precision)**: Precision-based stratum selection. MoE routing is input-based stratum selection.
- **#687 (gradient checkpointing)**: Checkpoint count as weak, precision-dependent stratum selector. MoE router as strong, input-dependent stratum selector.
- **#525 (Entropy-SGD)**: Desingularization via entropy regularization. Load balancing is a routing-specific desingularizer.
- **Token dropping (#686)**: Dropping tokens to fit capacity. MoE routing selects which EXPERTS process which tokens.

## Open Problems

1. Formal derivation of λ_MoE as a function of (E, k, d_exp, routing architecture)
2. Does the router truly learn optimal stratum selection, or just heuristic routing?
3. Interaction between router and expert RLCT: does router capacity need to scale with expert count?
4. Soft routing (all experts, weighted) vs hard routing (top-k): different singular fibers?
5. Expert capacity limits (token dropping within MoE): compound stratum effects?
6. MoE depth: stacking MoE layers — nested stratum selection?
7. Can load balancing loss coefficient λ_bal* be predicted from SLT?

## Cross-References

#8 (foundational RLCT), #16 (Watanabe gen bound), #155 (gradient noise), #224 (label smoothing), #354 (STE/mixed precision), #525 (Entropy-SGD), #609 (gradient noise injection), #686 (token dropping), #687 (gradient checkpointing)
