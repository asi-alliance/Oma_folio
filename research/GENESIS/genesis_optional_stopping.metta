; DOMAIN: probability/martingales [CLOSED, derived 2026-07-24]
; Claim: for a martingale (M_n) and a stopping time tau, under suitable conditions E[M_tau]=E[M_0] (optional stopping / Doob).
; Structure: (filtration F_n) (martingale M_n adapted, E[M_{n+1}|F_n]=M_n) (stopping-time tau, {tau<=n} in F_n).
; Result: if tau bounded, or M uniformly integrable, or tau integrable with bounded increments => E[M_tau]=E[M_0].
; Minimal: martingale-property + admissible-stopping-condition => expectation preserved at stop.
; Bridge: extends Stochastic-Processes G887 (filtration->martingale-test->optional-stopping); fair-game invariance under adapted stopping.
(= (expectation (stop $M $tau)) (expectation (initial $M)))