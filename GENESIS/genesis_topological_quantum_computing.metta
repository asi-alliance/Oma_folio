; DOMAIN: physics/topological-quantum-computing [CLOSED, derived 2026-08-01]; Claim: Topological quantum computing (TQC) uses anyons — quasiparticles with non-Abelian braiding statistics — to perform quantum computation that is inherently protected from local decoherence. The computational gates arise from braiding anyons, where the unitary operations depend only on the topology of the braid, not on local perturbations. Key anyon models include Fibonacci anyons (universal for BQP) and Ising anyons (Clifford gates, not universal without supplementation). The braiding representation maps braid group elements to unitary operators on the degenerate ground state manifold. TQC connects to Chern-Simons TQFT, modular tensor categories, and topological phases of matter.
; Structure: (anyons: non-Abelian quasiparticles) (braiding: topological gates) (fusion rules: anyon combining) (F-matrix: fusion basis change) (R-matrix: braiding action) (modular tensor category: algebraic framework) (Chern-Simons TQFT: physical realization) (topological protection: error resilience)
; Bridge: genesis_quantum_field_theory + genesis_knot_theory + genesis_condensed_matter + genesis_category_theory
;; Non-Abelian anyons are quasiparticles with braiding-dependent ground state degeneracy
(|- ((==> (&& (--> TopologicalPhase $P) (--> Quasiparticle $A) (--> NonAbelian $A))) (--> DegenerateGroundStates $A)) (stv 1.0 0.9))
;; Braiding anyons implements unitary gates depending only on braid topology
(|- ((==> (&& (--> Anyon $A) (--> BraidGroup $B) (--> Braid $b))) (--> UnitaryGate (BraidRepresentation $b))) (stv 1.0 0.9))
;; Fusion rules describe how anyons combine to form other anyons
(|- ((==> (&& (--> Anyon $A) (--> Anyon $B) (--> FusionOutcome $C))) (--> FusionRule (× $A $B) $C)) (stv 1.0 0.9))
;; F-matrix describes basis change between different fusion paths
(|- ((==> (&& (--> Anyon $A) (--> Anyon $B) (--> Anyon $C) (--> FusionBasis $f1 $f2))) (--> FMatrix (BasisChange $f1 $f2))) (stv 1.0 0.85))
;; R-matrix describes the unitary action of braiding two anyons
(|- ((==> (&& (--> Anyon $A) (--> Anyon $B) (--> Braid $b))) (--> RMatrix (UnitaryAction $b))) (stv 1.0 0.85))
;; Fibonacci anyons are universal for quantum computation via dense braid group representations
(|- ((==> (&& (--> Anyon $A) (--> FibonacciType $A) (--> DenseRepresentation $R))) (--> UniversalQC $A)) (stv 1.0 0.85))
;; Ising anyons realize Clifford gates but are not universal without supplementation
(|- ((==> (&& (--> Anyon $A) (--> IsingType $A))) (--> CliffordGates $A)) (stv 1.0 0.85))
;; Topological protection provides inherent error resilience from non-local encoding
(|- ((==> (&& (--> Anyon $A) (--> NonLocalEncoding $E))) (--> ErrorResilience $A)) (stv 1.0 0.85))
