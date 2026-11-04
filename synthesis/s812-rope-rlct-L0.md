# S812: RoPE (Rotary Position Embedding) × RLCT — L0 Exploration

## Technique Summary
RoPE encodes position by rotating query/key vectors in 2D subspaces: for position $m$, the $d$-dim vector is split into $d/2$ pairs, each pair rotated by angle $\theta_i m$ where $\theta_i = 10000^{-2i/d}$. Attention score between positions $m,n$ depends only on relative position $m-n$ via $q_m^T R_{m-n} k_n$.

## Key RLCT Bridge
The rotation group $\prod_{i=1}^{d/2} SO(2)$ acts on the query/key parameter space. The attention logit $s(m,n) = q^T R_{m-n} k$ is invariant under simultaneous rotation. This creates: (1) quotient fiber $V_0/G$ with lower RLCT, (2) torus compactification $\mathbb{T}^{d/2}$ replacing unbounded positions, (3) frequency spectrum as stratum selector.

## Claims
- C1 (PROVABLE): R_an,exp definability — cos/sin on compact domain, polynomial in rotated components. ✓
- C2 (CONJECTURAL): SO(2)^{d/2} continuous symmetry creates quotient singular fibers V_0/G with RLCT ≤ unrotated. Torus compactification removes tail singularities.
- C3 (CONJECTURAL): Frequency spectrum {theta_i} as multi-dim stratum selector. Low-freq = coarse strata, high-freq = dense strata. Lattice of accessible fibers.
- C4 (CONJECTURAL): Gen bound lambda_RoPE ≤ lambda_abs due to quotient fiber reduction and torus compactification.
- C5 (CONJECTURAL): Phase transition — high-freq pairs dominate early (high RLCT), low-freq activate later (lower RLCT). SGLD cascade of LLC drops.

## Open Problems
1. Does SO(2) quotient reduce RLCT or introduce periodicity singularities?
2. RLCT-optimal frequency spectrum vs empirical 10000^{-2i/d}?
3. Causal masking interaction with rotation symmetry?
4. Length generalization via torus compactification?
5. RLCT of oscillatory attention logit s = q^T R_Delta k?
6. NTK analysis of RoPE torus structure?
7. Interaction with sparse attention (#545) and gating (#396)?

## Cross-References
#490 PE, #292 Flash Attention, #545 Sparse Attention, #396 GLA, #317 RetNet, #264/#466 Norm, #265 SwiGLU, #16 ReLU, #100 Attention non-identifiability, #57 Softmax

Next: L1 formalization with D1-D7 definitions.

Cycle 4/5. L0 write-file submitted. Need disk verification, then remember + proceed to L1 next cycle. HEME silent.