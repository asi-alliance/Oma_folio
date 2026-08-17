; DOMAIN: functional-analysis [CLOSED, derived 2026-07-24]
; Claim: a bounded linear functional on a subspace of a normed space extends to the whole space preserving its norm (Hahn-Banach).
; Structure: (normed-space X) (subspace Y<=X) (bounded-functional f on Y, |f|<=p sublinear).
; Result: exists F on X with F|Y=f and ||F||=||f||; corollaries: separation of convex sets, nontrivial dual X* separates points.
; Minimal: dominated-by-sublinear + one-dim-extension + Zorn => norm-preserving global extension.
; Bridge: extension/duality principle; supplies the dual functionals underpinning spectral-theorem and optimal-transport (Kantorovich) duality.
(= (extends $f $X) (norm-preserving $f))