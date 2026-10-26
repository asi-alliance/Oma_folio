;; Synthesis #653: Depthwise Separable Convolution × RLCT
;; L3 — MeTTa Encoding
;; Date: 2026-10-26
;; Status: L3 MeTTa Encoding

;; === Type Declarations ===
(declare-type DepthwiseWeights (Type))
(declare-type PointwiseWeights (Type))
(declare-type GroupCount (Type))
(declare-type BlockDiagFiber (Type))
(declare-type DeterminantalVariety (Type))
(declare-type CompositeFiber (Type))
(declare-type PhaseTransitionG (Type))

;; === D1: Update Map Definability (C1 PROVEN) ===
(|- ((--> (× DepthwiseSeparableConv Synthesis#653)) (stv 1.0 0.9)))
(|- ((Inheritance DepthwiseConv R_an_exp_Definable) (stv 1.0 0.9)))
;; depthwise conv = polynomial in (X, W_dw)
(|- ((Inheritance PointwiseConv R_an_exp_Definable) (stv 1.0 0.9)))
;; pointwise conv = linear projection
(|- ((Inheritance ReLU R_an_exp_Definable) (stv 1.0 0.9)))
;; ReLU = piecewise polynomial = semi-algebraic
(|- ((Inheritance Softmax R_an_exp_Definable) (stv 1.0 0.9)))
(|- ((Inheritance CrossEntropy R_an_exp_Definable) (stv 1.0 0.9)))
(|- ((Inheritance CompositeMap R_an_exp_Definable) (stv 1.0 0.9)))
;; composition of definable maps is definable

;; === D2: Block-Diagonal Jacobian Structure ===
(|- ((--> (× DepthwiseConv Jacobian) BlockDiagonal) (stv 1.0 0.9)))
(|- (= J_dw (diag J_1 J_2 ... J_C)) (stv 1.0 0.9))
(|- (--> J_c PerChannelConvJacobian) (stv 1.0 0.9))
(|- (<= (rank J_dw) (* C (min HW K_sq))) (stv 1.0 0.9))
(|- (= rank J_dw (sum rank J_c)) (stv 1.0 0.9))
(|- (!= BlockDiagonal DenseJacobian) (stv 1.0 0.9))

;; === D3: Block-Diagonal Singular Fiber (C2 CONJECTURAL) ===
(declare-type PerChannelFiber (Type))
(|- ((Inheritance PerChannelFiber DeterminantalVariety) (stv 1.0 0.9)))
(|- ((Inheritance BlockDiagFiber SingularFiber) (stv 1.0 0.9)))
(|- (= V_dw (union V_1 V_2 ... V_C)) (stv 1.0 0.9))
(|- ((--> (× PerChannelRankDrop) PerChannelFiber) (stv 1.0 0.9)))
;; V_c = {theta : rank(J_c) < min(HW, K^2)}
(|- ((= (RLCT V_dw) (max_c RLCT V_c)) (stv 0.5 0.7)))
;; conjecture: independence gives max, not sum
(|- ((Implication (Independent V_i V_j) (= (RLCT (union V_i V_j)) (max (RLCT V_i) (RLCT V_j)))) (stv 1.0 0.7)))

;; === D4: Group-Count Stratified Family (C3 CONJECTURAL) ===
(declare-type GroupedConv (Type))
(declare-type StratumSelectorG (Type))
(|- ((--> (× GroupCount StratumSelectorG) (stv 1.0 0.9)))
(|- ((--> (× GroupCount_1 DenseConv) (stv 1.0 0.9)))
(|- ((--> (× GroupCount_C DepthwiseConv) (stv 1.0 0.9)))
(|- ((Inheritance GroupedConv InterpolatedArchitecture) (stv 1.0 0.9)))
(|- ((<= (RLCT g_1) (RLCT g_2)) (stv 0.5 0.7)))
;; conjecture: lambda_eff(g) monotonically decreasing in g
(|- ((Implication (> g_1 g_2) (< (lambda_eff g_1) (lambda_eff g_2))) (stv 0.6 0.7)))
(|- ((= (rank J_g) (* C (min HW K_sq))) (stv 1.0 0.9)))
;; same rank upper bound regardless of g, but singular LOCUS differs

;; === D5: Composite Singular Fiber ===
(|- (= V_total (union V_dw V_pw V_comp)) (stv 1.0 0.9))
(|- ((Inheritance V_pw PointwiseRankDeficiency) (stv 1.0 0.9)))
(|- ((Inheritance V_comp CompositionInteraction) (stv 1.0 0.9)))
(|- ((Subset V_comp V_dw) (stv 0.5 0.7)))
;; conjecture: composition interaction is subset of depthwise deficiency
(|- ((<= (dim V_comp) (dim V_dw)) (stv 0.6 0.7)))

;; === D6: Generalization Bound (C4 CONJECTURAL) ===
(declare-type FactorizedRLCT (Type))
(|- ((Inheritance FactorizedRLCT GenBoundComponent) (stv 1.0 0.9)))
(|- ((= (GenBound DepthwiseSep) (+ (* lambda_eff (/ (log n) (* 2 n))) (/ B_comp (sqrt n)))) (stv 0.5 0.7)))
(|- ((Implication (Independent V_dw V_pw) (<= (RLCT V_total) (+ (RLCT V_dw) (RLCT V_pw)))) (stv 1.0 0.7)))
;; subadditivity under independence
(|- ((<= (RLCT DepthwiseSep) (RLCT DenseConv)) (stv 0.5 0.7)))
;; conjecture: factorization reduces RLCT at comparable accuracy
(|- ((Implication (ComparableAccuracy DepthwiseSep DenseConv) (<= (lambda_eff_depthwise) (lambda_eff_dense))) (stv 0.5 0.7)))

;; === D7: Phase Transition at g* (C5 CONJECTURAL) ===
(declare-type CriticalGroupCount (Type))
(|- ((--> (× CriticalGroupCount PhaseTransition) (stv 1.0 0.7)))
(|- ((--> (× CriticalGroupCount LLC_Kink) (stv 1.0 0.7)))
(|- ((Implication (> g g_star) (< (lambda_eff g) (lambda_eff dense))) (stv 0.6 0.7)))
(|- ((Implication (< g g_star) (= (lambda_eff g) (lambda_eff dense))) (stv 0.6 0.7)))
(|- ((--> (× g_star AccuracyDegradation) (stv 0.6 0.7)))
;; at g*, per-group info insufficient for pointwise reconstruction
(|- ((--> (× GroupCount SGLDTestable) (stv 1.0 0.9)))
(|- ((= (LLC_hat g) (mean_t (- (* n L_t) (/ (* n (norm theta_t theta_0) 2))))) (stv 1.0 0.9)))
(|- ((Implication (= g g_star) (StepDecrease LLC_hat)) (stv 0.6 0.7)))
(|- ((!= (× DepthwiseSep LLC_Profile) (× DenseConv LLC_Profile)) (stv 1.0 0.9)))

;; === PLN Chains ===
;; Chain 1: C1 Definability
(|- ((Inheritance DepthwiseConv R_an_exp_Definable) (stv 1.0 0.9)))
(|- ((Inheritance PointwiseConv R_an_exp_Definable) (stv 1.0 0.9)))
(|- ((Inheritance CompositeMap R_an_exp_Definable) (stv 1.0 0.9)))
(|~ ((Implication (Inheritance A R_an_exp_Definable) (Inheritance (Composite A B) R_an_exp_Definable)) (stv 1.0 0.9)))
(|~ ((Implication (Inheritance (Composite DepthwiseConv PointwiseConv) R_an_exp_Definable) (WellDefined RLCT)) (stv 1.0 0.9)))

;; Chain 2: C2 Block-diagonal fiber
(|~ ((Implication (= V_dw (union V_1 ... V_C)) (= (RLCT V_dw) (max_c (RLCT V_c)))) (stv 0.5 0.7)))
(|~ ((Implication (Independent V_i V_j) (<= (RLCT (union V_i V_j)) (max (RLCT V_i) (RLCT V_j)))) (stv 0.7 0.7)))

;; Chain 3: C3 Group stratification
(|~ ((Implication (> g_1 g_2) (< (lambda_eff g_1) (lambda_eff g_2))) (stv 0.6 0.7)))
(|~ ((Implication (and (> g g_star) (MaintainedAccuracy)) (< lambda_eff lambda_dense)) (stv 0.5 0.7)))

;; Chain 4: C4 Gen bound
(|~ ((Implication (Independent V_dw V_pw) (<= (RLCT V_total) (+ (RLCT V_dw) (RLCT V_pw)))) (stv 0.7 0.7)))
(|~ ((Implication (and (FactorizedArchitecture) (ComparableAccuracy)) (<= lambda_depthwise lambda_dense)) (stv 0.5 0.7)))

;; Chain 5: C5 Phase transition
(|~ ((Implication (= g g_star) (and (StepDecrease LLC_hat) (AccuracyDegradation))) (stv 0.6 0.7)))
(|~ ((Implication (Sweep g 1 C) (StepDecrease LLC_hat_at_g_star)) (stv 0.6 0.7)))

;; === Caveats ===
;; 1. Independence assumption for max-RLCT may fail if V_c overlap
;; 2. Monotonicity of lambda_eff(g) assumes per-group information loss is gradual
;; 3. Gen bound subadditivity requires sufficient separation of V_dw and V_pw
;; 4. g* phase transition is empirical prediction, needs SGLD validation
;; 5. Composition interaction V_comp may dominate in deep stacks

;; === Cross-References ===
(|- ((CrossRef DepthwiseSep #16_ReLU) (stv 1.0 0.9)))
(|- ((CrossRef DepthwiseSep #134_Attention) (stv 1.0 0.9)))
(|- ((CrossRef DepthwiseSep #220_Pruning) (stv 1.0 0.9)))
(|- ((CrossRef DepthwiseSep #223_LoRA) (stv 1.0 0.9)))
(|- ((CrossRef DepthwiseSep #234_Temperature) (stv 1.0 0.9)))
(|- ((CrossRef DepthwiseSep #354_STE) (stv 1.0 0.9)))
(|- ((CrossRef DepthwiseSep #434_MoE) (stv 1.0 0.9)))
(|- ((CrossRef DepthwiseSep #472_SENet) (stv 1.0 0.9)))
(|- ((CrossRef DepthwiseSep #535_Word2Vec) (stv 1.0 0.9)))
(|- ((CrossRef DepthwiseSep #599_DPO) (stv 1.0 0.9)))
(|- ((CrossRef DepthwiseSep #609_SwiGLU) (stv 1.0 0.9)))
