;; S592: NovoGrad / Layer-Wise Gradient Normalization x RLCT - L3 MeTTa Encoding
;; Date: 2026-10-24
;; Author: Oma (OmegaClaw agent)
;; Status: L3 encoding
;; Depends on: s592-novograd-rlct-L0.md, s592-novograd-rlct-L1.md, s592-novograd-rlct-L2-novelty.md

;; --- Type Declarations ---
(= (NovoGrad) Type)
(= (LayerNorm) Type)
(= (GradientNorm) Type)
(= (SingularFiber) Type)
(= (RLCT) Type)
(= (StratumSelector) Type)
(= (GenBound) Type)
(= (PhaseTransition) Type)
(= (Claim) Type)

;; --- D1: Parameter Space and Loss ---
(= (theta) Parameter)
(= (empirical-loss theta) Real)
(= (layer-count M) Integer)
(= (layer-params k) Integer)

;; --- D2: NovoGrad Update Rule ---
(= (grad-norm k theta) (GradientNorm (sqrt (sum_j (grad_k_j theta) (grad_k_j theta)))))
(= (novograd-velocity k t) (+ (* beta (novograd-velocity k (- t 1))) (/ (grad_k t) (grad-norm k t))))
(= (novograd-update k t) (- (theta_k t) (* eta (novograd-velocity k t))))
(= (defined-on (stratum (grad-norm k theta) > 0)) True)

;; --- D3: R_an,exp Definability (C1 PROVEN) ---
(= (c1-novograd-definable) (Claim C1))
(= (exp-definable (grad_k_j theta)) True)
(= (exp-definable (grad-norm k theta)) True)
(= (exp-definable (/ (grad_k theta) (grad-norm k theta))) True)
(= (exp-definable (novograd-velocity k t)) True)

(;- C1: PROVEN - NovoGrad is R_an,exp-definable -;)
(;- (|- ((==> (exp-definable (grad_k_j theta)) (exp-definable (grad-norm k theta))) (stv 1.0 0.95)) ((exp-definable (grad_k_j theta)) (stv 1.0 0.95))) -;)
(;- (|- ((==> (exp-definable (grad-norm k theta)) (exp-definable (/ (grad_k theta) (grad-norm k theta)))) (stv 1.0 0.95)) ((exp-definable (grad-norm k theta)) (stv 1.0 0.95))) -;)
(;- (|- ((==> (exp-definable (/ (grad_k theta) (grad-norm k theta))) (exp-definable (novograd-velocity k t))) (stv 1.0 0.95)) ((exp-definable (/ (grad_k theta) (grad-norm k theta))) (stv 1.0 0.95))) -;)

;; --- D4: Per-Layer Singular Fiber (C2 CONJECTURAL) ---
(= (c2-per-layer-fiber) (Claim C2))
(= (layer-null-locus k) (SingularFiber (set theta (= (grad-norm k theta) 0))))
(= (sigma-novograd) (SingularFiber (union_k (layer-null-locus k))))
(= (codim (layer-null-locus k)) n_k)
(= (adam-codim) 1)

;; C2: CONJECTURAL - per-layer fiber codim n_k >> Adam codim 1
(;- (|~ ((Implication (Inheritance $theta (layer-null-locus k)) (Inheritance $theta (SingularFiber))) (stv 0.6 0.7)) ((Inheritance theta_star (layer-null-locus k)) (stv 1.0 0.7))) -;)

;; --- D5: Layer Norm Ratio as Stratum Selector (C3 CONJECTURAL) ---
(= (c3-norm-ratio-selector) (Claim C3))
(= (layer-norm-vector theta) (Vector (grad-norm 1 theta) (grad-norm M theta)))
(= (bar-g theta) (/ (sum_k (grad-norm k theta)) M))
(= (ratio-vector theta) (Vector (/ (grad-norm 1 theta) (bar-g theta)) (/ (grad-norm M theta) (bar-g theta))))
(= (stratum-selector ratio-vector) (StratumSelector ratio-vector))

;; C3: CONJECTURAL - first-order gradient norm selector, distinct from K-FAC second-order
(;- (|~ ((Implication (< (ratio_k theta) r_star) (active-layer k)) (stv 0.6 0.7)) ((< (ratio_k theta_star) r_star) (stv 1.0 0.7))) -;)

;; --- D6: Generalization Bound (C4 CONJECTURAL) ---
(= (c4-gen-bound) (Claim C4))
(= (lambda-novograd) (RLCT lambda_NovoGrad))
(= (desingularization-map phi) (Map g_k (/ g_k (grad-norm k theta))))
(= (gen-bound-novograd) (GenBound (+ (/ lambda-novograd n) (/ (U-tension (layer-norm-vector theta)) (sqrt n)))))

;; C4: CONJECTURAL - lambda_NovoGrad <= lambda_SGD when uniform
(;- (|~ ((Implication (uniform-layer-norms) (<= lambda-novograd lambda-sgd)) (stv 0.5 0.7)) ((uniform-layer-norms) (stv 1.0 0.7))) -;)

;; --- D7: Phase Transition at r* (C5 CONJECTURAL) ---
(= (c5-phase-transition) (Claim C5))
(= (critical-ratio r_star) Real)
(= (frozen-layer k) (PhaseTransition (> (ratio_k theta) r_star)))
(= (active-layer k) (PhaseTransition (< (ratio_k theta) r_star)))

;; C5: CONJECTURAL - SGLD-detectable kink at r*
(;- (|~ ((Implication (= (ratio_k theta) r_star) (sgld-kink k)) (stv 0.6 0.7)) ((= (ratio_k theta_star) r_star) (stv 1.0 0.7))) -;)

;; --- Caveats ---
;; 1. Homogeneity gap: NovoGrad assumes per-layer gradient norms are meaningful scale proxies.
;; 2. Layer definition ambiguity: what counts as a "layer" affects fiber geometry.
;; 3. EMA beta creates memory: velocity recursion is t-fold composition, not single-step.
;; 4. Codim n_k claim assumes generic loss (non-degenerate gradient within layer).
;; 5. Weight decay (#282) interaction: L2 reg may shift singular locus, changing fiber structure.

;; --- Cross-Refs ---
;; #8 Adam, #100 SGD, #186 RMSProp, #282 Weight Decay, #304 Adam L0-L4,
;; #436 AdaBelief, #485 RLT, #516 K-FAC, #298 Orthogonal Init, #484 ReZero,
;; #420 LayerScale, #559 SAM, #582 Curriculum Learning