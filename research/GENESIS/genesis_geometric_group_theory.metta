; DOMAIN: mathematics/geometric-group-theory [CLOSED, derived 2026-08-01]; Claim: Geometric group theory studies finitely generated groups as geometric objects via their Cayley graphs, endowed with the word metric. The central principle is that algebraic properties of groups correspond to geometric properties of their Cayley graphs. Gromov's program classifies groups by large-scale geometry — hyperbolicity, asymptotic dimension, growth rate. Key results include Gromov's theorem on polynomial growth, the Milnor-Schwarz lemma, and quasi-isometry invariants.
; Structure: (Cayley graph: group as metric space) (word metric: graph distance) (quasi-isometry: large-scale equivalence) (Gromov hyperbolicity: negative curvature analog) (asymptotic dimension: large-scale dimension) (growth rate: volume of balls) (Milnor-Schwarz lemma: group action geometry) (ends of groups: topological invariants)
; Result: Geometric group theory bridges algebra and geometry by treating groups as metric spaces via Cayley graphs. The Milnor-Schwarz lemma connects geometric actions to quasi-isometry. Gromov hyperbolicity generalizes negative curvature to discrete groups. Polynomial growth characterizes virtually nilpotent groups. Quasi-isometry invariants classify groups at large scale.
; Bridge: genesis_group_theory + genesis_differential_geometry + genesis_graph_theory + genesis_algebraic_topology
;; Cayley graph with word metric turns a finitely generated group into a metric space
(|- ((==> (&& (--> Group $G) (--> FinitelyGenerated $G) (--> GeneratingSet $S))) (--> MetricSpace (CayleyGraph $G $S))) (stv 1.0 0.9))
;; Quasi-isometry captures large-scale equivalence between metric spaces
(|- ((==> (&& (--> MetricSpace $X) (--> MetricSpace $Y) (--> QuasiIsometry $f))) (--> LargeScaleEquivalent $X $Y)) (stv 1.0 0.9))
;; Milnor-Schwarz lemma connects proper group actions to quasi-isometry
(|- ((==> (&& (--> Group $G) (--> MetricSpace $X) (--> ProperAction $G $X) (--> Geodesic $X))) (--> QuasiIsometric $G $X)) (stv 1.0 0.9))
;; Gromov hyperbolicity generalizes negative curvature to discrete groups
(|- ((==> (&& (--> CayleyGraph $C) (--> DeltaHyperbolic $C))) (--> GromovHyperbolic $C)) (stv 1.0 0.85))
;; Gromov theorem — polynomial growth implies virtually nilpotent
(|- ((==> (&& (--> Group $G) (--> PolynomialGrowth $G))) (--> VirtuallyNilpotent $G)) (stv 1.0 0.85))
;; Asymptotic dimension is a quasi-isometry invariant of groups
(|- ((==> (&& (--> Group $G) (--> QuasiIsometryInvariant $P) (--> AsymptoticDimension $d))) (--> InvariantUnderQuasiIsometry $d)) (stv 1.0 0.85))
;; Number of ends is a topological invariant of the Cayley graph
(|- ((==> (&& (--> Group $G) (--> CayleyGraph $C) (--> Ends $e))) (--> GroupInvariant $e)) (stv 1.0 0.8))
;; Quasi-isometry invariants classify groups at large scale
(|- ((==> (&& (--> Group $G) (--> Group $H) (--> QuasiIsometric $G $H))) (--> SameLargeScaleGeometry $G $H)) (stv 1.0 0.85))
