# Synthesis #608: Class Balancing / Long-Tail Learning × RLCT — L3 MeTTa Encoding
## Date: 2026-10-25
## Status: L3 MeTTa Encoding

(: ParamTensor Type)
(: ClassIdx Type)
(: ClassWt Type)
(: Loss Type)
(: Fiber Type)
(: RLCT Type)
(: StratumType)
(: Selector Type)
(: Bias Type)
(: TailParam Type)
(: EffNum Type)

;; D1: Reweighted loss landscape
(= (bal-loss $w $wvec) (- (/ 1 $N) (sum $i (* (weight $y_i) (log (probab $y_i $x_i $w))))))
(= (zero-loss-bal $w $wvec) (intersect $k (singular-locus $k $w)))

;; D2: Class-indexed singular fiber
(= (class-locus $k $vector) (sum $i (= class-index $i $k) (log (probab $k $x_i $v))))
(= (class-fiber $wvec) (multi-fiber $w0 $w1 ... $wk $wvec))

;; D3: Effective number weight function
(= (effective-num $k $beta) (/ (- 1 (exp (* $nk_k (log $beta)))) (- 1 $beta)))
(= (eff-weight $k $beta) (/ $M (* $k (effective-num $k $beta))))

;; D4: Weight vector as stratum selector
(= (stratum-selector $wvec) (multi-dim-selector $wvec))
(= (dominant-stratum $wvec) (arg-max lambda_bal $wvec))
(= (stratum-transition $wvec) (critical-surface Sigma $wvec))

;; D5: Reweighted RLCT
(= (rlct-bal $wvec) (rict-min $k (* $wk_k lambda_k))
;; under transversality: lambda_bal = min_k(w_k * lambda_k)
(= (inverse-freq-weight $k) (/ 1 $nk_k))
(= (effnum-weight $k $beta) (/ 1 (effective-num $k $beta)))

;; D6: Reweighting bias
(= (reweight-bias $wvec) (max $k (abs (- $wk_k (/ $nk_k $N)))))
(= (gen-bound-bal $wvec $w $n) (+ (* (rict-bal $wvec) (log $n) (/ 2)) (/ (reweight-bias $wvec) (sqrt $n)) (/ (arg-max $k $s) (sqrt $n)))

;; D7: Tail-length parameter
(= (tail-dist $k $rho) (* $k (exp (- (* rho_k (log $k))))))
(= (tail-crit rho*) (critical-imbalance rho))

;; C1 (PROVEN): R_an_exp definability
(|- ((==> (Inheritance $w (Singular Lignable Balanced))
(inherence $w RDdefinable)) (stv 1.0 0.95))
((= (bal-loss $wnew $wvec))
(inference $wnew analytic))
(==> (inherence $wnew RanexpDefinable))
(meta-app (log) (exp) (/) (*) (+) (-) $wvec constants))
(stv 1.0 0.95))

;; C2 (CONJECTURAL): Class-indexed singular fiber
(|- ((==> (Implication (Inheritance $wvec ClassIndexedFiber))
(inherence $wvec SingularLoc)) (stv 0.5 0.7))
((= (rict-bal $wvec))
(belongs fiber variety))
((==> (rict-bal $wvec) (in (set fiber-dim-k))) (conjecture))
((stv 0.5 0.7)))

;; C3 (CONJECTURAL): Multi-dim stratum selector (CONJECTURAL)
(|- ((==> (Implication (Inheritance $wvec KDimContiguousSelector))
(inherence $wvec KDimContinousSelector)) (stv 0.5 0.7))
((= (stratum-selector $wvec) (dimension K)))
((==> (crossing Sigma stratum-transition) (conjecture))
((stv 0.5 0.75)))

;; C4 (CONJECTURAL): Gen bound with reweighting bias (CONJECTURAL)
(|-
((==> (Implication
(Inheritance $w (Set GeneralizabilityRichness))
(Implication (reweighting-bias-compromise) (reweighting-bias)))
(stv 0.5 0.7))
((= (gen-bound-bal $wvec $w $n))
(requires bias complexity tradeoff))
((stv 0.5 0.7)))

;; C5 (CONJECTURAL): Tail-length phase transition (CONJECTURAL)
(|-
((==>
((Implication (rl crit) Importance))
((Implication (effnum-saturation-regularizes) (crossing critical surface))))
(stv 0.5 0.7))
((= (tail-crit rho*))
(class balancing becomes essential only above rho*)
((stv 0.5 0.7)))

;; PLN Chain 1: Reweighting reduces RLCT for minority classes
(|~ ((Implication
((Inheritance $wkinfreq MinorityUpweight))
((Implication
((Implication $wkinfreq (creates dominant fiber Sk)))
((Implication dominant_fiber (reduces rict-bal))))
(I= (reduces (rict-bal $wvec))))
(stv 0.75 0.8))
((Inheritance $wkinfreq MinorityUpweight) (stv 1.0 0.9))
((==> (reduces rict-bal $wvec) (stv 0.7 0.8))

;; PLN Chain 2: Bias-complexity tradeoff prevents inverse-freq optimality
(|~
((Implication
((Inheritance $w ReweightedLoss))
(Implication bias grows with reweighting)))
((Implication reweighting-bias creates gen-bound tradeoff))
(==> not inverse-freq optimal)
(stv 0.75 0.75))

;; PLN Chain 3: Effective number saturation smooths stratum transition
(|~
((Implication (class balancing selects dominant stratum))
(Implication (such selection depends on rho)))
((Implication (effnum saturation smooths transition))
(==> (for rho > rho* balancing essential))
(stv 0.7 0.8))

;; PLN Chain 4: Transversality gives lambda_bal = min_k(w_k * lambda_k)
(|~
((Implication (class strata transversal))
(Implication (rl was min_k scaled contribution)))
((==> (rict-bal determined by minimum scaled stratum))
(not inverted by majority class))
(stv 0.8 0.85))

;; PLN Chain 5: Optimal weights balance reduction versus bias
(|~
((Implication (class balancing reduces RLCT or creates bias))
((Implication (optimal w** tradeoff RLCT vs bias))
(not necessarily inverse-freq))
(stv 0.7 0.8))

;; Caveat 1: Transversality of class strata not proven for specific architectures
;; Caveat 2: Topology of sigma surfaces in R_{>0}^K for general K-dim selector unknown
;; Caveat 3: Explicit form of U(wvec) for bias component unresolved
;; Caveat 4: rho* depends on architecture and dataset, not predictable a priori
;; Caveat 5: Sample frequency in training may generate transient deviations from assumed power-law

;; Cross-References (12)
;; #8 #539 #433 #536 #372 #95 #548 #323 #600 #515 #169 #470