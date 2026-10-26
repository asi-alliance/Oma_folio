# Synthesis #656: Manifold Mixup × RLCT — L1 Formalization

## Date: 2026-10-26
## Status: L1 — Formal Definitions and Proofs

## Definitions

### D1: Manifold Mixup Forward Pass
Given a neural network f(w, ·) = f_{k+1:L} ∘ ... ∘ f_1 composed of L layers, and two samples (x_a, y_a), (x_b, y_b):

1. Forward both inputs through layers 1..k:
   h_a = f_{1:k}(w, x_a), h_b = f_{1:k}(w, x_b)

2. Interpolate at layer k:
   h_mix = λ · h_a + (1-λ) · h_b, where λ ~ Beta(α, α), α > 0

3. Continue forward pass from layer k+1:
   ŷ = f_{k+1:L}(w, h_mix)

4. Mixed label: y_mix = λ · y_a + (1-λ) · y_b

### D2: Manifold Mixup Loss
L_MM(w) = (1/N) Σ_{(a,b)} ℓ(y_mix, f_{k+1:L}(w, λ·f_{1:k}(w,x_a) + (1-λ)·f_{1:k}(w,x_b)))

where ℓ is cross-entropy with soft labels, which is analytic in logits and polynomial in y_mix.

### D3: Layer-Indexed Singular Fiber
For fixed interpolation layer k and mixing coefficient λ, define:
V_{k,λ}(w) = { w ∈ W : ∇_w L_MM(w) = 0 }

The singular fiber depends on k and λ because:
- Layers 1..k process x_a and x_b separately (two independent analytic maps)
- Layer k performs linear interpolation (polynomial in λ)
- Layers k+1..L process the interpolated point (single analytic map)

The fiber V_{k,λ} is the zero set of an R_an,exp function, hence a real analytic set.

### D4: Transit Singularity
As λ varies continuously from 0 to 1, the interpolated point h_mix(λ) = λ·h_a + (1-λ)·h_b traces a line segment in feature space R^{d_k} (where d_k is the dimension at layer k).

Define the downstream singular strata: S_j = { h ∈ R^{d_k} : f_{k+1:L}(w, h) lies on a singular stratum of the loss ℓ }.

A **transit singularity** occurs when h_mix(λ) crosses S_j for some j as λ varies. At the crossing value λ*, the singular fiber V_{k,λ*} has qualitatively different structure from V_{k,λ*±ε}.

### D5: Effective RLCT as Function of (k, λ)
Define λ_RLCT(k, λ) = RLCT of L_MM(w) at the true parameter W* for interpolation layer k and mixing coefficient λ.

Special cases:
- k=0: λ_RLCT(0, λ) = RLCT of input-space mixup (#258)
- k=L: λ_RLCT(L, λ) = RLCT of output-space interpolation (trivial, only labels mixed)
- Intermediate k: λ_RLCT(k, λ) depends on the geometry of the feature manifold at layer k

### D6: Feature Manifold Curvature
Let M_k(w) = { f_{1:k}(w, x) : x ∈ X } be the feature manifold at layer k. Its curvature κ_k(w) at the interpolation midpoint h_mix(0.5) affects the variance term:

The interpolation line segment h_a → h_b may not lie on M_k. The deviation δ_k = dist(h_mix, M_k) measures how far the interpolated point is from the learned manifold. Higher δ_k means the interpolated sample is more "off-manifold," creating stronger regularization but potentially higher variance.

## Proofs

### P1: Definability (C1 — PROVEN)
**Claim**: L_MM(w) is R_an,exp-definable.

**Proof**: Each component is R_an,exp-definable:
- f_{1:k}(w, x): composition of analytic functions (ReLU/tanh/sigmoid are subanalytic, linear layers are polynomial) → R_an-definable
- λ·h_a + (1-λ)·h_b: polynomial in (h_a, h_b, λ) → R_an-definable
- f_{k+1:L}(w, h_mix): composition of analytic functions → R_an-definable
- ℓ(y_mix, ŷ): y_mix is polynomial in λ, ŷ is analytic in w, cross-entropy is analytic → R_an-definable
- Sum over batch: finite sum of R_an,exp functions → R_an,exp-definable

By closure of R_an,exp under composition, addition, and multiplication, L_MM ∈ R_an,exp. ∎

### P2: Piecewise Analyticity in λ (C2 — PARTIAL)
**Claim**: For fixed w, L_MM as a function of λ is piecewise-analytic with at most |S| transit singularities, where S is the set of downstream singular strata.

**Proof sketch**: L_MM(w, λ) = ℓ(y_mix(λ), f_{k+1:L}(w, h_mix(λ))). Both y_mix and h_mix are polynomial (hence analytic) in λ. f_{k+1:L} is analytic. ℓ is analytic. Composition of analytic functions is analytic. Therefore L_MM(w, λ) is analytic in λ for fixed w.

However, the singular fiber V_{k,λ} changes structure at transit singularities λ* where h_mix(λ*) ∈ S_j. At these points, the local geometry of the loss landscape changes, affecting the RLCT. The RLCT is a function of λ that is piecewise-constant (or piecewise-smooth) with jumps at transit singularities. ∎ (partial — full proof requires resolution of singularities)

### P3: Monotonicity of δ_k in k (C3 — CONJECTURAL)
**Claim**: The off-manifold deviation δ_k is non-monotone in k, with a minimum at some k*.

**Argument**: At k=0, interpolation is in input space — δ_0 is determined by the input distribution geometry. At k=L, δ_L = 0 (interpolation is at output, always on the manifold). At intermediate k, the feature manifold M_k becomes progressively more linearized (deeper representations tend to be more linearly separable). The deviation δ_k depends on both the curvature of M_k and the distance between h_a and h_b. Conjectured: δ_k peaks at intermediate depths where the manifold is most curved, then decreases. The optimal k* minimizes a tradeoff between δ_k (off-manifold penalty) and L-k (downstream depth for smoothing). ∎ (conjectural)

## Generalization Bound (C4 Formalization)

G_MM(n, k, λ) ≤ [λ_RLCT(k, λ) + δ_k · κ_k] · log(n) / (2n) + U(k, λ) / √n

where:
- λ_RLCT(k, λ): effective RLCT of the layer-k-interpolated loss
- δ_k · κ_k: curvature correction — off-manifold deviation × feature manifold curvature at layer k
- U(k, λ): variance term including:
  - Standard empirical process variance
  - Interpolation-induced variance (mixing two samples increases label uncertainty)
  - Depth-dependent correction: U(k, λ) = U_0 + c_1 · (L-k)/L + c_2 · Var(λ)

Key insight: the bound has a **depth-dependent regularization term** (L-k)/L — deeper interpolation means fewer layers benefit from the smoothing effect, reducing the variance reduction from mixup but also reducing the curvature correction.

## Cross-References
#258 (Mixup input space), #532 (CutMix piecewise), #589 (Mixup formalization), #169 (dropout), #100 (LayerNorm), #221 (BatchNorm), #296 (stochastic depth), #485 (RLT loop depth), #8 (weight decay), #16 (standard), #223 (LoRA rank), #334 (self-distillation)
