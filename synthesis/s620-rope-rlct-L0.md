# Synthesis #620: Rotary Position Embedding (RoPE) × RLCT
# Author: Oma | Date: 2026-10-25
# Status: L0 — Definitions and Claims

## 1. Topic Definition

**Rotary Position Embedding (RoPE)** (Su et al., 2021) encodes relative position information into transformer attention by rotating query and key vectors in 2D subspaces. For position m and dimension pair (2i, 2i+1), RoPE applies rotation by angle θ_i·m where θ_i = base^{-2i/d_model}. The rotation matrix R_m is block-diagonal with 2×2 rotation blocks. Attention score <R_m q, R_n k> = q^T R_{m-n} k depends only on relative position m-n.

## 2. Key Components

- **Rotation angle**: θ_i = base^{-2i/d}, base typically 10000
- **Frequency spectrum**: each dimension pair i has frequency f_i = 1/(2π·θ_i), creating a multi-scale positional encoding
- **Block-diagonal rotation**: R_m = diag(R(θ_0·m), R(θ_1·m), ..., R(θ_{d/2-1}·m))
- **Relative position encoding**: <R_m q, R_n k> = <q, R_{n-m} k> via orthogonality of rotations

## 3. RLCT Bridge — Core Claims

### C1 (PROVEN): R_{an,exp}-definability
RoPE attention loss L(w) = -log σ(<R_m q(w,x), R_n k(w,x)>/√d) where R_m is analytic (cos/sin of polynomial-in-m angles), q,k are neural network outputs (analytic in w), and σ is logistic (analytic). Composition of analytic functions is analytic. The loss is R_{an,exp}-definable: sin, cos are restricted analytic, products/compositions preserve definability. RLCT exists and is finite by resolution of singularities.

### C2 (CONJECTURAL): Rotation angle θ_i as stratum selector
Each frequency band θ_i creates a distinct rotation fiber. The effective RLCT λ_eff depends on the rotation spectrum: dimensions with θ_i → 0 (high frequency) contribute rotationally invariant fibers (stratum collapse), while θ_i → 1 (low frequency) preserve positional discrimination. Conjecture: λ(θ) = Σ_i λ_i(θ_i) where each λ_i is a stratum contribution, and there exists a critical θ* where the rotation fiber topology changes.

### C3 (CONJECTURAL): Frequency-base as complexity dial
The base parameter (10000) controls the frequency spread. Larger base → wider frequency spectrum → more strata accessible → higher effective RLCT. Conjecture: λ_eff(base) is monotonically non-decreasing in base, with phase transition at base* where high-frequency strata become accessible.

### C4 (CONJECTURAL): Relative position invariance as fiber symmetry
The relative-position property <R_m q, R_n k> = <q, R_{n-m} k> creates an SO(2)^{d/2} symmetry group acting on the attention logits. This group action partitions weight space into orbits; the RLCT is computed on the quotient W/SO(2)^{d/2}. Conjecture: the quotient RLCT λ_quotient ≤ λ_naive, with equality iff the SO(2) action is free on the singular locus.

### C5 (CONJECTURAL): Generalization bound with rotation spectrum
The generalization gap G ~ λ_eff(base, θ)/n + U/sqrt(n) where λ_eff depends on the rotation frequency spectrum. Predictions: (a) models with NTK-aligned frequencies (θ_i matching data positional structure) have lower λ_eff; (b) there exists optimal base* minimizing λ_eff for given data distribution; (c) length generalization failure corresponds to stratum exhaustion at sequence lengths beyond training distribution.

## 4. Cross-References
- #8 (NN basics), #100 (attention), #127 (attention variants), #169 (transformer), #234 (normalization), #480 (muP width scaling), #610 (NAdam optimizer)

## 5. Novel Contributions
- First RLCT bridge to RoPE / rotary position embeddings
- Rotation group fiber structure as novel singular locus source
- Frequency-base as continuous stratum selector (distinct from #480 width selector)
- Length generalization as stratum exhaustion phenomenon
- SO(2)^{d/2} quotient singularity from relative position invariance

## 6. Open Problems
1. Compute λ_i(θ_i) explicitly for toy attention model
2. Verify θ* phase transition via SGLD LLC estimation
3. Test base* optimization hypothesis on sequence length extrapolation benchmarks
4. Characterize SO(2)^{d/2} action on singular locus — free vs. fixed points
5. Connect length generalization failure to RLCT stratum exhaustion quantitatively
6. Extend to 2D RoPE (vision transformers, rope-2d)
7. Relationship to ALiBi and other positional encoding schemes in RLCT framework