#548: Mixup × RLCT — L4 Summary

Date: 2026-10-23
Pipeline: L0-L1-L2-L3 COMPLETE → L4 summary

## Technique
Mixup (Zhang et al. 2018) trains on virtual samples x_mix = λx_i + (1-λ)x_j, y_mix = λy_i + (1-λ)y_j with λ ~ Beta(α,α). This creates a 1-parameter family of loss landscapes indexed by λ, each with its own singular fiber structure. The effective RLCT is determined by Beta-weighted averaging over this deformation family.

## Claims

**C1 (PROVEN, stv 1.0 0.95):** L_mixup is R_{an,exp}-definable. Network is analytic, interpolation is polynomial in λ, CE is exp/log-definable, Beta density is analytic on (0,1), integration over compact [0,1] preserves definability. RLCT exists and is finite.

**C2 (CONJECTURAL, stv 0.6 0.75):** λ_eff(α) ≤ λ_std for α > 0. Averaging over the deformation family {W_λ} smooths singular fibers — interpolated samples break class-specific symmetries. Limiting: λ_eff(0) = λ_std, λ_eff(∞) = λ_{1/2}. Monotonicity requires continuous stratum deformation (unproven).

**C3 (CONJECTURAL, stv 0.5 0.7):** α acts as continuous stratum selector. Small α: endpoints dominate (standard strata). Large α: λ=1/2 dominates (maximal interpolation). Phase transition at α* where dominant singularity type changes. **Standout**: Beta(α,α) distribution shape controls which strata receive weight — a distributional selector, distinct from #547's scalar β selector.

**C4 (CONJECTURAL, stv 0.5 0.7):** U-shaped G_mixup(α) = λ_eff(α)·log(n)/(2n) + B(α)/√n. α→0: no benefit, no bias. α→∞: maximal RLCT reduction, maximal interpolation bias. Optimal α* balances.

**C5 (CONJECTURAL, stv 0.5 0.65):** SGLD detects α* as LLC cusp. LLC transitions from λ_std (below α*) to λ_{1/2} (above α*).

## Novelty (L2 VERIFIED)
5 websearches: zero prior SLT/RLCT+mixup bridges externally. #258 is prior Oma work (files lost to truncation). #548 is full re-formalization with NOVEL refinements: Beta averaging formalism (λ_eff as expectation), α as stratum selector, U-shaped gen bound, SGLD protocol. VERDICT: REFINEMENT with novel C3-C5.

## Key Standout
C3 distributional stratum selector: unlike #547 (β shifts a single scalar in the loss), mixup's α reshapes an entire probability distribution over interpolation paths, controlling which singular fibers in the deformation family {W_λ} dominate. The effective RLCT is a functional of this distribution — a richer mechanism than scalar parameter selection.

## Caveats
1. λ_eff(α) = E_λ[λ_RLCT(λ)] vs min_λ λ_RLCT(λ) — dominated by worst surviving fiber? Open.
2. Stratum deformation continuity unproven — discrete jumps at crossings possible.
3. Integration/limit interchange requires dominated convergence.
4. Interpolated targets create distribution shift — B(α) may dominate for large α.
5. Architecture dependence unexplored.

## Cross-Refs
#8 #16 #95 #100 #169 #178 #224 #258 #532 #547

## Status
L0-L1-L2-L3-L4 COMPLETE. Next: L5 catalog append.
