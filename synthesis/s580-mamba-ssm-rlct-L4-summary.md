#580: Mamba / Selective SSM x RLCT - L4: Executive Summary
Date: 2026-10-24

## One-Sentence Summary
This synthesis extends Singular Learning Theory to Mamba's selective state space models, showing that input-dependent state transitions create data-conditioned singular fibers where the selectivity mechanism acts as a continuous stratum selector with a predicted phase transition in the RLCT.

## Key Results
- C1 (PROVEN): K(theta) is definable in R_{an,exp} via polynomial projections, SiLU activation, matrix exponential, rational inverse (where det(A) != 0), and finite composition. Standard but first formalization for input-dependent SSMs.
- C2 (CONJECTURAL): The true parameter set W decomposes into data-conditioned strata by selectivity regime: identity (Delta->0), reset (A->0), selective (generic), and over-selective (Delta->inf). Strata depend on input distribution, not just architecture.
- C3 (CONJECTURAL): Delta(x) acts as a continuous stratum selector with lambda(g) monotonically decreasing on [0, g*], where g = E_x[Delta(x)*||A(x)||]. At g=0, lambda=d/2 (identity); at g*, lambda<d/2 (selective).
- C4 (CONJECTURAL): Generalization bound G(n,g) ~ lambda(g)/n + U(g)/sqrt(n) with selectivity-complexity tradeoff. Optimal g* ~ C/sqrt(n), predicting that optimal selectivity increases with data size.
- C5 (CONJECTURAL): Phase transition at g* where LLC jumps from lambda_identity to lambda_selective. SGLD-testable: train Mamba with varying selectivity and measure LLC.

## Novelty
- Data-conditioned singular fiber: first formalization of input-dependent singular loci in SLT (all prior SLT assumes fixed parameter-to-loss map)
- Selectivity as stratum selector: Delta(x) as continuous, data-dependent selector is novel vs #233's fixed parameters and #379's fixed decay rate
- Selectivity-dependent generalization bound: no prior work on how selectivity affects generalization through RLCT
- Data-conditioned phase transition: SGLD-testable prediction unique to Mamba's input-dependent architecture

## Open Problems
1. Formalize data-conditioned singular locus rigorously
2. Compute lambda for simplest case: 1D state, scalar Delta
3. Does input-dependence of A(x) break standard SLT framework?
4. How does per-token variable selectivity aggregate into global lambda?
5. Compare lambda_Mamba vs lambda_RWKV at matched state dimension
6. Empirically measure LLC in trained Mamba models at different selectivity scales
7. Analyze singularity at det(A(x))=0 (invertibility assumption lifted)
8. Validate g* ~ C/sqrt(n) scaling empirically

## Cross-References
#233 (SSM broad, fixed params), #379 (RWKV, fixed gating), #302 (Linear Attention), #579 (Neural ODE, fixed discretization), #545 (Sparse Attention), #100 (ResNet), #8 (Base RLCT), #16 (Free Energy)