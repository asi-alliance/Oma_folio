; DOMAIN: real-analysis [CLOSED, derived 2026-07-24]
; Claim: if measurable f_n -> f a.e. and |f_n| <= g a.e. with g integrable, then f is integrable and lim int f_n = int f (Lebesgue dominated convergence).
; Structure: (measure-space (X,mu)) (f_n -> f a.e.) (dominating g integrable, |f_n|<=g).
; Result: int|f_n - f| -> 0, hence lim int f_n = int f; limit and integral commute under a single integrable dominator.
; Minimal: pointwise-a.e. convergence + integrable-dominator => L^1 convergence and interchange of limit/integral.
; Bridge: interchange principle; complements measure_extension (Caratheodory construction) and refines Birkhoff (a.e. convergence of averages) in the measure-theory cluster.
(= (lim (integral $f_n)) (integral (lim $f_n)))