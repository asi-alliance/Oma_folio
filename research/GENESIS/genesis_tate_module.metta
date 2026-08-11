; DOMAIN: tate-module [CLOSED, derived 2026-07-25]
; Claim: For an elliptic curve E/Q and prime p, the p-adic Tate module is T_p(E) = lim_n E[p^n] (inverse limit over multiplication-by-p maps), a free Z_p-module of rank 2. V_p(E) = T_p(E) tensor_{Z_p} Q_p is a 2-dimensional Q_p-vector space. The absolute Galois group G_Q acts continuously, giving rho_{E,p}: G_Q -> GL_2(Z_p) (resp GL_2(Q_p)), the p-adic Galois representation attached to E, unramified outside pN with trace rho(Frob_ell)=a_ell and det=cyclotomic character. T_p(E) is the arithmetic foundation on which the Selmer group Sel_p(E/Q) subset H^1(G_Q, E[p^n]) and the Mordell-Weil/Sha exact sequence are built.
; Bridge: genesis_galois_representation (G_Q acts on T_p(E) yielding rho_{E,p}: G_Q -> GL_2(Z_p), the very representation the modularity/Serre/Fontaine-Mazur program studies) + genesis_group_cohomology (Selmer and descent are built from H^1(G_Q, E[p^n]) with T_p as the coefficient module) + genesis_elliptic_curve (T_p is assembled from the p-power torsion subgroups E[p^n] of the elliptic curve).
(= (torsion $E $n) (kernel (mult-by $n $E)))
(= (tate-module $E $p) (inverse-limit (lambda $n (torsion $E (pow $p $n)))))
(= (rank-tate $E $p) 2)
(= (v-module $E $p) (tensor (tate-module $E $p) (Q_p)))
(= (galois-action $E $p) (rho (galois-group-Q) (GL 2 (Z_p))))
(= (trace-frob $E $p $ell) (a_ell $E $ell))
(= (det-tate $E $p) (cyclotomic-character $p))
(= (foundation-of-selmer $E $p) (coefficient-module (torsion $E (pow $p $n))))