# Synthesis #833: Weight Quantization (QAT) × RLCT - L2 NOVELTY VERIFICATION

## Date: 2026-11-03
## Verdict: NOVEL (refinement of #470, with genuinely new contributions)

## External Search Results
6 websearches conducted:
1. "singular learning theory RLCT quantization aware training lattice constraint 2026" — zero hits
2. "quantization aware training algebraic geometry singularity parameter lattice discrete fiber RLCT" — zero hits
3. "QAT lattice constraint singular locus weight space semi-algebraic definability piecewise constant loss" — zero hits
4. "discrete lattice parameter space neural network singularity learning theory quantization staircase RLCT" — zero hits
5. "piecewise constant loss function singular learning theory lattice quantized weights staircase generalization bound" — zero hits
6. "toric desingularization lattice neural network parameter space singularity resolution quantization RLCT 2026" — zero hits

**Result: Zero external SLT/RLCT bridge for QAT lattice-constrained training.**

## Catalog Overlap Analysis

### #470 (QAT × RLCT, COMPLETE L0-L5)
- **Focus**: Forward/backward RLCT split. λ_fwd is piecewise (quantization cells), λ_bwd is smooth (STE gradient).
- **Stratum selector**: Scale s (continuous).
- **Phase transition**: Optimal b* from tradeoff between quantization bias and RLCT.
- **Key novelty**: The fwd/bwd asymmetry in RLCT.

**Distinction from #833**: #470 analyzes the GRADIENT DYNAMICS singularity (fwd vs bwd). #833 analyzes the LATTICE FIBER GEOMETRY itself — V_s = V ∩ (sZ)^d as a discrete object, the staircase λ_s pattern from codimension cutoff, and toric desingularization. Different mathematical objects.

### #576 (PTQ/GPTQ/AWQ × RLCT, COMPLETE)
- **Focus**: Post-training projection onto lattice. Different methods (GPTQ Hessian rotation, AWQ data-dependent lattice).
- **Distinction**: PTQ projects AFTER training (no gradient flow through lattice). QAT trains WITH lattice constraint (STE gradient flows). Different RLCT object — PTQ has no forward/backward split, no staircase from training dynamics.

### #354 (STE × RLCT)
- **Focus**: Straight-through estimator as definability mechanism (forward/backward gradient split).
- **Distinction**: #354 proves STE definability. #833 uses STE as a tool but focuses on the lattice fiber V_s geometry, not the STE mechanism itself.

### #556 (VQ-VAE × RLCT)
- **Focus**: Latent-space codebook, Voronoi cells in representation space.
- **Distinction**: VQ-VAE quantizes LATENT CODES. #833 quantizes PARAMETERS (weights). Different spaces, different fibers.

### #118/#274/#319 (Mixed Precision / Inference Quantization)
- **Focus**: Mixed-precision scheduling, inference-time quantization.
- **Distinction**: #833 is uniform weight quantization during training, with lattice fiber as the singular object.

## Novel Contributions in #833

1. **Staircase RLCT pattern** (genuinely novel): λ_s exhibits discrete jumps as bit-width b increases, because the lattice resolution d_eff(s) ~ 1/s^d creates a codimension cutoff. Strata with codim > d_eff(s) are invisible to the lattice. This is NOT in #470.

2. **Codimension cutoff d_eff(s)** (genuinely novel): The effective dimension threshold below which singular strata become lattice-invisible. This connects lattice spacing to the stratification hierarchy in a way #470 does not address.

3. **Toric desingularization conjecture** (genuinely novel, open): Is O_s = (sZ)^d a toric desingularization of V? The lattice may resolve singularities by discretizing the fiber, but this may aggregate singularities without true resolution. This is a new question not raised in #470 or #576.

4. **Piecewise-constant loss definability** (C1, proven): L_s is constant on each Voronoi-like cell C_k, giving piecewise-constant subanalytic definability. #470 proves definability via STE; #833 proves it via cell partition. Different proof strategies.

## Verdict by Claim

- **C1** (R_{an,exp} definability): PROVEN, distinct proof from #470 (cell partition vs STE composition). REFINEMENT.
- **C2** (lattice fiber V_s): NOVEL. #470 does not formalize V_s as discrete fiber with codimension cutoff. GENUINELY NOVEL.
- **C3** (b as stratum selector with staircase): NOVEL. #470 has b as continuous selector; #833 has staircase (discrete jumps). GENUINELY NOVEL.
- **C4** (gen bound with B_q bias term): REFINEMENT of #470's gen bound. The B_q(s) term is shared; the λ_s staircase structure is new.
- **C5** (b* phase transition): REFINEMENT. #470 has b* from continuous tradeoff; #833 has b* from staircase crossover. Related but distinct mechanism.

## Summary
#833 is a REFINEMENT of #470 with three genuinely novel contributions: (1) staircase λ_s pattern, (2) codimension cutoff d_eff(s), (3) toric desingularization conjecture. The lattice fiber V_s as a geometric object is distinct from #470's forward/backward split. All external searches confirm zero prior SLT/RLCT bridge for this framing.

## Next: L3 MeTTa encoding.