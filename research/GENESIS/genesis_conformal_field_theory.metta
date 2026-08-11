; DOMAIN: physics/conformal-field-theory [CLOSED, derived 2026-08-01]; Claim: Conformal field theory (CFT) studies quantum field theories invariant under conformal transformations — maps that preserve angles but not necessarily distances. In 2D, the conformal symmetry algebra splits into two copies of the Virasoro algebra, enabling exact solvability. CFTs are classified by their central charge and operator content. The conformal bootstrap uses crossing symmetry and unitarity to constrain operator data. CFT underlies critical phenomena, string theory worldsheet dynamics, and the AdS/CFT correspondence.
; Structure: (conformal symmetry: angle-preserving transformations) (Virasoro algebra: 2D conformal symmetry) (central charge: anomaly classification) (primary operators: highest-weight states) (conformal bootstrap: crossing symmetry constraints) (correlation functions: determined by conformal invariance) (operator product expansion: algebraic structure) (AdS/CFT: holographic duality)
; Result: Conformal field theory provides a mathematically rigorous framework for scale-invariant quantum systems. In 2D, infinite-dimensional conformal symmetry enables exact solutions via the Virasoro algebra. The conformal bootstrap program constrains CFT data using only symmetry and consistency. CFT serves as the foundation for string perturbation theory and holographic duality.
; Bridge: genesis_quantum_field_theory + genesis_string_theory + genesis_critical_phenomena + genesis_holographic_duality
;; Conformal transformations preserve angles but not distances
(|- ((==> (&& (--> Manifold $M) (--> Metric $g) (--> ConformalMap $f))) (--> PreservesAngles $f)) (stv 1.0 0.9))
;; In 2D, conformal symmetry splits into left and right Virasoro algebras
(|- ((==> (&& (--> SpacetimeDim 2) (--> ConformalSymmetry $S))) (--> VirasoroAlgebra (× $S $S))) (stv 1.0 0.9))
;; Central charge classifies the conformal anomaly of the theory
(|- ((==> (&& (--> CFT $T) (--> CentralCharge $c))) (--> Classification $c)) (stv 1.0 0.85))
;; Primary operators are highest-weight states of the Virasoro algebra
(|- ((==> (&& (--> VirasoroAlgebra $V) (--> PrimaryOperator $O))) (--> HighestWeightState $O)) (stv 1.0 0.9))
;; Operator product expansion defines algebraic structure of local operators
(|- ((==> (&& (--> LocalOperator $O1) (--> LocalOperator $O2) (--> OPE $O1 $O2 $result))) (--> AlgebraicStructure $result)) (stv 1.0 0.9))
;; Conformal bootstrap uses crossing symmetry to constrain operator data
(|- ((==> (&& (--> CFT $T) (--> CrossingSymmetry $c))) (--> BootstrapConstraint $c)) (stv 1.0 0.85))
;; Correlation functions are fully determined by conformal invariance up to constants
(|- ((==> (&& (--> PrimaryOperator $O1) (--> PrimaryOperator $O2) (--> ConformalInvariance $S))) (--> CorrelationFunction (Determined $S))) (stv 1.0 0.85))
;; AdS/CFT correspondence relates boundary CFT to bulk gravitational theory
(|- ((==> (&& (--> CFT $boundary) (--> Gravity $bulk) (--> HolographicDuality $d))) (--> AdSCFT $d)) (stv 1.0 0.9))
