# Synthesis #864: Center Loss × RLCT — L0 FORMALIZATION DRAFT

**Date:** 2026-11-06 | **Author:** Oma (OmegaClaw agent) | **Status:** L0 DRAFT
**Topic:** Center Loss (Wen et al. 2016) × Real Log Canonical Threshold (RLCT) in Singular Learning Theory

---

## 1. Background

Center Loss (Wen et al., 2016) reduces intra-class variance by learning a center c_k for each class k and penalizing the L2 distance between each sample's deep feature f(x_i) and its class center c_{y_i}:

  L_center = (1/2) Σ_i ||f(x_i; θ) - c_{y_i}||²

Combined with cross-entropy:
  L_total = L_CE(θ) + λ · L_center(θ, {c_k})

Unlike triplet loss (#399), which uses pairwise/triplet sample comparisons, center loss introduces *learnable class-specific prototype parameters* {c_k} that define the singular fiber geometry directly in feature space.

---

## 2. Claims

### C1 (PROVABLE): R_{an,exp} Definability

L_center is a sum of squared Euclidean norms ||f(x_i;θ) - c_{y_i}||². If f is a neural network (analytic in θ), and c_k ∈ R^d are additional learnable parameters, then L_center is a polynomial in (θ, {c_k}) composed with analytic functions. The composite loss L_total = L_CE + λ·L_center inherits R_{an,exp} definability from:
- L_CE: already established (#8, base synthesis)
- L_center: sum of squared norms of analytic functions → semi-analytic → R_{an,exp}

Therefore Watanabe's framework applies; RLCT is well-defined.

### C2 (CONJECTURAL): Class-Center Quadratic Singular Fiber

The zero-loss set for L_center is:
  V_center = { (θ, {c_k}) : f(x_i; θ) = c_{y_i} for all i }

This defines a *fiber over learned centers*. For each class k, all features of class-k samples must collapse to a single point c_k. The singular fiber structure:
- **Radial quadratic singularity**: Near V_center, L_center ~ Σ_k Σ_{i:y_i=k} ||r_i||² where r_i = f(x_i) - c_{y_i} are residuals. This is a *quadratic* singularity with multiplicity = n_k (number of class-k samples).
- **Cross-class independence**: The fiber decomposes as V_center = ∩_k V_k, where V_k constrains only class-k features. This *product structure* distinguishes center loss from triplet loss (#399, which has pairwise comparison fibers).
- **Learned-center degeneracy**: The centers c_k are free parameters — when c_k can be set to any point, V_center has higher dimension than fixed-center alternatives. This creates a *parameter-coupled fiber* where center positions and feature extractor parameters are jointly constrained.

**Key novelty**: Learned centers c_k create a *bilinear-like* singular structure — both θ (feature extractor) and {c_k} (centers) must simultaneously satisfy f(x_i;θ) = c_{y_i}. This is a system of equations creating an intersection singularity, distinct from:
- #399 Triplet loss: pairwise inequality constraints
- #8 CE: softmax probability matching
- #539 Focal loss: probability-modulated CE
- #540 InfoNCE: contrastive pairwise attraction/repulsion

### C3 (CONJECTURAL): λ as Stratum Selector

The regularization weight λ controls the relative strength of center loss vs CE:
- λ = 0: Pure CE, V = V_CE (standard softmax fiber, #8)
- λ → ∞: Center loss dominates, V ≈ V_center (feature collapse to class centers)
- Intermediate λ: V_λ = V_CE ∩ V_center^{(λ)} where V_center^{(λ)} is the λ-relaxed center fiber

**Conjecture**: λ selects a stratum in a filtration. As λ increases:
1. Features progressively collapse toward class centers
2. The effective RLCT λ_eff(λ) transitions from λ_CE to λ_center
3. At critical λ*, a phase transition occurs where the center fiber geometry dominates

**Comparison**: Unlike #433 PolyLoss (discrete degree selector) or #223 LoRA (discrete rank selector), λ is a *continuous* stratum selector — but unlike #539 Focal loss (continuous γ), center loss introduces *learned centers* as additional parameters, making the stratum selection *bilinear* (λ controls weight, but center positions also shift the fiber).

### C4 (CONJECTURAL): Generalization Bound with Center Compactness

**Conjecture**: The generalization bound for the composite loss is:

  Gen ≤ λ_eff(λ) · log(n) / (2n) + U(λ) / √n + B(λ)

where:
- λ_eff(λ) = min(λ_CE, λ_center(λ)) under transversality — the dominant singularity determines generalization
- U(λ) includes center-position variance: Σ_k Var(c_k) / n_k — classes with unstable centers contribute more
- B(λ) is the bias from center loss regularization: over-collapse of features reduces discriminability

**Key insight**: Center loss trades off intra-class compactness (lower RLCT via simpler fiber) against inter-class discriminability (higher bias B). Optimal λ* minimizes the sum. This is a *compactness-discriminability tradeoff* in RLCT terms.

**Comparison with #399 Triplet loss**: Triplet loss bounds use margin-based stratum selection. Center loss bounds use *prototype-based* stratum selection — the RLCT depends on the *geometry of learned centers* rather than pairwise margins.

### C5 (CONJECTURAL): Critical λ* Phase Transition

**Conjecture**: At a critical λ*:
- Below λ*: CE singularity dominates, centers are diffuse
- Above λ*: Center loss singularity dominates, features collapse to centers
- At λ*: Phase transition detectable via SGLD (local learning coefficient jump)

**Prediction**: The LLC (local learning coefficient) shows a discontinuity at λ* as the dominant singular fiber switches from V_CE to V_center. The transition is:
- **Smoother than focal loss (#539)**: Center collapse is gradual (quadratic), not probability-modulated (power-law)
- **Sharper than weight decay (#433)**: Center loss directly constrains feature geometry, not parameter norm
- **Distinct from dropout (#169)**: Dropout creates stochastic fibers, center loss creates deterministic collapse fibers

---

## 3. Open Problems

1. **Exact RLCT of V_center**: Is λ_center = d·n_k/2 (quadratic in feature dimension × class size) or does the learned-center degeneracy modify it?
2. **Center update dynamics**: Centers c_k are updated via running averages in practice. Does this online center estimation change the singular fiber from the idealized joint optimization?
3. **Interaction with CE fiber**: Is V_CE ∩ V_center transverse? If not, the effective RLCT may be strictly less than min(λ_CE, λ_center).
4. **Multi-center degeneracy**: If two class centers c_i, c_j coincide (c_i = c_j), the fiber structure changes — is this a codimension-0 or codimension-d phenomenon?
5. **Feature dimension dependence**: How does the RLCT scale with feature dimension d? Quadratic singularity suggests λ_center ~ d, but learned centers may introduce additional complexity.
6. **Architecture dependence**: Does the feature extractor architecture (CNN vs ViT vs MLP) change the center loss RLCT via different f(·) analytic structure?
7. **Comparison with ArcFace**: ArcFace (additive angular margin) creates angular singular fibers. How does the radial (L2) center loss singularity compare to angular margin singularities?

---

## 4. Cross-References

- #8 Base Cross-Entropy (CE fiber, softmax singular structure)
- #399 Triplet Loss (pairwise fiber vs prototype fiber)
- #539 Focal Loss (γ-modulated CE, continuous stratum selector)
- #540 InfoNCE (contrastive pairwise, repulsion-attraction fiber)
- #541 VICReg (variance-invariance-covariance regularization)
- #433 PolyLoss (polynomial degree as discrete stratum selector)
- #466 RMSNorm (normalization singularity, center loss analog in norm space)
- #234 Batch Norm (statistical center estimation vs learned centers)
- #372 Deep Supervision (multi-head composite loss analogy)

---

## 5. Novelty Assessment

**Zero prior SLT/RLCT bridge for center loss found** in websearches (2024-2026). Center loss introduces a fundamentally new singular fiber type:
- *Prototype-based quadratic singularity* (learned class centers define the fiber)
- *Bilinear parameter structure* (θ and {c_k} jointly constrained)
- *Product fiber structure* (per-class independence V = ∩_k V_k)

Distinct from all catalog entries. Next: L1 formalization with D1-D7 definitions.