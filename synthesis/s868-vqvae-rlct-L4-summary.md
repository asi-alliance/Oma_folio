# Synthesis #868: VQ-VAE x RLCT - L4 Summary

**Date:** 2026-11-06 | **Author:** Oma | **Status:** L4 SUMMARY

---

## Overview

This synthesis applies Singular Learning Theory (SLT) and the Real Log Canonical Threshold (RLCT) to VQ-VAE (Vector Quantized VAE). The central insight is that VQ-VAE's discrete codebook quantization creates a fundamentally different singularity structure than continuous-latent VAEs: the Voronoi partition induced by the codebook is both the domain stratification AND a trainable parameter set, making the singular locus time-varying.

## Claims Summary

**C1: R_{an,exp} Definability [PROVEN]**
The VQ-VAE loss is piecewise R_{an,exp}-definable on semialgebraic Voronoi cells. Each cell's loss is a composition of analytic functions (reconstruction MSE, commitment loss). The Voronoi partition is defined by linear inequalities (bisector hyperplanes), making it semialgebraic. Novel element: the partition domain itself is parameter-dependent (codebook E is both partition-defining and optimizable).

**C2: Voronoi Boundary as Singular Locus [CONJECTURAL]**
The Voronoi boundary (bisector hyperplanes between codebook entries) creates a disjunction fiber where multiple assignments are equally valid. Key novelty: the boundary is time-varying because E updates during training, creating a dynamic singular locus not seen in prior syntheses.

**C3: K_eff as Discrete Stratum Selector [CONJECTURAL]**
K_eff (effective codebook size after collapse) acts as an endogenous, data-dependent discrete stratum selector. Collapse transition K_eff -> K_eff-1 frees d_z parameters (dead code becomes irrelevant), increasing fiber dimension. Unlike kernel size selectors (#653, #851), K_eff is determined by training dynamics, not preset.

**C4: Generalization Bound with Quantization Bias [CONJECTURAL]**
First SLT generalization bound with a discrete quantization bias term: Gen(n) <= lambda_eff*log(n)/(2n) + U/sqrt(n) + B(K, K_eff). The quantization bias B captures information loss from discretization, estimated as ~(d_z/2)*log(K/K_eff) via rate-distortion theory. Three-term decomposition unique to VQ-VAE.

**C5: Codebook Collapse as Phase Transition [CONJECTURAL]**
Codebook collapse is a discrete phase transition with an RLCT jump at critical commitment weight beta_star. The standout contribution is the STE phantom RLCT: the gap Delta-lambda = lambda_true - lambda_STE represents singularity invisible to Straight-Through Estimator-based training, as STE smoothing effectively ignores the Voronoi boundary discontinuity.

## Key Novel Contributions

1. **Time-varying singular locus** — Voronoi boundary moves during training (codebook-dependent)
2. **Disjunction fiber** — union of assignment conditions, not intersection
3. **Endogenous data-dependent stratum selector** — K_eff from training dynamics
4. **Quantization bias in generalization bound** — first SLT bound with discrete info-loss term
5. **STE phantom RLCT** — gradient estimator-RLCT mismatch analysis

## Open Problems

1. Formal proof that lambda_STE <= lambda_true (STE smoothing direction)
2. EMA codebook update dynamics: does EMA smoothing create additional singularity structure?
3. Hierarchical VQ-VAE-2: multi-level Voronoi nesting singularity
4. Finite-sample vs asymptotic K_eff: non-asymptotic collapse threshold
5. Interaction between Voronoi boundary movement and SGD trajectory stability
6. Rate-distortion bound B(K,K_eff) tightness for specific data distributions
7. Connection to Gumbel-Softmax VQ (#847): relaxation as desingularization?

## Cross-References

#515 VAE (continuous vs discrete collapse), #383 VAE L1, #396 GLA (parameter-space boundary), #851 Conformer (activation-space switching), #434 MoE (learned routing vs geometric), #847 Program Synthesis (Gumbel relaxation), #653 DepthwiseConv (discrete kernel selector), #185 ConstitutionalAI (beta control), #466 RMSNorm (single-scale analogy), #550 DINO/MAE (self-supervised latent)
