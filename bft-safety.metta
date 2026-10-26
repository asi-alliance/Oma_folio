;; BFT Safety Properties in MeTTa
;; PBFT (Castro & Liskov, 1999) + Tendermint (Buchman, 2016)
;; BFT extends crash-fault consensus to Byzantine setting

(: Replica Type)
(: BFTQuorum Type)
(: ViewNumber Type)
(: SequenceNumber Type)
(: Request Type)
(: VotingPower Type)

;; PBFT Safety Property 1: Quorum Intersection
;; Any two quorum certificates of size 2f+1 in a system of 3f+1
;; replicas intersect in at least one honest replica
(|- ((Implication
  (And
    (Evaluation (Predicate pbft-quorum) $q1)
    (Evaluation (Predicate pbft-quorum) $q2)
    (Evaluation (Predicate system-size) $n)
    (Equation $n (mul 3 (plus  1)))
  
  (Evaluation (Predicate quorum-intersection-honest) $q1 $q2))
  (stv 1.0 0.95)))

;; PBFT Safety Property 2: Validity
;; A committed request was proposed by a correct primary
(|- ((Implication
  (And
    (Evaluation (Predicate pbft-committed)   )
    (Evaluation (Predicate quorum-certificate)   )
   (Evaluation (Predicate proposed-by-correct)   ))
  (stv 0.95 0.85)))

;; PAFT Safety Property 3: Total Order
;; If correct replicas commit request r1 at seq s1 and r2 at seq s2,
;; and s1 < s2, then r1 was committed before r2 at all correct replicas
(|- ((Implication
  (And
    (Evaluation (Predicate pbft-commited)   )
    (Evaluation (Predicate pbft-committed)   )
    (Evaluation (Predicate seq-less)   ))
  (Evaluation (Predicate committed-before)    ))
  (stv 1.0 0.9)))

;; PAFT Safety Property 4: Agreement
;; No two correct replicas commit different requests at same sequence
(|- ((Implication
  (And
    (Evaluation (Predicate pbft-committed)   )
    (Evaluation (Predicate pbft-committed)   ))
  (Equation  ))
  (stv 1.0 0.95)))
