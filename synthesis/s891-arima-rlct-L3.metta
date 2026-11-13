
;; Type declarations
(: ARIMAPoly (-> Int Real))              ;; AR polynomial Phi(B) coefficients
(: MAPoly (-> Int Real))                 ;; MA polynomial Theta(B) coefficients
(: DifferencingOrder Type)               ;; discrete d in {0,1,2,...}
(: InnovVar Type)                        ;; sigma^2
(: ARIMAParam (-> ARIMAPoly MAPoly InnovVar DifferencingOrder))  ;; w = (Phi, Theta, sigma^2, d)
(: ARIMALoss (-> ARIMAParam Real))       ;; K(w) per-sample NLL
(: UnitRootFiber (-> ARIMAPoly Bool))    ;; Phi has root on |z|=1
(: MACancellation (-> ARIMAPoly MAPoly Bool))  ;; Phi,Theta share common root
(: StratumSelector (-> DifferencingOrder ARIMAParam))  ;; d selects stratum
(: RootCrossing (-> ARIMAPoly Real Bool))  ;; root crosses unit circle

;; D1-D7 atoms
(: D1-ARIMAParam (-> ARIMAPoly MAPoly InnovVar DifferencingOrder))
(: D2-TrueDist (-> ARIMAParam Real))
(: D3-Loss (-> ARIMAParam Real))
(: D4-FisherInfo (-> ARIMAParam Real))
(: D5-SingularSet (-> ARIMAParam Bool))
(: D6-RLCT (-> ARIMAParam Real))
(: D7-GenBound (-> ARIMAParam Real))

;; C1 PROVEN: R_an,exp definability
(|- ((==> (IsARIMAParam $w) (RanExpDefinable (D3-Loss $w))) (stv 1.0 0.95)))

;; C2 CONJECTURAL: Unit root singular fiber RLCT = m/2
(|~ ((Implication (UnitRootFiber (ARIMAPoly-of $w))
                  (= (D6-RLCT $w) (/ (UnitRootCount $w) 2))) (stv 0.55 0.7)))

;; C3 CONJECTURAL: Differencing d as discrete stratum selector, U-shaped
(|~ ((Implication (IsDifferencingOrder $d)
                  (UShaped (D7-GenBound (StratumSelector $d)))) (stv 0.5 0.7)))

;; C4 CONJECTURAL: Root crossing = phase transition
(|~ ((Implication (RootCrossing (ARIMAPoly-of $w) $phi)
                  (PhaseTransition $phi)) (stv 0.55 0.75)))

;; C5 CONJECTURAL: AR-MA cancellation fiber, quartic KL, RLCT 1/2
(|~ ((Implication (MACancellation (ARIMAPoly-of $w) (MAPoly-of $w))
                  (= (D6-RLCT $w) (/ 1 2))) (stv 0.5 0.7)))

;; PLN Chain 1: R_an,exp definability → RLCT well-defined
(|- ((Implication (RanExpDefinable (D3-Loss $w))
                  (WellDefined (D6-RLCT $w))) (stv 1.0 0.9))
    ((IsARIMAParam $w) (stv 1.0 0.95)))

;; PLN Chain 2: Unit root → Fisher degeneracy → singularity
(|- ((Implication (UnitRootFiber (ARIMAPoly-of $w))
                  (FisherDegenerate $w)) (stv 0.8 0.85))
    ((Implication (FisherDegenerate $w)
                  (Singular $w)) (stv 1.0 0.9)))

;; Caveats
;; 1. C1 proven via closure properties: Gaussian density, Toeplitz determinant, differencing operator all R_an,exp
;; 2. C2 lambda_UR=1/2 per root assumes quadratic KL along radial direction — unverified for AR(p>1)
;; 3. C3 U-shape assumes overdifferencing adds 1/2 per excess d — needs finite-sample simulation
;; 4. C4 SGLD kink prediction requires root multiplicity = critical exponent link — unproven
;; 5. C5 quartic KL along cancellation direction assumes symmetric AR+MA second-order cancellation — open

;; Cross-References
;; #883 Kalman Filter (continuous state, Riccati, observability degeneracy)
;; #879 #886 HMM (discrete latent, permutation fiber, temporal)
;; #885 ICA (continuous quotient non-identifiability)
;; #882 Naive Bayes (Gaussian variance collapse)
;; #268 GMM (mixture singularity, no temporal structure)
;; #887 UMAP (graph automorphism fiber)
;; #107 RL policy gradient (Fisher singularity sequential)
;; #69 Markov identifiability
;; #244 Multinomial uniform (tau stratum selector)
;; #251 Neural ODE (continuous dynamics singularity)
