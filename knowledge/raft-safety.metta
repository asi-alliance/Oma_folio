;; Raft Safety Properties in MeTTa
;; Based on Ongaro & Ousterhout (2014)
;; Safety = (1) Election Safety, (2) Leader Append-Only,
;; (3) Log Matching, (4) Leader Completeness,
;; (5) State Machine Safety

(: RaftNode Type)
(: Term Type)
(: LogIndex Type)
(: LogEntry Type)
(: StateMachine Type)

;; Safety Property 1: Election Safety
;; At most one leader can be elected in a given term
(|- ((Implication
  (And
    (Evaluation (Predicate leader-at-term) $n1 $t)
    (Evaluation (Predicate leader-at-term) $n2 $t))
  (Equation $n1 $n2))
  (stv 1.0 0.9)))

;; Safety Property 2: Leader Append-Only
(|- ((Implication
  (And
    (Evaluation (Predicate is-leader) $n $t)
    (Evaluation (Predicate has-log-entry) $n $idx $e1 $t1)
    (Evaluation (Predicate ballot-order) $t1 $t))
  (Evaluation (Predicate still-has-log-entry) $n $idx $e1 $t))
  (stv 1.0 0.9))

;; Safety Property 3: Log Matching
(|- ((Implication
  (And
    (Evaluation (Predicate log-entry) $n1 $idx $term $e)
    (Evaluation (Predicate log-entry) $n2 $idx $term $e))
  (Evaluation (Predicate log-prefix-match) $n1 $n2 $idx))
  (stv 1.0 0.9))

;; Safety Property 4: Leader Completeness
(|- ((Implication
  (And
    (Evaluation (Predicate committed) $idx $term $e)
    (Evaluation (Predicate ballot-order) $term $term2)
    (Evaluation (Predicate leader-at-term) $leader $term2))
  (Evaluation (Predicate has-log-entry) $leader $idx $e $term))
  (stv 1.0 0.85))

;; Safety Property 5: State Machine Safety
(|- ((Implication
  (And
    (Evaluation (Predicate applied) $n1 $idx $e1)
    (Evaaultion (Predicate applied) $n2 $idx $e2))
  (Equation $e1 $e2))
  (stv 1.0 0.9))

;; Cross-protocol similarity: Paxos agreement <-> Raft state machine safety
(|- ((Similarity
  (Evaluation (Predicate paxos-agreement))
  (Evaluation (Predicate raft-state-machine-safety)))
  (stv 0.85 0.8))
