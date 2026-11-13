#872: K-Means Clustering × RLCT — L0 Rough Paths

## Topic Motivation
K-Means clustering minimizes the sum of squared Euclidean distances to K centroids via Lloyd's algorithm (alternating assignment and update). The loss function L_KM = (1/n)Σ_i min_k ||x_i - μ_k||² is piecewise quadratic in centroid parameters {μ_k}, with assignment discontinuities at Voronoi boundaries. Unlike VQ-VAE (#556, learned codebook via gradient descent with STE) or spectral clustering (#266, Laplacian eigenvectors), k-means uses exact coordinate descent on a non-smooth objective, creating singularities at three levels: (1) Voronoi boundary crossings (assignment non-identifiability), (2) empty-cluster degeneracy (rank drop), (3) centroid collision (K_eff < K, label permutation symmetry). No prior work connects k-means to singular learning theory.

## C1 (PROVEN): R_an,exp definability of L_KM
L_KM = (1/n)Σ_i min_k ||x_i - μ_k||². The min over k of squared norms is a piecewise-semialgebraic function (finite minimum of polynomials). Each ||x_i - μ_k||² is a polynomial in μ_k. The min of finitely many R_an,exp-definable functions is R_an,exp-definable (o-minimal structure closure under finite min). Thus L_KM ∈ R_an,exp. Standard pattern (same as #556, #864).

## C2 (CONJECTURAL): Voronoi boundary singular fiber
The zero-loss set V = {μ : Σ_i min_k ||x_i - μ_k||² = 0} requires each x_i to coincide with some μ_k, so V is empty for generic data. The singular fiber is better characterized as the critical fiber V_c = {μ : L_KM = c} for c near the infimum. At Voronoi boundaries where x_i is equidistant to two centroids, the assignment is non-unique, creating a non-smooth ridge in the loss surface. The local geometry near these ridges has RLCT λ_KM determined by the codimension of the Voronoi boundary intersection and the quadratic contact order. Conjecture: λ_KM = d·(K_eff) where K_eff is the number of non-empty, non-collided clusters, modulated by boundary geometry.

## C3 (CONJECTURAL): K as discrete stratum selector
K (number of clusters) acts as a discrete stratum selector: for fixed data, different K values yield different singular fiber structures. When K exceeds the true number of well-separated clusters K*, centroid collision creates permutation symmetry (S_K/S_K_eff quotient), increasing effective RLCT via the orbit structure. When K < K*, forced merging of clusters creates high-residual fibers with different singularity type. Conjecture: λ(K) = d·min(K, K*) + (K - K*)·d_collision where d_collision is the collision singularity RLCT contribution. This parallels #870 (G as stratum selector) and #871 (K as context window) but via a fundamentally different mechanism: combinatorial assignment geometry.

## C4 (CONJECTURAL): Generalization bound with clustering bias
The gen bound for k-means should take the form: G(K) = λ(K)·log(n)/(2n) + U(K)/√n + B(K,K*) where U(K) is the variance term from Voronoi boundary fluctuations and B(K,K*) is the model misspecification bias when K ≠ K*. When K > K*, the bias B is dominated by collision redundancy (redundant centroids add complexity without reducing bias). When K < K*, B is dominated by cluster merging error. The optimal K* minimizes the bias-complexity tradeoff. Novel feature: B(K,K*) has a discontinuous derivative at K=K* (phase transition).

## C5 (CONJECTURAL): Phase transition at K*
At K = K* (true number of clusters), the singular fiber undergoes a topological change: for K < K*, the fiber has merging singularities (multiple data clusters assigned to one centroid); for K > K*, collision singularities appear (multiple centroids at same location). K* is detectable via SGLD: the LLC (learning coefficient) estimated via SGLD shows a discontinuity or sharp gradient change at K*. This is analogous to #556 codebook collapse phase transition but for fixed-assignment (non-learned) clustering. Distinct from spectral clustering (#266) which has no discrete K stratum selector in the same sense.

## Overlap Analysis
- #556 VQ-VAE: Learned codebook via gradient descent + STE. K-means uses exact coordinate descent (Lloyd's). VQ-VAE has continuous embedding space; k-means operates directly in data space. DIFFERENT optimization landscape.
- #266 Spectral Clustering: Uses Laplacian eigenvectors, no centroid parameterization. DIFFERENT loss structure (eigendecomposition vs min-distance).
- #864 Center Loss: Learns class prototypes with CE loss. K-means has no supervised labels — unsupervised prototype discovery. DIFFERENT (no CE component).
- #434 MoE: Gating network routes to experts. K-means has hard assignment (no gating). DIFFERENT (hard vs soft routing).

## 7 Open Problems
1. RLCT of Voronoi boundary crossing — is it determined by codimension alone or does data geometry matter?
2. Collision singularity RLCT — what is d_collision exactly? Is it always d (full-dimensional)?
3. SGLD detectability of K* — does the LLC discontinuity survive finite-sample noise?
4. Label permutation symmetry quotient — does S_K quotient factor appear in RLCT as in algebraic statistics?
5. Empty-cluster degeneracy — is this a measure-zero singularity or a stable stratum?
6. K-means++ initialization — does initialization distribution affect which stratum is reached ( basin of attraction in singular landscape)?
7. Mini-batch k-means — does stochastic approximation change the RLCT (analogous to SGD noise in #533)?

## Cross-Refs
#556 #266 #864 #434 #870 #871 #570 #533 #100 #379

## Status: L0 COMPLETE
Next: L1 formalization