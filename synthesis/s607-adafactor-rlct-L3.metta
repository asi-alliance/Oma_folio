# Synthesis #607: AdaFactor x RLCT - L3 MeTTa Encoding
### Date: 2026-10-25
### Status: L3 MeTTa Encoding

(: ParamMatrix Type)
(: RowFactor Type)
(: ColFactor Type)
(: Metric Type)
(: Step Type)
(: Loss Type)
(: Fiber Type)
(: RLCT Type)
(: GridStratum Type)
(: Rank Type)
(: Bias Type)

;; D1: Factored state space
(= (adafactor-state    ) (StateSpace    ))

;; D2: Factored update map
(= (adafactor-update        )
   (-  (*  (hadamard (factored-inv-sqrt   ) ))))

(= (row-ema   ) (+ (*  ) (* (- 1 ) (row-sq-sum ))))
(= (col-ema   ) (+ (*  ) (* (- 1 ) (col-sq-sum ))))

;; D3: Rank-1 factored preconditioner fiber
(= (factored-metric  ) (outer-product  ))
(= (factored-inv-sqrt   ) (entrywise-inv-sqrt (outer-product  ) ))

;; D4: Grid-structured frozen set (row union col)
(= (grid-frozen-set   ) (union (frozen-rows  ) (frozen-cols  )))
(= (active-grid     ) (* (-  (size (frozen-rows  ))) (-  (size (frozen-cols  )))))

;; D5: Gen bound with factored bias
(= (gen-bound-adafactor -fact   -rank ) (+ (/ (* -fact (log )) (* 2 )) (/ -rank (sqrt ))))
(= (rank-bias   ) (/ (norm-frobenius (-  (outer-product  ))) (sigma-max )))

;; D6: Dual beta stratum selector (2D lattice)
(= (stratum-lattice    ) (GridStratum (-  ) (-  )))
(= (dual-selector  ) (StratumSelector (pair  )))

;; D7: Phase transition at factor rank collapse (asymmetric)
(= (asymmetric-kink   -type) (if (= -type row)  ))

;; C1 (PROVEN): R_an_exp definability
(|- ((==> (And (Definable (adafactor-update        )) (Definable (row-ema   )) (Definable (col-ema   ))) (R_an_exp (adafactor-trajectory        ))) (stv 1.0 0.95))

;; C2 (CONJECTURAL): Grid-structured fiber
(|- ((==> (And (Equal (rank (factored-metric  )) 1) (Or (HasZeroEntry ) (HasZeroEntry ))) (DegenerateFiber (grid-frozen-set   ))) (stv 0.6 0.7))

;; C3 (CONJECTURAL): 2D stratum lattice
(|- ((==> (StratumSelector (dual-selector  )) (TwoDLattice (stratum-lattice    ))) (stv 0.5 0.7))

;; C4 (CONJECTURAL): Gen bound with factored bias
(|~ ((Implication (AdaFactorOptimizer ) (GenBound (gen-bound-adafactor -fact   -rank ))) (stv 0.5 0.7))

;; C5 (CONJECTURAL): Asymmetric phase transition
(|- ((==> (GridCollapse (frozen-rows  )) (AsymmetricKink (asymmetric-kink   row))) (stv 0.6 0.7))

;; Caveats: 1) Rank-1 fixed, no schedule. 2) Grid freezing is union not intersection. 3) Dual beta coupled via shared gradient. 4) Normalization may change singular geometry. 5) Relative step size couples param scale to metric.
;; Cross-Refs: #516 K-FAC, #289 Adam, #605 Adagrad, #606 RMSProp, #591 AdaBelief, #354 SGD, #415 Muon, #480 muP, #505 WeightNorm, #433 WeightDecay, #8/#16 RLCT foundational
