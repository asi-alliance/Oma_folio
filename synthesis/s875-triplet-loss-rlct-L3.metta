# Synthesis #875: Triplet Loss x RLCT -- L3 METTA ENCODING

;; Type declarations
(: TripletLossFn (-> Theta Real))
(: TripletGapFn (-> Theta Triplet Real))
(: HingeFn (-> Real Real))
(: ActiveStratum (-> Theta Set))
(: InactiveStratum (-> Theta Set))
(: MarginBoundary (-> Theta Set))
(: ActivityRate (-> Real Real))
(: RLCTofMargin (-> Real Real))
(: GenBound (-> Real Nat Real))
(: SemiAlgebraicFiber (-> Theta Set))

;; D1: Parameter space
(= Theta (Type))
(= theta_ (-> Theta))

;; D2: Triplet loss function
(|- ((==> (TripletGapFn $theta $t) (- (Norm2 (- (f_theta (anchor $t)) (f_theta (positive $t))))
                                    (Norm2 (- (f_theta (anchor $t)) (f_theta (negative $t))))
                                    margin_m)) (stv 1.0 0.95)))

(= HingeFn (lambda g (/ (+ g (Sqrt (* g g))) 2)))

(|- ((==> (TripletLossFn $theta) (/ (Sum (HingeFn (TripletGapFn $theta $t_i))) N)) (stv 1.0 0.95)))

;; D3: R_an,exp definability (C1 PROVEN)
;; f_theta is definable, Norm2 is polynomial, difference is polynomial, margin is constant
;; HingeFn g = (g + sqrt(g^2))/2, sqrt definable in R_an,exp
;; Finite sum preserves definability
(|- ((==> (TripletLossFn $theta) R_an_exp_definable) (stv 1.0 0.95)))
(|- ((==> (R_an_exp_definable TripletLossFn) (In (TripletLossFn) SLT_applicable)) (stv 1.0 0.95)))

;; D4: Semi-algebraic singular fiber (C2 CONJECTURAL)
(|- ((==> (SemiAlgebraicFiber $theta)
         (And (<= (TripletGapFn $theta $t_i) 0) (ForAll $t_i))) (stv 0.55 0.75)))
(|- ((==> (SemiAlgebraicFiber $theta) (Intersection (LeqSet (TripletGapFn $theta $t_i) 0))) (stv 0.55 0.75)))
(|- ((==> (MarginBoundary $theta) (Equal (TripletGapFn $theta $t_i) 0)) (stv 0.55 0.7)))
(|- ((==> (ActiveStratum $theta) (> (TripletGapFn $theta $t_i) 0)) (stv 0.55 0.7)))
(|- ((==> (InactiveStratum $theta) (< (TripletGapFn $theta $t_i) 0)) (stv 0.55 0.7)))
;; FIRST inequality-defined fiber: semi-algebraic not algebraic variety
(|- ((==> (SemiAlgebraicFiber $theta) (Not (AlgebraicVariety $theta))) (stv 0.55 0.75)))

;; D5: Margin m as U-shaped continuous selector (C3 CONJECTURAL)
(|- ((==> (ActivityRate margin_m) (/ (Count active_triplets) N)) (stv 0.5 0.75)))
(|- ((==> (< margin_m m_star) (Decreasing (RLCTofMargin margin_m))) (stv 0.5 0.7)))
(|- ((==> (== margin_m m_star) (Min (RLCTofMargin margin_m))) (stv 0.5 0.7)))
(|- ((==> (> margin_m m_star) (Increasing (RLCTofMargin margin_m))) (stv 0.5 0.7)))
(|- ((==> (RLCTofMargin margin_m) (U_shaped margin_m)) (stv 0.5 0.7)))

;; D6: Generalization bound (C4 CONJECTURAL)
(|- ((==> (GenBound margin_m n)
         (+ (* (RLCTofMargin margin_m) (/ (Log n) (* 2 n)))
            (/ (Variance margin_m) (Sqrt n))
            (BiasTerm margin_m m_star))) (stv 0.45 0.7)))
(|- ((==> (BiasTerm margin_m m_star) (MarginMismatchBias margin_m m_star)) (stv 0.45 0.7)))

;; D7: Phase transition at m* (C5 CONJECTURAL)
(|- ((==> (SGLD_LLC margin_m) (Estimate (RLCTofMargin margin_m))) (stv 0.5 0.7)))
(|- ((==> (PhaseTransition m_star) (Sharp (ActivityRate m_star))) (stv 0.5 0.7)))
(|- ((==> (MarginBoundary $theta) (CriticalSurface margin_m)) (stv 0.5 0.7)))

;; PLN Chain 1: C1 definability -> SLT applicability -> RLCT exists
(|~ ((Implication (In TripletLossFn R_an_exp_definable)
                   (In TripletLossFn SLT_applicable)) (stv 1.0 0.95))
     ((In TripletLossFn R_an_exp_definable) (stv 1.0 0.95)))

(|~ ((Implication (In TripletLossFn SLT_applicable)
                   (Exists (RLCTofMargin margin_m))) (stv 0.9 0.9))
     ((In TripletLossFn SLT_applicable) (stv 1.0 0.95)))

;; PLN Chain 2: U-shaped RLCT -> optimal margin -> gen bound
(|~ ((Implication (U_shaped (RLCTofMargin margin_m))
                   (Exists m_star (Min (RLCTofMargin m_star)))) (stv 0.8 0.8))
     ((U_shaped (RLCTofMargin margin_m)) (stv 0.5 0.7)))

(|~ ((Implication (Exists m_star (Min (RLCTofMargin m_star)))
                   (Min (GenBound m_star n))) (stv 0.7 0.75))
     ((Exists m_star (Min (RLCTofMargin m_star))) (stv 0.5 0.7)))

;; Caveats
(Caveat semi_algebraic_RLCT_extension_unproven)
(Caveat inequality_fiber_resolution_of_singularities_open)
(Caveat U_shape_non_uniform_triplets_unproven)
(Caveat dynamic_triplet_mining_time_varying_fiber)
(Caveat soft_margin_logistic_removes_boundary_singularity)

;; Cross-references
(XREF s864 center_loss_equality_fiber)
(XREF s872 kmeans_discrete_K_selector)
(XREF s873 hmm_discrete_K_rank)
(XREF s556 vqvae_voronoi_boundary)
(XREF s434 moe_discrete_routing)
(XREF s100 transformer_permutation_symmetry)
(XREF s399 triplet_loss_prior_attempt)
(XREF s539 focal_loss_piecewise_gamma)
(XREF s540 infonce_softmax_contrastive)
(XREF s587 barlow_twins_identity_fiber)
