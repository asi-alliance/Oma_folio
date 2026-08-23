; DOMAIN: quantum-information-theory/operator-algebras [SYNTHESIS, novel, 2026-08-17]
; Synthesis: Operator-Algebraic Quantum Error Correction (OAQEC)
; Bridges: genesis_quantum_information (Knill-Laflamme QEC), genesis_von_neumann_algebra (commutant, factors, type-I)
; Sources: Kribs-Laflamme-Poulin 2005, Dauphinais et al 2024, Nielsen 2007

(; (--> oaqec novel_synthesis) (stv 1.0 0.9))
(; (--> (× oaqec quantum_information) extends) (stv 1.0 0.9))
(; (--> (× oaqec von_neumann_algebra) bridges) (stv 1.0 0.9))
(; (--> (× oaqec c_star_algebra) bridges) (stv 0.95 0.9))

; Core: Hilbert space decomposition for subsystem codes
(= (subsystem-decomposition H A B K) (= H (direct-sum (tensor-product H-A H-B) K)))
(= (subsystem-code H A B K E-set) (and (subsystem-decomposition H A B K) (correctable-subsystem B E-set H-A H-B K)))

; Knill-Laflamme generalized to operator-valued condition
(= (correctable-subsystem B E-set H-A H-B K) (forall ($i $j) (exists (operator $M-ij) (= (* (adjoint $E-i) $E-j $P) (* $M-ij (identity-on-H-B))))))
(= (knill-laflamme-scalar-case) (= $M-ij (scalar $c-ij)))
(= (oaqec-generalizes-knill-laflamme) (=> (knill-laflamme-condition $code $P-set $E-set) (correctable-subsystem B $E-set H-A H-B K)))

; Noiseless subsystems: commutant of error algebra acts on B
(= (noiseless-subsystem B error-algebra) (= (commutant error-algebra) (bounded-operators H-A tensor identity-on-H-B)))
(= (error-algebra-generated E-set) (von-neumann-algebra-generated-by (adjoints-and-products E-set)))
(= (knill-laflamme-for-noiseless) (=> (noiseless-subsystem B error-algebra) (= $M-ij (trace-on-H-A-of $M-ij))))

; Correctability as algebraic condition
(= (correctable-algebra A E-set) (forall $E (exists $F (and (in $F error-algebra) (= (* (adjoint $E) $E) $F)))))
(= (correctable-channel N) (exists (recovery $R) (= (compose $R $N) (conditional-expectation-onto-correctable-algebra))))
(= (conditional-expectation-onto-algebra $M) (projection-from-bounded-operators-to $M))

; OAQEC stabilizer formalism (Dauphinais et al 2024)
(= (oaqec-stabilizer S A B) (and (abelian-group S) (acts-on S H-A) (= B (commutant-of-action S))))
(= (gauge-group G A B) (and (group G) (acts-on G H-A) (= B (fixpoint-subspace G))))
(= (gauge-subsystem A) (subsystem-with-nonabelian-gauge-group))
(= (bacon-shor-code) (example-of gauge-subsystem-with-abelian-stabilizer))

; Connection to von Neumann algebra type classification
(= (type-i-subsystem-code) (and (subsystem-code H A B K E-set) (type-i-factor (error-algebra-generated E-set))))
(= (type-ii-oaqec) (and (subsystem-code H A B K E-set) (type-ii-factor (error-algebra-generated E-set))))
(= (type-iii-oaqec) (and (subsystem-code H A B K E-set) (type-iii-factor (error-algebra-generated E-set))))
(= (type-ii-advantage) (type-ii-oaqec provides continuous-error-correction-without-discrete-syndrome))

; Recovery map as completely positive map
(= (recovery-map R) (and (completely-positive R) (trace-preserving R)))
(= (recovery-condition-oaqec R N A B) (= (* R (restrict N (tensor H-A H-B))) (identity-on-information-algebra)))
(= (information-algebra A B) (commutant-of-gauge-algebra-within-code-space))

; Entanglement-assisted OAQEC
(= (entanglement-assisted-oaqec N S-shared) (correctable-subsystem B (augmented-errors N S-shared) H-A H-B K))
(= (entanglement-reduces-error-algebra) (shared-entanglement-tensor-reduces-effective-error-algebra-rank))

; PLN bridge: OAQEC generalizes Knill-Laflamme from scalars to operators
(ImplicationLink (InheritanceLink (ConceptNode OAQECCondition) (ConceptNode KnillLaflammeCondition)) (InheritanceLink (ConceptNode CorrectableSubsystem) (ConceptNode QuantumErrorCorrectingCode)) (stv 0.95 0.9))

; PLN bridge: noiseless subsystem = commutant theorem application
(ImplicationLink (InheritanceLink (ConceptNode NoiselessSubsystem) (ConceptNode DoubleCommutantTheorem)) (InheritanceLink (ConceptNode ErrorAlgebraCommutant) (ConceptNode ProtectedSubspace)) (stv 0.9 0.9))

; PLN bridge: vN factor type determines OAQEC structure
(ImplicationLink (InheritanceLink (ConceptNode FactorType) (ConceptNode OAQECStructure)) (InheritanceLink (ConceptNode TypeIIFactor) (ConceptNode ContinuousErrorCorrection)) (stv 0.8 0.85))

; PLN bridge: recovery = conditional expectation (noncommutative projection)
(ImplicationLink (InheritanceLink (ConceptNode RecoveryMap) (ConceptNode ConditionalExpectation)) (InheritanceLink (ConceptNode CPTPMap) (ConceptNode VonNeumannProjection)) (stv 0.85 0.9))

; Bridge declarations
(; (--> (× oaqec quantum_information) extends) (stv 1.0 0.9))
(= (extends-quantum-information) (generalizes-knill-laflamme-from-scalar-c-ij-to-operator-M-ij))
(; (--> (× oaqec von_neumann_algebra) bridges) (stv 1.0 0.9))
(= (bridges-von-neumann-algebra) (noiseless-subsystem-via-commutant-error-algebra-is-vN-algebra-factor-type-determines-code-structure))

; Meta: completes operator-algebraic QEC synthesis
(= (oaqec-complete) (and correctable-subsystem-condition noiseless-subsystem-via-commutant oaqec-stabilizer-formalism factor-type-classification recovery-as-conditional-expectation))
