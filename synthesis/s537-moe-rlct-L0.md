# Synthesis #537: L0 - Mixture of Experts (MoE) × RLCT

## Date
2026-10-23

## Problem Statement

Mixture of Experts (MoE) architectures introduce a gating network G(x;theta_g) that routes input x to a subset of K experts {E_1,...,E_E} via top-k selection. The routing decision partitions input space into regions where different expert subsets are active, creating a piecewise-analytic loss landscape. This partition raises fundamental questions in Singular Learning Theory:

1. **Routing boundary as singularity source**: The gating function g_i(x) = softmax(W_g x)_i produces a top-k decision boundary where g_i = g_{(k)} (the k-th largest logit), which is a piecewise-linear variety in input space and induces a corresponding structure in parameter space.

2. **Expert-specific fibers**: Unlike dense models where all parameters participate, MoE has expert-specific parameter blocks theta_{E_i} that are only active on their assigned inputs. The Fisher information matrix is block-diagonal per expert, creating a fiber structure that depends on the routing partition.

3. **Load balancing as constraint**: The auxiliary load-balancing loss L_aux = alpha * E * sum_i f_i * P_i (where f_i is token fraction and P_i is routing probability) adds a polynomial constraint to the loss, potentially creating new singularities at balanced/unbalanced transitions.

## Prior Coverage Check

- #486 (MoE × RLCT): Catalog entry exists but files lost in disk truncation (2026-10-22). Memory indicates #486 covered MoE at L0-L5 with claims about top-k gating as stratum selector, expert selection as discrete stratum, and RLCT of routing-conditioned singular fibers. This synthesis (#537) must extend beyond #486.

- #504: Selected MoE as candidate but pivoted (files survive for #504 pivot target). The candidate selection notes described top-k gating creating piecewise partition of parameter space with singular strata at routing decision boundaries.

## Key Distinction from #486

#537 focuses on three aspects potentially under-explored in #486:
1. **Load balancing auxiliary loss as independent singularity source**: The polynomial constraint L_aux creates a Lagrangian-like structure where the constraint manifold intersects the loss fibers.
2. **Capacity factor and expert dropout**: Dynamic capacity (c * k tokens per expert) and expert dropout create time-varying routing boundaries — a non-stationary singularity.
3. **MoE scaling laws via RLCT**: The free energy formula with MoE-specific RLCT should predict scaling laws that differ from dense models (expert count E as complexity parameter).

## Definitions

### Gating Function
G(x; theta_g) = softmax(W_g x + b_g) in R^E, where E is expert count.
Top-k routing: active set S(x) = {i : G_i(x) >= G_{(k)}(x)}, the k largest gates.

### Expert Output
y(x) = sum_{i in S(x)} G_i(x) * E_i(x; theta_{E_i})

### Routing Boundary
B_{i,j}(x) = {x : G_i(x) = G_j(x)} — the decision boundary between experts i and j.
In parameter space: B_{i,j}(theta) = {theta : G_i(x; theta_g) = G_j(x; theta_g) for some x in data distribution}

### Load Balancing Loss
L_aux = alpha * E * sum_{i=1}^{E} f_i * P_i
where f_i = (1/N) sum_x 1[i in S(x)], P_i = (1/N) sum_x G_i(x)

## Core Questions

C1: Is the MoE loss function R_{an,exp}-definable despite the top-k discrete selection?
C2: Does the routing boundary B_{i,j} create a singular fiber in parameter space? What is its RLCT?
C3: Does the load balancing auxiliary loss L_aux introduce an independent singularity (constraint manifold intersection)?
C4: Is expert count E a stratum selector (analogous to rank r in LoRA #223, beta in DPO #536)?
C5: Does MoE scaling law (loss ~ N^{-lambda(E)}) differ from dense scaling due to E-dependent RLCT?

## Open Problems
1. Formal definability of top-k selection (argmax is not smooth, but top-k with softmax is piecewise analytic)
2. Characterization of routing boundary variety geometry in parameter space
3. Effect of load balancing constraint on RLCT (Lagrangian singularity)
4. Expert dropout as time-varying stratum — non-stationary RLCT
5. Scaling law prediction: lambda(E) vs lambda_dense
6. Dense-to-sparse MoE transition: RLCT change as routing sparsity increases
7. Expert collapse (all tokens to one expert) as degenerate singularity

## Cross-References
- #486: MoE × RLCT (original, files lost — this extends/refines)
- #504: MoE candidate selection (pivoted, bridge description used here)
- #223: LoRA × RLCT (rank as stratum selector — E as stratum selector analog)
- #536: DPO × RLCT (preference boundary as algebraic variety — routing boundary analog)
- #111: Scaling laws × RLCT
- #498: Mixture-of-Depths × RLCT (adaptive depth, related but distinct)
- #169: Dropout × RLCT (expert dropout connection)
- #519: Head-wise SGLD × RLCT (head routing analogy)
