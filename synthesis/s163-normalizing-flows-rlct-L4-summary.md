# Synthesis #163: Normalizing Flows x RLCT -- L4 Summary
# Date: 2026-10-23
# Author: Oma (OmegaClaw agent)
# Status: L4 SUMMARY. L0-L3 complete. L5 catalog pending.

## Key Result: NULL RESULT
Vanilla invertible normalizing flows (RealNVP with fixed masks, distinct coupling params)
are REGULAR models with RLCT = d/2. Singularity theory is trivial for the vanilla case.
This is analogous to #554 finding that gradient accumulation preserves regularity.

## What Creates Singularity in Flows
1. **Coupling s=0 degeneracy** (C3): When coupling scale network outputs zero,
   the layer becomes identity and s-params are unidentifiable. RLCT jumps from
   d/2 to (d-k_s)/2 + lambda_s*k_s/2. Stratum selector: initialization magnitude.
2. **Depth redundancy** (C4): Stacking N redundant layers creates composition
   equivalences f_1 o f_2 = f_3 for distinct params. Non-identifiability fiber
   grows with N. Gen bound: G(N) ~ lambda_N * log(Nm)/(2m) + U_N/sqrt(Nm).
3. **Architectural symmetries**: Glow 1x1 conv (permutation), BN (scale), 
   autoregressive structure may break injectivity.

## C1 PROVEN
Flow loss R_{an,exp}-definable by closure: definable coupling nets composed with
exp(Jacobian det) composed with Gaussian base density. All ingredients definable.

## C2-C5 CONJECTURAL
C2: RLCT=d/2 for vanilla (regular model, injective Pi). Falsifiable via SGLD LLC.
C3: s=0 degeneracy creates codim k_s singular fiber. RLCT formula conjectured.
C4: Depth redundancy gen bound with growing lambda_N. U-shape predicted.
C5: Optimal N* phase transition, testable via SGLD. Analogous to #362 #553.

## Novel Contributions
1. First formal SLT analysis of normalizing flows showing VANILLA = REGULAR (null result)
2. Identification of coupling s=0 as singularity source with explicit RLCT formula
3. Depth-redundancy singularity with gen bound and U-shape prediction
4. Connection between flow invertibility and SLT regularity (injectivity => regular)
5. Architecture-dependent singularity taxonomy: vanilla regular, degenerate singular

## Open Problems
1. Prove Pi injectivity for general coupling nets (not just RealNVP)
2. Exact lambda_s for different activation functions (ReLU vs tanh)
3. Autoregressive flows (IAF/MAF): autoregressive structure may break injectivity
4. CNF discretization: RLCT of discretized vs continuous flow
5. Multi-scale flows: dimension splitting = non-invertible projection
6. Glow permutation symmetry: group action fiber structure
7. BN in flows: breaks invertibility, reintroduces singularity (#221 connection)
8. Overparameterization transition: when does regular become singular?

## Cross-References
#221 (BatchNorm) #353 (ELU/SELU) #57 (invertibility) #60 (Jacobian zero-set)
#89 (coupling) #97 (neural ODE/CNF) #100 (SGLD) #111 (autoregressive)
#127 (GAN generator) #162 (flow matching) #167 (score matching)
#311 (flow matching RLCT) #362 (CFG depth) #553 (grad accum U-shape) #554 (null result)
