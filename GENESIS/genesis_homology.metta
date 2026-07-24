; DOMAIN: algebraic-topology [CLOSED, derived 2026-07-24]
; Claim: A chain complex is a sequence of abelian groups C_n with boundary maps d_n: C_n -> C_{n-1} satisfying d_{n-1} d_n = 0 (i.e. im(d_{n+1}) subset ker(d_n)). Homology H_n = ker(d_n)/im(d_{n+1}) = cycles modulo boundaries measures the failure of exactness. Singular homology takes C_n = free abelian group on continuous maps Delta^n -> X with the alternating-face boundary; it is a homotopy invariant. A short exact sequence of chain complexes induces a long exact sequence in homology (the connecting map via the snake lemma). Euler characteristic chi(X) = sum (-1)^n rank(H_n) = sum (-1)^n b_n (Betti numbers), independent of the chain-level description.
; Structure: (chain complex d^2=0) (H_n = cycles/boundaries = ker d_n / im d_{n+1}) (singular homology homotopy-invariant, functorial) (short exact sequence of complexes => long exact sequence, snake lemma connecting map) (Euler characteristic = alternating sum of Betti numbers).
; Result: homology converts a topological space into a graded sequence of abelian groups whose ranks (Betti numbers) and torsion are homotopy invariants; the snake lemma gives the long exact sequence machine, and chi is the homotopy-invariant alternating sum.
; Bridge: genesis_de_rham (de Rham theorem: H^k_dR(M) iso Hom(H_k(M),R) - de Rham cohomology is the real dual of singular homology, the integration pairing is the duality) + genesis_fundamental_group (Hurewicz: H_1 = abelianization of pi_1) + genesis_gauss_bonnet (chi(M) = alternating sum of Betti numbers = integral of curvature).
(= (chain-complex $C) (and (graded-abelian-groups $C) (boundary-maps $C d) (= (compose d d) 0)))
(= (homology $C $n) (quotient (kernel (d $n)) (image (d (succ $n)))))
(= (cycles $C $n) (kernel (d $n)))
(= (boundaries $C $n) (image (d (succ $n))))
(= (long-exact-sequence $ses) (snake-lemma-connecting $ses))
(= (betti-number $X $n) (rank (homology (singular $X) $n)))
(= (euler-characteristic $X) (alternating-sum $n (betti-number $X $n)))