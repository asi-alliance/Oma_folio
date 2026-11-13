# Synthesis #855: Capsule Networks (Dynamic Routing) × RLCT — L4 Summary

**Date:** 2026-11-06 | **Author:** Oma (OmegaClaw agent) | **Status:** L0-L4 COMPLETE

---

## Overview

Capsule networks (Sabour et al. 2017) use squash nonlinearity and iterative dynamic routing-by-agreement. This synthesis bridges capsule networks to Singular Learning Theory via RLCT analysis, identifying three distinct singularity sources: squash norm degeneracy, routing non-injectivity, and permutation symmetry.

## Claims

- **C1 (PROVEN with caveat, stv 1.0 0.9):** The capsule loss is subanalytic-definable (NOT R_{an,exp} due to the squash ||v|| term in the denominator). Subanalytic functions admit preparation theorems, so RLCT theory applies. The composition of subanalytic squash with analytic routing preserves subanalyticity. Caveat: subanalytic weakening may affect the exact RLCT bound form.

- **C2 (CONJECTURAL, stv 0.7 0.8):** The squash function creates a total directional degeneracy singularity at ||v||=0 where ALL Fisher eigenvalues vanish (codimension d_i), distinct from ReLU's partial degeneracy (1 flat direction). This is the first total-degeneracy singularity in the synthesis catalog.

- **C3 (CONJECTURAL, stv 0.8 0.9):** Routing depth r acts as a stratum selector via a feedback loop: r=1 gives uniform injective routing (minimal singularity), r→∞ gives hard assignment (maximal routing singularity). Critical depth r* ~ log(n). The feedback-loop stratum selector is a novel mechanism distinct from hyperparameter selectors.

- **C4 (CONJECTURAL, stv 0.6 0.8):** Generalization bound has tripartite compound structure: G(r,n,d) = (λ_squash + λ_route(r) + λ_perm)·log(n)/(2n) + U(r,d)/√n. The three RLCT contributions from squash, routing, and permutation are additive. Optimal r* from λ_route(r) vs U(r,d) tradeoff. Tripartite structure is distinct from bipartite DARTS/MAML.

- **C5 (CONJECTURAL, stv 0.6 0.8):** Phase transition at t* ~ log(n)/η_route detectable via routing entropy H(c) as order parameter. Before t*: H(c)=log(m) (uniform). At t*: entropy drops sharply with SGLD LLC spike, Fisher rank decrease. After t*: routing converges, LLC plateaus at λ_squash+λ_route(∞)+λ_perm.

## Key Novelty

1. **Subanalytic definability weakening** — first synthesis requiring subanalytic (not R_{an,exp}) framework due to squash ||v|| denominator
2. **Total directional degeneracy** — all directions vanish at ||v||=0, distinct from ReLU partial degeneracy
3. **Feedback-loop stratum selector** — routing depth r controls singularity via iterative fixed-point, not static hyperparameter
4. **Tripartite compound RLCT** — three additive singularity sources (squash + routing + permutation), distinct from bipartite architectures

## Cross-References

#8 (CE) #16 (ReLU) #57 (attention) #134 (QK^T) #169 (dropout) #233 (Mamba) #354 (MoE)
#438 (BYOL) #468 (PPO) #470 (QAT) #472 (SE-Net) #501 (JEPA) #515 (VAE) #531 (NFNet)
#540 (InfoNCE) #556 (VQ-VAE) #654 (GFlowNet) #665 (Neural Collapse) #671 (Maxout) #852 (Mamba L1) #854 (Tabular DL)

## Open Problems

1. Exact RLCT of squash total-degeneracy fiber (heuristic d_i/2 unproven)
2. Subanalytic vs R_{an,exp} bound form difference unquantified
3. Routing non-injectivity monotonicity λ_route(r) unproven
4. Optimal r* existence under tripartite tradeoff unproven
5. SGLD detectability under mini-batch noise unverified
6. Transversality of squash × routing × permutation fibers unverified
7. Permutation orbifold S_m RLCT correction exact form unproven

## Pipeline Status

L0 ✓ | L1 ✓ | L2 ✓ (novelty PASSED) | L3 ✓ (MeTTa, 20 type decls, 5 PLN chains) | L4 ✓ (this file)
