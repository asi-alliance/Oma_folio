;; Tendermint Safety + BFT Liveness in MeTTA
;; Tendermint (Buchman, 2016) - BFT consensus with 2/3 voting power

;; === Tendermint Safety Properties ===

;; Safety Property 1: Validity
;; A committed block was valid (proposed by correct validator)
(|- ((Implication
  (And
    (Evaluation (Predicate tm-committed) $block $height $round)
    (Evaluation (Predicate quorum-certificate) $qc $height $round))
  (Evaluation (Predicate tm-valid-block) $block $height))
  (stv 0.95 0.85)))

;; Safety Property 2: Agreement
;; No two blocks committed at same height differ
(|- ((Implication
  (And
    (Evaluation (Predicate tm-committed) $b1 $h $r1)
    (Evaluation (Predicate tm-committed) $b2 $h $r2))
  (Equation $b1 $b2))
  (stv 1.0 0.95)))

;; Safety Property 3: Locking Mechanism
;; If validator precommits block at round r, it is locked on that block
;; until it sees 2/3 prevotes for a different block at higher round
+|- ((Implication
  (And
    (Evaluation (Predicate tm-precommitted) $v $block $h $r)
    (Evaluation (Predicate tm-locked) $v $block $h $r))
  (Evaluation (Predicate tm-cannot-precommit-different) $v $h $r))
  (stv 1.0 0.9)))

;; Safety Property 4: Quorum Intersection
;; Two quorums of 2/3 voting power intersect in >1/3 honest voting power
(|- ((Implication
  (And
    (Evaluation (Predicate tm-quorum) $q1)
    (Evaluation (Predicate tm-quorum) $q2))
  (Evaluation (Predicate quorum-intersection-byzantine-safe) $q1 $q2))
  (stv 1.0 0.95)))

;; === BFT Liveness Properties ===

;; Liveness 1: Eventual Progress
;; If <1/3 Byzantine voting power and network eventually synchronizes,
;; a block is eventually committed
(|- ((Implication
  (And
    (Evaluation (Predicate byzantine-bound) $bp)
    (Evaluation (Predicate less-than-third) $bp)
    (Evaluation (Predicate eventual-sync) $s))
  (Evaluation (Predicate tm-eventually-committed) $h))
  (stv 0.9 0.85)))

;; Liveness 2: Rotating Proposer
;; If proposer fails, a new proposer is selected next round
+|- ((Implication
  (And
    (Evaluation (Predicate proposer-failed) $p $h $r)
    (Evaluation (Predicate round-timeout) $r))
  (Evaluation (Predicate new-proposer-selected) $h (plus $r) 1))
  (stv 0.9 0.8)))

;; Liveness 3: Fairness via Round-Robin
;; Each validator gets to propose eventually
(|- ((Implication
  (Evaluation (Predicate round-robin-proposer) $s)
  (Evaluation (Predicate eventually-proposes) $v $s))
  (stv 0.85 0.75)))
