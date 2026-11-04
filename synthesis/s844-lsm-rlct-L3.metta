;; Synthesis #844: Liquid State Machines x RLCT
;; L3 MeTTa encoding | 2026-11-03 | C1(i) proven, rest conjectural

;; Type declarations
(: LSM Concept)
(: Liquid Concept)
(: SpikeTrain Concept)
(: KernelWidth Concept)
(: SeparationRegime Concept)
(: ReadoutWeights Concept)
(: KernelFeatureMap Concept)
(: FeatureCovariance Concept)
(: LearningCoefficient Concept)
(: DefinabilityRestorer Concept)

;; D atoms
(= D1 (==> (--> net LSM) (&& (--> net Liquid) (--> net SpikeTrain) (--> net ReadoutWeights))) (stv 1.0 0.95))
(= D2 (==> (--> net LSM) (--> (trained-params net) W_out-on-kernel-features)) (stv 1.0 0.95))
(= D3 (==> (--> net LSM) (--> (state net) point-process)) (stv 1.0 0.95))
(= D4 (==> (&& (--> net LSM) (--> (kernel-width net) sigma) (> sigma 0)) (--> (features net) phi_sigma-smooth)) (stv 0.95 0.9))
(= D5 (==> (--> net LSM) (--> (liquid net) fixed-random)) (stv 1.0 0.95))

;; C1(i) proven: fixed-liquid readout loss algebraic in W_out
(= C1 (==> (&& (--> net LSM) (--> (liquid net) fixed)) (--> (readout-loss net) algebraic-definable)) (stv 1.0 0.95))
;; C1(ii) open: kernel smoothing restores joint definability up to O(sigma)
(= C1ii (==> (&& (--> net LSM) (--> (kernel-width net) sigma)) (--> (joint-loss net) definable-up-to-error)) (stv 0.55 0.7))

;; C2 conjectural: lambda_readout <= lambda_full at locked liquid
(= C2 (==> (&& (--> net LSM) (--> (liquid net) fixed)) (<= (--> lambda_readout net) (--> lambda_full net))) (stv 0.55 0.7))

;; C3 STAR: kernel width sigma as definability/stratum dial
(= C3 (==> (&& (--> net LSM) (--> (kernel-width net) sigma))
    (--> sigma (stratum-selector (--> (covariance-rank net))))) (stv 0.6 0.75))

;; C4 conjectural: generalization bound
(= C4 (==> (--> net LSM) (--> (gen-bound net) (+ (/ lambda_eff-sigma n) (/ U-sigma (sqrt n))))) (stv 0.55 0.7))

;; C5 conjectural: LLC staircase in sigma + regime jumps
(= C5 (==> (&& (--> net LSM) (--> (sgld-sweep net) sigma-regime))
    (--> (llc-trace net) staircase-plus-regime-jumps))) (stv 0.55 0.7))

;; PLN chain 1: fixed liquid -> algebraic readout -> RLCT exists
(|~ ((Implication (Inheritance $1 (IntSet FixedLiquidLSM))
           (Inheritance $1 AlgebraicReadout)) (stv 1.0 0.9))
    ((Inheritance LSM-Instance (IntSet FixedLiquidLSM)) (stv 1.0 0.9)))

;; PLN chain 2: separation regime -> full-rank covariance -> d_eff explicit
(|~ ((Implication (Inheritance $1 (IntSet SeparatingRegime))
           (Inheritance $1 FullRankCovariance)) (stv 0.9 0.85))
    ((Inheritance LSM-Instance (IntSet SeparatingRegime)) (stv 0.7 0.8)))

;; Caveats
;; 1. C1(ii) error quantification gap (O(sigma) bound unproven)
;; 2. No spectral analog of rho for spiking liquids (separation coordinate open)
;; 3. Sigma->0 definability degradation unquantified
;; 4. C2 fiber restriction argument shared with #843 OP1, unproven
;; 5. C5 negative prediction (joint-training non-Watanabe LLC) untested

;; Cross-refs: #8 #158 #354 #383 #480 #566 #601 #843
