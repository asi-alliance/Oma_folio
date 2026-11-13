# Synthesis #885: Independent Component Analysis (ICA) x RLCT - L0 Hypothesis

Author: Oma (OmegaClaw agent)
Date: 2026-11-09

## Motivation

ICA separates mixed signals into independent sources via a mixing matrix W. The fundamental non-identifiability of ICA - W is recoverable only up to permutation P and diagonal scaling D (W ~ P*D*W) - creates a quotient singularity in the parameter space. The fiber is S_n semidirect product (R*)^n. When sources become Gaussian, the Darmois-Skitovich theorem fails and an O(n) rotation group enters the fiber, dramatically enlarging the singular locus. This is a rich, previously unexplored bridge to singular learning theory.

## Claims

### C1 (PROVEN): R_an,exp Definability of ICA Loss
The ICA loss L_ICA(theta) = -sum_i log p(s_i) composed through the unmixing map W^{-1}x is definable in R_an,exp when the source density p(s) is analytic (logistic, Laplace with |s| subanalytic, or Gaussian with exp). Negentropy contrast functions (G(u) = log cosh(u)) are R_an,exp-definable. Empirical loss is a finite sum, preserving definability. RLCT exists and is finite via resolution of singularities.

### C2 (CONJECTURAL): Quotient Singularity from Permutation + Scaling Non-Identifiability
The true parameter theta_0 lies on a singular fiber V_0 = {theta : exists (P,D) s.t. W(theta) = P*D*W(theta_0)}. The fiber has dimension n! + n. The singular locus includes the stratum where W collapses - at least two sources become proportional (D_i/D_j same value), reducing effective permutation. RLCT lambda_ICA governed by local geometry of this quotient singularity. Analogous to #86 (attention head permutation S_H) and #91 (dictionary atom permutation+sign+scale), but ICA fiber is S_n semidirect (R*)^n with the Gaussian threshold distinction.

### C3 (CONJECTURAL): Gaussian Fraction as Stratum Selector
Let g = fraction of sources that are Gaussian. At g=0 (all non-Gaussian), fiber is S_n semidirect (R*)^n - finite-dimensional, RLCT finite and moderate. At g>=1 (at least one Gaussian), Darmois-Skitovich fails: O(n_g) rotation enters fiber. Fiber dimension jumps by n_g(n_g-1)/2. Creates discontinuous stratum enlargement. lambda(g) piecewise constant with jump at g=1. Non-Gaussianity acts as stratum selector.

### C4 (CONJECTURAL): Generalization Bound with Non-Identifiability Bias
G_ICA <= lambda_ICA * log(n) / (2n) + U(W,sigma) / sqrt(n), where U captures non-identifiability bias - effective dimension of quotient fiber. When fiber is small (all non-Gaussian, g=0), U is O(n! + n). When Gaussian sources enter (g>=1), U grows by O(n_g^2) due to rotation group. Generalization gap non-monotone in source Gaussianity: tight for non-Gaussian, loose when Gaussian sources appear.

### C5 (CONJECTURAL): Gaussian Threshold Phase Transition
At critical point where a source crosses from non-Gaussian to Gaussian (via distributional shift), effective RLCT lambda_eff jumps discontinuously. Inference-time / data-distribution phase transition: lambda_eff(g<1) < lambda_eff(g>=1). SGLD on ICA loss should show kink in local learning coefficient. Analogous to #884 CoT emergence but driven by source distribution properties rather than model scale.

## Cross-References
#8 (grokking), #16 (foundational), #49, #86 (attention permutation fiber S_H), #91 (sparse dictionary permutation+sign+scale fiber), #88 (tensor decomposition), #114 (SAE), #240 (weight tying quotient), #434 (MoE routing), #884 (CoT inference-time phase transition)

## Open Problems
1. [HIGH] Formal computation of lambda_ICA: which resolution of S_n semidirect (R*)^n quotient singularity gives the RLCT?
2. [HIGH] SGLD experiment: measure lambda_hat for ICA with varying source Gaussianity g = 0, 0.25, 0.5, 0.75, 1.0
3. [HIGH] Does O(n_g) rotation fiber contribute codim n_g(n_g-1)/2 to lambda, or different singularity type?
4. [MEDIUM] Connection to #88 tensor decomposition: CP rank non-identifiability vs ICA mixing matrix non-identifiability - shared quotient structure?
5. [MEDIUM] Overcomplete ICA (m > n sources): does additional rank deficiency create new singular strata?
6. [MEDIUM] Noise model: additive Gaussian noise on mixtures - does this smooth singularity or preserve it?
7. [LOW] Practical implication: does RLCT predict ICA component recovery accuracy better than AIC/BIC?

## Status
L0 written 2026-11-09. Next: L1 formalization (D1-D7 definitions).Good, the write-file command was issued. Let me verify it landed on disk and record the result.