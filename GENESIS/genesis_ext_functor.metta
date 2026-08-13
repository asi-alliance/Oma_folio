; DOMAIN: homological-algebra/derived-functors [OPEN, derived 2026-07-31]
; Claim: Ext^n_R(A,B) is the n-th right derived functor of Hom_R(-,B) computed via projective resolution.
; Ext^0 = Hom, Ext^1 classifies extensions (Baer sum), Ext^n parametrizes n-extensions (Yoneda).
; Ext is balanced: can use projective res of A or injective res of B.
; UCT: 0->Ext^1(H_{n-1},G)->H^n(C;G)->Hom(H_n,G)->0
; Group cohomology: H^n(G,M)=Ext^n_{ZG}(Z,M)
; Bridge: spectral_sequence + group_cohomology + homology + tor_functor

(= (Ext $R $n $A $B) (cohomology $n (Hom-complex $R (projective-resolution $R $A) $B)))
(= (Ext-zero $R $A $B) (Hom $R $A $B))
(= (Ext-balanced $R $n $A $B) (cohomology $n (Hom-complex-contravariant $R $A (injective-resolution $R $B))))
(= (extension-classification $R $A $B) (bijection (Ext $R 1 $A $B) (extensions $R $A $B)))
(= (group-cohomology-as-ext $G $M $n) (= (group-cohomology $G $n $M) (Ext (group-ring $G) $n (trivial-module $G) $M)))
(= (universal-coefficient-theorem $C $G $n) (short-exact (Ext 1 (homology (pred $n) $C) $G) (cohomology $n $C $G) (Hom (homology $n $C) $G)))
(= (long-exact-ext $R $A $B $E $C $n) (=> (short-exact $R $B $E $C) (exact-sequence (Hom $R $A $B) (Hom $R $A $E) (Hom $R $A $C) (Ext $R 1 $A $B) (Ext $R 1 $A $E) (Ext $R 1 $A $C) (Ext $R 2 $A $B))))
(= (yoneda-product $R $A $B $C $m $n) (composition (Ext $R $m $A $B) (Ext $R $n $B $C) (Ext $R (plus $m $n) $A $C)))
(= (pid-vanishing $R $n $A $B) (=> (and (PID $R) (greater $n 1)) (= (Ext $R $n $A $B) (zero))))
(= (baer-sum $R $A $B) (abelian-group-structure (Ext $R 1 $A $B)))
(= (dimension-shifting $R $A $B $n) (=> (short-exact $R $K $P $A) (= (Ext $R $n $A $B) (Ext $R (pred $n) $K $B))))
(= (ext-additivity-arg1 $R $n $A1 $A2 $B) (= (Ext $R $n (direct-sum $A1 $A2) $B) (direct-sum (Ext $R $n $A1 $B) (Ext $R $n $A2 $B))))
(= (ext-additivity-arg2 $R $n $A $B1 $B2) (= (Ext $R $n $A (direct-sum $B1 $B2)) (direct-sum (Ext $R $n $A $B1) (Ext $R $n $A $B2))))
(= (ext-over-z $A $B $n) (=> (and (= $R Z) (greater $n 0)) (finite-group (Ext $R $n $A $B))))
(= (ext-duality $R $n $A $B) (equivalence (proj-resolution-ext $R $n $A $B) (injective-resolution-ext $R $n $A $B)))
