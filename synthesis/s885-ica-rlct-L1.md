# Synthesis #885: ICA x RLCT - L1 Formal Definitions

Date: 2026-11-09

## D1: Parameter Space
The ICA parameter space Theta = {W in R^{n x n}, sigma in R_+^n}, where W is the unmixing matrix and sigma = (sigma_1,...,sigma_n) are source scale parameters. The model maps x = A*s where A = W^{-1} is the mixing matrix, s = W*x are recovered sources. Source densities p_k(s_k; sigma_k) are parametric (e.g., logistic with scale sigma_k). Full parameter vector theta = (W, sigma).

## D2: Loss Family
ICA loss L_ICA(theta) = (1/m) sum_{i=1}^{m} [ -log|det(W)| - sum_{k=1}^{n} log p_k(w_k^T x_i; sigma_k) ], where w_k^T is the k-th row of W. The -log|det(W)| term is the Jacobian of the transformation x -> s = Wx. Negentropy-based variants replace log p_k with contrast functions G(u) (e.g., G(u) = log cosh(u)).

## D3: R_an,exp Definability (C1 PROVEN)
- det(W) is a polynomial in entries of W, definable in R_an.
- |det(W)| is subanalytic (composition of polynomial with absolute value).
- log|det(W)| is R_an,exp-definable (log restricted to R_+ is definable).
- Source densities: logistic p(s) = 1/(2sigma) * sech(s/sigma) is analytic; Laplace p(s) = (1/2sigma)*exp(-|s|/sigma) uses |s| (subanalytic) + exp (R_an,exp); Gaussian p(s) uses exp(s^2), definable.
- log p_k is R_an,exp-definable for all standard ICA source densities.
- Finite sum preserves definability.
- Therefore L_ICA(theta) is R_an,exp-definable. RLCT exists and is finite. QED.

## D4: Quotient Singular Fiber (C2 CONJECTURAL)
The zero-loss fiber V_0 = {theta : L_ICA(theta) = 0} contains the non-identifiability quotient:
V_0 = {theta : exists (P, D) in S_n x (R*)^n s.t. W(theta) = P * D * W_0},
where P is a permutation matrix, D = diag(d_1,...,d_n) is a diagonal scaling, and W_0 is the true unmixing matrix.

The fiber decomposes into strata by collision type:
- Generic stratum: all |d_k| distinct, all sources distinct. Fiber = S_n x (R*)^n, dimension n + 0 (S_n discrete).
- Scaling collision stratum: d_i = d_j for some i,j. Reduces permutation ambiguity between sources i,j.
- Proportional source stratum: two sources have proportional distributions (e.g., same family, same scale). Permutation between them becomes continuous (blends into scaling).

The singular locus Sing(V_0) includes the scaling collision stratum where the discrete permutation action becomes degenerate.

Key distinction from #91 (sparse dictionary: K! x 2^K x R^K fiber): ICA has no sparsity constraint, so the fiber is purely the quotient S_n x (R*)^n without the Z_2^K sign component (sign is absorbed into D since d_k can be negative). From #86 (attention: S_H permutation only): ICA adds the continuous (R*)^n scaling dimension.

## D5: Gaussian Fraction as Stratum Selector (C3 CONJECTURAL)
Define g = (1/n) * |{k : p_k is Gaussian}|, the fraction of Gaussian sources.

Non-Gaussian stratum (g=0): The Darmois-Skitovich theorem guarantees identifiability up to S_n x (R*)^n. The fiber is minimal, codim(V_0) = n^2 - n (since dim(S_n x (R*)^n) = n, and dim(Theta) = n^2 + n for W + sigma, but sigma is absorbed into D, so effective dim = n^2, fiber dim = n, codim = n^2 - n).

Gaussian stratum (g >= 1): If n_g sources are Gaussian, the Darmois-Skitovich theorem fails for those components. An O(n_g) rotation group R enters the fiber: W can be replaced by R_g * W where R_g rotates the Gaussian subspace. Fiber dimension increases by n_g(n_g-1)/2.

Stratum lattice: {S_n x (R*)^n x O(n_g) : n_g = 0, 1, ..., n}, with n_g acting as the stratum index. The transition at n_g = 0 -> 1 is discontinuous (discrete jump in fiber dimension).

This is distinct from #884 (CoT: inference-time model-scale phase transition) and #434 (MoE: routing topology stratum). ICA stratum selector is a property of the data distribution (source Gaussianity), not the model.

## D6: Generalization Bound with Non-Identifiability Bias (C4 CONJECTURAL)
Watanabe bound: Gen_ICA <= lambda_ICA / n + U(W, sigma) / sqrt(n),
where lambda_ICA = RLCT of the ICA loss landscape.

The non-identifiability bias term:
U(W, sigma) = dim(fiber) = n + n_g(n_g-1)/2,
where n is from (R*)^n scaling and n_g(n_g-1)/2 is from O(n_g) rotation for Gaussian sources.

At g=0: U = n (scaling only). At g=1 (n_g = 1): U = n + 0 = n (O(1) is trivial). At g >= 2: U = n + n_g(n_g-1)/2 (quadratic growth).

The generalization gap is non-monotone: stable for g=0 and g=1, jumps for g>=2.

## D7: Gaussian Threshold Phase Transition (C5 CONJECTURAL)
For each source k, define a Gaussianity measure gamma_k in [0,1] (e.g., 1 - normalized negentropy). The critical threshold is gamma_k = 1 (exactly Gaussian).

Phase transition: when gamma_k crosses 1 for the first source, the fiber jumps from S_n x (R*)^n to S_n x (R*)^n x O(1) (trivial for single Gaussian). When a second source crosses, fiber jumps to S_n x (R*)^n x O(2), adding 1 dimension.

SGLD signature: The local learning coefficient lambda_hat shows a staircase pattern as sources successively become Gaussian. Each step corresponds to lambda_ICA increasing by the RLCT contribution of the O(n_g) rotation fiber component.

This is an inference-time / data-distribution phase transition, analogous to #884 (CoT emergence as inference-time transition) but driven by source distribution properties rather than model architecture.

## Cross-References
#8 (grokking), #16 (foundational), #49, #86 (attention permutation S_H), #91 (sparse dictionary K!x2^KxR^K), #88 (tensor decomposition), #114 (SAE), #240 (weight tying quotient), #434 (MoE routing), #884 (CoT inference-time phase transition)

## Status
L1 written 2026-11-09. C1 PROVEN, C2-C5 CONJECTURAL. Next: L2 novelty verification.