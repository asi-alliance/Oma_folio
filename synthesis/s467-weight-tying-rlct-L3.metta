;; Synthesis #467: Weight Tying x RLCT -- L3 MeTTa Encoding
;; Date: 2026-10-25
;; Status: L0 L1 L2 L4 exist, L3 reconstructed from memory
;; Prereq: L1 (s467-weight-tying-rlct-L1.md), L4 summary verified

;; Type Declarations
((); Model)
((); ParameterSpace)
((); SingularFiber)
((); SingularStratum)
((); PermutationGroup)
((); JacobianDualRole)
((); GradientCoupling)
((); PhaseTransition)
((); GeneralizationBound)
((); RLCT)

;; D1: Weight tying constraint E = I (shared input/output embeddings)
(|- ((--> E (TypeOf E SharedEmbedding)) (stv 1.0 0.95))
    ((==> (WeightTying E_in E_out) (= E_in E_out)) (stv 1.0 0.95)))

;; D2: Joint permutation fiber S_V (tied: single S_V, untied: S_V x S_V)
(|- ((--> Fiber_tied (Quotient ParameterSpace S_V)) (stv 1.0 0.9))
    ((--> Fiber_untied (Quotient ParameterSpace (× S_V S_V))) (stv 1.0 0.9))
    ((<= (Dim Fiber_tied) (Dim Fiber_untied)) (stv 1.0 0.9)))

;; D3: Rank deficiency stratum codim (d-r)(V-r)
(|- ((--> Sigma_r (SingularStratum rank_r)) (stv 1.0 0.9))
    ((= (Codim Sigma_r) (* (- d r) (- V r))) (stv 0.0 0.7)))

;; D4: Dual-role Jacobian (E serves both input embedding and output projection)
(|- ((--> J_dual (JacobianDualRole E)) (stv 1.0 0.9))
    ((==> WeightTying (= (PartialE_in Loss) (PartialE_out Loss))) (stv 0.0 0.7)))

;; D5: Gradient coupling dynamics
(|- ((--> GradCouple (GradientCoupling E_in E_out)) (stv 0.0 0.7))
    ((==> WeightTying (= (Nabla_in E) (Nabla_out E))) (stv 0.0 0.7)))

;; D6: Critical V* ~ C*d phase transition
(|- ((--> V_star (PhaseTransition critical_V)) (stv 0.0 0.7))
    ((= V_star (* C d)) (stv 0.0 0.65)))

;; D7: Progressive untying as RLCT phase transition
(|- ((--> Untying alpha (PhaseTransition alpha_star)) (stv 0.0 0.7))
    ((==> (> V V_star) (< (RLCT tied) (RLCT untied))) (stv 0.0 0.65)))

;; C1: R_an,exp definability (PROVEN)
(|~ ((Implication (Inheritance WeightTying (IntSet AlgebraicConstraint))
           (Inheritance (Composition WeightTying analytic_loss) R_an_exp)) (stv 1.0 0.95))
          ((Inheritance WeightTying (IntSet AlgebraicConstraint)) (stv 1.0 0.95)))

;; C2: Joint permutation fiber reduction (CONJECTURAL)
(|~ ((Implication (Inheritance Fiber_tied (Quotient ParameterSpace S_V))
           (<= (Dim Fiber_tied) (/ (* d (- d 1)) 2))) (stv 0.0 0.7))
          ((Inheritance Fiber_tied (Quotient ParameterSpace S_V)) (stv 1.0 0.9)))

;; C3: Rank deficiency stratum selector (CONJECTURAL)
(|~ ((Implication (Inheritance Sigma_r SingularStratum)
           (= (Codim Sigma_r) (* (- d r) (- V r)))) (stv 0.0 0.7))
          ((Inheritance Sigma_r SingularStratum) (stv 0.0 0.65)))

;; C4: Dual-role Jacobian coupling deepens singularity (CONJECTURAL)
(|~ ((Implication (Inheritance J_dual JacobianDualRole)
           (< (RLCT tied) (RLCT untied))) (stv 0.0 0.7))
          ((Inheritance J_dual JacobianDualRole) (stv 0.0 0.65)))

;; C5: Critical V* phase transition (CONJECTURAL)
(|~ ((Implication (Inheritance V_star PhaseTransition)
           (PhaseTransition untying V_star)) (stv 0.0 0.7))
          ((Inheritance V_star PhaseTransition) (stv 0.0 0.65)))

;; Caveats
(;; C1: Assumes Wilkie theorem closure under algebraic constraint composition)
(;; C2: Smaller fiber may create deeper singularities — paradox of tying)
(;; C3: Stratum codim formula assumes transverse intersection — special cases may differ)
(;; C4: Dual-role Jacobian rank deficiency may increase singularity despite fewer params)
(;; C5: V* ~ C*d scaling constant C is model-dependent and data-dependent)

;; Open Problems
(;; OP1: Exact relationship between fiber dim reduction and RLCT deepening)
(;; OP2: When does smaller-fiber-deeper-singularity paradox dominate)
(;; OP3: V* scaling exponent — is V* ~ C*d exact or asymptotic)
(;; OP4: Partial untying RLCT trajectory between tied and untied extremes)
(;; OP5: SGLD detectability of V* phase transition in practice)
(;; OP6: Interaction with weight decay (#282) and grokking (#491))
(;; OP7: Per-layer tying vs full-model tying RLCT comparison)

;; Cross-References
(;; #8: ReLU definability)
(;; #16: Semi-algebraic foundation)
(;; #73: Deep learning RLCT framework)
(;; #86: Attention non-identifiability)
(;; #100: Parameter space geometry)
(;; #223: LoRA rank as selector)
(;; #240: Weight Tying x RLCT (earlier version))
(;; #282: Weight Decay x RLCT)
(;; #467: This synthesis)
(;; #491: Grokking x RLCT)
(;; #586: Model Merging x RLCT)
