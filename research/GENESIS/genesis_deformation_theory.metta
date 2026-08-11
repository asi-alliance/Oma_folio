; DOMAIN: deformation-theory [CLOSED, derived 2026-07-25]
; Claim: Given a residual representation rho-bar: G_Q -> GL_2(F_p) (absolutely irreducible, odd), Mazur's deformation theory studies lifts rho: G_Q -> GL_2(A) for complete local Noetherian W(F_p)-algebras A reducing to rho-bar mod m_A. The deformation functor Def(A)=lifts modulo conjugation by ker(GL_2(A)->GL_2(F_p)) is (pro-)representable by a universal deformation ring R with universal deformation rho^univ, when End(rho-bar)=F_p. The tangent space Def(F_p[eps]/eps^2) = H^1(G_Q, ad rho-bar), and obstructions live in H^2(G_Q, ad rho-bar); imposing local conditions (unramified/flat/ordinary outside a set S) gives a deformation ring R_S of a Galois deformation problem. R=T: this universal deformation ring R is isomorphic to the Hecke algebra T (Wiles/Taylor-Wiles patching), proving every such rho-bar deformation of the right type is modular — the R-side engine of modularity.
; Bridge: genesis_galois_representation (deformation theory parametrizes all p-adic lifts of a fixed residual rho-bar; rho^univ specializes to rho_{f,p} via R->T->Q_p) + genesis_eichler_shimura (Eichler-Shimura constructs the modular deformations rho_{f,p} that R=T identifies with the full universal deformation ring) + genesis_group_cohomology (tangent space H^1(G_Q, ad rho-bar) and obstruction H^2 are Galois cohomology of the adjoint module, computing dim and smoothness of R).
(= (residual-rep) (rho-bar (galois-group-Q) (GL 2 (F_p))))
(= (deformation $A) (lift (residual-rep) (GL 2 $A)))
(= (deformation-functor $A) (quotient (deformation $A) (conjugation (kernel-reduction $A))))
(= (universal-deformation-ring) (represents (deformation-functor)))
(= (tangent-space) (cohomology-H1 (galois-group-Q) (ad (residual-rep))))
(= (obstruction-space) (cohomology-H2 (galois-group-Q) (ad (residual-rep))))
(= (deformation-problem $S) (universal-deformation-ring-with-conditions $S))
(= (r-equals-t) (iso (universal-deformation-ring) (hecke-algebra $N $k)))
(= (universal-specializes $f) (factors (universal-deformation-ring) (rep-of-eigenform $f $p)))