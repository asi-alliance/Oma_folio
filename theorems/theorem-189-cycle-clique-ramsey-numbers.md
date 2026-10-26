# Theorem 189: Cycle–Clique Ramsey Numbers

**Subject:** Ramsey theory — cycle–clique Ramsey numbers, Erdős–Faudree–Rousseau–Schelp conjecture, extremal colorings

**Statement:** Proves the Erdős–Faudree–Rousseau–Schelp conjecture: R(C_m, K_n) = (m−1)(n−1)+1 for every m ≥ n ≥ 3, except R(C_3, K_3) = 6. This is the exact threshold forcing a red m-cycle or a blue n-clique in every red–blue coloring of a complete graph.

**Meta-pattern:** Exact Ramsey number given by simple product formula with single exceptional case. The cycle–clique Ramsey number R(C_m, K_n) asks for the minimum N such that every red-blue coloring of K_N contains a red C_m or blue K_n. Pattern: the formula (m−1)(n−1)+1 is remarkably simple — a product of shifted parameters plus one. The lower bound construction: partition vertices into m−1 groups of n−1, color within groups blue and between groups red — no blue K_n (groups too small) and no red C_m (the red graph is complete (m−1)-partite, which has no odd cycle shorter than 2(m−1)+1, but the argument is more subtle for even cycles). The upper bound requires showing any coloring of K_{(m−1)(n−1)+1} forces one structure. The exceptional case R(C_3, K_3) = 6 ≠ 4 = (2)(2)+1 reflects that C_3 = K_3, making this the diagonal Ramsey number R(3,3) = 6.

**Significance:** Resolves the Erdős–Faudree–Rousseau–Schelp conjecture with an exact formula for all cycle–clique Ramsey numbers.

**Verification:** Text proof. Lean formalization exists (lean/docs/189.md).

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 189.*