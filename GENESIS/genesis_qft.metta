; DOMAIN: physics/quantum-field-theory [CLOSED, derived 2026-08-01]; Claim: QFT quantizes classical fields on spacetime. Field phi(x) with Lagrangian density L is quantized to operator-valued distributions on Fock space. Path integral Z[J] = integral D[phi] exp(iS/hbar + iJ phi) generates Feynman diagrams perturbatively. Gauge fixing via Faddeev-Popov introduces Grassmann ghost fields canceling unphysical polarizations, yielding BRST-invariant effective action. LSZ reduction extracts S-matrix as amputated on-shell residue of n-point Green functions. Renormalization absorbs UV divergences into running couplings governed by RG flow.
; Structure: (classical field + Lagrangian density) (canonical/path-integral quantization, Fock space) (generating functional Z[J], perturbative expansion => Feynman diagrams) (gauge fixing, Faddeev-Popov ghosts, BRST symmetry) (LSZ reduction: S-matrix = amputated on-shell residue of Green functions) (renormalization: counterterms, running couplings, RG flow).
; Result: QFT unifies quantum mechanics and special relativity for fields. Particles are excitations of quantized fields, interactions are vertices in Feynman diagrams, gauge redundancy is handled by ghosts and BRST, observable scattering extracted by LSZ. Theory rendered finite by renormalization, scale dependence governed by RG.
; Bridge: genesis_gauge_theory + genesis_quantum_mechanics + genesis_renormalization_group + genesis_lagrangian_mechanics
;; QFT core structure: fields quantized on Fock space
(|- ((--> ClassicalField (× SpacetimeManifold FiberBundle)) (stv 1.0 0.95)))
;; Path integral generating functional
(|- ((==> (--> LagrangianDensity $L) (--> GeneratingFunctional (Integral D[phi] (Exp (* (+ (/ (Action $phi) hbar) (Integral J phi))))))) (stv 1.0 0.9)))
;; Perturbative expansion yields Feynman diagrams
;; Faddeev-Popov gauge fixing introduces ghosts
(|- ((==> (--> GaugeGroup Volume) (--> GhostFields GrassmannValued)) (stv 1.0 0.85)))
;; BRST symmetry encodes gauge invariance after fixing
(|- ((--> BRST Nilpotent) (stv 1.0 0.9)))
(|- ((==> (--> BRST Symmetry) (--> PhysicalStates Cohomology)) (stv 1.0 0.85)))
;; LSZ reduction: S-matrix from Green functions
(|- ((==> (&& (--> GreenFunction $G) (--> ExternalParticles $n) (--> MassPole OnShell)) (--> SMatrix (AmputatedResidue $G $n))) (stv 1.0 0.9)))
(|- ((--> Particle FockExcitation) (stv 1.0 0.95)))
(|- ((==> (--> UVDivergence Present) (--> Counterterms Absorb)) (stv 1.0 0.85)))
(|- ((--> FieldCommutator (* (/ hbar (Delta x y)) (Commutator phi pi))) (stv 1.0 0.9)))
(|- ((==> (--> RenormalizationScale $mu) (--> CouplingRunning (BetaFunction $mu))) (stv 1.0 0.9)))
(|- ((==> (--> FieldSymmetry Continuous) (--> ConservedCurrent Noether)) (stv 1.0 0.9)))
(|- ((--> Vacuum FockGroundState) (stv 1.0 0.9)))
(|- ((--> FeynmanPropagator (TimeOrdered TwoPointFunction)) (stv 1.0 0.9)))
(|- ((==> (&& (--> CorrelationFunction $n_point) (--> LSZReduction Applied)) (--> ScatteringAmplitude $n_point)) (stv 1.0 0.9)))
