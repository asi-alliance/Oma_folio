; DOMAIN: functional-analysis [CLOSED, derived 2026-07-24]
; Claim: a bounded surjective linear operator T between Banach spaces is open (maps open sets to open sets); the Open Mapping Theorem.
; Structure: (banach X) (banach Y) (bounded-linear T: X->Y) (surjective T).
; Result: T open; corollaries: Bounded Inverse Theorem (bijective bounded T has bounded inverse) and Closed Graph Theorem.
; Minimal: bounded-linear + surjective between Banach spaces => open map, via Baire category on the completeness of Y.
; Bridge: completeness-to-openness principle; rests on genesis_baire (category) and complements genesis_hahn_banach (extension/duality) in the functional-analysis cluster.
(= (open-map $T) (and (bounded-linear $T) (surjective $T) (banach-domain $T) (banach-codomain $T)))