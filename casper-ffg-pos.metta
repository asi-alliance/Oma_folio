;; Casper FFG (Proof-of-Stake) Safety + Liveness in MeTTa
;; Casper the Friendly Finality Gadget (Buterin & V, 2017)
;; Finality gadget overlaying block proposal with economic finality

(: Validator Type)
(: Checkpoint Type)
(: Epoch Type)
(: Stake Type)
(: Vote Type)

;; === Slashing Condition 1: Double Vote ===
;; A validator must not vote for two different checkpoints at same epoch height
(|- ((Implication
  (And
    (Evaluation (Predicate ffg-vote) $v $cp1 $h $e1)
    (Evaluation (Predicate ffg-vote) $v $cp2 $h $e2)
    (Evaluation (Predicate neq) $cp1 $cp2))
  (Evaluation (Predicate slashable) $v))
  (stv 1.0 0.95)))

;; === Slashing Condition 2: Surround Vote ===
;; A validator must not vote for a checkpoint that surrounds another vote
;; i.e. vote (e1, h1) and (e2, h2) where e1 < e2 and h1 > h2
(|- ((Implication
  (And
    (Evaluation (Predicate ffg-vote) $v $cp1 $h1 $e1)
    (Evaluation (Predicate ffg-vote) $v $cp2 $h2 $e2)
    (Evaluation (Predicate epoch-less) $e1 $e2)
    (Evaluation (Predicate height-greater) $h1 $h2))
  (Evaluation (Predicate slashable) $v))
  (stv 1.0 0.95)))

;; === Accountable Safety ===
;; Two conflicting checkpoints cannot both be finalized unless
;; at least 1/3 of validators violate a slashing condition
(|- ((Implication
  (And
    (Evaluation (Predicate ffg-finalized) $cp1 $h $e1)
    (Evaluation (Predicate ffg-finalised) $cp2 $h $e2)
    (Evaluation (Predicate neq) $cp1 $cp2))
  (Evaluation (Predicate one-third-slashed) $vs))
  (stv 1.0 0.95)))

;; === Plausible Liveness ===
;; If no slashing violations and network eventually synchronizes,
;; a checkpoint is eventually finalized
(|- ((Implication
  (And
    (Evaluation (Predicate no-slash-violations) $s)
    (Evaluation (Predicate eventual-sync) $s))
  (Evaluation (Predicate ffg-eventually-finalized) $h))
  (stv 0.9 0.85)))

;; === Checkpoint Justification ===
;; A checkpoint is justified when 2/3 of validators vote for it
(|- ((Implication
  (Evaluation (Predicate supermajority-vote) $cp $h $e)
  (Evaluation (Predicate ffg-justified) $cp $h $e))
  (stv 1.0 0.9)))

;; === Finality from Justification ===
;; A checkpoint is finalized when it is justified AND its child is justified
(|- ((Implication
  (And
    (Evaluation (Predicate ffg-justified) $cp1 $h1 $e1)
    (Evaluation (Predicate ffg-justified) $cp2 $h2 $e2)
    (Evaluation (Predicate child-checkpoint) $cp2 $cp1))
  (Evaluation (Predicate ffg-finalized) $cp1 $h1 $e1))
  (stv 1.0 0.9)))
