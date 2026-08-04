;; GENESIS artifact #260: Sobolev Spaces
;; Domain: functional-analysis / PDE-theory
;; Bridges: genesis_measure_theory, genesis_fourier_analysis, genesis_lebesgue_integration, genesis_hilbert_spaces, genesis_distributions

(= (weak_derivative $f $alpha $g) (and (locally_integrable $f) (locally_integrable $g) (forall $phi (==> (compact_support $phi) (== (integral (times $D_phi $f)) (* (sign $alpha) (integral (times $phi $g)))))))

(= (sobolev_space $W $k $p $Omega) (and (open_domain $Omega) (integer $k) (real $p) (>= $p 1) (forall $f (==> (member $f $W) (and (lebesgue_integrable $f $p $Omega) (forall $alpha (==> (<= (sum $alpha) $k) (lebesgue_integrable (weak_derivative $f $alpha) $p $Omega)))))))

(= (sobolev_norm $f $k $p $Omega) (sum $alpha (==> (<= (sum $alpha) $k) (power (lebesgue_norm (weak_derivative $f $alpha) $p $Omega) $p))))

(= (sobolev_embedding $W $k $p $Omega $L $q) (and (sobolev_space $W $k $p $Omega) (lebesgue_space $L $q $Omega) (continuous_embedding $W $L) (== $q (quotient (* $n $p) (- $n (* $k $p))))))

(= (morrey_inequality $f $k $p $Omega) (and (sobolev_space $W $k $p $Omega) (> (- $n (* $k $p)) 0) (holder_continuous $f $Omega (quotient (- $n (* $k $p)) (- $p 1)))))

(= (rellich_kondrachov $W $k $p $Omega $L $q) (and (sobolev_space $W $k $p $Omega) (bounded_domain $Omega) (lipschitz_boundary $Omega) (> $q $p) (compact_embedding $W $L $q)))

(= (trace_theorem $f $k $p $Omega $gamma) (and (sobolev_space $W $k $p $Omega) (smooth_boundary $Omega) (continuous_map $gamma $W (sobolev_space_boundary (- $k 1) $p))))

(= (poincare_inequality $f $p $Omega $C) (and (sobolev_space $W 1 $p $Omega) (bounded_domain $Omega) (== (integral (power (abs (- $f (mean $f $Omega))) $p)) (<= (times $C (integral (power (gradient $f) $p)))))))

(= (sobolev_density $W $k $p $Omega) (and (sobolev_space $W $k $p $Omega) (dense $C_infinity (closure $W $sobolev_norm))))

(= (meyers_serrin $W $k $p $Omega) (and (sobolev_space $W $k $p $Omega) (== $W (completion (smooth_compact_support $Omega) $sobolev_norm))))

(= (fractional_sobolev $W $s $p $Omega) (and (real $s) (sobolev_space $W (floor $s) $p $Omega) (finite (integral (quotient (power (abs (- $f $y)) $p) (power (distance $x $y) (+ $n (* $s $p))))))))

(= (gagliardo_nirenberg $f $p $q $r $j $m) (and (sobolev_space $W $m $p $Omega) (lebesgue_space $L $q $Omega) (== (norm $f $q) (times (norm (derivative $j $f) $r) (power (norm $f $p) (- 1 $theta)))))

(= (sobolev_multiplication $f $g $k $p $Omega) (and (member $f $W) (member $g $W) (sobolev_space $W $k $p $Omega) (> $k (quotient $n $p)) (member (times $f $g) $W)))

(= (aubin_lions $W0 $W $W1 $T $q) (and (compact_embedding $W0 $W) (continuous_embedding $W $W1) (== $T (compact_embedding (intersection (space_time $W0 $q) (space_time $W1 $q)) $L)))))))