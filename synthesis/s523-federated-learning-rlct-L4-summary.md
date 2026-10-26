#523: Federated Learning (FedAvg) x RLCT -- L4 Summary
Date: 2026-10-22
Status: L4 SUMMARY COMPLETE (L0-L4 pipeline done)

## Claim Digest
- C1 (PROVEN): FedAvg aggregation map Phi is R_an-definable (polynomial aggregation + autograd composition closure)
- C2 (CONJECTURAL): Singular fibers F_k(0) non-convex for heterogeneous clients; Minkowski sum F_avg not contained in any single F_k(0)
- C3 (CONJECTURAL): Heterogeneity sigma acts as stratum selector -- controls which stratum of average loss L-bar the composite point lands on
- C4 (CONJECTURAL): Composite RLCT lambda_avg satisfies min_k lambda_k <= lambda_avg <= max_k lambda_k; Lipschitz refinement |lambda_avg - lambda_hom| <= C*sigma
- C5 (CONJECTURAL): Critical heterogeneity sigma* phase transition in lambda_avg; sigma* ~ 1/sqrt(d) conjectured

## Lineage
- Builds on #119 (FL x RLCT initial), #149 (FL x RLCT formalized)
- Related: #226 (EMA), #232 (model soup), #394 (SWA fiber averaging), #420 (Lookahead), #506 (hypernetwork), #522 (active learning)
- Key distinction from #394 SWA: same distribution temporal averaging vs heterogeneous spatial averaging

## Key Novelties
- Minkowski-sum composite fiber F_avg = Sum w_k F_k(0) -- new construction in SLT
- Heterogeneity sigma as stratum selector in Watanabe resolution framework
- sigma* phase transition in composite RLCT -- testable via SGLD

## Open Problems
1. Definability of F_avg for R_an,exp with exponentials
2. Can lambda_avg <= max_k lambda_k fail? (pathological counterexample)
3. Analytical sigma* for linear regression (Gaussian)
4. Local epochs E modulating fiber divergence
5. Communication compression adding singular structure
6. FedAvg as variational inference over composite fiber
7. Client selection bias affecting lambda_avg
8. Unification with #394 SWA under averaging-over-singular-fibers framework
9. FedProx variant -- different composite RLCT?

## Next Steps
- L5 catalog append
- Candidate #524 selection