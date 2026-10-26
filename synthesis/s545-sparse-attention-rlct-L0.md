# Synthesis #545: Sparse Attention × RLCT — L0 Exploration

### Date: 2026-10-23
### Status: L0 (exploration)
### Candidate: Sparse Attention × RLCT

---

## Premise

Sparse attention mechanisms (BigBird, Longformer, Sparse Transformer, etc.) replace the dense n×n attention matrix with a masked/sparse variant where each query position attends to only a subset of key positions. The sparsity pattern P ⊆ [n]×[n] defines which entries of the attention matrix are computed; the rest are masked to -∞ before softmax.

The RLCT bridge: the sparsity pattern P acts as a **semi-algebraic constraint** on the attention map, restricting the set of achievable attention distributions. This constrains the singular locus of the loss landscape — the set of parameters achieving zero loss is restricted to those consistent with pattern P. Different patterns P create different singular strata with potentially different RLCT values λ(P).

## Key Distinctions from Prior Syntheses

- **#380 (Sliding Window Attention)**: SWA is a *specific* sparse pattern (band-diagonal). #545 generalizes to *arbitrary* sparsity patterns (local + global + random as in BigBird, strided as in Sparse Transformer, learnable as in NSTransformer).
- **#134 (Self-Attention)**: Full dense attention — no mask constraints. #545 studies the *constrained* version.
- **#302 (Linear Attention)**: Changes the kernel function (φ(Q)φ(K)^T instead of QK^T) but keeps dense connectivity. #545 keeps QK^T but restricts connectivity.
- **#292/#499 (Flash Attention)**: Exact same computation, different IO. #545 changes the *function itself*.

## Formal Sketch

### D1: Sparsity Pattern
Let P ⊆ {1,...,n}² be a binary mask. Entry (i,j) ∈ P means query i attends to key j. The masked attention score is:

  S_P(i,j) = Q_i·K_j/√d  if (i,j) ∈ P,  else -∞

The attention weight matrix A_P = softmax(S_P) has A_P(i,j) = 0 for (i,j) ∉ P.

### D2: Sparse Attention as Constrained Function
Standard attention: f_att(Q,K,V) = softmax(QK^T/√d)V
Sparse attention: f_P(Q,K,V) = softmax(M_P ⊙ (QK^T/√d))V

where M_P is the indicator matrix of P (with -∞ for masked entries).

### D3: Semi-Algebraic Constraint
The pattern P defines a **semi-algebraic set** on the attention matrix: A ∈ {A : A_{ij} = 0 for (i,j) ∉ P, Σ_j A_{ij} = 1}. This is a polytope face of the simplex — a convex set defined by linear equalities and inequalities.

### D4: Singular Locus Under Sparsity
The zero-loss set V_0(P) = {θ : L(f_P(θ)) = 0} is a subset of the unconstrained V_0. The mask P restricts which parameter configurations can achieve zero loss, potentially creating a **smaller singular stratum** with different (possibly lower) RLCT.

### D5: Sparsity Pattern as Stratum Selector
Different patterns P₁, P₂ create different constrained singular loci V_0(P₁), V_0(P₂). The pattern acts as a **discrete stratum selector** — analogous to window size w in #380, but generalized to arbitrary graph structures.

### D6: Pattern Complexity and RLCT
Hypothesis: λ(P) depends on the structure of P. Patterns with more regularity (e.g., banded, block-diagonal) may have lower λ than random patterns due to algebraic structure of the constraint set. The graph-theoretic properties of P (connectivity, diameter, spectral gap) may correlate with RLCT.

### D7: Generalization Bound
Expected generalization bound: G(P) ≤ λ(P)/n + U(P)/√n

where λ(P) is the RLCT of the sparse-attention loss and U(P) accounts for the pattern-induced effective dimension.

## Claims

### C1 (PROVEN): R_{an,exp}-definability
The sparse attention function f_P = softmax(M_P ⊙ (QK^T/√d))V is R_{an,exp}-definable. The mask M_P is a finite union of polynomial equalities/inequalities (semi-algebraic), and softmax is definable in R_{an,exp}. The composition of a definable function with a semi-algebraic restriction is definable.

### C2 (CONJECTURAL): Pattern-Constrained Singular Locus
The singular locus V_0(P) ⊆ V_0 (unconstrained). The mask P creates additional algebraic constraints (A_{ij} = 0 for (i,j) ∉ P) that restrict the fiber structure. The RLCT λ(P) may differ from the dense attention RLCT λ_dense. Specifically, sparser patterns may create **simpler** singular strata (lower λ) if the mask eliminates high-complexity directions in the loss landscape.

### C3 (CONJECTURAL): Pattern Structure as Stratum Selector
The sparsity pattern P acts as a discrete stratum selector. Patterns with algebraic regularity (banded P → #380, block-diagonal P → block sparse) have predictable RLCT structure determined by the geometry of the constraint polytope. Random patterns (BigBird random edges) introduce stochastic constraints that may create a **mixture of strata** with effective λ = weighted combination. The graph-theoretic properties (spectral gap, connectivity) of P correlate with λ(P).

### C4 (CONJECTURAL): Generalization Bound
G(P) ≤ λ(P)/n + U(P)/√n where λ(P) ≤ λ_dense (sparsity reduces effective complexity) but U(P) may increase (pattern-induced bias). The optimal sparsity level trades off λ reduction against U increase. For patterns with |P| = O(n log n) (BigBird), the bound may be O(λ_eff log n / n), better than dense O(λ_dense / n) when λ_eff << λ_dense.

### C5 (CONJECTURAL): Optimal Sparsity Phase Transition
There exists a critical sparsity level s* = |P*|/n² at which the generalization bound is minimized. Below s* (too sparse), U(P) dominates (insufficient connectivity). Above s* (too dense), λ(P) approaches λ_dense (no complexity reduction). The phase transition at s* depends on the data distribution and task structure. SGLD-based LLC estimation can empirically locate s*.

## Open Problems

1. Formal characterization of λ(P) as a function of pattern geometry (spectral gap, algebraic structure)
2. Random vs structured patterns: does randomness in P create a different RLCT regime than algebraic patterns?
3. Learnable sparsity (e.g., learned masks, routing-based patterns) — adaptive stratum selection
4. Interaction with multi-head attention: do different heads with different patterns create a product stratum structure?
5. BigBird universality (Turing-complete) vs RLCT: does universality constrain the minimum λ(P)?
6. Empirical validation: SGLD LLC estimation comparing dense vs sparse attention patterns
7. Hierarchical sparsity (block-sparse within block-sparse) — nested stratum filtration

## Cross-References

#134 (Self-Attention), #302 (Linear Attention), #380 (Sliding Window = special case), #292/#499 (Flash Attention = same function, different IO), #396 (GLA), #485 (RLT), #503 (ALiBi/Perceiver), #529 (Self-Consistency Decoding), #16 (ReLU gating), #8 (grokking)

## Lineage

- Generalizes #380 (Sliding Window Attention × RLCT) from band-diagonal to arbitrary sparsity patterns
- Constrained version of #134 (Self-Attention × RLCT)
- Complementary to #302 (Linear Attention × RLCT) — sparsity vs kernel approximation as two routes to efficient attention
