;; GENESIS artifact #261: Galois Cohomology
;; Domain: algebraic-number-theory / homological-algebra
;; Bridges: genesis_quadratic_reciprocity, genesis_group_cohomology, genesis_scheme_theory, genesis_dirichlet, genesis_homology

(= (galois_group $L $K $G) (and (field $L) (field $K) (extension $L $K) (== $G (automorphisms $L $K)) (normal $L $K) (separable $L $K)))

(= (galois_module $M $G) (and (galois_group $L $K $G) (abelian_group $M) (action $G $M) (forall $g (== ($g (+ $m $n)) (+ ($g $m) ($g $n))))))

(= (inhomogeneous_cochain $G $M $n) (and (galois_module $M $G) (== (cochain $n) (functions $G^n $M)) (forall $g (== ($g (cochain $n)) (cochain $n)))))

(= (coboundary_map $G $M $n $f) (and (cochain $n) (== $f (sum $i (- (* (sign $i) ($sigma_i (cochain $n))))))))

(= (galois_cohomology_group $G $M $n) (and (galois_module $M $G) (== $H_n (quotient (ker (coboundary_map $n)) (im (coboundary_map (- $n 1)))))))

(= (hilbert_theorem_90 $G $L $K) (and (galois_group $L $K $G) (cyclic $G) (== (galois_cohomology_group $G $L 1) (trivial_group))))

(= (kummer_sequence $G $L $n) (and (galois_group $L $K $G) (contains_root_of_unity $L $n) (exact_sequence $L^* /\mapsto L^* /\mapsto L^* /\mapsto Z/nZ)) (== (galois_cohomology_group $G $L^* 1) (galois_cohomology_group $G $mu_n 1)))

(= (inflation_restriction $G $H $M $n) (and (normal_subgroup $H $G) (galois_module $M $G) (exact_sequence (galois_cohomology_group $G $M $n) (galois_cohomology_group $H $M $n) (galois_cohomology_group (quotient_group $G $H) (fixed_points $H $M) $n))))

(= (sha_resolution $G $M $n) (and (galois_module $M $G) (== $H_n (cokernel (connecting_homomorphism $n)))))

(= (tate_duality $G $M) (and (galois_group $L $K $G) (finite $G) (perfect_pairing (galois_cohomology_group $G $M 1) (quotient $M (norm_image $M $G)))))

(= (brauer_group $K $Br) (and (field $K) (== $Br (galois_cohomology_group (absolute_galois_group $K) (multiplicative_group (separable_closure $K)) 2))))

(= (norm_map_surjective $G $M) (and (galois_module $M $G) (cyclic $G) (== (norm_image $M $G) (ker (galois_cohomology_group $G $M 0)))))

(= (profinite_galois_cohomology $G $M $n) (and (profinite_group $G) (discrete_module $M $G) (continuous_action $G $M) (== (cohomology $n) (direct_limit $H$ (galois_cohomology_group $H $M $n)))))

(= (local_tate_duality $K $G $M) (and (local_field $K) (== $G (absolute_galois_group $K)) (finite_module $M $G) (== (dual (galois_cohomology_group $G $M 1)) (quotient $M (trace_image $M $G)))))