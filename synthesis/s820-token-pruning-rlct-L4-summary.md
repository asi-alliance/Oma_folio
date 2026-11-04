#820: Token Pruning x RLCT -- L4 Summary

## Date: 2026-10-29
## Status: L4 SUMMARY WRITTEN

## Plain-Language Summary

Token pruning removes low-importance tokens from the input sequence based on a learned or fixed score. When viewed through Singular Learning Theory, pruning creates a restricted singular fiber: the set of parameters achieving zero loss on fewer tokens is structurally different from the full-input fiber.

## C1 (PROVEN): The pruned loss is R_{an,exp}-definable for definable importance scores (attention weights, norms, learned scores). The piecewise threshold indicator 1[s >= tau] is semi-algebraic.

## C2 (CONJECTURAL): The pruned singular fiber is a proper sub-fibration of the unpruned fiber when n_def < n. The RLCT satisfies lambda(rho) <= lambda(1) when essential tokens are retained.

## C3 (CONJECTURAL): The pruning ratio rho = n_def/n acts as a stratum selector. lambda(rho) is roughly monotone for tau < tau_critical (all essential tokens kept) with a sharp jump at tau_critical when essential tokens begin to be pruned.

## C4 (CONJECTURAL): The generalization bound G_prun(rho) ~ lambda(rho)/n_def + U_prun/sqrt(n_def) reveals a fundamental tradeoff: pruning reduces the RLCT (fewer effective parameters) but also reduces n_def (less empirical data). This is distinct from all prior syntheses.

## C5 (CONJECTURAL): Token pruning is fundamentally distinct from token merging (#500, quotient fiber), token dropping (#686, stochastic fiber), sparse attention (#545, mask fiber), weight pruning (#220, parameter removal), and data pruning (#481, sample removal). Pruning creates a deterministic sub-variety restriction on the input space.

## Key Novelty
The standout contribution is the double-edged generalization bound: unlike weight pruning (reduces parameters, keeps data) or data pruning (keeps parameters, reduces data), token pruning reduces BOTH the RLCT and the effective sample count simultaneously. The tradeoff curve G_prun(rho) has an optimal rho* that balances fiber simplification against information loss. The threshold-crossing singularity (D6) creates a non-smooth lambda(rho) profile unique among pruning-type mechanisms.

## Open Problems
1. Formal characterization of lambda(rho) for specific importance criteria.
2. Interaction with positional encoding after non-contiguous pruning.
3. RLCT-aware pruning: designing s to minimize lambda directly.
4. Relationship to data pruning (#481): different granularities of information removal.
5. Effect of learned vs fixed thresholds on fiber structure.
6. Information loss quantification: entropy of pruned tokens vs lambda reduction.
7. Multi-layer pruning: nested stratum structure lambda(rho_1,...,rho_L).

## Cross-References
#8, #16, #169, #220, #468, #469, #481, #493, #500, #545, #673, #686
