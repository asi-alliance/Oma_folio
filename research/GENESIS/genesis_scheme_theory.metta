;; GENESIS artifact #258: Scheme Theory
;; Domain: algebraic-geometry
;; Bridges: genesis_gauss_bonnet, genesis_de_rham, genesis_homology, genesis_yoneda, genesis_quadratic_reciprocity

(= (affine_scheme $X) (and (ring $R) (== $X (Spec $R)) (topological_space $X)))

(= (prime_spectrum $R $X) (and (ring $R) (== $X (Spec $R)) (= (points $X) (set_of_prime_ideals $R)) (= (topology $X) (zariski_topology $R))))

(= (structure_sheaf $X $O) (and (affine_scheme $X) (== (stalk $O $p) (localization $R (complement $p))) (forall $U (== ($O $U) (sections_over $U)))))

(= (scheme $X) (and (topological_space $X) (structure_sheaf $X $O) (open_cover $X $U_i) (forall $i (affine_scheme (pair $U_i (restriction $O $U_i))))))

(= (scheme_morphism $f $X $Y) (and (scheme $X) (scheme $Y) (continuous_map $f $X $Y) (morphism_sheaves $f (structure_sheaf $Y) (pushforward $f (structure_sheaf $X)))))

(= (fiber_product $X $Y $S $P) (and (scheme $X) (scheme $Y) (scheme $S) (scheme_morphism $f $X $S) (scheme_morphism $g $Y $S) (scheme $P) (projections $P $X $Y) (universal_property $P $f $g)))

(= (separated_scheme $X) (and (scheme $X) (diagonal_morphism $delta $X (fiber_product $X $X $X)) (closed_immersion $delta)))

(= (proper_scheme $X) (and (separated_scheme $X) (finite_type $X (Spec $k)) (universally_closed $X)))

(= (coherent_sheaf $F $X) (and (scheme $X) (sheaf_of_modules $F $X) (affine_cover $U_i) (forall $i (finitely_generated (sections $F $U_i)))))

(= (scheme_cohomology $X $F $n) (and (scheme $X) (coherent_sheaf $F $X) (== (cohomology_group $n) (derived_functor $n (global_sections $F)))))

(= (serre_duality $X $F) (and (proper_scheme $X) (smooth $X) (== (Ext $i $F $omega) (dual (cohomology $X $F (- (dimension $X) $i))))))

(= (riemann_roch $X $D) (and (proper_scheme $X) (divisor $D $X) (== (chi $X (line_bundle $D)) (+ (deg $D) (chi $X (trivial_bundle $X))))))

(= (genus_formula $X $g) (and (proper_scheme $X) (curve $X) (== $g (cohomology $X (structure_sheaf $X) 1))))