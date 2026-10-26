# Synthesis #605: Adagrad × RLCT - L3 MeTTa Encoding
### Date: 2026-10-25
### Status: L3 MeTTa Encoding

---

# MeTTa Type Declarations

(: Param Type)
(: Grad Type)
(: CumGrad Type)
(: Metric Type)
(: Step Type)
(: Loss Type)
(: Fiber Type)
(: RLCT Type)
(: FrozenSet Type)
(: Ratio Type)

# MeTTa Atom Declarations

;; D1: Parameter space & update map
(= (adagrad-update $w $g $G $eta $eps)
   (- $w (* $eta (hadamard (diag-inv-sqrt $G $eps) $g))))

;; D2: Cumulative squared gradient (monotonic)
(= (cum-grad $G $g) (+ $G (hadamard $g $g)))

;; D3: Diagonal preconditioning metric
(= (diag-inv-sqrt $G $eps)
   (map ($x) (^ (+ $x $eps) -0.5) $G))

;; D4: Frozen set (monotonic, irreversible)
(= (frozen-set $G $tau)
   (filter ($i $g) (> $g $tau) (enumerate $G)))

;; D5: Effective RLCT after freezing
(= (lambda-eff $lambda0 $d $G $tau)
   (* $lambda0 (/ (- $d (size (frozen-set $G $tau))) $d)))

;; D6: Generalization bound
(= (gen-bound-adagrad $lambda0 $d $n $G $tau $U)
   (+ (/ (lambda-eff $lambda0 $d $G $tau)
         (* $n (/ (- $d (size (frozen-set $G $tau))) $d)))
      (/ $U (sqrt (* $n (/ (- $d (size (frozen-set $G $tau))) $d))))))

;; D7: Phase transition critical step
(= (t-star $n $lambda0)
   (^ $n (/ 1 (+ $lambda0 1))))

# Claim Encoding

;; C1 (PROVEN): R_an,exp-definability of Adagrad update
(|- ((==> (And (Definable (adagrad-update $w $g $G $eta $eps))
               (Definable (cum-grad $G $g))
               (Definable (diag-inv-sqrt $G $eps)))
          (R_an_exp (adagrad-trajectory $w $g $G $eta $eps)))
     (stv 1.0 0.95))

;; C2 (CONJECTURAL): Time-dependent degenerate Fisher fiber via irreversible freezing
(|- ((==> (Monotonic (cum-grad $G $g))
          (DegenerateFiber (frozen-set $G $tau)))
     (stv 0.6 0.7))

(|- ((==> (Greater (size (frozen-set $G $tau)) 0)
          (RankDeficient (Fisher-eff (frozen-set $G $tau))))
     (stv 0.6 0.7))

;; C3 (CONJECTURAL): Diagonal metric as monotonic stratum selector
(|- ((==> (Monotonic (diag-inv-sqrt $G $eps))
          (StratumSelector (diag-inv-sqrt $G $eps)))
     (stv 0.5 0.7))

;; C4 (CONJECTURAL): Generalization bound with lambda_eff / n_eff tension
(|~ ((Implication (AdagradOptimizer $opt)
                  (GenBound (gen-bound-adagrad $lambda0 $d $n $G $tau $U)))
     (stv 0.5 0.7))

;; C5 (CONJECTURAL): Phase transition at t* with SGLD-testable kink
(|- ((==> (And (Greater $t (t-star $n $lambda0))
               (Greater (size (frozen-set $G $tau)) (/ $d 2)))
          (CoordinateDescent (adagrad-update $w $g $G $eta $eps)))
     (stv 0.6 0.7))

# Caveats

;; Caveat 1: epsilon > 0 required for definability at G=0
;; Without epsilon, (G+eps)^{-1/2} is non-analytic at G=0.
;; epsilon ensures R_an,exp definability but introduces numerical artifact.

;; Caveat 2: lambda_eff linear scaling is conjectural.
;; Actual scaling depends on singularity structure of the frozen stratum.
;; Non-generic singularities may have nonlinear RLCT-dimension relationship.

;; Caveat 3: t* formula is heuristic, derived from generic singularity scaling.
;; Specific architectures may have different critical step scaling.

;; Caveat 4: SGLD kink prediction assumes LC is measurable at each step.
;; In practice, SGLD requires thermal equilibrium which may not hold mid-training.

;; Caveat 5: Frozen set threshold tau(t) is not uniquely defined.
;; Different threshold choices yield different S_t and thus different lambda_eff.

# Cross-References

;; #289/#304: Adam (bias correction prevents freezing - KEY CONTRAST)
;; #433: Weight Decay (modifies variety, not optimizer metric)
;; #516: K-FAC/Shampoo (full-matrix preconditioning, no accumulation history)
;; #604: One-Cycle LR (schedule-based stratum selector)
;; #533/#553: Gradient Accumulation (intersection zero-loss set)
;; #569: Gradient Penalty (input-space Jacobian singularity)
;; #578: Gradient Surgery/PCGrad (non-conservative gradient field)
;; #298/#528: Orthogonal Initialization (Stiefel manifold)
;; #415: Muon (O(d) projection)
;; #316: One-Cycle LR (cycling schedule)
;; #354: SGD (vanilla baseline for comparison)

