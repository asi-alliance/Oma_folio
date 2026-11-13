#888: Spectral Clustering × RLCT — L1 Formalization

## D1 (Parameter Space)
Let X = {x_1, ..., x_n} ⊂ R^d be a fixed dataset. Construct a similarity graph G with weighted adjacency W ∈ R^{n×n}, degree matrix D = diag(d_1, ..., d_n), d_i = Σ_j w_{ij}. The normalized Laplacian is L_sym = D^{-1/2} (D - W) D^{-1/2} = I - D^{-1/2} W D^{-1/2}.

The parameter space is the set of k-dimensional subspace embeddings:
Θ = {U ∈ R^{n×k} : U^T D U = I_k, columns of U are D-orthonormal}

This is the Stiefel manifold St_D(k, n) = {U : U^T D U = I_k}, a compact manifold of dimension nk - k(k+1)/2. The effective parameter dimension is nk - k(k-1)/2 (accounting for O(k) gauge).

Additional parameters: graph construction parameters (sigma_kernel for Gaussian kernel, k_NN for kNN graph) and k-means centroids M = (μ_1, ..., μ_k) ∈ R^{d×k} for post-processing.

Full parameter: θ = (U, M, sigma_kernel) with sigma_kernel as hyperparameter/stratum selector.

## D2 (Spectral Clustering Loss — Formal)
The relaxed normalized cut objective:
L_spec(U) = Tr(U^T L_sym U) = Σ_{j=1}^{k} u_j^T L_sym u_j

subject to U^T D U = I_k (orthogonality constraint).

The full composite loss including k-means post-processing:
L_comp(U, M) = Tr(U^T L_sym U) + γ · L_KM(Z(U), M)

where Z(U) = row-normalized U (for k-means input), L_KM is the k-means loss from #872, and γ ≥ 0 is a coupling weight. In practice, spectral clustering solves these sequentially (first U, then M), but the composite objective captures both singularities.

The Rayleigh quotient form for each cluster:
R_j = (u_j^T L_sym u_j) / (u_j^T D u_j)

Minimizing Σ_j R_j subject to D-orthogonality yields U = bottom k eigenvectors of L_sym.

## D3 (R_{an,exp} Definability — C1 PROVED)
**Claim C1 (PROVED):** L_spec and L_comp are definable in R_{an,exp}.

**Proof:**
1. Similarity weights: w_{ij} = exp(-||x_i - x_j||^2 / (2σ^2)) is R_{an,exp}-definable (exponential of polynomial).
2. Laplacian entries: L_sym[i,j] = δ_{ij} - w_{ij}/√(d_i d_j). The function 1/√x is definable on (0,∞) (sub-analytic). Products and sums preserve definability. So L_sym is a definable matrix-valued function of (W, σ).
3. Eigenvectors: The characteristic polynomial p(λ) = det(L_sym - λI) is a polynomial in entries of L_sym and λ. Its roots are algebraic functions of L_sym entries. By the Wilkie theorem (o-minimality of R_{an,exp}), algebraic functions (solutions of polynomial equations on semialgebraic sets) are definable via definable choice. The eigenvector u_j (as null vector of L_sym - λ_j I) is definable away from eigenvalue crossings (where the null space dimension jumps).
4. At eigenvalue crossings (λ_j = λ_{j+1}), the eigenvector is non-unique (any orthonormal basis of the eigenspace). The set of crossings is semialgebraic (det discriminant = 0). On each open stratum where eigenvalues are distinct, eigenvectors are analytic functions of L_sym entries.
5. L_spec = Tr(U^T L_sym U) is a polynomial in (U, L_sym), hence definable.
6. L_KM is piecewise polynomial (proven in #872 D3).
7. Composition: L_comp = L_spec + γ L_KM(Z(U), M) is definable (sum of definable functions, Z(U) = normalization is definable away from zero rows).

The singular locus includes: (a) eigenvalue crossing hypersurfaces {det_disc(L_sym) = 0}, (b) Voronoi boundaries from k-means (per #872), (c) zero-row degeneracy of U. All definable. ∎

## D4 (Singular Fiber — C2 CONJECTURAL)
**Claim C2 (CONJECTURAL):** The singular fiber has three interacting components:

**(a) Rotation fiber O(k):** The loss L_spec(U) = Tr(U^T L_sym U) is invariant under U → U R for any R ∈ O(k) (since Tr(U^T L_sym U) = Tr(R^T U^T L_sym U R) = Tr(U^T L_sym U)). This O(k) gauge symmetry has dimension k(k-1)/2. The true parameter space is the quotient Θ/O(k) = Gr_D(k, n) (the D-weighted Grassmannian).

**(b) Eigenvalue crossing stratum:** When λ_k = λ_{k+1} (the k-th eigenvalue gap closes), the eigenspace E_{≤k} = span(u_1, ..., u_k) becomes non-unique: it can be any k-dimensional subspace of E_{≤k+1}. The fiber dimension jumps from k(k-1)/2 (O(k) rotation within fixed subspace) to (k+1)k/2 (O(k+1) rotation within merged eigenspace). The crossing locus is {L_sym : λ_k(L_sym) = λ_{k+1}(L_sym)}, a codimension-1 semialgebraic set (vanishing of eigenvalue gap). RLCT contribution from this stratum: ≥ 1/2 (codim-1, generically transverse).

**(c) k-means permutation fiber S_k:** After spectral embedding, k-means adds S_k permutation symmetry (per #872 D4). Cluster labels are non-identifiable, adding discrete fiber of |S_k| = k! copies.

**Composite fiber structure:** O(k) × S_k with eigenvalue-crossing enhancement. The composite RLCT:
λ_spec = k(k-1)/2 (rotation) + λ_crossing + λ_kmeans

where λ_kmeans = d·k_eff (from #872 D4, with K=k) and λ_crossing depends on eigenvalue gap distribution.

Conjecture: At the global minimum (U* = bottom k eigenvectors with distinct eigenvalues), λ_spec = k(k-1)/2 + d·k (rotation fiber + k-means regular). At eigenvalue crossing, λ_spec jumps by k/2 (additional rotation in merged eigenspace).

## D5 (sigma_kernel as Stratum Selector — C3 CONJECTURAL)
**Claim C3 (CONJECTURAL):** Graph construction parameter sigma_kernel acts as a continuous stratum selector.

For fixed data X with true cluster count k*:
- **sigma → ∞:** Graph fully connected with uniform weights. L_sym → I - (1/n)11^T (rank 1 perturbation of identity). All eigenvalues except λ_1 ≈ 0 are ≈ 1. Eigenvalue gaps vanish. Fiber: O(n-1) rotation (maximal degeneracy). λ → (n-1)(n-2)/2 (huge).
- **sigma → sigma*:** Graph captures local manifold structure. Eigenvalue gap δ* = λ_{k*+1} - λ_{k*} is maximized. The bottom k* eigenvectors align with cluster structure. Rotation fiber minimal: O(k*). λ = k*(k*-1)/2 + d·k*.
- **sigma → 0:** Graph disconnected (each point isolated). L_sym → I (all eigenvalues = 1, λ_1 = 0). Trivial clusters. Fiber: O(n-1) degeneracy again. λ → (n-1)(n-2)/2.

Conjectured scaling: λ(sigma) is U-shaped with minimum at sigma*:
λ(sigma) = k*(k*-1)/2 + d·k* + C_1/σ² + C_2·σ²

where C_1 captures density variation (too-small sigma creates fragmentation) and C_2 captures over-smoothing (too-large sigma merges clusters).

k (number of clusters) as discrete selector: choosing k selects which eigenvalue gap (λ_{k+1} - λ_k) matters. If k = k* (true cluster count), the gap is maximal. If k ≠ k*, the gap is smaller or zero, increasing λ.

This is analogous to #887 (n_neighbors as graph topology selector) but operates on spectral gap rather than graph connectivity directly.

## D6 (Generalization Bound — C4 CONJECTURAL)
**Claim C4 (CONJECTURAL):**
G_spec ≤ λ_spec · log(n)/(2n) + U_spec / √n

where:
- λ_spec = k(k-1)/2 + d·k + λ_crossing(σ) from D4-D5
- U_spec = U_spectral + U_kmeans:
  - U_spectral = (1/δ) · ||δL||_F where δ = λ_{k+1} - λ_k (eigenvalue gap), ||δL|| ~ √(n/σ²) (spectral perturbation from data noise). Davis-Kahan: ||δU_k|| ≤ ||δL|| / δ.
  - U_kmeans = (boundary points) / √n (from #872 D6)
- Graph spectral gap term: the Cheeger constant h(G) = min |∂S| / min(vol(S), vol(Ṡ)) relates to δ = λ_{k+1} - λ_k via Cheeger inequality: 2h ≥ δ ≥ h²/2. So U_spectral ∝ 1/h(G).

Key insight: G_spec ∝ 1/δ = 1/(λ_{k+1} - λ_k). Well-separated clusters (large δ) → small generalization gap. This connects spectral clustering quality (eigengap) directly to RLCT generalization bound.

The bound has two regimes:
- δ large (well-separated): G dominated by λ_spec·log(n)/(2n) — complexity term
- δ small (overlapping): G dominated by U_spec/√n ∝ 1/(δ√n) — instability term

## D7 (Eigenvalue Gap Phase Transition — C5 CONJECTURAL)
**Claim C5 (CONJECTURAL):** Phase transition at δ* = λ_{k+1} - λ_k = 0 (eigenvalue crossing).

- **δ > 0 (well-separated):** Regular regime. Rotation fiber = O(k), λ = k(k-1)/2 + d·k. SGLD LLC stable at this value.
- **δ → 0 (approaching crossing):** Eigenvector subspace becomes ill-conditioned. RLCT increases continuously as δ → 0 (the Jacobian of eigenvector map w.r.t. L_sym has factor 1/δ).
- **δ = 0 (crossing):** Phase transition. Fiber jumps from O(k) to O(k+1). λ jumps by k/2 (additional k rotation degrees of freedom). SGLD LLC shows discontinuous jump.
- **δ < 0 (crossed):** Eigenvalues reorder, k-th eigenvector changes identity. New stable regime with O(k) fiber on new subspace.

Detection: SGLD on L_spec for varying σ (which controls δ). The LLC profile λ̂(σ) should show:
- U-shape with minimum at σ* (where δ maximized)
- Jump discontinuity at σ values where δ = 0
- High values at extremes (σ → 0, σ → ∞)

This parallels #872 (K* phase transition at k-means collision) but the mechanism is spectral (eigenvalue crossing) rather than geometric (centroid collision). Also distinct from #887 (min_dist topological transition) — here the transition is in eigenvalue space, not embedding space.

## Status: L1 COMPLETE
Next: L2 novelty verification
