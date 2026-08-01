; DOMAIN: physics/statistical-mechanics [CLOSED, derived 2026-08-01]; Claim: Statistical mechanics derives macroscopic thermodynamics from microscopic dynamics via ensembles. The microcanonical ensemble (fixed N,V,E) gives the entropy S = k ln W where W is the phase-space volume. The canonical ensemble (fixed N,V,T) is derived from the microcanonical by coupling to a heat bath, giving the partition function Z = sum exp(-beta H) and free energy F = -kT ln Z. The grand canonical ensemble (fixed V,T,mu) allows particle exchange, with grand partition function. Phase transitions are classified by Landau theory: symmetry-breaking order parameters, continuous (2nd order) transitions with critical exponents and scaling, and first-order transitions. The renormalization group connects critical behavior to universality classes.
; Structure: (microcanonical: S=k ln W, equal a priori probability) (canonical: Z=sum exp(-beta H), F=-kT ln Z, equipartition) (grand canonical: particle exchange, chemical potential) (Landau theory: order parameter, free energy expansion, symmetry breaking) (critical phenomena: critical exponents, scaling relations, universality) (RG: fixed points define universality classes).
; Result: Statistical mechanics bridges microscopic dynamics and macroscopic thermodynamics through ensembles. The partition function encodes all thermodynamic observables. Phase transitions emerge from collective behavior, classified by Landau symmetry breaking and characterized by universal critical exponents. The RG provides the theoretical framework for universality.
; Bridge: genesis_thermodynamics_maxent + genesis_large_deviations + genesis_information_geometry + genesis_renormalization_group
;; Microcanonical ensemble: entropy from phase-space volume
(|- ((==> (&& (--> Ensemble Microcanonical) (--> Fixed N V E)) (--> Entropy (* k (Log W)))) (stv 1.0 0.95)))
;; Equal a priori probability in microcanonical ensemble
(|- ((==> (--> Ensemble Microcanonical) (--> ProbabilityDistribution Uniform)) (stv 1.0 0.9)))
;; Canonical ensemble: partition function
(|- ((==> (&& (--> Ensemble Canonical) (--> Fixed N V T)) (--> PartitionFunction (Sum (Exp (* (- beta) H))))) (stv 1.0 0.95)))
;; Canonical ensemble: free energy from partition function
(|- ((==> (&& (--> Ensemble Canonical) (--> PartitionFunction $Z)) (--> FreeEnergy (* (- k) T (Log $Z)))) (stv 1.0 0.95)))
;; Grand canonical ensemble: particle exchange with reservoir
(|- ((==> (&& (--> Ensemble GrandCanonical) (--> Fixed V T mu)) (--> GrandPartitionFunction (Sum (Exp (* (- beta) (- H (* mu N))))))) (stv 1.0 0.9)))
;; Equipartition theorem: each quadratic degree of freedom contributes kT/2
(|- ((==> (&& (--> Ensemble Canonical) (--> QuadraticDoF $f)) (--> EnergyContribution (* (/ k T) 0.5))) (stv 1.0 0.9)))
;; Landau theory: free energy expansion in order parameter
(|- ((==> (&& (--> PhaseTransition SecondOrder) (--> OrderParameter $m)) (--> LandauFreeEnergy (+ a0 (* a2 m m) (* a4 m m m m)))) (stv 1.0 0.85)))
;; Symmetry breaking: order parameter nonzero below critical temperature
(|- ((==> (&& (--> Temperature $T) (< $T Tc) (--> PhaseTransition SecondOrder)) (--> OrderParameter Nonzero)) (stv 1.0 0.9)))
;; Critical exponents: power-law behavior near critical point
(|- ((==> (&& (--> Observable $O) (--> Near $Tc) (--> CriticalExponent $alpha))) (--> ScalingLaw (PowerLaw $O (- $T Tc) $alpha))) (stv 1.0 0.85)))
;; Scaling relations connect critical exponents
(|- ((==> (--> CriticalExponents $alpha $beta $gamma $delta $nu $eta)) (--> ScalingRelation (- (* 2 $alpha) (+ (* 2 $beta) $gamma) 0))) (stv 1.0 0.8)))
;; Universality: critical exponents depend on symmetry and dimension, not microscopic details
(|- ((==> (&& (--> CriticalExponent $alpha) (--> SymmetryClass $C) (--> Dimension $d))) (--> UniversalityClass (× $C $d))) (stv 1.0 0.85)))
;; RG bridge: fixed points define universality classes
(|- ((==> (&& (--> RGFlow $f) (--> FixedPoint $f))) (--> UniversalityClass $f)) (stv 1.0 0.85)))
;; Correlation length divergence near critical point
(|- ((==> (&& (--> Near $Tc) (--> CriticalExponent $nu))) (--> CorrelationLength (PowerLaw xi (- T Tc) (- $nu))) (stv 1.0 0.85)))
