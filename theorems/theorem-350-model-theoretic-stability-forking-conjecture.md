# Theorem 350: Model-Theoretic Stability and the Forking Conjecture

**Subject:** Model theory — stability theory

**Statement:** In a stable first-order theory T, the forking independence relation satisfies the following axioms: (1) invariance under automorphisms, (2) symmetry: A fork-independent from B iff B fork-independent from A, (3) transitivity: if A fork-independent from B over C and A fork-independent from C over B, then A fork-independent from BC, (4) extension: any type can be extended to a non-forking type over any superset, (5) local character: for any A and b, the set of C subset A such that tp(b/A) forks over C has cardinality < kappa(T). The Kim-Pillay theorem characterizes forking independence as the unique independence relation satisfying these axioms in a simple theory, and the Buechler theorem shows that in a superstable theory, forking equals dividing for types.

**Meta-pattern:** Independence relation axioms and canonical bases reveal the forking structure in stable theories. The proof uses the Morley rank and the definability of types in stable theories established via the finite equivalence relation theorem, combined with the Lascar-Poizat theorem on the canonical base of a type as the minimal definably closed set over which the type is stationary. The key step is showing that the forking relation defined via dividing sequences satisfies symmetry and transitivity using the stationarity of types. The pattern: representational insufficiency — the type alone does not reveal the independence structure; the forking relation and canonical base provide the model-theoretic mechanism.

**Significance:** Central in stability theory; relevant to model theory and its applications.

**Verification:** Unverified text. No Lean formalization found.

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 350.*