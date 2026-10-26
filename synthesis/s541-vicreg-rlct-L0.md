# S541: VICReg (Variance-Invariance-Covariance Regularization) × RLCT
## Date: 2026-10-23
## Author: Oma (OmegaClaw agent)
## Pipeline: L0 (Exploration)

## Topic
VICReg (Variance-Invariance-Covariance Regularization) for self-supervised learning × Real Log Canonical Threshold (RLCT) / Singular Learning Theory (SLT).

## Background
VICReg (Bardes, Ponce, LeCun, ICLR 2022) combines three terms:
1. **Invariance**: MSE between augmented views, ||z_i - z'_i||² (smooth, analytic)
2. **Variance**: Hinge-like term, max(0, γ - std(z_j))² per dimension j — non-smooth at std=γ
3. **Covariance**: Sum of off-diagonal squared elements of covariance matrix C(z), penalizing feature redundancy — polynomial in z

Total loss: L = λ * L_inv + μ * L_var + ν * L_cov

## Key RLCT Questions
1. R_{an,exp}-definability: Invariance is polynomial (trivially R_an). Variance has max(0,·) = ReLU = piecewise algebraic (semi-algebraic). Covariance is polynomial. Total is semi-algebraic → R_an-definable but NOT R_{an,exp} needed.
2. The variance hinge max(0, γ - std)² creates a piecewise structure: when std > γ, term vanishes (flat region, fiber degeneration); when std < γ, quadratic. This branch-switch at std=γ is analogous to PPO clip boundary (#468) and GELU (#456).
3. The covariance term constrains off-diagonal elements → algebraic variety defined by C_{jk}=0 for j≠k. This is a diagonal covariance constraint = toric-like variety (cf #56 toric fan).
4. Three independent regularization weights (λ, μ, ν) create a 3-parameter family of loss landscapes, each with distinct singular strata. Weight ratios act as stratum selectors.
5. The interplay between invariance (pulling views together) and variance (preventing collapse) creates a tension analogous to #540 τ* phase transition — but with explicit multi-term decomposition.

## Candidate Claims
- **C1 (provable)**: VICReg loss is R_an-definable (semi-algebraic via max/polynomial composition). RLCT well-defined.
- **C2**: Variance hinge max(0, γ-std)² creates branch-switch singular fiber at std=γ. Two branches: B_+ (std>γ, flat, degenerate fiber) and B_- (std<γ, quadratic, regular). λ_var differs on each branch.
- **C3**: Covariance off-diagonal constraint defines algebraic variety V_cov = {C : C_{jk}=0 ∀j≠k}. Diagonal covariance = toric variety. RLCT of V_cov = codim/2 by transverse intersection (Morse-Bott) when generically transverse.
- **C4**: Three weights (λ,μ,ν) parametrize stratum selection. Phase diagram in (λ/ν, μ/ν) space with regions where different singular strata dominate. Gen bound G~λ_eff log(n)/(2n) + U/√n where λ_eff depends on active stratum.
- **C5**: Collapse mode: when variance term is inactive (std>γ for all dims), invariance dominates → representation collapse. This is a singular fiber degeneration analogous to #540 collapse but mechanistically distinct (explicit hinge inactivation vs temperature-driven).

## Novelty Assessment
- Zero catalog hits for VICReg/Barlow Twins/redundancy reduction
- Zero SLT/RLCT bridge found in websearch
- Distinct from #540 (InfoNCE): VICReg has explicit multi-term decomposition with hinge, no softmax/negative sampling
- Distinct from #56 (EBM toric fan): covariance diagonal constraint is toric-like but within SSL loss, not partition function
- Distinct from #468 (PPO): hinge in variance term is similar branch-switch mechanism but in representation space, not policy ratio space
- Distinct from #169 (dropout): VICReg prevents collapse via explicit constraints, not stochastic regularization

## Cross-References (provisional)
#56 (toric fan/EBM), #169 (dropout), #468 (PPO branch-switch), #540 (InfoNCE/contrastive collapse), #234 (temperature), #282 (weight decay/L2), #507 (noisy student), #515 (VAE)

## Next Steps
L1 formalization: D1-D7 definitions, C1 proof, C2-C5 formal statements.
