; DOMAIN: mathematics/operator-algebra [CLOSED, derived 2026-08-01]; Claim: Operator algebras study algebras of bounded linear operators on Hilbert spaces. The two main classes are C*-algebras (norm-closed, involutive) and von Neumann algebras (weakly closed). The GNS construction links states to representations. The classification of factors (types I, II, III) reveals deep structure — type III factors connect to Tomita-Takesaki theory and modular automorphism groups. K-theory of C*-algebras provides topological invariants. Noncommutative geometry extends geometric tools to operator algebras. Applications span quantum mechanics, quantum field theory, and statistical mechanics.
; Structure: (C*-algebras: norm-closed involutive Banach algebras) (von Neumann algebras: weakly closed *-subalgebras of B(H)) (GNS construction: state-to-representation) (factor classification: types I, II, III) (Tomita-Takesaki: modular automorphism group) (K-theory: topological invariants via K0, K1) (noncommutative geometry: spectral triples) (crossed products: dynamical system algebras)
; Result: Operator algebras provide the mathematical framework for quantum mechanics and quantum field theory. C*-algebras capture the norm and involution structure; von Neumann algebras capture the measure-theoretic/commutant structure. The GNS construction bridges states and representations. Factor classification reveals deep connections to quantum statistical mechanics (type II_1 for finite systems, type III for thermal/KMS states). K-theory yields topological invariants. Noncommutative geometry generalizes Riemannian geometry to quantum spaces.
; Bridge: genesis_functional_analysis + genesis_quantum_mechanics + genesis_topology + genesis_k_theory + genesis_noncommutative_geometry
;; A C*-algebra is a Banach algebra with involution satisfying the C*-identity
(|- ((==> (&& (--> BanachAlgebra $A) (--> Involution $star) (--> NormIdentity (|| $x $star) (* $x (Apply $star $x))))) (--> CStarAlgebra $A)) (stv 1.0 0.9))
;; Von Neumann algebra is a *-subalgebra of B(H) closed in the weak operator topology
(|- ((==> (&& (--> StarSubalgebra $M) (--> BoundedOperators $B) (--> WeakOperatorClosed $M))) (--> VonNeumannAlgebra $M)) (stv 1.0 0.9))
;; GNS construction maps a state to a cyclic representation
(|- ((==> (&& (--> CStarAlgebra $A) (--> State $phi))) (--> CyclicRepresentation (GNS $A $phi))) (stv 1.0 0.9))
;; Factor classification: type I factors are isomorphic to B(H)
(|- ((==> (&& (--> VonNeumannAlgebra $M) (--> MinimalProjection $p) (--> Isomorphic $M (B $H)))) (--> TypeIFactor $M)) (stv 1.0 0.85))
;; Type II_1 factors have a finite trace and no minimal projections
(|- ((==> (&& (--> Factor $M) (--> FiniteTrace $tau) (--> NoMinimalProjection $M))) (--> TypeII1Factor $M)) (stv 1.0 0.85))
;; Tomita-Takesaki theory: modular automorphism group from a cyclic separating vector
(|- ((==> (&& (--> VonNeumannAlgebra $M) (--> CyclicSeparatingVector $Omega) (--> ModularOperator $Delta))) (--> ModularAutomorphismGroup (TomitaTakesaki $M $Omega))) (stv 1.0 0.85))
;; K-theory of C*-algebras provides topological invariants via K0 and K1 groups
(|- ((==> (&& (--> CStarAlgebra $A) (--> EquivalenceClasses $K0) (--> UnitaryClasses $K1))) (--> TopologicalInvariant (KTheory $A))) (stv 1.0 0.85))
;; Noncommutative geometry generalizes Riemannian geometry via spectral triples
(|- ((==> (&& (--> CStarAlgebra $A) (--> HilbertSpace $H) (--> DiracOperator $D))) (--> NoncommutativeGeometry (SpectralTriple $A $H $D))) (stv 1.0 0.85))
