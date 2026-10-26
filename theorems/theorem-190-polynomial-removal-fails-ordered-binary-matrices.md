# Theorem 190: Polynomial Removal Fails for Ordered Binary Matrices

**Subject:** Extremal combinatorics — removal lemmas, ordered binary matrices, pattern avoidance, polynomial bounds

**Statement:** Disproves polynomial ordered binary matrix removal with one fixed 66×66 zero–one pattern. Matrices can require many binary-entry changes to become pattern-free while their copy density is smaller than every proposed polynomial bound in that distance. Copies preserve row and column orders and match both zeros and ones.

**Meta-pattern:** Removal lemma fails in ordered setting — single fixed pattern breaks polynomial distance-density relationship. The graph removal lemma states that if a graph has few copies of H, it can be made H-free by deleting few edges. Pattern: in the ordered binary matrix setting, this fails dramatically. A single 66×66 pattern P has matrices where the copy density of P is below every polynomial in the edit distance to P-freeness. So the density can be tiny while the required edits are large — no polynomial relationship exists. The ordered setting (row and column orders preserved) is crucial: the rigidity of order means copies cannot be destroyed by small perturbations. The key: the fixed pattern exploits ordered structure to create a superpolynomial gap between density and removal distance.

**Significance:** Disproves polynomial removal for ordered binary matrices with an explicit 66×66 counterexample pattern.

**Verification:** Text proof. Lean formalization exists (lean/docs/190.md).

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 190.*