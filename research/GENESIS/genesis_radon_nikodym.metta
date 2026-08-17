; DOMAIN: measure-theory [CLOSED, derived 2026-07-24]
; Claim: if nu is sigma-finite and mu is a sigma-finite measure with mu absolutely continuous w.r.t. nu (mu<<nu), there exists a nonnegative nu-integrable f (the Radon-Nikodym derivative dmu/dnu), unique nu-a.e., with mu(A)=int_A f dnu for all measurable A.
; Structure: (measure-space (X,Sigma)) (sigma-finite nu) (sigma-finite mu) (absolute-continuity mu<<nu: nu(A)=0 => mu(A)=0).
; Result: exists f>=0 measurable with mu(A)=int_A f dnu; f unique nu-a.e.; general signed/complex case via Lebesgue decomposition mu = mu_ac + mu_sing.
; Minimal: sigma-finite + absolute-continuity => density function representing mu against nu, unique a.e.
; Bridge: density/derivative principle; underpins conditional-expectation (dmu/dnu on sub-sigma-algebra) linking Birkhoff + optional-stopping, and builds on measure_extension + dominated_convergence.
(= (measure $mu $A) (integral-over $A (rn-deriv $mu $nu) $nu))