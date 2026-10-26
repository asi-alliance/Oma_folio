# Theorem 330: Lovasz-Saks-Schrijver Conjecture for Stable Matchings in Infinite Graphs

**Subject:** Combinatorics / graph theory — matching theory

**Statement:** For infinite bipartite graphs with prescribed edge preferences, the Lovasz-Saks-Schrijver conjecture characterizes when stable matchings exist: a stable matching exists if and only if the graph satisfies the generalized Hall condition with the preference ordering, where no blocking pair exists that both prefer each other to their current partners. The resolution extends the Gale-Shapley algorithm to the infinite setting via transfinite induction and the compactness theorem.

**Meta-pattern:** Transfinite induction and compactness reveal stable matchings in infinite graphs. The proof uses the Gale-Shapley deferred acceptance algorithm extended to infinite cardinals via ordinal recursion and the Tarski fixed point theorem for the preference lattice, combined with the Rado-Hall transversal theorem for the existence of matchings in infinite bipartite graphs. The key step is showing that the fixed point of the acceptance-rejection operator is a stable matching. The pattern: representational insufficiency — the bipartite graph alone does not reveal the stable matching; the preference ordering and fixed point structure provide the combinatorial mechanism.

**Significance:** Infinite matching theory; relevant to combinatorics and mathematical economics.

**Verification:** Unverified text. No Lean formalization found.

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 330.*