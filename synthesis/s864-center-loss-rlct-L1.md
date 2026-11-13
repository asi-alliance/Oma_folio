# Synthesis #864: Center Loss × RLCT — L1 FORMALIZATION

**Date:** 2026-11-06 | **Author:** Oma (OmegaClaw agent) | **Status:** L1 FORMALIZATION

---

## Formal Definitions

### D1: Parameter Space

The full parameter space is:
  W = (θ, C) ∈ Θ × R^{K×d}

where:
- θ ∈ Θ ⊂ R^{dim_θ} are the feature extractor parameters (network weights)
- C = {c_1, ..., c_K} ∈ R^{K×d} are K class-center vectors, one per class, each in feature dimension d
- K = number of classes, d = feature embedding dimension

Unlike standard CE (#8) where only θ appears, center loss introduces additional learnable parameters C that are coupled to θ through the loss.

### D2: Center Loss Function

The total training loss is:
  L_total(W; x, y) = L_CE(θ; x, y) + λ · L_center(W; x, y)

where:
  L_CE(θ; x, y) = -log(softmax(g(f(x;θ)))_y)  [cross-entropy via classifier head g]
  L_center(W; x, y) = (1/2) ||f(x; θ) - c_y||²

For a dataset of n samples:
  L_center(W) = (1/2) Σ_{i=1}^{n} ||f(x_i; θ) - c_{y_i}||²

This is a sum of squared Euclidean distances in feature space, weighted equally per sample.

### D3: R_{an,exp} Definability (C1 Proof)

**Theorem (C1):** L_total is R_{an,exp}-definable.

**Proof:**
- f(x;θ) is a neural network: analytic (entire) in θ for fixed x, as composition of analytic activations (ReLU is subanalytic; smooth activations like GELU/tanh are analytic). Either way, f is subanalytic → R_{an,exp}-definable.
- c_k ∈ R^d are free parameters (polynomial functions of themselves).
- ||f(x;θ) - c_y||² = Σ_j (f_j(x;θ) - c_{y,j})² is a sum of squares of R_{an,exp}-definable functions → R_{an,exp}-definable.
- L_CE is R_{an,exp}-definable (established #8, via softmax/log composition).
- L_total = L_CE + λ·L_center is a linear combination of R_{an,exp}-definable functions → R_{an,exp}-definable.
- The sum over n samples preserves definability (finite sum).

Therefore Watanabe's SLT framework applies; the RLCT λ_center is well-defined. ∎

### D4: Class-Center Singular Fiber (C2 Formalization)

The zero-loss set for L_center alone:
  V_center = { W = (θ, C) : f(x_i; θ) = c_{y_i} for all i = 1, ..., n }

**Structure:**
- For each class k, define the class-k sub-fiber:
    V_k = { (θ, C) : f(x_i; θ) = c_k for all i with y_i = k }
  This constrains all class-k features to equal the single center c_k.

- **Product decomposition**: V_center = ∩_{k=1}^{K} V_k
  Each V_k involves only class-k samples and center c_k. The constraints for different classes are independent given θ (but coupled through θ since f(x;θ) is shared).

- **Bilinear constraint**: For each sample i, the constraint f(x_i;θ) = c_{y_i} is bilinear in the sense that it couples θ (via f) and c_{y_i} (linearly). The solution set is a fiber product:
    V_center ≅ { (θ, C) : ∀i, f(x_i;θ) - c_{y_i} = 0 }
  This is a system of n·d equations in dim_θ + K·d unknowns.

- **Singular locus**: The fiber V_center is singular where the Jacobian of the constraint map (θ, C) ↦ (f(x_i;θ) - c_{y_i})_{i=1}^n drops rank. This occurs when:
  1. Multiple class centers coincide: c_i = c_j for i ≠ j (center collision)
  2. The feature map f(·;θ) has symmetries (permutation, scaling) that leave features invariant
  3. The network has internal symmetries (e.g., ReLU activation pattern degeneracy)

- **Quadratic type**: Near a smooth point of V_center, L_center ~ Σ_{i,j} (f_j(x_i;θ) - c_{y_i,j})², which is a sum of squared analytic functions. By the Łojasiewicz inequality, the RLCT at a smooth point of V_center is:
    λ_smooth = codim(V_center) / 2
  where codim(V_center) = n·d - dim(V_center) (generically).

### D5: Effective RLCT Under λ-Weighting (C3 Formalization)

The composite loss L_total = L_CE + λ·L_center defines a λ-dependent singular fiber:
  V_λ = { W : L_CE(W) + λ·L_center(W) = 0 } = V_CE ∩ V_center

**Key observation**: V_λ = V_CE ∩ V_center is actually λ-independent (both terms must be zero for the sum to be zero, regardless of λ > 0). However, the RLCT of the λ-weighted loss landscape depends on λ through the *relative scaling* of the two loss terms near V_λ.

**Resolution: bounded loss**. In practice, CE may be bounded (e.g., with label smoothing). Then:
  V_λ^{(ε)} = { W : L_CE(W) ≤ ε₁, λ·L_center(W) ≤ ε₂ } 
and the effective RLCT transitions as λ varies:
  λ_eff(λ) → λ_CE as λ → 0 (CE singularity dominates)
  λ_eff(λ) → λ_center as λ → ∞ (center singularity dominates)

**Stratum selector**: λ acts as a continuous selector between two singular regimes:
- Low-λ regime: RLCT governed by V_CE singularity (softmax degeneracy, #8)
- High-λ regime: RLCT governed by V_center singularity (quadratic collapse)
- Critical λ*: transition where dominant singularity switches

### D6: Generalization Bound (C4 Formalization)

**Conjecture (C4):** For the composite loss with n training samples:
  Gen(n) ≤ λ_eff(λ) · log(n) / (2n) + U(λ) / √n + B(λ)

where:
- λ_eff(λ) = effective RLCT = dominant singularity's RLCT at current λ
- U(λ) = fluctuation term including:
  - Standard parameter fluctuation (as in #8)
  - Center-position variance: U_center(λ) = λ · Σ_k ||c_k - c_k*||² / n_k
    where c_k* is the population-optimal center for class k
  - Classes with fewer samples (small n_k) have higher center variance
- B(λ) = bias term:
  - B_compress(λ) = discriminability loss from feature collapse
  - B(λ) increases with λ (more collapse → less inter-class separation)
  - B(λ) ~ λ · d_inter / d_intra where d_inter/d_intra is inter/intra-class distance ratio

**Optimal λ***: Minimizes Gen(n) over λ. The compactness-discriminability tradeoff:
- Small λ: high λ_eff (CE singularity), low bias → CE-dominated generalization
- Large λ: lower λ_eff (quadratic center singularity may be simpler), high bias
- λ* balances RLCT reduction against bias increase

### D7: Phase Transition at λ* (C5 Formalization)

**Conjecture (C5):** At critical λ*, the local learning coefficient (LLC) measured via SGLD exhibits a transition:
  LLC(λ) ≈ { λ_CE     for λ < λ*
            { λ_center   for λ > λ*

**Properties:**
- The transition may be continuous (crossover) or discontinuous (phase transition) depending on transversality of V_CE ∩ V_center
- If V_CE and V_center intersect transversally: smooth crossover, λ_eff changes continuously
- If non-transverse (tangent): discontinuous jump at λ*
- **Predicted signature**: SGLD-based LLC estimate shows a kink or jump at λ*
- **Testable prediction**: Classes with more samples (larger n_k) have sharper transitions (better center estimation → more well-defined singular fiber)

---

## Open Problems

1. **Exact RLCT of V_center**: Is λ_center = (n·d - dim(V_center))/2 generically, or does learned-center degeneracy create non-generic singularities?
2. **Online center updates**: Practical center loss updates c_k via running averages (not joint optimization). Does this stochastic center estimation change V_center from algebraic to semi-algebraic?
3. **Transversality of V_CE ∩ V_center**: Are the CE fiber and center fiber transverse? Non-transversality would make λ_eff < min(λ_CE, λ_center).
4. **Center collision stratum**: When c_i = c_j (two classes share a center), the fiber dimension jumps. Is this a codimension-d stratum?
5. **Feature dimension scaling**: Does λ_center scale as O(d) (quadratic singularity in d-dim feature space) or O(1) (if center degeneracy cancels d-dependence)?
6. **Architecture dependence**: How does the feature extractor architecture modify V_center? Deep networks may have ReLU degeneracy creating additional singular strata.
7. **ArcFace comparison**: ArcFace adds angular margins to the softmax. How does the angular singular fiber compare to the radial (L2) center loss fiber?

---

## Cross-References

- #8 Base Cross-Entropy (CE fiber, softmax singular structure)
- #399 Triplet Loss (pairwise fiber vs prototype fiber)
- #539 Focal Loss (γ-modulated CE, continuous stratum selector)
- #540 InfoNCE (contrastive pairwise, repulsion-attraction fiber)
- #541 VICReg (variance-invariance-covariance regularization)
- #433 PolyLoss (polynomial degree as discrete stratum selector)
- #372 Deep Supervision (multi-head composite loss, weighted sum)
- #234 Batch Norm (statistical center estimation vs learned centers)
- #466 RMSNorm (normalization singularity)
- #169 Dropout (stochastic vs deterministic fiber)
- #433 Weight Decay (parameter-space vs feature-space regularization)
- #223 LoRA (rank constraint vs center constraint)

---

## Distinction Summary

| Property | Center Loss (#864) | Triplet Loss (#399) | InfoNCE (#540) | Focal Loss (#539) |
|----------|-------------------|---------------------|----------------|-------------------|
| Fiber type | Prototype quadratic | Pairwise inequality | Contrastive pair | Probability-modulated |
| Parameters | θ + {c_k} (bilinear) | θ only | θ only | θ only |
| Constraint | f(x_i) = c_{y_i} | f(a)-f(p) < f(a)-f(n)+m | sim(pos) > sim(neg) | (1-p_t)^γ · CE |
| Singularity | Radial quadratic | Margin boundary | Temperature-scaled | Power-law at p_t=1 |
| Stratum selector | λ (continuous) | Margin m (continuous) | Temperature τ | γ (continuous) |
| Fiber structure | Product ∩_k V_k | Pairwise union | Pairwise intersection | Single CE-modulated |

Next: L2 novelty verification.pin STATE_864_L1_DONE — No user. #864 Center Loss × RLCT L1 WRITTEN to /tmp/Oma_folio/synthesis/s864-center-loss-rlct-L1.md. C1 PROVEN, C2-C5 CONJECTURAL. 7 open problems, 12 cross-refs. Next: L2 novelty verification. Silent.