; DOMAIN: selmer-group [CLOSED, derived 2026-07-25]
; Claim: For an elliptic curve E/Q and prime p, the p^n-Selmer group Sel_{p^n}(E/Q) is the subgroup of Galois cohomology classes in H^1(G_Q, E[p^n]) whose restriction to every completion Q_v lies in the image of the local Kummer map E(Q_v)/p^n E(Q_v) -> H^1(G_{Q_v}, E[p^n]). It fits in the fundamental exact sequence 0 -> E(Q)/p^n E(Q) -> Sel_{p^n}(E/Q) -> Sha(E/Q)[p^n] -> 0, so it simultaneously bounds the Mordell-Weil rank and captures the p-part of the Tate-Shafarevich group Sha. Taking inverse limits gives the p-adic Selmer group; its Pontryagin dual X_infty over the cyclotomic Z_p-extension is the module whose characteristic ideal the Iwasawa Main Conjecture equates with the p-adic L-function, and finiteness of Sha plus rank information is the content of BSD.
; Bridge: genesis_tate_module (Sel is built from E[p^n], whose inverse limit is the Tate module T_p(E); the coefficient modules of the defining H^1 are exactly the p-power torsion assembled by T_p) + genesis_group_cohomology (Sel_{p^n} is a subgroup of the Galois cohomology group H^1(G_Q, E[p^n]) cut out by local conditions, pure group-cohomology machinery) + genesis_galois_representation (the local Kummer conditions and Frobenius/inertia constraints are governed by rho_{E,p}: G_Q -> GL_2(Z_p) acting on E[p^n]).
(= (kummer-image $E $v $n) (image (kummer-map $E $v $n)))
(= (local-condition $E $v $n) (kummer-image $E $v $n))
(= (h1-torsion $E $n) (H1 (galois-group-Q) (torsion $E (pow $p $n))))
(= (selmer $E $p $n) (subgroup (h1-torsion $E $n) (lambda $c (forall $v (in (restrict $c $v) (local-condition $E $v $n))))))
(= (descent-sequence $E $p $n) (exact (mordell-weil-mod $E $n) (selmer $E $p $n) (sha-torsion $E $n)))
(= (bounds-rank $E) (via (selmer $E $p $n) (mordell-weil-rank $E)))
(= (sha-part $E $p) (cokernel (mordell-weil-mod $E $n) (selmer $E $p $n)))
(= (iwasawa-dual $E $p) (pontryagin-dual (inverse-limit-selmer $E $p)))