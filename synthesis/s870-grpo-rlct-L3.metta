;; Synthesis #870: GRPO × RLCT — L3 MeTTa encoding
;; Group Relative Policy Optimization × Real Log Canonical Threshold
;; 2026-11-07 | C1 proven, C2-C5 conjectural | Extends #414

;; Type declarations
(: GRPO Concept)
(: PolicyNetwork Concept)
(: ReferencePolicy Concept)
(: ImportanceRatio Concept)
(: GroupAdvantage Concept)
(: RewardTieLocus Concept)
(: GroupSizeSelector Concept)
(: KLPenaltyTube Concept)
(: CriticFreeReduction Concept)
(: RewardCollapse Concept)
(: PhaseTransitionG Concept)
(: GeneralizationBound Concept)

;; D atoms
(= D1 (==> (--> algo GRPO) (&& (--> algo PolicyNetwork) (--> algo ReferencePolicy) (--> algo CriticFreeReduction))) (stv 1.0 0.95))
(= D2 (==> (--> algo GRPO) (--> (loss-fn algo) L_GRPO)) (stv 1.0 0.95))
(= D3 (==> (--> algo GRPO) (--> (advantage-fn algo) group-relative)) (stv 1.0 0.95))
(= D4 (==> (&& (--> algo GRPO) (= (sigma_G algo) 0)) (--> algo RewardTieLocus)) (stv 0.95 0.9))
(= D5 (==> (--> algo GRPO) (--> (group-size algo) GroupSizeSelector)) (stv 0.8 0.85))
(= D6 (==> (--> algo GRPO) (--> (kl-coef beta) KLPenaltyTube)) (stv 0.8 0.85))
(= D7 (==> (--> algo GRPO) (--> (reward-tie-locus algo) reduced-gradient)) (stv 0.85 0.85))

;; C1 PROVEN — R_an,exp definability of L_GRPO
(= C1 (==> (--> algo GRPO) (--> (loss algo) R_an_exp-definable)) (stv 1.0 0.95))

;; C2 CONJECTURAL — group size G as discrete stratum selector
(= C2 (==> (--> algo GRPO) (= (RLCT algo) (* (RLCT_pi algo) (/ G (+ G G_0))))) (stv 0.6 0.7))

;; C3 CONJECTURAL — critic-free reduces RLCT: lambda_GRPO < lambda_PPO
(= C3 (==> (--> algo GRPO) (< (RLCT algo) (RLCT PPO))) (stv 0.6 0.75))

;; C4 CONJECTURAL — KL beta as continuous stratum selector
(= C4 (==> (--> algo GRPO) (= (gen-bound algo) (+ (/ (lambda_eff beta) n) (/ (U beta) (sqrt n))))) (stv 0.55 0.7))

;; C5 CONJECTURAL — G* phase transition for reward collapse
(= C5 (==> (< G G_star) (--> (sigma_G algo) 0)) (stv 0.55 0.7))

;; PLN chain 1 — reward-tie locus as singular fiber component
(|~ ((Implication (Inheritance RewardTieLocus SingularFiber)
                (Inheritance RewardCollapse HighRLCT)) (stv 0.8 0.8))
    ((Inheritance RewardTieLocus SingularFiber) (stv 0.85 0.85)))

;; PLN chain 2 — critic-free reduction removes value-function singular fiber
(|~ ((Implication (Inheritance CriticFreeRemoval ReducedFiber)
                (Inheritance GRPO LowerRLCT)) (stv 0.8 0.75))
    ((Inheritance CriticFreeRemoval ReducedFiber) (stv 0.85 0.85)))

;; PLN chain 3 — group size G modulates accessible stratum dimension
(|~ ((Implication (Inheritance GroupSizeSelector StratumDimension)
                (Inheritance GRPO RLCTScaling)) (stv 0.75 0.75))
    ((Inheritance GroupSizeSelector StratumDimension) (stv 0.8 0.8)))

;; PLN chain 4 — KL tube intersects singular fiber, beta selects stratum
(|~ ((Implication (Inheritance KLPenaltyTube StratumSelector)
                (Inheritance BetaConstrained LowerEffectiveRLCT)) (stv 0.75 0.75))
    ((Inheritance KLPenaltyTube StratumSelector) (stv 0.8 0.8)))

;; PLN chain 5 — G* phase transition: small G triggers collapse
(|~ ((Implication (Inheritance SmallGroup RewardTieLikely)
                (Inheritance BelowGstar PhaseTransition)) (stv 0.7 0.7))
    ((Inheritance SmallGroup RewardTieLikely) (stv 0.75 0.75)))

;; Caveats
(= caveat_1 sigma_G_to_zero_rational_not_analytic_definability_holds_on_open_set)
(= caveat_2 lambda_GRPO_lt_lambda_PPO_requires_lambda_V_gt_0_assumes_independent_fibers)
(= caveat_3 G_scaling_monotone_unverified_nonmonotone_possible_at_small_G)
(= caveat_4 KL_tube_singular_fiber_intersection_transversality_not_proven)
(= caveat_5 G_star_depends_on_entropy_reward_smoothness_temperature_not_derived)

;; Cross-refs: #8 #100 #173 #213 #223 #394 #414 #496 #527 #558 #579