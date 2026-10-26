;; Synthesis #602: Process Reward Model (PRM) x RLCT - L3 MeTTa Encoding
;; Date: 2026-10-25
;; Status: L3 MeTTa Encoding
;; Prerequisites: L0, L1, L2 (all verified)

;; Type Declarations
(: PRMScore (-> State Action Float))
(: PRMLoss (-> Params Float))
(: StepFiber (-> Int Float Set))
(: TemporalFamily (-> Set))
(: BeamPolicy (-> Int Set))
(: ORMLoss (-> Params Float))
(: StepNoise (-> Float Set))
(: RLCT (-> Params Float))

;; D1: PRM Score Function
(= (PRMScore $theta $s $a) (NeuralNet $theta $s $a))

;; D2: PRM Training Loss (definable)
(= (PRMLoss $theta) (Sum (StepBCE $theta $t) $t))

;; D3: Per-Step Singular Fiber
(= (StepFiber $t $rstar) (LevelSet (PRMScore $theta $s_t $a_t) $rstar))

;; D4: Temporal Fiber Family
(= (TemporalFamily) (Family (StepFiber $t $rstar) $t))

;; D5: Beam Search Stratum Selector
(= (BeamPolicy $B) (TopBStrata (PRMScore $theta) $B))

;; D6: ORM Loss (sparse, single-step)
(= (ORMLoss $theta) (BCE (PRMScore $theta $s_T $a_T) $y))

;; D7: Step-Boundary Noise Tube
(= (StepNoise $eta) (Tube (StepFiber $t $rstar) $eta))

;; C1 PROVEN: PRM Loss is definable in R_{an,exp}
(|- ((==> (And (IsDefinable NeuralNet) (IsDefinable Sigmoid) (IsDefinable Log) (IsDefinable Sum)) (IsDefinable PRMLoss)) (stv 1.0 0.95)))

;; C2 CONJECTURAL: Per-step singular fibers create temporal family
(|~ ((Implication (IsCriticalPoint (PRMScore $theta $s_t $a_t)) (IsSingular (StepFiber $t $rstar))) (stv 0.6 0.8)))
(|~ ((Implication (And (IsSingular (StepFiber $t1 $rstar)) (IsSingular (StepFiber $t2 $rstar))) (IsStratified (TemporalFamily))) (stv 0.5 0.7)))

;; C3 CONJECTURAL: Beam width B acts as stratum selector with B* phase transition
(|~ ((Implication (LessThan $B $Bstar) (IsStratumConfined (BeamPolicy $B))) (stv 0.6 0.75)))
(|~ ((Implication (GreaterThan $B $Bstar) (IsStratumSpanning (BeamPolicy $B))) (stv 0.6 0.75)))
(|~ ((Implication (Equals $B $Bstar) (IsPhaseTransition (BeamPolicy $B))) (stv 0.5 0.7)))

;; C4 CONJECTURAL: Dense per-step reward reduces RLCT (desingularization)
(|~ ((Implication (And (IsDefinable PRMLoss) (IsDefinable ORMLoss) (HasDenseReward PRMLoss) (HasSparseReward ORMLoss)) (LessEq (RLCT PRMLoss) (RLCT ORMLoss))) (stv 0.7 0.8)))

;; C5 CONJECTURAL: Step-boundary noise destroys temporal strata above eta*
(|~ ((Implication (LessThan $eta $etastar) (AreDisjoint (StepNoise $eta))) (stv 0.6 0.75)))
(|~ ((Implication (GreaterThan $eta $etastar) (AreMerged (StepNoise $eta))) (stv 0.6 0.75)))
(|~ ((Implication (GreaterThan $eta $etastar) (IsDestroyed (TemporalFamily))) (stv 0.5 0.7)))

;; PLN Chain 1: PRM definability -> RLCT well-defined
(|~ ((Implication (IsDefinable PRMLoss) (IsWellDefined (RLCT PRMLoss))) (stv 1.0 0.9))
    ((IsDefinable PRMLoss) (stv 1.0 0.95)))

;; PLN Chain 2: Dense reward -> desingularization -> lower RLCT
(|~ ((Implication (HasDenseReward PRMLoss) (IsDesingularization ORM-to-PRM)) (stv 0.7 0.8))
    ((HasDenseReward PRMLoss) (stv 1.0 0.95)))

;; PLN Chain 3: Beam width phase transition via stratum selection
(|~ ((Implication (IsStratumSelector BeamPolicy) (HasPhaseTransition $Bstar)) (stv 0.6 0.75))
    ((IsStratumSelector BeamPolicy) (stv 0.5 0.7)))

;; PLN Chain 4: Noise broadening destroys strata (extends #169)
(|~ ((Implication (And (AreDisjoint (StepNoise $eta)) (GreaterThan $eta $etastar)) (AreMerged (StepNoise $eta))) (stv 0.6 0.75))
    ((AreDisjoint (StepNoise $eta)) (stv 0.5 0.7)))

;; PLN Chain 5: Temporal fiber family distinct from single-fiber models
(|~ ((Implication (HasTemporalIndex TemporalFamily) (Not (IsSingleFiber TemporalFamily))) (stv 0.8 0.85))
    ((HasTemporalIndex TemporalFamily) (stv 1.0 0.9)))

;; Caveats
;; 1. C4 may fail if step rewards conflict across timesteps
;; 2. B* characterization needs formal RLCT stratum geometry
;; 3. Transversality of V_step intersections across t not proven
;; 4. eta* depends on inter-step fiber distances - not formalized
;; 5. Partial PRM annotation creates partial singular structure

;; Cross-References: #468 #599 #136 #306 #579 #218 #414 #169 #503
