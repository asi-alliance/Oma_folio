;; Hashgraph Consensus (Gossip-about-Gossip + Virtual Voting) Safety + Liveness in MeTTa
;; Hashgraph (Baird, 2016) - Asynchronous BFT via gossip + virtual voting

(: HashEvent Type)
(: Node Type)
(: Round Type)
(: Transaction Type)

;; === Gossip-about-Gossip: Events carry parent hashes ===
(|- ((Implication
  (And
    (Evaluation (Predicate hashgraph-event) $ev $node $txs)
    (Evaluation (Predicate self-parent) $ev $sp)
    (Evaluation (Predicate other-parent) $ev $op))
  (Evaluation (Predicate gossip-about-gossip) $ev $sp $op))
  (stv 1.0 0.9)))

;; === Famous Witness Selection ===
(|- ((Implication
  (And
    (Evaluation (Predicate witness) $ev $round $node)
    (Evaluation (Predicate strong-majority-yes) $next-witnesses $ev))
  (Evaluation (Predicate famous-witness) $ev $round))
  (stv 0.95 0.85)))

;; === Virtual Voting ===
(|- ((Implication
  (And
    (Evaluation (Predicate shared-graph) $nodes $g)
    (Evaluation (Predicate locally-computable) $votes $g))
  (Evaluation (Predicate virtual-voting) $nodes $votes))
  (stv 1.0 0.9)))

;; === Consensos Order from Famous Witnesses ===
(|- ((Implication
  (And
    (Evaluation (Predicate famous-witness) $fw1 $r)
    (Evaluation (Predicate famous-witness) $fw2 $r)
    (Evaluation (Predicate ancestor-of) $ev $fw1)
    (Evaluation (Predicate ancestor-of) $ev $fw2))
  (Evaluation (Predicate consensos-received) $ev $r))
  (stv 0.95 0.85)))

;; === Asynchronous BFT Safety ===
(|- ((Implication
  (And
    (Evaluation (Predicate honest-supermajority) $nodes)
    (Evaluation (Predicate sufficient-gossip) $nodes $rounds))
  (Evaluation (Predicate total-order-agreement) $nodes $txs))
  (stv 0.99 0.85)))

;; === Liveness: Gossip Propagation ===
(|- ((Implication
  (And
    (Evaluation (Predicate honest-network) $net)
    (Evaluation (Predicate eventual-delivery) $net))
  (Evaluation (Predicate all-events-propagated) $nodes $events))
  (stv 0.95 0.85)))

;; === Fairness: Timestamp Consensus ===
(|- ((Implication
  (And
    (Evaluation (Predicate famous-witness) $fw $r)
    (Evaluation (Predicate event-timestamp) $ev $fw $ts)
    (Evaluation (Predicate median) $all-ts $consensus-ts))
  (Evaluation (Predicate consensus-timestamp) $ev $consensus-ts))
  (stv 0.9 0.85)))

;; === Fork Resolution ===
(|- ((Implication
  (And
    (Evaluation (Predicate hashgraph-event) $ev1 $node $txs1)
    (Evaluation (Predicate hashgraph-event) $ev2 $node $txs2)
    (Evaluation (Predicate same-self-parent) $ev1 $ev2))
  (Evaluation (Predicate fork-violation) $node))
  (stv 1.0 0.95)))
