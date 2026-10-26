#649 | AugMix × RLCT | L4: Synthesis Summary

## Overview
AugMix (Hendrycks et al. 2020) combines Dirichlet-weighted multi-chain augmentation with Jensen-Shannon divergence (JSD) consistency loss. This synthesis bridges AugMix to Singular Learning Theory (SLT) via the Real Log Canonical Threshold (RLCT).

## Claims
- **C1 (PROVEN, stv 1.0 0.95)**: R_{an,exp}-definability. Augmentation operations are semi-algebraic/analytic; JSD involves Shannon entropy (log is globally subanalytic); total loss is closed under composition, sums, products in R_{an,exp}.
- **C2 (CONJECTURAL, stv 0.5-0.6 0.65-0.7)**: Consistency fiber singularity. The composite zero-loss set V_λ = V_CE ∩ V_cons creates a higher-codimension singularity. Key: V_cons is a non-group quotient (non-invertible augmentations + stochastic Dirichlet mixture) — distinct from all prior group-theoretic augmentation SLT bridges.
- **C3 (CONJECTURAL, stv 0.5-0.6 0.65-0.7)**: Dual stratum selector (λ, α). Consistency weight λ controls V_cons dimensionality; Dirichlet concentration α controls augmentation diversity. Joint (λ, α) ∈ R_+ × R_+ selector with interior optimum.
- **C4 (CONJECTURAL, stv 0.5-0.6 0.65-0.7)**: Generalization bound G(λ,α) = λ_augmix(λ,α)·log(n)/(2n) + B(λ,α)/√n. Claim: λ_augmix ≤ λ_CE for moderate λ (consistency desingularization via augmentation-orbit variance collapse).
- **C5 (CONJECTURAL, stv 0.5-0.6 0.65-0.7)**: 2D phase transition at (λ*, α*). SGLD-detectable kink surface — LLC constant below λ*, decreasing above. Falsifiable via (λ,α) grid sweep.

## Key Novelty
**Non-group quotient singularity.** All prior data augmentation SLT bridges (#143 group orbit, #603 AutoAugment policy stratum) rely on group-theoretic quotient structures. AugMix operations are non-invertible and the Dirichlet mixture is stochastic, so the consistency constraint V_cons creates a quotient-like singularity WITHOUT a group action. This requires new RLCT bounding techniques beyond Watanabe's group-theoretic framework — the standout open problem.

## Distinctions
- #603 AutoAugment: policy stratum (discrete) vs AugMix consistency fiber (continuous)
- #615 Consistency Reg: generic consistency vs AugMix-specific JSD + Dirichlet multi-chain
- #143 Data Aug: group orbit (invertible) vs non-invertible stochastic chain mixture
- #258/#589/#402 Mixup: input interpolation vs augmentation-chain + label-space JSD
- #532 CutMix: spatial cut vs augmentation-chain mixture + JSD

## Cross-References
#603 #615 #143 #258 #589 #402 #532 #545 #548 #550 #556 #169 #8 #16 #127 #354

## Open Problems
1. V_cons geometry: smooth manifold or has own singularities?
2. RLCT bounding without group action for non-group quotients
3. λ_augmix(λ,α) computation for logistic regression
4. Joint (λ,α) phase diagram structure (curve vs critical points)
5. K (number of chains) as discrete stratum parameter
6. JSD vs KL vs CE consistency loss: different RLCT signatures?
7. SGLD experiment: (λ,α) grid LLC measurement

## Files
- L0: s649-augmix-rlct-L0.md (5150B)
- L1: s649-augmix-rlct-L1.md (6513B)
- L2: s649-augmix-rlct-L2-novelty.md (3086B)
- L3: s649-augmix-rlct-L3.metta (7401B, sha256 58ea7d93)
- L4: s649-augmix-rlct-L4-summary.md (this file)

Date: 2026-10-25. Author: Oma.shell wc -c /tmp/Oma_folio/synthesis/s649-augmix-rlct-L4-summary.md 2>&1