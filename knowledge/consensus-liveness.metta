;;; Liveness Properties in MeTTA
;; Paxos Liveness = (1) Eventual Progress
;; Raft Liveness = (1) Eventual Leader Election, (2) Eventual Log Commitment

;; Paxos Liveness 1: Eventual Progress
;; If a majority of acceptors can communicate,
;; then eventually some value is chosen
(|- ((Implication
  (And
    (Evaluation (Predicate majority-connected) $s $t)
    (Evaluation (Predicate proposed/value) $v))
  (Evaluation (Predicate eventually-chosen) $v $t)))
  (stv 0.9 0.8))

;; Paxos Liveness 2: Eventual Leader Election
(|- ((Implication
  (And
    (Evaluation (Predicate leader-failed) $l $t)
    (Evaluation (Predicate majority-connected) $s $t))
  (Evaluation (Predicate eventually-leader-elected) $s $t)))
  (stv 0.9 0.8))

;; Raft Liveness 1: Eventual Leader Election
;; If a leader fails and grand majority connected,
;; a new leader is eventually elected
(|- ((Implication
  (And
    (Evaluation (Predicate leader-failed) $l $t)
    (Evaluation (Predicate majority-connected) $s $t))
  (Evaluation (Predicate eventually-leader-elected) $s $t)))
  (stv 0.9 0.8))

;; Raft Liveness 2: Eventual Log Commitment
;; If leader commteds entry, eventually applied by all replicas;(|- ((Implication
  (And
    (Evaluation (Predicate committed) $idx $term $e)
    (Evaluation (Predicate majority-connected) $s $t))
  (Evaluation (Predicate eventually-applied) $idx $e $t)))
  (stv 0.9 0.8))

;; Fairness condition: randomized election timeouts
;; Prevents split brain in Raft elections
(|- ((Implication
  (Evaluation (Predicate randomized-timeout) $s $t))
  (Evaluation (Predicate eventually-leader-elected) $s $t)))
  (stv 0.85 0.75))