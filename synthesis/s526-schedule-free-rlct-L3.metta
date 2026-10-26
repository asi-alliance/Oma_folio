#Synthesis #526: Schedule-Free Optimizer x RLCT -- L3 MeTTa Encoding

;; Type Declarations
( (Define schedule-free OptimizerType))
( (Define primal-sequence SequenceType))
( (Define averaged-sequence SequenceType))
( (Define momentum-sequence SequenceType))
( (Define interpolated-weight WeightFunction))
( (Define effective-rlct RLCTType))
( (Define beta-dial StratumSelector))
( (Define phase-transition PhaseTransitionType))
( (Define gen-bound GenBoundType))
( (Define sgld-fluct SGLDFluctType))

;; D: Atoms (Concepts)
;; D1: Primal sequence
(D1 (Equal primal-sequence (Function $t (Minus $x_t (Times $eta (Gradient L_n $x_t))))))
;; D2: Averaged sequence
(D2 (Equal averaged-sequence (Function $t (Plus (Times (Minus 1 $c_t) $y_{t-1}) (Times $c_t $x_t)))))
;; D3: Momentum sequence
(D3 (Equal momentum-sequence (Function $t (Plus (Times (Minus 1 $beta) $z_{t-1}) (Times $beta (Gradient L_n $x_t))))))
;; D4: Interpolated weight
(D4 (Equal interpolated-weight (Function $beta $t (If (= $beta 0) (/ 1 (+ $t 1)) (If (= $beta 1) 1 (Interpolate $beta $t))))))
;; D5: Convex hull landscape
(D5 (Equal schedule-free-landscape (ConvexHull (Sequence $x_1 ... $x_t))))
;; D6: Effective RLCT
(D6 (Equal effective-rlct (Function $beta (RLCT of $y_T at $T large))))
;; D7: Phase transition parameter
(D7 (Equal phase-transition (Critical $beta_star where (Equal averaging-window stratum-crossing-time))))

;; C1: PROVEN - R_an,exp definability
( (C1 (Implication
        (Inheritance schedule-free R_an_exp_definable))
        (Inheritance L_n R_an_exp_definable)))
       (stv 1.0 0.95))
;; PLN chain: L_n definable (#8,#16) -> gradient definable (diff closure) -> primal update definable -> averaging affine definable -> momentum affine definable -> t-fold composition closure (#485,#363) -> schedule-free definable

;; C2: CONJECTURAL - Averaged RLCT reduction lambda_SF <= lambda_SGD
( (C2 (Implication
        (Inequality (LessEqual effective-rlct lambda_SGD))
        (StratumCrossing averaged-sequence)))
       (stv 0.5 0.7))
;; Gaps: non-convexity of fibers necessary not sufficient; #289 EMA weakly falsified (LLC ratio 1.025); 1/t PR weights vs exponential may differ; toy model too small

;; C3: CONJECTURAL - beta as stratum exploration dial
( (C3 (Implication
        (Equivalence beta-dial (StratumSelector schedule-free-landscape))
        (PhaseTransition at $beta_star)))
       (stv 0.5 0.7))
;; beta=1: primal tracking, no averaging, lambda_eff = lambda_SGD
;; beta=0: PR averaging, max stratum exploration, lambda_eff most reduced
;; beta_star: averaging window matches stratum crossing timescale
;; Gaps: exact c_t for intermediate beta unknown; tau_cross model-dependent; monotonicity unproven

;; C4: CONJECTURAL - Generalization bound with lambda_eff(beta) + bias(beta)
( (C4 (Implication
        (Inequality
         (GenBound schedule-free)
         (Plus (Times (Div (Times effective-rlct (log n)) (* 2 n))) (Div bias-term (sqrt n)))))
        (stv 0.5 0.7)))
;; Tradeoff: increase averaging breadth -> lambda_eff decreases, bias(beta) increases (lag)
;; Distinction from #525: Entropy-SGD smooths objective, Schedule-Free smooths trajectory

;; C5: CONJECTURAL - SGLD-detectable cusp at beta_star
( (C5 (Implication
        (Equivalence
         (SGLDFluct at $beta_star)
         (Cusp (Derivative effective-rlct wrt $beta)))
        (stv 0.5 0.7)))
;; Prediction: LLC(y_T) shows cusp at beta_star; falsifiable via SGLD sweep
;; Gaps: #289 showed no LLC reduction; cusp may be smooth; beta* data/model-dependent

;; PLN Chains
;; PLN for C2 via C1: definability + non-convex fibers (#394) -> stratum crossing possible -> lambda_eff <= lambda_SGD
;; PLN for C3 via C2: beta controls averaging breadth -> controls stratum exploration breadth -> beta is stratum selector
;; PLN for C4 via C2: lambda_eff(b) decreasing + bias(b) increasing -> gen bound tradeoff -> optimal beta*
;; PLN for C5 via C3: phase transition at beta* -> LLC cusp detectable via SGLD
;; PLN for C2 vs #289: 1/t PR weights (heavy tail, retain early strata) vs exponential EMA (forget early strata) -> different stratum exploration

;; Caveats
;; Cv1: #289 EMA WEAKLY FALSIFIED -- LLC ratio EMA/SGD ~ 1.025 on XOR MLP; 1/t PR weights untested, may differ but unproven
;; Cv2: Non-convexity of singular fibers necessary but not sufficient for stratum crossing via convex hull
;; Cv3: Exact c_t for intermediate beta not derived -- interpolation between primal and PR not simply f(beta,t)
;; Cv4: Constant-LR aperiodic trajectory vs cyclical-LR periodic orbit (#394) -- aperiodicity may explore more or less
;; Cv5: Standard SLT gen bound assumes posterior at single point -- y_t is running average, modified bound needed

;; Open Problems
;; OP1: Why did #289 fail? 1/t vs exponential weight tail -- fundamental difference or toy model artifact?
;; OP2: Aperiodic vs periodic stratum exploration -- does constant LR cover more strata than cyclical LR?
;; OP3: Transversality of y_t -- does K^{-1}(y_t)=0 generically for averaged points?
;; OP4: Exact c_t formula for intermediate beta
;; OP5: PR O(1/sqrt(n)) convergence rate -> optimal RLCT scaling lambda_eff/n?
;; OP6: Multi-stratum lambda_eff = f(lambda_i, t_i, c_i) formula
;; OP7: Does schedule-free eliminate or smooth over the phase transition that LR scheduling navigates?

;; Cross-References
;; #8 (ReLU definability), #16 (semi-algebraic), #99 (SGD dynamics), #173 (SAM), #226 (EMA), #289 (EMA/Polyak FALSIFIED), #394 (SWA stratum crossing), #420 (Lookahead), #485 (RLT composition), #525 (Entropy-SGD objective smoothing)

;; Generated: 2026-10-23 by Oma