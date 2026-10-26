# Synthesis #561: Ring Attention × RLCT — L0 Exploration

### Date: 2026-10-23
### Status: L0 (exploration)
### Candidate: Ring Attention × RLCT

---

## Premise

Ring Attention (Liu, Zaharia, Abbeel 2023) distributes self-attention computation across D devices arranged in a ring topology. Each device holds a block of the query, key, and value sequences. Key-value blocks rotate around the ring while each device computes blockwise attention with its local query block against the incoming KV block. Communication and computation are fully overlapped: while device i computes attention with KV block from device i-1, it simultaneously sends its own KV block to device i+1.

The method computes **exact** self-attention — the result is mathematically identical to standard dense attention. The distribution is a scheduling/IO strategy, not an approximation. This is crucial for the RLCT bridge: the function computed is the same, so the singular locus of the loss is unchanged. However, the **blockwise decomposition** introduces a partitioning structure on the attention computation that creates new mathematical structure worth analyzing.

### Key Mathematical Structure

- Sequence of length n is split into D blocks of size b = n/D across D devices
- Each device d holds Q_d, K_d, V_d (local block)
- Ring communication: KV blocks circulate; at step t, device d receives KV block from device (d-1) mod D
- Blockwise attention: A_d = Σ_{t=0}^{D-1} softmax(Q_d · K_{(d+t) mod D}^T / √d_k) V_{(d+t) mod D}
- Online softmax decomposition enables incremental accumulation of attention weights
- The ring topology defines a cyclic group Z_D action on KV blocks

## RLCT Connection

### C1 (Definability):
- Ring attention computes the same function as standard attention: f_att(Q,K,V) = softmax(QK^T/√d_k)V
- The blockwise decomposition is a finite sum of softmax terms — each term is R_{an,exp}-definable
- Online softmax involves running max and running sum — piecewise-analytic, definable in R_{an,exp}
- The composition is definable: R_{an,exp}-definability follows from the equivalence to standard attention

### C2 (Singular Fiber Structure — Blockwise Decomposition):
- Although the function is identical to standard attention, the blockwise computation introduces a **block-diagonal structure** on the intermediate computations
- Each blockwise attention term A_{d,t} = softmax(Q_d · K_{d+t}^T/√d_k) V_{d+t} is a separate definable function
- The sum over t creates a **decomposition of the zero-loss set**: V_0 = {θ : Σ_t L_t(θ) = 0} where each L_t depends on a different KV block
- The cyclic group Z_D acts on the block indices: the loss is invariant under cyclic permutation of blocks
- This symmetry constrains the singular stratum: the true singular locus must respect the cyclic symmetry

### C3 (Phase Transition — Device Count D):
- D (number of devices) controls the block size b = n/D
- As D → 1: single block, standard attention, no ring communication — λ = λ_dense
- As D → n: each block is a single token, maximum decomposition — extreme blockwise
- Phase transition conjecture: at critical D*, the blockwise decomposition creates a **qualitatively different singular fiber structure**
- The cyclic symmetry group Z_D grows with D, potentially increasing the symmetry-enforced codimension of singular strata

### C4 (D as Stratum Selector):
- D acts as a discrete stratum selector — analogous to window size w in #380, sparsity pattern in #545
- Different D values partition the computation differently, creating different intermediate structures
- However, since the final function is identical, the singular locus V_0 is the SAME for all D
- Key subtlety: D does NOT change the RLCT of the loss (unlike #380/#545 which change the function)
- Instead, D changes the **computational structure** — the RLCT bridge here is about how the blockwise decomposition affects optimization dynamics, not the function's expressiveness
- Revised C4: D affects the **effective loss landscape** encountered by gradient-based optimization, not the theoretical V_0

### C5 (Scaling Law):
- Since Ring Attention computes exact attention, the generalization bound is the same: G ≤ λ_dense/n + U/√n
- The novel aspect: communication overhead scales as O(n²/D) per device but the RLCT is D-independent
- Conjecture: training dynamics (convergence rate to singular locus) are affected by D through the blockwise gradient structure
- Optimization scaling: steps to convergence ~ D^α for some α related to the block decomposition's effect on gradient variance

## Key Distinction from Prior Syntheses

- **#134 (Self-Attention)**: Ring Attention computes the SAME function. The bridge is about computational decomposition, not functional change.
- **#292/#499 (Flash Attention)**: Also exact attention with different IO. Flash Attention tiles within a single device; Ring Attention distributes across devices. Both are IO strategies — the RLCT bridge is about how computational structure affects optimization, not the function.
- **#545 (Sparse Attention)**: Changes the function (masking). Ring Attention does NOT change the function.
- **#380 (Sliding Window)**: Changes the function (local attention). Ring Attention is exact.

**Novel angle**: Ring Attention's RLCT bridge is fundamentally different from most prior syntheses because it does NOT change the function. The bridge is through the **computational decomposition's effect on optimization dynamics** — blockwise gradients, cyclic symmetry of the computation, and the discrete parameter D as a computational stratum selector.

## Claims

### C1 (PROVEN): R_{an,exp}-definability
Ring attention computes f = softmax(QK^T/√d_k)V, which is R_{an,exp}-definable (same as #134). The blockwise decomposition expresses this as a finite sum of definable functions, preserving definability.

### C2 (CONJECTURAL): Cyclic Symmetry of Computational Structure
The ring topology induces a Z_D cyclic group action on the blockwise computation. While V_0 is unchanged, the computational structure respects this symmetry, which may constrain the effective gradient flow and intermediate singular structure during optimization.

### C3 (CONJECTURAL): D-Dependent Optimization Phase Transition
At critical device count D*, the blockwise gradient structure may undergo a phase transition in convergence behavior. Below D*: gradients are dominated by within-block interactions. Above D*: cross-block communication via ring rotation dominates.

### C4 (CONJECTURAL): D as Computational Stratum Selector
D selects different computational decompositions of the same function. While V_0 and λ are D-invariant, the optimization trajectory's effective landscape is D-dependent through blockwise gradient variance and communication patterns.

### C5 (CONJECTURAL): Optimization Scaling Law
Training steps to convergence scale as ~D^α where α depends on the block decomposition's effect on gradient noise. The generalization bound remains λ_dense/n + U/√n (function-invariant).

## Cross-References

- #134 (Self-Attention — base function)
- #292 (Flash Attention — single-device IO strategy)
- #499 (Flash Attention v2 — improved tiling)
- #380 (Sliding Window — function-changing attention)
- #545 (Sparse Attention — function-changing masking)
- #302 (Linear Attention — function-changing kernel)
- #538 (Speculative Decoding — two-model coupling)
- #342 (GQA/MQA — KV sharing strategies)

## Open Problems

1. Is the cyclic symmetry Z_D of the blockwise computation detectable in the loss landscape's Hessian spectrum?
2. Does blockwise gradient computation introduce a D-dependent effective noise scale that modifies the Bayesian free energy landscape?
3. Can the online softmax decomposition create spurious intermediate singularities during incremental accumulation?
4. Is there a measurable D* phase transition in SGLD-LLC curves when training with different device counts?
5. How does the ring communication latency (asynchronous updates) affect the effective loss landscape vs the idealized synchronous case?
6. Does the block decomposition's effect on gradient variance create a D-dependent effective RLCT for optimization (distinct from the function's RLCT)?
7. Can the cyclic symmetry be exploited to derive tighter generalization bounds via symmetry-reduced volume computations?
8. Does the equivalence of function (D-invariant V_0) but inequivalence of computation (D-dependent gradients) create a new class of "computational RLCT" distinct from "functional RLCT"?
