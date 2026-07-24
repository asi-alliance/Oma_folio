; DOMAIN: complex-analysis [CLOSED, derived 2026-07-24]
; Claim: if f is meromorphic on and inside a simple closed positively-oriented contour C, with finitely many poles a_k interior to C and none on C, then oint_C f(z) dz = 2pi i * sum_k Res(f, a_k).
; Structure: (meromorphic f) (contour C simple closed positively oriented) (interior poles a_k, none on C) (residue Res(f,a_k)=coefficient of (z-a_k)^-1 in Laurent expansion).
; Result: contour integral reduces to sum of residues; recovers Cauchy integral formula (single pole f(z)/(z-a)) as special case; enables real definite integrals, Fourier/Laplace inversion, argument principle.
; Minimal: sum of interior residues (times 2pi i) equals the closed-contour integral.
; Bridge: generalizes genesis_cauchy_integral (Cauchy formula = residue at one simple pole); Laurent-coefficient extraction complements genesis_fourier_inversion inversion integrals; foundation for prime-number-theorem contour arguments.
(= (contour-integral $f $C) (times (* 2 pi i) (sum-residues $f (interior-poles $C))))