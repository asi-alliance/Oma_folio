# Synthesis #656: Manifold Mixup × RLCT

## Date: 2026-10-26
## Status: L0 — Initial Claims (unverified)

## Topic
Manifold Mixup (Verma et al., 2019) — interpolating hidden representations rather than raw inputs, creating virtual samples in feature space.

## Background
Standard Mixup (#258) interpolates inputs z=λx+(1-λ)y and labels. Manifold Mixup generalizes this by interpolating at an intermediate layer k: h_k = λ·f_k(x) + (1-λ)·f_k(y), then continuing the forward pass from the mixed hidden state. This creates samples that lie on the model's learned manifold rather than in input space.

## RLCT Bridge
Manifold Mixup creates a **layer-indexed family of interpolated loss landscapes**. The interpolation point k determines which layers see mixed vs original data:
- Layers 1..k: process original inputs (two separate forward passes)
- Layer k: interpolation h_k = λf_k(x) + (1-λ)f_k(y)
- Layers k+1..L: process the mixed hidden state

The singular fiber structure depends on k because the interpolation happens at different depths in the network. At layer k, the loss surface undergoes a **fiber merge** — two separate singular fibers (from x and y) are linearly combined, producing a new singular set that is the linear combination of the original fibers. This is fundamentally different from input-space mixup (#258) where the entire network sees the interpolated point.

## Five Claims

### C1 (Definability — PROVEN)
The manifold mixup loss L(w) = Σ_n ℓ(y_n_mix, f_{k+1:L}(w, λf_k(w,x_a) + (1-λ)f_k(w,x_b))) is R_an,exp-definable. f_k is a neural network (analytic composition), linear interpolation is polynomial, f_{k+1:L} is analytic, ℓ is cross-entropy (analytic). The mixture is polynomial in λ. By closure properties, R_an,exp(L) is definable.

### C2 (Singular Fibers — CONJECTURAL)
The interpolation at layer k creates a **merged singular fiber** V_{k,λ} = {w : the interpolated hidden state λf_k(w,x_a) + (1-λ)f_k(w,x_b) lies on a singular stratum of the downstream loss}. The key insight: the singular set at layer k+1 depends on the geometry of the interpolated point, which traces a **line segment in feature space** as λ varies from 0 to 1. This line segment can cross multiple singular strata of the downstream network, creating **transit singularities** — points where the interpolated representation transitions between basins of attraction.

### C3 (Stratum Selector — CONJECTURAL)
The interpolation layer k acts as a **depth-indexed stratum selector**:
- k=0: input-space mixup (= #258, entire network sees mixed input)
- k=L: output-space mixup (only logits are mixed, trivial)
- Intermediate k: mixed representations at varying depth

The effective RLCT λ(k) depends on k because deeper interpolation (higher k) means fewer layers process the mixed representation, potentially creating simpler singular structure. Conjectured: λ(k) is non-monotone — there may be an optimal k* that minimizes λ by placing interpolation at a depth where the feature manifold is most regular.

### C4 (Generalization Bound — CONJECTURAL)
G_MM(n,k,λ) ≤ λ(k,λ) · log(n) / (2n) + U(k,λ) / √n

where λ(k,λ) is the RLCT of the layer-k-interpolated loss. Key novel term: **interpolation depth correction** — the variance term U(k,λ) includes a term proportional to the curvature of the feature manifold at layer k, because high-curvature regions amplify the effect of interpolation. Deeper interpolation (high k) reduces this curvature term but may increase λ by placing interpolation closer to the singularity.

### C5 (Phase Transition — CONJECTURAL)
Critical depth k* exists where the interpolation creates the most regularizing singularity:
- k < k*: interpolation too early, feature space still close to input space (similar to #258)
- k > k*: interpolation too late, too few layers benefit from the smoothing
- k = k*: optimal tradeoff between manifold smoothness and downstream depth

Predicted: k* ~ L/2 (middle layers), testable via SGLD comparing LLC across interpolation depths.

## Seven Open Problems

1. How does the merged singular fiber V_{k,λ} relate to the individual fibers V_x and V_y? Is it a linear combination, or does the merge create qualitatively new singularities?
2. Does the transit singularity (line segment crossing strata) have a distinct RLCT from the endpoint singularities?
3. Is λ(k) truly non-monotone? What determines k* — is it layer depth, feature dimensionality, or manifold curvature?
4. How does manifold mixup interact with batch norm (#221) or layer norm (#100) at the interpolation point? Does normalization change the merged fiber geometry?
5. Relationship to CutMix (#532): CutMix creates spatial piecewise interpolation (non-smooth cut), manifold mixup creates smooth feature interpolation. Is the RLCT of smooth interpolation strictly lower than piecewise?
6. Can the interpolation layer k be learned adaptively using RLCT as objective? Does a per-sample k(x) improve generalization?
7. Experimental prediction: SGLD on manifold mixup models at varying k should show λ(k) with a minimum at k*. Can this be measured?

## Cross-References
#258 (Mixup input space), #532 (CutMix piecewise), #589 (Mixup formalization), #169 (dropout), #100 (LayerNorm), #221 (BatchNorm), #296 (stochastic depth), #485 (RLT loop depth), #8 (weight decay), #16 (standard), #223 (LoRA rank), #334 (self-distillation)

## Key Novelty
Manifold Mixup is the first synthesis to analyze **feature-space interpolation depth** through RLCT. Unlike input-space mixup (#258, interpolation before all layers) and CutMix (#532, piecewise spatial cut), manifold mixup interpolates at a chosen depth k, creating a **layer-indexed family of singular fibers**. The transit singularity concept — where an interpolated representation crosses stratum boundaries as λ varies — is unique to this synthesis and absent from all 655 prior entries.
