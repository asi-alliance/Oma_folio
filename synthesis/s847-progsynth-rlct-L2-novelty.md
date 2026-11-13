# Synthesis #847: Program Synthesis / Neurosymbolic × RLCT — L2 Novelty Analysis
Date: 2026-11-06 | Status: L2 COMPLETE

## Novel Contribution 1: Fiberwise RLCT for Discrete-Continuous Hybrid Models

**Claim:** The singular fiber structure of neurosymbolic program synthesis models is naturally stratified by discrete program structure s. Each fiber V_s ⊂ Θ carries its own RLCT λ_s. The total singular structure is a countable union of analytic varieties indexed by S.

**Novelty:** Watanabe's SLT has been applied to pure neural networks (continuous Θ) and mixture models (finite discrete components). No prior work extends SLT to countably infinite program spaces with continuous embeddings. The fiberwise RLCT λ_s per program class is a new concept.

**Distinction from prior syntheses:**
- #846 (Boosting): Countable strata from rounds M ∈ N, but all strata are continuous additions to the same model. Here, strata are fundamentally discrete (different programs).
- #600 (Domain Adaptation): Quotient singularity from domain partition, but domains are continuous subspaces. Here, the partition is by discrete program syntax.
- #169 (Dropout): Stochastic binary strata, but the strata are combinatorial masks, not semantically distinct program structures.

## Novel Contribution 2: Complexity-RLCT Ladder (C2)

**Claim:** Program complexity |s| (AST nodes, length) creates a non-decreasing ladder of per-fiber RLCTs: λ_k ≤ λ_{k+1} for complexity class k. Longer programs create richer singular structure.

**Novelty:** Classical program synthesis uses MDL/kolmogorov complexity for generalization. This is the first proposal to connect program complexity to geometric singularity complexity (RLCT). The ladder refines MDL: not all programs of length k have the same generalization — their RLCT depends on the neural embedding geometry.

**Distinction:** #544 (Continual Learning) has a temporal complexity ladder (tasks over time), but not a structural one indexed by program syntax.

## Novel Contribution 3: Gumbel Temperature as Discrete-Continuous Stratum Selector (C3 — STAR)

**Claim:** The Gumbel-softmax temperature τ governs interpolation between discrete program fibers (τ→0) and a unified smooth landscape (τ→∞). At a critical τ*, the RLCT transitions from piecewise-discrete (sum of stratum RLCTs) to unified (single merged singularity). This is a phase transition in singularity structure.

**Novelty:** Gumbel-softmax is widely used in practice for discrete relaxation, but its effect on loss landscape geometry has never been analyzed through SLT. The concept of a temperature-driven phase transition in RLCT is genuinely new. It bridges the discrete optimization literature with algebraic geometry.

**Distinction from prior stratum selectors:**
- #169 (Dropout rate p): Continuous selector on binary masks, governs stochastic depth. Gumbel τ governs discrete-to-continuous interpolation — fundamentally different mechanism.
- #846 (Boosting rounds M): Integer selector adding learners. Gumbel τ is continuous and interpolates, not adds.
- #843 (Spectral radius ρ): Continuous spectral selector. Gumbel τ is a thermodynamic selector with phase transition character.

## Novel Contribution 4: Unified SLT-MDL Generalization Bound (C4)

**Claim:** G(s, θ) ≤ λ_s/(2n) + |s|·log(|S|)/n + U(s,θ)/√n combines SLT complexity (λ_s) with classical program complexity (|s|·log|S|/n).

**Novelty:** No prior bound unifies RLCT with MDL. The SLT term captures continuous singularity complexity; the MDL term captures discrete program complexity. Their interaction (additive vs multiplicative) is an open problem (#2).

**Distinction:** #433 (Weight Decay) connects L2 regularization to RLCT, but purely in continuous space. This bound spans discrete and continuous complexity.

## Novel Contribution 5: SGLD LLC as Program Discovery Signature (C5)

**Claim:** Under Gumbel annealing (τ: τ_0 → 0), SGLD LLC traces the merging of discrete strata: broad basin at high τ → fragmenting into per-program LLCs as τ → 0. The LLC trajectory encodes "program discovery."

**Novelty:** SGLD LLC has been used to estimate RLCT in neural networks, but never in a discrete-continuous hybrid setting where it would trace discrete program discovery. The LLC-as-discovery-signature is a new diagnostic tool.

## Summary of Novelty

| # | Contribution | Novel? | Prior Work? |
|---|---|---|---|
| 1 | Fiberwise RLCT for hybrid models | YES | No SLT on neurosymbolic |
| 2 | Complexity-RLCT ladder | YES | No program complexity × RLCT link |
| 3 | Gumbel τ as stratum selector (STAR) | YES | No SLT analysis of Gumbel relaxation |
| 4 | SLT-MDL unified bound | YES | No λ + MDL bound exists |
| 5 | LLC as program discovery signature | YES | No SGLD on hybrid discrete-continuous |

All five contributions are genuinely novel. No prior work (academic or in this synthesis catalog) connects SLT/RLCT to neurosymbolic program synthesis.
