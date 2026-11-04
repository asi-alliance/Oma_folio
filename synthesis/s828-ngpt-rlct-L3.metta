;; Synthesis #828: nGPT (Normalized Transformer) × RLCT — L3 MeTTa Encoding
;; Date: 2026-11-03
;; Status: L3 DRAFT

;; === TYPE DECLARATIONS ===
(: NGPT Transformer)
(: ProductOfSpheres Manifold)
(: Hypersphere Manifold)
(: AntipodalMap (-> Parameter Parameter))
(: Z2Action Group)
(: RealProjectiveSpace Manifold)
(: RadialDirection Direction)
(: CurvaturePhaseTransition Phenomenon)

;; === D1: Product-of-Spheres Parameter Space ===
(= (parameter-space NGPT)
   (Product (map S^{d_i-1} i (range 1 M))))
(= (compact-p (parameter-space NGPT)) True)
(= (dimension (parameter-space NGPT)) (- D M))

;; === D2: nGPT Loss Function ===
(= (spherical-attention NGPT)
   (softmax (dot-product (normalize W_Q x) (normalize W_K x))))
(= (ngpt-loss NGPT)
   (cross-entropy (spherical-output NGPT) y))

;; === D3: R_{an,exp}-Definability (C1 PROVEN) ===
(= (sphere-constraint S^{d-1}) (analytic-equation norm-eq-1))
(= (dot-product-analytic) True)
(= (softmax-definable R_{an,exp}) True)
(= (cross-entropy-definable R_{an,exp}) True)

;; === D4: Antipodal Z_2 Singular Fiber ===
(= (antipodal-map tau) (lambda theta (negate theta)))
(= (loss-invariant-p (antipodal-map tau) ngpt-loss) True)

;; === D5: Built-in Desingularization ===
(= (radial-direction-eliminated NGPT) True)
(= (desingularization-savings NGPT) (/ M 2))

;; === D6: Generalization Bound on Compact Manifold ===
(= (gen-bound NGPT) (sqrt (* lambda-nGPT (/ sigma-sq n))))
(= (bounded-loss-p (parameter-space NGPT)) True)

;; === D7: Curvature-Induced Phase Transition ===
(= (curvature S^{d-1}) (/ 1 d))
(= (phase-transition-d-star) (* O (/ 1 (sqrt epsilon))))

;; === C1: PROVEN ===
(|- ((==> (ngpt-loss-is-R-an-exp-definable)
          (RLCT-well-defined ngpt-loss (parameter-space NGPT)))
      (stv 1.0 0.95))
     ((ngpt-loss-is-R-an-exp-definable) (stv 1.0 0.95)))

;; === C2: CONJECTURAL ===
(|- ((==> (pure-dot-product-architecture)
          (RLCT-on-RP-d-1 differs-from (RLCT-on-S-d-1)))
      (stv 0.6 0.7))
     ((pure-dot-product-architecture) (stv 0.5 0.7)))

;; === C3: CONJECTURAL ===
(|- ((==> (sphere-constraint-active)
          (<= lambda-nGPT (- lambda-standard (/ M 2))))
      (stv 0.6 0.75))
     ((sphere-constraint-active) (stv 0.5 0.7)))

;; === C4: CONJECTURAL ===
(|- ((==> (compact-parameter-space)
          (gen-bound-without-weight-decay NGPT))
      (stv 0.6 0.75))
     ((compact-parameter-space) (stv 1.0 0.9)))

;; === C5: CONJECTURAL ===
(|- ((==> (less-than d_eff d-star)
          (lambda-determined-by-sphere-topology))
      (stv 0.5 0.7))
     ((less-than d_eff d-star) (stv 0.5 0.6)))

;; === PLN CHAIN 1 ===
(|~ ((Implication (Inheritance ngpt-loss (IntSet R-an-exp-definable))
                   (Inheritance ngpt-loss (IntSet RLCT-well-defined)))
      (stv 1.0 0.9))
     ((Inheritance ngpt-loss (IntSet R-an-exp-definable)) (stv 1.0 0.95)))

;; === PLN CHAIN 2 ===
(|~ ((Implication (Inheritance (parameter-space NGPT) (IntSet CompactManifold))
                   (Inheritance (parameter-space NGPT) (IntSet Desingularized)))
      (stv 0.7 0.8))
     ((Inheritance (parameter-space NGPT) (IntSet CompactManifold)) (stv 1.0 0.95)))

;; === PLN CHAIN 3 ===
(|~ ((Implication (Inheritance ngpt-loss (IntSet Even-degree-architecture))
                   (Inheritance (parameter-space NGPT) (IntSet Z2-symmetric)))
      (stv 0.7 0.8))
     ((Inheritance ngpt-loss (IntSet Even-degree-architecture)) (stv 0.5 0.7)))

;; === PLN CHAIN 4 ===
(|~ ((Implication (Inheritance (parameter-space NGPT) (IntSet CompactManifold))
                   (Inheritance (gen-bound NGPT) (IntSet Bounded-without-regularization)))
      (stv 0.8 0.85))
     ((Inheritance (parameter-space NGPT) (IntSet CompactManifold)) (stv 1.0 0.95)))

;; === PLN CHAIN 5 ===
(|~ ((Implication (Inheritance (curvature S^{d-1}) (IntSet Non-negligible))
                   (Inheritance (lambda-nGPT) (IntSet Sphere-topology-determined)))
      (stv 0.5 0.7))
     ((Inheritance (curvature S^{d-1}) (IntSet Non-negligible)) (stv 0.5 0.6)))

;; === CAVEATS ===
;; 1. Z_2 symmetry is exact only for pure dot-product (even-degree) terms; bias terms break it.
;; 2. Upper bound lambda-nGPT <= lambda-standard - M/2 assumes radial directions were truly free.
;; 3. Product-of-spheres RLCT may not decompose as sum of per-sphere RLCTs (fiber interaction).
;; 4. Coordinate singularities at poles (tangent space collapse) may add singular fibers.
;; 5. SGLD LLC measurement needed to empirically verify the d* phase transition.

;; === CROSS-REFERENCES ===
;; #8 (ReLU), #219 (GELU), #282 (normalization), #323 (weight decay desingularization),
;; #383 (VAE latent sphere), #421 (LayerScale), #491 (grokking), #501 (weight tying),
;; #620 (RMSNorm), #619 (RMSNorm), #169 (curriculum), #480 (muP), #528 (orthogonal init)
