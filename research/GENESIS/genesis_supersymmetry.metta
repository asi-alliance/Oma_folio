; DOMAIN: physics/supersymmetry [CLOSED, derived 2026-08-01]; Claim: Supersymmetry (SUSY) is a spacetime symmetry relating bosons and fermions via supercharges. Each particle has a superpartner with spin differing by 1/2. SUSY addresses the hierarchy problem, enables gauge coupling unification, and provides dark matter candidates. The super-Poincare algebra extends the Poincare algebra with anticommuting generators. Spontaneous SUSY breaking is required since exact SUSY predicts degenerate mass superpartners not observed.
; Structure: (super-Poincare algebra: boson-fermion symmetry) (supercharges: anticommuting generators) (supermultiplets: boson-fermion pairs) (R-symmetry: internal rotation of supercharges) (SUSY breaking: spontaneous or explicit) (MSSM: minimal supersymmetric standard model) (non-renormalization theorems: constrained radiative corrections) (Witten index: SUSY breaking criterion)
; Result: Supersymmetry extends the Poincare algebra with fermionic generators, pairing bosons and fermions in supermultiplets. The MSSM provides the minimal realistic framework. Non-renormalization theorems constrain radiative corrections, stabilizing the hierarchy. The Witten index determines whether SUSY is spontaneously broken. While no superpartners have been observed, SUSY remains theoretically compelling for unification and dark matter.
; Bridge: genesis_quantum_field_theory + genesis_particle_physics + genesis_group_theory + genesis_cosmology
;; Super-Poincare algebra extends Poincare with anticommuting supercharges
(|- ((==> (&& (--> PoincareAlgebra $P) (--> AnticommutingGenerator $Q))) (--> SuperPoincareAlgebra (Extend $P $Q))) (stv 1.0 0.9))
(|- ((==> (&& (--> Boson $B) (--> Supercharge $Q))) (--> FermionicSuperpartner (Apply $Q $B))) (stv 1.0 0.9))
;; Supercharges satisfy anticommutation relations closing the algebra
(|- ((==> (&& (--> Supercharge $Q1) (--> Supercharge $Q2))) (--> Anticommutator (× $Q1 $Q2) (MomentumOperator))) (stv 1.0 0.85))
;; SUSY breaking is required because exact SUSY predicts degenerate superpartner masses
(|- ((==> (&& (--> ExactSUSY $S) (--> Superpartner $P1 $P2))) (--> DegenerateMass $P1 $P2)) (stv 1.0 0.9))
(|- ((==> (&& (--> Supercharge $Q) (--> InternalRotation $R))) (--> RSymmetry $R)) (stv 1.0 0.85))
;; MSSM is the minimal supersymmetric extension of the Standard Model
(|- ((==> (&& (--> StandardModel $SM) (--> SUSY $S) (--> MinimalExtension $E))) (--> MSSM $E)) (stv 1.0 0.85))
;; Non-renormalization theorems constrain radiative corrections in SUSY theories
(|- ((==> (&& (--> SUSYTheory $T) (--> Holomorphy $H))) (--> NonRenormalization $T)) (stv 1.0 0.85))
;; Witten index determines whether SUSY is spontaneously broken
(|- ((==> (&& (--> SUSYTheory $T) (--> WittenIndex $w) (--> ZeroP $w))) (--> SUSYBreaking $T)) (stv 1.0 0.85))
