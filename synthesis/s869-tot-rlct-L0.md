# Synthesis #869: Tree of Thoughts (ToT) x RLCT
## L0: Outline & Architecture Overview
## Date: 2026-11-06

### Architecture: Tree of Thoughts (Yao et al., 2023)
Tree of Thoughts is an inference-time reasoning framework that structures LLM reasoning as a search over a tree of intermediate thought nodes. Core mechanism:

- Thought generation: At each node, generate k candidate next-thoughts via LLM sampling
- Evaluation: Score each candidate thought (value function: LLM-as-judge or heuristic)
- Search: BFS/DFS over thought tree with pruning of low-value branches
- Backtracking: Abandon unpromising branches, return to parent, explore alternatives
- Termination: Stop at depth D or when solution found

Key parameters:
- b: branching factor (number of candidates per node)
- D: maximum search depth
- v(node): evaluation function (LLM-based or heuristic score)
- Search policy: BFS, DFS, or beam search variant
- Pruning threshold: minimum value to continue exploring a branch

### Parameter Space
theta_tot = (theta_LLM, b, D, v, search_policy, prune_threshold)

theta_LLM = model parameters (frozen at inference, but the thought distribution is parameterized by them)
The RLCT analysis targets the COMPOSITE system: LLM + tree search structure.

### Claim Preview
- C1 (PROVEN): ToT composite loss is R_an,exp-definable. LLM softmax sampling (analytic), evaluation scoring (polynomial/comparison), tree search (piecewise selection via argmax/threshold). All components in R_an,exp; closure under composition.
- C2 (CONJECTURAL): Combinatorial singular fiber V_path = {theta : thought sequence path p has zero evaluation gradient}. Each tree path defines a fiber component. Pruning boundaries create semi-algebraic hypersurfaces (v(node) < threshold) -> singular strata. The fiber is COMBINATORIAL — indexed by exponentially many thought paths, unlike sequential (#529) or single-path (#169) fibers.
- C3 (CONJECTURAL): Search depth D and branching factor b act as DISCRETE stratum selectors. D controls fiber depth (number of composition layers in the path). b controls fiber width (number of parallel components). The product b^D indexes the full fiber lattice. Low D: shallow fiber (reduces to CoT, connects #169). High D: deep combinatorial fiber with exponentially many strata.
- C4 (CONJECTURAL): Generalization bound G_TOT ~ lambda_TOT/(2n)*log(n) + U/sqrt(n) + SearchBias(b,D). Search bias term captures the gap between best-path and greedy-path generalization. Lambda_TOT >= lambda_CoT (tree search increases model complexity). Trade-off: deeper search finds better solutions (lower loss) but increases RLCT (more singular strata).
- C5 (CONJECTURAL): Search-depth phase transition at D*. For D < D*, ToT reduces to CoT (single path dominates, low RLCT). For D > D*, combinatorial explosion of thought paths creates rich singular structure (high RLCT, but better solutions). SGLD on the composite system detects kink when search switches from greedy to exploratory.

### Key Novelty
COMBINATORIAL SINGULAR FIBER. Prior reasoning syntheses (#169 CoT, #529 self-consistency, #538 speculative decoding) have sequential or parallel fibers. ToT creates a TREE-STRUCTURED fiber: the singular locus is indexed by the exponentially many thought paths in the search tree. Pruning creates semi-algebraic boundary strata (evaluation threshold hypersurfaces). Backtracking dynamically ELIMINATES fiber components during inference — the singular structure changes WITHIN a single forward pass. This is fundamentally new: a time-varying (within-inference) singular fiber driven by combinatorial search.

### Cross-References
#169 (CoT single path), #529 (self-consistency parallel paths), #538 (speculative decoding two-model), #435 (beam search top-k pruning — closest prior), #364 (early exit threshold), #485 (RLT recurrent depth), #434 (MoE routing), #8 (RLCT basics), #16 (definability), #134 (attention)

### Open Problems
1. Combinatorial fiber formalization: V_path as product fiber over tree nodes
2. Pruning boundary as semi-algebraic set: v(node) = threshold creates codim-1 stratum
3. Backtracking as fiber elimination: dynamic singular structure within single inference
4. Relationship to beam search (#435): ToT = generalized beam search with LLM evaluator
5. b^D fiber lattice: combinatorial explosion vs RLCT — is lambda_TOT ~ O(b^D)?
6. LLM-as-judge evaluator: self-referential singularity (model evaluates its own thoughts)
7. Comparison: ToT RLCT vs CoT RLCT at matched compute — does search increase or decrease effective complexity?

### Pipeline Status
L0 (this file) -> L1 (formal definitions) -> L2 (novelty) -> L3 (MeTTa) -> L4 (summary) -> L5 (catalog)
