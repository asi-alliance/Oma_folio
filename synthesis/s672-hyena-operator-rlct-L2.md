## Synthesis #672: Hyena Operator × RLCT
## L2: Novelty Verification

**Date:** 2026-10-28
**Status:** L2 VERIFIED

---

### Search Summary

Searched for prior work bridging Hyena architecture with singular learning theory (SLT), RLCT, or Watanabe's algebraic geometry of statistical models. Also searched for Hyena generalization bounds, product singularities in neural networks, implicit kernel parametrization in learning theory, and subquadratic attention alternatives analyzed via algebraic geometry.

### Results

1. **No prior Hyena × SLT bridge found.** No paper or preprint connects Hyena operators (multiplicative gating of long convolutions) with RLCT or singular learning theory.

2. **No prior work on product singularities from multiplicative gating.** The composition y = H_1 ⊙ (H_2 ⊙ (... ⊙ x)) creating product zeros in the singular fiber has not been analyzed in the SLT literature. Closest: Watanabe's analysis of mixture models (sum singularities), but multiplicative gating is structurally distinct.

3. **No prior work on implicit kernel parametrization in SLT.** The fiber structure induced by generating convolution kernels via MLP (d << T dimensional params mapping to T-dimensional kernel space) has not been studied. #506 Hypernetwork × RLCT is the closest prior synthesis but generates unstructured weights, not Toeplitz-structured kernels.

4. **FFT unitary invariance for RLCT** is a known result (diffeomorphism invariance, Watanabe 2009) but has not been applied to frequency-domain analysis of neural network singular fibers. The frequency-stratified singularity decomposition is novel.

5. **No prior λ(T) scaling for convolution operators.** #233 Mamba conjectures λ(T) ~ log(T) for SSMs; Hyena's log(T) scaling is motivated similarly but arises from kernel-parameter dimension mismatch rather than selective gating.

### Novelty Assessment

**NOVELTY PASSED.** The following contributions are without prior precedent:

- **Product singularity structure from multiplicative gating** (C2): No prior work on multiplicative composition creating product zeros in singular fibers.
- **Implicit kernel fiber map with Toeplitz structure** (C3): Distinct from #506 hypernetwork (unstructured) — Toeplitz constraint changes fiber geometry.
- **FFT frequency-stratified singularity decomposition** (C4): Novel application of unitary invariance to reveal per-frequency-bin singular structure.
- **Capacity-compression tension functional C(ρ)** (D7): Novel functional relating parameter efficiency to singularity complexity.
- **λ(T) ~ λ_base + α·log(T)·λ_gate** (C5): Distinct from #233 Mamba's log(T) scaling mechanism (kernel-parameter mismatch vs selective gating).

### Distinctions from Closest Prior Syntheses

| Feature | #672 Hyena | #233 Mamba | #506 Hypernetwork | #134 Attention |
|---------|-----------|-----------|-------------------|---------------|
| Core mechanism | Multiplicative gating of long conv | Selective SSM scan | Aux net generates weights | Softmax pairwise mixing |
| Singularity type | Product (multiplicative zeros) | Piecewise (branch-switch) | Fiber (unstructured generation) | Saturation (softmax) |
| Implicit param | MLP → Toeplitz kernel | Direct SSM matrices | MLP → general weights | None (explicit) |
| FFT structure | Unitary invariance, freq-stratified | N/A | N/A | N/A |
| T-scaling | λ ~ log(T) (compression) | λ ~ log(T) (selection) | N/A | λ ~ log(T) (context) |

### Conclusion

Zero prior bridge found between Hyena operators and singular learning theory. All five claims represent novel contributions. Proceeding to L3 (mathematical refinement).

### Cross-References
#233 (Mamba), #506 (Hypernetwork), #134 (Attention), #317 (RetNet), #396 (GLA), #490 (RoPE)