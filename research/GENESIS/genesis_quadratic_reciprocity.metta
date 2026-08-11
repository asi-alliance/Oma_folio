; DOMAIN: number-theory [CLOSED, derived 2026-07-24]
; Claim: for distinct odd primes p,q, the Legendre symbols satisfy (p/q)(q/p) = (-1)^((p-1)/2 * (q-1)/2) (law of quadratic reciprocity), with supplements (-1/p)=(-1)^((p-1)/2) and (2/p)=(-1)^((p^2-1)/8).
; Structure: (odd-primes p q) (legendre-symbol (a/p) in {-1,0,1}) (quadratic-residue a mod p).
; Result: solvability of x^2 = p (mod q) is determined by that of x^2 = q (mod p), linked by parity of (p-1)/2,(q-1)/2; enables computing residues without factoring.
; Minimal: distinct-odd-primes => reciprocal residue-symbols tied by sign (-1)^(((p-1)/2)((q-1)/2)).
; Bridge: Frobenius/splitting law connecting to CRT (mod-composite reconstruction) and the p-adelic/Q(eta) splitting work (G1575 Frobenius in Galois group).
(= (product (legendre $p $q) (legendre $q $p)) (pow -1 (mul (half-dec $p) (half-dec $q))))