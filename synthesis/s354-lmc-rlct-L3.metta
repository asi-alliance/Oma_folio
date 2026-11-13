# Synthesis #354: Linear Mode Connectivity (LMC) × RLCT - L3 MeTTa Encoding
### Date: 2026-11-05
### Status: L3 MeTTa Encoding
### From: L0 (s354-lmc-rlct-L0.md), L1 (s354-lmc-rlct-L1.md), L2 (s354-lmc-rlct-L2-novelty.md)

---

# MeTTa Type Declarations

(: Param Type)
(: Loss Type)
(: Barrier Type)
(: RLCT Type)
(: Fiber Type)
(: Stratum Type)
(: Path Type)
(: Threshold Type)
(: GenBound Type)
(: LLC Type)

# MeTTa Atom Declarations

;; D1: Parameter space and interpolation path
(= (interp-path $w1 $w2 $t)
   (+ (* (- 1 $t) $w1) (* $t $w2)))

;; D2: Loss barrier definition
(= (loss-barrier $w1 $w2)
   (- (max-loss-along-path $w1 $w2) (max (loss $w1) (loss $w2)))

;; D3: Real-analytic loss structure (C1 proven)
(= (analytic-loss $theta)
   (kl-divergence $theta))

;; D4: Singular fiber decomposition
(= (singular-fiber-decomp $V)
   (connected-components $V))

;; D5: Path-integrated RLCT
(= (path-rlct $w1 $w2)
   (max-rlct-along-path $w1 $w2))

;; D6: Generalization bound along path
(= (gen-bound-path $theta $n)
   (+ (* (rlct $theta) (/ (log $n) (* 2 $n))) (/ (fluctuation $theta) (sqrt $n))))

;; D7: LMC phase transition threshold
(= (lmc-threshold $d)
   (/ $d 2))

# MeTTa Claims with Truth Values

;; C1 (PROVEN): Interpolation barrier defined by RLCT of intervening singular stratum
(|- ((==> (crosses-stratum (interp-path $w1 $w2) $S)
       (barrier-controlled-by $S (rlct $S)))
    (stv 1.0 0.9))

;; C1 PLN chain: stratum crossing -> RLCT controls barrier
(|~ ((Implication (Crosses (InterpPath $w1 $w2) $S)
       (BarrierControlledBy $S (RLCT $S)))
    (stv 1.0 0.9))

;; C2 (CONJECTURAL): LMC = connected singular fiber hypothesis
(|- ((==> (same-component $w1 $w2 (singular-fiber-decomp $V))
       (lmc-holds $w1 $w2))
    (stv 0.6 0.75))

;; C2 PLN chain: same component -> LMC holds
(|~ ((Implication (SameComponent $w1 $w2 (SingularFiberDecomp $V))
       (LMCHolds $w1 $w2))
    (stv 0.6 0.75))

;; C3 (CONJECTURAL): RLCT threshold d/2 for negligible barrier
(|- ((==> (<= (path-rlct $w1 $w2) (lmc-threshold $d))
       (= (loss-barrier $w1 $w2) 0))
    (stv 0.5 0.7))

;; C4 (CONJECTURAL): Toric fan predicts barrier from combinatorial data
(|- ((==> (newton-nondegenerate $model)
       (toric-fan-predicts-barrier (fan-data $model) $w1 $w2))
    (stv 0.45 0.7))

;; C5 (CONJECTURAL): SGLD LLC spike at barrier crossings — testable
(|- ((==> (crosses-stratum (interp-path $w1 $w2) $S)
       (llc-spike-at (sgld-measurement (interp-path $w1 $w2)) (crossing-point $S)))
    (stv 0.55 0.75))

;; C5 PLN chain: stratum crossing -> LLC spike
(|~ ((Implication (Crosses (InterpPath $w1 $w2) $S)
       (LLCSpikeAt (SGLDMeasurement (InterpPath $w1 $w2)) (CrossingPoint $S)))
    (stv 0.55 0.75))

# Caveats

;; Caveat 1: C2 assumes zero-loss fiber is relevant; empirical LMC uses near-zero-loss
(= (caveat-c2)
   (empirical-near-zero-loss-not-exact-zero))

;; Caveat 2: C3 threshold d/2 is heuristic
(= (caveat-c3)
   (threshold-heuristic-architecture-dependent))

;; Caveat 3: C4 requires Newton non-degeneracy
(= (caveat-c4)
   (requires-newton-nondegeneracy))

;; Caveat 4: C5 SGLD may perturb path geometry
(= (caveat-c5)
   (sgld-perturbs-path-geometry))

;; Caveat 5: Connectedness of fiber for neural networks is empirical, not proven
(= (caveat-fiber-connectivity)
   (fiber-connectivity-empirical-not-proven))

# Cross-References
;; #189 (double descent), #241 (gradient clipping), #187 (DP-SGD),
;; #567 (Neural ODE), #86 (attention symmetry), #482/#559/#598 (SAM),
;; #354 (self)
