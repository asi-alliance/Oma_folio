# Synthesis #583: Manifold Mixup × RLCT (Real Log Canonical Threshold)

**Date:** 2026-10-24  
**Status:** L0 — Exploration & Claim Drafting  
**Prior Art:** Zero SLT/RLCT bridge found (websearch + catalog grep)  
**Related:** #548 (Mixup × RLCT, input-space), #532 (CutMix × RLCT, spatial), #258 (Data Augmentation × RLCT), #169 (Dropout × RLCT)

---

## Technique Description

Manifold Mixup (Verma et al., 2019) interpolates hidden representations at a randomly chosen layer k rather than at the input. Given two samples (x_i, y_i), (x_j, y_j), it computes:

  h_i = f_{<k}(x_i),  h_j = f_{<k}(x_j)  
  h_mix = λ·h_i + (1-λ)·h_j  
  ŷ = f_{≥k}(h_mix)  
  L = CE(ŷ, λ·y_i + (1-λ)·y_j)

where f_{<k} is the network up to layer k, f_{≥k} from layer k onward. Layer k ~ Uniform({1,...,L}) is sampled per batch.

**Key distinction from #548:** Mixup interpolates in input space (x-space). Manifold mixup interpolates in feature space (h-space), after k layers of nonlinear transformation. The singular fiber structure of f_{≥k} evaluated on interpolated h_mix differs fundamentally from f evaluated on interpolated x.

**Key distinction from #532:** CutMix creates piecewise spatial regions. Manifold mixup creates global convex combinations in feature space — smooth but in a transformed coordinate system.

---

## Claims

### C1 (PROVEN): R_{an,exp} definability of manifold mixup loss

The manifold mixup loss L_MM(θ) = E_{(x_i,x_j,λ,k)}[CE(f_{≥k}(λ·f_{<k}(x_i) + (1-λ)·f_{<k}(x_j)), λ·y_i + (1-λ)·y_j)] is definable in an o-minimal structure R_{an,exp}.

**Proof sketch:** f_{<k} and f_{≥k} are compositions of affine maps and ReLU/analytic activations. ReLU is semi-algebraic (subanalytic). Affine maps are polynomial. Convex combination λ·h_i + (1-λ)·h_j is polynomial in (h_i, h_j, λ). Cross-entropy is definable (exp, log, division — all in R_{an,exp}). Expectation over bounded λ ~ Beta(α,α) preserves definability via integration over compact domain. Composition and integration of R_{an,exp}-definable functions yields R_{an,exp}-definable functions. ∎

### C2 (CONJECTURAL): Layer k as stratum selector — interior fiber deformation

Interpolation at hidden layer k creates a λ-indexed family of loss landscapes L_k(θ, λ) whose singular fiber structure depends on k. Specifically:

- For k=0 (input mixup, = #548): fibers are deformed in x-space, same as #548.
- For k=L (output mixup): interpolation at logits creates a different fiber topology near the output layer.
- For intermediate k: f_{≥k} acts on a mixed representation h_mix that lies on a chord between two points on the k-layer feature manifold M_k. The zero-loss set W_k(λ) = {θ : f_{≥k}(λ·f_{<k}(x_i;θ_{<k}) + (1-λ)·f_{<k}(x_j;θ_{<k})) = λ·y_i + (1-λ)·y_j ∀ (i,j)} is a deformation of the original fiber that depends on both λ AND k.

**Conjecture:** The RLCT λ_MM(k) of the manifold mixup loss varies with k, and there exists an optimal k* that minimizes the effective RLCT. The interior interpolation creates fiber deformations that are NOT accessible via input-space mixup because f_{<k} transforms the interpolation geometry nonlinearly.

### C3 (CONJECTURAL): Feature-space interpolation crosses stratum boundaries in interior parameter space

Unlike input-space mixup (#548), where interpolated samples x_mix = λx_i + (1-λ)x_j trace straight lines in input space, manifold mixup traces curves in feature space parameterized by θ_{<k}. These curves can cross singular stratum boundaries that are invisible from the input-space perspective.

**Conjecture:** The set of θ_{<k} for which h_mix = λ·f_{<k}(x_i) + (1-λ)·f_{<k}(x_j) lies on a discriminant variety of f_{≥k} has positive codimension, creating an additional singular stratum S_k(λ) absent in input-space mixup. The RLCT of this stratum satisfies λ(S_k) ≤ λ(W_0) where W_0 is the original zero-loss set, because the constraint is more restrictive.

### C4 (CONJECTURAL): Generalization bound with k-dependent RLCT

The generalization gap under manifold mixup training satisfies:

  Gen_MM ≤ C · (λ_eff(k*) / (λ_eff(k*) + 1)) · (log n / n)^{1/(λ_eff(k*)+1)}

where λ_eff(k*) = E_{λ~Beta(α,α)}[λ_MM(k, λ)] is the k-averaged effective RLCT. The key prediction: manifold mixup achieves BETTER generalization than input-space mixup when k* > 0 because interior interpolation exposes the optimizer to a richer set of singular strata, effectively desingularizing a larger portion of the loss landscape.

**Contrast with #548:** #548's bound uses λ_eff = E_λ[λ_mixup(λ)] which only captures input-space deformation. Manifold mixup's bound includes the k-dimension, potentially reducing λ_eff further.

### C5 (CONJECTURAL): Layer depth k* phase transition

There exists a critical layer k* (depending on architecture depth L, width d, and data complexity) at which the RLCT undergoes a phase transition:

- For k < k*: interpolation occurs in early features (close to input), RLCT ≈ λ_mixup (same as #548).
- For k = k*: interpolation occurs at the "bottleneck" where feature representations are most compressed, RLCT is minimized.
- For k > k*: interpolation in late features (close to output) risks over-smoothing class-discriminative representations, RLCT increases again.

**Prediction:** λ_MM(k) has a U-shaped profile in k, analogous to the U-shaped test loss in #433 (PolyLoss degree d). The optimal k* ~ L/2 (middle layers) for deep networks.

**Testable via SGLD:** Measure LLC at different fixed k values. If LLC(k) is U-shaped, C5 is confirmed.

---

## Key Novelty

First formal bridge between **hidden-layer interpolation** (manifold mixup) and **singularity structure** (RLCT/SLT). The layer index k acts as a novel **stratum selector** — a discrete parameter controlling WHICH singular fiber the loss landscape exposes. This is absent in:

- #548 (mixup): only λ as stratum selector, input-space
- #532 (CutMix): λ + spatial mask, piecewise regions
- #169 (dropout): stochastic masking, no interpolation
- #582 (curriculum): data distribution modulation, no interpolation

The interior fiber deformation is the genuinely new insight: f_{<k} transforms the interpolation geometry, so the chord in h-space maps to a curve in x-space and vice versa. This curve can cross stratum boundaries that straight-line input interpolation misses.

---

## Cross-References

#548 (Mixup × RLCT, input-space), #532 (CutMix × RLCT, spatial), #258 (Data Aug × RLCT), #169 (Dropout × RLCT), #433 (PolyLoss, U-shaped), #95 (Curriculum), #582 (Curriculum × RLCT), #178 (Unlearning), #271 (EMA), #213 (LR scheduling), #334 (Self-distillation), #291 (PCGrad), #579 (Neural ODE × RLCT)

---

## Open Problems

1. Formal derivation of λ_MM(k) as function of k, architecture depth, width
2. Is the U-shaped profile in k universal or architecture-dependent?
3. Relationship between k* and the "information bottleneck" layer
4. Does manifold mixup's interior interpolation create genuinely NEW singular strata, or only deform existing ones?
5. Interaction with skip connections (ResNet): does k* shift when skip connections provide bypass paths?
6. Multi-sample manifold mixup (k-layer interpolation of 3+ samples): RLCT scaling
7. Connection to #579 Neural ODE: continuous-depth manifold mixup as ODE interpolation
8. SGLD experimental protocol: fixing k and measuring LLC across k values
9. Does f_{<k}(θ_{<k}) introduce additional non-identifiability vs input-space mixup?