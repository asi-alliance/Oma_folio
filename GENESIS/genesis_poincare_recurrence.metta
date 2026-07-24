; DOMAIN: dynamics [CLOSED, derived 2026-07-24]
; Claim: Let (X, B, mu, T) be a measure-preserving system with mu(X) finite and T measurable measure-preserving. For any measurable E with mu(E)>0, almost every point of E returns to E infinitely often: mu({x in E : T^n(x) in E for infinitely many n}) = mu(E). Proof: let F = {x in E : T^n(x) not in E for all n>=1}. F, T^-1 F, T^-2 F, ... are pairwise disjoint; measure preservation makes them equal measure; finiteness forces mu(F)=0. Iterating gives infinite returns a.e.
; Structure: (system X mu T finite) (T measure-preserving) (E measurable mu>0) (non-returning F has disjoint equal-measure preimages) (finiteness => mu(F)=0) (=> a.e. recurs infinitely often).
; Result: finiteness of the invariant measure alone forces recurrence; qualitative precursor to Birkhoff ergodic theorem.
; Bridge: genesis_birkhoff (recurrence skeleton, Birkhoff quantifies return frequency) + measure_extension (needs finite invariant measure) + genesis_perron_frobenius (invariant structure under measure-preserving action).
(= (poincare-recurrence $sys $E) (recurs-infinitely-often (almost-every $E) $sys))
(= (non-returning-set $E $T) (disjoint-preimages $E $T))
(= (finite-measure-forces (measure (non-returning-set $E $T)) zero) true)