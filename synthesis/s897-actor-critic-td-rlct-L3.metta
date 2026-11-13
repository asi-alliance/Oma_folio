;; Synthesis #897: Actor-Critic / TD-Learning × RLCT - L3 MeTTa Encoding
;; Date: 2026-11-12 | Author: Oma | Status: L3 (MeTTa encoded, C1 proven, C2-C5 conjectural)

;; === TYPE DECLARATIONS ===
(declare-type ParamSpace)
(declare-type LossFunction)
(declare-type Fiber)
(declare-type Selector)
(declare-type GenBound)
(declare-type PhaseTransition)
(declare-type SingularityClass)
(declare-type JacobianOperator)
(declare-type CouplingTerm)
(declare-type EntropyCoeff)

;; === D1: PARAMETER SPACE ===
(= (param-space-actor-critic d_pi d_V) (ParamSpace R^{d_pi+d_V}))
(= (param-space-shared d_shared d_pi d_V) (ParamSpace R^{d_pi+d_V-d_shared}))
(= (policy-readout theta_pi f_theta s) (softmax (dot theta_pi (f_theta s))))
(= (value-readout phi_V g_phi s) (dot phi_V (g_phi s)))

;; === D2: COMPOSITE ACTOR-CRITIC LOSS ===
(= (td-loss phi gamma data) (LossFunction
  (* (/ 1 N) (sum t (pow (- (+ r_t (* gamma (value-readout phi g_phi s_prime_t)))
                           (value-readout phi g_phi s_t)) 2)))))
(= (ppo-actor-loss theta rho eps data) (LossFunction
  (- (* (/ 1 N) (sum t (min (* (ratio_t theta) (advantage_t))
                            (* (clip (ratio_t theta) (- 1 rho) (+ 1 rho)) (advantage_t)))))
     (* eps (entropy (policy-readout theta_pi f_theta s_t))))))
(= (composite-loss theta phi beta rho eps data) (LossFunction
  (+ (ppo-actor-loss theta rho eps data) (* beta (td-loss phi gamma data)))))
(= (kl-proxy theta phi theta_star phi_star) (- (composite-loss theta phi beta rho eps data)
  (composite-loss theta_star phi_star beta rho eps data)))
(= (fisher-block-structure theta phi) (Matrix [[I_theta_theta I_theta_phi] [I_phi_theta I_phi_phi]]))

;; === D3: R_{an,exp}-DEFINABILITY (C1 PROVEN) ===
(= (softmax-definable) (R_an_exp-definable (exp(w_k)/sum_j exp(w_j))))
(= (squared-affine-definable) (R_an-definable (pow affine 2)))
(= (ratio-definable) (R_an_exp-definable (pi_theta/pi_theta_old)))
(= (clip-piecewise-definable) (R_an_exp-definable (min max)))
(= (entropy-log-definable) (R_an_exp-definable (sum (* pi (log pi)))))
(= (finite-sum-definable) (R_an_exp-definable (sum i (loss-term i))))
(= (composition-closed) (R_an_exp-closed composition))
(= (addition-closed) (R_an_exp-closed addition))

;; === D4: BELLMAN FIXED-POINT SINGULAR FIBER (C2 CONJECTURAL) ===
(= (bellman-fixed-point-fiber) (Fiber
  V_fixed {phi : (kl-proxy-td phi phi_star) = 0}))
(= (bootstrapping-jacobian) (JacobianOperator J = I - gamma * P^pi * J_V))
(= (non-injective-map) (Property phi -> V_phi is non-injective))
(= (self-referential-dependency) (Property V_phi appears in both prediction and target))
(= (slow-mixing-degeneracy) (SingularityClass spectral-gap -> 0 implies J -> singular))
(= (fixed-point-singularity-type) (SingularityClass self-referential-fixed-point))
(= (fiber-dimension-underdetermined) (Fiber dim = d_V - n when d_V > n))
(= (fiber-dimension-overdetermined) (Fiber dim = 0 when d_V <= n))

;; === D5: DISCOUNT GAMMA AS STRATUM SELECTOR (C3 CONJECTURAL) ===
(= (gamma-stratified-family) (Family {V_gamma}_{gamma in [0,1)}))
(= (myopic-regime) (Regime gamma -> 0 regular RLCT = d_V/2))
(= (far-sighted-regime) (Regime gamma -> 1 singular RLCT < d_V/2))
(= (critical-gamma-star) (Selector gamma* = 1/abs(lambda_2(P^pi))))
(= (continuous-selector) (Property smooth-phase-transition in gamma))
(= (spectral-gap-interplay) (Property gamma* depends on MDP spectral gap and J_V rank))

;; === D6: COMPOUND GENERALIZATION BOUND (C4 CONJECTURAL) ===
(= (compound-gen-bound) (GenBound
  (+ (* lambda_theta (/ (log n) (* 2 n)))
     (* lambda_phi (/ (log n) (* 2 n)))
     (* -1 (/ c_coupling 2))
     (/ B_div (sqrt n)))))
(= (coupling-term) (CouplingTerm shared-features + advantage-gradient + on-policy-shift))
(= (coupling-regularization) (Property joint-training reduces effective complexity))
(= (divergence-aware-term) (Complexity B_div ~ tau^{-1} * log(n) / sqrt(n)))
(= (target-network-lag) (Parameter tau = Polyak coefficient))

;; === D7: ENTROPY COEFFICIENT PHASE TRANSITION (C5 CONJECTURAL) ===
(= (entropy-phase-transition) (PhaseTransition
  epsilon* = sup {eps > 0 : clip-boundary-regularizes-policy}))
(= (high-entropy-regime) (Regime eps large regular RLCT = d_pi/2))
(= (low-entropy-regime) (Regime eps small singular RLCT < d_pi/2))
(= (clip-boundary-ridge) (SingularityClass non-smooth-piecewise-ridge))
(= (discontinuous-rlct-change) (Property RLCT drops at epsilon*))

;; === PLN CHAINS ===
;; Chain 1: Definability implies standard RLCT applicability
(|~ ((Implication (R_an_exp-definable L) (RLCT-exists L)) (stv 1.0 0.95))
    ((R_an_exp-definable (composite-loss theta phi beta rho eps data)) (stv 1.0 0.95)))

;; Chain 2: Spectral gap degeneracy implies singular fiber
(|~ ((Implication (--> (slow-mixing MDP) (singular-jacobian J)) (stv 0.6 0.75))
    ((--> (slow-mixing bellman-MDP) (singular-jacobian bootstrapping-jacobian)) (stv 0.6 0.75)))

;; === CAVEATS ===
;; 1. C2: Exact RLCT for fixed-point fiber needs spectral analysis of J = I - gamma*P^pi*J_V
;; 2. C3: Critical gamma* formula heuristic; rigorous derivation needs eigenvalue analysis
;; 3. C4: Coupling term c_coupling qualitative; quantitative estimation needs MI bounds
;; 4. C5: Discontinuity at epsilon* conjectured from PPO clip non-smoothness; SGLD needed
;; 5. Multi-step TD(lambda) may create interpolating fiber family; open problem
