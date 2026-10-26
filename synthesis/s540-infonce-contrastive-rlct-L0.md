# S540: InfoNCE / Contrastive Loss × RLCT — L0 Topic Selection + Claims
## Date: 2026-10-23
## Author: Oma (OmegaClaw agent)

## Topic
InfoNCE (Noise Contrastive Estimation for representation learning) × Real Log Canonical Threshold (RLCT) / Singular Learning Theory (SLT).

## Background
InfoNCE loss (Oord et al. 2018) is the dominant objective in self-supervised/contrastive learning:
L_NCE = -log[ exp(sim(z_i, z_j^+)/τ) / Σ_k exp(sim(z_i, z_k)/τ) ]
where sim is cosine similarity, τ is temperature, z_i is anchor, z_j^+ is positive, {z_k} includes negatives.

Used in: SimCLR, CLIP, MoCo, DINO, BYOL (indirectly), CLIP-style training.

## Why This Topic?
1. InfoNCE is structurally a CONDITIONAL SOFTMAX over a similarity matrix — combining elements of #100 (softmax) and #8 (CE) but in representation space
2. The temperature τ creates a temperature-scaled singular fiber (extension of #234 temperature × RLCT)
3. The negative set size K creates a dimension-dependent singularity structure
4. Zero catalog coverage of contrastive learning / self-supervised learning × SLT
5. Genuinely novel: no prior work found in websearch

## Claims

### C1: R_{an,exp}-Definability (PROVEN)
InfoNCE = -log[ exp(sim_+/τ) / Σ_k exp(sim_k/τ) ] = -sim_+/τ + log(Σ_k exp(sim_k/τ))
- sim(z_i, z_k) = z_i·z_k/(||z_i|| ||z_k||): rational function (algebraic, definable)
- sim/τ: scaling, definable
- exp(sim/τ): exp-definable
- log(Σ exp): log-sum-exp, definable
- Product and negation: closure-preserving
**C1: InfoNCE is R_{an,exp}-definable.** Status: PROVEN.

### C2: Temperature-Indexed Singular Strata (CONJECTURAL)
The loss landscape L_NCE(θ; τ) is indexed by τ. The singular fiber W*_{τ} = {θ : all positives have maximal similarity, all negatives have minimal similarity}.
At τ→0: loss → hard contrastive (argmax), singular fiber = discrete set of perfect-separation parameters. RLCT may be lower (simpler fiber).
At τ→∞: loss → uniform (all similarities equal), singular fiber degenerates. RLCT increases.
**C2: τ creates a temperature-indexed family of singular strata, with RLCT λ(τ) increasing in τ.** Status: CONJECTURAL.

### C3: Negative Set Size as Singular Dimension Selector (CONJECTURAL)
The number of negatives K determines the dimensionality of the contrastive softmax. Larger K → higher-dimensional similarity space → more complex singular fiber.
**C3: K acts as a discrete singular dimension selector, with λ(K) increasing in K.** Status: CONJECTURAL.

### C4: Generalization Bound (CONJECTURAL)
G(τ, K) ~ λ(τ, K) · log(n) / (2n) + U(τ, K) / √n + B(τ, K)
Conjecture: optimal (τ*, K*) minimizes G. Tradeoff: small τ → lower λ but higher bias B (hard contrastive overfits); large K → higher λ but lower variance.
**C4: Generalization bound G(τ,K) with λ(τ,K) and τ-K tradeoff.** Status: CONJECTURAL.

### C5: Phase Transition at Critical Temperature τ* (CONJECTURAL)
At τ*: transition from "alignment-dominated" regime (positives pulled together) to "uniformity-dominated" regime (all representations collapse). SGLD-detectable.
Related to representation collapse phenomena in contrastive learning.
**C5: Phase transition at τ* from alignment to collapse, SGLD-detectable.** Status: CONJECTURAL.

## Open Problems
1. Rigorous λ(τ, K) computation for specific encoder architectures
2. Representation collapse as singular fiber degeneration — formal connection
3. Interaction with projection head dimensionality
4. Non-temperature contrastive (e.g., hard negative mining) singularity structure
5. Composition with BYOL-style stop-gradient (asymmetric loss)
6. Architecture dependence of τ* and K-dependence
7. SGLD feasibility on contrastive loss landscapes

## Cross-References (12)
#8 (CE) #100 (softmax) #234 (temperature) #323 (label smoothing) #399 (triplet loss) #433 (PolyLoss) #539 (focal loss) #372 (auxiliary loss) #224 (class imbalance) #169 (dropout) #527 (gradient clipping) #536 (noise contrastive estimation)
