## Synthesis #888: Spectral Clustering × RLCT -- L0 Exploration

Date: 2026-11-09

## Topic
Spectral Clustering (Normalized Cut / Ratio Cut / Laplacian Eigenvalue Clustering) × Real Log Canonical Threshold (RLCT)

## Background
Spectral clustering uses eigenvalues/eigenvectors of graph Laplacian L = D - W to partition data into k clusters. Key variants:
- Normalized Cut (Shi-Malik): minimize NCut = sum_k (y_k^T (D-W) y_k) / (y_k^T D y_k)
- Ratio Cut: minimize Rcut = sum_k (y_k^T L y_k) / |C_k|
- Relaxed solution: bottom k eigenvectors of normalized Laplacian L_sym = D^{-1/2} L D^{-1/2}
- Post-processing: k-means on rows of eigenvector matrix U_k

## RLCT Bridge: Why Spectral Clustering is Singular

### Singularity Source 1: Eigenvalue Multiplicity
Graph Laplacian L has eigenvalues 0 = lambda_1 <= lambda_2 <= ... <= lambda_n. When lambda_k = lambda_{k+1} (eigenvalue gap closes), the eigenvector subspace becomes degenerate -- rotation within the eigenspace costs zero energy. This is a non-identifiability fiber: O(k) rotation group acts on the eigenvector matrix U_k, and the loss is invariant under this action. The singular locus includes the set where eigenvalue gaps vanish.

### Singularity Source 2: Cluster Indicator Relaxation
The true cluster indicators are binary {0,1}. The relaxation to real-valued eigenvectors creates a constraint manifold. The discrete solution is a point on this manifold, but the relaxation introduces continuous directions. The zero-locus of the relaxed loss includes both the true partition and spurious eigenvector rotations.

### Singularity Source 3: Graph Construction Parameters
The similarity graph (kNN, epsilon-neighborhood, fully connected with Gaussian kernel) has parameters (k, epsilon, sigma_kernel) that change the graph topology. Different graphs yield different Laplacians with different eigenvalue structures. This creates a family of loss functions parameterized by graph construction -- analogous to n_neighbors in #887 UMAP.

### Singularity Source 4: k-means Post-processing
After extracting U_k, k-means clustering on rows has its own singularity (permutation symmetry S_k of cluster labels, centroid collapse). This is a composition of two singular models: spectral embedding + k-means. The composite RLCT involves the product fiber structure.

## C1-C5 Claims

### C1 (Definability): CONJECTURED PROVABLE
The spectral clustering loss (relaxed NCut) is a rational function of eigenvectors, which are algebraic functions of Laplacian entries. Laplacian entries are polynomial in similarity weights. Similarity weights are exp(-||x_i-x_j||^2/sigma^2), which is R_an,exp-definable. The eigenvector map (as roots of characteristic polynomial) is algebraic, hence definable. The relaxed NCut objective y^T L y / y^T D y is rational (definable away from y^T D y = 0). k-means loss is piecewise-polynomial (R_an-definable). Composition should preserve definability.

Key challenge: eigenvectors are implicitly defined (as null space of L - lambda I), requiring definable choice or algebraic root extraction. Similar to #887 sigma_i implicit definition but potentially more complex (matrix eigenvectors vs scalar equation).

### C2 (Singular Fiber): CONJECTURAL
The singular fiber has three components:
(a) Rotation fiber: O(k) acts on U_k columns -- loss invariant under U_k -> U_k R for R in O(k). This is a continuous non-identifiability of dimension k(k-1)/2.
(b) Eigenvalue crossing: When lambda_k = lambda_{k+1}, the eigenspace jumps dimension. The eigenvector selection becomes non-unique beyond the O(k) fiber -- any orthonormal basis of the merged eigenspace is valid.
(c) Cluster permutation: k-means post-processing adds S_k permutation fiber (same as #268 GMM).

Composite fiber: O(k) × S_k with eigenvalue-crossing strata as singular locus enhancement. The eigenvalue-crossing stratum has codim 1 (lambda_k - lambda_{k+1} = 0 is a single equation), suggesting RLCT >= 1/2 contribution from this stratum.

### C3 (Stratum Selector): CONJECTURAL
Graph construction parameter sigma_kernel (Gaussian kernel width) as continuous stratum selector:
- sigma large: graph dense, Laplacian eigenvalues compressed, eigenvalue gaps small -- high degeneracy, large lambda
- sigma optimal: eigenvalue gaps maximal, rotation fiber minimal, lambda minimized
- sigma small: graph sparse/disconnected, Laplacian block-diagonal, trivial clusters -- degenerate fiber (disconnected components give exact clustering, but fiber is product of per-component fibers)

k (number of clusters) as discrete stratum selector: choosing k selects which eigenvalue gap matters. Mis-specified k (when true gap is at k* != k) creates large singular fiber.

### C4 (Generalization Bound): CONJECTURAL
G_spec <= lambda_spec * log(n)/(2n) + U_spec / sqrt(n)

where lambda_spec includes:
- O(k) rotation fiber dimension: k(k-1)/2
- Eigenvalue crossing contribution: depends on spectral gap distribution
- k-means centroid collapse: contribution from #268 analysis

U_spec includes:
- Graph spectral gap: n * (lambda_{k+1} - lambda_k) / lambda_n (Cheeger constant proxy)
- Eigenvector stability: ||delta U_k|| ~ ||delta L|| / (lambda_{k+1} - lambda_k) (Davis-Kahan)
- Cluster separation: min_{i!=j} ||mu_i - mu_j|| / max_sigma_i

Key insight: the generalization bound should be inversely proportional to the eigenvalue gap (lambda_{k+1} - lambda_k), connecting spectral clustering quality to RLCT.

### C5 (Phase Transition): CONJECTURAL
Eigenvalue gap phase transition at delta* = lambda_{k+1} - lambda_k:
- delta > delta*: well-separated clusters, rotation fiber minimal, RLCT = k(k-1)/2 + d_kmeans (regular regime)
- delta < delta*: eigenvalue crossing, fiber jumps to O(k+1) or larger, RLCT increases discontinuously
- delta = delta*: phase transition, SGLD LLC shows jump

This connects to the "easier clustering = lower RLCT" principle: well-separated clusters (large gap) yield simpler singular structure.

## Novelty Assessment
- Zero catalog hits for spectral clustering / normalized cut / Laplacian eigenvalue clustering
- Zero SLT/RLCT bridge in literature (websearch confirmed)
- Distinct from #887 (UMAP: fuzzy simplicial set topology vs spectral eigenvalue structure)
- Distinct from #267 (t-SNE: kernel density vs eigenvalue optimization)
- Distinct from #268 (GMM: permutation fiber vs rotation + eigenvalue crossing fiber)
- Distinct from #804 (GNN: message passing vs spectral decomposition)
- Novel contributions: eigenvalue crossing as singular stratum, O(k) rotation fiber, composite spectral + k-means RLCT, eigenvalue gap as generalization predictor

## Cross-references
#8 #16 #57 #88 #100 #267 #268 #350 #804 #887

## Next Steps
L1: Formal definability proof (eigenvector definability via algebraic geometry), formal C2-C5 elaboration with explicit fiber dimension computation.
