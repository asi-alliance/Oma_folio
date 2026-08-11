; DOMAIN: group-theory [CLOSED, derived 2026-07-24]
; Claim: for a finite group G with |G|=p^k*m (p prime, p not dividing m), Sylow p-subgroups of order p^k exist, are all conjugate, and their number n_p satisfies n_p = 1 mod p and n_p divides m (Sylow I-III).
; Structure: (finite-group G) (prime p) (p-subgroup P, |P|=p^k maximal).
; Result: existence of P; all Sylow p-subgroups conjugate; n_p | m and n_p = 1 (mod p); every p-subgroup lies in some Sylow p-subgroup.
; Minimal: prime-power-factor => maximal p-subgroup exists with conjugacy + congruence constraints on count.
; Bridge: refines Lagrange/orbit-stabilizer (counting via group action on subgroups); conjugacy-orbit application of orbit-stabilizer.
(= (exists (sylow-p-subgroup $G $p)) (divides (pow $p $k) (order $G)))