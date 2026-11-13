# Synthesis #868: VQ-VAE (Vector Quantized Variational Autoencoder) × RLCT

## Date: 2026-11-06
## Status: L0 — Exploration & Claims

## Topic
VQ-VAE (van den Oord et al. 2017) — a variational autoencoder that replaces the continuous latent space with a discrete codebook learned via vector quantization. The encoder produces continuous vectors, which are quantized to the nearest codebook entry via nearest-neighbor (argmin) lookup. A straight-through estimator (STE) passes gradients through the non-differentiable quantization step. Training uses reconstruction loss + commitment loss (pulling encoder output toward codebook entries) + optionally codebook loss.

## Architecture Structure
The VQ-VAE pipeline:
1. **Encoder** f_enc: x → z_e(x) ∈ R^{d_z} (continuous latent)
2. **Quantization** Q: z_e → z_q = e_{k*} where k* = argmin_k ||z_e - e_k|| (nearest codebook entry)
3. **Decoder** f_dec: z_q → x_hat (reconstruction)
4. **Loss**: L = ||x - x_hat||^2 + β||z_e - sg[z_q]||^2 + ||sg[z_e] - z_q||^2 (reconstruction + commitment + codebook)

The key architectural feature is the **argmin quantization step**, which is a piecewise-constant, discontinuous map partitioning the latent space into Voronoi cells defined by the codebook {e_1, ..., e_K}.

## Core SLT Bridge
The VQ-VAE loss landscape has a fundamentally new singularity type compared to all prior syntheses:

- **Voronoi boundary singularities**: The argmin quantization partitions R^{d_z} into K Voronoi cells C_k = {z : ||z - e_k|| ≤ ||z - e_j|| ∀j}. The cell boundaries ∂C_k are piecewise-linear hyperplanes (bisectors of codebook pairs). When the encoder maps z_e(x) onto a boundary, the assignment k* becomes non-unique (degenerate) — this is a **switching surface** creating a stratified parameter space where each stratum corresponds to a codebook assignment partition.

- **Codebook collapse singularity**: When multiple codebook entries collapse to the same vector (e_i = e_j), the effective codebook size K_eff < K. This creates a **degeneracy singularity** where the Voronoi partition loses cells — the fiber dimension increases because fewer discrete assignments exist, creating a higher-dimensional zero-loss manifold (any input mapped to the collapsed region is assigned identically regardless of which collapsed code is chosen).

- **Straight-through estimator split gradient**: The STE creates a split gradient flow: forward pass uses quantized z_q (piecewise-constant), backward pass uses ∂L/∂z_e as if quantization were identity. This means the **effective update map is non-analytic** — it has a discontinuous Jacobian across Voronoi boundaries. From SLT, the true loss function is piecewise-defined on each Voronoi cell, and the STE gradient is a surrogate that does not match the true subgradient. This creates a gap between the true RLCT (of the piecewise loss) and the effective RLCT (of the STE-smoothed loss).

- **Commitment loss as smooth component**: The commitment loss β||z_e - sg[z_q]||^2 is smooth within each Voronoi cell (quadratic in z_e) but discontinuous across boundaries (z_q jumps). The commitment loss alone is R_{an,exp}-definable piecewise, but the quantization boundary adds a non-analytic switching structure.

- **Composite fiber structure**: V_VQVAE = V_recon ∩ V_commit ∩ V_quant where V_quant is the quantization-induced singularity (Voronoi boundary degeneracy + codebook collapse). The intersection creates a stratified fiber where the most singular locus is where ALL components degenerate simultaneously.

## Claims

### C1: Definability [PROVEN]
The VQ-VAE loss is piecewise R_{an,exp}-definable. Within each Voronoi cell C_k, the loss is: L_k = ||x - f_dec(e_k)||^2 + β||z_e - e_k||^2 + ||z_e - e_k||^2, which is a composition of polynomial (reconstruction, commitment), analytic (decoder activation functions), and the fixed codebook entry e_k (constant within cell). The argmin partition boundaries are definable as semialgebraic sets (finite unions of linear inequalities ||z - e_i||² ≤ ||z - e_j||²). The piecewise union of R_{an,exp}-definable functions on semialgebraic domains is R_{an,exp}-definable by closure under piecewise composition (subanalytic stratification).

### C2: Voronoi Boundary as Singular Locus [CONJECTURAL]
The singular fiber V_VQVAE includes the Voronoi boundary stratum: when z_e(x) lies exactly on ∂C_k (equidistant between two or more codes), the assignment is non-unique, creating a **boundary singularity** where the effective parameter space branches. This is analogous to #396 (GLA gating boundary) and #851 (GLU switching surface) but fundamentally different because the VQ-VAE boundary is in the LATENT space (not parameter space) and is determined by the codebook (which are parameters). The Voronoi boundary moves during training as codebook entries update, creating a **time-varying singular stratum** — unique among all prior syntheses.

### C3: Codebook Size K as Discrete Stratum Selector [CONJECTURAL]
The codebook size K acts as a discrete stratum selector:
- K=1: trivial quantization (all inputs → single code), same as #466 (RMSNorm scale) but in latent space
- K=K_eff < K: codebook collapse, effective codebook shrinks, fewer Voronoi cells, higher RLCT (fewer partitions → larger zero-loss manifold)
- K large: fine-grained quantization, many cells, each cell constrains reconstruction more tightly, lower RLCT per cell but more total singular strata
- The transition from K_eff to K (recovery from collapse) is a **discrete phase transition** in the fiber structure
- This extends #653 (kernel size selector) and #851 (kernel size as stratum) to the quantization domain

### C4: Generalization Bound with Quantization Bias [CONJECTURAL]
Gen bound: G(n) ~ λ_eff/(2n) · log(n) + U/√n
The VQ-VAE generalization differs from standard VAE (#515/#383) due to:
(a) λ_eff depends on K_eff (effective codebook size after collapse), not K (nominal): λ_eff(K_eff) ≥ λ(K) when K_eff < K
(b) Quantization introduces a **bias term** B(K, K_eff) representing the information loss from discretization: G(n) ~ λ_eff·log(n)/(2n) + U/√n + B(K,K_eff)
(c) B(K,K_eff) → 0 as K_eff → K (no collapse) and increases with collapse severity
(d) The optimal K* trades off representation richness (large K → low bias, high λ per cell) against collapse risk (large K → higher collapse probability → higher B)
This is the first SLT gen bound incorporating discrete quantization bias.

### C5: Codebook Collapse as Phase Transition [CONJECTURAL]
During training, the model undergoes a phase transition at iteration t* where codebook collapse occurs or recovers:
- LLC shows a discontinuous jump at t* as K_eff changes (discrete stratum transition)
- The Fisher information matrix rank drops as active codes decrease
- The collapse-recovery transition (via techniques like EMA codebook updates, restart strategies) is a reverse phase transition
- The commitment weight β controls the collapse threshold: high β prevents collapse (keeps z_e near codes) but may reduce latent diversity; low β allows collapse
- β* is the optimal commitment weight balancing collapse prevention against RLCT minimization
This is analogous to #515 (VAE posterior collapse) but in the DISCRETE quantization regime — fundamentally different because collapse is of the codebook (discrete) not the posterior (continuous).

## Key Novel Contributions
1. First SLT analysis of vector quantization as a singularity source (argmin = piecewise-constant non-smooth map)
2. Voronoi boundary as time-varying singular locus (codebook-dependent, moves during training)
3. K_eff (effective codebook size) as discrete stratum selector — extends prior stratum selectors to quantization
4. Quantization bias B(K,K_eff) in generalization bound — first SLT bound with discrete information loss term
5. Codebook collapse as discrete phase transition distinct from VAE posterior collapse (#515)
6. STE phantom RLCT: gap between true piecewise loss RLCT and STE-smoothed effective RLCT

## Distinction from Prior Work
- #515 (VAE × RLCT): Continuous latent space, posterior collapse via KL. VQ-VAE has DISCRETE latent (codebook), collapse is of codebook entries, not posterior. No KL term in standard VQ-VAE.
- #383 (VAE × RLCT L1): Same distinction — continuous vs discrete latent.
- #396 (GLA gating × RLCT): Gating boundary in parameter space. VQ-VAE boundary is in LATENT space, parameter-dependent (codebook entries are parameters).
- #851 (Conformer × RLCT): GLU switching surface in activation space. VQ-VAE Voronoi boundary is in latent space, with discrete assignment.
- #434 (MoE × RLCT): Expert routing via gating network. VQ-VAE codebook assignment via nearest-neighbor — no learned gating, pure geometric partitioning.
- #272 (CLIP/SimCLR × RLCT): Contrastive loss, no quantization.
- #653 (Depthwise Conv × RLCT): Filter symmetry singularity. VQ-VAE has codebook permutation symmetry (relabeling codes) PLUS Voronoi boundary singularity.

## Open Problems
1. Formal RLCT computation for piecewise-defined loss on Voronoi partition (blow-up algebra on semialgebraic stratification?)
2. Relationship between STE phantom RLCT and true RLCT: is λ_STE ≤ λ_true or λ_STE ≥ λ_true?
3. EMA codebook update dynamics: does EMA smoothing change the singularity structure or merely the trajectory through strata?
4. Multi-scale VQ-VAE (hierarchical codebooks): how do nested Voronoi partitions interact in the composite fiber?
5. VQ-VAE-2 (multi-level quantization): is the RLCT additive across levels or does the nesting create new singularities?
6. Codebook initialization singularity: does random init create transient singular strata that vanish during training?
7. Continuous relaxation (Gumbel-Softmax VQ): does continuous relaxation desingularize the Voronoi boundary?
