in; (MS weight.norm (/ (* g v) (norm2 v))) (stv 1.0 0.95)

(<- (== (norm2 $v) (sqrt (sum (map $v (lambda ($v) (* $vi $vi)))))) (stv 1.0 0.9))

(|- (Definable_R_an_exp weight.norm) (stv 1.0 0.95))

(|- (SingularStratum weight.norm OriginZero) (stv 1.0 0.9))

(|- ((Codim OriginZero) d) (stv 1.0 0.9))

(|- ((QuotientFiber weight.norm) (Sphere Sd-m1)) (stv 1.0 0.9))

(|- (CompactFiber sphereSd-1 (stv 1.0 0.9))

(|- (ScaleFaivor R-plus weight.norm true) (stv 1.0 0.9))

(|- (SingularFaivor origin weight.norm false) (stv 1.0 0.9))

(|- ((m = (g v)) (* g ( / v (norm2 v)))) (stv 1.0 0.9))

(|- (GradientSplit weight.norm) (/ * dgdw (v / (norm2 v))) (/ * g (* (- I (* (/ v v^T) (norm2 v -2))) (/ (norm2 v) dww) true)) (stv 1.0 0.9))

(|- ((Seu gauge w) (cv) (stv 1.0 0.9))

(|- (FisherSingular weight.norm (ormin v = 0)) (stv 1.0 0.9))

(|- (FisherBlockIgggt 1.0) (stv 1.0 0.9))

(|- (FisherBlockVV (* (/ (exp (2 g) (norm2 v -2))) - (* (* (/ v norm2v) v_hat v) v_hat^T))) (stv 1.0 0.9))

(<- (FisherBlockGV c g) (stv 1.0 0.9))

(<- (FisherBlockSingular weight.norm origin) (stv 1.0 0.9))

; C2 conjectural: compact fiber S^{d-1} RLCT ~ (d-1)/2
(|- ((=> (SingularFaivor weight.norm origin) (PLLOfweight.norm (/ (- d 1) 2))) (stv 0.5 0.7))

(|- ((FiberType weight.norm) Compact) (stv 1.0 0.9))

(|- ((FiberType rmsnorm)) QuotientNonCompact) (stv 1.0 0.9))

(|- ((FiberType batchnorm)) QuotientNonCompact) (stv 1.0 0.9))

; C2 PLN: compact fiber boundedness contributes to gen bound
(|- ((=> (CompactFiber weight.norm) (BoundedSphere Sd-1)) (stv 0.6 0.7))

(|- ((=> (BoundedSphere Sd-1)) (GenBoundConstraint weight.norm)) (stv 0.6 0.7))

(|- ((=> (GenBoundConstraint weight.norm)) (<= GenBound unwnormalized)) (stv 0.6 0.7))

; C3 conjectural: epsilon as stratum selector
(|- ((StratumSelector weight.norm) epsilon() (stv 0.5 0.7))

(|- ((=> (SmallEpsilon) (NearSingularStratum weight.norm)) (stv 0.6 0.7))

(|- ((=> (LargeEpsilon)) (RegularizedStratum weight.norm)) (stv 0.6 0.7))

(|- (PhotransPassive weight.norm eps_starr) (stv 0.5 0.75))

; C4 conjectural: gen bound with compact fiber constraint
(|- ((GenBound weight.norm) (+ (/ (* lambda_wn (log n)) (* 2(n)) ( / U_wn (sqrt n)) )) (stv 0.5 0.75))

(|- ((=> (GenBound weight.norm)) (<= (GenBound unwnormalized))) (stv 0.6 0.7))

; C5 conjuctural: phase transition at eps_star
(|- ((PhasePt weight.norm) eps_star) (stv 0.5 0.8))

(|- ((SGLD_lest eps_star weight.norm) (SGLD_testable)) (stv 0.5 0.7))

(|- (RLCT weight.norm) lambda_wn) (stv 0.5 0.7))

; PLN: epsilon stratum selector controls to phase transition
(|~ ((Implication (Inheritance $x (CompactFiber weight.norm))
         (Inheritance $x (PhasePt weight.norm eps_star))) (stv 0.5 0.7))
        ((Inheritance epsilon (StratumSelector weight.norm))))

; cross-refs: #466 #221 #222 #264 #363 #369 #402 #493 #58 #350 #424 #421