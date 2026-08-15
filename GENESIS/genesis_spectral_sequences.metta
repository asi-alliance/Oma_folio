; DOMAIN: spectral-sequences [OPEN, derived 2026-08-14]; Source: Serre 1951; Grothendieck 1957; Massey 1952; Weibel 1994; McCleary 2001
; Bridges: genesis_homological_algebra, genesis_algebraic_topology, genesis_homology, genesis_group_cohomology, genesis_k_theory
(= (spectral-sequence $Er $dr) (and (bigraded-module $Er) (differential $dr (bidegree $r (- $r 1))) (= (homology $Er $dr) (E (+ $r 1)))))
(= (exact-couple $D $E $i $j $k) (and (exact-sequence $D $E $i $j $k) (bidegree $i (1 -1)) (bidegree $j (-1 0)) (bidegree $k (-1 1))))
(= (filtered-complex-ss $C $F) (= (E0 pq) (quotient (Fp $C) (Fp-1 $C))))
(= (convergence $Er $Einf) (and (bounded-filtration $F) (= (Einf pq) (graded-piece (H (+ $p $q)) $F))))
(= (serre-spectral-sequence $F $B $E) (and (fibration $F -> $B) (convergence (E2 pq) (H $B (H $F))) (= (E2 pq) (H $p $B (H $q $F)))))
(= (grothendieck-spectral-sequence $F $G) (=> (and (left-exact $F) (left-exact $G)) (convergence (E2 pq) (R $p $F (R $q $G $A)))))
(= (leray-serre-ss $pi $B $F) (and (fibration $pi) (serre-spectral-sequence $F $B $E) (= (E2 pq) (H $p $B (H $q $F)))))
(= (cross-domain-bridge-ss-homology $system) (and (bridges genesis_spectral_sequences genesis_homology) (uses serre-spectral-sequence fibration-homology) (uses filtered-complex-ss chain-complexes)))
(= (cross-domain-bridge-ss-groupcoh $system) (and (bridges genesis_spectral_sequences genesis_group_cohomology) (uses lyndon-hochschild-serre-ss group-extensions) (uses grothendieck-spectral-sequence invariants)))
