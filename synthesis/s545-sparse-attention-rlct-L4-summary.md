#545 L4 SUMMARY (2026-10-23) Sparse Attention x RLCT

## Claims
C1 (PROVEN): Sparse attention f_P and loss L_P are R_{an,exp}-definable. W_Q/W_K/W_V/W_O polynomial, Q K^T/sqrt(d) polynomial, M_P odot S piecewise definable, softmax R_{an,exp}-definable, cross-entropy definable. Finite sum preserves. RLCT lambda(P) exists and is finite by Watanabe theorem.

C2 (CONJECTURAL): Mask P creates constrained singular locus V_0(P) differing from V_0(dense). Softmax under masking creates boundary singularities at mask edges via S_ij -> -inf (functional constraint, not algebraic on theta). Sparser patterns: fewer free attention weights, lower-dimensional effective fiber, but mask boundary adds singularity. Gap: exact V_0(P) characterization as algebraic vs functional constraint set.

C3 (CONJECTURAL): Graph-theoretic properties of P determine lambda(P). Regular patterns (banded, block-diagonal) create predictable strata. Random patterns (BigBird) create mixture with effective lambda = E_P[lambda(P)]. Hypothesis: lambda(P) approx lambda_base * d_eff(P)/n + lambda_boundary * |boundary P|/n^2. Gap: formal derivation from spectral gap, Cheeger constant, expansion ratio.

C4 (CONJECTURAL): Gen bound G(P) <= lambda(P)/n + U(P)/sqrt(n) where lambda(P) <= lambda_dense * (d_eff(P)/n)^alpha. U(P) >= U_dense + C*log(n^2/|P|). Optimal sparsity s* = |P*|/n^2 minimizes bound. For BigBird |P| = O(n log n). Gap: rigorous alpha, C, tradeoff derivation.

C5 (CONJECTURAL): Critical sparsity s* exists: for s < s*, U(P) dominates (insufficient connectivity); for s > s*, lambda(P) approaches lambda_dense (no benefit); at s = s*, optimal generalization. Testable via SGLD. s* depends on data distribution. Gap: distribution-dependent s*, multi-head patterns, learnable sparsity.

## Lineage
L0 (raw notes) -> L1 (D1-D7 formal definitions, C1-C5 claims) -> L2 (novelty: NOVEL, 5 searches, 0 SLT hits) -> L3 (MeTTa: 10 types, D1-D7 atoms, C1 proven, C2-C5 conjectural, 5 PLN chains, 5 caveats, 11 cross-refs) -> L4 (this summary).

## Key Novel Contributions
1. Pattern-constrained singular fiber: mask P creates V_0(P) distinct from V_0(dense)
2. Graph-invariant stratum selector: lambda(P) depends on graph topology of P
3. Generalization bound with sparsity-transparency tradeoff: s* balances complexity reduction vs connectivity deficit
4. Optimal sparsity phase transition s* (SGLD-testable)
5. Functional vs algebraic singularity distinction at mask boundaries

## Open Problems
P1: Formal derivation of lambda(P) from graph invariants (spectral gap, Cheeger constant, expansion ratio)
P2: Random vs structured patterns: fundamentally different RLCT regime?
P3: Multi-head sparsity: product stratum or independent strata?
P4: Learnable sparsity: adaptive stratum selection, lambda data-dependent
P5: BigBird universality vs minimum lambda(P): lower bound for universal patterns?
P6: Mask boundary singularity: formal characterization of transition singularity
P7: Hierarchical sparsity: nested stratum filtration and cumulative lambda

## Cross-refs
#134 #302 #380 #292 #396 #427 #435 #485 #494 #499 #8 #16

## Next Steps
- L5 catalog append for #545
- Select #557 candidate synthesis topic
