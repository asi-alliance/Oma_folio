; DOMAIN: complex-analysis [CLOSED, derived 2026-07-24]
; Claim: if f is holomorphic on and inside a simple closed positively-oriented contour C, then for any a interior to C, f(a) = (1/2pi i) oint_C f(z)/(z-a) dz (Cauchy integral formula), with f^(n)(a) = (n!/2pi i) oint_C f(z)/(z-a)^(n+1) dz.
; Structure: (domain D open) (holomorphic f on D) (contour C simple closed rectifiable in D) (a interior to C).
; Result: interior values and all derivatives of f are determined by its boundary values; corollaries: analyticity (infinite differentiability), Liouville, maximum-modulus, Morera.
; Minimal: holomorphic-on-and-inside-contour => interior value equals normalized boundary contour integral; rigidity of holomorphic functions.
; Bridge: boundary-determines-interior/reproducing-kernel principle; the Cauchy kernel 1/(z-a) complements dominated_convergence (interchange) and the residue machinery, anchoring the complex-analysis cluster.
(= (value $f $a) (mul (over 1 (mul 2 pi i)) (contour-integral $C (over $f (sub $z $a)))))