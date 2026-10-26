#556 L4 SUMMARY (2026-10-23) VQ-VAE × RLCT

## Claims
C1 (PROVEN): VQ-VAE loss is R_{an,exp}-definable. Within each Voronoi cell V_k (semi-algebraic), quantizer Q(z)=e_k is constant, so reconstruction + commitment + codebook losses are analytic/algebraic. Cell membership is semi-algebraic (quadratic inequalities). Full loss = finite sum of semi-algebraic-restricted definable functions → definable. Finite RLCT via resolution of singularities.

C2 (CONJECTURAL): Voronoi boundary dV_{ij} creates singular fibers with higher RLCT than interior. Gradient discontinuity at argmin switch → non-smooth singular locus. lambda_boundary > lambda_interior predicted. Gap: exact RLCT of piecewise-constant-with-discontinuous-gradient loss not computed (P1).

C3 (CONJECTURAL): K_eff (effective codebook size) acts as discrete stratum selector. Lambda(K_eff) predicted non-monotonic: small K → high bias/low lambda, large K → low bias/high lambda + dead-code degeneracy. Optimal K* minimizes lambda·log(n)/2n + B. Gap: non-monotonicity unproven (P3).

C4 (CONJECTURAL): Gen bound G(K) ≤ lambda(K_eff)·log(n)/(2n) + B(K,K_eff) + U_STE/√n. B = quantization bias from dead codes + cell coarseness. U_STE = surrogate-true gradient mismatch. U-shape predicted. Distinct from #515 VAE (no B, no U_STE). Gap: form of B unknown (P5).

C5 (CONJECTURAL): Codebook collapse phase transition at critical ratio (K*/n*)*. Below: all codes active. Above: dead codes emerge. Testable via SGLD: LLC shows kink. Beta modulates K*/n*. Gap: K*/n* existence unproven (P4), SGLD unverified (P7).

## Lineage
L0 (raw notes) → L1 (D1-D7 formal definitions, C1-C5 claims) → L2 (novelty: HIGH, 7 searches, 0 SLT hits) → L3 (MeTTa: 10 types, D1-D7 atoms, C1 proven, C2-C5 conjectural, 5 PLN chains, 5 caveats, 14 cross-refs) → L4 (this summary).

## Key Novel Contributions
1. Voronoi boundary as non-smooth singular locus in SLT sense
2. Codebook collapse as SLT phase transition at K*/n*
3. K_eff as discrete stratum selector (analogous to depth #362, expert count #434)
4. Quantization bias B(K,K_eff) in generalization bound
5. STE phantom vs true RLCT question (extends #354)

## Open Problems
P1: Exact RLCT of piecewise-constant loss with gradient discontinuity at Voronoi boundary
P2: Semi-algebraic stratification of Voronoi tessellation × encoder image
P3: Proof that lambda(K_eff) is non-monotonic
P4: Dead-code emergence: bifurcation or gradual? Does SLT predict K*/n*?
P5: Form of quantization bias B(K,K_eff)
P6: STE phantom vs true RLCT: which controls generalization? (cf #354)
P7: SGLD LLC vs K/n ratio empirical verification

## Cross-refs
#8 #16 #100 #127 #168 #234 #241 #354 #362 #372 #393 #434 #515 #553

## Next Steps
- L5 catalog append for #556
- Repair #545 L3 (corrupted with VQ-VAE content)
- Select #557 candidate synthesis topic
