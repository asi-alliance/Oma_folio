# Synthesis #497: Matryoshka Representation Learning × RLCT — L0 Outline

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Topic
Matryoshka Representation Learning (MRL) × Real Log Canonical Threshold (RLCT)

## What is Matryoshka Representation Learning?
MRL trains models to produce embeddings where the first d coordinates form a useful d-dimensional representation for any d in a predefined set {d_1, d_2, ..., d_n} with d_1 < d_2 < ... < d_n = D. The loss is a sum of losses at each granularity: L = Σ_i w_i · L_{d_i}(θ), where L_{d_i} uses only the first d_i coordinates of the embedding.

## Key RLCT Bridge
The nested embedding structure creates a tower of singular fibers. At each dimension d_i, the effective model is the restriction of the full D-dimensional map to the first d_i coordinates. This restriction creates a nested sequence of singular loci:

V_0^{d_1} ⊆ V_0^{d_2} ⊆ ... ⊆ V_0^{d_n} = V_0^D

where V_0^{d_i} is the singular locus of the loss function using the first d_i coordinates. The RLCT at each level λ(d_i) satisfies:

λ(d_1) ≤ λ(d_2) ≤ ... ≤ λ(d_n)

because lower-dimensional projections are "simpler" (fewer effective parameters, smaller singular locus). This is analogous to how restricting to a subspace can only decrease the RLCT (the singular locus of a restriction is contained in the restriction of the singular locus).

## Core Claims

C1 (standard-novel): The RLCT of the d_i-dimensional matryoshka sub-model is bounded above by the full model RLCT: λ(d_i) ≤ λ(D). This follows from the restriction principle — projecting to fewer coordinates restricts the parameter-to-output map, which can only simplify the singularity structure.

C2 (genuinely novel): The matryoshka loss L = Σ_i w_i · L_{d_i}(θ) creates a weighted union of singular loci. The effective singular locus is V_0^{eff} = ∪_i V_0^{d_i}, and the effective RLCT is λ_eff = min_i λ(d_i) (dominated by the lowest-RLCT stratum). This explains why matryoshka training preserves coarse-grained performance: the coarse stratum (low d_i, low λ) dominates the free energy landscape.

C3 (genuinely novel): The nesting structure V_0^{d_1} ⊆ V_0^{d_2} ⊆ ... creates a filtration of singular strata. This is a novel type of singular structure — a filtered singular variety — where each stratum is a subspace of the next. The RLCT transition from λ(d_i) to λ(d_{i+1}) is a phase transition in the representation granularity.

C4 (genuinely novel): Matryoshka generalization at dimension d_i follows the RLCT bound: G(d_i) ~ λ(d_i)/n. The nested structure means coarse representations generalize better (lower λ) but with less expressivity. The optimal d_i for a task with n samples is d* where λ(d*)/n ≈ approximation error at d*. This gives an RLCT-based criterion for optimal embedding dimensionality.

C5 (genuinely novel): Matryoshka training as singularity-aware multi-resolution learning. The weighted sum of losses creates a multi-resolution free energy landscape where the model must simultaneously reside on multiple nested strata. The training dynamics traverse from coarse (low d, low λ) to fine (high d, high λ) strata, analogous to coarse-to-fine optimization in multi-scale methods.

## Novelty Assessment
- Zero prior SLT/RLCT work on matryoshka representations (5 websearches, zero hits)
- Distinct from #220 (pruning: removes parameters post-hoc) — matryoshka trains all granularities simultaneously
- Distinct from #249 (LoRA: low-rank constraint on weights) — matryoshka restricts output dimension, not parameter rank
- Distinct from #264 (LayerNorm: normalization singularity) — matryoshka is about dimensional nesting
- Distinct from #312 (multi-token prediction: multiple heads) — matryoshka uses same head at different dimensions

## L0 Outline
1. Define matryoshka embedding map and nested loss
2. Formalize nested singular loci V_0^{d_i} and filtration
3. Prove C1 (restriction principle for RLCT)
4. Develop C2 (weighted union of singular loci)
5. Develop C3 (filtered singular variety)
6. Develop C4 (optimal dimensionality via RLCT)
7. Develop C5 (multi-resolution training dynamics)
8. Cross-references and open problems

## Cross-References
#8 (grokking), #65 (singular stratum), #94 (phase transition), #115 (emergent ability), #220 (pruning), #249 (LoRA), #264 (LayerNorm), #312 (multi-token prediction), #496 (CoT — sequential stratum transitions)

## Status
L0 written 2026-10-21. Next: L1 formalization.
