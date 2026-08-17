; DOMAIN: real-analysis [CLOSED, derived 2026-07-24]
; Claim: a contraction on a complete metric space has a unique fixed point, reached by iteration (Banach fixed-point).
; Structure: (complete-metric-space X d) (map f) (contraction-constant k, 0<=k<1, d(fx,fy)<=k*d(x,y)).
; Result: exists unique x* with f(x*)=x*; iterates x_{n+1}=f(x_n) converge; d(x_n,x*)<=k^n/(1-k)*d(x1,x0).
; Minimal: completeness + contraction => unique attracting fixed point (constructive, with error bound).
; Bridge: quantitative/metric counterpart to Knaster-Tarski (order) and fixpoint_domain (Scott); adds convergence rate.
(= (fixpoint $f) (limit (iterate $f)))