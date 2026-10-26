# Synthesis #606: RMSProp × RLCT - L3 MeTTa Encoding
### Date: 2026-10-25
### Status: L3 MeTTa Encoding

---

# MeTTa Type Declarations

(: Param Type)
(: Grad Type)
(: EMAGrad Type)
(: Metric Type)
(: Step Type)
(: Loss Type)
(: Fiber Type)
(: RLCT Type)
(: FrozenSet Type)
(: Gamma Type)

# MeTTa Atom Declarations

;; D1: Parameter space & update map
(= (rmsprop-update $w $g $E $eta $eps $gamma)
   (- $w (* $eta (hadamard (diag-inv-sqrt $E $eps) $g))))

;; D2: EMA squared gradient (bounded-memory, reversible)
(= (ema-grad $E $g $gamma)
   (+ (* $gamma $E) (* (- 1 $gamma) (hadamard $g $g))))

;; D3: Diagonal preconditioning metric (non-monotonic)
(= (diag-inv-sqrt $E $eps)
   (map ($x) (^ (+ $x $eps) -0.5) $E))

;; D4: Reversible frozen set (non-monotonic membership)
(= (frozen-set-rms $E $tau)
   (filter ($i $e) (< $e $tau) (enumerate $E)))

;; D5: Effective RLCT (gamma-dependent)
(= (lambda-eff-rms $lambda0 $d $gamma $f_eq)
   (* $lambda0 (- 1 (/ $f_eq $d))))

;; D6: Generalization bound (interior optimum gamma*)
(= (gen-bound-rmsprop $lambda0 $d $n $gamma $f_eq $U)
   (+ (/ (lambda-eff-rms $lambda0 $d $gamma $f_eq)
         (* $n (- 1 (/ $f_eq $d))))
      (/ $U (sqrt (* $n (- 1 (/ $f_eq $d)))))))

;; D7: Equilibrium frozen fraction (smooth crossover)
(= (f-eq $gamma $gradstats)
   (* 1 (- 1 (^ (- 1 $gamma) 0.5))))

# Claim Encoding

;; C1 (PROVEN): R_an,exp-definability of RMSProp update
(|- ((==> (And (Definable (rmsprop-update $w $g $E $eta $eps $gamma))
               (Definable (ema-grad $E $g $gamma))
               (Definable (diag-inv-sqrt $E $eps)))
          (R_an_exp (rmsprop-trajectory $w $g $E $eta $eps $gamma)))
     (stv 1.0 0.95))

;; C2 (CONJECTURAL): Reversible stratum selector via EMA
(|- ((==> (And (EMA-Bounded-Memory $E $gamma)
               (NonMonotonic (diag-inv-sqrt $E $eps)))
          (ReversibleStratumSelector (frozen-set-rms $E $tau)))
     (stv 0.6 0.7))

;; C3 (CONJECTURAL): Gamma-mediated lambda_eff tradeoff
(|~ ((Implication (And (Gamma-Tradeoff $gamma)
                        (EquilibriumFrozenFraction $f_eq $gamma))
           (InteriorOptimum $gamma*))
     (stv 0.5 0.7))

;; C4 (CONJECTURAL): Generalization bound with interior optimum
(|~ ((Implication (GenBoundRMSProp $lambda0 $d $n $gamma $f_eq $U)
           (Exists $gamma* (Optimal $gamma* (gen-bound-rmsprop $lambda0 $d $n $gamma* $f_eq $U))))
     (stv 0.55 0.7))

;; C5 (CONJECTURAL): Breathing singularity, no sharp phase transition
(|- ((==> (And (OscillatingFiber (frozen-set-rms $E $tau))
               (SmoothCrossover $gamma))
          (Not (SharpPhaseTransition $t*)))
     (stv 0.5 0.65))

# PLN Chains

;; PLN-1: Definability chain (EMA recursion closure)
(|- ((==> (Definable $g)
          (Definable (hadamard $g $g)))
     (stv 1.0 0.95))
(|- ((==> (And (Definable $E) (Definable (hadamard $g $g)))
          (Definable (ema-grad $E $g $gamma)))
     (stv 1.0 0.9))
(|- ((==> (Definable (ema-grad $E $g $gamma))
          (Definable (diag-inv-sqrt (ema-grad $E $g $gamma) $eps)))
     (stv 1.0 0.9))

;; PLN-2: Reversibility chain (non-monotonic EMA => reversible stratum)
(|- ((==> (NonMonotonic (ema-grad $E $g $gamma))
          (CanUnfreeze (frozen-set-rms $E $tau)))
     (stv 0.6 0.7))
(|- ((==> (CanUnfreeze (frozen-set-rms $E $tau))
          (ReversibleStratumSelector (frozen-set-rms $E $tau)))
     (stv 0.7 0.75))
(|- ((==> (ReversibleStratumSelector (frozen-set-rms $E $tau))
          (Not (MonotonicRankDecrease (fiber-rank (frozen-set-rms $E $tau)))))
     (stv 0.65 0.7))

;; PLN-3: Gamma tradeoff chain
(|- ((==> (Low $gamma) (HighAdaptability $gamma))
     (stv 0.7 0.7))
(|- ((==> (HighAdaptability $gamma) (HighLambdaEff $gamma))
     (stv 0.6 0.65))
(|- ((==> (High $gamma) (LowLambdaEff $gamma))
     (stv 0.7 0.7))
(|- ((==> (And (HighLambdaEff $gamma1) (LowLambdaEff $gamma2))
          (Exists $gamma* (Between $gamma1 $gamma2 $gamma*)))
     (stv 0.5 0.6))

;; PLN-4: Gen bound interior optimum chain
(|- ((==> (DecreasingIn $gamma (lambda-eff-rms $lambda0 $d $gamma $f_eq))
          (IncreasingIn $gamma $U_gamma))
     (stv 0.6 0.65))
(|- ((==> (And (DecreasingIn $gamma lambda_eff)
               (IncreasingIn $gamma U_gamma))
          (InteriorOptimum $gamma*))
     (stv 0.55 0.65))
(|- ((==> (InteriorOptimum $gamma*)
          (OptimalGenBound (gen-bound-rmsprop $lambda0 $d $n $gamma* $f_eq $U)))
     (stv 0.5 0.6))

;; PLN-5: Breathing singularity chain
(|- ((==> (OscillatingFiber (frozen-set-rms $E $tau))
          (BreathingSingularity $gamma))
     (stv 0.5 0.6))
(|- ((==> (BreathingSingularity $gamma)
          (SmoothCrossover $gamma))
     (stv 0.5 0.6))
(|- ((==> (SmoothCrossover $gamma)
          (Not (SharpPhaseTransition $t*)))
     (stv 0.6 0.7))
(|- ((==> (BreathingSingularity $gamma)
          (HighLCVariance (SGLD $gamma)))
     (stv 0.5 0.6))

# Caveats

1. C1 definability proof mirrors Adagrad #605; novelty is singular locus structure, not technique.
2. C2 reversibility assumes stationary gradient statistics; non-stationary may break equilibrium.
3. C3 f_eq ~ 1-(1-gamma)^{1/2} is heuristic, not derived from first principles.
4. C4 U(gamma) ~ C*(1-gamma)^{-1/2} scaling is conjectural; empirical validation needed.
5. C5 breathing singularity is a hypothesis; no formal RLCT computation for oscillating strata exists.
