; DOMAIN: mathematics/knot-theory [CLOSED, derived 2026-08-01]; Claim: Knot theory studies embeddings of circles in 3-dimensional space up to ambient isotopy. Two knots are equivalent if one can be continuously deformed into the other without cutting. Knot invariants — quantities unchanged under Reidemeister moves — classify and distinguish knots. Key invariants include the Jones polynomial, Alexander polynomial, and knot group. Knot theory connects to topology, statistical mechanics, quantum field theory via Chern-Simons, and DNA topology.
; Structure: (knot embedding: circle in S^3) (Reidemeister moves: local equivalence moves) (knot invariants: quantities preserved under isotopy) (Jones polynomial: skein relation based invariant) (Alexander polynomial: fundamental group derived) (knot group: complement fundamental group) (Chern-Simons: topological QFT connection) (skein relations: recursive polynomial construction)
; Result: Knot theory provides topological invariants that classify embeddings of circles in 3-space. The Jones polynomial revolutionized knot theory by connecting it to statistical mechanics and quantum groups. Chern-Simons theory provides a path integral framework for computing knot invariants. Knot theory has applications in DNA topology, quantum computing, and topological phases of matter.
; Bridge: genesis_algebraic_topology + genesis_quantum_field_theory + genesis_statistical_mechanics + genesis_differential_geometry
;; Knot equivalence preserves ambient isotopy class
(|- ((==> (&& (--> Knot $K1) (--> Knot $K2) (--> AmbientIsotopy $K1 $K2))) (--> Equivalent $K1 $K2)) (stv 1.0 0.9))
;; Reidemeister moves generate all knot equivalences
(|- ((==> (&& (--> Knot $K1) (--> Knot $K2) (--> ReidemeisterMoves $K1 $K2))) (--> Equivalent $K1 $K2)) (stv 1.0 0.9))
;; Jones polynomial is a knot invariant satisfying the skein relation
(|- ((==> (&& (--> Knot $K) (--> JonesPolynomial $P) (--> SkeinRelation $P))) (--> KnotInvariant $P)) (stv 1.0 0.9))
;; Alexander polynomial derives from the knot complement fundamental group
(|- ((==> (&& (--> Knot $K) (--> KnotComplement $C) (--> FundamentalGroup $G))) (--> AlexanderPolynomial $K)) (stv 1.0 0.85))
;; Knot group is the fundamental group of the knot complement
(|- ((==> (&& (--> Knot $K) (--> KnotComplement $C))) (--> KnotGroup (FundamentalGroup $C))) (stv 1.0 0.9))
;; Chern-Simons theory provides path integral framework for knot invariants
(|- ((==> (&& (--> ChernSimonsTheory $CS) (--> WilsonLoop $W) (--> Knot $K))) (--> KnotInvariant $W)) (stv 1.0 0.85))
;; Skein relations recursively construct knot polynomials from simpler knots
(|- ((==> (&& (--> Knot $K) (--> SkeinRelation $R) (--> CrossingChange $c))) (--> RecursiveConstruction (Polynomial $K))) (stv 1.0 0.85))
