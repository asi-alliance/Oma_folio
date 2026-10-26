;; Paxos Safety Properties in MeTTa
;; Based on Lamport's Paxos: safety = (1) Validity, (2) Agreement
;; Raft: safety = (1) Election Restriction, (2) Leader Append, (3) State Machine Safety

;; Type declarations
(: PaxosNode Type)
(: Ballot Type)
(: Value Type)
(: Proposed Value -> Type)
(: Accepted Value -> Type)
(: Chosen Value -> Type)
(: Leader Ballot -> PaxosNode -> Type)
(: Vote Ballot -> PaxosNode -> Value -> Type)

;; Safety Property 1: Validity — only proposed values can be chosen
(|- ((Implication
  (Evaluation (Predicate chosen) $v)
  (Evaluation (Predicate proposed) $v))
  (stv 1.0 0.9)))

;; Safety Property 2: Agreement — at most one value is chosen
;; If v1 and v2 are both chosen, then v1 = v2
(|- ((Implication
  (And
    (Evaluation (Predicate chosen) $v1)
    (Evaluation (Predicate chosen) $v2))
  (Equation $v1 $v2))
  (stv 1.0 0.9)))

;; Quorum intersection: any two quorums share at least one acceptor
(: Quorum Ballot -> Type)
(|- ((Implication
  (And
    (Evaluation (Predicate quorum) $b1)
    (Evaluation (Predicate quorum) $b2))
  (Exists $n (And
    (Evaluation (Predicate member) $n $b1)
    (Evaluation (Predicate member) $n $b2))))
  (stv 1.0 0.9)))

;; Ballot ordering: ballots are totally ordered
(: BallotOrder Ballot -> Ballot -> Type)
(|- ((Implication
  (And
    (Evaluation (Predicate ballot-order) $b1 $b2)
    (Evaluation (Predicate ballot-order) $b2 $b3))
  (Evaluation (Predicate ballot-order) $b1 $b3))
  (stv 1.0 0.9)))

;; Key lemma: if a value v was chosen in ballot b1, and ballot b2 > b1,
;; then any value proposed in b2 must equal v
;; This follows from quorum intersection + ballot ordering
(|- ((Implication
  (And
    (Evaluation (Predicate chosen) $v1)
    (Evaluation (Predicate chosen-at) $v1 $b1)
    (Evaluation (Predicate ballot-order) $b1 $b2)
    (Evaluation (Predicate proposed-at) $v2 $b2))
  (Equation $v1 $v2))
  (stv 0.95 0.8)))
