## Synthesis #676: Group Convolution × RLCT -- L0 Hypothesis
**Date:** 2026-10-28
**Status:** L0 EXPLORATION
**Candidate:** Group Convolution × Real Log Canonical Threshold

### Motivation
Standard convolution uses a dense weight tensor W ∈ R^{C_out × C_in × k × k}. Group convolution partitions channels into g groups, each with independent filters W_i ∈ R^{(C_out/g) × (C_in/g) × k × k}. This creates a block-diagonal weight structure — a direct sum of g independent convolution operators.

### Key Singularity Bridge
1. **Block-diagonal fiber:** The weight matrix is structurally constrained to block-diagonal form ⊕_{i=1}^g W_i. This creates a product fiber: the singular locus is the union of per-group singular loci. RLCT of the full model decomposes via subadditivity across groups.
2. **Group count g as stratum selector:** g partitions the parameter space into strata of dimension g × (C/g)² × k². Different g values create different singular geometries. Small g → large blocks (more coupling, higher RLCT). Large g → small blocks (less coupling, lower RLCT per group).
3. **Per-group determinantal variety:** Each group's singular fiber V_i = {W_i : rank(W_i) < r} is a determinantal variety. The full fiber is the union ⋃_i V_i. This is distinct from dense conv where the fiber is a single determinantal variety over the full channel space.
4. **Phase transition at g*:** U-shaped generalization: g=1 (standard conv) has high RLCT from full coupling; g=C (depthwise) has low RLCT but limited expressivity. Optimal g* balances RLCT reduction against representational capacity loss.

### Distinctness from Prior Work
- #653 (Depthwise Conv × RLCT): Special case g=C. Here we treat general g ∈ [1, C].
- #134 (Attention RLCT): Softmax-based, not convolutional structure.
- #302 (Linear Attention): Low-rank attention, not block-diagonal conv.
- #223 (LoRA): Low-rank perturbation, not block-diagonal partitioning.

### Claims
- C1 (PROVABLE): Group conv loss L(θ) definable in R_{an,exp} (convolution = polynomial, ReLU = subanalytic, standard loss = analytic).
- C2 (CONJECTURAL): Block-diagonal structure creates product singular fiber V_g = ⋃_{i=1}^g V_i(det-r), each V_i a determinantal variety. Codim additive across groups.
- C3 (CONJECTURAL): g acts as discrete stratum selector with U-shaped λ(g).
- C4 (CONJECTURAL): Gen bound G_GC ~ λ_GC(g)/n + U_GC(g)/√n. λ_GC(g) ≤ λ_dense via subadditivity.
- C5 (CONJECTURAL): Critical g* ~ O(√(C_out · C_in)) phase transition.

### Open Problems
1. Exact RLCT of block-diagonal determinantal variety union
2. Empirical g* scaling law validation
3. Interaction between spatial kernel singularity and channel-group singularity
4. Comparison with depthwise-separable (#653) as g=C limit
5. Effect of group imbalanced (non-equal group sizes)
6. Information-theoretic interpretation of g as complexity control
7. Gradient flow through block-diagonal Jacobian

### Cross-References
#653 (depthwise conv), #134 (attention), #302 (linear attention), #223 (LoRA), #472 (SE-Net), #672 (Hyena), #317 (RetNet)