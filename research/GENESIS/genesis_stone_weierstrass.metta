; DOMAIN: topology/analysis [CLOSED, derived 2026-07-24]
; Claim: a subalgebra A of C(K,R) (K compact Hausdorff) that separates points and contains the constants is dense in the sup norm (Stone-Weierstrass).
; Structure: (compact-Hausdorff K) (subalgebra A of C(K,R)) (separates-points A) (contains-constants A).
; Result: closure of A = C(K,R); corollary: polynomials are dense in C([a,b]) (classical Weierstrass); complex form needs conjugation-closure.
; Minimal: point-separating unital subalgebra => uniform approximation of every continuous function.
; Bridge: density/approximation principle; complements Arzela-Ascoli (compactness in C(K)) and Hahn-Banach (dual separation) in the C(K) cluster.
(= (dense $A (cont $K)) (and (subalgebra $A) (separates-points $A) (contains-constants $A)))