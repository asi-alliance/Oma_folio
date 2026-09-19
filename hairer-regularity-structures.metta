;; Hairer Regularity Structures Chain
;; Domain: stochastic-analysis / singular-SPDEs
;; Built: 2026-09-19 by Oma
;; Martin Hairer (2014): regularity structures give meaning to ill-defined stochastic PDEs

;; === Type Declarations ===
(-> regularity-structure (Type HairerRS))
(-> model (Type ModelDistribution))
(-> reconstruction-operator (Type ReconstructionTheorem))
(-> renormalization-group (Type BHZRenormalization))
(-> paracontrolled-distribution (Type GIPParacontrolled))
(-> stochastic-pde (Type SingularSPDE))
(-> multilevel-schauder (Type SchauderEstimate))
(-> abstract-wiener-space (Type WienerSpace))
(-> fixed-point-map (Type LipschitzFixedPoint))
(-> renormalization-scheme (Type RenormalizationScheme))
(-> bony-paraproduct (Type ParaproductDecomp))
(-> structure-group (Type StructureGroup))
(-> canonical-model (Type CanonicalModel))

;; === Chain Atoms ===
(|- ((--> stochastic-pde regularity-structure) (stv 0.95 0.90)))
(|- ((--> regularity-structure model) (stv 0.92 0.87)))
(|- ((--> model reconstruction-operator) (stv 0.90 0.85)))
(|- ((--> reconstruction-operator multilevel-schauder) (stv 0.88 0.82)))
(|- ((--> multilevel-schauder fixed-point-map) (stv 0.85 0.79)))
(|- ((--> fixed-point-map abstract-wiener-space) (stv 0.83 0.75)))
(|- ((--> abstract-wiener-space canonical-model) (stv 0.80 0.72)))
(|- ((--> canonical-model renormalization-group) (stv 0.78 0.69)))
(|- ((--> renormalization-group structure-group) (stv 0.75 0.66)))
(|- ((--> structure-group bony-paraproduct) (stv 0.73 0.63)))
(|- ((--> bony-paraproduct paracontrolled-distribution) (stv 0.70 0.60)))
(|- ((--> paracontrolled-distribution renormalization-scheme) (stv 0.67 0.57)))
(|- ((--> renormalization-scheme stochastic-pde) (stv 0.64 0.53)))

;; === Key Claims ===
;; C1: Sub-critical SPDE admits regularity structure with model space, structure group, and model. (0.95)
;; C2: Model assigns concrete distributions to abstract symbols locally consistently. (0.92)
;; C3: Reconstruction theorem lifts modelled distributions to genuine distributions. (0.90)
;; C4: Multilevel Schauder estimates control regularity of reconstruction. (0.88)
;; C5: Fixed point map on modelled distributions is locally Lipschitz under sub-criticality. (0.85)
;; C6: Abstract Wiener space provides canonical model for Gaussian driving noise. (0.83)
;; C7: Canonical model needs renormalization: divergent trees removed via BHZ scheme. (0.80)
;; C8: Bruned-Hairer-Zambotti renormalization group acts on structure via Hopf algebra. (0.78)
;; C9: Structure group encodes Taylor-like local transformations between models. (0.75)
;; C10: Bony paraproduct decomposes products into coherent + remainder paracontrolled terms. (0.73)
;; C11: Paracontrolled distributions (Gubinelli-Imkeller-Perkowski) give alternative to RS for sub-critical SPDE. (0.70)
;; C12: Renormalization scheme ensures convergence of canonical model to renormalized model. (0.67)
;; C13: Cumulative confidence across 13 hops. Chain closes loop from SPDE back to SPDE via renormalized solution.

;; BRIDGES:
;; - rough-paths-theory (folio): Hairer RS unifies rough paths with Taylor expansion; Lyons extension analogous to reconstruction
;; - ito_calculus (GENESIS): Canonical model built from Ito noise; renormalization removes Ito-Langevin divergence
;; - malliavin-calculus-chain (folio): Wiener chaos expansion feeds canonical model construction
;; - heat_kernel (GENESIS): Schauder estimates use heat kernel semigroup; RS fundamental solutions
;; - elliptic_regularity (GENESIS): Sub-criticality condition connects to elliptic regularity scale