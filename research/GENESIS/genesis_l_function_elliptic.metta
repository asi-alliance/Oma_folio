; DOMAIN: l-function-elliptic [CLOSED, derived 2026-07-25]
; Claim: For an elliptic curve E/Q the Hasse-Weil L-function is L(E,s)=prod_p L_p(E,s), where the local Euler factor at good primes is (1 - a_p p^{-s} + p^{1-2s})^{-1} with a_p = p+1-#E(F_p), and modified factors at bad primes by reduction type. The Euler product converges for Re(s)>3/2. By the Modularity Theorem (shimura_taniyama) L(E,s)=L(f,s) for a weight-2 newform f of level N=conductor(E), giving analytic continuation to all of C and a functional equation relating s to 2-s with sign w=+-1. BSD conjecture: ord_{s=1} L(E,s) = rank E(Q) (analytic rank = algebraic rank), and the leading Taylor coefficient at s=1 equals (Omega * Reg * prod c_p * #Sha) / (#E(Q)_tors)^2, housing the Cassels-Tate square-order of Sha. Bridge: genesis_shimura_taniyama (modularity gives analytic continuation + functional equation via L(E,s)=L(f,s)) + genesis_sha_group (#Sha enters the leading BSD coefficient) + genesis_cassels_tate_pairing (forces the #Sha factor to be a perfect square).
(= (l-function $E) (euler-product (lambda $p (local-factor $E $p))))
(= (local-factor-good $E $p) (inverse (- (+ 1 (neg (mult (a-p $E $p) (pow $p (neg $s))))) (pow $p (- 1 (mult 2 $s))))))
(= (a-p $E $p) (- (+ $p 1) (count-points $E (finite-field $p))))
(= (analytic-continuation $E) (via-modularity (l-function $E) (l-function-newform (modular-form $E))))
(= (functional-equation $E) (relate $s (- 2 $s) (sign $E)))
(= (analytic-rank $E) (order-vanishing (l-function $E) 1))
(= (bsd-rank $E) (equal (analytic-rank $E) (rank $E)))
(= (bsd-leading-coeff $E) (div (mult (period $E) (regulator $E) (tamagawa-product $E) (order (sha-group $E))) (square (order (torsion $E)))))