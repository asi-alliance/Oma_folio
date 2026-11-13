# Synthesis #902: SVM (Support Vector Machine) x RLCT - L4 Executive Summary

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L0-L1-L2-L3 complete; L4 summary

## Plain-Language Summary

Support Vector Machines minimize a non-smooth objective: half the squared weight norm plus a penalty for margin violations, scaled by a constant C. The hinge loss (max of zero and a linear function) creates a kink wherever a data point sits exactly on the margin boundary. This kink makes SVMs fundamentally different from every prior catalog entry.

### C1 (PROVEN): Definability
The hinge loss is subanalytic (a semi-algebraic max), and the L2 regularizer is polynomial. Their sum is R_{an}-definable, hence R_{an,exp}-definable. Kernel extensions (RBF, polynomial) preserve definability. This is standard but had not been formally stated for SVM in the SLT literature.

### C2 (CONJECTURAL): Data-Dependent Singular Fiber
The singular fiber dimension is (d+1) minus the number of support vectors. Which data points are support vectors depends on the data itself, not just the parameters. This is the **first data-dependent singular fiber** in the catalog. All prior fibers (#896, #870, #889, #433) depend on model parameters or architecture, not on which data points activate constraints.

### C3 (CONJECTURAL): C as Constraint-Activation Stratum Selector
As C varies, data points cross the margin boundary, changing the SV set and fiber dimension by discrete jumps. Unlike #889 (smooth Morse bifurcations) or #433 (continuous fiber deformation), SVM has discontinuous, piecewise-constant fiber dimension transitions.

### C4 (CONJECTURAL): Generalization Bound with Margin-Width Complexity
G <= lambda_eff*log(n)/(2n) + 1/(||w*||*sqrt(n)) + C*E[xi]/n. The margin-width term 1/||w*|| connects to VC dimension. The RLCT subsumes VC: when singular, lambda_eff < (d+1)/2 improves on the VC bound.

### C5 (CONJECTURAL): Phase Transition at C*
Piecewise-constant LLC with step jumps at critical C*_k values where the SV set changes. This non-smooth LLC profile is qualitatively distinct from all catalog entries and requires subgradient SGLD for empirical verification.

## Star Contribution

**The data-dependent singular fiber.** Every prior catalog entry studies singularities determined by model parameters or architecture. In SVM, the singular fiber structure depends on which data points are support vectors. This creates a feedback loop: loss landscape geometry depends on data, data depends on the learned model, the model determines the SV set. Additionally, the **piecewise-linear non-smooth singularity** at data-dependent margin boundaries is the first of its kind in the catalog.

## Honest Assessment

- C1 is straightforward (subanalytic closure) but was undocumented for SVM specifically.
- C2-C5 are genuinely novel but CONJECTURAL. The data-dependent fiber requires extending RLCT theory to fibers whose dimension depends on data, not just parameters. No prior SLT work validates this.
- The non-smooth nature (hinge loss) complicates SGLD-based empirical verification. Subgradient methods exist but their LLC-tracking guarantees are unproven for non-smooth losses.
- The VC dimension connection (lambda_SVM <= d_VC/2) is an attractive conjecture but needs formal proof.

## Open Problems

1. Does resolution of singularities apply to piecewise-linear (non-smooth) subanalytic varieties?
2. Is lambda = |SV|/2 for hard-margin SVM (constraint dimension counting)?
3. Does the kernel trick (RKHS feature map) change the RLCT?
4. Multi-class SVM (Crammer-Singer): how do class-wise SV sets interact?
5. Is lambda_SVM <= d_VC/2 always (RLCT tightens VC)?
6. Does subgradient SGLD track RLCT when loss is non-differentiable at stratum boundaries?
7. Nu-SVM: does nu produce different stratum structure than C?

## Cross-References

#896 Logistic Regression (transcendental at infinity vs algebraic finite), #870 L1/Lasso (coordinate-zero kink vs data-dependent margin kink), #889 Mean Shift (Morse bifurcation vs KKT activation), #433 Weight Decay (continuous vs discontinuous), #831 Nuclear Norm (spectral vs margin), #872 K-Means (unsupervised vs supervised), #567 DPO (preference boundary vs classification margin), #354 RLCT framework, #8 SLT foundations, #16 Watanabe RLCT.
