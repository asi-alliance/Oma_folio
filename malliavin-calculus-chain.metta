;; Malliavin Calculus Chain
;; Domain: stochastic-analysis / calculus-of-variations-on-Wiener-space
;; Built: 2026-09-19 by Oma
;; Confidence decays across hops - honest deep-chain uncertainty
;;
;; Key sources: Nualart (2006), Di Nunno et al. (2009), Malliavin (1978)

;; === Type Declarations ===
(-> malliavin-derivative (Type MalliavinDerivativeOperator))
(-> skorokhod-integral (Type SkorokhodIntegralOperator))
(-> wiener-chaos-decomposition (Type ChaosDecompositionStructure))
(-> clark-ocone-formula (Type RepresentationFormula))
(-> hida-distribution (Type HidaDistributionSpace))
(-> malliavin-sobolev-space (Type SobolevSpaceOverWiener))
(-> divergence-operator (Type DivergenceOperator))
(-> ornstein-uhlenbeck-semigroup (Type SemigroupOperator))
(-> malliavin-covariance-matrix (Type CovarianceMatrixRandom))
(-> integration-by-parts (Type IBPFormula))
(-> wiener-space (Type AbstractWienerSpace))
(-> wick-product (Type WickProductOperation))

;; === Chain Atoms ===
(|- ((--> wiener-space brownian-motion) (stv 0.95 0.90)))
(|- ((--> brownian-motion malliavin-sobolev-space) (stv 0.88 0.85)))
(|- ((--> malliavin-sobolev-space malliavin-derivative) (stv 0.90 0.87)))
(|- ((--> malliavin-derivative integration-by-parts) (stv 0.87 0.83)))
(|- ((--> integration-by-parts skorokhod-integral) (stv 0.85 0.80)))
(|- ((--> skorokhod-integral divergence-operator) (stv 0.83 0.78)))
(|- ((--> divergence-operator wiener-chaos-decomposition) (stv 0.82 0.76)))
(|- ((--> wiener-chaos-decomposition clark-ocone-formula) (stv 0.80 0.75)))
(|- ((--> clark-ocone-formula ornstein-uhlenbeck-semigroup) (stv 0.78 0.72)))
(|- ((--> ornstein-uhlenbeck-semigroup hida-distribution) (stv 0.75 0.69)))
(|- ((--> hida-distribution wick-product) (stv 0.73 0.66)))
(|- ((--> wick-product malliavin-covariance-matrix) (stv 0.70 0.62)))
(|- ((--> malliavin-covariance-matrix hypoellipticity) (stv 0.67 0.58)))

;; === Key Claims ===
;; C1: Wiener space with Gaussian measure. Brownian motion is canonical process. (0.95)
;; C2: Malliavin derivative maps Sobolev space to H-valued RV. Gateaux derivative in Cameron-Martin direction. (0.88)
;; C3: Integration by parts: E[F W(h)] = E[<DF,h>]. Fundamental IBP formula. (0.87)
;; C4: Skorokhod integral extends Ito integral to non-adapted integrands. (0.85)
;; C5: Wiener chaos expansion: L2(mu) = direct sum of H_n, n-fold Ito integrals. (0.82)
;; C6: Clark-Ocone formula: explicit martingale representation via conditional expectation of Malliavin derivative. (0.80)
;; C7: OU semigroup hypercontractivity links to Bakry-Emery CD(1,infinity). (0.78)
;; C8: Hida distributions: white noise formalism, generalized functionals of BM. (0.75)
;; C9: Wick product as renormalized multiplication. Applications in SPDEs and finance. (0.73)
;; C10: Malliavin covariance matrix invertibility implies smooth density - probabilistic proof of Hormander hypoellipticity. (0.67)
;; C11: Cumulative confidence ~0.024 across 13 hops. Chain traverses stochastic-analysis to PDE-regularity.

;; BRIDGES:
;; - ito_calculus (GENESIS): Skorokhod extends Ito; Clark-Ocone gives explicit Ito representation
;; - bakry_emery_gamma_calculus (GENESIS): OU semigroup hypercontractivity is paradigmatic CD(1,infinity) example
;; - distribution_theory (GENESIS): Hida distributions are tempered distributions on white noise space
;; - heat_kernel (GENESIS): hypoellipticity via Malliavin covariance yields smooth heat kernels for degenerate SDEs
;; - rough_paths (folio): signature terms relate to iterated integrals in Wiener chaos
