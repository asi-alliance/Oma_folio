# #889: Mean Shift × RLCT — L0 Topic Selection

Date: 2026-11-09

## Topic
Mean Shift clustering / Kernel Density Estimation (KDE) mode-seeking algorithm analyzed through Singular Learning Theory (RLCT).

## Motivation
Mean shift is a non-parametric, iterative mode-seeking algorithm that climbs KDE gradients to find density maxima. Unlike k-means (#872, fixed K, discrete assignment) or GMM/EM (#268, parametric, continuous likelihood), mean shift has an endogenous mode count determined by bandwidth h. The bandwidth acts as a continuous stratum selector — a parameter that smoothly controls the number of singularities (modes) in the loss landscape. This is unique: no other algorithm in the catalog has a single continuous parameter that controls the number of critical points via Morse-theoretic bifurcations.

## Key Questions
1. Is the KDE / mean shift loss R_{an,exp}-definable? (→ C1)
2. What is the singular fiber structure? Mode permutation + collision strata? (→ C2)
3. Can bandwidth h serve as a continuous RLCT stratum selector? (→ C3)
4. What is the generalization bound, and does Hessian eigenvalue structure appear? (→ C4)
5. Is there a phase transition at critical bandwidth h_c where modes merge? (→ C5)

## Claims
- **C1 (PROVEN)**: Gaussian KDE and mean shift loss are R_{an,exp}-definable. RLCT exists by Wilkie's theorem. Exponential kernel composition preserves definability.
- **C2 (CONJECTURAL)**: Singular fiber = S_k mode permutation (discrete) × mode collision stratum (Morse-theoretic saddle-node bifurcation). First Morse theory → SLT bridge in catalog.
- **C3 (CONJECTURAL)**: Bandwidth h as continuous U-shaped stratum selector. h→0: over-segmentation (n modes, high λ). h* optimal: k* modes, minimal λ. h→∞: single flat mode, high λ via flatness. Silverman's rule predicts λ minimum.
- **C4 (CONJECTURAL)**: Gen bound G ≤ λ_MS·log(n)/(2n) + U_MS/√n where U_MS ∝ 1/|λ_min(Hess)|. First Hessian-eigenvalue-dependent gen bound. Morse index connection to stability.
- **C5 (CONJECTURAL)**: Phase transition at critical bandwidth h_c: saddle-node bifurcation (mode-saddle annihilation). SGLD LLC shows U-shaped profile with step decreases at h_c values. Cerf theory decomposes bifurcations into stratum crossings.

## Novelty Hypothesis
- Zero external SLT/RLCT connections to mean shift / KDE / mode-seeking in literature (verified L2)
- Catalog grep: zero hits for mean shift / KDE / mode-seeking
- Distinct from #872 (geometric centroid collision, discrete K), #888 (spectral eigenvalue crossing, graph Laplacian), #268 (parametric GMM/EM)
- Standout contributions: first Morse/Cerf theory → SLT bridge; first Hessian-eigenvalue gen bound

## Open Problems (7)
1. Formalize RLCT at saddle-node via resolution of singularities
2. Prove Silverman's h* minimizes λ_MS (MISE→RLCT connection)
3. Non-Gaussian kernels (Epanechnikov, uniform) definability + Morse structure
4. Weighted mean shift: w_i additional parameter symmetry fiber
5. High-dim curse: KDE modes + Hessian conditioning
6. Persistent homology: mode lifetime barcodes as RLCT stratum diagrams
7. SGLD empirical LLC profile across bandwidth sweep

## Cross-References (11)
#8 #57 #88 #100 #267 #268 #350 #872 #888

## Next: L1 formalization