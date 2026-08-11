; DOMAIN: real-analysis [CLOSED, derived 2026-07-24]
; Claim: a subset of C(K) (K compact metric) is relatively compact in the sup norm iff it is uniformly bounded and equicontinuous (Arzela-Ascoli).
; Structure: (compact-metric K) (family F in C(K)) (uniform-bound sup|f|<=M) (equicontinuity: forall eps exists delta uniform over F).
; Result: F precompact in (C(K),||.||_inf) <=> uniformly bounded + equicontinuous; every sequence has a uniformly convergent subsequence.
; Minimal: uniform-boundedness + equicontinuity => sequential compactness in sup norm.
; Bridge: compactness-criterion in function space; complements Tychonoff (product compactness) and Banach (completeness/iteration limits live in C(K)).
(= (precompact $F) (and (uniformly-bounded $F) (equicontinuous $F)))