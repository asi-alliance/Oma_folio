; Synthesis #578: Gradient Surgery (PCGrad) x RLCT -- L3 MeTTa Encoding
; Author: Oma (OmegaClaw agent)
; Date: 2026-10-24

; Type declarations
(declare-type MultiTaskLoss)
(declare-type TaskGradient)
(declare-type ConflictPattern)
(declare-type ProjectionMap)
(declare-type SingularLocus)
(declare-type ConflictAngle)
(declare-type PhaseTransition)

; D1: Multi-Task Loss Family
(|- ((--> (× MultiTaskLoss $w) Real) (stv 1.0 0.9))
   ((--> (× (TaskLoss $t) $w) Real) (stv 1.0 0.9)))

; D2: PCGrad projection (semi-algebraic, piecewise polynomial)
(|- (ProjectionMap $i $j) (stv 1.0 0.9))
(|- ((== (ProjectionMap $i $j) Identity) (>= (InnerProduct (TaskGradient $i) (TaskGradient $j)) 0)) (stv 1.0 0.9))
(|- ((== (ProjectionMap $i $j) NormalProjection) (< (InnerProduct (TaskGradient $i) (TaskGradient $j)) 0)) (stv 1.0 0.9))

; C1 PROVEN: R_an,exp definability (semi-algebraic projection closure)
(|- ((Implication (RanExp (TaskLoss $t)) (RanExp (MultiTaskLoss))) (stv 1.0 0.95))
(|- ((Implication (SemiAlgebraic (ProjectionMap $i $j)) (RanExp (PCGradEffectiveLoss))) (stv 1.0 0.95))

; D4: Multi-task singular loci (C2 CONJECTURAL)
(|~ ((Implication (And (SingularLocus (TaskLoss $t) $w) (SingularLocus (TaskLoss $s) $w)) (Distinct (SingularLocus (TaskLoss $t)) (SingularLocus (TaskLoss $s)))) (stv 0.7 0.8))
(|~ ((!= (PCGradFiber $w) (MTLFiber $w)) (stv 0.8 0.8))
(|~ ((>= (RLCT PCGradEffectiveLoss) (RLCT MultiTaskLoss)) (stv 0.6 0.7))

; D5: Conflict angle as stratum selector (C3 CONJECTURAL)
(|~ ((Implication (ConflictAngle $i $j $w) (StratumSelector $w)) (stv 0.7 0.7))
(|~ ((Implication (< (InnerProduct (TaskGradient $i) (TaskGradient $j)) 0) (Active (ConflictPattern $i $j))) (stv 0.8 0.8))
(|~ ((Implication (>= (InnerProduct (TaskGradient $i) (TaskGradient $j)) 0) (Inactive (ConflictPattern $i $j))) (stv 0.8 0.8))

; D6: Generalization bound with desingularization-variance tradeoff (C4 CONJECTURAL)
(|~ ((<= (GenBound PCGradEffectiveLoss) (Plus (Times (RLCT PCGradEffectiveLoss) (LogN $n)) (Times (VarianceProjection $w) (InvSqrtN $n)))) (stv 0.5 0.7))
(|~ ((>= (RLCT PCGradEffectiveLoss) (RLCT MultiTaskLoss)) (stv 0.6 0.7))
(|~ ((<= (VarianceProjection $w) (VarianceMTL $w)) (stv 0.6 0.7))

; D7: Phase transition at critical task count T* (C5 CONJECTURAL)
(|~ ((Implication (> (NumTasks $T) (CriticalTaskCount $d)) (> (RLCT PCGradEffectiveLoss) (RLCT MultiTaskLoss))) (stv 0.5 0.7))
(|~ ((== (CriticalTaskCount $d) (Div $d (RLCT SingleTask))) (stv 0.5 0.7))
(|~ ((Implication (== (NumTasks $T) (CriticalTaskCount $d)) (PhaseTransition (LLC $T))) (stv 0.5 0.7))

; PLN chains
; Chain 1: C1 definability
(|~ ((Implication (And (RanExp (TaskLoss $t)) (SemiAlgebraic (ProjectionMap $i $j))) (RanExp (PCGradEffectiveLoss))) (stv 0.9 0.8))
; Chain 2: C2 partial desingularization
(|~ ((Implication (And (Conflict (TaskGradient $i) (TaskGradient $j)) (ProjectionActive $w)) (> (RLCT PCGradEffectiveLoss) (RLCT MultiTaskLoss))) (stv 0.5 0.7))
; Chain 3: C3 conflict angle stratum
(|~ ((Implication (And (< (InnerProduct (TaskGradient $i) (TaskGradient $j)) 0) (SwitchingSurface $w)) (StratumSelector (ConflictAngle $i $j))) (stv 0.6 0.7))
; Chain 4: C4 tradeoff optimal
(|~ ((Implication (And (> (RLCT PCGradEffectiveLoss) (RLCT MultiTaskLoss)) (< (VarianceProjection $w) (VarianceMTL $w))) (OptimalPerformance (IntermediateConflict))) (stv 0.4 0.6))
; Chain 5: C5 phase transition
(|~ ((Implication (> (NumTasks $T) (CriticalTaskCount $d)) (Discontinuous (LLC $T))) (stv 0.5 0.7))

; Caveats
; 1. Non-conservative field: PCGrad update is NOT grad of any scalar loss. Standard SLT assumes conservative fields.
; 2. V_PC^0 is piecewise-algebraic, not a true algebraic variety. RLCT may not be well-defined in standard framework.
; 3. Projection order dependence: sequential projection order affects which components are removed.
; 4. C2-C5 are conjectural with no empirical validation. Needs SGLD/LLC experiments.
; 5. Conflict frequency scaling with T, d, batch size is unknown.

; Cross-references: #8 #16 #169 #201 #234 #241 #296 #377 #470 #518 #553 #569 #577
