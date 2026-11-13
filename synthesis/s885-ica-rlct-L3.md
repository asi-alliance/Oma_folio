# Synthesis #885: ICA x RLCT - L3 MeTTa Formalization

Date: 2026-11-09

## MeTTa Expressions

; D1: Parameter Space
; W is unmixing matrix (n x n), sigma is source scale vector
(= (ica-param-space $n) (MatrixSpace $n $n))
(= (ica-source-scale $n) (VectorSpace $n))

; D2: ICA Loss
; L_ICA = (1/m) sum_i [ -log|det(W)| - sum_k log p_k(w_k^T x_i) ]
(= (ica-loss $W $sigma $X)
   (sum-over $X
     (+ (log-abs-det $W)
        (sum-over-sources $W $sigma $X))))

; D3: R_an,exp Definability (C1 PROVEN)
; det(W) polynomial -> |det(W)| subanalytic -> log|det(W)| R_an,exp
; Source densities definable -> finite sum preserves definability
(|- ((==> (ica-analytic-source-density $p)
         (R_an_exp_definable (log-source-density $p)))
    (stv 1.0 0.99))
   ((ica-analytic-source-density logistic-pdf) (stv 1.0 0.99)))

(|- ((==> (R_an_exp_definable (ica-loss $W $sigma $X))
         (rlct-exists-finite (ica-loss $W $sigma $X)))
    (stv 1.0 0.95))
   ((R_an_exp_definable (ica-loss-component $W $sigma $X)) (stv 1.0 0.95)))

; D4: Quotient Singular Fiber (C2 CONJECTURAL)
; V_0 = {theta : exists (P,D) in S_n x (R*)^n s.t. W(theta) = P*D*W_0}
(|- ((==> (ica-non-identifiable $W $W0)
         (exists-permutation-scaling $W $W0))
    (stv 1.0 0.99))
   ((ica-non-identifiable $W $W0) (stv 1.0 0.99)))

(= (exists-permutation-scaling $W $W0)
   (Exists $P $D
     (And (permutation-matrix $P)
          (diagonal-scaling $D)
          (= $W (matmul $P (matmul $D $W0))))))

; Fiber dimension: dim(S_n x (R*)^n) = n (S_n discrete)
(|- ((--> (ica-fiber $W $W0) (quotient-fiber Sn R*_n))
    (stv 1.0 0.95))
   ((ica-fiber-dimension Sn R*_n n) (stv 1.0 0.95)))

; Singular locus: scaling collision stratum
(|- ((==> (scaling-collision $D $i $j)
         (in-singular-locus (ica-fiber $D)))
    (stv 0.9 0.85))
   ((scaling-collision-example) (stv 1.0 0.9)))

; D5: Gaussian Fraction as Stratum Selector (C3 CONJECTURAL)
; g = fraction of Gaussian sources, n_g = count of Gaussian sources
(= (gaussian-fraction $sources) (/ (count-gaussian $sources) (length $sources)))

; At g=0: fiber = S_n x (R*)^n (Darmois-Skitovich holds)
(|- ((==> (= (gaussian-fraction $sources) 0)
         (ica-identifiable-up-to $sources Sn R*_n))
    (stv 1.0 0.99))
   ((darmois-skitovich-holds non-gaussian-sources) (stv 1.0 0.99)))

; At g>=1: O(n_g) rotation enters fiber (Darmois-Skitovich fails)
(|- ((==> (>= (count-gaussian $sources) 1)
         (fiber-contains-rotation (ica-fiber $W $W0) O $n_g))
    (stv 0.85 0.8))
   ((darmois-skitovich-fails gaussian-sources) (stv 1.0 0.99)))

; Fiber dimension jumps by n_g(n_g-1)/2
(|- ((==> (count-gaussian $sources $n_g)
         (= (fiber-dimension-boost $n_g) (/ (* $n_g (- $n_g 1)) 2)))
    (stv 0.85 0.8))
   ((rotation-dimension O_n $n_g) (stv 1.0 0.9)))

; D6: Generalization Bound (C4 CONJECTURAL)
; Gen <= lambda_ICA/n + U(W,sigma)/sqrt(n)
; U = n + n_g(n_g-1)/2
(|- ((==> (ica-rlct $lambda)
         (ica-gen-bound $lambda $n $n_g))
    (stv 0.8 0.75))
   ((ica-rlct-bound) (stv 0.85 0.8)))

(= (ica-gen-bound $lambda $n $n_g)
   (+ (/ $lambda $n)
      (/ (non-identifiability-bias $n $n_g) (sqrt $n))))

(= (non-identifiability-bias $n $n_g)
   (+ $n (/ (* $n_g (- $n_g 1)) 2)))

; D7: Gaussian Threshold Phase Transition (C5 CONJECTURAL)
; lambda_eff(g<1) < lambda_eff(g>=1), discontinuous jump
(|- ((==> (< (gaussian-fraction $sources) 1)
         (< (effective-rlct (ica-loss non-gaussian))
            (effective-rlct (ica-loss with-gaussian))))
    (stv 0.8 0.75))
   ((rlct-jump-at-gaussian-threshold) (stv 0.8 0.7)))

; SGLD signature: staircase pattern as sources become Gaussian
(|- ((==> (sgld-ica $W $sources)
         (staircase-pattern (local-learning-coefficient)))
    (stv 0.75 0.7))
   ((sgld-gaussianity-sweep) (stv 0.7 0.65)))

## Cross-References via MeTTa
(|- ((--> (quotient-fiber Sn R*_n) (synthesis-86-permutation-fiber))
    (stv 0.8 0.7))
   ((cross-ref-86-attention) (stv 1.0 0.9)))

(|- ((--> (quotient-fiber K! Z2_K R_K) (synthesis-91-dictionary-fiber))
    (stv 0.7 0.65))
   ((cross-ref-91-sparse-dict) (stv 1.0 0.9)))

(|- ((--> (inference-time-phase-transition gaussianity) (synthesis-884-cot-transition))
    (stv 0.7 0.65))
   ((cross-ref-884-cot) (stv 1.0 0.9)))

## Status
L3 written 2026-11-09. C1 PROVEN (stv 1.0), C2-C5 CONJECTURAL (stv 0.7-0.85). Next: L4 catalog append.