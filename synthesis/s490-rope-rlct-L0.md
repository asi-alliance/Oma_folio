# Synthesis #490: RoPE (Rotary Position Embedding) × RLCT
## L0: Exploration

**Date:** 2026-10-21
**Candidate:** RoPE (Rotary Position Embedding) × RLCT
**Status:** Genuinely uncovered — zero catalog hits, zero prior SLT/RLCT bridge in websearch

### Motivation

RoPE encodes position as rotation in 2D subspaces of query/key space. The rotation matrix R_k = blockdiag(R(θ_k), R(θ_k), ...) where θ_k = k · base^{-2i/d} for dimension pair i. This creates an SO(d/2) group action on the query/key parameter space. Unlike absolute/sinusoidal PE (additive bias) or learned PE (embedding lookup), RoPE imposes a smooth group-equivariance constraint. The key question: how does this rotation group structure interact with the singular geometry of the loss landscape?

### Key Insights

1. **Rotation as desingularization:** RoPE applies a smooth, non-degenerate rotation map to Q and K. Unlike additive PE which creates offset-dependent singularities, the rotation is a diffeomorphism on each 2D block, potentially desingularizing the positional component of the loss.

2. **Frequency spectrum as stratum parameter:** θ_i = base^{-2i/d} parameterizes the rotation frequency per dimension pair. Low-frequency components (large θ_i) create near-identity rotations (degenerate stratum), high-frequency components (small θ_i) create rapid rotation (complex stratum). This frequency hierarchy naturally stratifies the parameter space.

3. **Group-equivariance constraint:** The SO(d/2) action creates continuous non-identifiability (gauge freedom) — any global rotation in a dimension pair commutes with the attention computation, creating a degenerate fiber Q/R_{SO(d/2)}.

4. **Long-context degradation as RLCT growth:** At positions beyond training distribution, the rotation angles θ_k exceed seen values. This forces the model into unexplored singular strata, increasing RLCT and degrading generalization — a geometric explanation for RoPE's context extension difficulties.

### Five Claims

**C1 (PROVEN): Definability.** RoPE's rotation matrix R_k(θ) with θ = k·base^{-2i/d} is definable in R_{an,exp}: sin, cos are restricted analytic, base^{-2i/d} is exponential, position k is integer-valued (semialgebraic). The attention score with RoPE, S(i,j) = Re[⟨q_i · R_i, k_j · R_j⟩] = Σ_l Re[q_i^{(l)} k_j^{(l)*} e^{i(l)(θ_i - θ_j)}], is a composition of definable functions. Thus the full loss with RoPE is R_{an,exp}-definable.

**C2 (CONJECTURAL): SO(d/2) gauge fiber reduces RLCT.** The rotation group SO(d/2) acts freely on the parameter space: any global rotation of a dimension pair leaves attention scores invariant (cos(θ_i - θ_j) is invariant under global phase shift). This creates a continuous degenerate fiber of dimension d/2 (one rotation per pair). The quotient by this fiber reduces the effective RLCT: λ_RoPE = λ_base - d/2·c for some constant c related to the fiber's contribution. This is lower than additive PE (no gauge symmetry) and learned PE (discrete, non-smooth).

**C3 (CONJECTURAL): Frequency index i is stratum selector.** Each dimension pair i has frequency θ_i = base^{-2i/d}. The stratum V_i consists of parameters where the i-th pair's rotation dominates the attention pattern. Low-frequency pairs (i near d/2) create near-identity strata (degenerate, high RLCT from rank deficiency). High-frequency pairs (i near 0) create rapid rotation strata (complex, lower RLCT). The stratum selector is the frequency index i, and λ_i is non-monotonic: maximally singular at extremes (near-identity or aliasing), smoothest at mid-frequencies.

**C4 (CONJECTURAL): Generalization bound with rotation fiber.** The generalization error for RoPE-equipped models satisfies: Gen ≤ λ_RoPE · log(n)/(2n) + U_RoPE/√n, where U_RoPE accounts for the rotation fiber's contribution. The key prediction: RoPE should generalize better than absolute PE at matched parameter count due to the gauge fiber reducing λ. However, for sequence lengths beyond training (extrapolation), the unexplored rotation angles create additional singular strata, increasing λ and degrading generalization — quantifiable as λ(L) > λ(L_train) for L > L_train.

**C5 (CONJECTURAL): Context length phase transition at L*.** There exists a critical context length L* where RoPE transitions from smooth (good generalization) to singular (degraded). Below L*, all rotation angles θ_k = k·base^{-2i/d} for k ≤ L remain within the trained smooth stratum. Above L*, new rotation angles access unexplored singular strata, causing a phase transition in λ. This is detectable via SGLD on the loss landscape as context length increases. L* depends on base frequency and training distribution.

### Cross-References
- #224 (Positional Encoding × RLCT — parent, RoPE claim C2 there is conjectural; here we formalize)
- #8 (Softmax × RLCT — attention score definability base)
- #16 (Attention × RLCT — shared parameter structure)
- #134 (Self-Attention × RLCT — query/key non-identifiability)
- #379 (RWKV × RLCT — position decay vs rotation)
- #233 (Mamba/SSM × RLCT — state-space position handling)

### Open Problems
1. Exact RLCT of the SO(d/2) gauge fiber for specific architectures
2. Rigorous proof that rotation quotient reduces λ below additive PE baseline
3. Monotonicity of λ_i vs frequency index i — is it truly U-shaped?
4. Formal derivation of L* from base frequency and training distribution
5. RoPE variants (NTK-aware, YaRN, position interpolation) — do they shift L*?
6. Multi-head RoPE: does per-head rotation frequency create independent strata?
7. Connection to #245: RoPE frequency spectrum and singular fiber structure

### Next Steps
- L1: Formalize definitions (rotation matrix, frequency spectrum, gauge fiber, stratum structure)
- L2: Novelty verification (confirm zero prior RoPE × SLT/RLCT work)
- L3: MeTTa encoding
- L4: Summary
- L5: Catalog append