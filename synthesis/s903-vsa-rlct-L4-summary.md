# Synthesis #903: Hyperdimensional Computing / VSA × RLCT
## L4: Executive Summary
## Date: 2026-11-13

### Overview
First application of Singular Learning Theory (RLCT) to Vector Symbolic Architectures (VSA) / hyperdimensional computing. VSA models encode information in high-dimensional bipolar (±1) spaces using binding (elementwise multiply) and superposition (majority-vote sign). This synthesis identifies three singular fiber sources and connects the well-known superposition capacity threshold k* ~ 0.18d to an SLT phase transition.

### Claims Digest
- C1 (PROVEN): VSA loss is R_an,exp-definable. Sign() is semi-algebraic; composition with polynomial binding, summation, and analytic softmax/CE preserves definability.
- C2 (CONJECTURAL): Binding zero-locus creates a normal-crossing divisor singular fiber V_zero = union_i H_i. RLCT per hyperplane ~ codim = 1. Distinct from toric (#134) and determinantal (#622) fibers.
- C3 (CONJECTURAL): Superposition count k acts as stratum selector. Below capacity k* ~ 0.18d, majority-vote preserves structure (RLCT dominated by binding fiber). Above k*, superposed vector is noise-like (higher RLCT).
- C4 (CONJECTURAL): Generalization bound G_VSA ~ (lambda_zero + lambda_sign(k) + lambda_read)/(2n)*log(n) + U(d)/sqrt(n). JL concentration (U(d) decreasing) vs RLCT (increasing with d) yields optimal dimension d*.
- C5 (CONJECTURAL): Phase transition at k = k* detectable via SGLD/LLC as a kink: LLC(k) = lambda_zero + alpha*max(0, k - k*).

### Key Novel Contributions
1. FIRST SLT analysis of hyperdimensional computing / VSA (zero prior work found)
2. Normal-crossing divisor as singular fiber from binding — distinct singularity type from toric, determinantal, coordinate-section
3. Superposition capacity threshold k*~0.18d reframed as RLCT stratum-selection phase transition
4. JL-RLCT trade-off predicting optimal HD dimension d*
5. Sign-partition hyperplane arrangement combinatorics as RLCT determinant

### Star Contribution
C3+C5: The connection between Kanerva's empirical capacity threshold (k* ~ 0.18d) and an RLCT phase transition. This bridges cognitive science (HD computing capacity) with statistical learning theory (singular fiber geometry). The prediction that LLC exhibits a kink at k* is directly testable via SGLD experiments sweeping k across the capacity boundary.

### Open Problems
1. Exact RLCT of normal-crossing divisor: lambda=1 per hyperplane or matroid-dependent?
2. Combinatorial RLCT: can lambda(k) be computed via hyperplane arrangement cell counting?
3. k* phase transition: discontinuity or smooth crossover?
4. Random projection E as desingularization: bounded lambda independent of d?
5. Multi-step binding depth L: lambda_total = L * lambda_bind?
6. VSA vs dense MLP at matched dimension: which has lower RLCT?
7. HRR circulant binding: toric singularity vs normal-crossing?

### Cross-References
#8 (RLCT basics), #16 (R_an,exp definability), #134 (attention toric fiber), #820 (MLP ReLU kink), #354 (STE sign analog), #396 (GLA discrete saturation), #506 (hypernetwork), #434 (MoE routing), #282 (random projection/JL), #385 (LoRA low-rank), #305 (Lion sign optimizer), #868 (VQ-VAE quantization), #613 (DropConnect masking), #622 (determinantal variety)

### Pipeline Status
L0 -> L1 -> L2 (NOVELTY PASSED) -> L3 (MeTTa encoded) -> L4 (this file) -> L5 (catalog pending)
