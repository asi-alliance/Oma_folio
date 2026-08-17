; DOMAIN: taylor-wiles [CLOSED, derived 2026-07-25]
; Claim: The Taylor-Wiles patching method proves R=T (the universal deformation ring equals the Hecke algebra), completing the modularity of a residual representation rho-bar. One augments the minimal deformation problem by allowing ramification at a finite set Q_n of auxiliary Taylor-Wiles primes q (chosen via Chebotarev so q=1 mod p^n and rho-bar(Frob_q) has distinct eigenvalues), giving deformation rings R_{Q_n} and Hecke algebras T_{Q_n} that are modules over Z_p[Delta_{Q_n}] with Delta_{Q_n}=(Z/p^n)^r. Passing to the inverse limit patches these into R_infty surjecting onto T_infty, both finite over a power series ring S_infty=W[[x_1,...,x_r]]; a dimension/depth (numerical) count (Wiles/Lenstra criterion: R is a complete intersection and T is free) forces R_infty=T_infty, hence R=T at finite level. Combined with Ribet level-lowering this yields the Modularity Theorem and thereby Fermat's Last Theorem via the Frey curve.
; Bridge: genesis_deformation_theory (Taylor-Wiles patches the universal deformation rings R_{Q_n} of the augmented deformation problems into R_infty — the R-side input) + genesis_hecke_algebra (the patched T_infty is built from Hecke algebras T_{Q_n} acting on modular forms with Q_n-level structure — the T-side, and R=T is the conclusion) + genesis_galois_representation (auxiliary primes q are selected by the Frobenius eigenvalues of rho-bar(Frob_q), and the resulting rho^univ = rho_{f,p} certifies modularity).
(= (tw-primes $n) (aux-primes-with (frobenius-distinct-eigenvalues) (cong q 1 (pow $p $n))))
(= (aug-deformation-ring $n) (deformation-problem (tw-primes $n)))
(= (aug-hecke $n) (hecke-algebra-level (tw-primes $n)))
(= (diamond-group $n) (pow (Z-mod (pow $p $n)) $r))
(= (patched-R) (inverse-limit (aug-deformation-ring $n)))
(= (patched-T) (inverse-limit (aug-hecke $n)))
(= (power-series-ring) (W-power-series $r))
(= (numerical-criterion) (and (complete-intersection (patched-R)) (free (patched-T))))
(= (r-equals-t-infty) (iso (patched-R) (patched-T)))
(= (modularity-conclusion) (implies (r-equals-t-infty) (r-equals-t)))