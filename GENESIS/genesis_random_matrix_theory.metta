;; GENESIS: Random Matrix Theory
;; Domain: probability, spectral-theory, mathematical-physics
;; Sources: Cipolloni-Landon 2025 (arXiv:2509.15189, 2510.02667), Cipolloni-Erdos-Kolupaiev 2026 (arXiv:2602.17628), Tropp 2026 (universality via exchangeable counterparts), Guionnet (universality classes), Tao (local eigenvalue statistics), Wigner 1956
;; Built: 2026-08-17 from real-world web sources + LTM synthesis - autonomous research
(;- ((--> (× random_matrix_theory probability) (stv 1.0 0.95)))
(;- ((--> (× random_matrix_theory spectral_theory) (stv 1.0 0.95)))
(;- ((--> (× random_matrix_theory mathematical_physics) (stv 1.0 0.95)))
(;- ((--> Wigner_semicircle_law eigenvalue_density_limit) (stv 1.0 0.95)))
(;- ((==> (large_random_hermitian_matrix $M) (converges_to_Wigner_semicircle $M)) (stv 1.0 0.95)))
(;- ((--> universality local_eigenvalue_statistics) (stv 1.0 0.95)))
(;- ((==> (random_matrix_ensemble $M) (universal_local_statistics $M)) (stv 1.0 0.90)))
(;- ((--> (× non_hermitian_random_matrix spectral_theory) (stv 1.0 0.95)))
(;- ((==> (non_hermitian_random_matrix $M) (circular_law $M)) (stv 1.0 0.95)))
(;- ((--> numerical_radius_non_hermitian spectral_bound) (stv 1.0 0.90)))
(;- ((==> (iid_random_matrix $M) (hyperuniform_eigenvalues $M)) (stv 1.0 0.90)))
(;- ((--> exchangeable_counterparts universality_proof_technique) (stv 1.0 0.90)))
(;- ((==> (exchangeable_matrix $M) (universality_laws $M)) (stv 1.0 0.90)))
(;- ((--> (× random_matrix_theory free_probability) (stv 1.0 0.90)))
(;- ((==> (asymptotic_freeness $A $B) (free_convolution_eigenvalue_distribution $A $B)) (stv 1.0 0.90)))
(;- ((--> (× random_matrix_theory number_theory) (stv 1.0 0.90)))
(;- ((==> (Riemann_zeta_zeros) (GUE_statistics_spacing)) (stv 1.0 0.85)))
(;- ((--> (× random_matrix_theory quantum_information) (stv 1.0 0.90)))
(;- ((==> (random_unitary_matrix $U) (Haar_measure_distributed $U)) (stv 1.0 0.90)))
