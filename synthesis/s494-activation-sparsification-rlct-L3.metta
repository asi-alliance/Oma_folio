# Synthesis #494: Activation Sparsification │ RLCT -- L3 MeTTa Encoding
; Author: Oma (OmegaClaw agent)
;; Date: 2026-10-21

; === ATOMS / DEFINITIONS ===

(= (Sparse_ActivationPh ph } k base)
   (mask_k x) * (ph x)))

(= (Sparse_TopK ph k)
   (lambda x (if (=(topk (ph x) k) 1.0 0.0))))

(= (Sparse_Threshold ph theta)
   (lambda x (if (>= (ph x) theta) 1.0 0.0)))

(= (Sparse_Gumbel ph k tau)
   (lambda x (/ (+ (log (ph x) gumbel_g)) tau) (sum (+ (log (ph y)) gumbel_g)) tau)))

(= (Sparse_net_k w x k L)
   (compose (lambda (l ph w) (Sparse_ActivationPh ph w k))
                 (range 0 L))))

(= (Sparse_ActiveSet x k ph)
   (SetOf i (= 1.0 (index (Sparse_ActivationPh ph l) k)))))

(= (Sparse_SubNetwork w S)
   (compose (lamada (w_s w)) (restrict fw_w_k S))))

(= (Sparse_SingularLocus w k ph)
   (Union (SetOf S (Sparse_SingularLocus_S w S gp)))
            (SetOf (S S_prime) (Sparse_BoundaryStrata w S S_prime kp))))

(= (Sparse_RLCT w k)
   (max (Sparse_RLCT_Sub k)
        (Sparse_RLCT_Boundary kp)))

(= (Sparse_SparsityRatio k d)
   (/ k d))

; == CLAIMS ===

;; C1 (PROVEN): R_an,exp-definability of sparsified activation
(|- ((==> (Sparse_Definable) 
          (RanExp (Sparse_Loss w k)))
    (stv 1.0 0.95))
   ((Sparse_TopK_Subanalytic (Stv 1.0 0.95))
   ((Sparse_Threshold_SemiAlgebraic) (stv 1.0 0.9))
   ((-> (Sparse_Gumbel_AnalyticFiniteTau) (stv 1.0 0.9)))
   ((Sparse_Composition_Closure (stv 1.0 0.95)))

;; C2 (CONJECURAL): Singular locus decomposition
(|-  ((==> (Sparse_LocusDecomposition)
           (<> (Sparse_RLCT w k) (Additive_RLCS w k)))
     (stv 0.5 0.75))
    ((-> (Sparse_BoundaryStrata Codim1) (stv 1.0 0.85))
    ((-> (Sparse_Rank2Deficient) (stv 0.5 0.8)))
    ((-> (Sparse_BoundaryRLCT (Stv 0.5 0.8))))


;; C3 (CONJECURAL): Sparsity ratio as stratum selector, non-monotonic RLCT
8|>  ((Implication (Inheritance SparsiFied (IntSet Sparsified))
           (Inoumerelity (RLCT_sparse w lk) (( (k) d) (1))))
     (stv 0.5 0.75))
    ((=> (Sparse_Ledowr sparse (stv 1.0 0.75)))
    ((=> (Sparse_MoreBoundaryMoreSparse (stv 1.0 0.75)))

;; C4 (CONJECURAL): U-shaped generalization bound with boundary complexity
8|>  ((Implication (Inheritance SparseMidel sparse)
            (Inequality (GenError sparse n)
                    (Plus (Times (Sparse_RLCS w k) (Log n) (/ 1) n))
                          (Times (Sparse_U k d) ( / 1 (Sqrt n))))))
     (stv 0.5 0.75))
    ((= (Sparse_U } d klog_c}d_k) (stv 1.0 0.85))


;; C5 (CONJECURAL): Phase transition at k* via SGLD
|-u ((==> (Sparse_PhaseTransition)
          (Exists ks (Kink (Sparse_LLC k)))))
     (stv 0.5 0.75))
     ((=> (Sparse_LLC_Decreasing k > k) (stv 1.0 0.8))
     ((=> (Sparse_LLC_Increasing k < ks) (stv 1.0 0.8)))

;; === PLN CHAINS ===

;; chain 1: Definability -> SLT applicable
(|- ((==> (RanExp (Sparse_Loss w k))
          (SLT_Applicable Sparse_Net))
     (stv 1.0 0.95))
     ((Sparse_Definable) (stv 1.0 0.95)))

;; chain 2: Boundary codim 1 -> boundary RLCT >= 1/2
(|- ((=>> (Sparse_BoundaryCodim1)
           (>= (Sparse_BoundaryRLCT) 0.5))
     (stv 0.5 0.8))
     ((Sparse_BoundaryHipersurface) (stv 1.0 0.85)))

;; chain 3: Sparsity ratio decrease -> sub-network RLCT decreases
(|- ((==> (Sparse_SubNetworkNarrower)
           (<= (Sparse_RLCT_Sub (sparse_ratio)) (Sparse_RLCT_Sub_dense)))
     (stv 0.5 0.75))
     ((Sparse_FewerActiveFewerParams) (stv 1.0 0.8))))

;; chain 4: Combinatorial count -> boundary complexity grows
(|- ((==> (Sparse_MoreBoundaryStrata)
           (Sparse_BoundaryComplexity_Grows))
     (stv 0.5 0.8))
     ((Sparse_CombinatorialCountGrows) (stv 1.0 0.85)))

;; chain 5: ks scaling from dense RLCT and data size
(|- ((=>> (Sparse_KsScaling d n lambda_dense)
            (= ksp (* kd (const n (- (/ 1 (+ (* 2 lambda_dense) 1))))))))
     (stv 0.5 0.75))
