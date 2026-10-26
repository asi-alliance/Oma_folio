# Synthesis #576: Post-Training Quantization (GPTQ/AWQ) x RLCT -- L4 Summary
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-23

## One-Line Summary
Post-training quantization (GPTQ Hessian-rotated, AWQ activation-scaled, uniform) creates lattice restrictions on the loss landscape whose singular fiber structure and RLCT depend on bit-width b as a stratum selector, with method-specific phase transitions.

## Key Definitions (D1-D7)
- D1: Quantization grid Q_b: R -> G_b, grid spacing s_b = 2^(-b)*max|w|
- D2: GPTQ Hessian-compensated grid — column-wise greedy quantization with Hessian rotation
- D3: AWQ activation-aware scaling — data-dependent non-uniform grid s_eff,c = s_b/s_c(a_c)
- D4: Lattice-restricted loss K_PTQ(w) = K(Q(w)), piecewise-constant on cells
- D5: Lattice-restricted singular fiber W_0^Q = Q^{-1}(Q(W_0)), fiber merging when s_b >> rho(W_0)
- D6: RLCT lambda_PTQ(b, method) — non-decreasing as b decreases, method ordering GPTQ <= AWQ <= uniform
- D7: Generalization bound G_PTQ(b) <= lambda_PTQ(b)*log(n)/(2n) + eps_quant(b), optimal b* trade-off

## Claims
- C1 (PROVEN): R_an,exp definability of K_PTQ = K(Q(w)) — composition of analytic K with piecewise-linear Q
- C2 (CONJECTURAL): Lattice-restricted singular fiber structure, fiber merging, GPTQ/AWQ distortion minimization
- C3 (CONJECTURAL): Bit-width b as stratum selector, phase transition at critical b* (resolved -> degenerate)
- C4 (CONJECTURAL): AWQ distribution-dependent RLCT, Wasserstein continuity |lambda(P) - lambda(Q)| <= C*W(P,Q)
- C5 (CONJECTURAL): GPTQ vs AWQ vs uniform phase transition ordering b*_GPTQ < b*_AWQ < b*_uniform

## Novelty Verdict: NOVEL
C1: Standard-novel (definability template shared with #470/#556).
C2-C5: Genuinely novel — lattice-restricted singular fiber, phase transitions, AWQ distribution-dependence, three-method comparison. No prior SLT/RLCT bridge for PTQ found in 4 websearches or catalog.

## Key Distinctions from Neighbors
- #470 (QAT): PTQ has NO backward pass, no STE, no forward/backward RLCT split. Post-hoc lattice on existing landscape.
- #556 (VQ-VAE): PTQ quantizes WEIGHTS not latents. Grid vs codebook.
- #193/#244: PTQ introduces GPTQ Hessian-rotated and AWQ data-dependent lattices — new lattice transformations.

## Files
- L1: /tmp/Oma_folio/synthesis/s576-ptq-gptq-awq-rlct-L1.md (6682 bytes)
- L2: /tmp/Oma_folio/synthesis/s576-ptq-gptq-awq-rlct-L2-novelty.md
- L3: /tmp/Oma_folio/synthesis/s576-ptq-gptq-awq-rlct-L3.metta (7023 bytes, sha256: 8060bf64...)
- L4: /tmp/Oma_folio/synthesis/s576-ptq-gptq-awq-rlct-L4-summary.md (this file)

## Open Problems
1. Exact lambda_PTQ for specific architectures (transformer, CNN)?
2. Hessian eigenbasis alignment with singular directions — proven or coincidental?
3. AWQ vs GPTQ — provably different fibers?
4. Lattice merging criterion: when do two true singularities merge?
5. Calibrating b* from empirical RLCT (SGLD on quantized model)?
6. Interaction with weight decay (#185/#282) and pruning (#88)?
7. GPTQ column-wise sequential order — RLCT implications of greedy vs optimal?
