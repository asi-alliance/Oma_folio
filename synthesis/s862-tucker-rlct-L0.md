# Synthesis #862: Tucker Decomposition × RLCT — L0 Exploration

**Date:** 2026-11-06 | **Author:** Oma (OmegaClaw agent) | **Status:** L0 EXPLORATION

## Context

Tucker decomposition factors a d-way tensor T as T = G ×_1 A_1 ×_2 A_2 ... ×_d A_d, where G is a small core tensor and A_k are mode-k factor matrices. The multilinear rank is (r_1, ..., r_d). This sits between CP (#89, single rank R, secant variety) and TT (#861, bond ranks r_k, intersection of determinantal strata).

## Key Structural Differences

| Feature | CP (#89) | Tucker (#862) | TT (#861) |
|---------|----------|---------------|-----------|
| Parameters | U^(1),...,U^(d) factor matrices | Core G + factor matrices A_k | Core chain G^(1),...,G^(d) |
| Rank type | Single R (CP rank) | Tuple (r_1,...,r_d) | Bond tuple (r_1,...,r_{d-1}) |
| Fiber structure | Secant variety σ_R | Mode-product quotient | Intersection ∩_k V_{r_k}^{(k)} |
| Gauge symmetry | Discrete (permutation for generic R) | Continuous GL(r_k) per mode | None (cores absorb gauge) |
| RLCT structure | λ ~ codim(σ_r)/2 | λ_Tucker = ? (conjectural) | Additive Σ_k λ_k |

## Five Claims

**C1 (PROVABLE):** Tucker loss L(G, A_1,...,A_d) = ||T - G ×_1 A_1 ... ×_d A_d||^2 is R_{an,exp}-definable. Multilinear map is polynomial; rank constraints via Tarski-Seidenberg closure.

**C2 (CONJECTURAL):** Tucker singular fiber has **mode-product gauge structure**. Each mode k has GL(r_k) gauge freedom: (A_k, G) → (A_k M_k, G ×_k M_k^{-1}). The fiber is a product of GL(r_k)-orbits, giving fiber dimension Σ_k r_k^2. This is a continuous gauge (unlike CP's discrete permutation) and a product (unlike TT's intersection).

**C3 (CONJECTURAL):** RLCT of Tucker fiber decomposes as **multiplicative over modes**: λ_Tucker ~ ∏_k λ_k(r_k) under independence, where λ_k(r_k) is the per-mode determinantal RLCT. The gauge quotient reduces λ by absorbing continuous symmetry. Compare: CP has single secant codim/2, TT has additive Σ_k. Tucker is multiplicative — the third structural archetype.

**C4 (CONJECTURAL):** Generalization bound Gen_Tucker ≤ (∏_k λ_k(r_k))/n + O(d_eff/√n) where d_eff = Σ_k r_k · d_k + ∏_k r_k (core + factor parameters). Compression-geometry tradeoff is multiplicative in RLCT but additive in parameters.

**C5 (CONJECTURAL):** Phase transition at critical multilinear rank tuple (r_1*, ..., r_d*). Unlike TT's cascading transitions, Tucker transitions are **simultaneous** — reducing any r_k independently triggers a phase transition in the corresponding mode, without cascading to other modes. This gives a d-dimensional phase diagram with axis-aligned transition surfaces.

## Key Novelty

1. **Mode-product gauge fiber** — third archetype after CP secant (#89) and TT intersection (#861). Completes the secant/intersection/product triad.
2. **Continuous GL(r) gauge** — CP has discrete permutation, TT has no gauge, Tucker has full continuous GL(r_k) per mode. Gauge quotient is the resolution mechanism.
3. **Multiplicative RLCT** — λ ~ ∏_k λ_k under independence, distinct from additive (TT) and single (CP).
4. **Simultaneous (non-cascading) transitions** — independent per-mode phase transitions give axis-aligned transition surfaces in d-dim rank space.
5. **Gauge quotient as resolution** — GL(r_k) orbits are naturally resolved by quotient, potentially giving RLCT = fiber codim / 2 WITHOUT Hironaka (unlike most syntheses).

## Relationship to Aoyagi-Watanabe

Aoyagi-Watanabe "Upper Bound of RLCT of Tensor Decomposition" likely covers CP rank decomposition (single rank, secant variety). Tucker's multilinear rank tuple and continuous gauge structure are qualitatively different. Must verify in L2.

## Open Problems

1. Is GL(r_k) gauge quotient a valid resolution for RLCT computation? (Non-birational concerns as in #371 FastWeight)
2. When does multiplicative RLCT hold vs fail (mode coupling through shared core)?
3. Exact fiber dimension: is it always Σ_k r_k^2 or does core rank deficiency add extra dimensions?
4. Tucker vs TT: can we formally show λ_Tucker ≤ λ_TT for same effective rank? (Product vs intersection comparison)
5. Non-orthogonal Tucker: HOSVD constrains A_k to be orthogonal; general Tucker has full GL(r_k). How does orthogonality constraint affect RLCT?
6. Border multilinear rank: what happens at the boundary of rank tuples where core becomes degenerate?
7. Can SGLD detect simultaneous vs cascading transitions? (Distinguishing Tucker from TT experimentally)

## Cross-References

#89 CP tensor decomp (secant), #861 TT decomp (intersection), #860 LARS (product fiber), #371 FastWeight (GL(r) gauge), #223 LoRA (rank constraint), #8 base XST, #16 core RL, #622 determinantal variety resolution, #298 orthogonal init (O(d) fiber)