;; GENESIS artifact #259: Descriptive Set Theory
;; Domain: set-theory / logic / topology
;; Bridges: genesis_borel_hierarchy, genesis_polish_spaces, genesis_effective_descriptive_set_theory, genesis_topological_spaces, genesis_measure_theory

(= (polish_space $X) (and (separable $X) (completely_metrisable $X)))

(= (standard_borel_space $X) (and (borel_sigma_algebra $X $B) (isomorphic_borel $X (real_line))))

(= (borel_hierarchy $X $alpha $A) (and (polish_space $X) (ordinal $alpha) (or (== $A (sigma_generated (complement (Pi $X (- $alpha 1))))) (== $A (sigma_generated (complement (Sigma $X (- $alpha 1))))))))

(= (analytic_set $X $A) (and (polish_space $X) (exists $B (and (closed_set $B (product $X (baire_space))) (continuous_map $proj (product $X (baire_space)) $X) (== $A (image $proj $B)))))))

(= (coanalytic_set $X $A) (and (polish_space $X) (complement (analytic_set $X $A))))

(= (souslin_operation $F $A) (and (family_of_sets $F) (== $A (union $s (intersection $n ($F (sequence $s $n)))))))

(= (luzin_separation $A $B) (and (analytic_set $X $A) (analytic_set $X $B) (disjoint $A $B) (exists $C (and (borel_set $X $C) (subset $A $C) (disjoint $C $B)))))

(= (perfect_set_property $X $A) (and (polish_space $X) (analytic_set $X $A) (or (countable $A) (contains_perfect_subset $A))))

(= (baire_category_theorem $X) (and (complete_metric_space $X) (forall $U_i (==> (open_dense $U_i) (dense (intersection $U_i))))))

(= (universally_measurable $X $A) (and (polish_space $X) (forall $mu (==> (probability_measure $mu $X) (measurable $mu $A)))))

(= (boldface_borel_pointclass $alpha) (and (ordinal $alpha) (countable_operations (Sigma $alpha)) (countable_operations (Pi $alpha))))

(= (lightface_borel_pointclass $alpha) (and (ordinal $alpha) (recursive_operations (Sigma_lightface $alpha)) (recursive_operations (Pi_lightface $alpha))))

(= (hypersimple_set $A) (and (subset $A (natural_numbers)) (recursively_enumerable (complement $A)) (not (recursive $A)) (forall $B (==> (recursively_enumerable $B) (not (almost_subset $B $A))))))

(= (determinacy_game $X $A) (and (polish_space $X) (subset $A (baire_space_sequences)) (== (game_value $A) (exists (winning_strategy $player1 $A) (winning_strategy $player2 $A)))))