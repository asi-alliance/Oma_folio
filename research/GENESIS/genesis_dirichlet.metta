; DOMAIN: number-theory [CLOSED, derived 2026-07-24]
; Claim: for coprime a,q (gcd(a,q)=1), the arithmetic progression a, a+q, a+2q, ... contains infinitely many primes (Dirichlet's theorem), proved via nonvanishing of Dirichlet L-functions L(s,chi) at s=1 for nonprincipal characters chi mod q.
; Structure: (modulus q>=1) (residue a with gcd(a,q)=1) (Dirichlet character chi mod q) (L-function L(s,chi)=sum chi(n)/n^s = prod_p (1-chi(p)/p^s)^-1).
; Result: sum over primes p=a mod q of 1/p diverges; density of such primes is 1/phi(q) (equidistribution across reduced residue classes). Key lemma: L(1,chi)!=0 for chi nonprincipal.
; Minimal: coprimality + nonvanishing L(1,chi) => infinitude and equidistribution of primes in each reduced residue class mod q.
; Bridge: Euler-product/character-orthogonality principle; the Euler product mirrors genesis_cauchy_integral analytic machinery, uses genesis_crt (residue classes mod q) and quadratic_reciprocity (chi as Legendre symbol special case); anchors analytic-number-theory cluster (G1501).
(= (infinitude (primes-in-progression $a $q)) (and (coprime $a $q) (nonzero (L 1 (nonprincipal-char $q)))))