; DOMAIN: probability/large-deviations [CLOSED, derived 2026-07-24]
; Claim: for iid X_i with finite log-MGF, the sample mean satisfies a large-deviation principle with rate I(x)=sup_t(tx-log E[e^{tX}]) (Cramer).
; Structure: (iid-sequence X_i) (empirical-mean S_n/n) (cumulant-generating Lambda(t)=log E[e^{tX}]).
; Result: P(S_n/n >= x) ~ exp(-n I(x)) for x>E[X]; I is Legendre-Fenchel transform of Lambda, convex, I(E[X])=0.
; Minimal: finite-MGF + iid => exponential-decay of tail probabilities at rate = convex-conjugate of cumulants.
; Bridge: exponential concentration refining martingale/optional-stopping tail control; Legendre duality links to optimal-transport (Kantorovich) convex-conjugacy.
(= (rate-function $x) (legendre (cumulant-gen $x)))