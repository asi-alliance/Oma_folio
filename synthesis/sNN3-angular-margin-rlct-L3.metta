;; SNN3: Angular Margin (ArcFace/CosFace/SphereFace) × RLCT - L3 MeTTa Encoding
;; Date: 2026-11-05
;; Author: Oma (OmegaClaw agent)
;; Status: L3 encoding
;; Depends on: sNN3-angular-margin-rlct-L0.md, sNN3-angular-margin-rlct-L1.md, sNN3-angular-margin-rlct-L2-novelty.md

;; --- Type Declarations ---
(= (AngularMargin) Type)
(= (ArcFaceLoss) Type)
(= (CosFaceLoss) Type)
(= (SphereFaceLoss) Type)
(= (BranchPoint) Type)
(= (NormalizationQuotient) Type)
(= (RLCT) Type)
(= (StratumSelector) Type)
(= (GenBound) Type)
(= (Claim) Type)

;; --- D1: Normalized Cosine Model ---
(= (cos-k $w $x $k) (/ (dot (w-k $k) (x-vec)) (* (norm (w-k $k)) (norm (x-vec)))))
(= (scale-logit $s $f) (* $s $f))

;; --- D2: ArcFace Margin Function ---
(= (arcface-margin $c $m) (- (* $c (cos-const $m)) (* (sqrt (- 1 (* $c $c))) (sin-const $m))))
(= (cosface-margin $c $m) (- $c $m))
(= (sphereface-margin $c $m) (chebyshev $m $c))

;; --- D3: Hierarchy of Singular Complexity ---
(= (hierarchy-softmax) (SmoothLogistic))
(= (hierarchy-cosface) (AlgebraicSmooth))
(= (hierarchy-sphereface) (AlgebraicPolynomial))
(= (hierarchy-arcface) (SemialgebraicBranchPoint))

;; --- D4: ArcFace Loss ---
(= (arcface-loss $w $x $y $s $m $K) (+ (- (* (- 1) $s (arcface-margin (cos-k $w $x $y) $m)))
                                        (log (sum-exp $s (arcface-margin (cos-k $w $x $y) $m) (non-target-cos $w $x $y $K)))))

;; --- D5: Normalization Quotient Space ---
(= (norm-map $x) (/ (x-vec) (norm (x-vec))))
(= (quotient-sphere $d) (NormalizationQuotient $d))
(= (gauge-freedom RadialDirection))

;; --- D6: Branch Point Singular Fiber ---
(= (branch-point-plus) (BranchPoint 1))
(= (branch-point-minus) (BranchPoint -1))
(= (sqrt-singularity $c) (sqrt (- 1 (* $c $c))))
(= (near-c1 $c) (sqrt (* 2 (- 1 $c))))

;; --- D7: RLCT Definition ---
(= (lambda-arcface $w-star) (RLCT $w-star))
(= (zeta-func $z $w) (integrate (pow (K-func $w) $z) $w))
(= (K-func $w) (* (exp (* (- 1) $n (arcface-loss $w))) (phi-prior $w)))

;; --- C1: PROVEN - ArcFace loss is R_an-definable (subanalytic) ---
(= (c1-arcface-definable) (Claim C1))
(= (subanalytic (cos-k $w $x $k)) True)
(= (semialgebraic (arcface-margin $c $m)) True)
(= (subanalytic (sqrt (- 1 (* $c $c)))) True)
(= (subanalytic (arcface-loss $w $x $y $s $m $K)) True)

(|- ((==> (algebraic (cos-k $w $x $k))
       (subanalytic (cos-k $w $x $k)))
     (stv 1.0 0.95))
    ((algebraic (cos-k $w $x $k)) (stv 1.0 0.95)))

(|- ((==> (And (subanalytic (cos-k $w $x $k))
              (subanalytic (sqrt (- 1 (* $c $c)))))
       (semialgebraic (arcface-margin $c $m)))
     (stv 1.0 0.95))
    ((subanalytic (sqrt (- 1 (* $c $c)))) (stv 1.0 0.95)))

(|- ((==> (And (semialgebraic (arcface-margin $c $m))
              (subanalytic (cos-k $w $x $k)))
       (subanalytic (arcface-loss $w $x $y $s $m $K)))
     (stv 1.0 0.95))
    ((semialgebraic (arcface-margin $c $m)) (stv 1.0 0.95)))

;; --- C2: CONJECTURAL - sqrt branch points create singular fibers ---
(= (c2-branch-singular) (Claim C2))
(= (fold-singularity $c) (BranchPoint $c))

(|~ ((==> (BranchPoint 1)
       (And (Inheritance (near-c1 1) (IntSet SquareRootSingular))
            (Inheritance (branch-point-plus) (IntSet FoldSingularity))))
     (stv 0.6 0.7))
    ((BranchPoint 1) (stv 0.5 0.7)))

;; PLN: sqrt divergence at c=1 increases RLCT
(|~ ((Implication (Inheritance (sqrt-singularity $c) (IntSet DivergentDerivative))
       (Inheritance (lambda-arcface $w-star) (IntSet InflatedRLCT)))
     (stv 0.6 0.7))
    ((BranchPoint 1) (stv 0.5 0.7)))

;; PLN: margin gap pinches zero-loss fiber
(|~ ((Implication (Inheritance (arcface-margin $c $m) (IntSet MarginGap))
       (Inheritance (arcface-loss $w $x $y $s $m $K) (IntSet PinchedFiber)))
     (stv 0.5 0.65))
    ((BranchPoint 1) (stv 0.5 0.7)))

;; --- C3: CONJECTURAL - margin m as continuous stratum selector ---
(= (c3-margin-selector) (Claim C3))
(= (lambda-of-m $m) (StratumSelector $m))

(|~ ((==> (StratumSelector $m)
       (And (Inheritance (lambda-of-m 0) (IntSet SoftmaxRLCT))
            (Inheritance (lambda-of-m $m-pos) (IntSet BranchPointRLCT))
            (Inheritance (lambda-of-m $m-star) (IntSet DivergentRLCT))))
     (stv 0.5 0.65))
    ((StratumSelector $m) (stv 0.5 0.65)))

;; PLN: increasing m narrows zero-loss stratum
(|~ ((Implication (Inheritance $m (IntSet IncreasingMargin))
       (Inheritance (lambda-of-m $m) (IntSet NarrowingStratum)))
     (stv 0.6 0.7))
    ((StratumSelector $m) (stv 0.5 0.65)))

;; --- C4: CONJECTURAL - generalization bound ---
(= (c4-gen-bound) (Claim C4))
(= (gen-bound-arcface $m $s $n) (GenBound $m $s $n))

(|~ ((==> (GenBound $m $s $n)
       (And (Inheritance (gen-bound-arcface $m $s $n) (IntSet RLCTBound))
            (Inheritance (lambda-arcface $w-star) (IntSet BranchPointContribution))))
     (stv 0.5 0.65))
    ((GenBound $m $s $n) (stv 0.5 0.65)))

;; PLN: scale s sharpens branch point singularity
(|~ ((Implication (Inheritance $s (IntSet LargeScale))
       (Inheritance (lambda-arcface $w-star) (IntSet SharpenedSingularity)))
     (stv 0.55 0.7))
    ((GenBound $m $s $n) (stv 0.5 0.65)))

;; --- C5: CONJECTURAL - normalization quotient singularity ---
(= (c5-norm-quotient) (Claim C5))
(= (quotient-origin $d) (NormalizationQuotient $d))

(|~ ((==> (NormalizationQuotient $d)
       (And (Inheritance (quotient-sphere $d) (IntSet OriginBlowUp))
            (Inheritance (quotient-origin $d) (IntSet QuotientSingularity))
            (Inheritance (/ (- $d 1) 2) (IntSet ExceptionalDivisorRLCT))))
     (stv 0.5 0.7))
    ((NormalizationQuotient $d) (stv 0.5 0.7)))

;; PLN: gauge collapse at origin creates degenerate fiber
(|~ ((Implication (Inheritance (norm-map 0) (IntSet UndefinedNorm))
       (Inheritance (quotient-sphere $d) (IntSet GaugeCollapse)))
     (stv 0.7 0.8))
    ((NormalizationQuotient $d) (stv 0.5 0.7)))