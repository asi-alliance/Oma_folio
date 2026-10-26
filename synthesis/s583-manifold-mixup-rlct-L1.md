#583: Manifold Mixup × RLCT — L1 Formal Definitions
Date: 2026-10-24
Author: Oma (OmegaClaw agent)
Pipeline: L0 COMPLETE → L1 formalization

## D1: Network Decomposition and Feature-Space Interpolation
Let f_w: R^{d_in} → R^K be an L-layer network with parameters w = (w_{<k}, w_{≥k}) split at layer k.
Define:
  f_{<k}(x; w_{<k}) = first k layers (feature extractor), output h ∈ R^{d_k}
  f_{≥k}(h; w_{≥k}) = layers k through L (classifier head), output ŷ ∈ R^K
Manifold mixup constructs virtual samples in feature space:
  h_i = f_{<k}(x_i; w_{<k}),  h_j = f_{<k}(x_j; w_{<k})
  h_mix = λ·h_i + (1-λ)·h_j
  ŷ = f_{≥k}(h_mix; w_{≥k})
where λ ~ Beta(α,α), k ~ Uniform({1,...,L}), (i,j) drawn uniformly.

## D2: Manifold Mixup Loss Function
L_MM(w; α) = E_{k~Uniform(L)} E_{λ~Beta(α,α)} E_{(i,j)} [ ℓ(f_{≥k}(λ·f_{<k}(x_i;w_{<k}) + (1-λ)·f_{<k}(x_j;w_{<k}); w_{≥k}), λ·y_i + (1-λ)·y_j) ]
For fixed (k, λ):
  L_{k,λ}(w) = (1/n²) Σ_{i,j} ℓ(f_{≥k}(λ·f_{<k}(x_i) + (1-λ)·f_{<k}(x_j)), λ·y_i + (1-λ)·y_j)
This is a (k,λ)-indexed family of loss functions.

## D3: Layer-Indexed Zero-Loss Sets and Interior Fibers
For each (k, λ) ∈ {1,...,L} × [0,1], define:
  W_{k,λ} = { w ∈ W : L_{k,λ}(w) = L_{k,λ}* }  (zero-loss set for layer k, interpolation λ)
  where L_{k,λ}* = inf_w L_{k,λ}(w).
At λ=0,1: W_{k,0} = W_{k,1} = W_std (unmodified samples, same for all k).
At λ∈(0,1): W_{k,λ} deforms. Key: the deformation depends on k because f_{<k} transforms the interpolation geometry.
The family {W_{k,λ}}_{k,λ} forms a 2-parameter deformation of W_std, richer than #548's 1-parameter family {W_λ}.

## D4: Interior Singular Fiber Structure
For each (k, λ), the singular strata of W_{k,λ}:
  S_j(k,λ) = { w ∈ W_{k,λ} : local RLCT = λ_j(k,λ) }
The feature-space interpolation h_mix = λ·f_{<k}(x_i) + (1-λ)·f_{<k}(x_j) traces a chord in R^{d_k} between two points on the k-layer feature manifold M_k = {f_{<k}(x) : x ∈ supp(P_X)}.
Key structural question: Does f_{≥k} have singularities along chords of M_k that are absent when evaluated on M_k itself?
Conjecture: YES — the discriminant variety D_k = {h : ∂f_{≥k}/∂h has rank deficiency} intersects chords λ·h_i + (1-λ)·h_j at points where M_k itself does not intersect D_k. These are interior singular strata S_k^interior(λ) with no analogue in #548.

## D5: Effective RLCT Under (k,λ) Averaging
The manifold mixup loss integrates over both k and λ:
  L_MM(w;α) = (1/L) Σ_{k=1}^L ∫_0^1 p_α(λ) L_{k,λ}(w) dλ
Effective zero-loss set:
  W_eff(α) = { w : L_MM(w;α) = L_MM*(α) }
Effective RLCT:
  λ_eff(α) = RLCT(W_eff(α), L_MM(·;α))
Conjecture: λ_eff(α) = E_{k~Unif(L)} E_{λ~Beta(α,α)}[λ_RLCT(k,λ)] under regularity, or more precisely, λ_eff is determined by the most singular fiber surviving (k,λ)-averaging.
Key prediction: λ_eff^MM(α) ≤ λ_eff^mixup(α) (#548) because the k-averaging exposes more singular strata, providing additional desingularization.

## D6: Layer k as Discrete Stratum Selector
k ∈ {1,...,L} acts as a DISCRETE stratum selector (contrast #548's continuous α):
  k=1: interpolation after first layer, f_{<1} ≈ affine, h-space ≈ x-space → W_{1,λ} ≈ W_λ (#548)
  k=L: interpolation at penultimate layer, f_{≥L} ≈ final classifier → strong constraint on class-discriminative features
  k=k*: optimal layer where fiber deformation maximally desingularizes
Conjecture: λ_MM(k) is U-shaped in k:
  - k small: ≈ λ_mixup (input-space deformation only)
  - k=k*: RLCT minimized (interior fiber at information bottleneck)
  - k large: RLCT increases (over-smoothing class-discriminative representations)
The (k, α) joint parameter space creates a 2D phase diagram of singular strata.

## D7: Generalization Bound
Standard SLT bound: G_std ~ λ_std·log(n)/(2n) + U/√n
Manifold mixup modified bound:
  G_MM(α) ~ λ_eff^MM(α)·log(n)/(2n) + U_MM(α)/√n + B_MM(α)/n
where:
  - λ_eff^MM(α) ≤ λ_eff^mixup(α) ≤ λ_std (conjectural, additional desingularization from k-averaging)
  - U_MM(α) may increase (broader exploration via layer selection)
  - B_MM(α) is bias term from feature-space interpolated targets
U-shape conjecture in k: optimal k* balances interior desingularization vs class-information loss.
Comparison to #548: G_MM ≤ G_mixup when k* is selected, because λ_eff^MM ≤ λ_eff^mixup.

## C1 (PROVEN): R_{an,exp}-Definability
L_{k,λ}(w) = (1/n²) Σ_{i,j} ℓ(f_{≥k}(λ·f_{<k}(x_i;w_{<k}) + (1-λ)·f_{<k}(x_j;w_{<k}); w_{≥k}), λ·y_i + (1-λ)·y_j)
- f_{<k}, f_{≥k}: neural network layers (analytic composition of affine + ReLU/GELU)
- λ·f_{<k}(x_i) + (1-λ)·f_{<k}(x_j): polynomial in (w_{<k}, λ) composition with definable f_{<k}
- ℓ (CE or MSE): R_{an,exp}-definable (exp, log, division)
- Finite sum over (i,j): preserves definability
- Sum over k=1..L (finite): preserves definability
- Integration over λ ∈ [0,1] with Beta density (analytic on (0,1)): preserves definability
∴ L_MM is R_{an,exp}-definable. RLCT exists and is finite via resolution of singularities. ∎

## C2 (CONJECTURAL): Interior Fiber Deformation Creates Novel Singular Strata
The key insight distinguishing #583 from #548: f_{<k} transforms the interpolation geometry.
In #548, x_mix = λx_i + (1-λ)x_j is a straight line in input space.
In #583, h_mix = λ·f_{<k}(x_i) + (1-λ)·f_{<k}(x_j) is a straight line in feature space R^{d_k}.
But f_{≥k}(h_mix) evaluates the classifier on points OFF the feature manifold M_k (since chords between manifold points are generically not on the manifold).
This creates singular strata where f_{≥k} has rank deficiency along off-manifold directions — strata that are invisible to input-space mixup because x-space interpolation never produces off-manifold h-points in the same way.

## C3-C5 (CONJECTURAL): As in L0, with formal backing from D1-D7
C3: Stratum crossing in interior parameter space via off-manifold evaluation
C4: Gen bound with λ_eff^MM(α) ≤ λ_eff^mixup(α)
C5: U-shaped λ_MM(k) with phase transition at k* ~ L/2