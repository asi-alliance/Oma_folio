; DOMAIN: mathematics/algebraic-geometry/sheaf-cohomology [CLOSED, derived 2026-08-01]; Claim: Sheaf cohomology provides a powerful framework for studying global properties of geometric objects by gluing local data. A sheaf assigns algebraic data (groups, rings, modules) to open sets of a topological space, with restriction maps satisfying gluing axioms. Cohomology groups H^i(X, F) measure the obstruction to extending local sections to global ones. Key tools include injective resolutions, derived functors, and spectral sequences. Serre duality and Riemann-Roch theorem are fundamental results. Applications span algebraic geometry, complex geometry, topology, and number theory (etale cohomology).; Structure: (sheaf: algebraic data on open sets with restriction maps) (gluing axioms: local-to-global consistency) (cohomology groups H^i(X,F): obstruction to global extension) (injective resolutions: derived functor computation) (spectral sequences: multi-level filtration tools) (Serre duality: dual cohomology on smooth varieties) (Riemann-Roch: dimension formula for line bundles) (etale cohomology: arithmetic applications)
; Result: Sheaf cohomology measures the obstruction to gluing local sections into global ones. The cohomology groups H^i(X, F) vanish for i=0 when local sections extend globally. Derived functors via injective resolutions provide the computational framework. Spectral sequences organize multi-step computations. Serre duality relates H^i and H^{n-i} on smooth projective varieties. The Riemann-Roch theorem computes dimensions of spaces of sections. Etale cohomology extends these tools to arithmetic settings, proving the Weil conjectures.
; Bridge: genesis_category_theory + genesis_homological_algebra + genesis_topology + genesis_algebraic_geometry + genesis_number_theory
;; A sheaf assigns algebraic data to open sets with restriction maps satisfying gluing axioms
(|- ((==> (&& (--> TopologicalSpace $X) (--> OpenSet $U) (--> AlgebraicData $F) (--> RestrictionMap $rho) (--> GluingAxiom $rho))) (--> Sheaf $F $X)) (stv 1.0 0.9))
;; Cohomology groups H^i(X,F) measure obstruction to extending local sections globally
(|- ((==> (&& (--> TopologicalSpace $X) (--> Sheaf $F) (--> Obstruction $O) (--> GlobalExtension $G))) (--> CohomologyGroup (H $X $F $i) $O)) (stv 1.0 0.9))
;; Derived functors compute sheaf cohomology via injective resolutions
(|- ((==> (&& (--> Sheaf $F) (--> InjectiveResolution $I) (--> DerivedFunctor $R))) (--> SheafCohomology (Apply $R $F))) (stv 1.0 0.85))
;; Spectral sequences organize multi-step cohomology computations via filtrations
(|- ((==> (&& (--> Complex $C) (--> Filtration $F) (--> MultiLevel $F))) (--> SpectralSequence (Leray $C $F))) (stv 1.0 0.85))
;; Serre duality relates H^i and H^{n-i} on smooth projective varieties via the canonical sheaf
(|- ((==> (&& (--> SmoothProjectiveVariety $X) (--> Dimension $n) (--> CanonicalSheaf $omega) (--> DualIsomorphism $D))) (--> SerreDuality (H $X $F $i) (H $X $omega (- $n $i)))) (stv 1.0 0.85))
;; Riemann-Roch theorem computes dimensions of spaces of sections for line bundles
(|- ((==> (&& (--> SmoothProjectiveVariety $X) (--> LineBundle $L) (--> CanonicalSheaf $omega) (--> Degree $d))) (--> RiemannRoch (H $X $L 0) (+ (- $d $g) 1))) (stv 1.0 0.85))
;; Etale cohomology extends sheaf cohomology to arithmetic settings for the Weil conjectures
(|- ((==> (&& (--> Sheaf $F) (--> EtaleSite $X) (--> GaloisAction $G))) (--> EtaleCohomology (H $X $F $i))) (stv 1.0 0.85))
;; Vanishing theorem: higher cohomology vanishes for ample line bundles on projective varieties
(|- ((==> (&& (--> ProjectiveVariety $X) (--> AmpleLineBundle $L) (--> GreaterThan $i 0))) (--> Vanishing (H $X $L $i))) (stv 1.0 0.85))
