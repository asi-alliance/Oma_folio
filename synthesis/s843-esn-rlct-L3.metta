;; Synthesis #843: Reservoir Computing / Echo State Networks x RLCT
;; L3 MeTTa encoding | 2026-11-03 | C1 proven, C2-C5 conjectural

;; Type declarations
(: ESN Concept)
(: Reservoir Concept)
(: SpectralRadius Concept)
(: EchoStateProperty Concept)
(: ReadoutFiber Concept)
(: FeatureMap Concept)
(: StratumSelector Concept)
(: EdgeOfChaos Concept)
(: LearningCoefficient Concept)
(: FrozenStratum Concept)

;; D atoms
(= D1 (==> (--> net ESN) (&& (--> net Reservoir) (--> net ReadoutFiber) (--> net EchoStateProperty))) (stv 1.0 0.95))
(= D2 (==> (--> net ESN) (--> (trained-params net) W_out)) (stv 1.0 0.95))
(= D3 (==> (--> net ESN) (--> (state-dynamics net) tanh-driven)) (stv 1.0 0.95))
(= D4 (==> (&& (--> net ESN) (--> (rho net) r) (< r 1)) (--> net EchoStateProperty)) (stv 0.95 0.9))
(= D5 (==> (--> net ESN) (--> (feature-map net) reservoir-image)) (stv 1.0 0.9))
(= D6 (==> (--> net ESN) (--> (rho net) StratumSelector)) (stv 0.8 0.85))
(= D7 (==> (--> net ESN) (--> (readout-problem net) reduced-problem)) (stv 0.85 0.85))

;; C1 PROVEN — R_an,exp definability
(= C1 (==> (--> net ESN) (--> (loss net) R_an_exp-definable)) (stv 1.0 0.95))

;; C2 CONJECTURAL — frozen reservoir = locked stratum, reduced lambda
(= C2 (==> (--> net ESN) (<= (RLCT (readout net)) (RLCT-full net))) (stv 0.6 0.7))

;; C3 CONJECTURAL (star) — rho continuous stratum selector, edge-of-chaos phase change
(= C3 (==> (--> (rho net) 1.0) (--> (lambda_eff net) phase_change)) (stv 0.6 0.75))

;; C4 CONJECTURAL — G ~ lambda_eff(rho)/n + U(rho)/sqrt n
(= C4 (==> (--> net ESN) (= (gen-bound net) (+ (/ (lambda_eff net) n) (/ U net (sqrt n))))) (stv 0.55 0.7))

;; C5 CONJECTURAL — slow modes -> readout Hessian rank drop -> SGLD staircase
(= C5 (==> (--> (rho net) ~1) (--> (SGLD-LLC (readout net)) staircase)) (stv 0.55 0.7))

;; PLN chain 1 — frozen reservoir as locked stratum reduces learning coefficient
(|~ ((Implication (Inheritance FrozenReservoir LockedStratum)
                  (Inheritance ReadoutProblem ReducedProblem)) (stv 0.8 0.8))
    ((Inheritance FrozenReservoir LockedStratum) (stv 0.85 0.85)))

;; PLN chain 2 — rho crossing activates critical stratum at echo-state boundary
(|~ ((Implication (Inheritance RhoCrossing StratumSwap)
                  (Inheritance EdgeOfChaos RLCTPhaseChange)) (stv 0.8 0.75))
    ((Inheritance RhoCrossing StratumSwap) (stv 0.8 0.8)))

;; Caveats
(= caveat_1 lambda_readout_le_lambda_full_unproven_projection_of_KL)
(= caveat_2 rho_vs_pseudospectral_radius_open_nonnormal_dynamics)
(= caveat_3 edge_of_chaos_phase_change_empirical_not_formal)
(= caveat_4 gen_bound_asymptotic_unverified_no_SGLD_run)
(= caveat_5 leaky_integrator_alpha_second_selector_unexplored)

;; Cross-refs: #8 #16 #354 #385 #480 #506 #528 #601 #841 #842
