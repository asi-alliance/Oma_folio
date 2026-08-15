; DOMAIN: de-rham-cohomology [REBUILD, 2026-08-14]; Source: de Rham 1931; Poincare 1895; Hodge 1941; Stokes 1850; Cartan 1945
; Bridges: genesis_differential_geometry, genesis_algebraic_topology, genesis_chern_character, genesis_spectral_sequences
(= (differential-form $omega $M $k) (and (smooth-manifold $M) (section $omega (wedge-power (cotangent-bundle $M) $k))))
(= (exterior-derivative $d) (and (linear-map $d (forms $M $k) (forms $M (+ $k 1))) (compose $d $d 0) (graded-derivation $d (degree 1) (wedge-product))))
(= (de-rham-cohomology $H $M $k) (and (smooth-manifold $M) (= ($H $k $M) (quotient (closed-forms $k $M) (exact-forms $k $M))) (= (closed-forms $k $M) (kernel ($d $k))) (= (exact-forms $k $M) (image ($d (- $k 1))))))
(= (stokes-theorem $M $omega) (and (smooth-manifold $M) (differential-form $omega $M (- (dim $M) 1)) (= (integral (boundary $M) $omega) (integral $M ($d $omega)))))
(= (hodge-decomposition $M $g) (and (riemannian-manifold $M $g) (= (forms $k $M) (direct-sum (exact-forms $k) (coexact-forms $k) (harmonic-forms $k))) (orthogonal-decomposition)))
(= (poincare-lemma $M $omega) (=> (and (star-shaped $M) (closed-form $omega) (degree $omega > 0)) (exact-form $omega)))
(= (wedge-product $alpha $beta) (and (differential-form $alpha $M $p) (differential-form $beta $M $q) (graded-commutative $wedge) (= (degree (wedge $alpha $beta)) (+ $p $q))))
(= (cross-domain-bridge-dr-diffgeo $system) (and (bridges genesis_de_rham genesis_differential_geometry) (uses differential-forms smooth-manifold) (uses hodge-decomposition riemannian-metric)))
(= (cross-domain-bridge-dr-algtopo $system) (and (bridges genesis_de_rham genesis_algebraic_topology) (uses de-rham-cohomology singular-cohomology) (uses stokes-theorem integration-on-manifolds)))
(= (cross-domain-bridge-dr-chernchar $system) (and (bridges genesis_de_rham genesis_chern_character) (uses chern-classes differential-forms) (uses de-rham-cohomology characteristic-classes)))
(= (cross-domain-bridge-dr-specseq $system) (and (bridges genesis_de_rham genesis_spectral_sequences) (uses hodge-decomposition spectral-sequence) (uses de-rham-cohomology filtered-complexes)))
