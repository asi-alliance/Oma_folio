# Synthesis #822: Manifold Mixup × RLCT - L0 Exploration

## Date: 2026-10-29
## Status: L0 Exploration

## Technique
Manifold Mixup (Verma et al., 2019): instead of interpolating raw inputs z=λx+(1-λ)y, interpolate hidden representations h=λh_i+(1-λ)h_j at a randomly selected layer k. The mixed hidden state passes through remaining layers, producing predictions for a mixed target λy_i+(1-λ)y_j.

## Key RLCT Bridge
Input-space mixup (#258) creates λ-parameterized singular fibers in the data manifold. Manifold mixup creates singular fibers in the COMPOSITION manifold — the preimage of interpolation in the hidden space under the encoder map. This is qualitatively different:

1. Hidden-space interpolation creates singular fibers in f_k^{-1}(λh_i+(1-λ)h_j), the preimage of a line segment in feature space under the first k layers.
2. The singular structure depends on WHICH LAYER k is chosen — k acts as a DISCRETE stratum selector in addition to the continuous λ.
3. Deeper layers have more compressed/smoothed representations, potentially creating simpler (lower λ) singular fibers.
4. The composition through remaining layers f_{>k} adds further singularity structure via the pushforward.

## Candidate Claims C1-C5
C1 (PROVABLE): Manifold mixup loss is R_{an,exp}-definable. Hidden interpolation is polynomial (affine), ReLU/SwiGLU activations are subanalytic, composition preserves definability.

C2 (CONJECTURAL): The zero-loss fiber V_k(λ) = {θ : f_{>k}(λh_i(θ)+(1-λ)h_j(θ)) = λy_i+(1-λ)y_j} has singular structure determined by layer k. Deeper k → lower-dimensional effective fiber → lower λ_k. Conjecture λ_k decreases with k (deeper interpolation → simpler singularity).

C3 (CONJECTURAL): Layer index k acts as discrete stratum selector. λ_k (RLCT at layer k) forms a descending sequence λ_1 >= λ_2 >= ... >= λ_L where L is depth. Combined with continuous λ, the effective RLCT is λ_eff(k,λ) = λ_k(λ).

C4 (CONJECTURAL): Generalization bound E[L_test] <= E[L_train] + C*sqrt(λ_eff(k,λ)*log(n)/n). Optimal (k*,λ*) trades off interpolation smoothness (deeper k) against label mixing diversity (λ near 0.5). Predicts optimal manifold mixup layer is mid-depth.

C5 (CONJECTURAL): Phase transition at critical layer k* detectable via SGLD LLC estimation. LLC should show step-like decrease as k increases past k*, reflecting stratum simplification.

## Distinction from #258 (Input-Space Mixup)
- #258: interpolation in input space X, singular fibers in data manifold
- #822: interpolation in hidden space H_k, singular fibers in composition preimage f_{≤k}^{-1}(line segment)
- #822 has DUAL stratum selectors: discrete k + continuous λ
- #822 singular structure depends on encoder geometry (first k layers), not just data geometry

## Distinction from Other Catalog Entries
- #169 Dropout: stochastic masking, no interpolation
- #222 Spectral Norm: operator constraint, not interpolation
- #658 Weight Standardization: normalization constraint, not interpolation
- #480 muP: parametrization, not data augmentation

## Open Problems
1. Monotonicity of λ_k with depth: does deeper interpolation always simplify singularity?
2. Interaction between k and λ: is λ_eff(k,λ) separable or coupled?
3. Connection to #258: is manifold mixup a strict generalization (k=0 recovers input mixup)?
4. Layer selection distribution: uniform random vs learned — different stratum selection?
5. Connection to feature space smoothness: Lipschitz constant of f_{≤k} and its effect on λ_k
6. Multi-layer mixup (interpolating at multiple layers simultaneously): new fiber structure?
7. Relationship to #173 SAM: does flat-minima + manifold mixup create compound singularities?

## Cross-References
#258 (input mixup), #169 (dropout), #222 (spectral norm), #480 (muP), #658 (weight std), #173 (SAM), #590 (adversarial training)
