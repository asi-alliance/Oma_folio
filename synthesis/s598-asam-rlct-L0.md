# Synthesis #598: Adaptive Sharpness-Aware Minimization (ASAM) × RLCT — L0 Exploration

**Date:** 2026-10-25
**Status:** L0 — Hypothesis & Exploration
**Candidate:** ASAM (Adaptive SAM) × RLCT

## Background

SAM (Sharpness-Aware Minimization) finds flat minima by minimizing the worst-case loss within an L2 ball of radius ρ around current weights. Prior syntheses #173, #289, #559 formalized fixed-ρ SAM × RLCT: ρ as stratum selector, λ_SAM(ρ) U-shaped, ρ* ~ n^{-1/(2λ+1)}.

ASAM extends SAM with **adaptive perturbation radius**: instead of a single fixed ρ, the perturbation budget is adapted per-parameter (or per-layer) based on weight norms, gradients, or learned scaling. This creates an **anisotropic perturbation ball** — different directions in parameter space receive different perturbation magnitudes.

## Key RLCT Bridge

The core novelty over fixed-ρ SAM (#173/#559):

1. **Anisotropic stratum selector**: Fixed ρ selects strata uniformly. ASAM's per-parameter ρ_i creates a **weighted stratum selector** — directions with larger ρ_i probe deeper into singular strata, directions with smaller ρ_i stay local. This is a **direction-dependent stratum filter**.

2. **Adaptive RLCT landscape**: λ_ASAM(ρ(w)) depends on the *function* ρ(w), not just a scalar. The optimal ρ*(w) allocates perturbation budget proportional to local sharpness — i.e., ρ_i* ∝ 1/√(H_ii) where H is the Hessian. This creates a **preconditioned singularity exploration**.

3. **Normalization-invariant perturbation**: ASAM typically normalizes perturbation by weight norm (ρ_i = ρ · ||w_i||), making the perturbation ball scale-equivariant. This changes the stratum geometry: the effective perturbation is ρ · ||w_i|| · d_i/||d_i||, which stretches/shrinks with weight magnitude — **scale-adaptive stratum probing**.

## Candidate Claims

- **C1 (PROVABLE):** The ASAM loss L_ASAM(w) = max_{||δ_i||≤ρ·||w_i||} L(w+δ) is R_{an,exp}-definable. The adaptive constraint ||δ_i|| ≤ ρ·||w_i|| is polynomial (quadratic), and the max over a compact semialgebraic set preserves definability via the definable selection theorem. Same argument as #559 C1 but with parameter-dependent constraint set.

- **C2 (CONJECTURAL):** The normalization-by-weight-norm creates a **scale-equivariant stratum selector**. The effective perturbation radius in each direction scales with ||w_i||, so stratum probing depth is proportional to weight magnitude. This means ASAM probes *deeper* into strata along directions with large weights and *shallower* along directions with small weights. The singular geometry is explored non-uniformly in a norm-adaptive way.

- **C3 (CONJECTURAL):** The anisotropic perturbation creates a **preconditioned RLCT** λ_ASAM(ρ) ≤ λ_SAM(ρ) for the same total perturbation budget ||ρ||. The adaptive allocation concentrates perturbation where sharpness is highest, filtering out more narrow sharp strata per unit budget. Conjecture: λ_ASAM ≤ λ_SAM with equality iff the loss landscape is isotropic (H proportional to identity).

- **C4 (CONJECTURAL):** Generalization bound: G_ASAM ≤ λ_ASAM(ρ*)·log(n)/(2n) + U(ρ*)/√n, where ρ* is the optimal adaptive schedule. The bias term U(ρ*) is smaller than fixed-SAM's because norm-adaptive perturbation matches the natural scale of each parameter group. Conjecture: U_ASAM(ρ*) ≤ U_SAM(ρ*) with the gap growing with parameter group scale heterogeneity.

- **C5 (CONJECTURAL):** Phase transition: ASAM has a smoother ρ* transition than fixed SAM because the norm normalization absorbs scale differences. The critical ρ*~ASAM is more robust across architectures. SGLD-testable: LLC traces under ASAM should show gentler kinks at ρ* compared to fixed SAM.

## Distinctions from Prior Syntheses

- **#173/#559 (fixed-ρ SAM):** ASAM differs by adaptive per-parameter ρ_i = ρ·||w_i||. The stratum selector is anisotropic and scale-equivariant. #559 C3 already noted ρ as scalar stratum selector; ASAM upgrades to vector-valued stratum selector.
- **#420 (Lookahead):** Lookahead explores via slow-fast weight averaging, not perturbation. Different mechanism.
- **#394 (SWA):** SWA averages trajectory points; ASAM perturbs adaptively. Different geometry.
- **#226 (EMA):** EMA is temporal averaging; ASAM is spatial perturbation.
- **#590 (Adversarial Training):** AT perturbs inputs; ASAM perturbs weights. Different space.
- **#433 (Weight Decay):** Weight decay penalizes norm; ASAM normalizes perturbation by norm. Complementary.

## Open Problems

1. Formalize the anisotropic stratum selector: how does ρ(w) = ρ·||w|| interact with the Whitney stratification?
2. Prove or disprove λ_ASAM ≤ λ_SAM for fixed total budget.
3. Characterize the optimal adaptive schedule ρ*(w) in terms of local RLCT geometry.
4. Does norm-normalization create a Riemannian-like metric on parameter space? Connection to natural gradient?
5. Multi-layer ASAM: how do per-layer ρ_i interact with cross-layer singular fibers?
6. Empirical: measure λ_ASAM vs λ_SAM via SGLD on heterogeneous-scale architectures (e.g., transformer with vastly different layer norms).
7. Connection to #473 (Spectral Norm): ASAM's norm-adaptive perturbation is related to spectral normalization of the perturbation ball.

## Cross-References

#8 #16 #73 #100 #127 #173 #226 #289 #394 #420 #433 #473 #482 #531 #543 #559 #590

## Next Steps

L1: Formal definitions (D1-D7), rigorous C1 proof, C2-C5 formalization.
L2: Novelty verification via websearch.
L3: MeTTa encoding.
L4: Summary.
L5: Catalog append.