;; GENESIS: Optimal Transport Theory
;; Domain: probability, analysis, optimization, differential-geometry
;; Sources: arXiv:2603.25182 (Wasserstein gradient flows 2026), arXiv:2510.27120 (Monge maps 2025), Villani 2003/2009, Jordan-Kinderlehrer-Otto 1998, Benamou-Brenier
;; Built: 2026-08-17 from real-world web sources + LTM synthesis - autonomous research
(;- ((--> (× optimal_transport probability) (stv 1.0 0.95)))
(;- ((--> (× optimal_transport analysis) (stv 1.0 0.95)))
(;- ((--> (× optimal_transport optimization) (stv 1.0 0.95)))
(;- ((--> (× optimal_transport differential_geometry) (stv 1.0 0.90)))
(;- ((--> Monge_problem minimize_transport_cost) (stv 1.0 0.95)))
(;- ((==> (Monge_map $T) (push_forward_measure $T mu $nu)) (stv 1.0 0.95)))
(;- ((--> Kantorovich_duality linear_programming_relaxation) (stv 1.0 0.95)))
(;- ((==> (Kantorovich_problem $mu $nu) (minimize_coupling_integral_cost $mu $nu)) (stv 1.0 0.95)))
(;- ((--> Wasserstein_distance metric_on_probability_measures) (stv 1.0 0.95)))
(;- ((==> (Wasserstein_distance $p $mu $nu) (inf_cost (coupling $mu $nu) (|x-y|^p))) (stv 1.0 0.95)))
(;- ((--> Benamou_Brenier_formula dynamic_optimal_transport) (stv 1.0 0.90)))
(;- ((==> (Wasserstein_gradient_flow $mu_t) (PDE_continuity_equation $mu_t)) (stv 1.0 0.90)))
(;- ((--> (× optimal_transport thermodynamics) (stv 1.0 0.90)))
(;- ((==> (JKO_scheme $mu_t) (minimize_JKO_functional $mu_t)) (stv 1.0 0.90)))
(;- ((--> (× optimal_transport machine_learning) (stv 1.0 0.90)))
(;- ((==> (neural_optimal_transport $f) (dual_potential_network $f)) (stv 1.0 0.90)))
(;- ((--> Brenier_theorem quadratic_cost_unique_gradient_map) (stv 1.0 0.95)))
(;- ((==> (quadratic_cost $c) (Brenier_map $T (= (nabla phi)))) (stv 1.0 0.90)))
(;- ((--> (× optimal_transport metric_learning) (stv 1.0 0.90)))
(;- ((==> (Wasserstein_GAN $G $D) (minimax_Wasserstein_distance $G $D)) (stv 1.0 0.85)))
