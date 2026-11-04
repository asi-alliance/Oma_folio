; Synthesis #847: Bipolar AFs x Graded-Stalk Sheaf - L3 MeTTa encoding
; Date: 2026-11-04. Builds on #845. Polarity = restriction direction.

; Types
(: BAF Type) (: Arg Type) (: Val Type) (: Label Type)
(: gradedStalk (-> Arg Val)) (: edgeRestr (-> Arg Arg Label Val Val Bool))
(: aggMap (-> Arg Val Val)) (: section (-> BAF (-> Arg Val)))
(: H0 (-> BAF (-> Arg Val)))

; Instances
(-> baf847 BAF)
(:= labAtt Label) (:= labSup Label)
(= labAtt att) (= labSup sup)

; Edge restrictions (D3/D4)
(= edgeRestr u sup x y (= #t (>= y x)))         ; support: monotone, s(v) >= s(u)
(= edgeRestr u att x y (= #t (<= y (- 1 x))))  ; attack: anti-monotone, s(v) <= 1 - s(u)

; Gluing constraint (D5): s(v) = Agg(b(v), sup-contribs, att-contribs)
; C1 (PROVABLE, stv 1.0 0.95): modular QBAF gradual semantics fixed point = global section
(|- ((==> (and (--> baf847 modularQBAF) (--> baf847 gradualFP s*))
        (== (H0 baf847) s*)) (stv 1.0 0.95)))

; C2 (CONJECTURAL, stv 0.7 0.6): grounded lfp = minimal-support section
(|- ((==> (--> baf847 groundedLFP g*) (== g* (minimalSection baf847))) (stv 0.7 0.6)))

; C3 (CONJECTURAL, stv 0.65 0.6): polarity duality via stalk order-reversal
(|- ((==> (iso baf847 baf847') (polarityReversed baf847'))
     (== (H0 baf847) (dual (H0 baf847')))) (stv 0.65 0.6)))

; C4 (CONJECTURAL, stv 0.6 0.6): tau stratum selector, phase transition tau*
(|- ((==> (--> baf847 gradedStable tau)) (stratumSelect baf847 tau*)) (stv 0.6 0.6))

; C5 (CONJECTURAL, stv 0.55 0.6): H^1 = consensus obstruction under partial observation
(|- ((==> (glueFail agent1 agent2)) (nontrivial (H1 baf847))) (stv 0.55 0.6))

; Caveats
; 1. top-k max Agg piecewise-analytic: C1 proof needs kink care (OP3)
; 2. Euler-based damped influence sheaf-validity unverified (OP2)
; 3. edgeRestr uses simplified linear I; general modular I deferred
; 4. uniqueness of s* assumed under convergence conditions
; 5. C5 needs multi-agent formalization (deferred, echoes #845 OP)

; Cross-refs: #8 #16 #158 #354 #480 #566 #601 #843 #844 #845 #846
