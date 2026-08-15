; DOMAIN: group-cohomology [REBUILD, 2026-08-14]
(= (bar-resolution $G) (and (free-resolution (bar-complex $G) $Z) (= (Bn $G) (tensor-power $ZG $n))))
; Source: Eilenberg-MacLane 1945; Hochschild-Serre 1953; Lyndon 1948; Tate 1952; Shapiro 1951; Brown 1982
; Bridges: genesis_homological_algebra, genesis_spectral_sequences, genesis_algebraic_topology, genesis_representation_theory
(= (group-cohomology $G $M $n) (and (group $G) (G-module $M) (= (Hn $G $M) (derived-functor $n (invariants-functor $G $M)))))
(= (bar-resolution $G) (and (free-resolution (bar-complex $G) Z) (= (Bn $G) (tensor-power ZG $n))))
(= (cochain-complex $G $M) (and (group $G) (G-module $M) (= (Cn $G $M) (Hom (Bn $G) $M))))
(= (cup-product $c1 $c2) (and (cochain $c1) (cochain $c2) (= (cup $c1 $c2) (cocycle ($c1 times $c2)) (shuffle-product $c1 $c2))))
(= (lhs-spectral-sequence $G $N $M) (and (normal-subgroup $N $G) (spectral-sequence $E) (= ($E2 $p $q) (Hp $G/N (Hq $N $M))) (converges $E (H (p+q) $G $M))))
(= (shapiro-lemma $H $G $M) (=> (subgroup $H $G) (isomorphic (Hn $G (Ind $M)) (Hn $H $M))))
(= (tate-cohomology $G $M $n) (and (finite-group $G) (G-module $M) (= (Hhat $n $G $M) (quotient (kernel $N) (image $N))) (complete-resolution $N)))
(= (group-extension $E $G $N) (and (short-exact-sequence (1) ($N) ($E) ($G) (1)) (normal-subgroup $N $E) (quotient-group $G (/ $E $N))))
(= (cross-domain-bridge-gc-homalgebra $system) (and (bridges genesis_group_cohomology genesis_homological_algebra) (uses derived-functor invariants-functor) (uses bar-resolution free-resolution)))
(= (cross-domain-bridge-gc-specseq $system) (and (bridges genesis_group_cohomology genesis_spectral_sequences) (uses lhs-spectral-sequence group-extensions) (uses tate-cohomology complete-resolution)))
(= (cross-domain-bridge-gc-algtopo $system) (and (bridges genesis_group_cohomology genesis_algebraic_topology) (uses group-cohomology classifying-spaces) (uses cup-product cohomology-ring)))
(= (cross-domain-bridge-gc-repth $system) (and (bridges genesis_group_cohomology genesis_representation_theory) (uses group-cohomology group-algebras) (uses shapiro-lemma induced-representations)))
