;; Rough Paths Theory Chain
;; Domain: stochastic-analysis / controlled-rough-differential-equations
;; Built: 2026-09-19 by Oma
;; Terry Lyons (1998): signature captures path information up to tree-like equivalence

;; === Type Declarations ===
(-> rough-path (Type GeometricRoughPath))
(-> signature-transform (Type SignatureMap))
(-> iterated-integral (Type IteratedIntegralTensor))
(-> tensor-algebra (Type FreeTensorAlgebra))
(-> path-lift (Type LiftOperation))
(-> enhanced-brownian-motion (Type EnhancedBM))
(-> signature-kernel (Type UniversalKernel))
(-> lyons-extension-theorem (Type ExtensionTheorem))
(-> controlled-differential (Type ControlledODE))
(-> rough-integral (Type RoughIntegration))
(-> young-integral (Type YoungIntegration))
(-> variation-norm (Type PVariationNorm))
(-> geometric-rough-path (Type LevelPPath))

;; === Chain Atoms ===
(|- ((--> continuous-path tensor-algebra) (stv 0.95 0.90)))
(|- ((--> tensor-algebra iterated-integral) (stv 0.92 0.87)))
(|- ((--> iterated-integral signature-transform) (stv 0.90 0.85)))
(|- ((--> signature-transform path-lift) (stv 0.88 0.82)))
(|- ((--> path-lift enhanced-brownian-motion) (stv 0.85 0.79)))
(|- ((--> enhanced-brownian-motion controlled-differential) (stv 0.83 0.75)))
(|- ((--> controlled-differential rough-integral) (stv 0.80 0.72)))
(|- ((--> rough-integral young-integral) (stv 0.78 0.69)))
(|- ((--> young-integral variation-norm) (stv 0.75 0.66)))
(|- ((--> variation-norm geometric-rough-path) (stv 0.73 0.63)))
(|- ((--> geometric-rough-path lyons-extension-theorem) (stv 0.70 0.60)))
(|- ((--> lyons-extension-theorem signature-kernel) (stv 0.67 0.57)))
(|- ((--> signature-kernel universal-feature-map) (stv 0.64 0.53)))

;; === Key Claims ===
;; C1: Continuous path of bounded p-variation embeds into tensor algebra via iterated integrals. (0.95)
;; C2: k-th iterated integral S^k is tensor-valued. (0.92)
;; C3: Signature S(x) = (1, S^1, S^2, ...) lives in tensor algebra. Uniqueness up to tree-like equivalence. (0.90)
;; C4: Path lift extends p-rough path to full signature via Lyons extension theorem. (0.88)
;; C5: Enhanced BM = (B_t, B_t^2) where B^2 is Ito correction. Lifting BM to geometric rough path. (0.85)
;; C6: Controlled differential dY = f(X) dX solved via Gubinelli construction. (0.83)
;; C7: Rough integral extends Young integral from p<1 to p<2 and beyond. (0.80)
;; C8: Young integral: int f dg defined for p-variation paths with 1/p+1/q>1. Rough paths breaks this barrier. (0.78)
;; C9: p-variation norm controls signature growth. (0.75)
;; C10: Geometric rough path = path in free nilpotent group G^N of step N = floor(p). (0.73)
;; C11: Lyons extension: any p-rough path extends uniquely to signature in tensor algebra. (0.70)
;; C12: Signature kernel is universal: dense in C(paths). (0.67)
;; C13: Cumulative confidence across 13 hops. Chain traverses path analysis to ML representation theory.

;; BRIDGES:
;; - ito_calculus (GENESIS): Enhanced BM uses Ito correction as second level
;; - malliavin-calculus-chain (folio): Signature terms relate to Wiener chaos iterated integrals
;; - bakry_emery_gamma_calculus (GENESIS): Rough paths on Riemannian manifolds via gamma calculus
;; - heat_kernel (GENESIS): Rough DE solutions yield heat kernel estimates for hypoelliptic operators
;; - elliptic_regularity (GENESIS): Path-level regularity connects to PDE solution regularity