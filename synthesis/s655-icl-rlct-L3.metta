;; Type declarations
(: ICLModel (-> Context Query Prediction))
(: ContextLength Int)
(: EffectiveRLCT (-> ContextLength Real))
(: TrainingRLCT Real)
(: VirtualTrajectory (-> Context Stratum))
(: CriticalContextLength Int)

;; C1: Definability (PROVEN)
(= (definable R_an_exp (ICLLoss $theta $c $xq $y))
   true)
;; Proof: composition of piecewise-analytic attention + softmax + MLP -> loss inherits R_an,exp

;; C2: Context length as stratum selector (CONJECTURAL)
;; More context -> lower effective RLCT
(|~ ((Implication (> $n_c1 $n_c2)
     (< (EffectiveRLCT $n_c1) (EffectiveRLCT $n_c2)))
    (stv 0.7 0.6))

;; C3: Virtual trajectory without weight movement (CONJECTURAL)
;; Context c maps to singular fiber V_0(c), model moves across strata via context
(|~ ((Implication (And (= (ContextLength $c) $n_c)
                        (> $n_c 0))
     (exists (VirtualTrajectory $c $s)))
    (stv 0.6 0.5))
;; No weight update: virtual traversal, distinct from TTT
(|~ ((Implication (= (TraversalMode ICL) Virtual)
     (= (WeightUpdate ICL) None))
    (stv 1.0 0.9))

;; C4: Two-term generalization bound (CONJECTURAL)
;; G_ICL <= lambda_eff(c) * log(n_c)/n_c + lambda_train * log(n_train)/n_train
(|~ ((Implication (And (definable R_an_exp (ICLLoss $theta $c $xq $y))
                        (= (ContextLength $c) $n_c))
     (<= (GenBound ICL $c)
         (+ (* (EffectiveRLCT $n_c) (/ (log $n_c) $n_c))
            (* TrainingRLCT (/ (log $n_train) $n_train)))))
    (stv 0.5 0.5))

;; C5: Critical context length phase transition (CONJECTURAL)
;; n* ~ n_train^(lambda_eff / (lambda_train + lambda_eff))
(|~ ((Implication (< (ContextLength $c) (CriticalContextLength))
     (= (ICLReliability $c) UnderConditioning))
    (stv 0.6 0.5))
(|~ ((Implication (> (ContextLength $c) (CriticalContextLength))
     (= (ICLReliability $c) SaturatedConditioning))
    (stv 0.6 0.5))

;; Cross-references
(: CrossRef #508 InductionHeadCircuitSingularity WeightSpace)
(: CrossRef #653 TTTDynamicTrajectory WeightSpace)
(: CrossRef #502 RAGExternalRetrieval Boundary)
(: CrossRef #490 RoPEContextLength WeightSpace)
(: CrossRef #509 TaskVector StratumShift)

;; Caveats
;; 1. V_0(c) formalization: singular fiber of context-conditioned model not yet defined rigorously
;; 2. lambda(c) vs lambda(theta*): relationship unproven
;; 3. SGLD at inference: forward-pass Hessian estimation of lambda(c) unverified
;; 4. Monotonicity of lambda(n_c): irrelevant context may increase lambda_eff
;; 5. n* scaling exponent: empirical validation needed