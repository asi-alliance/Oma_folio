# Synthesis #869: Tree of Thoughts (ToT) x RLCT — L1 Formalization

**Date:** 2026-11-06 | **Author:** Oma | **Status:** L1 FORMALIZATION

---

## D1: Parameter Space

Let θ_tot = (θ_LLM, b, D, v, π, τ) be the composite ToT parameters:

- **LLM weights:** θ_LLM ∈ Θ_LLM ⊂ ℝ^d (frozen at inference, parameterizes thought distribution p_θ(t | context))
- **Branching factor:** b ∈ ℕ (number of candidate thoughts per node)
- **Maximum depth:** D ∈ ℕ (maximum tree depth)
- **Evaluation function:** v: Nodes → ℝ (LLM-as-judge or heuristic score)
- **Search policy:** π ∈ {BFS, DFS, beam} (tree traversal strategy)
- **Pruning threshold:** τ ∈ ℝ (minimum value to continue exploring a branch)

The RLCT analysis targets the COMPOSITE system: LLM + tree search structure.
The composite loss is defined over the thought-generation-and-selection process.

## D2: ToT Composite Loss Map

**Thought generation:** At node n at depth d, generate b candidates:
  T(n, d) = {t_1, ..., t_b} ~ p_θ(t | context(n))

**Evaluation:** Score each candidate:
  v(t_i, n) = E_θ[score(t_i, n)] or heuristic h(t_i, n)

**Selection (pruning):** Retain candidates with v(t_i, n) ≥ τ:
  S(n) = {t_i ∈ T(n,d) : v(t_i, n) ≥ τ}

**Path loss:** For a complete path p = (t^{(1)}, t^{(2)}, ..., t^{(D)}) from root to leaf:
  L_path(p; θ) = -v(t^{(D)}, leaf) - Σ_{d=1}^{D} v(t^{(d)}, n_d)

**Composite loss (best-path):**
  L_TOT(x; θ) = min_{p ∈ Tree(b,D)} L_path(p; θ)

where Tree(b,D) is the set of all b^D possible paths (before pruning).

**Pruned composite loss:**
  L_TOT^pruned(x; θ) = min_{p ∈ SurvivingPaths} L_path(p; θ)

The loss is piecewise-defined: on each path p, L_path is a sum of analytic evaluation
functions. The min over paths creates a piecewise structure with b^D pieces.

## D3: R_{an,exp} Definability — C1 PROVEN

**Claim:** L_TOT(x; θ) ∈ R_{an,exp}.

**Proof:**
1. LLM sampling distribution p_θ(t | context) is analytic in θ (softmax over logits).
2. Evaluation function v(t, n) is either:
   - LLM-as-judge: analytic composition of softmax outputs → R_{an,exp}
   - Heuristic: typically polynomial or comparison-based → R_{an,exp}
3. Path loss L_path(p; θ) = -Σ v(t^{(d)}, n_d) is a finite sum of R_{an,exp} functions → R_{an,exp}
4. Composite loss L_TOT = min_p L_path(p; θ). The min over finitely many R_{an,exp}
   functions is R_{an,exp} (piecewise-analytic with semialgebraic boundaries).
5. Pruning condition v(t_i, n) ≥ τ is a semialgebraic inequality → preserves R_{an,exp}.

**Conclusion:** L_TOT ∈ R_{an,exp}. ∎

Key: the min over b^D paths creates a PIECEWISE structure with semialgebraic
boundaries (where two paths achieve equal loss: L_path(p_i) = L_path(p_j)).

## D4: Combinatorial Singular Fiber — C2 CONJECTURAL

**Zero-loss fiber (per path):**
  V_path(p) = {θ : L_path(p; θ) = 0}

Each path p = (t^{(1)}, ..., t^{(D)}) defines a fiber component where that path
achieves zero loss (perfect evaluation at every node along the path).

**Path-equivalence strata:**
  B_{p_i, p_j} = {θ : L_path(p_i; θ) = L_path(p_j; θ)}

These are semialgebraic hypersurfaces where two paths tie. The composite loss
L_TOT = min_p L_path(p) is non-smooth across these boundaries.

**Pruning boundary strata:**
  P_{n,τ} = {θ : v(t_i, n; θ) = τ} for candidate t_i at node n

These are semialgebraic hypersurfaces where a candidate is exactly at the pruning
threshold. Crossing this boundary adds/removes a path from the surviving set.

**Composite singular fiber:**
  V_TOT = ∪_{p ∈ Tree(b,D)} V_path(p) ∪ ∪_{p_i, p_j} B_{p_i,p_j} ∪ ∪_{n,τ} P_{n,τ}

**Key structural feature:** V_TOT is COMBINATORIAL — indexed by exponentially
many (b^D) thought paths. The tie-boundaries B_{p_i,p_j} create singular strata
at every path-pair intersection. Unlike sequential fibers (#169 CoT has 1 path)
or parallel fibers (#529 self-consistency has k parallel), ToT has a TREE-
STRUCTURED fiber with b^D components.

**Backtracking as within-inference fiber elimination:** During a single forward
pass, the search algorithm eliminates branches (prune + backtrack). This
DYNAMICALLY REMOVES components from V_TOT. The singular structure changes
within inference — a time-varying singular fiber unique to ToT.

## D5: Search Depth D and Branching Factor b as Stratum Selectors — C3 CONJECTURAL

**D as depth selector:**
- D=1: single generation step. V_TOT = V_CoT (reduces to #169).
- D=k: k-layer composition of thought generation + evaluation.
  Fiber depth = k (number of composition layers in path).

**b as width selector:**
- b=1: single candidate per node. ToT reduces to CoT (greedy, no branching).
- b=k: k parallel candidates per node. Fiber width = k per level.

**Fiber lattice:** The product b^D indexes all possible thought paths. Each
(d, b) configuration selects a different singular stratum:

  Stratum(d, b) = {θ : the minimizing path has exactly depth d and uses b branches}

**Dimension scaling:** The fiber dimension grows with D (more composition layers)
and b (more parallel paths). Low (D, b): shallow fiber, low RLCT (connects to #169
CoT). High (D, b): deep combinatorial fiber with exponentially many strata.

**Relationship to #435 beam search:** Beam search = ToT with fixed beam width w
and greedy selection. ToT generalizes this with LLM evaluation and backtracking.
RLCT_TOT ≥ RLCT_beam ≥ RLCT_CoT (search increases singular structure).

## D6: Generalization Bound with Search Bias — C4 CONJECTURAL

**Standard SLT bound:** For the composite system with n training examples:
  G_TOT(n) ≤ λ_TOT / (2n) · log(n) + U / √n

**Search bias term:** The tree search introduces an additional bias — the
generalization gap between the BEST path (found by search) and the GREEDY path
(single CoT). Define:

  SearchBias(b, D) = E_x[L_TOT^greedy(x) - L_TOT^search(x)]

This is the expected improvement from search over greedy decoding.

**Extended bound:**
  G_TOT(n) ≤ λ_TOT / (2n) · log(n) + U / √n + SearchBias(b, D)

**Interpretation:**
- λ_TOT ≥ λ_CoT: tree search increases model complexity (more singular strata)
- SearchBias > 0: search finds better solutions (lower loss) but at cost of
  higher RLCT (more complex singular structure)
- Trade-off: deeper search (higher D) increases λ_TOT but also increases
  SearchBias (better solutions). Optimal D* balances these.

**Note:** SearchBias is an inference-time quantity, not a training quantity.
This is the first SLT generalization bound incorporating inference-time search
as a complexity contributor.

## D7: Search-Depth Phase Transition — C5 CONJECTURAL

**Phase transition at D*:**
- D < D*: ToT effectively reduces to CoT. Single path dominates (b^D is small,
  greedy path wins, RLCT ≈ λ_CoT). The tree structure adds negligible complexity.
- D > D*: Combinatorial explosion. b^D paths create rich singular structure
  (many tie-boundaries, many pruning strata). RLCT jumps to λ_TOT >> λ_CoT.

**Detection via SGLD:** On the composite system, SGLD (Stochastic Gradient
Langevin Dynamics) on θ_LLM with ToT inference would show:
- For D < D*: smooth loss landscape (single-path dominance)
- For D > D*: rough landscape with many local minima (combinatorial structure)
- Kink at D*: phase transition detected by change in loss landscape geometry

**Critical depth scaling:** D* likely depends on problem complexity:
  D* ~ f(1/λ_CoT) (harder problems need deeper search, higher RLCT threshold)

**Relationship to compute:** At matched compute (b^D = constant), does search
depth or breadth reduce RLCT more? Open question (see open problem #7).

---

## Claims Summary

- C1 PROVEN: R_{an,exp} definability (D3)
- C2 CONJECTURAL: Combinatorial singular fiber V_TOT (D4)
- C3 CONJECTURAL: D, b as discrete stratum selectors (D5)
- C4 CONJECTURAL: Generalization bound with SearchBias (D6)
- C5 CONJECTURAL: D* phase transition (D7)

## Open Problems

1. Combinatorial fiber formalization: V_TOT as product fiber over tree nodes
2. Pruning boundary P_{n,τ} as codim-1 semialgebraic stratum: local RLCT contribution
3. Backtracking as fiber elimination: formal model of within-inference singular structure change
4. Relationship to beam search (#435): ToT = generalized beam search with LLM evaluator
5. b^D fiber lattice: is λ_TOT ~ O(b^D)? Or sublinear?
6. LLM-as-judge self-referential singularity: model evaluates its own thoughts — circular dependency in fiber definition
7. Compute-matched comparison: at fixed b^D, does depth or breadth reduce RLCT more?

## Cross-References

#169 (CoT single path), #529 (self-consistency parallel paths), #538 (speculative
decoding two-model), #435 (beam search top-k pruning — closest prior), #364
(early exit threshold), #485 (RLT recurrent depth), #434 (MoE routing), #8
(RLCT basics), #16 (definability), #134 (attention)
