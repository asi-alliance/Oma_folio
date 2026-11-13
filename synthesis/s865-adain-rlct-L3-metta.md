# Synthesis #865: AdaIN × RLCT — L3 MeTTa Encoding

**Date:** 2026-11-06 | **Author:** Oma | **Status:** L3 METTA ENCODING

---

## Type Declarations

(: DecoderParam (-> Int DecoderParam))
(: ContentImage (-> Int ContentImage))
(: StyleImage (-> Int StyleImage))
(: Feature (-> ContentImage Feature))
(: StyleStat (-> StyleImage StyleMean StyleStd))
(: AdaIN (-> Feature StyleMean StyleStd Feature))
(: GramMatrix (-> Feature GramMatrix))
(: VarianceCollapseFiber (-> DecoderParam VarianceCollapseFiber))
(: GramFiber (-> DecoderParam GramFiber))
(: ReconFiber (-> DecoderParam ReconFiber))
(: CompositeFiber (-> DecoderParam Real CompositeFiber))
(: RLCT (-> CompositeFiber Real))
(: StratumSelector (-> Real CompositeFiber))
(: GenBound (-> Int Real Int Int Real))
(: PhaseTransition (-> Real Real))

## C1: R_{an,exp}-Definability (PROVEN)

(|- ((==> (AdaIN $content $smean $sstd)
          (R_an_exp_definable AdaIN))
     (stv 1.0 0.95))
    ((R_an_exp_definable AdaIN)
     (stv 1.0 0.9)))

; Rational function (division by sigma_c) is R_an,exp-definable on {sigma_c > 0}
(|- ((==> (And (VarianceCollapseFiber $theta)
               (= sigma_c 0))
          (PoleSingularity AdaIN))
     (stv 1.0 0.95))
    ((VarianceCollapseFiber $theta)
     (stv 0.0 0.9)))

## C2: Variance-Collapse Rational Singularity (CONJECTURAL)

(|- ((==> (VarianceCollapseFiber $theta)
          (And (SingularFiber $theta)
               (= (SingularityType $theta) RationalPole)))
     (stv 1.0 0.7))
    ((VarianceCollapseFiber $theta)
     (stv 0.0 0.9)))

; First rational singularity in catalog — distinct from polynomial/piecewise singularities
(|- ((==> (CompositeFiber $theta $lambda)
          (Intersection ReconFiber GramFiber))
     (stv 1.0 0.7))
    ((CompositeFiber $theta 0)
     (stv 0.0 0.9)))

## C3: λ as Content-Style Stratum Selector (CONJECTURAL)

(|- ((==> (StratumSelector $lambda)
          (Or (= $lambda 0) (> $lambda 0)))
     (stv 1.0 0.7))
    ((StratumSelector 0)
     (stv 0.0 0.9)))

; lambda=0: V_recon only (polynomial); lambda>0: V_recon ∩ V_gram (polynomial × quadratic)
(|- ((==> (= $lambda 0)
          (= (DominantFiber $lambda) ReconFiber))
     (stv 1.0 0.8))
    ((StratumSelector $lambda)
     (stv 0.0 0.9)))

(|- ((==> (> $lambda $lambda_star)
          (= (DominantFiber $lambda) GramFiber))
     (stv 1.0 0.7))
    ((StratumSelector $lambda)
     (stv 0.0 0.9)))

## C4: Generalization Bound (CONJECTURAL)

(|- ((==> (GenBound $n $lambda_eff $C $L $G)
          (= $G (+ (* (/ (* $lambda_eff (log $n)) (* 2 $n))
                      (/ $U $sqrt_n))))
     (stv 1.0 0.7))
    ((GenBound $n $lambda $C $L $G)
     (stv 0.0 0.9)))

; lambda_eff transitions between RLCT(V_recon) and RLCT(V_gram)
(|- ((==> (RLCT (CompositeFiber $theta $lambda) $lambda_eff)
          (Min (RLCT ReconFiber) (RLCT GramFiber) (RLCT Intersection)))
     (stv 1.0 0.7))
    ((CompositeFiber $theta $lambda)
     (stv 0.0 0.9)))

## C5: λ* Phase Transition (CONJECTURAL)

(|- ((==> (PhaseTransition $lambda $lambda_star)
          (And (< $lambda $lambda_star)
               (= (DominantFiber $lambda) ReconFiber)))
     (stv 1.0 0.7))
    ((PhaseTransition $lambda $lambda_star)
     (stv 0.0 0.9)))

(|- ((==> (PhaseTransition $lambda $lambda_star)
          (And (> $lambda $lambda_star)
               (= (DominantFiber $lambda) GramFiber)))
     (stv 1.0 0.7))
    ((PhaseTransition $lambda $lambda_star)
     (stv 0.0 0.9)))

; Order parameter: Gram rank discrepancy rho(lambda)
(|- ((==> (= $lambda $lambda_star)
          (And (SGLD_LLC_Spike $theta)
               (= (GramRankDiscrepancy $theta) 0)))
     (stv 1.0 0.7))
    ((PhaseTransition $lambda_star $lambda_star)
     (stv 0.0 0.9)))

## Key Caveats

1. RLCT of rational singularity V_var requires resolution theory for non-polynomial maps — Hironaka applicability unproven
2. Transversality of V_recon ∩ V_gram unverified — may have excess intersection
3. Gram matrix rank deficiency → multiplicity → RLCT connection is conjectural
4. Frozen VGG encoder ReLU piecewise structure interaction with V_var unanalyzed
5. Multi-layer product fiber V_gram = ∩_l V_gram,l transversality unverified
6. λ* existence may be monotonic — no crossover possible
7. ε > 0 regularization makes V_var approximate; RLCT correction as ε → 0 unproven

## Cross-References

#8 (CE) #16 (ReLU) #57 (attention) #134 (QK^T) #169 (dropout)
#234 (batch norm) #355 (perceptual loss) #363 (adaLN) #433 (PolyLoss)
#466 (RMSNorm) #505 (weight norm) #515 (VAE) #539 (focal loss)
#592 (NovoGrad) #665 (Neural Collapse) #855 (capsule routing)
#860 (LARS) #864 (center loss)
