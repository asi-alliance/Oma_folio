# Synthesis #903: Hyperdimensional Computing / Vector Symbolic Architecture (VSA) x RLCT
## L0: Outline & Architecture Overview
## Date: 2026-11-13

### Architecture: Hyperdimensional Computing / VSA (Kanerva, 1997; Plate, 1995; Gayler, 1998)
Hyperdimensional computing represents information in very high-dimensional spaces (d ~ 1000-10000) using random, nearly-orthogonal vectors. Core operations:

- **Encoding**: Map symbols/concepts to random hypervectors H in {-1,+1}^d or R^d (dense distributed representation)
- **Binding** (element-wise product or convolution): C = A ⊗ B binds two vectors into a new near-orthogonal vector. In binary: XOR. In bipolar: elementwise multiply.
- **Superposition / Bundling** (majority vote or sum): S = sign(A + B + C) superposes (creates a set-like representation). Robust to noise.
- **Unbinding** (inverse binding): A ≈ C ⊗ B^{-1} ≈ C ⊗ B (for self-inverse binding like XOR/multiply).
- **Similarity**: cosine similarity or Hamming distance. Near-orthogonality gives capacity ~ 0.18d items.

Key parameter groups:
- Binding weights W_bind in R^{d x d} (or identity for elementwise multiply)
- Readout/probe matrix W_read in R^{d x k} (maps hypervectors to class labels)
- Item memory M in R^{m x d} (stored prototypes, updated via superposition)
- Encoding projection E in R^{d x p} (maps input features to HD space)

### Parameter Space
theta_vsa = (E, W_bind, M, W_read)

Key distinction from dense neural nets (#134 attention, #820 MLP): VSA operations are *fixed* (binding = elementwise multiply, bundling = majority vote). The "learning" is in the random projection E and the item memory M. The hypothesis space is structurally constrained by discrete superposition.

### Claim Preview
- **C1 (PROVEN)**: VSA loss is R_an,exp-definable. Random projection E (linear/polynomial), elementwise multiply (polynomial), sign() (piecewise definable, semi-algebraic), cosine similarity (ratio of polynomials), softmax readout (analytic). All components in R_an,exp. Closure under composition preserves definability.

- **C2 (CONJECTURAL)**: Binding singular fiber V_bind = {theta : W_bind has rank < d, OR sign() saturation locus}. Elementwise multiply binding creates a *multiplicative singularity*: when any component h_i = 0, the binding output loses information in that dimension (0 ⊗ anything = 0). The fiber V_zero = {h : h_i = 0 for some i} is a union of coordinate hyperplanes — a normal-crossing divisor. This is structurally distinct from attention rank-degeneracy (#134) or ReLU kink singularities (#8).

- **C3 (CONJECTURAL)**: Superposition capacity acts as stratum selector. Bundling via sign() creates a *majority-vote stratum*: when the number of superposed items k exceeds capacity threshold k* ~ 0.18d, the superposed vector becomes noise-like (all directions near-orthogonal to any individual item). This capacity-induced phase transition controls the effective RLCT: lambda_VSA(d, k) increases with k beyond k*.

- **C4 (CONJECTURAL)**: Generalization bound G_VSA ~ lambda_VSA(d,k)/(2n)*log(n) + U(d)/sqrt(n). High dimensionality d increases capacity (lower U) but the multiplicative binding singularity increases lambda. Trade-off phase transition at optimal dimension d*.

- **C5 (CONJECTURAL)**: Capacity phase transition at k* ~ 0.18d. As superposition count k increases past k*, the model transitions from "structured retrieval" to "noise-like storage". LLC should show a kink at k* — SGLD-detectable.

### Key Novelty
**MULTIPLICATIVE SINGULARITY from binding.** All prior syntheses involve additive or compositional singularities (ReLU kinks, attention rank, conv symmetries). VSA binding via elementwise multiply creates a fundamentally different singularity class: the zero-locus of binding is a **normal-crossing divisor** (union of coordinate hyperplanes {h_i = 0}), which has well-understood resolution of singularities and known RLCT formula. This is the first synthesis where the singularity is a classical algebraic geometry object (hyperplane arrangement) rather than a neural-network-specific degeneracy.

Additionally, the **discrete superposition stratum** (majority vote with sign()) creates a piecewise-constant hypothesis map — the loss landscape is literally a discrete partition of R^d, making RLCT computation potentially tractable via combinatorial methods rather than analytic resolution.

### Cross-References
#8 (RLCT basics), #16 (definability), #134 (attention Plucker toric fiber), #820 (MLP ReLU), #354 (STE straight-through estimator — sign() analog), #396 (GLA gating — discrete saturation), #506 (hypernetwork — generative parameter space), #434 (MoE — routing as stratum selector), #282 (random projection / Johnson-Lindenstrauss), #385 (LoRA — low-rank structure)

### Open Problems
1. Formal RLCT of normal-crossing divisor {h_i = 0} in binding: is lambda = d - (number of nonzero coordinates)?
2. Sign() superposition as piecewise-constant map: can RLCT be computed combinatorially (counting cells in the hyperplane arrangement)?
3. Capacity threshold k* ~ 0.18d: connection to RLCT phase transition — does lambda(k) show a discontinuity at k*?
4. Random projection E as resolution of singularities: does the JL lemma guarantee bounded RLCT?
5. Multi-step binding chains (hierarchies): how does RLCT compose across binding depth?
6. Comparison: VSA vs dense MLP at matched dimension — which has lower RLCT?
7. Holographic reduced representation (Plate convolution binding): different singularity structure from elementwise multiply?

### Pipeline Status
L0 (this file) -> L1 (formal definitions) -> L2 (novelty) -> L3 (MeTTa) -> L4 (summary) -> L5 (catalog)
