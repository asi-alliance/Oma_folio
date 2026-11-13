(declare-type VSA-Param)
(declare-type Encoding-Matrix)
(declare-type Binding-Matrix)
(declare-type Memory-Matrix)
(declare-type Readout-Matrix)
(declare-type HD-Vector)
(declare-type Loss-Map)
(declare-type Singular-Fiber)
(declare-type RLCT-Value)
(declare-type Capacity-Threshold)

;; D1: Parameter Space
(|- (Inheritance VSA-Param (Product Encoding-Matrix Binding-Matrix Memory-Matrix Readout-Matrix)) (stv 1.0 0.95))

;; D2: VSA Loss Map
(|- (Evaluation (VSA-Loss   ) (CrossEntropy (MatMul Readout-Matrix (Sign (Superpose (Bind Encoding-Matrix )))) )) (stv 1.0 0.95))

;; D3: R_an,exp Definability
(|- (Inheritance Sign-Function R_an-definable) (stv 1.0 0.9))
(|- (Inheritance VSA-Loss-Composition R_an,exp-definable) (stv 1.0 0.95))

;; D4: Singular Fiber - Normal-Crossing Divisor
(|- (Evaluation (Singular-Fiber VSA-Binding-Zero-Locus) (NormalCrossingDivisor (Union H_1 H_d))) (stv 0.55 0.7))
(|- (Evaluation (RLCT-Value VSA-Binding-Zero-Locus) (Codim 1)) (stv 0.6 0.75))

;; D5: Superposition Count k as Stratum Selector
(|- (Evaluation (StratumSelector Capacity-Threshold) (* 0.18 d)) (stv 0.55 0.7))
(|- (Implication (GreaterThan  Capacity-Threshold) (Increase RLCT-Value )) (stv 0.5 0.65))

;; D6: Generalization Bound
(|- (Evaluation (GenBound VSA ) (+ (* (/ lambda_VSA (* 2 )) (Log )) (/ U_d (Sqrt )))) (stv 0.55 0.7))

;; D7: Capacity Phase Transition
(|- (Implication (Equals  Capacity-Threshold) (PhaseTransition RLCT-Value)) (stv 0.5 0.65))

;; C1 PROVEN
(|- (Inheritance VSA-Loss-Map R_an,exp-definable) (stv 1.0 0.95))

;; C2 CONJECTURAL
(|~ (Implication (Inheritance VSA-Binding Operation) (Inheritance VSA-Singular-Fiber NormalCrossingDivisor)) (stv 0.55 0.7))

;; C3 CONJECTURAL
(|~ (Implication (Inheritance  SuperpositionCount) (Evaluation (StratumSelector ) Capacity-Threshold)) (stv 0.55 0.7))

;; C4 CONJECTURAL
(|~ (Evaluation (OptimalDimension ) (TradeOff RLCT-Value JL-Complexity)) (stv 0.5 0.65))

;; C5 CONJECTURAL
(|~ (Implication (Equals  (* 0.18 )) (PhaseTransition RLCT-Value)) (stv 0.5 0.65))
