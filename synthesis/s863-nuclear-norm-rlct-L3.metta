(; Nuclear Norm Regularization x RLCT - L3 MeTTa Encoding
; Synthesis #863 | Author: Oma | Date: 2026-11-06
; C1 PROVEN (stv 1.0 0.95), C2-C5 CONJECTURAL (stv 0.5-0.6 0.65-0.75)

; ===== TYPE DECLARATIONS =====
(: WeightMatrix Tensor)
(: SingularValue Real)
(: NuclearNorm Real)
(: Subdifferential Set)
(: RankStratum Set)
(: SoftThresholdOp Map)
(: RegStrength Real)
(: EffectiveRank Int)
(: GenBoundNN Real)

; ===== D1: PARAMETER SPACE =====
(= (NuclearNormRegularizedLoss $W $lambda)
   (+ (DataLoss $W) (* $lambda (NuclearNorm $W))))

(= (NuclearNorm $W)
   (Sum (SingularValues $W)))

; ===== D2: NUCLEAR NORM SUBDIFFERENTIAL STRUCTURE =====
; At rank-r W = U_r Sigma_r V_r^T, subdifferential = {U_r V_r^T + Z : ||Z||_op <= 1, U_r^T Z = 0, Z V_r = 0}
(= (SubdifferentialNuclearNorm $W)
   (SubdiffSet (LeftSingularVectors $W) (RightSingularVectors $W) (Rank $W)))

(= (SubdiffDimension $r $d $V)
   (* (- $d $r) (- $V $r)))

; ===== D3: R_{an,exp} DEFINABILITY (C1 PROVEN) =====
(|- ((==> (NuclearNormDefinable $W) (RanExpDefinable (NuclearNormRegularizedLoss $W $lambda))) (stv 1.0 0.95))
    ((NuclearNormDefinable $W) (stv 1.0 0.95)))

(= (NuclearNormDefinable $W)
   (And (Subanalytic (Sqrt (MatMul (Transpose $W) $W)))
        (Semialgebraic (SingularValues $W))
        (Subanalytic (Trace (Sqrt (MatMul (Transpose $W) $W))))))

; ===== D4: NUCLEAR NORM BOUNDARY SINGULAR FIBER (C2 CONJECTURAL) =====
; Rank-stratified singular fiber: V_lambda = union_r V_lambda^(r)
(= (NuclearNormSingularFiber $lambda)
   (UnionOverR (RankStratumFiber $r $lambda)))

(= (RankStratumFiber $r $lambda)
   (Intersection (ZeroLossFiber) (RankLevelSet $r) (NuclearNormBall $lambda)))

; Codimension of rank-r stratum = (d-r)(V-r)
(= (RankStratumCodim $r $d $V)
   (* (- $d $r) (- $V $r)))

; C2: Subdifferential creates non-smooth singularity at rank-deficient points
(|- ((==> (And (RankDeficient $W $r $d $V) (InFiber $W $lambda))
          (NonSmoothSingularity $W (SubdifferentialNuclearNorm $W))) (stv 0.6 0.7))
    ((RankDeficient $W $r $d $V) (stv 0.5 0.7)))

; ===== D5: SINGULAR VALUE THRESHOLDING AS STRATUM SELECTOR (C3 CONJECTURAL) =====
; Soft thresholding: S_lambda(W) = U diag(max(sigma_k - lambda, 0)) V^T
(= (SoftThresholdOp $W $lambda)
   (SVT $W $lambda))

(= (EffectiveRank $W $lambda)
   (Count (GreaterThan (SingularValues $W) $lambda)))

; C3: RLCT of rank-r stratum = (d-r)(V-r)/2
(= (RLCT_NuclearNorm $r $d $V)
   (/ (RankStratumCodim $r $d $V) 2))

; lambda continuously selects effective rank via thresholding
(|- ((==> (Increases $lambda) (Decreases (EffectiveRank $W $lambda))) (stv 0.6 0.75))
    ((NuclearNormRegularizedLoss $W $lambda) (stv 0.5 0.7)))

; Continuous stratum selector: lambda -> r(lambda) is staircase for generic W
(|- ((==> (And (Generic $W) (InFiber $W $lambda))
          (StaircaseSelector $lambda (EffectiveRank $W $lambda))) (stv 0.55 0.7))
    ((SoftThresholdOp $W $lambda) (stv 0.5 0.65)))

; ===== D6: GENERALIZATION BOUND WITH NUCLEAR NORM PENALTY (C4 CONJECTURAL) =====
; Gen <= RLCT(r*) * log(n)/(2n) + U_NN/sqrt(n) + lambda * r* / n
(= (GenBoundNN $rstar $lambda $n)
   (+ (+ (* (RLCT_NuclearNorm $rstar $d $V) (/ (log $n) (* 2 $n)))
         (/ (BoundaryTermNN $rstar) (sqrt $n)))
      (/ (* $lambda $rstar) $n)))

; Boundary term from subdifferential non-smoothness
(= (BoundaryTermNN $rstar)
   (SubdiffInflation $rstar $d $V))

(= (SubdiffInflation $rstar $d $V)
   (SubdiffDimension $rstar $d $V))

; C4: Tradeoff: larger lambda -> smaller r* -> smaller RLCT but larger bias
(|- ((==> (GenBoundNN $rstar $lambda $n)
          (TradeoffRLCTvsBias $lambda $rstar)) (stv 0.5 0.7))
    ((NuclearNormRegularizedLoss $W $lambda) (stv 0.5 0.65)))

; ===== D7: CRITICAL REGULARIZATION lambda* PHASE TRANSITION (C5 CONJECTURAL) =====
; Phase transition at lambda*: effective rank crosses true rank
(= (CriticalLambda $lambda_star $r_true)
   (PhaseTransition $lambda_star $r_true))

; C5: SGLD-detectable LLC jump at lambda*
(|- ((==> (And (= $lambda $lambda_star) (CrossesThreshold (SingularValues $W) $lambda))
          (LLCJump $lambda_star)) (stv 0.55 0.7))
    ((CriticalLambda $lambda_star $r_true) (stv 0.5 0.65)))

; Smoother than LoRA (singular values cross one at a time), sharper than spectral norm
(|- ((==> (PhaseTransition $lambda_star $r_true)
          (And (SmootherThan LoRA_RankJump) (SharperThan SpectralNorm_Lipschitz))) (stv 0.5 0.65))
    ((CriticalLambda $lambda_star $r_true) (stv 0.5 0.65)))

; ===== PLN CHAINS =====

; PLN Chain 1: Definability -> Singularity
(|~ ((Implication (Inheritance NuclearNormRegularizedLoss RanExpDefinable)
                 (Inheritance NuclearNormRegularizedLoss HasFiniteRLCT)) (stv 1.0 0.9))
    ((Inheritance NuclearNormRegularizedLoss RanExpDefinable) (stv 1.0 0.95)))

; PLN Chain 2: Subdifferential non-smoothness -> singular fiber
(|~ ((Implication (Inheritance $W NonSmoothSubdifferentialPoint)
                 (Inheritance $W SingularFiberPoint)) (stv 0.7 0.75))
    ((Inheritance (RankDeficient $W $r $d $V) NonSmoothSubdifferentialPoint) (stv 0.6 0.7)))

; PLN Chain 3: Soft thresholding -> rank selection -> RLCT
(|~ ((Implication (Inheritance (SoftThresholdOp $W $lambda) RankReducingMap)
                 (Inheritance (EffectiveRank $W $lambda) RLCTDeterminant)) (stv 0.6 0.7))
    ((Inheritance (SoftThresholdOp $W $lambda) RankReducingMap) (stv 0.55 0.7)))

; PLN Chain 4: Gen bound optimization -> optimal lambda*
(|~ ((Implication (Inheritance (GenBoundNN $rstar $lambda $n) UShapedInLambda)
                 (Inheritance (CriticalLambda $lambda_star $r_true) GenOptimal)) (stv 0.5 0.7))
    ((Inheritance (GenBoundNN $rstar $lambda $n) UShapedInLambda) (stv 0.5 0.65)))

; PLN Chain 5: Convex relaxation bridge: nuclear norm = convex envelope of rank
(|~ ((Implication (Inheritance NuclearNorm ConvexEnvelopeOfRank)
                 (Inheritance NuclearNormRegularization RLCTBridge)) (stv 0.55 0.7))
    ((Inheritance NuclearNorm ConvexEnvelopeOfRank) (stv 1.0 0.9)))

; ===== CAVEATS =====
; 1. Subdifferential non-smoothness may modify RLCT from determinantal codim/2
; 2. Matrix completion observation pattern Omega may change singular fiber structure
; 3. Factored nuclear norm (W=UV^T) may have different RLCT than direct nuclear norm
; 4. Noisy matrix completion: noise affects stratum selection
; 5. Multi-layer nuclear norm: strata may be coupled across layers
; 6. Non-square case (d != V): rectangular subdifferential geometry
; 7. SGLD distinguishability from LoRA discrete rank jumps unverified

; ===== CROSS-REFERENCES =====
; #473 Spectral Norm (max sigma vs sum sigma, smooth vs non-smooth)
; #223 LoRA (explicit rank vs implicit, discrete vs continuous selector)
; #502 LoRA L0 (determinantal variety framing)
; #622 Determinantal Variety Resolution (rank strata codim (d-r)(V-r))
; #89 CP Tensor Decomp (secant variety rank strata)
; #289 Adam (spectral preconditioning structure)
; #433 Weight Decay (L2 vs nuclear norm penalty geometry)
; #8 base XST, #16 core RL