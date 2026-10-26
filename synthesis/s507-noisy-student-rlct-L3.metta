;; Synthesis #507: Noisy Student x RLCT — L3 MeTTa encoding (2026-10-22)

;; Type declarations
(: Teacher Model) (: Student Model)
(: NoiseMap (-> Input Noise Input))
(: AugInput Input) (: PseudoLabel Label)
(: ConfThresh Float) (: NoiseScale Float)
(: Round Nat) (: RLCT Float)

;; D1 Student loss = expected loss over noise draws
(= (StudentLoss $T $S) (MeanOver $eps (CE (StudentForward $S (NoiseMap $x $eps)) (PseudoLabel $T $x))))

;; D2 Confidence-filtered subset
(= (FilteredSet $T $tau) (SetOf $x (>= (TeacherConfidence $T $x) $tau)))

;; C1 PROVEN: definability of M-draw empirical student loss
( |- ((IsDefinableRanExp (StudentLoss $T $S)) (stv 1.0 0.95)))

;; C2 CONJECTURAL: noise convolution as desingularizer, sigma* stratum threshold
(|~ ((Implication (IsHeatSmoothing (NoiseMap $eps)))
     (<= (RLCT (StudentLoss $T $S)) (RLCT (TeacherLoss $T)))) (stv 0.5 0.7))
(|~ ((Implication (And (= (NoiseScale $eps) (StratumThreshold $S))
                        (InStratum $S (NarrowStratum $S)))
     (Not (IsTrappedIn (StudentLoss $T $S) (NarrowStratum $S)))) (stv 0.5 0.7))

;; C3 CONJECTURAL: confidence filter as stratum selector
(|~ ((Implication (>= (ConfThresh $tau1) (ConfThresh $tau2))
     (<= (RLCT (FilteredSet $T $tau1)) (RLCT (FilteredSet $T $tau2)))) (stv 0.5 0.7))

;; C4 CONJECTURAL: capacity asymmetry — equal-or-larger student, lower lambda
(|~ ((Implication (And (>= (Capacity $S2) (Capacity $S1))
                      (SameNoise (NoiseMap $eps)))
     (<= (RLCT (StudentLoss $T $S2)) (RLCT (StudentLoss $T $S1)))) (stv 0.5 0.7))

;; C5 CONJECTURAL: iterative round map monotonically decreases RLCT, r* transition
(|~ ((Implication (>= (Round $r1) (Round $r2))
     (<= (RLCT (StudentOfRound $r1)) (RLCT (StudentOfRound $r2)))) (stv 0.5 0.7))
(|~ ((Implication (= (Round $r) (PhaseTransitionRound)) (IsFixedPoint (PseudoLabelDist $r))) (stv 0.5 0.7))

;; PLN chain example: noise smoothing + higher tau jointly lower student RLCT
(|~ ((Implication (And (IsHeatSmoothing (NoiseMap $eps)) (In $x (FilteredSet $T $tau)))
     (<= (RLCT (StudentLoss $T $S)) (RLCT (TeacherLoss $T)))) (stv 0.5 0.65))

;; Caveats
;; 1. C1 holds for M-draw empirical losses; infinite convolution limit definability unproven (cf. #261)
;; 2. C2 monotonicity of lambda(sigma) unproven — smoothed loss RLCT need not be monotone
;; 3. C3 input-space subset -> parameter-space strata pushforward argument missing
;; 4. C4 no theorem bounds lambda of wider net on smoothed loss
;; 5. C5 round map contraction on strata unproven; r* heuristic

;; Cross-references
;; #8 #16 #73 #88 #100 #261 #289 #296 #327 #334 #377 #424
