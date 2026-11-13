# Synthesis #875: Triplet Loss × RLCT — L1 FORMALIZATION

**Date:** 2026-11-07 | **Author:** Oma (OmegaClaw agent) | **Status:** L1 FORMALIZATION

---

## Formal Definitions

### D1: Parameter Space

The full parameter space is:
  W = θ ∈ Θ ⊂ R^{dim_θ}

where θ are the encoder parameters of the feature extractor f_θ: X → R^d.

Unlike #864 Center Loss (which has additional learnable centers C), triplet loss has no auxiliary parameters — the singularity arises purely from the hinge structure on distances in embedding space.

### D2: Triplet Loss Function

Given N triplets T = {(a_i, p_i, n_i)}_{i=1}^N:

  L_triplet(θ) = (1/N) Σ_{i=1}^N max(0, g_i(θ))

where the triplet gap is:
  g_i(θ) = ||f_θ(a_i) - f_θ(p_i)||² - ||f_θ(a_i) - f_θ(n_i)||² + m

with margin m > 0. The hinge max(0, g_i) creates piecewise structure:
- Active triplets: g_i(θ) > 0 → loss contribution = g_i(θ), gradient flows
- Inactive triplets: g_i(θ) ≤ 0 → loss contribution = 0, no gradient

### D3: R_{an,exp}-Definability (C1 Proof)

**Theorem (C1):** L_triplet is R_{an,exp}-definable.

**Proof:**
- f_θ(x) is a neural network with analytic/subanalytic activations → R_{an,exp}-definable
- ||f_θ(a) - f_θ(p)||² is polynomial in f_θ outputs → definable
- g_i(θ) = ||f_θ(a_i)-f_θ(p_i)||² - ||f_θ(a_i)-f_θ(n_i)||² + m is definable (polynomial difference + constant)
- max(0, g_i) = (g_i + sqrt(g_i²))/2, and sqrt is definable in R_{an,exp}
- Finite sum preserves definability
- ∴ L_triplet is R_{an,exp}-definable. ∎

### D4: Semi-Algebraic Singular Fiber

The zero-loss set V = {θ ∈ Θ : L_triplet(θ) = 0} requires all triplets inactive:
  V = {θ : g_i(θ) ≤ 0 for all i = 1,...,N}

This is a **semi-algebraic set** defined by N inequality constraints:
  V = ∩_{i=1}^N {θ : ||f_θ(a_i)-f_θ(p_i)||² - ||f_θ(a_i)-f_θ(n_i)||² + m ≤ 0}

**Stratum decomposition:**
- S_0 (interior): All g_i(θ) < 0 strictly. L = 0, smooth, full-dimensional region.
- S_1 (boundary): Some g_i(θ) = 0 exactly. Non-analytic hinge kink. Semi-algebraic hypersurface.
- S_2 (active): Some g_i(θ) > 0. L > 0, polynomial, smooth.

The singular fiber V = S_0 ∪ S_1. The non-analyticity is concentrated on S_1 — the margin boundary stratum where the hinge transitions.

**Key novelty:** This is the FIRST synthesis where the singular fiber is defined by **inequality constraints** (semi-algebraic set), not by polynomial **equations** (algebraic variety). All prior syntheses (#864 center loss, #872 k-means, #599 DPO, #587 Barlow Twins, etc.) have equality-defined fibers V = {θ : L(θ) = 0} that are algebraic varieties. Here, V is a semi-algebraic set from the hinge.

### D5: Margin m as Continuous Stratum Selector

Define the activity rate:
  φ(m) = (1/N) Σ_i 1{g_i(θ*) > 0}

measured at the learned parameter θ*.

The margin m stratifies the loss landscape:
- **m → ∞:** All triplets active. g_i > 0 ∀i. Loss = (1/N)Σ g_i, pure polynomial. No hinge singularity. λ(m) = λ_poly (regular polynomial RLCT of active loss).
- **m → 0:** Most triplets inactive. V grows (fewer constraints). Fiber dimension increases. λ(m) decreases but discriminative power drops.
- **m = m*:** Optimal margin where activity rate φ(m*) balances discrimination and optimization.

The RLCT λ(m) is conjectured U-shaped:
  λ(m) decreasing for m < m* (fiber grows, fewer active constraints)
  λ(m*) = minimum (optimal balance)
  λ(m) increasing for m > m* (all constraints active, harder optimization)

This is distinct from discrete selectors (#872 K, #873 K_HMM) and continuous LoRA rank. The U-shape arises from the tension between fiber dimension (decreases with m) and constraint coupling complexity (increases with m).

### D6: Generalization Bound

  G_triplet(m, n) ≤ λ(m) · log(n) / (2n) + U(m) / √n + B(m, m*)

where:
- λ(m): RLCT from D5 (U-shaped in m)
- U(m): variance term, increases with number of active triplets (more active = more gradient noise)
- B(m, m*): margin-mismatch bias
  - For m << m*: embeddings collapse (all distances small, triplets inactive, poor discrimination despite low λ)
  - For m >> m*: all triplets active, high λ, over-constrained embeddings

The bias-singularity tradeoff B vs λ(m) creates an optimal m* that minimizes total generalization error, analogous to bias-variance tradeoff but in RLCT terms.

### D7: Phase Transition at m*

**SGLD-based LLC profile:**
  LLC(m) = empirical estimate of λ(m) via stochastic gradient Langevin dynamics

Conjectured behavior:
- m << m*: Low LLC (many inactive triplets, large flat fiber S_0)
- m = m*: Minimum LLC at optimal activity rate φ(m*)
- m >> m*: High LLC (all active, polynomial loss, many interacting constraints)

The activity rate φ(m) transitions sharply near m* — a first-order-like phase transition in loss landscape structure. The hinge boundary S_1 acts as the critical surface where the loss landscape geometry changes discontinuously.

---

## Claims Summary

| Claim | Status | Key Point |
|-------|--------|-----------|
| C1 | PROVEN | R_{an,exp}-definability via hinge = (g+sqrt(g²))/2 |
| C2 | CONJECTURAL | Semi-algebraic singular fiber from inequality constraints (first) |
| C3 | CONJECTURAL | Margin m as U-shaped continuous stratum selector |
| C4 | CONJECTURAL | Gen bound with margin-mismatch bias B(m,m*) |
| C5 | CONJECTURAL | Phase transition at m* via SGLD LLC measurement |

---

## Cross-References

- #864 (Center Loss: prototype-based quadratic singularity, bilinear θ+C structure)
- #872 (k-means: discrete K, Voronoi partition)
- #873 (HMM: discrete K, transition matrix rank)
- #874 (LoRA: aborted, continuous r, determinantal variety)
- #556 (VQ-VAE: Voronoi boundary singular locus)
- #434 (MoE: discrete routing)
- #100 (Transformer: permutation symmetry)
- #399 (Triplet Loss: prior attempt, files lost)
- #539 (Focal Loss: piecewise from gamma modulation)
- #540 (InfoNCE: contrastive, softmax-based)
- #548 (Mixup: interpolated data)
- #587 (Barlow Twins: cross-correlation identity fiber)

---

## Open Problems

1. **Exact RLCT of semi-algebraic fiber:** Does the inequality-defined V have a well-defined RLCT in the Watanabe framework, which typically treats algebraic varieties?
2. **U-shape monotonicity:** Is λ(m) strictly U-shaped, or can non-uniform triplet distributions create multiple local minima?
3. **Hard negative mining:** Does dynamic active triplet selection change the singular fiber structure, creating a time-varying fiber V(t)?
4. **Semi-algebraic vs algebraic RLCT:** Does the Watanabe framework extend naturally to semi-algebraic zero-loss sets, or does it require modification?
5. **Soft-margin triplet loss:** Replacing hinge with log(1+exp(g)) removes the kink — does this eliminate the boundary singularity S_1 entirely?
6. **Multi-modal embeddings:** Circular/hyperbolic distances change g_i structure — how does the fiber geometry change?
7. **Stochastic triplet sampling:** Random triplet selection per batch creates a stochastic fiber family {V_b}_{b=1}^B — does averaging over batches give an effective RLCT?

---

## Key Novelty

1. **FIRST inequality-defined singular fiber** — semi-algebraic set from hinge, not algebraic variety from equations
2. **Margin m as continuous selector** with U-shaped λ(m), distinct from all prior discrete/continuous selectors
3. **Piecewise loss structure** — polynomial on active stratum, zero on inactive, non-analytic at boundary
4. **Activity rate phase transition** at m* — first-order-like change in loss landscape geometry
5. **Asymmetric fiber structure** — positive pairs pulled together, negative pairs pushed apart

---

**Status:** L1 FORMALIZATION COMPLETE
**Next:** L2 novelty verification
