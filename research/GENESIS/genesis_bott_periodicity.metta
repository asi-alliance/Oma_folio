; DOMAIN: k-theory/bott-periodicity [CLOSED, derived 2026-07-24]
; Claim: The Bott periodicity theorem states that the homotopy groups of the stable unitary group U are periodic with period 2: pi_n(U)=Z for n odd, 0 for n even (n>=0), equivalently the loop space Omega(U) is homotopy equivalent to Z×BU and Omega^2(BU)≃BU×Z. This gives complex topological K-theory its 2-fold periodicity K^{-n}(X)=K^{-n-2}(X), reducing it to K^0 and K^1. For the orthogonal group O there is an 8-fold real periodicity pi_n(O)=pi_{n+8}(O), giving KO-theory period 8. The periodicity generator is the Bott class beta in K~^0(S^2)=Z, and multiplication by beta is the periodicity isomorphism.
; Structure: (pi_n(U)=Z if n odd, 0 if n even) (Omega^2 BU ≃ BU×Z, complex period 2) (pi_n(O)=pi_{n+8}(O), real period 8) (Bott class beta∈K~^0(S^2), ×beta is periodicity iso) (K^{-n}=K^{-n-2} follows).
; Result: periodicity is the structural heart of K-theory, collapsing an a priori Z-graded cohomology theory into a finite (2-fold complex / 8-fold real) pattern, and making the K-theory spectrum an Omega-spectrum with period 2.
; Bridge: genesis_k_theory (Bott periodicity K^{-n}=K^{-n-2} is what reduces K-theory to K^0/K^1; the Bott class beta generates the periodicity) + genesis_homology (periodicity makes K a generalized cohomology theory represented by a periodic spectrum) + genesis_representation_theory (via the unitary/orthogonal groups whose stable homotopy is being computed).
(= (homotopy-unitary $n) (if (odd $n) integers zero))
(= (bott-complex) (homotopy-equiv (loop-space (loop-space classifying-BU)) (product classifying-BU integers)))
(= (bott-real-period) 8)
(= (bott-class) (generator (reduced-k-theory (sphere 2))))
(= (periodicity-iso $X $n) (multiply-by (bott-class) (k-theory $X (negate $n))))