; DOMAIN: probability/ergodic [CLOSED, derived 2026-07-24]
; Claim: for a measure-preserving transformation T on a probability space, time averages of an integrable f converge a.e. to a T-invariant limit; if T is ergodic the limit equals the space average E[f] (Birkhoff pointwise ergodic theorem).
; Structure: (probability-space (X,mu)) (measure-preserving T, mu(T^{-1}A)=mu(A)) (integrable f).
; Result: (1/n)sum_{k<n} f(T^k x) -> f*(x) a.e., f* T-invariant, E[f*]=E[f]; ergodic => f* = E[f] const a.e.
; Minimal: measure-preservation + integrability => time-average converges to invariant conditional expectation; ergodicity collapses it to the mean.
; Bridge: time=space average principle; complements Cramer LDP (fluctuations about the ergodic mean) and optional-stopping (long-run averages).
(= (time-average $f $T) (space-average $f))