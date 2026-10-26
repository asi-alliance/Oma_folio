# Synthesis #620: Grokfast x RLCT - L3 MeTTa Encoding
### Date: 2026-10-25
### Status: L3 MeTTa Encoding

(: GradientSignal Type)
(: FilteredGradient Type)
(: Parameter Type)
(: StepSize Type)
(: EMAParameter Type)
(: AmpFactor Type)
(: RLCT Type)
(: CutoffFreq Type)
(: Stratum Type)
(: Bias Type)

;; D1: Grokfast-EMA update map
(= (grokfast-filter alpha g_hist g_t)
   (+ (* alpha g_hist) (* (- 1 alpha) g_t)))

(= (grokfast-update alpha lambda_amp g_hist g_t theta eta)
   (- theta (* eta (+ g_t (* lambda_amp (grokfast-filter alpha g_hist g_t))))))

;; D2: Gradient spectral decomposition (EMA transfer function)
(= (ema-transfer alpha omega)
   (/ (- 1 alpha) (- 1 (* alpha (cos omega)))))

(= (cutoff-freq alpha)
   (arccos (- 1 (/ (* (- 1 alpha) (- 1 alpha)) (* 2 alpha)))))

(= (slow-gradient alpha g_t g_hist)
   (grokfast-filter alpha g_hist g_t))

(= (fast-gradient alpha g_t g_hist)
   (- g_t (slow-gradient alpha g_t g_hist)))

;; D3: Singular fiber frequency signature
(= (fiber-frequency-signature stratum)
   (SpectralContent (gradient-trajectory stratum)))

(= (along-fiber-freq stratum)
   (LowFreq (fiber-frequency-signature stratum)))

(= (transverse-fiber-freq stratum)
   (HighFreq (fiber-frequency-signature stratum)))

(= (crossing-freq stratum_high stratum_low)
   (MidFreq (fiber-frequency-signature stratum_high stratum_low)))

;; D4: Frequency-domain stratum selector
(= (stratum-selector alpha)
   (FreqCutoff (cutoff-freq alpha)))

(= (selects-stratum alpha omega_cross)
   (if (> (cutoff-freq alpha) omega_cross) CrossingAllowed CrossingBlocked))

(= (effective-rlct alpha lambda_cross)
   (if (> (cutoff-freq alpha) (crossing-freq MemStratum GenStratum))
      lambda_cross
      lambda_mem))

;; Non-conservative dynamics: gradient depends on history
(= (non-conservative grokfast-filter) (stv 1.0 0.9))
(= (non-conservative sgd) (stv 0.0 0.9))

;; D5: Amplification as stratum crossing accelerator
(= (crossing-velocity v_raw v_slow lambda_amp)
   (+ v_raw (* lambda_amp v_slow)))

(= (grokfast-time T_grok v_raw v_slow lambda_amp)
   (/ T_grok (+ 1 (* lambda_amp (/ v_slow v_raw)))))

(= (filter-bias alpha)
   (* (- 1 alpha) (norm-sq g_fast)))

(= (amp-bias lambda_amp)
   (* lambda_amp lambda_amp (norm-sq g_slow)))

(= (total-bias alpha lambda_amp)
   (+ (filter-bias alpha) (amp-bias lambda_amp)))

;; D6: Generalization bound
(= (gen-bound-grokfast lambda_eff alpha lambda_amp n)
   (+ (/ (* lambda_eff (log n)) (* 2 n))
      (/ (total-bias alpha lambda_amp) (sqrt n))))

;; D7: Phase transition at alpha*
(= (optimal-alpha omega_cross)
   (AlphaStar (cutoff-freq (AlphaStar)) omega_cross))

(= (phase-transition-regime alpha alpha_star)
   (if (< alpha alpha_star) CrossingAllowed CrossingBlocked))

(= (llc-drop-time alpha lambda_amp T_grok)
   (grokfast-time T_grok v_raw v_slow lambda_amp))

;; C1 (PROVEN): R_an,exp definability
(|- ((==> (And (Definable (grokfast-filter alpha g_hist g_t))
              (Definable (grokfast-update alpha lambda_amp g_hist g_t theta eta)))
         (R_an_exp (grokfast-trajectory alpha lambda_amp theta_0 eta n))) (stv 1.0 0.95))

;; C2 (CONJECTURAL): Low-pass filter as frequency-domain stratum selector
(|- ((==> (And (< (cutoff-freq alpha) (crossing-freq MemStratum GenStratum))
              (Equal (selects-stratum alpha (crossing-freq MemStratum GenStratum)) CrossingBlocked))
         (StuckInStratum (grokfast-update alpha lambda_amp) MemStratum)) (stv 0.6 0.75))

(|- ((==> (And (> (cutoff-freq alpha) (crossing-freq MemStratum GenStratum))
              (Equal (selects-stratum alpha (crossing-freq MemStratum GenStratum)) CrossingAllowed))
         (CrossesStratum (grokfast-update alpha lambda_amp) GenStratum)) (stv 0.6 0.75))

;; C3 (CONJECTURAL): Grokking acceleration via amplified fiber crossing
(|- ((==> (And (> lambda_amp 0)
              (> (cutoff-freq alpha) (crossing-freq MemStratum GenStratum)))
         (< (grokfast-time T_grok v_raw v_slow lambda_amp) T_grok)) (stv 0.6 0.7))

(|- ((==> (GrokfastOptimizer alpha lambda_amp)
         (EarlierPhaseTransition (llc-drop-time alpha lambda_amp T_grok) T_grok)) (stv 0.5 0.7))

;; C4 (CONJECTURAL): Gradient-space vs parameter-space EMA distinction
(|- ((==> (Equal (ema-domain grokfast) GradientSpace)
         (NonConservative (grokfast-filter alpha))) (stv 1.0 0.9))

(|- ((==> (Equal (ema-domain polyak-ema) ParameterSpace)
         (Conservative polyak-ema)) (stv 1.0 0.9))

(|- ((distinct (non-conservative grokfast-filter) (conservative polyak-ema)) (stv 1.0 0.9))

(|~ ((Implication (And (GradientEMA grokfast) (ParameterEMA polyak))
         (DistinctMechanism grokfast polyak)) (stv 0.6 0.75))

;; C5 (CONJECTURAL): Amplification factor as stratum crossing accelerator
(|- ((==> (And (> lambda_amp 0) (< (cutoff-freq alpha) (crossing-freq MemStratum GenStratum)))
         (StuckInStratum (grokfast-update alpha lambda_amp) MemStratum)) (stv 0.5 0.7))

(|- ((==> (And (> lambda_amp 0) (> (cutoff-freq alpha) (crossing-freq MemStratum GenStratum)))
         (GenBound (gen-bound-grokfast lambda_eff alpha lambda_amp n))) (stv 0.5 0.7))

;; Caveats
;; CV1: "Characteristic frequency of a stratum" is not formally defined — needs spectral theory of singular fibers
;; CV2: Non-conservative dynamics means no single loss landscape describes Grokfast trajectory
;; CV3: Optimal alpha* depends on unknown omega_cross which is architecture-specific
;; CV4: Box filter variant (K-window) may select different strata than EMA — untested
;; CV5: SGLD testability requires measuring LLC during Grokfast training — no empirical validation yet

;; Cross-References
(|- ((related #620 #289)) (stv 1.0 0.9))
(|- ((related #620 #491)) (stv 1.0 0.9))
(|- ((related #620 #525)) (stv 1.0 0.9))
(|- ((related #620 #420)) (stv 1.0 0.9))
(|- ((related #620 #476)) (stv 1.0 0.9))
(|- ((related #620 #606)) (stv 1.0 0.9))
(|- ((related #620 #169)) (stv 1.0 0.9))
(|- ((related #620 #377)) (stv 1.0 0.9))
(|- ((related #620 #553)) (stv 1.0 0.9))
(|- ((related #620 #578)) (stv 1.0 0.9))