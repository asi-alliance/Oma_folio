# Synthesis #822: Manifold Mixup x RLCT - L4 Summary

**Date:** 2026-10-29
**Status:** COMPLETE (L0-L5)
**Topic:** Manifold mixup (Verma et al. 2019) analyzed through Singular Learning Theory / RLCT framework

## C1 (PROVEN): R_an,exp-definability
Manifold mixup loss is R_an,exp-definable via composition closure: ReLU/SwiGLU (subanalytic) + affine interpolation (polynomial) + cross-entropy (polynomial + log). All components definable, composition preserves definability.

## C2 (CONJECTURAL): Layer-Dependent Singular Fiber
V_k(lambda) = zero-loss fiber with hidden interpolation at layer k. Deeper k -> more compressed hidden representations -> lower-dimensional singular fibers -> lower RLCT lambda_k. Monotonicity in k requires controlling encoder geometry — unproven.

## C3 (CONJECTURAL): Dual Stratum Selector
Unique to #822: BOTH discrete k (layer index) AND continuous lambda (interpolation ratio) serve as stratum selectors. k=0 recovers input mixup (#258/#548). k=L gives output-space interpolation. Conjecture: lambda_k monotonically non-increasing in k.

## C4 (CONJECTURAL): Generalization Bound
E[L_test^MM] <= E[L_train^MM] + C * sqrt(lambda_eff^MM(alpha) * log(n) / n)
where lambda_eff^MM = E_{k~p(k)} E_{lambda~Beta(a,a)} [lambda_k(lambda)].
Predicts optimal k* at mid-depth (U-shaped: too shallow = complex fiber, too deep = trivial).

## C5 (CONJECTURAL): Phase Transition at k*
SGLD LLC should show step-like decrease as k increases past k*, reflecting stratum simplification. Detectable via LLC trajectory comparison across layer depths.

## Standout Novelty
1. **Dual stratum selector** (discrete k + continuous lambda) — first synthesis with both
2. **Composition-mediated singularity** — fiber in w-space via f_{>k} . interp . f_{<=k}
3. **Layer-depth RLCT monotonicity** conjecture — deeper interpolation = simpler singularity
4. **Recovery property** — k=0 exactly recovers #258 input mixup

## Cross-References
#258 (input mixup), #548 (mixup RLCT), #169 (dropout), #173 (SAM), #222 (spectral norm), #480 (muP), #590 (adversarial training), #658 (weight standardization)

## Files
s822-manifold-mixup-rlct-L0.md, s822-manifold-mixup-rlct-L1.md, s822-manifold-mixup-rlct-L2.md, s822-manifold-mixup-rlct-L3.metta, s822-manifold-mixup-rlct-L4-summary.md
