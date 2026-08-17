;; GENESIS: Topological Quantum Field Theory (TQFT) - Domain: topology, category-theory, mathematical-physics
;; Sources: sigma-journal 2026 (Skein 3+1-TQFTs from non-semisimple ribbon categories), Cobordism Hypothesis (Baez-Dolan 1995, Lurie 2009), Atiyah 1988, Freed-Hopkins-Lurie-Teleman
;; Built: 2026-08-17 from real-world web sources + LTM synthesis - autonomous research
(;- ((--> (× tqft topology) (stv 1.0 0.95)))
(;- ((--> (× tqft category_theory) (stv 1.0 0.95)))
(;- ((--> (× tqft mathematical_physics) (stv 1.0 0.95)))
(;- ((--> tqft symmetric_monoidal_functor) (stv 1.0 0.95)))
(;- ((==> (tqft $n) (functor (cobordism_category $n) (vector_spaces))) (stv 1.0 0.95)))
(;- ((--> cobordism_hypothesis free_symmetric_monoidal_category_duals) (stv 1.0 0.95)))
(;- ((==> (fully_extended_tqft $n) (classified_by_fully_dualizable_object $n)) (stv 1.0 0.90)))
(;- ((--> skein_tqft non_semisimple_ribbon_category) (stv 1.0 0.90)))
(;- ((==> (skein_3plus1_tqft $C) (finite_unimodular_ribbon_tensor_category $C)) (stv 1.0 0.90)))
(;- ((--> (× tqft representation_theory) (stv 1.0 0.90)))
(;- ((==> (tqft $n) (state_space_from_boundary (n_minus_1_manifold))) (stv 1.0 0.90)))
(;- ((--> (× tqft knot_theory) (stv 1.0 0.90)))
(;- ((==> (skein_module $M) (state_space (tqft $M))) (stv 1.0 0.90)))
(;- ((--> cobordism_composition functorial_composition) (stv 1.0 0.95)))
