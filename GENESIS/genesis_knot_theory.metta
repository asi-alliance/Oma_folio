;; GENESIS artifact #263: Knot Theory
;; Domain: topology / geometric-topology
;; Bridges: genesis_homology, genesis_braid_group, genesis_quandles, genesis_topological_spaces, genesis_sobolev_spaces

(= (knot $K) (and (embedding $K (3-sphere $S3)) (== (domain $K) (circle $S1)) (image $K (smooth_submanifold $S3))))

(= (ambient_isotopy $K $L $H) (and (knot $K) (knot $L) (continuous_map $H (product (interval 0 1) $S3) $S3) (forall $t (homeomorphism ($H $t) $S3)) (== ($H 0) (identity $S3)) (== ($H 1 $K) $L)))

(= (knot_diagram $K $D) (and (knot $K) (regular_projection $D $S2) (crossing_record $D (over_under_strands $D))))

(= (reidemeister_move_I $D $D_prime) (and (knot_diagram $K $D) (knot_diagram $L $D_prime) (kink_removal $D $D_prime) (ambient_isotopy $K $L $H)))

(= (reidemeister_move_II $D $D_prime) (and (knot_diagram $K $D) (knot_diagram $L $D_prime) (poke_removal $D $D_prime) (ambient_isotopy $K $L $H)))

(= (reidemeister_move_III $D $D_prime) (and (knot_diagram $K $D) (knot_diagram $L $D_prime) (triangle_slide $D $D_prime) (ambient_isotopy $K $L $H)))

(= (knot_invariant $I $K $L) (and (function $I (knots) (some_set)) (forall $K $L (==> (ambient_isotopy $K $L) (== ($I $K) ($I $L))))))

(= (crossing_number $K $n) (and (knot $K) (== $n (min (count_crossings $D))) (forall $D (knot_diagram $K $D))))

(= (bridge_number $K $b) (and (knot $K) (== $b (min (count_maxima $h $K))) (forall $h (height_function $h $S3))))

(= (seifert_surface $K $F) (and (knot $K) (orientable_surface $F) (== (boundary $F) $K) (compact $F)))

(= (genus $K $g) (and (knot $K) (seifert_surface $K $F) (== $g (min (genus_surface $F))) (forall $F (seifert_surface $K $F))))

(= (jones_polynomial $K $V) (and (knot $K) (knot_invariant $V $K) (== ($V (unknot)) 1) (skein_relation $V (- $V_L + ($t^-1 $V_0) $V_inf))))

(= (skein_relation $V $L $L_plus $L_minus $L_zero) (and (knot_diagram $L_plus) (knot_diagram $L_minus) (knot_diagram $L_zero) (== (- ($t^-1 ($V $L_plus)) (* $t ($V $L_minus))) (* ($t^0_5 - $t^-0_5) ($V $L_zero)))))

(= (alexander_polynomial $K $Delta) (and (knot $K) (knot_invariant $Delta $K) (== ($Delta (unknot)) 1) (skein_relation $Delta ($Delta $L_plus - $Delta $L_minus) (* ($t^0_5 - $t^-0_5) ($Delta $L_zero)))))