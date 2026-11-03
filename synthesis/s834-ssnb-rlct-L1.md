#834 Semi-supervised Naive Bayes × RLCT - L1 Formalization

## Definitions
- D1: Model K components, conditionally independent features: p(x|z=k, Θ) = Π_v θ_kv^{x_v}, priors π_k; labeled CE terms Σ_labeled -log p(x_i, y_i|Θ) + unlabeled Σ_unlab -log Σ_k π_k Π_v θ_kv^{x_v}.
- D2: Parameter space Θ = (π_k, θ_kv) in simplices (closed, semialgebraic).
- D3: Zero-loss sets V_0^(α) parameterized by labeled fraction α: anchored fiber = set of Θ with minimal empirical risk at anchor level α.
- D4: Permutation action σ ∈ S_K: (π, θ) → (π_σ, θ_σ). Labeled likelihood is S_K-invariant only up to anchor labeling: fully-labeled limit breaks σ entirely; unlabeled limit leaves full S_K fiber (as in #268).
- D5: Anchored singular stratum: W_0^(α) = V_0^(α) ∩ {Θ : labeled anchor partial-identifiability}; partial fiber F_α ⊆ S_K orbit quotient.
- D6: Effective RLCT λ(α) over the anchored fiber, α ∈ [0,1] continuous selector.
- D7: EM map T_Θ fixed points; basin boundaries as semialgebraic loci.

## Claims
- C1 (PROVEN): Definability in R_an,exp. Labeled terms are finite sums of -log of products of simplex parameters (log-analytic on compact simplex interior, extends as in #268); unlabeled terms are log-sum-exp of the same — exp/log closure, same class as #268/#833. All constraint sets semialgebraic.
- C2 (CONJECTURAL): The latent-label permutation fiber is partially broken by the labeled anchor: F_α is a proper subset of the S_K orbit for 0<α<1. Per #69: fiber dimension alone does not set RLCT; what matters is the KL normal-direction scaling near F_α. Predicted λ(α) strictly between supervised regular value (d/2) and unlabeled mixture value; fiber-type singularity (product-distribution, conditionally independent), DISTINCT from #268 full-covariance mixtures.
- C3 (CONJECTURAL): α as continuous stratum selector interpolating supervised↔mixture singularities; critical α* where anchor first splits the permutation orbit. Sharp vs smooth transition open (cf. #834-L0 Q2).
- C4 (CONJECTURAL): Gen bound G(α) ≤ λ(α)·log(n)/(2n) + misspecification bias; conditional-independence violation constrains strata of the KL support set (Watanabe misspecification theorem applies since true distribution realizable in closure only).
- C5 (CONJECTURAL): EM confirmation bias = attraction to spurious fixed points near wrong strata; T_Θ fixed-point singularities at basin boundaries are the singular locus; soft marginalization distinguishes from #327 hard pseudo-labels.

## Gaps
1. Exact λ(α) via Newton polyhedron: open.
2. Partial fiber F_α geometry (group-subset vs stratified quotient): not computed.
3. α* transition sharpness unproven.
4. Misspecification support-set strata: not formalized.
5. SGLD/LLC estimability after EM pretraining: estimator design open.

## Cross-refs
#268 mixture/EM | #327 pseudo-labels | #69 fiber lesson | #166/#504 MoE routing | #244 multinomial | #833 PCA strata

## Next
L2 novelty verification.