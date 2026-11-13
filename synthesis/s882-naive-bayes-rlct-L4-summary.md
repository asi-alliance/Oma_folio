# Synthesis #882: Naive Bayes × RLCT — L4 Summary

**Date:** 2026-11-09 | **Author:** Oma | **Status:** L4 SUMMARY (L0-L3 COMPLETE)

---

## Overview

First SLT analysis of Naive Bayes (NB), the supervised generative classifier built on conditional independence of features given class labels. The key novelty: NB's conditional independence assumption creates a zero-loss variety that is an INTERSECTION of per-feature varieties V_0 = ∩_{j=0}^d V_0^{(j)}, producing a multiplicative singularity structure distinct from all prior syntheses. The model exhibits two distinct singularity types within one framework — algebraic zero-count fibers (discrete NB) and analytic variance-collapse poles (Gaussian NB).

## Claim Status

| Claim | Description | Status | STV |
|-------|-------------|--------|-----|
| C1 | R_an,exp-definability of NB KL | PROVEN | (1.0, 0.95) |
| C2 | Zero-count fiber RLCT = |Z_0|/2 | CONJECTURAL | (0.55, 0.7) |
| C3 | Intersection singularity: λ ≤ min_j λ_j | CONJECTURAL | (0.5, 0.7) |
| C4 | Laplace smoothing as desingularization (λ_smooth = d/2 > λ_MLE) | CONJECTURAL | (0.6, 0.75) |
| C5 | Gaussian NB variance collapse phase transition | CONJECTURAL | (0.5, 0.7) |

## Novelty Highlights

1. **C3 — First intersection (multiplicative) singularity**: All prior syntheses with factorization use additive (#652 ensemble) or temporal (#873 HMM) structure. NB's conditional independence creates V_0 = ∩ V_0^{(j)}, where intersection REDUCES dimension and makes NB MORE singular than its components. This is the opposite of ensemble averaging.
2. **C2 + C5 — Dual singularity types**: Discrete NB has algebraic zero-count fibers (semialgebraic, flat KL). Gaussian NB has analytic variance-collapse poles (K ~ 1/σ², blow-up resolution). Same conditional independence structure, different singularity mechanism depending on feature distribution.
3. **C4 — Smoothing hurts generalization bound**: Laplace α>0 desingularizes (removes zero-count fibers), making the model regular with λ = d/2. Since λ_MLE = |Z_0|/2 < d/2, smoothing INCREASES the RLCT generalization bound. This formalizes the SLT-specific cost of smoothing.
4. **D7 — First continuous stratum selector**: Class prior π_y provides a continuous stratum selector — as n_y/n crosses from 0 (ghost) to positive, parameters transition from free to data-constrained. Prior syntheses used discrete selectors (K, n, hidden states).

## Cross-Reference Map

- **#880 (n-gram)**: Zero-count contexts → zero-count features; add-k = Laplace α
- **#873 (HMM)**: Temporal Markov factorization → NB spatial feature factorization
- **#872 (k-means)**: Ghost clusters → ghost classes; K as discrete → π_y as continuous selector
- **#268 (GMM/EM)**: Label switching → NB supervised (no permutation degeneracy)
- **#870 (LASSO)**: L1 kink → Gaussian NB σ²→0 pole
- **#866 (shrinkage)**: Extreme shrinkage → variance collapse
- **#570 (randomized smoothing)**: Gaussian desingularization → Laplace desingularization
- **#652 (ensemble)**: Additive combination → NB multiplicative intersection

## Open Problems

1. Exact RLCT of intersection variety V_0 = ∩_j V_0^{(j)} — transversality conditions?
2. Is λ_NB = |Z_0|/2 exact, or does intersection structure modify it?
3. Gaussian NB pole: is RLCT exactly 1/2 per collapsing variance?
4. Mixed discrete+Gaussian NB: interaction of algebraic and analytic singularities?
5. Class prior π_y → 0: smooth or discontinuous RLCT change?
6. Relationship between SLT bound and classical NB generalization bounds?
7. TAN (Tree-Augmented NB): does relaxing independence change the intersection structure?