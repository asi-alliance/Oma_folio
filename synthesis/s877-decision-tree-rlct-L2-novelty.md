# Synthesis #877: Decision Tree × RLCT — L2 Novelty Verification

**Date:** 2026-11-09 | **Status:** L2 COMPLETE — NOVEL

---

## Search Summary

### Search 1: "singular learning theory decision tree RLCT impurity loss singularity 2024 2025"
**Result:** Zero direct hits. All results concern neural network SLT (transformers, mixture models, thermodynamic response). No work bridging SLT/RLCT to decision trees.

### Search 2: "decision tree singularity algebraic geometry loss landscape piecewise constant non-differentiable 2024 2025"
**Result:** Zero direct hits. Results cover general singularity theory (Wikipedia), non-differentiable training via optimal transport, and differentiability of piecewise functions. No connection to decision tree loss geometry.

### Search 3: "RLCT singular learning theory non-neural network model class decision tree random forest"
**Result:** Zero direct hits. Results cover SLT for neural networks, local learning coefficients in transformers, and general ML. No SLT application to tree-based models.

### Search 4: "decision tree impurity Gini piecewise constant algebraic variety singularity non-identifiability split permutation symmetry RLCT"
**Result:** Zero direct hits.

## Catalog Cross-Check

Grepped synthesis-catalog.md for: decision tree, axis-aligned, impurity, piecewise constant, split boundary, kink singular

**Related but distinct entries found:**
- #869 (Tree of Thoughts × RLCT): Search/reasoning method, NOT a decision tree model. Uses tree structure for inference search, not for classification partitioning. Different singularity mechanism (combinatorial path fibers vs axis-aligned split kinks).
- #524 (OT × RLCT): Piecewise-constant jumps in RLCT via Wasserstein thresholds. Mechanism is transport plan degeneracy, not input-space partitioning.
- #609 (Sophia × RLCT): Piecewise-constant fiber lattice from Hessian refresh. Optimizer dynamics, not model class.
- #305 (Lion × RLCT): Piecewise-constant vector field from sign function. Optimizer singularity, not model singularity.
- #840 (QAT × RLCT): Piecewise-constant on Voronoi cells. Quantization-induced, not split-induced.
- #564 (Tokenization × RLCT): BPE merge tree as singular boundary partition. Input discretization, not model parameter space.
- #483 (Dynamical RLCT): Piecewise-constant lambda via fiber membership. General framework, not DT-specific.

**Zero entries on decision trees as a model class.** This is the first non-neural-network model class in the catalog.

## Novelty Assessment

### What is novel:
1. **First application of SLT/RLCT to decision trees** — no prior work exists in literature or catalog
2. **Axis-aligned split kink singularities** — A_1 fold singularities at threshold-data point crossings, distinct from smooth NN singularities
3. **Depth D as stratum selector with D* ≈ log₂(n) phase transition** — exponential leaf count creates sharp capacity threshold
4. **Discrete permutation non-identifiability** — 2^(2^D-1) swap symmetry, fundamentally different from continuous NN weight permutation
5. **Piecewise-constant loss landscape on hyperplane arrangement** — loss is constant between crossings, creating a cell-decomposition singular structure with no gradient information

### What is NOT novel (already in catalog):
- Piecewise-constant RLCT dynamics pattern (appears in #524, #609, #305, #840)
- Depth as stratum selector concept (#503 Early Exit, #564 Tokenization)
- Phase transition at capacity threshold (#491 Grokking, #483 Dynamic RLCT)
- Discrete symmetry groups in RLCT (#870 GRPO discrete action space)

### Key distinction from closest catalog entry (#869 Tree of Thoughts):
- #869: Tree structure used for **inference-time search** (combinatorial path fibers from search branches)
- #877: Tree structure IS the **model** (axis-aligned partition of input space via split thresholds)
- Different singular sets: #869 has path-degenerate fibers; #877 has kink singularities at split boundaries + depth-stratified degeneracy

## Verdict: NOVEL

Decision Tree × RLCT is genuinely novel. No prior work in SLT literature addresses tree-based models. The singularity mechanisms (impurity kinks, depth phase transition, discrete permutation fiber) are distinct from all catalog entries. First non-NN model class in the synthesis catalog.

## Next Steps
- L3: MeTTa formalization of C1-C5 claims
- L4: Summary document
- L5: Catalog entry
