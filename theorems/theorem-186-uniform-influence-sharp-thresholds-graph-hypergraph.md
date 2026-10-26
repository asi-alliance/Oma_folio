# Theorem 186: Uniform Influence and Sharp Thresholds for Graph and Hypergraph Properties

**Subject:** Probabilistic combinatorics — Friedgut–Kalai threshold-width conjectures, graph and hypergraph properties, influence

**Statement:** Proves the Friedgut–Kalai threshold-width conjectures for graphs and fixed-uniformity hypergraphs. For fixed 0 < ε < 1/2, every nontrivial increasing relabeling-invariant property crosses from probability ε to 1−ε within width O((log n)^{−2}) for graphs and O_r((log n)^{−r/(r−1)}) for r-uniform hypergraphs (r ≥ 3). The hypergraph influence bound also applies to nonmonotone properties.

**Meta-pattern:** Threshold width controlled by logarithmic influence decay with uniformity-dependent exponent. The Friedgut–Kalai conjecture relates how sharply a property transitions from unlikely to likely in random structures. Pattern: the width of the threshold window shrinks as a power of log n — O((log n)^{−2}) for graphs and O_r((log n)^{−r/(r−1)}) for r-uniform hypergraphs. The exponent −r/(r−1) approaches −1 as r grows, reflecting that higher uniformity smooths the transition. The key technique: uniform influence bounds — if total influence is large, the threshold is sharp. The graph bound O((log n)^{−2}) is tighter than the general hypergraph bound at r=2, matching the KKL-style influence theorem. Extension to nonmonotone properties is notable — influence methods transcend monotonicity.

**Significance:** Resolves the Friedgut–Kalai threshold-width conjectures for graphs and hypergraphs.

**Verification:** Text proof. Lean formalization exists (lean/docs/186.md).

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 186.*