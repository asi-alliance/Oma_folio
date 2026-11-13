## Synthesis #887: UMAP × RLCT — L0 Hypothesis

Date: 2026-11-09

## What is this about?

UMAP (Uniform Manifold Approximation and Projection) is a dimensionality reduction method that constructs a fuzzy simplicial set from the data (via local neighborhood graphs) and optimizes a cross-entropy between the high-dimensional and low-dimensional fuzzy simplicial sets. We analyze UMAP through Singular Learning Theory (SLT), specifically the Real Log Canonical Threshold (RLCT) — the measure of how singular a model loss landscape is near its true parameters.

## Key Hypotheses

### C1 (PROVEN): UMAP loss is R_an,exp-definable
The fuzzy membership function w_i(x_i, x_j) = exp(-(d(x_i,x_j) - rho_i) / sigma_i) is definable in R_an,exp (exponential of definable distance minus definable local radius). The cross-entropy L = sum over edges [w_h log(w_l/eps) + (1-w_h) log((1-w_l)/(1-eps))] involves log and exp of definable functions. Closure under composition, addition, and restricted analytic functions confirms definability.

### C2 (CONJECTURAL): Fuzzy simplicial set overlap creates singular fiber
When two high-dimensional simplices map to the same low-dimensional simplex (neighborhood collapse), the cross-entropy zero-locus degenerates. The singular fiber consists of embedding configurations where local fuzzy memberships are preserved but global structure collapses. Distinct from t-SNE/Isomap (#267): UMAP's fuzzy set topology (not kernel density) creates combinatorial singularity structure.

### C3 (CONJECTURAL): n_neighbors is U-shaped stratum selector
Small n_neighbors: overly local, high-rank local singularities. Optimal n_neighbors: balances local-global, minimizes RLCT. Large n_neighbors: global graph dominates, spectral degeneracy reintroduces singularities. Predicts optimal n_neighbors minimizes effective RLCT.

### C4 (CONJECTURAL): Generalization bound with fuzzy set complexity
Gen_UMAP <= lambda_UMAP * log(n)/(2n) + U(k, n_neighbors, min_dist)/sqrt(n), where U includes fuzzy graph spectral gap and local density variation terms absent in GMM (#268) and manifold learning (#267) bounds.

### C5 (CONJECTURAL): min_dist phase transition
As min_dist -> 0, RLCT jumps: embeddings collapse to discrete clusters (singularity concentration). SGLD shows bimodal LLC: cluster regime vs continuous manifold regime. Distinct from ALiBi slope phase transition (#427) and Mixup alpha (#589).

## What is new?
- Fuzzy simplicial set cross-entropy as definable loss with R_an,exp structure
- Neighborhood collapse singular fiber (combinatorial-topological, not kernel-based)
- n_neighbors as U-shaped RLCT stratum selector
- min_dist phase transition between cluster and manifold regimes
- Closest external: McInnes et al. (2018) UMAP paper — no SLT connection; #267 covers t-SNE/Isomap/LLE but NOT UMAP's fuzzy simplicial construction

## What is unproven?
- Exact RLCT at neighborhood collapse needs resolution of fuzzy simplicial singularities
- U-shaped lambda(n_neighbors) continuity unproven
- Cross-entropy definability over arbitrary metric spaces (non-Euclidean distances)
- min_dist phase transition threshold needs formal derivation
- Connection between graph Laplacian spectrum and RLCT stratum structure

## Cross-references
#8 #16 #57 #88 #100 #267 #268 #350 #427 #566 #589 #805 #885

Status: L0 DRAFTED 2026-11-09. Next: L1 formalization.