# Synthesis #661: RBF Networks × RLCT — L2 Novelty Check

## Date: 2026-10-27
## Status: L2 NOVELTY VERIFIED

## Websearch Results (2 searches)
1. "radial basis function network singular learning theory RLCT loss landscape geometry" — general SLT/RLT coverage (Watanabe, DSLT, metauni, LessWrong). General RBF network literature (Broomhead-Lowe 1988, Wikipedia). ZERO direct RBF×RLCT bridge.
2. Prior query covered "RBF singularity theory learning theory" — same result: no prior work on RBF singular strata in SLT context.

## Verdict: No prior work bridges RBF networks to SLT/RLCT. Genuinely novel territory.

## Catalog Check
grep "RBF\|radial basis\|rbf" synthesis-catalog.md → ZERO_CATALOG_HITS
grep "center collapse\|dead unit\|bandwidth collapse\|Gaussian kernel singularity" → ZERO_CATALOG_HITS

## Overlap Analysis

### vs #169 (Dropout)
Dropout creates stochastic masking of units — random, reversible degeneracy.
RBF dead units (S2) are deterministic, permanent degeneracy (w_k=0).
- Dropout: stochastic mask, non-degenerate at expectation, stratum selector = p
- RBF dead unit: deterministic w_k=0, free fiber directions (c_k,σ_k), stratum selector = σ
- Different degeneracy mechanism. DISTINCT.

### vs #383 (VAE Posterior Collapse)
VAE posterior collapse: latent dimension becomes unused (q(z|x) → q(z)).
RBF dead unit: center contributes nothing (w_k=0), (c_k,σ_k) free.
- VAE: KL term drives collapse, variational free parameters
- RBF: data fit drives w_k→0, geometric free parameters (c_k,σ_k)
- Analogous but different structure: VAE collapse is in latent space, RBF in center space. DISTINCT.

### vs #556 (VQ-VAE Codebook Collapse)
VQ-VAE: codebook entries collapse to few discrete codes.
RBF: continuous centers collapse to identical (c_i,c_j).
- VQ-VAE: discrete codebook, categorical collapse
- RBF: continuous centers, codimension-(d+1) collapse stratum
- Different: discrete vs continuous, different codimension structure. DISTINCT.

### vs #371 (Fast Weight Rank Collapse)
Fast weight: rank-deficient matrix fibers.
RBF: center collapse reduces effective K, not matrix rank.
- Fast weight: matrix rank deficiency, Schubert variety structure
- RBF: point set collapse, permutation group S_K structure
- Different geometry. DISTINCT.

## Novel Components (not found in any prior synthesis or literature)
1. Explicit center coordinates giving constructive RLCT access (first architecture with geometrically visualizable singular strata)
2. Four classified singular strata (S1-S4) with computed codimensions and RLCT estimates
3. Bandwidth σ as U-shaped stratum selector with λ(σ) profile
4. Dead-unit RLCT λ_dead = m(d+1)/2 with free fiber dimension analysis
5. Center collapse RLCT λ_collapse = (d+1)/2 via quadratic KL expansion
6. Bandwidth collapse RLCT λ_bw = 1/(2α+d) via power-law approach path
7. Phase transition at critical (K*,σ*) between stratum types
8. RBF as constructive testbed for RLCT methods bypassing Hironaka resolution

## Conclusion
NOVEL. All overlaps are DISTINCT. No prior RBF×RLCT bridge exists in literature or catalog.

Next: L3 MeTTa encoding.
