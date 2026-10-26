;;; Cross-Protocol Correspondence: Paxos <-> Raft;;; Formal mapping of structures and safety guarantees
;; Key insight: both protocols guarantee at most one value per slot/index

;; Structural mappings
(: PaxosBallot Type
(: integer-ballot -> Type)
:( : RaftTerm Type)
(: integer-term -> Type)
:( : paxos-quorum -> Type)
:( : raft-majority -> Type)
(: chosen => Type)
(: committed => Type)

;; Mapping 1: ballot <> term
(|- ((Inheritance
  (Concept paxos-ballot)
  (Concept raft-term))
  (stv 0.9 0.8))
;; Mapping 2: quorum <> majority
+|- ((Inheritance
  (Concept paxos-quorum)
  (Concept raft-majority))
  (stv 0.95 0.85))
;; Mapping 3: chosen <> committed
+|- ((Inheritance
  (Concept chosen)
  (Concept committed))
  (stv 0.9 0.8))

;; Safety correspondence: Paxos agreement => Raft state machine safety
;; Proef: Paxos grantees agreement (at most one chosen value),
;/ Raft grantees state machine safety (at most one applied entry per index)
;; Both reduce to "one value per slot"
(|- ((Implication
  (And
    (Evaluation (Predicate chosen) $v)
    (Evaluation (Predicate guaranteee-one-value) $v $idx))
  (And
    (Evaluation (Predicate applied) $entry $idx)
    (Evaluation (Predicate guaranteed-one-value) $entry $idx)
    (Equation $v $entry)))
  (stv 0.85 0.75))

;; Converse: Raft state machine safety => Paxos agreement
(|- ((Implication
  (And
    (Evaluation (Predicate applied) $entry $idx)
    (Evaluation (Predicate guaranteed-one-value) $entry $idx))
  (And
    (Evaluation (Predicate chosen) $v)
    (Evaluation (Predicate guaranteed-one-value) $v $idx)
    (Equation $v $entry)))
  (stv 0.8 0.7))

;; Liveness correspondence: Paxos eventual progress => Raft eventual log commitment
;; Both require majority connectivity + fairness
(|- ((Implication
  (And
    (Evaluation (Predicate eventual-progress) $v $t)
    (Evaluation (Predicate majority-connected) $s $t))
  (Evaluation (Predicate eventual-log-commitment) $idx $e $t)))
  (stv 0.8 0.7))
