# Synthesis #607: AdaFactor × RLCT — L4 Summary
## Date: 2026-10-25
## Status: L4 SUMMARY (Pipeline L0-L4 Complete)

## C1 (PROVEN): R_an,exp Definability
AdaFactor's factored update map (row-EMA + col-EMA + rank-1 inv-sqrt preconditioner) is definable in the real-analytic category. All component functions (EMA, outer product, entrywise inv-sqrt, Hadamard product) are real-analytic away from zero entries. Standard definability argument applies.

## C2 (CONJECTURAL): Grid-Structured Fiber (stv 0.6, 0.7)
Rank-1 factored metric V = R⊗C has degenerate fiber when either R or C has a zero entry. The frozen set is grid-structured: a parameter (i,j) is frozen if R_i < eps OR C_j < eps (union, not intersection). This creates a fundamentally different singular geometry than diagonal methods (which freeze individual entries) or K-FAC (which freezes blocks). Grid freezing is coarser than diagonal, finer than block.

## C3 (CONJECTURAL): 2D Dual-Beta Stratum Lattice (stv 0.5, 0.7)
Dual EMAs with independent β_R, β_C create a 2D stratum lattice. The stratum selector is the pair (β_R, β_C), not a single scalar. Phase transitions occur along two axes independently (row-collapse and col-collapse), creating a lattice of strata parameterized by (m-k, n-l). This is unprecedented in the catalog — all other optimizer syntheses have 1D stratum chains.

## C4 (CONJECTURAL): Gen Bound with Factored Bias (stv 0.5, 0.7)
The generalization bound includes a factored approximation bias B_rank = ||F - R⊗C||_F / σ_max(F). Rank-1 factorization trades lower RLCT (λ_fact < λ_diagonal) for higher bias (B_rank > 0). The optimal rank-1 factor is the best rank-1 approximation of the true second moment matrix, but the tradeoff between λ reduction and B_rank increase is unexplored.

## C5 (CONJECTURAL): Asymmetric Phase Transition (stv 0.6, 0.7)
When row factors collapse (frozen-rows nonempty), the SGLD phase transition kink scales as n (number of columns), not m. Symmetrically, column collapse gives kink ∝ m. This asymmetry is unique — no other synthesis has asymmetric kinks. The prediction: wide matrices (n >> m) show row-collapse kinks at larger t* than column-collapse kinks.

## Novel Contributions (5)
1. Rank-1 outer product as ALWAYS rank-1 preconditioner (vs K-FAC full-rank, diagonal axis-aligned)
2. Grid-structured singular fiber (row∪column freezing, not individual entries or blocks)
3. 2D dual-EMA stratum lattice with independent transition rates
4. Factored approximation bias B_rank in generalization bound
5. Asymmetric phase transition signature (row collapse ∝ n, column collapse ∝ m)

## Open Problems (5)
1. Optimal rank-1 factor: is the SVD best rank-1 approximation also optimal for RLCT reduction?
2. Does normalization (||V|| scaling) create additional non-analytic patches beyond the eps-frozen set?
3. Can the 2D stratum lattice be extended to higher-rank factored metrics (r > 1)?
4. Is there a principled schedule for (β_R, β_C) that minimizes the gen bound?
5. How does relative step size (η ||W||) interact with the grid-structured singular fiber?

## Cross-References (11)
#516 K-FAC, #289 Adam, #605 Adagrad, #606 RMSProp, #591 AdaBelief, #354 SGD, #415 Muon, #480 muP, #505 WeightNorm, #433 WeightDecay, #8/#16 RLCT foundational
