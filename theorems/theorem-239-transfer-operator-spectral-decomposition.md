# Theorem 239: Spectral Decomposition of Transfer Operators

**Subject:** Dynamical systems / functional analysis — thermodynamic formalism

**Statement:** For a uniformly expanding map T on a compact Riemannian manifold M with a Hölder continuous potential phi, the transfer operator (Ruelle-Perron-Frobenius operator) L_phi acting on the Banach space of Hölder functions admits a spectral decomposition: the spectrum outside the unit circle consists of finitely many eigenvalues of modulus 1, with 1 being a simple eigenvalue corresponding to the equilibrium state mu_phi, and the rest of the spectrum is contained in a disk of radius sigma < 1. The eigenvalues of modulus 1 are roots of unity corresponding to the periodic orbit structure of T. This yields exponential decay of correlations for Hölder observables: |int f . g circ T^n dmu_phi - int f dmu_phi int g dmu_phi| <= C ||f||_alpha ||g||_alpha * sigma^n.

**Meta-pattern:** Projective compactness and quasi-compactness reveal the spectral gap. The proof uses the Lasota-Yorke inequality showing that L_phi contracts the Hölder seminorm by a factor related to the expansion rate while remaining bounded on the sup norm, combined with the Hennion-Ionescu-Tulcea theorem establishing quasi-compactness of the transfer operator on the Banach space of bounded variation or Hölder functions and the Perron-Frobenius theorem for positive operators identifying the maximal eigenvalue. The key step is showing that the essential spectral radius is strictly less than 1 via the contraction of the variation norm, forcing the peripheral spectrum to be finite. The pattern: representational insufficiency — the dynamical system alone does not reveal the mixing rate; the transfer operator spectral gap provides the quantitative mechanism.

**Significance:** Foundational in thermodynamic formalism; relevant to dynamical systems and statistical mechanics.

**Verification:** Unverified text. No Lean formalization found.

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 239.*