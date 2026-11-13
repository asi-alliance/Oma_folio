# Synthesis #890: Predictive Coding × RLCT
## L0 — Exploration & Hypothesis
### Date: 2026-11-09

### Background
Predictive Coding (PC) is a biologically inspired learning framework where hierarchical
generative models compute predictions top-down and error neurons propagate prediction
errors bottom-up. The energy function is variational free energy. Training minimizes
prediction error via local Hebbian/anti-Hebbian updates.

### Key RLCT Bridge Hypothesis
1. **Error neuron activation = singular locus**: Points where prediction error → 0 define
   the zero-loss set V(K), which is generically singular (many parameter configurations
   achieve zero prediction error → non-identifiability).
2. **Precision weighting as stratum selector**: Precision (inverse variance) of error
   units modulates which hierarchical levels dominate loss. Low precision → flat loss
   (high degeneracy, low λ); high precision → sharp loss (low degeneracy, high λ).
   Precision acts as continuous stratum selector analogous to bandwidth h in #889.
3. **Hierarchical depth as RLCT modulator**: Each cortical layer adds a prediction-error
   term. Deeper hierarchies create more intersecting zero-loss manifolds → higher
   degeneracy → lower RLCT. This predicts U-shaped λ(depth): too shallow = high λ
   (underfitting), optimal depth = minimal λ, too deep = over-segmentation.
4. **Phase transition at precision threshold**: As precision weighting crosses a critical
   value, the dominant stratum switches from one hierarchical level to another — a
   branch-switch singularity analogous to #469 (speculative decoding) and #889 (mean shift).
5. **Local learning rules → non-identifiability**: Hebbian/anti-Hebbian local updates
   imply parameter symmetries (permutation of error neurons within a level) → group
   action on parameter space → orbifold singularities.

### Distinct from Prior Syntheses
- #334 (self-distillation): teacher-student framework, not hierarchical generative
- #201 (meta-learning): learning-to-learn, not prediction-error minimization
- #557 (neural ODE): continuous-time dynamics, not discrete hierarchical levels
- #889 (mean shift): mode-seeking clustering, not generative prediction hierarchy
- #388 (Mirostat): adaptive entropy targeting, not cortical hierarchy

### Candidate Contributions (C1-C5)
- C1: R_{an,exp} definability of PC energy (free energy = composition of Gaussian
  negative log-likelihood + hierarchical prediction terms, all definable)
- C2: Precision-weighted stratum selector: precision π_l at level l creates
  data-dependent singular fibers; U-shaped λ(π)
- C3: Hierarchical depth RLCT inequality: deeper hierarchy → lower λ via intersecting
  zero-error manifolds (monotone or U-shaped)
- C4: Generalization bound: G_PC ~ λ/n + U/√n where U depends on precision-weighted
  error norm
- C5: Local learning rule symmetry → orbifold singularity → RLCT reduction

### Next Steps
- L1: Formal definitions (D1-D7), prove C1, conjecture C2-C5
- L2: Novelty verification (websearch for PC × SLT bridges)
- L3: MeTTa encoding
- L4: Summary
- L5: Catalog append

