;; GENESIS artifact #256: Convex Optimization
;; Domain: optimization / functional-analysis
;; Bridges: genesis_lagrange, genesis_optimal-transport, genesis_hahn_banach, genesis_spectral_theorem

(= (convex_set $C) (and (subset $C $V) (vector_space $V) (forall $x $y (==> (and (in $x $C) (in $y $C)) (forall $t (==> (and (<= 0 $t) (<= $t 1)) (in (affine_combination $t $x $y) $C)))))))

(= (convex_function $f $C) (and (convex_set $C) (function $f $C $R) (forall $x $y $t (==> (and (in $x $C) (in $y $C) (<= 0 $t) (<= $t 1)) (<= ($f (affine_combination $t $x $y)) (affine_combination $t ($f $x) ($f $y)))))))

(= (separating_hyperplane $C $D $H) (and (convex_set $C) (convex_set $D) (empty (intersection $C $D)) (hyperplane $H) (forall $x (==> (in $x $C) (<= (evaluate $H $x) 0)) (==> (in $x $D) (>= (evaluate $H $x) 0)))))

(= (subgradient $g $f $x) (and (convex_function $f $C) (in $x $C) (forall $y (in $y $C) (<= ($f $y) (+ ($f $x) (inner_product $g (- $y $x)))))))

(= (kkt_conditions $x $f $g $h $mu $lambda) (and (convex_function $f $C) (convex_set $C) (forall $i (convex_inequality_constraint $g_i $C)) (forall $j (affine_equality_constraint $h_j $C)) (== (gradient $f $x) (+ (sum $i (* $mu_i (gradient $g_i $x))) (sum $j (* $lambda_j (gradient $h_j $x))))) (forall $i (>= $mu_i 0)) (forall $i (>= $g_i $x 0)) (forall $i (== (* $mu_i $g_i) 0)) (forall $j (== $h_j 0))))

(= (weak_duality $p_star $d_star) (<= $d_star $p_star))

(= (strong_duality $p_star $d_star) (and (weak_duality $p_star $d_star) (slater_condition $f $g) (== $p_star $d_star)))

(= (slater_condition $f $g) (exists $x (and (in $x (interior $C)) (forall $i (< $g_i $x 0)) (forall $j (== $h_j $x 0)))))

(= (projection_theorem $P $C $x) (and (closed_convex_set $C) (hilbert_space $H) (in $x $H) (in $P $C) (forall $y (in $y $C) (<= (norm (- $x $P)) (norm (- $x $y)))) (forall $y (in $y $C) (>= (inner_product (- $x $P) (- $y $P)) 0))))

(= (fenchel_conjugate $f_star $f) (and (convex_function $f $C) (= $f_star (lambda $y (supremum $x (- (inner_product $y $x) ($f $x)))))))

(= (fenchel_young_inequality $f $f_star $x $y) (>= (+ ($f $x) ($f_star $y)) (inner_product $x $y)))

(= (ot_duality $c $pi $phi) (and (cost_function $c) (transport_plan $pi) (kantorovich_dual $phi $c) (== (primal_cost $pi $c) (dual_cost $phi $c))))

(= (complementary_slackness $mu $g $x) (== (* $mu (constraint_value $g $x)) 0))