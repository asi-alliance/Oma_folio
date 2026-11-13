## #889: Mean Shift × RLCT — L1 Formalization

Date: 2026-11-09

## D1 (Parameter Space)

Let X = {x_1, ..., x_n} ⊂ R^d be a fixed dataset. The kernel density estimate (KDE) with bandwidth h > 0 and kernel K is:

p_h(μ) = (1/n) Σ_{i=1}^n K_h(x_i - μ), where K_h(z) = (1/h^d) K(z/h)

For Gaussian kernel: K_h(z) = (1/(2πh²)^{d/2}) exp(-||z||²/(2h²)).

The parameter space consists of mode locations and bandwidth:

Θ = {θ = (μ_1, ..., μ_k, h) : μ_j ∈ R^d, h ∈ R_{>0}}

with k = number of modes (endogenous, determined by h and data topology).

Mean shift vector at point μ:
m_h(μ) = (Σ_i x_i K'_h(x_i - μ)) / (Σ_i K'_h(x_i - μ)) - μ

Modes are fixed points: m_h(μ_j) = 0, equivalently ∇p_h(μ_j) = 0.

## D2 (Mean Shift Loss — Formal)

The objective is to maximize the KDE at mode locations (minimize negative KDE):

L_MS(θ) = -(1/k) Σ_{j=1}^k p_h(μ_j) = -(1/(nk)) Σ_{j=1}^k Σ_{i=1}^n K_h(x_i - μ_j)

subject to ∇p_h(μ_j) = 0 (mode constraint) and μ_j distinct.

Equivalently, the Fukunaga-Hostetler mean shift objective:

L_FH(θ) = -(1/n) Σ_{i=1}^n Σ_{j=1}^k 1[||x_i - μ_j|| < r_j] K_h(x_i - μ_j)

where r_j is the basin of attraction of mode j.

The unconstrained relaxation (dropping the mode constraint):

L_rel(θ) = -(1/(nk)) Σ_{j=1}^k Σ_{i=1}^n K_h(x_i - μ_j) + λ_reg Σ_{j≠j'} K_h(μ_j - μ_j')

where the regularization term penalizes mode overlap (repulsion between modes).

## D3 (R_{an,exp} Definability — C1 PROVED)

**Claim C1 (PROVED):** L_MS and L_rel are definable in R_{an,exp}.

**Proof:**
1. Gaussian kernel K_h(z) = (2π)^{-d/2} h^{-d} exp(-||z||²/(2h²)) is R_{an,exp}-definable (exponential of a rational function of z and h).
2. KDE p_h(μ) = (1/n) Σ_i K_h(x_i - μ) is a sum of definable functions, hence definable.
3. ∇p_h(μ) = (1/n) Σ_i K'_h(x_i - μ) · (x_i - μ)/h² is definable (polynomial × exponential, rational in h).
4. L_MS = -(1/k) Σ_j p_h(μ_j) is definable (sum of definable, with 1/k constant).
5. The repulsion term K_h(μ_j - μ_{j'}) is definable (same kernel form).
6. L_rel = L_MS + λ_reg · (repulsion) is definable (sum of definable).
7. Mode constraint set {μ : ∇p_h(μ) = 0} is definable (zero set of definable vector field).

The singular locus includes: (a) mode collision hypersurfaces {μ_j = μ_{j'}} (codim d), (b) critical bandwidth where modes merge (Morse critical points), (c) bandwidth degeneracy h → 0 (KDE → sum of delta functions, not definable at h=0 but definable on h > 0). All definable on the open set h > 0. ∎

## D4 (Singular Fiber — C2 CONJECTURAL)

**Claim C2 (CONJECTURAL):** The singular fiber has two interacting components:

**(a) Mode permutation fiber S_k:** The loss L_MS is invariant under permutation of mode labels σ ∈ S_k: L_MS(μ_1,...,μ_k, h) = L_MS(μ_{σ(1)},...,μ_{σ(k)}, h). This discrete fiber has |S_k| = k! copies. Same permutation symmetry as #872 k-means.

**(b) Mode collision stratum:** When two modes μ_j and μ_{j'} coalesce (μ_j → μ_{j'}), the Hessian of p_h at the merged mode degenerates. Specifically:
- At a non-degenerate mode (Morse critical point), Hess(p_h) has full rank d.
- When two modes merge, Hess(p_h) develops a zero eigenvalue (the direction along which the modes approached), reducing rank by 1.
- The collision locus is {μ_j = μ_{j'}} ⊂ R^{dk}, codimension d.
- At collision: the local RLCT contribution increases because the loss near the collision has a flatter valley (the two-mode configuration space collapses to one).

**Mode degeneracy via Morse theory:** The KDE p_h is a Morse function on R^d for generic h. As h increases, modes merge via saddle-node bifurcations. At each bifurcation:
- A local maximum and a saddle point of p_h annihilate (Morse index changes).
- The Hessian eigenvalue λ_1(Hess p_h) → 0 at the bifurcation point.
- This creates a codim-1 singular stratum in the (μ, h) parameter space.

**Composite fiber:** S_k (discrete) × mode collision strata (continuous, codim-d or codim-1 depending on mechanism).

**RLCT decomposition:**
λ_MS = λ_perm + λ_collision(h)

where λ_perm = 0 (discrete fiber, finite copies — contributes to multiplicity but not to RLCT exponent for real parameters), and λ_collision(h) depends on the Morse degeneracy at bandwidth h.

Conjecture: At non-degenerate modes (generic h), λ_MS = d·k (regular, k modes in R^d, each contributing d/2 from the Gaussian Hessian). At mode collision, λ_MS increases by d/2 (one mode degenerates, adding one flat direction with RLCT contribution 1/2 per dimension → d/2 total for codim-d collision, or 1/2 for codim-1 Morse bifurcation).

## D5 (Bandwidth h as Stratum Selector — C3 CONJECTURAL)

**Claim C3 (CONJECTURAL):** Bandwidth h acts as a continuous U-shaped stratum selector.

For fixed data X with true cluster count k*:

- **h → 0:** KDE approaches sum of delta functions at each data point. Every data point is a mode (k = n). Massive over-segmentation. Hessian at each mode ≈ -I/h² (very sharp, well-conditioned). λ_MS = d·n (n modes, each regular). Large due to n modes.

- **h → h* (optimal):** KDE has exactly k* modes corresponding to true clusters. Modes are well-separated, Hessians full-rank. λ_MS = d·k* (minimal number of well-conditioned modes).

- **h → ∞:** KDE approaches a single Gaussian bump (unimodal). k = 1. All data collapses to one mode. λ_MS = d (single mode). But the mode is very flat (Hessian → 0 as h → ∞), so the effective RLCT increases due to flatness: Hess ≈ -I/(nh²) → 0. The loss becomes increasingly flat, increasing λ via the 1/||Hess|| dependence.

**U-shaped λ(h):**
λ(h) = d·k(h) + C_1·k(h)/h² + C_2·h²

where k(h) = number of modes at bandwidth h (decreasing step function in h), C_1 captures mode sharpness (small h → sharp but many modes), C_2 captures mode flatness (large h → flat single mode).

The dominant term:
- Small h: d·k(h) ≈ d·n → large
- Optimal h*: d·k* → minimal
- Large h: C_2·h² → large (flatness dominates)

This is analogous to #888 (sigma_kernel U-shaped) and #872 (K selector), but the mechanism is Morse-theoretic (mode merging via saddle-node bifurcations) rather than spectral (eigenvalue crossing) or geometric (centroid collision).

## D6 (Generalization Bound — C4 CONJECTURAL)

**Claim C4 (CONJECTURAL):**
G_MS ≤ λ_MS · log(n)/(2n) + U_MS / √n

where:
- λ_MS = d·k(h) + λ_collision(h) from D4-D5
- U_MS = Σ_j 1/|λ_min(Hess p_h(μ_j))| · ||δp||_F

The key term: 1/|λ_min(Hess p_h(μ_j))| is the inverse of the smallest Hessian eigenvalue at mode j. By Morse theory:
- Well-separated modes (optimal h): Hessian eigenvalues large → U_MS small → good generalization
- Approaching collision (h near bifurcation): λ_min → 0 → U_MS → ∞ → poor generalization (instability)
- Over-smoothed (h → ∞): all eigenvalues → 0 → U_MS → ∞ → poor generalization

**Morse index connection:** The Morse index m_j (number of negative Hessian eigenvalues) classifies critical points. Modes are maxima (m_j = 0 for d-dimensional KDE). Saddles have m_j > 0. At bifurcation, mode-saddle pair annihilates. The generalization bound connects Morse stability to learning-theoretic stability.

**Silverman's rule connection:** The optimal bandwidth h* ≈ n^{-1/(d+4)} (Silverman's rule for KDE) minimizes MISE. This provides a data-dependent prediction for the minimum of λ(h).

Two regimes:
- h near h*: G dominated by λ_MS·log(n)/(2n) = d·k*·log(n)/(2n) — complexity term
- h far from h*: G dominated by U_MS/√n ∝ 1/(|λ_min|√n) — instability term

## D7 (Mode Merging Phase Transition — C5 CONJECTURAL)

**Claim C5 (CONJECTURAL):** Phase transition at critical bandwidth h_c where two modes merge (saddle-node bifurcation).

- **h < h_c (two modes):** Regular regime. Two well-separated modes, each with full-rank Hessian. λ_MS = d·k(h). SGLD LLC stable.

- **h → h_c⁻:** Smaller mode's Hessian eigenvalue λ_1 → 0 (mode flattens before vanishing). RLCT increases continuously as λ_1 → 0 (Jacobian of mode location w.r.t. h has factor 1/λ_1).

- **h = h_c (bifurcation):** Phase transition. Mode and saddle annihilate. k(h) decreases by 1. The loss develops a degenerate critical point (non-Morse, Hessian rank d-1). λ_MS jumps: the contribution from the merged region changes from 2·(d/2) = d (two modes) to (d-1)/2 + 1 (one degenerate mode with codim-1 degeneracy) + transition term. Net: λ_MS decreases by ≈ d/2 - 1/2 = (d-1)/2 at the bifurcation (fewer modes but one degenerate).

- **h > h_c (one mode):** New stable regime with k(h) - 1 modes. Regular again until next bifurcation.

**Detection:** SGLD on L_MS for varying h. The LLC profile λ̂(h) should show:
- Step decreases at each h_c (mode merging events reduce k)
- Continuous increases between bifurcations (modes flatten as h grows)
- Overall U-shape (high at small h due to many modes, high at large h due to flatness, minimum at h*)
- Discontinuous jumps at h_c values

This parallels #888 (eigenvalue gap δ = 0 phase transition) and #872 (K* centroid collision), but the mechanism is Morse-theoretic (saddle-node bifurcation in KDE) — a fundamentally different singularity mechanism from spectral or geometric collisions.

**Morse theory bridge:** The Euler characteristic χ(p_h) satisfies χ = Σ_j (-1)^{m_j} (Morse theory). As h increases and modes annihilate with saddles, χ changes. The sequence of bifurcations forms a Cerf theory decomposition of the (μ, h) parameter space, with each bifurcation a codim-1 stratum crossing.

## Status: L1 COMPLETE
Next: L2 novelty verification
