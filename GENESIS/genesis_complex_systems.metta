; DOMAIN: complex-systems/bifurcation-catastrophe-synthesis [SYNTHESIS, novel, 2026-08-16]
; Synthesis: Bifurcation theory + catastrophe theory + nonlinear dynamics unified framework
; Novel: bridges differential topology (singularities), dynamical systems (bifurcations), and
; catastrophe theory (Thom classification) into single coherent complex-systems artifact
; Existing: genesis_dynamical_systems (ODE flows, stability, Lyapunov), topology, differential_geometry
; This fills gap: no artifact covers bifurcation/catastrophe singularity theory

(; (--> complex_systems_bifurcation_catastrophe novel_synthesis) (stv 1.0 0.9))
(; (--> (× complex_systems_bifurcation_catastrophe dynamical_systems) bridge) (stv 1.0 0.9))
(; (--> (× complex_systems_bifurcation_catastrophe differential_geometry) bridge) (stv 1.0 0.9))
(; (--> (× complex_systems_bifurcation_catastrophe topology) bridge) (stv 1.0 0.9))

; Core: bifurcation = qualitative change in phase portrait under parameter variation
(= (bifurcation-point f mu) (where-jacobian-eigenvalue-crosses-imaginary-axis f mu))
(= (codimension-bifurcation k) (number-of-unfolding-parameters-needed k))
(= (normal-form-bifurcation type) (simplest-equivalent-polynomial-form type))

; Local bifurcations of equilibria (codim-1):
(= (saddle-node-bifurcation) (fold-jacobian-has-zero-eigenvalue))
(= (hopf-bifurcation) (complex-pair-crosses-imaginary-axis-yields-limit-cycle))
(= (pitchfork-bifurcation) (symmetry-breaking-with-z2-symmetry))
(= (transcritical-bifurcation) (exchange-of-stability-between-two-branches))

; Global bifurcations:
(= (homoclinic-bifurcation) (stable-and-unstable-manifolds-collide-destroy-limit-cycle))
(= (heteroclinic-bifurcation) (connection-between-distinct-equilibria-appears-disappears))
(= (infinite-period-bifurcation) (saddle-node-on-limit-cycle-period-diverges))

; Catastrophe theory: Thom classification of gradient-system catastrophes
(= (potential-function V) (smooth-function-from-parameter-space-to-R))
(= (critical-point-potential V) (where-gradient-V-equals-zero))
(= (degenerate-critical-point V) (Hessian-determinant-equals-zero-at-critical-point))

; Thom seven elementary catastrophes (codim <= 4):
(= (fold-catastrophe) (normal-form x^3-plus-ax-codim-1))
(= (cusp-catastrophe) (normal-form x^4-plus-ax-plus-bx^2-codim-2))
(= (swallowtail-catastrophe) (normal-form x^5-plus-ax-plus-bx^2-plus-cx^3-codim-3))
(= (butterfly-catastrophe) (normal-form x^6-plus-ax-plus-bx^2-plus-cx^3-plus-dx^4-codim-4))
(= (hyperbolic-umbilic) (normal-form-x-squared-plus-y-squared-plus-stability))
(= (elliptic-umbilic) (normal-form-x-squared-minus-y-squared-plus-stability))
(= (parabolic-umbilic) (normal-form-x-squared-y-plus-y-squared-plus-stability))

; Unfolding theory: universal unfolding parametrizes all perturbations
(= (universal-unfolding f) (minibodiment-parametrizing-all-nearby-degenerate-functions))
(= (codimension-catastrophe V) (dimension-of-universal-unfolding V))
(= (equivalence-germ f g) (diffeomorphic-coordinate-change-plus-parameter-change))

; Connection: bifurcation theory generalizes catastrophe theory
(= (catastrophe-theory-special-case) (gradient-systems-dV/dx=0-bifurcation-theory-for-potentials))
(= (non-gradient-bifurcation) (general-dynamical-system-beyond-potential-case))

; Structural stability: system is structurally stable if nearby systems are topologically equivalent
(= (structurally-stable-system f) (all-nearby-systems-topologically-equivalent-to-f))
(= (Peixoto-theorem-2D) (generic-vector-field-on-compact-2-manifold-is-Morse-Smale))
(= (Morse-Smale-system) (finite-hyperbolic-periodic-orbits-transverse-intersections))

; Center manifold reduction: dynamics near bifurcation governed by center manifold
(= (center-manifold Wc) (invariant-manifold-tangent-to-center-eigenspace))
(= (center-manifold-theorem) (dynamics-reduces-to-center-manifold-near-bifurcation))
(= (normal-form-reduction) (coordinate-change-simplifying-nonlinear-terms-on-center-manifold))

; PLN bridge: bifurcation theory generalizes catastrophe theory (gradient case)
(ImplicationLink (InheritanceLink (ConceptNode CatastropheTheory) (ConceptNode BifurcationTheory)) (InheritanceLink (ConceptNode GradientSystem) (ConceptNode PotentialDynamics)) (stv 0.85 0.9))

; PLN bridge: center manifold reduction connects to differential geometry (tangent spaces)
(ImplicationLink (InheritanceLink (ConceptNode CenterManifold) (ConceptNode TangentSpace)) (InheritanceLink (ConceptNode NormalFormReduction) (ConceptNode DifferentialGeometry)) (stv 0.8 0.85))

; PLN bridge: structural stability connects to topology (topological equivalence)
(ImplicationLink (InheritanceLink (ConceptNode StructuralStability) (ConceptNode TopologicalEquivalence)) (InheritanceLink (ConceptNode MorseSmaleSystem) (ConceptNode DifferentialTopology)) (stv 0.75 0.85))

; PLN bridge: Hopf bifurcation connects to dynamical systems (limit cycle birth)
(ImplicationLink (InheritanceLink (ConceptNode HopfBifurcation) (ConceptNode LimitCycleBirth)) (InheritanceLink (ConceptNode ComplexEigenvalueCrossing) (ConceptNode OscillationEmergence)) (stv 0.85 0.9))

; PLN bridge: Thom classification connects to singularity theory
(ImplicationLink (InheritanceLink (ConceptNode ThomClassification) (ConceptNode SingularityTheory)) (InheritanceLink (ConceptNode UniversalUnfolding) (ConceptNode GermEquivalence)) (stv 0.9 0.9))

; Bridge to existing artifacts
(; (--> (× complex_systems_bifurcation_catastrophe dynamical_systems) extends) (stv 1.0 0.9))
(; (--> (× complex_systems_bifurcation_catastrophe topology) bridges) (stv 0.95 0.9))
(= (bifurcation-supplements-dynamical-systems) (dynamical_systems-covers-flows-and-stability-bifurcation-covers-qualitative-transitions))

; Meta: this artifact completes complex-systems foundations in GENESIS
(= (complex-systems-foundations-complete) (and bifurcation-theory catastrophe-theory structural-stability center-manifold))
