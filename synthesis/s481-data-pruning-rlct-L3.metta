#A4881 Data Pruning x RLCT -- L3 METTA ENCODINg
Date: 2026-10-21
Status: ENCODING

;; Type Declarations

(; Defines pruning mask as binary vector over data indices)
(declare-type PruningMask (List Integer))

(; Per-sample loss function)
(declare-type PerSampleLoss (-> Parameter (-> Input (Integer Real))) Real))
(; Defines pruned empirical loss as anonymous sum over retained sets)
(declare-type PrunedLoss (-> Parameter (-> Input Real) Integer Real))

(; Pruned true parameter set)
(declare-type PrunedTrueParamsSet (-> PrunedMask (Set Parameter)))

(; Pruned fiber level set)
(declare-type PruniedFiber (-> PrunedLoss Real (Set Parameter)))

(; PLCT as function of mask)
(declare-type PLCTFunction (-> PrunedMask Real))

(; Redundance indicator)
(declare-type RedundancyIndicator (-> Sample Integer Real)))

(; Forgetting score as memorization proxy)
(declare-type ForgettingScore (-> Sample Integer Real))

;; Claims

(; C1 PROVEN: Definability of pruned empirical loss
(metta (|
  ((==> (Inheritance PrunedMask AnalyticLossFunction))
     (Stv 1.0 0.95))
)

(; C2 CONJJECTURAL: Data-dependent fiber stratification
((; Removing redundant samples does not change W -> same PLCT
(metta (|
  ((==> (Implication
       (Inheritance (RemoveRedundantSample)
       (Property InformativeMemober))
       (Inheritance PLCTFunction Unchanged)))
     (STv 0.6 0.8))
)

(; C3 CONJJECTURAL: Phase transition at critical pruning ratio alpha*
(metta (|
  ((==> (Implication
       (Inheritance (PruningRatioAlpha)
       (Property RedundantExhausted))
       (Inheritance PLCTRegimeRedundant)))
     (Stv 0.55 0.8))
)

(; C4 CONJJECTURAL: Generalization bound for pruned dataset
(declare-type GenBoundPruned (-> PLCTFunction Real))
(metta (|
  ((==> (Implication
      (Inheritance GenBoundPuprained)
      (FunctionalImplication
        (G equals lambda over size plus U over sqrt size))))
      (Stv 0.5 0.75))
)

(; C5 CONJJECTURAL: Memorization-singularity correlation
(mette (|
  ((==> (Implication
      (Inheritance ForgettingScoreHigh)
       (Property SampleContributesToSingularity))
      (Inheritance PLCThighere))
     (STv 0.5 0.7))
)

;; Cross-references
;; #220 (parameter pruning), #178 (unlearning), #95 (curriculum), #169 (droput), #222 (weight decay), #385 (LoRA)
 ;; Open problems: 8
 ;; 1. Structure of {m : lambda(m) = c} strtati
 ;; 2. Sharpness of phase transsition at alpha*
 ;; 3. Correlation strength between forgetting score and PLCT
 ;; 4. Optimal mask may be NP-hard subset selection
 ;; 5. Data+parameter pruning interaction effect
 ;; 6. Scale-dependent alpha* behavior
 ;; 7. Theoretical lower bound on minimal pruned set size
 ;; 8. Connection to influence functions and core set selection
 ;; Caveats:€ìì€Ä¸I•‘Õ¹‘…¹ä¥Ì‘…Ñ„µ…É¡¥Ñ•ÑÕÉ”µ‘•Á•¹‘•¹Ğ°¹½ĞÕ¹¥Ù•ÉÍ…±±ä‘•™¥¹…‰±”(€ìì€È¸Mµ½½Ñ É½ÍÍ½Ù•È™½È™¥¹¥Ñ”¸µ…ä‰±ÕÈÁ¡…Í”ÑÉ…¹Í¥Ñ¥½¸(€ìì€Ì¸5•µ½É¥é…Ñ¥½¸‘•™¥¹•…Ì™½É•ÑÑ¥¹œ¥Ì¥µÁ•É™•ĞÁÉ½áä(€ìì€Ğ¸=ÁÑ¥µ…°ÁÉ¥½Èµ…äÉ•ÅÕ¥É”Í•½¹µ½É‘•È•½¹½µ¥Ì…ÁÁÉ½á¥µ…Ñ¥½¸(€ìì€Ô¸…Ñ„…¹Á…É…µ•Ñ•ÈÍÁ…”ÁÉ¥¹¥¹œµ…ä¥¹Ñ•É…Ğ¹½¸µ±¥¹•…É±ä