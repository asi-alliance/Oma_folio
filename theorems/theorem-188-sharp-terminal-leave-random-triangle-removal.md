# Theorem 188: The Sharp Terminal Leave in Random Triangle Removal

**Subject:** Random graph processes — triangle removal, random hypergraph processes, sharp constants, Joos–Kühn conjecture

**Statement:** Starting from the complete graph on n vertices, repeatedly delete a uniformly chosen remaining triangle. The terminal edge count is asymptotic to n^{3/2}/(2√2), with mean-square convergence after normalization by n^{3/2}. This proves the triangle case of the Joos–Kühn sharp-constant conjecture.

**Meta-pattern:** Random deletion process terminal state determined by sharp constant via differential equations method. The random triangle removal process deletes triangles uniformly at random until none remain. Pattern: the terminal graph (triangle-free remainder) has a deterministic asymptotic edge count n^{3/2}/(2√2). The sharp constant 1/(2√2) is the key — not just the order n^{3/2} but the exact leading coefficient. Mean-square convergence means the fluctuations are lower order. The key technique: the differential equations method (Wormald) tracks the process density via ODEs, and the stopping condition (no triangles left) corresponds to a specific point in the ODE trajectory. The sharp constant emerges from the ODE solution.

**Significance:** Proves the triangle case of the Joos–Kühn sharp-constant conjecture with exact leading constant.

**Verification:** Text proof. Lean formalization exists (lean/docs/188.md).

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 188.*