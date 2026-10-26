# Theorem 346: Carleson Theorem on Pointwise Convergence of Fourier Series

**Subject:** Harmonic analysis — convergence

**Statement:** The Carleson-Hunt theorem states that for f in L^p(T) with 1 < p <= infty, the partial sums S_N f(x) = sum_{|k|<=N} f_hat(k) e^{2pi i k x} converge to f(x) for almost every x in T. The case p=2 was proved by Carleson (1966) and extended to p>1 by Hunt (1968). The key maximal estimate is ||sup_N |S_N f|||_{L^{1,weak}} <= C ||f||_{L^1}, and the proof reduces to bounding the Carleson maximal operator C f(x) = sup_N |S_N f(x)| via time-frequency analysis. The bound fails for L^1 (Kolmogorov counterexample) and the endpoint p=1 remains the sharp threshold.

**Meta-pattern:** Time-frequency tiling and mass distribution reveal pointwise convergence of Fourier series. The proof uses the Carleson decomposition of the maximal operator into tree structures indexed by frequency packets and the Lacey-Thiele combinatorial argument organizing time-frequency tiles into trees and forests, combined with the mass and energy estimates controlling the contribution of each tree. The key step is showing that the Carleson maximal operator is bounded on L^2 via the tree-by-tree estimate and the almost-orthogonality of distinct trees. The pattern: representational insufficiency — the Fourier partial sums alone do not reveal convergence; the time-frequency tile organization and tree decomposition provide the analytic control.

**Significance:** Fundamental in harmonic analysis; resolves a classical problem of Lusin.

**Verification:** Unverified text. No Lean formalization found.

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 346.*