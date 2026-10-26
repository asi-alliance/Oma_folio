# Synthesis #604: One-Cycle LR Policy x RLCT - L3 MeTTa Encoding

### Date: 2026-10-25
### Status: L3 MeTTa Encoding

---

# MeTTa Type Declarations

(: Time Type)
(: Param Type)
(: LR Type)
(: Momentum Type)
(: Ratio Type)
(: Model Type)
(: Loss Type)
(: Fiber Type)
(: RLCT Type)

# MeTTa Atom Declarations

;; D1: One-cycle LR schedule
(= (eta $t $eta_max $T) (* $eta_max (/ (+ 1 (cos (* pi (/ $t $T)))) 2)))

;; D2: Inverse momentum schedule
(= (beta $t $beta_min $beta_max $T) (- $beta_max (* (- $beta_max $beta_min) (/ (+ 1 (cos (* pi (/ $t $T)))) 2))))

;; D3: Momentum-LR ratio (stratum selector)
(= (rho $t $eta_max $beta_min $beta_max $T) (/ (beta $t $beta_min $beta_max $T) (eta $t $eta_max $T)))

;; D4: Time-dependent singular fiber
(= (fiber-V $t $theta) (Set ($theta) (Equals (+ (* (eta $t $eta_max $T) (grad-l $theta)) (momentum-term $t $theta)) 0)))

;; D5: Effective RLCT at time t
(= (lambda-eff $t) (RLCT (fiber-V $t) (fisher-squared)))

;; D6: Stratum commitment phase transition
(= (rho-star) (Sup ($rho) (Equals (topology (fiber-V $t-star)) SingleConnected)))

;; D7: Dual desingularization handoff
(= (handoff $t-star) (And (Equals (rho $t-star) (rho-star)) (SwitchPhase MechanismA MechanismB)))

# Claim Encoding

;; C1 (PROVEN): R_an,exp-definability
(|- ((==> (And (Definable (eta $t)) (Definable (beta $t)) (Definable (grad-l $theta)))
          (R_an_exp (coupled-dynamics $t $theta)))
     (stv 1.0 0.95))

;; C2 (CONJECTURAL): Dual singular fiber dynamics
(|- ((==> (Less (rho $t) (rho-star))
          (MultiStratum (fiber-V $t)))
     (stv 0.7 0.7))

(|- ((==> (Greater (rho $t) (rho-star))
          (SingleStratum (fiber-V $t)))
     (stv 0.7 0.7))

;; C3 (CONJECTURAL): Super-convergence as optimal desingularization
(|~ ((Implication (OneCyclePolicy $pi)
      (Less (lambda-eff $T) (lambda-monotone-decay $T)))
     (stv 0.6 0.7))

;; C4 (CONJECTURAL): rho(t) as monotonic stratum selector
(|~ ((Implication (Monotonic (rho $t))
      (Irreversible (stratum-commitment $t-star)))
     (stv 0.7 0.6))

;; C5 (CONJECTURAL): Lower-RLCT convergence bound
(|~ ((Implication (OneCyclePolicy $pi)
      (<= (GenBound $pi) (+ (/ (lambda-eff $T) $n) (/ (U rho-star) (sqrt $n)))))
     (stv 0.5 0.6))

# PLN Inference Chains

;; Chain 1: Definability -> coupled dynamics in R_an,exp
(|- ((==> (Definable (eta $t)) (R_an_exp (eta $t))) (stv 1.0 0.95))
(|- ((==> (Definable (beta $t)) (R_an_exp (beta $t))) (stv 1.0 0.95))
(|- ((==> (And (R_an_exp (eta $t)) (R_an_exp (beta $t)) (R_an_exp (grad-l $theta)))
          (R_an_exp (coupled-dynamics $t $theta)))
     (stv 1.0 0.85))

;; Chain 2: rho monotonicity -> irreversible commitment
(|- ((==> (MonotonicIncreasing (rho $t)) (OneWay (stratum-path $theta_0 $theta_T))) (stv 0.8 0.7))
(|- ((==> (OneWay (stratum-path $theta_0 $theta_T)) (Irreversible (stratum-commitment $t-star))) (stv 0.7 0.6))

# Caveats
;; 1. t* assumed at T/2 by cosine symmetry; optimal t* may differ
;; 2. rho* depends on singular fiber codimension; not analytically computed
;; 3. Momentum recovery may wash out exploration gains for large beta_max
;; 4. SGLD detectability of t* transition unverified
;; 5. Non-cosine schedules not covered; generalization open

# Cross-References: #213 #386 #410 #242 #526 #88 #239 #143 #58 #100