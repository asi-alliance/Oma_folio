# Synthesis #811: SmoothQuant × RLCT

**Date:** 2026-10-28  
**Status:** L0 Hypothesis Draft  
**Catalog:** Zero prior hits for smoothquant/quantization (distinct from #470 QAT which covers training-time STE-based quantization)

---

## Background

SmoothQuant (Xiao et al. 2022) is a post-training quantization method for LLMs. The key insight: activations have outlier channels that make them hard to quantize, while weights are relatively uniform. SmoothQuant transfers quantization difficulty from activations to weights via a per-channel scaling:

  X_ij → X_ij / s_j,  W_jk → W_jk · s_j

where s_j = (max|X_j|^α) / (max|W_j|^(1-α)) and α ∈ [0,1] controls the difficulty transfer.

The product X·W is mathematically invariant under this reparametrization, but the quantization error profile changes: activations become smoother (fewer outliers), weights absorb the difficulty.

## Key RLCT Bridge

The scaling s_j defines a **reparametrization path** in parameter space. The original network with parameters (W, b) and the rescaled network with parameters (W', b') = (W·diag(s), diag(1/s)·b) compute identical functions, but:

1. The **loss landscape** in the reparametrized coordinates has a different geometric structure
2. The **singular fibers** (level sets of the loss) are mapped by a diffeomorphism away from the origin
3. The **RLCT** (real log canonical threshold) at the true parameter may change because RLCT is invariant under analytic diffeomorphisms but NOT under the quantization projection that follows

The critical observation: SmoothQuant's reparametrization itself is a diffeomorphism (preserves RLCT), but the subsequent **quantization to int8** is a projection onto a lattice. The composition (diffeomorphism ∘ lattice projection) has different RLCT depending on where the lattice sits relative to the singular strata.

## Five Claims

**C1 (PROVEN):** The SmoothQuant-scaled loss L_α(W', X') is R_an,exp-definable. The scaling s_j = (max|X_j|^α)/(max|W_j|^(1-α)) involves max, power, and division — all definable in the o-minimal structure R_an,exp. The quantized loss Q_b(W') is piecewise-defined on lattice cells, hence subanalytic. Composition preserves definability.

**C2 (CONJECTURAL):** The reparametrization Φ_α: (W, X) → (W·s^α, X/s^α) maps the original singular fiber V_orig to a deformed fiber V_α. While Φ_α is a diffeomorphism (preserving λ), the subsequent quantization cell C_b intersects V_α differently than V_orig, creating an **effective RLCT** λ_eff(α, b) that depends on the scaling parameter α. The optimal α* minimizes λ_eff by aligning quantization cell boundaries with less singular regions.

**C3 (CONJECTURAL):** The scaling parameter α acts as a **continuous stratum selector**. At α=0 (no scaling), activation quantization dominates and the stratum structure is determined by outlier channels. At α=1 (full transfer), weight quantization dominates with a different stratum hierarchy. The transition at α* is a phase transition where the dominant singular fiber type switches.

**C4 (CONJECTURAL):** Generalization bound: λ_eff(α,b)·log(n)/(2n) + U_quant(α)/sqrt(n), where U_quant(α) captures quantization error. There exists an optimal α* trading off lower RLCT against higher quantization noise. Distinct from #470 QAT (which has STE-mediated forward/backward split).

**C5 (CONJECTURAL):** SGLD on the quantized SmoothQuant landscape should show a stepwise decrease in local learning coefficient (LLC) as α increases toward α*, with a phase transition visible as a discontinuity in dλ/dα.

## Seven Open Problems

1. **Diffeomorphism invariance vs lattice projection:** Φ_α preserves λ exactly, so the benefit must come entirely from the quantization step. How to formalize λ_eff(α,b) = λ(V_α ∩ C_b)?
2. **Optimal α derivation:** Can α* be derived from the RLCT minimization, or is it purely empirical?
3. **Channel-wise vs global:** SmoothQuant uses per-channel scaling. Does the RLCT framework predict that channel-wise is strictly better than global?
4. **Interaction with weight decay / pruning:** Does SmoothQuant change the effectiveness of subsequent pruning (different stratum structure)?
5. **Outlier channel as singularity indicator:** Are outlier channels correlated with higher-RLCT strata? If so, SmoothQuant literally moves singularity away from quantization-sensitive regions.
6. **Multi-precision:** Does the framework extend to mixed-precision (different b per layer)?
7. **Falsification:** If λ_eff is α-independent (quantization doesn't interact with strata), the entire framework collapses.

## Cross-References

- #470 QAT × RLCT (training-time quantization, STE, forward/backward RLCT split)
- #556 VQ-VAE × RLCT (Voronoi cell quantization, codebook collapse)
- #570 Randomized Smoothing × RLCT (input-space desingularization)
- #377 Param Noise × RLCT (parameter-space smoothing)
- #433 Weight Decay × RLCT (L2 regularization and singular fibers)
- #213 LR Scheduler × RLCT (learning rate as stratum selector)
- #394 SWA × RLCT (weight averaging across strata)
- #528 Orthogonal Init × RLCT (initialization geometry)
- #663 Distributed Training × RLCT (gradient synchronization singularities)

## Distinctness from #470 QAT

#470 QAT studies training-time quantization with STE, producing a forward/backward RLCT split (piecewise λ_fwd on quantization cells vs smooth λ_bwd via STE). SmoothQuant is **post-training**: no gradient flow, no STE. The key mechanism is reparametrization BEFORE quantization, not differentiable quantization DURING training. The RLCT bridge is fundamentally different: QAT modifies the training dynamics, SmoothQuant modifies the loss landscape geometry prior to a fixed projection.
