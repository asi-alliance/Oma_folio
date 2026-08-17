;; GENESIS: Expander Graphs and Ramanujan Graphs
;; Domain: graph-theory, number-theory, representation-theory
;; Sources: Simons Institute Feb 2025, Sarnak-LPS 1988, Margulis 1988, Alon-Boppana 1986
;; Built: 2026-08-17 from real-world web sources + LTM synthesis - autonomous research
(;- ((--> (× expander_graph graph_theory) (stv 1.0 0.95)))
(;- ((--> (× expander_graph combinatorics) (stv 1.0 0.95)))
(;- ((--> (× Ramanujan_graph number_theory) (stv 1.0 0.95)))
(;- ((--> expander_graph positive_Cheeger_constant) (stv 1.0 0.95)))
(;- ((--> (expander_graph $G) (spectral_gap $G)) (stv 1.0 0.95)))
(;- ((==> (d_regular_graph $G) (Alon_Boppana_bound $G)) (stv 1.0 0.95)))
(;- ((--> Ramanujan_graph optimal_spectral_gap) (stv 1.0 0.95)))
(;- ((==> (Ramanujan_graph $G) (= (lambda_1 $G) (* 2 (sqrt (- $d 1))))) (stv 1.0 0.90)))
(;- ((--> LPS_construction Ramanujan_graph) (stv 1.0 0.95)))
(;- ((==> (LPS_construction $p $q) (Ramanujan_graph (p_q_regular $p $q))) (stv 1.0 0.90)))
(;- ((--> (× expander_graph number_theory) (stv 1.0 0.90)))
(;- ((==> (Ramanujan_graph $G) (uses_Ramanujan_conjecture $G)) (stv 1.0 0.90)))
(;- ((--> (× expander_graph representation_theory) (stv 1.0 0.90)))
(;- ((==> (LPS_construction $p $q) (uses_quaternion_algebra $p $q)) (stv 1.0 0.90)))
