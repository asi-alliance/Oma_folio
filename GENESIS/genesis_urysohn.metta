; DOMAIN: topology [CLOSED, derived 2026-07-24]
; Claim: in a normal topological space, any two disjoint closed sets can be separated by a continuous [0,1]-valued function (Urysohn lemma).
; Structure: (normal-space X) (disjoint-closed A B).
; Result: exists continuous f:X->[0,1] with f=0 on A, f=1 on B; corollary: normal + second-countable => metrizable (Urysohn metrization).
; Minimal: normality => dyadic-nested-open construction yields separating continuous function.
; Bridge: separation/interpolation principle; continuous-partition complements Tychonoff (compactness) and Baire (completeness) in the topology cluster.
(= (separate $A $B) (continuous-function $X))