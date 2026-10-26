;; #511-R L3 MeTTa ENCODING (2026-10-22) OT x RLCT RECONSTRUCTION of #108
;; C1 proven, C2-C5 conjectural. Credit legacy #12/#108. C2 extends #396 C4.
(: Synthesis s511_ot_rlct_reconstruction)
(: Claim Concept)
(: OTCost Concept) (: WassersteinDist Concept) (: CouplingPlan Concept)
(: SingularSet Concept) (: Stratum Concept) (: SinkhornReg Concept)
(: TransportMap Concept) (: PhaseTransition Concept)
(: hasClaim Synthesis Concept)
(: hasTruth Claim TV)
(: proven Claim)
(: conjectural Claim)
(: crossRef Synthesis $X)
;; D1-D7 definitions as claims
(: D1_setup Concept) (: D2_wasserstein Concept) (: D3_otcost Concept)
(: D4_rlct Concept) (: D5_stratification Concept) (: D6_distdep_rlct Concept) (: D7_sinkhorn Concept)
(= (D1_setup) (parameter_space Theta_union R_d target_dist P_n output_dist Q_theta))
(= (D2_wasserstein) (inf_over_couplings_plans (expected_cost d_y_yp)))
(= (D3_otcost) (W_p (Q_theta P_n) argmin_over_theta))
(= (D4_rlct) (density_ratio_singular_set k_Theta smallest_stratum_multiplicity))
(= (D5_stratification) (Theta_union local_analytic_stratum Theta_lambda))
(= (D6_distdep_rlct) (lambda_P (k_Theta_P / m_P)))
(= (D7_sinkhorn) (entropic_plan T_eps eps_to_zero_recovers_C))
;; C1 PROVEN: OT cost definable in R_an, finite RLCT inherited
(|- ((--> s511_ot_rlct_reconstruction C1_proven_definability) (stv 1.0 0.9)))
(|- ((==> (--> C1_proven_definability (--> s511_ot_rlct_reconstruction ot_cost_finite_rlct)) (stv 1.0 0.9)))
;; C2 CONJECTURE: lambda(P) Wasserstein-continuous (extends #396 C4)
(|- ((--> s511_ot_rlct_reconstruction C2_lambda_wasserstein_continuous) (stv 0.55 0.7)))
(|- ((==> (--> C2_lambda_wasserstein_continuous (--> s511 delta_lambda_bounded_C_W_pq)) (stv 0.5 0.7)))
;; C3 CONJECTURE: OT convergence governed by singular posterior RLCT
(|- ((--> s511_ot_rlct_reconstruction C3_ot_convergence_rlct) (stv 0.5 0.7)))
(|- ((==> (--> C3_ot_convergence_rlct (--> s511 expected_ot_cost n_power_neg_lambda_2_lambda_plus_1)) (stv 0.5 0.7)))
;; C4 CONJECTURE: transport plans concentrate near singular set
(|- ((--> s511_ot_rlct_reconstruction C4_plan_concentration) (stv 0.5 0.7)))
(|- ((==> (--> C4_plan_concentration (--> s511 plan_mass_near_singular_set_proj)) (stv 0.5 0.7)))
;; C5 CONJECTURE: phase transition in OT map at stratum changes
(|- ((--> s511_ot_rlct_reconstruction C5_ot_phase_transition) (stv 0.5 0.7)))
(|- ((==> (--> C5_ot_phase_transition (--> s511 lambda_jumps_detect_stratum_change)) (stv 0.5 0.7)))
;; PLN chain: definability + concentration -> convergence correction
(|- ((==> (--> C1_proven_definability) (--> C4_plan_concentration (--> C3_ot_convergence_rlct))) (stv 0.6 0.7)))
;; PLN chain: C2 continuity + C5 transition -> detectability
(|- ((==> (--> C2_lambda_wasserstein_continuous) (--> C5_ot_phase_transition detectable)) (stv 0.55 0.7)))
;; Caveats
(: caveat reconstruction_wording_drift_from_lost_original)
(: caveat c2_only_extension_novel_unproven_at_bound_level)
(: caveat ot_rates_standardly_dimension_driven)
(: caveat sinkhorn_eps_interplay_unverified)
(: caveat multimarginal_untested)
;; Cross-refs
(crossRef s511 12) (crossRef s511 396) (crossRef s511 108)
(crossRef s503 8) (crossRef s511 16) (crossRef s511 57) (crossRef s511 73)
(crossRef s511 100) (crossRef s511 127) (crossRef s511 226) (crossRef s511 363)
