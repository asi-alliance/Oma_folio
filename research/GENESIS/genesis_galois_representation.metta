; DOMAIN: galois-representation [CLOSED, derived 2026-07-25]
; Claim: A Galois representation is a continuous homomorphism rho: G_Q = Gal(Qbar/Q) -> GL_n(Q_p) (or GL_n(F_p) residually), realized on the p-adic Tate module V_p(E)=lim E[p^n] tensor Q_p of an elliptic curve or on p-adic etale cohomology H^1_et. It is unramified outside the primes dividing Np, and for good primes p ell the trace of Frobenius rho(Frob_ell)=a_ell and det=ell (cyclotomic), so char poly = X^2 - a_ell X + ell. The representation rho_{f,p} attached to a weight-2 eigenform f (Deligne, Eichler-Shimura) is 2-dimensional, odd (det of complex conjugation = -1), and irreducible; modularity rho_{E,p} = rho_{f,p} matches these Frobenius traces to Hecke eigenvalues. Serre/Fontaine-Mazur conjectures characterize which rho arise from geometry/modular forms.
; Bridge: genesis_hecke_algebra (the Frobenius trace a_ell of rho equals the Hecke eigenvalue a_ell(f) by Eichler-Shimura, so rho_{f,p} is cut out of the Hecke module / Jacobian) + genesis_galois_theory (rho is a linear representation of the absolute Galois group G_Q, refining the Galois correspondence into continuous p-adic matrix actions with Frobenius conjugacy classes) + genesis_shimura_taniyama (modularity is precisely the isomorphism rho_{E,p} = rho_{f,p} of Galois representations, the object identified in the R=T deformation argument).
(= (galois-group-Q) (gal (algebraic-closure Q) Q))
(= (galois-rep $n $p) (continuous-hom (galois-group-Q) (GL $n (Q_p))))
(= (tate-module $E $p) (inverse-limit (torsion $E (pow $p $n))))
(= (rep-of-curve $E $p) (galois-action (tate-module $E $p)))
(= (frobenius-trace $rho $ell) (a_ell))
(= (char-poly $rho $ell) (minus (minus (pow X 2) (times (a_ell) X)) (neg $ell)))
(= (rep-of-eigenform $f $p) (deligne-construction $f $p))
(= (modular-rep-iso $E $f $p) (iso (rep-of-curve $E $p) (rep-of-eigenform $f $p)))
(= (odd-irreducible (rep-of-eigenform $f $p)) True)