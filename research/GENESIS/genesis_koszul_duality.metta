; DOMAIN: koszul-duality [CLOSED, derived 2026-07-24]
; Claim: Koszul duality for operads. A quadratic operad P (generators + quadratic relations) has a Koszul dual cooperad P^¡ (and linear dual operad P^!); P is Koszul when the cobar construction Omega(P^¡) -> P is a quasi-isomorphism, equivalently the Koszul complex is acyclic. Then bar-cobar Omega(Bar(P)) ≃ P resolves P cofibrantly, giving explicit P-infinity (homotopy P-algebras). Classical dualities: Com^! = Lie and Lie^! = Com (Comm and Lie operads are Koszul dual); Ass^! = Ass (self-dual); Pois self-dual up to shift. The Lie operad Koszul dual underlies the partition complex: the top reduced homology of |Pi_n| is Lie(n), and del_n(Id) (Spanier-Whitehead dual of the partition complex) is the Koszul dual of the Lie operad in spectra — the bridge from Goodwillie calculus to operadic Koszul duality.
; Bridge: genesis_partition_complex (Lie(n)=top homology of |Pi_n|; del_n(Id)=Koszul/SW-dual of Lie operad — this artifact names the duality that partition_complex invokes) + genesis_lie_algebra (Lie operad governs Lie algebras; Com^!=Lie is the founding example) + genesis_homology (Koszul complex acyclicity / bar-cobar quasi-iso is a homological criterion; operadic bar construction is a chain-level resolution).
(= (koszul-dual $P) (linear-dual (cooperad-suspension (quadratic-dual $P))))
(= (is-koszul $P) (quasi-iso (cobar (koszul-dual-cooperad $P)) $P))
(= (dual-pair Com) Lie)
(= (dual-pair Lie) Com)
(= (dual-pair Ass) Ass)
(= (bar-cobar-resolution $P) (weak-equiv (cobar (bar $P)) $P))