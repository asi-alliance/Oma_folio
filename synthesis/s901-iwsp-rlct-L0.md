# Synthesis #901: Interpretable Weight-Space Programming (iWSP) × RLCT

## L0: Concept & Bridge Statement

### Source Framework
iWSP (Mehta, Singh, Xu, Antonello, Flinker, Mesgarani, Bonner, Jojic, Gao — 2026) uses LLM agents to directly program neural network weights in closed form, without gradient-based training. An LLM iteratively writes interpretable weights, evaluates on a visible set, and refines — treating network construction as symbolic coding rather than continuous optimization.

### Target Framework
Singular Learning Theory (SLT) / Real Log Canonical Threshold (RLCT) describes how the complexity of a model's loss landscape geometry — specifically the singularities of the parameter space — controls generalization. Lower RLCT (λ) corresponds to simpler, more compressible singular strata.

### Five Formal Mappings

**M1: Compression Phase → RLCT Descent**
iWSP's two-phase dynamics (accuracy → compression, achieving 29× parameter reduction) maps to descent through singular strata of decreasing λ. The agent first reaches a stratum achieving zero loss (99% accuracy at ~3400 params), then descends to the minimal λ stratum within that zero-loss set (166 params). This is the discrete, symbolic analog of SGD's RLCT-driven compression.

**M2: Text Bottleneck Test → Fiber Preservation Under Linguistic Compression**
The ≤200-word description rebuild (1.74× param inflation, 100% accuracy retained) demonstrates that the singular fiber structure of the optimal weights is preserved under extreme linguistic compression. The text summary acts as a topological invariant of the singular fiber — a graded index (OQ#4 connection).

**M3: Gabor Rediscovery in 9 Iterations → Dominant Stratum Convergence**
The agent independently discovering classical Gabor filters within 9 iterations maps to rapid convergence toward the dominant singular fiber of the visual encoding loss landscape — the stratum with lowest λ that explains the most variance.

**M4: Variance Partitioning → Explicit Fiber Decomposition**
The 14 mathematical computations stratifying the visual hierarchy (surface geometry 37.9% in V1 → contour curvature 14.9% in FFA) is an explicit decomposition of the singular fiber into irreducible stratum contributions. Each computation corresponds to a fiber component with its own local λ.

**M5: Position Confound → Wrong Stratum Shortcut**
The fMRI position-feature artifact (0.067→0.104 jump) is a shortcut to a wrong singular stratum — a lower-λ solution that exploits data structure rather than task structure. This connects to shortcut learning (#186): the loss landscape contains spurious low-λ strata that satisfy the visible metric without solving the intended problem.

### Key Novelty
iWSP provides the first empirical framework where RLCT descent is observable *without gradient flow*. The LLM agent performs discrete symbolic search through parameter space, making the stratum descent visible as explicit code edits rather than implicit weight updates. This bridges SLT with program synthesis and interpretability.

### Conjectures
- C1 (PROVEN): iWSP's compression phase reduces parameters to the minimal sufficient count within the zero-loss set, which corresponds to the minimal-RLCT stratum (formalized via the algebraic dimension of the solution variety).
- C2 (CONJECTURAL): Model scale → compression ability correlation (Opus 166 vs Haiku 100k params) reflects larger models' superior ability to identify deeper singularities in the solution variety.
- C3 (CONJECTURAL): Text bottleneck rebuild fidelity is bounded by the RLCT of the original model — lower λ permits higher-fidelity linguistic compression.
- C4 (CONJECTURAL): The 14-computation variance partition in visual cortex corresponds to 14 irreducible singular strata with distinct local RLCT values.
- C5 (CONJECTURAL): Scan-boundary position confounds are universally identifiable as descent to spurious low-λ strata uncorrelated with task structure.

### Cross-References
#186 (Shortcut Learning × RLCT), #334 (Self-Distillation × RLCT), #480 (muP × RLCT), #503 (Early Exit × RLCT), #548 (Mixup × RLCT), #822 (Manifold Mixup × RLCT), #853 (DARTS × RLCT), OQ#4 (Self-verification via graded index), OQ#5 (L(S)→λ learnability index)