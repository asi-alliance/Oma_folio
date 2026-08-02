;; GENESIS artifact #262: Computability Theory
;; Domain: logic / recursion-theory / computation
;; Bridges: genesis_descriptive_set_theory, genesis_godel_incompleteness, genesis_turing_machines, genesis_yoneda, genesis_fixpoint_domain

(= (turing_machine $M) (and (finite_states $Q) (tape_alphabet $Gamma) (transition_function $delta $Q $Gamma $Q $Gamma $Direction) (initial_state $q0) (accept_state $q_accept) (reject_state $q_reject)))

(= (computable_function $f $M) (and (turing_machine $M) (forall $x (==> (natural_number $x) (exists $y (and (== $y ($f $x)) (halts $M $x $y)))))))

(= (recursively_enumerable $A $M) (and (turing_machine $M) (forall $x (==> (member $x $A) (halts_accept $M $x)))))

(= (recursive_set $A $M) (and (recursively_enumerable $A $M) (recursively_enumerable (complement $A) $M)))

(= (halting_problem $M $x) (and (turing_machine $M) (input $x) (not (computable_function (halts $M $x)))))

(= (rice_theorem $P) (and (property_of_recursively_enumerable_sets $P) (nontrivial $P) (forall $A (==> (recursively_enumerable $A) (not (decidable ($P $A)))))))

(= (many_one_reduction $A $B $f) (and (computable_function $f) (forall $x (== (member $x $A) (member ($f $x) $B)))))

(= (turing_reduction $A $B $M) (and (oracle_machine $M) (forall $x (== (member $x $A) (query_oracle $M $B $x)))))

(= (arithmetical_hierarchy $A $n) (and (or (== (Sigma $n) (exists $y (forall $z (recursive_predicate $x $y $z)))) (== (Pi $n) (forall $y (exists $z (recursive_predicate $x $y $z))))) (== $A (formula_at_level $n))))

(= (kleene_normal_form $f) (and (computable_function $f) (exists $e (forall $x (== ($f $x) $U (min_y (T $e $x $y)))))))

(= (s_m_n_theorem $f $e) (and (computable_function $f) (exists $s (computable_function $s) (forall $x $y (== ($f $x $y) ($phi (s $e $x) $y))))))

(= (recursion_theorem $f) (and (computable_function $f) (exists $e (== ($phi $e) ($f $e)))))

(= (productive_set $A $p) (and (recursively_enumerable $A) (partial_computable $p) (forall $W (==> (subset $W $A) (and (member ($p $index $W) $A) (not (member ($p $index $W) $W)))))))

(= (creative_set $A) (and (recursively_enumerable $A) (productive_set (complement $A))))