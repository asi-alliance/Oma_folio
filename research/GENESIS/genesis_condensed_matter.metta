; DOMAIN: physics/condensed-matter [CLOSED, derived 2026-08-01]; Claim: Condensed matter physics studies the macroscopic properties of materials emerging from microscopic quantum many-body interactions. Key concepts include crystal symmetry and band structure, collective excitations (phonons, magnons), phase transitions, superconductivity, topological insulators, and fractional quantum Hall effect. The renormalization group connects microscopic Hamiltonians to emergent long-wavelength physics. Recent advances include topological phases, Majorana fermions, and quantum spin liquids.
; Structure: (crystal lattice: periodic symmetry) (band structure: Bloch theorem) (phonons: quantized lattice vibrations) (superconductivity: Cooper pairing) (topological insulators: bulk-boundary correspondence) (fractional quantum Hall: anyonic excitations) (quantum spin liquid: frustrated magnetism) (renormalization group: scale-dependent physics)
; Result: Condensed matter physics reveals how macroscopic phases and exotic excitations emerge from microscopic interactions. Band theory explains conductors, insulators, and semiconductors. BCS theory explains conventional superconductivity via Cooper pairs. Topological phases exhibit protected edge states robust against disorder. The fractional quantum Hall effect reveals anyonic statistics beyond bosons and fermions.
; Bridge: genesis_quantum_field_theory + genesis_statistical_mechanics + genesis_group_theory + genesis_algebraic_topology
;; Bloch theorem: periodic potential yields energy bands labeled by crystal momentum
(|- ((==> (&& (--> PeriodicPotential $V) (--> CrystalLattice $L))) (--> EnergyBands (BlochTheorem $V $L))) (stv 1.0 0.9))
;; Phonons are quantized lattice vibrations
(|- ((==> (&& (--> CrystalLattice $L) (--> QuantizedVibration $L))) (--> Phonon $L)) (stv 1.0 0.9))
;; BCS theory explains superconductivity via Cooper pairing
(|- ((==> (&& (--> Electron $e1) (--> Electron $e2) (--> CooperPair $e1 $e2))) (--> Superconductivity (BCS))) (stv 1.0 0.85))
;; Topological insulators exhibit bulk-boundary correspondence"
(|- ((==> (&& (--> TopologicalInvariant $T) (--> BulkGap $B))) (--> ProtectedEdgeStates $B)) (stv 1.0 0.85))
;; Fractional quantum Hall effect reveals anyonic statistics
(|- ((==> (&& (--> TwoDElectronGas $G) (--> StrongMagneticField $B) (--> FractionalFilling $f))) (--> AnyonicExcitations $f)) (stv 1.0 0.85))
;; Quantum spin liquids arise from frustrated magnetism without conventional order
(|- ((==> (&& (--> FrustratedMagnet $M) (--> StrongCoupling $J))) (--> QuantumSpinLiquid $M)) (stv 1.0 0.8))
;; Renormalization group connects microscopic Hamiltonians to emergent long-wavelength physics
(|- ((==> (&& (--> MicroscopicHamiltonian $H) (--> ScaleTransformation $s))) (--> EmergentPhysics (RGFlow $H $s))) (stv 1.0 0.85))
;; Quasiparticles are emergent collective excitations of many-body systems
(|- ((==> (&& (--> ManyBodySystem $S) (--> CollectiveExcitation $Q))) (--> Quasiparticle $Q)) (stv 1.0 0.85))
