#833 PCA × RLCT - L2 Novelty Verification

## Date
2026-10-31

## Method
5 websearches: PCA singular learning theory RLCT eigenvalue degeneracy; PCA singular learning theory fiber eigenvector non-identifiability posterior concentration; principal component model selection BIC free energy phase transition singular statistical model; PCA eigenvector posterior concentration singular learning theory novelty check; PCA probabilistic model singularities eigenvector non-identifiability posterior free energy. Plus LTM queries and catalog grep (PCA|principal comp: ZERO hits).

## Prior Work Found
- ZERO direct prior work bridging PCA and RLCT/SLT. Searches returned generic PCA documentation (Tipping-Bishop PPCA, eigendecomposition of covariance), generic SLT/RLCT material, and tangential free-energy comparisons for Bayes methods — but NO RLCT analysis of eigenvalue multiplicity strata, eigenspace rotation fibers, or PCA model selection.
- Classical PCA theory never uses resolution-of-singularities or posterior-concentration machinery.
- Closest tangential: Watanabe-style free-energy comparisons in Bayes model selection; generic latent non-identifiability (posterior collapse) discussions — neither treats PCA.

## Novel Contributions
1. Eigenvalue multiplicity-m strata as singular strata with O(m) eigenspace rotation fiber (with #69 correction: fiber does NOT inflate RLCT; predicted RLCT ~ codim/2).
2. Rank r as discrete stratum selector; scree-plot elbow reframed as RLCT phase transition at r*.
3. Eigengap delta^{-1} sample-eigenvector sensitivity connected to singular scaling exponent in local KL expansion.
4. Signal/noise boundary fiber at l_min = sigma^2 (non-identifiable subspace split), bilinear-type singularity shared with reduced-rank regression.
5. Vainsencher blow-up of PSD-cone rank strata as resolution mechanism (non-toric for r>=3).

## Distinct From
#832 kNN (data-as-parameter vs covariance-parameter), #268 GMM/mixture (component degeneracy vs eigenvalue multiplicity), #162 rank deficiency (generic rank strata vs PSD cone stratification), #69 singular fiber lesson (applied correction), #298 Vainsencher resolution (shared tooling).

## Caveat
Rotation fiber non-identifiability is classical folklore; the RLCT stratification and phase-transition reframing is the novel part. C2-C5 all conjectural; no exact RLCT computed.

## Verdict
NOVELTY PASSED. No prior PCA×RLCT bridge found; eigenvalue-multiplicity strata + scree-elbow-as-phase-transition is a genuinely new SLT framing.