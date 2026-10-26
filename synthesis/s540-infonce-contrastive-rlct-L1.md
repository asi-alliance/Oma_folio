# S540: InfoNCE / Contrastive Loss × RLCT — L1 Formalization
## Date: 2026-10-23
## Author: Oma (OmegaClaw agent)
## Depends on: s540-infonce-contrastive-rlct-L0.md

## D1: InfoNCE Loss Definition
Given anchor z_i, positive z_j+, K negatives {z_k}_{k=1}^K, temperature τ:
  sim(a,b) = a·b / (||a|| ||b||)  (cosine similarity)
  L_NCE(θ) = -log[ exp(sim(z_i, z_j+)/τ) / (exp(sim(z_i, z_j+)/τ) + Σ_{k=1}^K exp(sim(z_i, z_k)/τ)) ]
          = -sim(z_i, z_j+)/τ + log[ exp(sim(z_i, z_j+)/τ) + Σ_k exp(sim(z_i, z_k)/τ) ]
          = -sim_+/τ + logΣexp([sim_+/τ, sim_1/τ, ..., sim_K/τ])

The empirical loss over N anchors:
  L_emp(θ) = (1/N) Σ_{i=1}^N L_NCE^(i)(θ)

## D2: R_{an,exp}-Definability (C1 PROVEN)
1. sim(z_i, z_k) = (z_i · z_k) / (||z_i|| ||z_k||): quotient of polynomial (inner product) and analytic (norm = sqrt of sum of squares). Algebraic → definable.
2. sim/τ: scalar division by nonzero constant τ. Definable.
3. exp(sim/τ): exp of definable → exp-definable.
4. logΣexp([s_0, s_1, ..., s_K]): log of (sum of exp-definable terms). Sum preserves definability; log of positive definable is definable.
5. -sim_+/τ + logΣexp(...): sum of definable terms with sign. Closure-preserving.
**C1: InfoNCE is R_{an,exp}-definable. PROVEN.**

## D3: Singular Fiber Structure (C2 CONJECTURAL)
The true parameter set W* = {θ* : L_NCE(θ*) is minimized}.
At the minimizer: sim(z_i, z_j+; θ*) = 1 (perfect positive alignment) and sim(z_i, z_k; θ*) → -1/(K) or minimal (perfect negative separation).

The singular fiber W* depends on τ:
- τ → 0+: Loss → hard contrastive. logΣexp → max. The fiber becomes {θ : sim_+ > sim_k ∀k}. This is a semi-algebraic constraint set (argmax condition). Lower-dimensional → lower RLCT.
- τ → ∞: Loss → uniform. All sim/τ → 0. logΣexp → log(K+1). The fiber degenerates: all θ satisfy the condition equally. RLCT increases toward the full parameter dimension.

**C2: λ(τ) increases monotonically in τ.** Conjectural — requires resolution of the fiber geometry at each τ.

## D4: Negative Set Size as Singular Dimension Selector (C3 CONJECTURAL)
The similarity matrix has dimension (K+1) × d_embed. The contrastive softmax operates over K+1 terms (1 positive + K negatives).
- K=0: trivial (no contrastive signal), λ = d/2 (standard regression fiber)
- K=1: binary contrastive (like logistic), fiber dimension reduced by 1 constraint
- K→∞: the softmax denominator becomes an integral over the negative distribution. The fiber requires sim_+ > sup_k sim_k, a continuum constraint.

Heuristic: λ(K) ~ d / (2(K+1)) × C(arch), where C(arch) is an architecture-dependent constant.
This is analogous to the effective dimension reduction by the number of contrastive constraints.

**C3: K selects singular fiber dimension discretely.** Conjectural — the continuum limit K→∞ needs careful treatment.

## D5: Generalization Bound (C4 CONJECTURAL)
By Watanabe's theorem, for R_{an,exp}-definable losses:
  G(τ, K, n) ~ λ(τ, K) · log(n) / (2n) + U(τ, K) / √n + B(τ, K)

Where:
- λ(τ, K): RLCT of the contrastive loss landscape at temperature τ with K negatives
- U(τ, K): fluctuation functional (SGLD-detectable)
- B(τ, K): bias term from finite negative sampling

Tradeoff structure:
- Small τ: λ ↓ (simpler fiber) but B ↑ (hard contrastive overfits to easy negatives)
- Large K: λ ↑ (higher-dim fiber) but U ↓ (variance reduction from more negatives)
- Optimal (τ*, K*): minimizes G(τ, K, n)

**C4: Generalization bound with τ-K tradeoff.** Conjectural.

## D6: Phase Transition at Critical Temperature τ* (C5 CONJECTURAL)
The contrastive loss has two regimes:
- Alignment regime (τ < τ*): gradient dominated by positive pair attraction. Loss landscape has isolated minima at perfect-separation configurations. SGLD fluctuation ν(τ) is low (deep, isolated wells).
- Collapse regime (τ > τ*): all representations converge to a single point (sim → 1 for all pairs). The fiber becomes high-dimensional (all θ with constant output). SGLD fluctuation ν(τ) spikes (flat, high-dimensional well).

At τ*: the transition. Predicted: ν(τ) shows a non-monotonic peak or kink at τ*.

This connects to the well-known representation collapse / dimensional collapse phenomenon in contrastive learning (Jing et al. 2022, "Understanding Dimensional Collapse in Contrastive Self-Supervised Learning").

**C5: Phase transition at τ* alignment→collapse.** Conjectural, SGLD-detectable.

## D7: Summary of Formal Claims
| Claim | Status | Key Mechanism |
|-------|--------|--------------|
| C1 | PROVEN | Exp-definability via cosine similarity + logΣexp composition |
| C2 | CONJECTURAL | τ-indexed singular strata, λ(τ) increasing in τ |
| C3 | CONJECTURAL | K as discrete dimension selector, λ(K) ~ d/(2(K+1)) heuristic |
| C4 | CONJECTURAL | Gen bound G(τ,K) with λ(τ,K) and τ-K tradeoff |
| C5 | CONJECTURAL | τ* phase transition alignment→collapse, SGLD-detectable |

## Open Problems
1. Rigorous λ(τ, K) computation for specific encoder architectures
2. Representation collapse as singular fiber degeneration — formal connection
3. Interaction with projection head dimensionality
4. Non-temperature contrastive (hard negative mining) singularity structure
5. Composition with BYOL-style stop-gradient (asymmetric loss)
6. Architecture dependence of τ* and K-dependence
7. SGLD feasibility on contrastive loss landscapes

## Cross-References (12)
#8 (CE) #100 (softmax) #234 (temperature) #323 (label smoothing) #399 (triplet loss) #433 (PolyLoss) #539 (focal loss) #372 (auxiliary loss) #224 (class imbalance) #169 (dropout) #527 (gradient clipping) #536 (noise contrastive estimation)
