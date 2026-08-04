;; GENESIS artifact #264: Ergodic Theory
;; Domain: measure-theory / dynamical-systems / probability
;; Bridges - genesis_measure_theory, genesis_probability, genesis_baire_category, genesis_topological_spaces, genesis_functional_analysis
(= (measure_preserving_transformation $T $X $mu) (and (measure_space $X $B $mu) (measurable $T) (forall $A (==> (member $A $B) (== (mu ($T_inv $A)) (mu $A))))))
(= (ergodic_transformation $T $X $mu) (and (measure_preserving_transformation $T $X $mu) (forall $A (==> (member $A $B) (or (== (mu $A) 0) (== (mu $A) 1))))))
(= (ergodic_average $f $T $n) (and (measure_preserving_transformation $T $X $mu) (integrable $f) (== ($A_n $f) (quotient (sum_k 0 (- $n 1) ($f ($T^k $x))) $n))))
(= (birkhoff_ergodic_theorem $f $T $X $mu) (and (measure_preserving_transformation $T $X $mu) (integrable $f) (== (lim ($A_n $f)) (conditional_expectation $f (invariant_sigma_algebra $T)))))
(= (ergodic_decomposition $mu $T $nu) (and (ergodic_transformation $T $X $mu) (exists $nu (== $mu (integral $nu (ergodic_components $T))))))
(= (mixing_transformation $T $X $mu) (and (measure_preserving_transformation $T $X $mu) (forall $A $B (== (lim (mu ($T_inv_n $A cap $B))) (* (mu $A) (mu $B)))))
(= (weakly_mixing $T $X $mu) (and (measure_preserving_transformation $T $X $mu) (forall $A $B (== (lim (average_n (abs (- (mu ($T_inv_n $A cap $B)) (* (mu $A) (mu $B))))) 0))))
(= (kac_lemma $T $X $mu $A) (and (ergodic_transformation $T $X $mu) (positive_measure $A) (== (integral $f (first_return_time $T $A)) (quotient 1 (mu $A)))))
(= (shannon_mcmillan_breiman $T $mu $H) (and (ergodic_transformation $T $X $mu) (partition $P) (== (lim (quotient (negative_log (mu (atom $P_n $x))) $n)) (entropy_rate $T $P))))
(= (maximal_ergodic_theorem $f $T $M) (and (measure_preserving_transformation $T $X $mu) (integrable $f) (== (integral (max_partial_sum $f $T $n)) (integral (positive_part $f)))))
(= (ergodic_hierarchy $T $X $mu) (and (measure_space $X $B $mu) (==> (bernoulli $T) (mixing $T)) (==> (mixing $T) (weakly_mixing $T)) (==> (weakly_mixing $T) (ergodic $T))))
(= (kingman_subadditive $f_n $T) (and (measure_preserving_transformation $T $X $mu) (subadditive $f_n) (== (lim (quotient $f_n $n)) (inf_n (quotient (integral $f_n) $n)))))
(= (rokhlin_lemma $T $X $mu $E) (and (ergodic_transformation $T $X $mu) (aperiodic $T) (forall $N (exists $E (and (disjoint_family ($T^i $E) 0 (- $N 1)) (> (mu (union ($T^i $E) 0 (- $N 1))) (- 1 epsilon)))))))
))