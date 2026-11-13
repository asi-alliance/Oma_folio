(; Type Declarations
(declare-type PerceptualLoss)
(declare-type FeatureExtractor)
(declare-type SingularFiber)
(declare-type StratumSelector)
(declare-type FiberEnlargingMap)
(declare-type GeneralizationBound)
(declare-type PhaseTransition)
(declare-type RLCT)
(declare-type Depth)
(declare-type Discriminability)

; D1-D7 Atoms
(= (D1 parameter-space) (Theta subset R^d params of f_theta phi frozen external))
(= (D2 perceptual-loss) (L_perceptual theta = ||phi(f_theta(x)) - phi(y)||^2))
(= (D3 definability) (phi ReLU CNN piecewise-poly ||.^2 poly composition-in-Ran-exp))
(= (D4 singular-fiber) (V_perceptual = {theta : phi(f_theta(x)) = phi(y)} V_pixel subset V_perceptual))
(= (D5 depth-stratum-selector) (phi_l layer-l lambda_l depth-as-stratum))
(= (D6 gen-bound) (Gen_perceptual = lambda_perceptual log(n)/2n + U/sqrt(n)))
(= (D7 phase-transition) (U-shaped lambda(l) optimal-depth l-star))

; C1 PROVEN
(|- ((==> (&& (IsA phi ReLU-CNN) (IsA L_perceptual R-an-exp)) (Exists RLCT finite)) (stv 1.0 0.95)))

; C2 CONJECTURAL
(|- ((==> (IsManyToOne phi) (ProperSuperset V_perceptual V_pixel)) (stv 0.7 0.8)))
(|- ((==> (JacobianRankDrop phi theta) (Exists new-singularity V_perceptual)) (stv 0.6 0.75)))

; C3 CONJECTURAL
(|- ((==> (IsA depth-l Depth) (= lambda_l (RLCT phi_l)) (StratumSelector depth-l)) (stv 0.65 0.75)))

; C4 CONJECTURAL
(|- ((==> (SufficientDiscriminability phi) (<= lambda_perceptual lambda_pixel)) (stv 0.6 0.7)))

; C5 CONJECTURAL
(|- ((==> (Exists l-star) (Min lambda_l)) (PhaseTransition l-star)) (stv 0.55 0.7)))

; PLN Chains
(|~ ((Implication (IsA phi FiberEnlargingMap) (ProperSuperset V_perceptual V_pixel))
     (Implication (ProperSuperset V_perceptual V_pixel) (<= lambda_perceptual lambda_pixel)))
    (stv 0.6 0.7))

; Caveats
; 1. phi Jacobian rank drop may create new singularities
; 2. Exact lambda_l computation for VGG-16 layers open
; 3. Multi-scale perceptual loss RLCT composition unknown
; 4. Discriminability threshold for C4 not quantified
; 5. SGLD testability of U-shaped lambda(l) unverified

; Cross-References
(= (cross-ref #8) foundational-RLCT)
(= (cross-ref #16) SGD-dynamics)
(= (cross-ref #73) loss-landscape)
(= (cross-ref #303) skip-connections-internal-vs-external)
(= (cross-ref #58) feature-learning)
(= (cross-ref #169) optimization-landscape)
(= (cross-ref #350) normalization-fiber-geometry)
(= (cross-ref #201) temperature-scaling)
(= (cross-ref #265) regularization)