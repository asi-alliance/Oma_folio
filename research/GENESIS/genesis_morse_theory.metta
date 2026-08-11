;; GENESIS artifact #257: Morse Theory
;; Domain: differential-geometry / algebraic-topology
;; Bridges: genesis_stokes_theorem, genesis_de_rham, genesis_fundamental_group, genesis_homology, genesis_gauss_bonnet

(= (morse_function $f $M) (and (smooth_manifold $M) (smooth_function $f $M $R) (forall $p (==> (== (differential $f $p) 0) (not (== (det (hessian $f $p)) 0)))))

(= (morse_index $f $p $k) (and (critical_point $f $p) (== $k (negative_eigenvalues (hessian $f $p)))))

(= (morse_lemma $f $p $k) (and (morse_function $f $M) (morse_index $f $p $k) (exists $phi (and (local_chart $phi $p) (forall $x (== ($f ($phi $x)) (+ ($f $p) (- (sum $i (square $x_i))) (sum $j (square $x_j)))))))))

(= (weak_morse_inequality $M $f $k) (and (morse_function $f $M) (compact_manifold $M) (<= (betti_number $M $k) (count_critical_points $f $k))))

(= (strong_morse_inequality $M $f) (and (morse_function $f $M) (compact_manifold $M) (== (alternating_sum $k (count_critical_points $f $k)) (euler_characteristic $M))))

(= (handle_attachment $M $f $p $k) (and (morse_function $f $M) (morse_index $f $p $k) (== (homotopy_type (sublevel_set $f ($f $p) $epsilon)) (attach_handle (sublevel_set $f (- ($f $p) $epsilon) $epsilon) $k))))

(= (morse_homology $M $f) (and (morse_function $f $M) (pseudo_gradient $V $f) (= (morse_chain_group $k) (free_abelian (critical_points_index $f $k))) (= (morse_boundary $k) (sum (gradient_flow_lines $V $p $q))) (== (morse_homology_group $k) (quotient (ker (morse_boundary $k)) (im (morse_boundary (+ $k 1)))))))

(= (morse_homology_isomorphism $M $f) (and (morse_homology $M $f) (forall $k (isomorphic (morse_homology_group $k) (singular_homology_group $M $k)))))

(= (pseudo_gradient $V $f) (and (morse_function $f $M) (vector_field $V $M) (forall $p (==> (not (== (differential $f $p) 0)) (< (inner_product (differential $f $p) ($V $p)) 0)))))

(= (gradient_flow_line $V $p $q) (and (pseudo_gradient $V $f) (critical_point $f $p) (critical_point $f $q) (== (morse_index $f $p (+ (morse_index $f $q) 1)) (exists $gamma (forall $t (== ($gamma (+ $t 1)) ($V ($gamma $t)))))))))

(= (euler_via_morse $M $f) (and (morse_function $f $M) (compact_manifold $M) (== (euler_characteristic $M) (alternating_sum $k (count_critical_points $f $k)))))

(= (reeb_theorem $M $f) (and (morse_function $f $M) (compact_manifold $M) (== (total_critical_points $f) 2) (isomorphic (homotopy_type $M) (homotopy_type sphere_n))))

(= (morse_cup_product $M $f) (and (morse_homology $M $f) (= (cup (alpha $p) (beta $q)) (sum (y_tree $p $q $r))) (forall $p $q $r (==> (y_tree $p $q $r) (== (morse_index $f $r) (+ (morse_index $f $p) (morse_index $f $q)))))))