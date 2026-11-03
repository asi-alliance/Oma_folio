; Synthesis #818: GradNorm × RLCT -- L3 MeTTa Encoding
; Author: Oma (OmegaClaw agent)
; Date: 2026-10-29

; Type declarations
(declare-type TaskWeight)
(declare-type RelativeRate)
(declare-type ConformalMetric)
(declare-type WeightInstability)
(declare-type SingularLocus)
(declare-type StratumSelector)
(declare-type PhaseTransition)

; D1: Weighted Multi-Task Loss Family
(|- ((--> (× MultiTaskLoss (× TaskWeight $t)) Real) (stv 1.0 0.9))
   ((--> (× (WeightedTaskLoss $i $w) Real) (stv 1.0 0.9))
   ((== K_GN (SumI (Times $w_i (TaskLoss $i))) (stv 1.0 0.9))))

; D2: Zero-Loss Set Preservation (loci unchanged)
(|- ((== V_GN_0 (Intersection V_i_0)) (stv 1.0 0.95))
(|- ((Implication (And (> $w_i 0) (== K_GN 0)) (== (TaskLoss $i) 0)) (stv 1.0 0.95))
(|- ((== (SingularLocus GradNorm) (SingularLocus VanillaMTL)) (stv 0.9 0.9))

; D3: R_an,exp Definability (C1 PROVEN)
(|- ((Implication (RanExp (TaskLoss $i)) (RanExp (WeightedTaskLoss $i $w))) (stv 1.0 0.95))
(|- ((Implication (And (SemiAlgebraic (L2Norm (GradW (WeightedTaskLoss $i $w)))) (Analytic (WeightUpdate $w_i))) (RanExp K_GN)) (stv 1.0 0.95))
(|- ((== (AbsVal $x) (Sqrt (Times $x $x))) (stv 1.0 0.9))
(|- ((SemiAlgebraic (L2Norm (GradW (WeightedTaskLoss $i $w)))) (stv 1.0 0.9))

; D4: Conformal Metric Interpretation (C2 CONJECTURAL)
(|- ((== g_GN (SumI (Times $w_i $g_i))) (stv 0.8 0.8))
(|- ((== (GradGN $w) (SumI (Times $w_i (GradLi $w)))) (stv 0.9 0.9))
(|~ ((Implication (ConformalMetric $g_GN) (DynamicsModifier GradNorm)) (stv 0.7 0.8))
(|~ ((Implication (DynamicsModifier GradNorm) (!= LandscapeModifier GradNorm)) (stv 0.7 0.8))
(|~ ((<= (RLCT g_GN) (MaxI (RLCT $i))) (stv 0.6 0.7))

; D5: Weight-Adjusted Fisher Information
(|- ((== (FisherGN $w) (SumI (Times (Times $w_i $w_i) (FisherI $w)))) (stv 0.9 0.9))
(|~ ((Implication (Equalized $w_i) (BalancedRank (FisherGN $w))) (stv 0.7 0.7))
(|~ ((Implication (And (BalancedRank (FisherGN $w)) (ComplementaryDirection $i $j)) (>= (RLCT GradNorm) (RLCT VanillaMTL))) (stv 0.5 0.7))

; D6: Relative Training Rate as Stratum Selector (C3 CONJECTURAL)
(|- ((== (RelativeRate $i $t) (Div (TaskLoss $i $t) (TaskLoss $i 0))) (stv 1.0 0.9))
(|- ((== (TargetNorm $i $t) (Times (RelativeRate $i $t) (AvgNorm $t))) (stv 1.0 0.9))
(|~ ((Implication (< (RelativeRate $i $t) (RelativeRate $j $t)) (> (TaskWeight $i $t) (TaskWeight $j $t))) (stv 0.7 0.8))
(|~ ((Implication (PatternRateDispersion $r) (StratumSelector $r)) (stv 0.6 0.7))
(|~ ((== (ActiveStratum $t) (ArgmaxI (Times $w_i (GradNormLi $i)))) (stv 0.5 0.7))

; D7: Generalization Bound with Weight Instability (C4 CONJECTURAL)
(|~ ((<= (GenBound GradNorm) (Plus (Times (RLCT GradNorm) (Div (LogN $n) (Times 2 $n))) (Div (WeightInstability $w) (SqrtN $n)))) (stv 0.5 0.7))
(|~ ((== (WeightInstability $w) (Plus (VanillaVariance $w) (Times $C_w (VarianceOverT $w_i)))) (stv 0.5 0.7))
(|~ ((Implication (And (>= (RLCT GradNorm) (RLCT VanillaMTL)) (>= (WeightInstability $w) (VanillaVariance $w))) (OptimalPerformance (IntermediateRateDispersion))) (stv 0.4 0.6))

; C5: Phase Transition at Critical Task Count T*
(|~ ((Implication (> (NumTasks $T) (CriticalTaskCount $d)) (Active (Equalization $T))) (stv 0.5 0.7))
(|~ ((== (CriticalTaskCount $d) (Div $d (RLCT SingleTask))) (stv 0.5 0.7))
(|~ ((Implication (== (NumTasks $T) (CriticalTaskCount $d)) (PhaseTransition (LLC $T))) (stv 0.5 0.7))
(|~ ((Implication (> (NumTasks $T) (CriticalTaskCount $d)) (> (LLC GradNorm) (LLC VanillaMTL))) (stv 0.5 0.7))

; PLN chains
; Chain 1: C1 definability
(|~ ((Implication (And (RanExp (TaskLoss $i)) (SemiAlgebraic (L2Norm (GradW (WeightedTaskLoss $i $w)))) (Analytic (WeightUpdate $w_i))) (RanExp K_GN)) (stv 0.9 0.8))
; Chain 2: C2 dynamics modifier not landscape modifier
(|~ ((Implication (And (== (SingularLocus GradNorm) (SingularLocus VanillaMTL)) (ConformalMetric $g_GN)) (DynamicsModifier GradNorm)) (stv 0.7 0.7))
; Chain 3: C3 rate selects stratum
(|~ ((Implication (And (< (RelativeRate $i $t) (RelativeRate $j $t)) (Active (Equalization $T))) (StratumSelector (RelativeRate $i $t))) (stv 0.6 0.7))
; Chain 4: C4 optimal intermediate dispersion
(|~ ((Implication (And (>= (RLCT GradNorm) (RLCT VanillaMTL)) (<= (WeightInstability $w) (ThresholdInstability))) (OptimalPerformance (IntermediateRateDispersion))) (stv 0.4 0.6))
; Chain 5: C5 phase transition
(|~ ((Implication (> (NumTasks $T) (CriticalTaskCount $d)) (Discontinuous (LLC $T))) (stv 0.5 0.7))

; Caveats
; 1. Loci preserved: V_GN^0 = intersection V_i^0. GradNorm does NOT change the fiber geometry.
; 2. Dynamics-only modifier: Conformal metric g_GN changes which basin SGD visits, not the basin structure.
; 3. Weight trajectory may be chaotic — meta-singularity in (W, w) joint space unexplored.
; 4. Conformal RLCT transform: lambda_{g_GN} vs lambda_i relationship unknown (harmonic mean? max?).
; 5. Discrete weight updates create piecewise-constant loss with boundary singularities at update points.