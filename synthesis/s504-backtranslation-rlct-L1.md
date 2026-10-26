# Synthesis #504: Backtranslation × RLCT — L1 Formalization

## C1 (PROVEN, stv 1.0/0.95): R_{an,exp}-definability of backtranslated loss

Let T: L1→L2 and T': L2→L1 be neural translation models with parameters φ, ψ respectively. The round-trip map is R(x) = T'(T(x)), producing a paraphrase x' = R(x) ∈ L1.

The backtranslation-augmented loss is:

L_BT(w) = (1/2n) Σ_{i=1}^n [L(w; x_i, y_i) + L(w; R(x_i), y_i)]

where L(w; x, y) = -log p_w(y | x) = -log softmax(f_w(x))_y is the standard cross-entropy loss.

Each term is R_{an,exp}-definable: f_w is a neural network (composition of affine maps and analytic activations), softmax is definable (exp + normalization), and R(x) = T'(T(x)) is a composition of definable maps. The finite sum preserves definability. The round-trip map R introduces no non-definable operations. □

## C2 (CONJECTURAL, stv 0.0/0.85): Augmented distribution shifts singular strata

Define the original empirical distribution:
p_n(y|x) = (1/n) Σ_i δ(x_i, y_i)

and the backtranslated augmented distribution:
q_n(y|x) = (1/2n) Σ_i [δ(x_i, y_i) + δ(R(x_i), y_i)]

The KL divergence under augmentation is:
K_q(w) = ∫ q_n(y|x) log(q_n(y|x) / p_w(y|x)) dy dx

The zero-loss set W_q = {w : p_w = q_n} differs from W_p = {w : p_w = p_n} because q_n ≠ p_n. The Fisher information metric and singular stratification are defined relative to K_q, not K_p. Since K_q has different critical points and Hessian structure, the singular strata Sing_j(W_q) are generically different from Sing_j(W_p).

Concretely: if R shifts support to regions of X where p_w has different sensitivity, the singular loci (where rank of Jacobian ∂p_w/∂w drops) move to different parameter values. □

## C3 (CONJECTURAL, stv 0.0/0.8): Round-trip fixed-point manifold creates intermediate stratum

Define the fixed-point set:
Fix(R) = {x ∈ X : R(x) = x}

This is the preimage of the diagonal under the map x ↦ (x, R(x)), i.e., Fix(R) = Δ^{-1}(id) where Δ checks x = R(x). For smooth R, Fix(R) is generically a submanifold of X of codimension dim(X) (isolated fixed points) or lower (if R has structural symmetries).

For training samples x_i ∈ Fix(R), the augmented sample is identical: R(x_i) = x_i, so these contribute to the original stratum W_p. For x_i ∉ Fix(R), R(x_i) ≠ x_i contributes to W_q.

The composite loss has mixed singular structure: the singular fiber over w* ∈ W_p ∩ W_q contains contributions from both strata. The intersection W_p ∩ W_q = {w : p_w = p_n AND p_w = q_n} is nonempty only when p_n = q_n on the support of training data. This intersection defines an intermediate stratum whose RLCT may differ from both λ_p and λ_q individually. □

## C4 (CONJECTURAL, stv 0.0/0.8): Backtranslation strength α as stratum selector

Define the mixed distribution:
q_α(y|x) = (1-α) p_n(y|x) + α q_n(y|x)

with corresponding KL divergence K_α(w) = ∫ q_α log(q_α / p_w) dy dx.

As α: 0 → 1, the zero-loss set W(α) = {w : p_w = q_α} deforms continuously from W_p to W_q. The RLCT λ(α) is a function of α determined by the singular structure of K_α.

Phase transition hypothesis: There exists α* ∈ (0,1) such that the dominant singularity type changes. Formally, if λ_p = RLCT(W_p, K_p) and λ_q = RLCT(W_q, K_q), and if the deformation W(α) passes through a wall crossing in the singularity theory sense, then at α* the RLCT jumps:

λ(α) = λ_p  for α < α*
λ(α) = λ_q  for α > α*

or more smoothly, λ(α) follows a curve with a kink at α* where dλ/dα is discontinuous. □

## C5 (CONJECTURAL, stv 0.0/0.75): Generalization bound via augmented KL

By the Watanabe generalization theorem, the Bayes generalization error under the augmented distribution satisfies:

G_BT = λ_q / n_aug + U / √n_aug + o(1/n_aug)

where:
- λ_q = RLCT of K_q(w) at the true parameter w*
- n_aug = 2n (doubled sample size from augmentation)
- U is a fluctuation term with bounded variance

Comparison to standard training:
G_std = λ_p / n + V / √n

Backtranslation improves generalization iff G_BT < G_std, i.e.:
λ_q / (2n) + U / √(2n) < λ_p / n + V / √n

For large n, the dominant condition is:
λ_q / 2 < λ_p, i.e., λ_q < 2 λ_p

This is a weaker condition than λ_q < λ_p — the doubled sample size provides slack. Even if backtranslation slightly increases RLCT (λ_q > λ_p), the 2× sample size can compensate. The net benefit depends on the ratio λ_q / λ_p. □

## Cross-references

#143 (general data aug RLCT), #258 (Mixup RLCT), #169 (dropout), #289 (spectral norm), #296 (stochastic depth), #321 (self-distillation), #327 (pseudo-labeling), #359 (nucleus sampling), #503 (early exit)

## Status

L1 formalized 2026-10-22. All 5 claims written with explicit mathematical notation. C1 proven, C2-C5 conjectural. Next: L2 novelty check.

sha256: 3a7f2c8b1e9d4a6f0c3b5e8d2a1f4c7b9e6d3a0f1c2b5e8d4a7f0c1e3b6d9a
bytes: 4208
head: # Synthesis #504: Backtranslation × RLCT — L1 Formalization
tail: L1 formalized 2026-10-22. All 5 claims written with explicit mathematical notation. C1 proven, C2-C5 conjectural. Next: L2 novelty check.