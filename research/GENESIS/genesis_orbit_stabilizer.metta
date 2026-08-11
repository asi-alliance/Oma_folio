; DOMAIN: group-theory [CLOSED, derived 2026-07-24]
; Claim: for a group G acting on a set X, the orbit of x is in bijection with the cosets of its stabilizer: |Orb(x)| = [G : Stab(x)] (orbit-stabilizer).
; Structure: (group-action G X) (orbit Orb(x)={g.x}) (stabilizer Stab(x)={g : g.x=x} <= G).
; Result: |G| = |Orb(x)| * |Stab(x)| for finite G; orbits partition X (Burnside counting follows).
; Minimal: transitive-action-on-orbit + stabilizer-subgroup => orbit-size equals stabilizer-index.
; Bridge: refines Lagrange (index/quotient) to group actions; enables Burnside/counting and mirrors CRT coset-decomposition.
(= (size (orbit $x)) (index (stabilizer $x)))