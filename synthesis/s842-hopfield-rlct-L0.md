# Synthesis #842: Hopfield Networks x RLCT (L0 - Informal Bridge)
Date: 2026-11-03 | Status: L0 draft

## Topic
Classical/modern Hopfield associative memory (energy E(s) = -1/2 s^T W s, Hebbian W = sum xi xi^T) analyzed via Real Log Canonical Threshold (RLCT, Watanabe) singularity framework.

## Motivation
Zero prior coverage in catalog + memory. Websearch: no external SLT/RLCT-Hopfield bridge found. Hopfield energy landscapes have stored-pattern minima, spurious minima (spin-glass states, mixture states), and a sharp capacity transition alpha_c ~ 0.138n (Amit-Gutfeld-Sompolinsky) - a natural singular-learning-theory object: the loss landscape of a memory network with strongly degenerate critical points.

## Core Claims (C1-C5)
- C1 PROVEN (definability): Hopfield energy + Hebbian storage map are polynomial in (s, xi, W); the associated KL-type loss is definable in R_an,exp. Spurious minima are critical points where grad E vanishes and Hessian degenerates (zero eigenvalues) - the hallmark of singular fibers.
- C2 CONJECTURAL: Stored patterns xi_i define degenerate fibers of the energy map; basin-of-attraction geometry near patterns = singular stratum structure. Spin-glass / mixture spurious states lie on deeper (more singular) strata than true memories.
- C3 CONJECTURAL: Hebbian load parameter alpha = p/n acts as stratum selector: lambda(w) increases with alpha; capacity transition alpha_c is an RLCT phase change (emergence of dominant singular stratum where spurious minima outnumber pattern minima).
- C4 CONJECTURAL: Generalization/retrieval-error bound of AIC-type: retrieval quality penalty scales with lambda(w)/log n rather than parameter count d/2 - explains why over-stored networks fail at alpha_c with graceful degradation below it.
- C5 CONJECTURAL: Modern Hopfield (Ramsauer et al., attention equivalence) softmax-padded energy gives strictly less singular fibers than classical energy; retrieval transition maps to a desingularization-like smoothing, connecting to #354 STE and #841 NTK landscape results.

## Cross-refs
#8 (RLCT basics), #16 (SLT foundations), #167 (energy-based models), #354 (STE), #394 (SWA basin geometry), #480 (phase transition / muP alpha*), #566 (3DGS landscape), #841 (NTK critical points), #185 (constraint manifolds).

## Open Problems
1. Formal RLCT of the Hebbian energy fiber: is lambda concentrated at mixture states?
2. Desingularization of spurious minima via temperature (Boltzmann Hopfield) - does stochastic descent = gradient of desingularized map?
3. Modern Hopfield attention-connection: does transformer attention resolve Hopfield singularities the way softmax resolves STE saturation?
4. Alpha_c as lambda-crossing: prove phase change = swap of dominant strata.
5. Capacity-alpha scaling of retrieval bound (C4) vs classical SNR analysis.
6. Extension: dense associative memory (Krotov-Hopfield, energy order beta>2) - higher-order polynomials, deeper singularity hierarchy.
7. Equivalence of spurious-minima merging (capacity loss) and singular-stratum coarsening.

## Next
L1 formalization (D1-D7 definitions, C1 proof detail).
