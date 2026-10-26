;; MeTTa encoding for #611 NAdam × RLCT
;; Types
(: NAdamState Type)
(: DisplacedLoss Type)
(: DisplacedFiber Type)
(: StratumSelector Type)
(: DisplacementBias Type)
(: PhaseTransition Type)
(: LookaheadPoint Type)

;; D1: NAdam update with Nesterov lookahead
(= (lookahead-displacement mu beta1 m) (* mu beta1 m))
(= (displaced-gradient theta mu beta1 m) (grad L (Subtract theta (lookahead-displacement mu beta1 m))))
(= (nadam-momentum m-prev g beta1) (+ (* beta1 m-prev) (* (- 1 beta1) g)))
(= (nadam-second-moment v-prev g beta2) (+ (* beta2 v-prev) (* (- 1 beta2) (* g g))))
(= (nadam-update theta m v eta eps) (Subtract theta (* eta (Divide m (+ (sqrt v) eps)))))

;; D2: Displaced loss L_mu(theta) = L(theta - mu*beta1*m)
(= (displaced-loss L mu m) (Compose L (ShiftFn (* mu m))))
;; L_mu is analytic translate of L by displacement d = mu*beta1*m

;; D3: Displaced singular fiber
(= (displaced-fiber S0 c d) (TranslateFiber S0 c d))
;; S_mu(c) = S_0(c) + d (translate of original fiber)
;; Fisher information J_mu(theta) = J_0(theta - d) (Jacobian at displaced point)

;; D4: Mu as stratum selector
(= (stratum-membership theta d strata) (ArgMin k (InStratum (Subtract theta d) strata_k)))
;; mu=0: sigma = sigma_Adam (no displacement)
;; mu=1: maximum Nesterov displacement
;; Intermediate: continuous stratum selection path

;; D5: Displacement bias generalization bound
(= (gen-bound-nadam lambda_mu n U_mu) (+ (Divide lambda_mu n) (Divide U_mu (sqrt n))))
;; U_mu = |lambda_mu - lambda_0| * C_stratum (stratum mismatch cost)
;; lambda_mu = lambda_0 by translation invariance, but U_mu captures membership mismatch

;; D6: Phase transition at mu*
(= (critical-mu lambda n) (Expt n (- 0 (Divide 1 (+ lambda 1)))))
;; mu* ~ n^{-1/(lambda+1)}
;; Below mu*: sigma(mu) = sigma(0) (same stratum)
;; Above mu*: sigma(mu) != sigma(0) (stratum crossing)

;; D7: SGLD displaced complexity measure
(= (sgld-displaced-complexity theta mu m) (LocalRLCT (Subtract theta (* mu m))))
;; C_SGLD(theta, mu) - C_SGLD(theta, 0) measures stratum difference at lookahead point

;; C1 PROVEN: R_{an,exp} definability
(|- ((==> (NAdam-definable NAdamState) (RLCT-well-defined NAdamState)) (stv 1.0 0.95))
    ((NAdam-definable NAdamState) (stv 1.0 0.9)))

;; C2 CONJECTURAL: Displaced fiber is translate, RLCT invariant but stratum membership changes
(|- ((==> (Translation-invariance-RLCT L d) (Equal-RLCT (displaced-loss L mu m) L)) (stv 0.6 0.75))
    ((Translation-invariance-RLCT L d) (stv 1.0 0.9)))

;; C3 CONJECTURAL: Mu parameterizes continuous stratum selection path
(|~ ((Implication (StratumSelector $mu) (Piecewise-constant $mu)) (stv 0.6 0.7))
    ((StratumSelector 0.5) (stv 1.0 0.9)))

;; C4 CONJECTURAL: Displacement bias in gen bound from stratum mismatch
(|~ ((Implication (DisplacementBias $mu) (Gen-bound-degraded $mu)) (stv 0.5 0.65))
    ((DisplacementBias 0.5) (stv 1.0 0.9)))

;; C5 CONJECTURAL: Phase transition at mu* ~ n^{-1/(lambda+1)}
(|- ((==> (Gt $mu (critical-mu lambda n)) (Stratum-crossing $mu)) (stv 0.5 0.6))
    ((Gt 0.5 (critical-mu 2.0 10000)) (stv 1.0 0.9)))

;; PLN Chain 1: Translation invariance of RLCT under analytic diffeomorphism
(|~ ((Implication (And (Inheritance $L AnalyticLoss) (Inheritance $d AnalyticShift))
           (RLCT-invariant-under-translation $L $d)) (stv 0.8 0.9))
    ((Inheritance L AnalyticLoss) (stv 1.0 0.9)))

;; PLN Chain 2: Mu=0 reduces NAdam to Adam
(|- ((==> (Eq mu 0) (NAdam-reduces-to-Adam)) (stv 1.0 0.95))
    ((Eq 0 0) (stv 1.0 0.9)))

;; PLN Chain 3: Stratum crossing implies displacement bias
(|~ ((Implication (And (Stratum-crossing $mu) (StratumSelector $mu))
           (Nonzero-displacement-bias $mu)) (stv 0.6 0.7))
    ((Stratum-crossing 0.5) (stv 1.0 0.9)))

;; PLN Chain 4: Well-tuned mu minimizes displacement bias
(|~ ((Implication (And (In $mu OptimalRange) (DisplacementBias $mu))
           (Minimized-bias $mu)) (stv 0.7 0.8))
    ((In 0.25 OptimalRange) (stv 1.0 0.9)))

;; PLN Chain 5: Lookahead probes different stratum than current point
(|- ((==> (Gt mu mu-star) (Different-stratum theta (Subtract theta (* mu m)))) (stv 0.5 0.7))
    ((Gt 0.5 mu-star) (stv 1.0 0.9)))

;; Open Problems
;; 1. Is RLCT translation invariant when displacement d depends on random variable m (not fixed)?
;; 2. Characterize P(sigma(mu) != sigma(0)) as function of mu and training step t
;; 3. Can U(mu) be bounded by Fisher information distance d_F(theta, theta-d)?
;; 4. Does mu* depend on network width, depth, dataset size? Universal scaling?
;; 5. Does NAdam converge to different singular stratum than Adam in practice?
;; 6. Predictor-corrector interpretation of Nesterov as fiber-following scheme?
;; 7. SGLD at theta vs theta-d for varying mu — empirical RLCT difference?

;; Cross-References
;; #289 (Adam × RLCT), #304 (AdamW × RLCT), #305 (Lion × RLCT), #621 (Lion L1),
;; #420 (Lookahead × RLCT), #394 (SWA × RLCT), #100 (RLCT basics), #8 (SGLD), #16 (singular strata)

;; Date: 2026-10-25
;; Status: L3 COMPLETE