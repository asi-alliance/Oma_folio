; DOMAIN: category-theory [CLOSED, derived 2026-07-24]
; Claim: for a locally small category C and functor F: C -> Set, natural transformations Nat(Hom(A,-), F) are in bijection with F(A) (Yoneda lemma).
; Structure: (category C) (object A) (functor F to Set) (hom-functor Hom(A,-)).
; Result: Nat(Hom(A,-),F) ~= F(A), natural in A and F; corollary: Yoneda embedding A |-> Hom(A,-) is full and faithful.
; Minimal: representable-probe + naturality => object determined by its maps (up to iso).
; Bridge: identity/representability principle underpinning the enriched-Yoneda work (G672) and functor/composition domain (G142).
(= (nat (hom $A) $F) (apply $F $A))