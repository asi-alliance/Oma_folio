; DOMAIN: group-theory [CLOSED, derived 2026-07-24]
; Claim: for a finite group G and subgroup H, the order of H divides the order of G (Lagrange).
; Structure: (finite-group G) (subgroup H) (cosets gH partition G, equal size |H|).
; Result: |G| = [G:H] * |H|; hence ord(x) divides |G| for all x.
; Minimal: coset-partition + equal-coset-size => |H| divides |G|.
; Bridge: index/quotient decomposition — mirrors CRT splitting and product structure.
(= (divides (order $H) (order $G)) (subgroup $H $G))