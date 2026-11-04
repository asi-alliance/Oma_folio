# Synthesis #840: Weight Quantization (QAT) x RLCT - L1 FORMALIZATION

## Date: 2026-11-03
## Pipeline: L0-L1 COMPLETE. L2 pending.

## Distinction from Prior Work
- #354 (STE): focuses on forward/backward gradient split. #840 focuses on the LATTICE CONSTRAINT itself as singular structure.
- #556 (VQ-VAE): latent-space codebook Voronoi cells. #840 quantizes PARAMETERS directly.
- #576 (PTQ/GPTQ/AWQ): post-training projection onto lattice. #840 = QAT; training WITH quantization. Different RLCT object.
- #118/#274/#319: mixed-precision/inference quantization. #840 = uniform weight quantization during training.

## Formal Definitions

### D1: Parameter Space and Quantization Grid
Let W subset R^d be compact (closure in [-R, R]^d). For b-bit quantization, s = 2^{-b}. The lattice O_s = (sZ)^d contains discrete points. The quantization map:

Q_s(w) = s * round(w/s)

### D2: Quantized Loss
QAT loss: L_s(w) = (1/n) sum_i ell(f_{w_hat_q}(x_i), y_i) where w_hat_q = Q_s(w). STE gradient: nabla_s w L_s(w_hat_q) where w_hat_q is the float-point copy.

### D3: R_{an,exp} Definability (C1: PROVEN)
Q_s partitions W by Voronoi-like cells C_k = {w in W : floor(w/s) = k} = span semi-algebraic [k*s - s/2, k*s + s/2)^d space+ s^2 - floor(w/s) = k)}. Each cell is convex semi-algebraic. Partition is finite since W is compact. On each cell, L_s(w) = L(k*s) is constant. L analytic (standard SLT). Each cell semi-algebraic. L_s piecewise-constant subanalytic, hence definable in R_{an,exp} by finite union closure. QED.

### D4: Lattice-Constrained Singular Fiber (C2: CONJECTURAL)
V = {w in W : L(w) = 0}. Lattice fiber: V_s = V cap O_s where O_s = (sZ)^d is the lattice grid. V_s is discrete: finite or countably infinite intersection of V with the lattice grid.

Key insight: finite lattice spacing s creates a CUTOFF on the RLCT spectrum. Strata of codimension > d_eff(s) are invisible, where d_eff(s) ~ 1/s^d is the lattice resolution. The effective RLCT is:
lambda_s ~ min{lambda_i : codim(Stratum_i) >= d_eff(s)}

This produces a STAIRCASE pattern in lambda_s vs b = log_2(1/s): as b increases, new strata become lattice-visible continuously, causing discrete jumps in lambda_s.

### D5: Bit-Width b as Stratum Selector (C3: CONJECTURAL)
b = log_2(1/s) controls which singular strata are visible to the lattice. Low b (coarse lattice): only high-dimensional strata sampled, lambda_s ~ d/2 (generic, high). High b (fine lattice): all strata sampled, lambda_s -> lambda (true RLCT, lower). Transition is NOT smooth - occurs in discrete jumps as new strata become lattice-visible. Staircase pattern.

### D6: Generalization Bound (C4: CONJECTURAL)
G_s(n) ~ lambda_s * log(n)/(2n) + U_s / sqrt(n) + B_q(s)
where B_q(s) = E_{(x,y)}[||f_{w_hat_q}(x) - f_w*(x)||^2] <= C * s * ||grad f||_infty (Lipschitz bound). Tradeoff: lower b (larger s) increases B_q but may increase lambda_s. Optimal b* minimizes G_s.

### D7: Phase Transition at b* (C5: CONJECTURAL)
The optimal bit-width b* satisfies: d(lambda_s)/db * log(n)/(2n) >= -d(B_q)/db / sqrt(n). This gives b* ~ log_2(n^{alpha}) for some alpha depending on the RLCT staircase structure. SGLD-testable: measure LLC for models trained at different bit-widths.

## Open Problems
1. Exact form of lambda_s staircase - depends on Diophantine properties of V relative to lattice
2. STE gradient convergence: does QAT converge to lattice point minimizing L_s?
3. Stratum sampling bias: V_s misses lower-codimension strata if lattice resolution is poor. Measurable via SGLD lattice-fast transition compared to fiber stratum
4. Different underlying stratum frameworks for d_eff(s) > codim(stratum)
5. Interaction with weight decay and pruning: compound singularity (L_2, sparsity, lattice)
6. SGLD testability: can staircase pattern be observed empirically?
7. Toric desingularization connection: does O_s resolve V singularity?

## Cross-References
#354 (STE forward/backward split), #556 (VQ-VAE latent quantization), #576 (PTQ post-training), #118/#274/#319 (mixed precision/inference), #169 (dropout stochastic masking), #258 (mixup data-space), #405 (pruning sparsity vs quantization), #88/#832 (equivariance lattice symmetry), #56 (toric varieties), #127 (compression bound)

## Next: L2 novelty verification.
