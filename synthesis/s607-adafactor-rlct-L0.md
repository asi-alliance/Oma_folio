# Synthesis #607: AdaFactor × RLCT — L0 Claims
## Date: 2026-10-25
## Status: L0 Claims
## Candidate Selection: AdaFactor (Shazeer & Stern 2018) uses factored second-moment
## statistics: for 2D parameter W in R^{m×n}, instead of storing full m×n second
## moment matrix, it stores row sums R in R^m and column sums C in R^n, approximating
## V ≈ R C^T / ||R C^T|| (normalized outer product). Zero catalog hits. Zero SLT/RLCT
## bridge in literature. Distinct from #516 K-FAC (Kronecker F=A⊗B, full-rank within
## factors), #289 Adam (diagonal second moment), #605 Adagrad (diagonal accumulation),
## #606 RMSProp (diagonal EMA).

## Claims

### C1 (PROVABLE): R_{an,exp}-definability of AdaFactor trajectory
The AdaFactor update map is definable in R_{an,exp}. Components:
- EMA recursion on row/column statistics: R_t = β_R R_{t-1} + (1-β_R) sum_j g_{t,ij}²
  (definable: polynomial + exponential decay)
- EMA on column statistics: C_t = β_C C_{t-1} + (1-β_C) sum_i g_{t,ij}² (same form)
- Factored second moment: V_t = R_t ⊗ C_t (outer product, polynomial)
- Normalization: V_t / max(1, ||V_t||/sqrt(d)) (rational, definable)
- Entrywise inverse sqrt: V_t^{-1/2} (definable via ^(-1/2))
- Update: W_{t+1} = W_t - η * V_t^{-1/2} ⊙ g_t (polynomial composition)
- Relative step size: η_t = η * max(eps_2, ||W_t||) (norm is definable)
All operations compose within R_{an,exp}. QED.

### C2 (CONJECTURAL): Rank-1 factored Fisher fiber
The factored approximation V ≈ R ⊗ C creates an implicit rank-1 structure for the
preconditioning metric. The true Fisher information matrix F (m×n) generically has
rank min(m,n). The AdaFactor preconditioner D = V^{-1/2} has effective rank 1
(outer product of two vectors). This creates a singular fiber structure:
- When R or C has zero entries, the factored metric degenerates further
- The zero-loss set V_0 intersects the factored-metric strata nontrivially
- The fiber of the factored update map has dimension determined by the
  joint kernel of R and C, which is generically (m-1)(n-1) for rank-1 outer product
- Singular strata: rank drops in R or C (zero entries) create nested singular loci
- Contrast with #516 K-FAC: Kronecker A⊗B has rank rank(A)*rank(B), generically
  full — AdaFactor is ALWAYS rank-1, a much stronger constraint

### C3 (CONJECTURAL): Row-column dual stratum selector
AdaFactor has TWO independent EMA forgetting factors (β_R for rows, β_C for
columns), creating a DUAL stratum selector. The row selector freezes entire rows
(high cumulative row gradient → low row LR), the column selector freezes entire
columns. Their intersection defines the active parameter set:
- Active set = {(i,j) : R_i > τ_R AND C_j > τ_C}
- Dual selectors create a grid-like stratum structure, distinct from diagonal
  (#605/#606) which selects individual entries
- The dual β_R, β_C provide a 2-parameter family of stratum exploration
- Predict: optimal (β_R*, β_C*) depends on aspect ratio m/n of parameter matrix
- Contrast: diagonal methods (#605 Adagrad, #606 RMSProp) have single selector;
  K-FAC (#516) has block-level selectors but full-rank within blocks

### C4 (CONJECTURAL): Generalization bound with factored approximation bias
The factored second moment introduces a systematic approximation error:
||F - V||_F where F is true Fisher, V = R⊗C is rank-1 approximation.
Gen bound: G ≤ λ_factored * log(n)/(2n) + B_rank/sqrt(n)
where λ_factored is the RLCT under the rank-1 constrained metric, and B_rank
captures the bias from using rank-1 instead of full-rank preconditioning.
Key tension: lower λ_factored (rank-1 metric is "smoother" — fewer effective
dimensions) vs higher B_rank (approximation error). There exists an optimal
factorization rank r* — but AdaFactor fixes r=1, so the bound has a fixed
bias term that depends on the true Fisher's spectrum.
- Contrast: #516 K-FAC has rank rank(A)*rank(B) (much higher), lower bias
- Contrast: #605/#606 diagonal has rank min(m,n) but axis-aligned, different bias

### C5 (CONJECTURAL): Phase transition at factor rank collapse
When the gradient signal becomes concentrated on few rows or columns (e.g.,
late training with sparse gradients), R or C develops near-zero entries,
causing the factored metric to collapse. We predict a phase transition:
- As training progresses, effective rank of gradient signal decreases
- At critical time t*, the row or column factor loses a dimension
  (R_i → 0 or C_j → 0), creating a rank-deficient factor
- This is analogous to #605 Adagrad's freezing phase transition but in the
  FACTORED space — the collapse is along an entire row or column, not
  individual parameters
- SGLD signature: LC mean shows a kink at t* (stratum dimension drops),
  and the kink direction depends on whether row or column collapses first
- Falsifiable: if SGLD LC is smooth through t*, no phase transition

## Open Problems
1. Exact fiber dimension of rank-1 outer product preconditioner on loss landscape
2. Whether dual β_R, β_C have independent or coupled optimal values
3. Computation of λ_factored for rank-1 metric on a concrete model (e.g., matrix
   factorization, where m×n is the parameter space)
4. Whether the normalization step (dividing by ||V||) changes the singular geometry
   or merely rescales
5. Interaction between relative step size (η * ||W||) and factored metric — does
   the parameter-scale coupling create additional singular strata?
6. Whether AdaFactor's clipping (max(eps, ·)) creates definable non-analyticities
   beyond the EMA structure
7. Comparison: is AdaFactor's rank-1 metric closer to diagonal (#605) or K-FAC
   (#516) in terms of RLCT? Hypothesis: closer to diagonal (same O(d) storage)
   but with anisotropic structure (row/column correlations captured)

## Cross-References
- #516 K-FAC/Shampoo (full-rank Kronecker factored preconditioning — DIRECT CONTRAST)
- #289/#304 Adam (diagonal EMA second moment)
- #605 Adagrad (diagonal irreversible accumulation)
- #606 RMSProp (diagonal EMA reversible)
- #591 AdaBelief (belief discrepancy denominator)
- #354 SGD (vanilla baseline)
- #415 Muon (Newton-Schulz orthogonalization)
- #480 muP (width-dependent parametrization)
- #433 Weight Decay (variety modification)
- #505 Weight Normalization (scale-direction decomposition)
- #8/#16 (foundational RLCT definitions)
