# Synthesis #486: Mixture of Experts (MoE) × RLCT — L0 Exploration

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Seed Topic
Mixture of Experts (MoE) architecture bridged to Singular Learning Theory / Real Log Canonical Threshold (RLCT).

## Architecture Overview
MoE replaces a single feedforward layer with K expert sub-networks and a gating network g(x) that routes input tokens to top-k experts. The composite function is:
  f_MoE(x) = Σ_{i∈topk(g(x))} g_i(x) · E_i(x)
where g(x) = softmax(W_g · x) is the gating function, E_i are expert networks, and top-k selection picks the k highest gating scores.

## Key RLCT Bridge Insight
The gating function g(x) creates PIECEWISE-DEFINABLE routing: the input space is partitioned by semi-algebraic hypersurfaces at expert assignment boundaries {|g_i(x) - g_j(x)| = 0}. Each region routes to a different subset of k experts, defining a different composite loss landscape. This creates:

1. **Expert strata**: Each expert assignment (subset S ⊂ {1..K}, |S|=k) defines a singular stratum — a region of input space where that expert combination is active. The composite loss K(w) restricted to stratum S is definable.

2. **Gating boundary singularity**: At the boundary {|g_i(x) - g_j(x)| = 0}, the active expert set changes. This is a non-analytic switching point — the loss function is continuous (gating weights → 0 smoothly) but its derivative is discontinuous at the boundary. This creates a singular locus.

3. **Top-k discrete selection**: Unlike soft routing (all experts active), top-k hard selection creates a combinatorial partition of input space into C(K,k) regions. Each region has a different effective parameter set, creating different singular fibers V_0^(S).

4. **Load balancing auxiliary loss**: The auxiliary loss L_aux = K · Var(p_1..p_K) (where p_i = fraction of tokens routed to expert i) adds a polynomial constraint that penalizes uneven routing. This creates an additional singularity at balanced routing manifolds.

5. **Capacity factor constraint**: Hard capacity limits (dropping tokens when expert is full) create a non-smooth truncation — a definable but non-analytic boundary in the data-dependent loss.

## Candidate Claims

- **C1**: The MoE composite loss K(w) is R_an,exp-definable (gating softmax + expert MLPs + top-k selection + auxiliary loss all definable).
- **C2**: Each expert assignment stratum S has a distinct singular fiber V_0^(S), with RLCT λ_S depending on which experts are active. Expert specialization → fiber specialization.
- **C3**: Gating boundary {|g_i - g_j| = 0} creates a singular locus where the RLCT transitions. K experts → C(K,k) strata, λ varies across strata. Load-balanced regime (uniform gating) vs collapsed regime (one expert dominant) = phase transition.
- **C4**: Generalization bound G(n) ≤ C·λ_eff/n where λ_eff is the effective RLCT across all strata, weighted by routing probabilities. More experts K → more strata → potentially lower λ_eff (specialization) but higher combinatorial complexity.
- **C5**: Critical number of experts K* exists as phase transition — below K* underutilization (few strata, high λ), above K* routing collapse or fragmentation (high combinatorial complexity, λ_eff saturates or increases).

## Novel Mechanisms
- Expert-as-fiber: Each expert defines a separate singular fiber, and the gating network selects which fiber is active — this is a DATA-DEPENDENT stratum selector (unlike #435 beam search where beam width K is fixed).
- Gating boundary as singular locus: The softmax gating creates smooth transitions but top-k creates hard switching — the interplay generates a hybrid smooth/piecewise singularity.
- Load balancing as regularization singularity: The auxiliary loss constrains the routing distribution, creating a balanced-routing manifold that is itself a singular stratum.

## Overlap Check
- #435 (Beam Search): Top-k in TOKEN space vs MoE top-k in EXPERT/parameter space. Different mechanism. DISTINCT.
- #342 (GQA): Groups query heads, no routing/gating. DISTINCT.
- #485 (RLT): Recurrent weight sharing vs expert specialization. DISTINCT.
- #258 (Mixup): Input interpolation vs expert routing. DISTINCT.

## Status
L0 COMPLETE. Next: L1 formalization.
