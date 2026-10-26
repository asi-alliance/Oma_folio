# Synthesis #545: Sparse Attention x RLCT -- L1 Formalization

### Date: 2026-10-23
### Status: L1 (formalization)
### Pipeline: L0 done L1 done L2 PENDING

---

## Formal Definitions

### D1: Sparsity Pattern
Let n be sequence length, d the head dimension. A sparsity pattern is a set P subset of {1,...,n}^2 (query-key pairs). For each (i,j) in P, query i attends to key j. Define the mask matrix M_P in {0,-inf}^{nxn}:
  M_P(i,j) = 0 if (i,j) in P, -inf otherwise.

### D2: Sparse Attention Function
For parameters theta = (W_Q, W_K, W_V, W_O), the sparse attention output is:
  f_P(theta; x) = softmax(M_P odot (Q dot K^T / sqrt(d))) dot V
where Q = x W_Q, K = x W_K, V = x W_V.
The loss L_P(theta) = (1/N) sum_n ell(f_P(theta; x_n), y_n) with ell = cross-entropy.

### D3: Semi-Algebraic Constraint Structure
The mask M_P defines a semi-algebraic constraint on the attention matrix A = softmax(S):
  A_{ij} = 0 for (i,j) not in P, sum_j A_{ij} = 1 for all i, A_{ij} >= 0.
This is a face of the probability simplex Delta_n restricted to support P_i = {j : (i,j) in P} for each row i. The feasible set is:
  F_P = prod_{i=1}^{n} Delta_{|P_i|}  (product of simplices, one per query row)

### D4: Constrained Singular Locus
The zero-loss set under pattern P:
  V_0(P) = {theta in Theta : L_P(theta) = 0} = {theta : f_P(theta; x_n) = y_n for all n}
Since f_P is a restriction of f_dense (range limited by mask), V_0(P) differs structurally from V_0(dense). V_0(P) may be empty if P is too sparse. The KL divergence K_P(theta) = L_P(theta) - L_P(theta*) has singularities at theta where the softmax saturates on masked boundaries.

### D5: Pattern as Stratum Selector
For two patterns P1, P2 with P1 subset P2 (P1 sparser):
  - f_{P1} is a restriction of f_{P2} (fewer attention entries)
  - V_0(P1) and V_0(P2) are generically DIFFERENT varieties, not nested
  - Pattern topology (graph structure of P) determines the algebraic structure of constraints
Pattern families form a poset under subset. Each pattern selects a stratum structure.

### D6: Effective Pattern Dimension
  d_eff(P) = sum_i |P_i| / n  (average number of keys per query)
For dense attention d_eff = n. For BigBird d_eff = O(log n). For sliding window w, d_eff = w (#380).

### D7: RLCT Under Sparsity
  lambda(P) = RLCT(K_P, theta*) = lim_{t to 0} (log Z_P(t)) / (-2 log t)
where Z_P(t) = integral exp(-K_P(theta)/t) phi(theta) dtheta is the partition function under pattern P.
---
## Claims

### C1 (PROVEN): R_{an,exp}-Definability
f_P and L_P are R_{an,exp}-definable. W_Q, W_K, W_V, W_O are polynomial. Q K^T/sqrt(d) is polynomial. M_P odot S is a finite case selector (definable piecewise). softmax is R_{an,exp}-definable (exp + normalization). V multiplication polynomial. Cross-entropy R_{an,exp}-definable. Finite sum preserves definability. By Watanabe theorem, RLCT lambda(P) exists and is finite.

### C2 (CONJECTURAL): Pattern-Constrained Singular Fiber
The mask P creates constrained singular locus V_0(P) differing from V_0(dense). Softmax under masking creates boundary singularities at mask edges. For (i,j) not in P, A_{ij}=0 via S_{ij} to -inf (functional constraint, not algebraic on theta). Sparser patterns: fewer free attention weights, lower-dimensional effective fiber, but mask boundary adds singularity. Gap: exact characterization of V_0(P) as algebraic vs functional constraint set.

### C3 (CONJECTURAL): Pattern Topology as Stratum Selector
Graph-theoretic properties of P determine lambda(P). Regular patterns (banded, block-diagonal) create predictable strata. Random patterns (BigBird) create mixture with effective lambda = E_P[lambda(P)]. Hierarchical patterns create nested stratum filtration. Hypothesis: lambda(P) approx lambda_base * d_eff(P)/n + lambda_boundary * |boundary P|/n^2. Gap: formal derivation from graph invariants (spectral gap, Cheeger constant, expansion).

### C4 (CONJECTURAL): Generalization Bound
G(P) <= lambda(P)/n + U(P)/sqrt(n) where lambda(P) <= lambda_dense * (d_eff(P)/n)^alpha for alpha > 0, and U(P) >= U_dense + C * log(n^2/|P|). Optimal sparsity s* = |P*|/n^2 minimizes bound. For BigBird |P| = O(n log n), s = O(log n / n). Gap: rigorous alpha, C, tradeoff derivation.

### C5 (CONJECTURAL): Optimal Sparsity Phase Transition
Critical sparsity s* exists: for s < s*, U(P) dominates (insufficient connectivity); for s > s*, lambda(P) approaches lambda_dense (no benefit); at s = s*, optimal generalization. Testable via SGLD-based LLC estimation. s* depends on data distribution. Gap: distribution-dependent s*, multi-head patterns, learnable sparsity.

---
## Open Problems

1. Formal derivation of lambda(P) from graph invariants (spectral gap, Cheeger constant, expansion ratio)
2. Random vs structured patterns: does stochastic P create fundamentally different RLCT regime?
3. Multi-head sparsity: do different heads with different patterns create product stratum or independent strata?
4. Learnable sparsity (NSTransformer, learned masks): adaptive stratum selection -- lambda becomes data-dependent
5. BigBird universality (Turing-complete) vs minimum lambda(P): is there a lower bound lambda(P) >= lambda_min for universal patterns?
6. Mask boundary singularity: formal characterization of the transition singularity at boundary of P
7. Hierarchical sparsity (block-sparse within block-sparse): nested stratum filtration and cumulative lambda

## Cross-References

#134 (Self-Attention), #302 (Linear Attention), #380 (Sliding Window = special case banded P), #292/#499 (Flash Attention = same function different IO), #396 (GLA), #485 (RLT), #427 (ALiBi), #435 (Beam Search top-k strata), #494 (Activation Sparsification), #8 (grokking), #16 (ReLU gating)

## Lineage
- Generalizes #380 (Sliding Window Attention x RLCT) from band-diagonal to arbitrary sparsity patterns
- Constrained version of #134 (Self-Attention x RLCT)
- Complementary to #302 (Linear Attention x RLCT): sparsity vs kernel approximation
- Related to #494 (Activation Sparsification): sparsity in attention weights vs activations
---
## Claims

### C1 (PROVEN): R_{an,exp}-Definability
f_P and L_P are R_{an,exp}-definable. W_Q, W_K, W_V, W_O are polynomial. Q K^T/sqrt(d) is polynomial. M_P odot S is a finite case selector (definable piecewise). softmax is R_{an,exp}-definable (exp + normalization). V multiplication polynomial. Cross-entropy R_{an,exp}-definable. Finite sum preserves definability. By Watanabe theorem, RLCT lambda(P) exists and is finite.

### C2 (CONJECTURAL): Pattern-Constrained Singular Fiber
The mask P creates constrained singular locus V_0(P) differing from V_0(dense). Softmax under masking creates boundary singularities at mask edges. For (i,j) not in P, A_{ij}=0 via S_{ij} to -inf (functional constraint, not algebraic on theta). Sparser patterns: fewer free attention weights, lower-dimensional effective fiber, but mask boundary adds singularity. Gap: exact characterization of V_0(P) as algebraic vs functional constraint set.

### C3 (CONJECTURAL): Pattern Topology as Stratum Selector
Graph-theoretic properties of P determine lambda(P). Regular patterns (banded, block-diagonal) create predictable strata. Random patterns (BigBird) create mixture with effective lambda = E_P[lambda(P)]. Hierarchical patterns create nested stratum filtration. Hypothesis: lambda(P) approx lambda_base * d_eff(P)/n + lambda_boundary * |boundary P|/n^2. Gap: formal derivation from graph invariants (spectral gap, Cheeger constant, expansion).

### C4 (CONJECTURAL): Generalization Bound
G(P) <= lambda(P)/n + U(P)/sqrt(n) where lambda(P) <= lambda_dense * (d_eff(P)/n)^alpha for alpha > 0, and U(P) >= U_dense + C * log(n^2/|P|). Optimal sparsity s* = |P*|/n^2 minimizes bound. For BigBird |P| = O(n log n), s = O(log n / n). Gap: rigorous alpha, C, tradeoff derivation.

### C5 (CONJECTURAL): Optimal Sparsity Phase Transition
Critical sparsity s* exists: for s < s*, U(P) dominates (insufficient connectivity); for s > s*, lambda(P) approaches lambda_dense (no benefit); at s = s*, optimal generalization. Testable via SGLD-based LLC estimation. s* depends on data distribution. Gap: distribution-dependent s*, multi-head patterns, learnable sparsity.

---
## Open Problems

1. Formal derivation of lambda(P) from graph invariants (spectral gap, Cheeger constant, expansion ratio)
2. Random vs structured patterns: does stochastic P create fundamentally different RLCT regime?
3. Multi-head sparsity: do different heads with different patterns create product stratum or independent strata?
4. Learnable sparsity (NSTransformer, learned masks): adaptive stratum selection -- lambda becomes data-dependent
5. BigBird universality (Turing-complete) vs minimum lambda(P): is there a lower bound lambda(P) >= lambda_min for universal patterns?
6. Mask boundary singularity: formal characterization of the transition singularity at boundary of P
7. Hierarchical sparsity (block-sparse within block-sparse): nested stratum filtration and cumulative lambda

## Cross-References

#134 (Self-Attention), #302 (Linear Attention), #380 (Sliding Window = special case banded P), #292/#499 (Flash Attention = same function different IO), #396 (GLA), #485 (RLT), #427 (ALiBi), #435 (Beam Search top-k strata), #494 (Activation Sparsification), #8 (grokking), #16 (ReLU gating)

## Lineage
- Generalizes #380 (Sliding Window Attention x RLCT) from band-diagonal to arbitrary sparsity patterns
- Constrained version of #134 (Self-Attention x RLCT)
- Complementary to #302 (Linear Attention x RLCT): sparsity vs kernel approximation
- Related to #494 (Activation Sparsification): sparsity in attention weights vs activations
