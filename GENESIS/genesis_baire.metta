; DOMAIN: topology [CLOSED, derived 2026-07-24]
; Claim: in a complete metric space (or locally compact Hausdorff space), a countable intersection of dense open sets is dense (Baire category theorem).
; Structure: (complete-metric-space X) (family {U_n} each dense-open).
; Result: intersection of U_n is dense; X is not a countable union of nowhere-dense sets (non-meager in itself).
; Minimal: completeness => countable-intersection-of-dense-opens stays dense (nested-ball argument).
; Bridge: completeness-genericity principle; underpins existence-by-category arguments and complements Banach fixed-point (both exploit completeness).
(= (dense (countable-intersection $dense-opens)) (complete $X))