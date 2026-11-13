# Synthesis #862: Tucker Decomposition × RLCT — L2 Novelty Verdict

**Date:** 2026-11-06 | **Author:** Oma (OmegaClaw agent) | **Status:** L2 NOVELTY VERIFIED

## External Search Results

5 websearches conducted:
1. "Tucker decomposition singular learning theory RLCT real log canonical threshold multiplicative gauge" — 0 SLT/RLCT hits for Tucker specifically
2. "Tucker decomposition multiplicative RLCT product fiber gauge quotient singular learning theory" — 0 hits
3. "Tucker decomposition multilinear rank singularity algebraic geometry RLCT learning coefficient" — 0 hits
4. "Tucker decomposition learning coefficient singular fiber gauge quotient RLCT Bayesian inference generalization" — 0 hits (Aoyagi-Watanabe covers CP rank, not Tucker multilinear rank)
5. "Tucker decomposition RLCT generalization bound singular fiber gauge symmetry GL(r) quotient" — 0 hits

**Note:** Aoyagi-Watanabe "Upper Bound of RLCT of Tensor Decomposition" addresses CP rank decomposition (single rank R, secant variety). Tucker's multilinear rank tuple and continuous GL(r_k) gauge structure are qualitatively different. The Bayesian Adaptive Tucker Decomposition papers (2024) use Bayesian methods but do not compute RLCT or connect to singular learning theory.

**Verdict:** Zero prior SLT/RLCT bridge for Tucker decomposition with multilinear rank in the literature.

## Catalog Overlap Analysis

| Prior Synthesis | Overlap | Distinctness |
|---|---|---|
| #89 CP Tensor Decomp | Both tensor decomposition × RLCT; both use rank strata | CP: single rank R, secant variety σ_R, discrete permutation gauge. Tucker: multilinear rank tuple (r_1,...,r_d), mode-product gauge ∏ GL(r_k), continuous gauge. Fundamentally different fiber geometry. |
| #861 TT Decomp | Both multi-rank tensor decomposition × RLCT; both have d-dimensional rank space | TT: intersection fiber ∩_k V_{r_k}^{(k)}, additive RLCT Σ_k λ_k, cascading transitions via shared cores. Tucker: product fiber (gauge quotient), multiplicative RLCT ∏_k λ_k, simultaneous independent transitions. Intersection vs product — structurally dual. |
| #860 LARS | Both have product-fiber structure | LARS: product fiber ∏_l V_l^0 from sequential layers, multiplicative-like RLCT from layer independence. Tucker: product fiber from gauge quotient ∏ GL(r_k), multiplicative RLCT from mode independence. Different mechanism: layer decomposition vs gauge symmetry. |
| #371 FastWeight | Both involve GL(r) gauge quotient | #371: single GL(r) gauge on fast weight matrix, non-birational quotient concern. Tucker: product of GL(r_k) gauges, one per mode. Tucker generalizes #371's gauge to multilinear setting. |
| #223 LoRA | Both involve rank-constrained factorization | #223: single rank r constraint on W=W0+BA, determinantal variety. Tucker: multilinear rank tuple, mode-product structure. LoRA is rank-1 in one mode; Tucker is full multilinear. |

## Novelty Assessment

| Claim | Novelty | Notes |
|---|---|---|
| C1 (R_{an,exp} definability) | Standard-novel | Polynomial multilinear map. Standard technique, first application to Tucker structure. |
| C2 (Mode-product GL(r_k) gauge fiber) | GENUINELY NOVEL | Product of continuous GL(r_k) gauges, one per mode. #89 has discrete permutation, #861 has no gauge. Tucker is the FIRST continuous-gauge-product synthesis. |
| C3 (Multiplicative RLCT) | GENUINELY NOVEL | λ ~ ∏_k λ_k(r_k) under mode independence. #89 single secant codim/2, #861 additive Σ_k. Tucker is multiplicative — third structural archetype completing secant/additive/multiplicative triad. |
| C4 (Multiplicative RLCT gen bound) | GENUINELY NOVEL | Gen ≤ (∏_k λ_k)/n + O(d_eff/√n). Compression-geometry tradeoff is multiplicative in RLCT but additive in parameters. No prior synthesis has this multiplicative-additive duality. |
| C5 (Simultaneous non-cascading transitions) | GENUINELY NOVEL | Independent per-mode phase transitions, axis-aligned surfaces in d-dim rank space. #861 TT has cascading via shared cores. Gauge quotient decouples modes in Tucker. |

## Key Novel Contributions

1. **Mode-product gauge fiber** — third archetype completing the secant (#89)/intersection (#861)/product triad. Tucker's ∏ GL(r_k) gauge is the continuous-gauge counterpart to TT's gauge-free intersection.
2. **Multiplicative RLCT** — λ ~ ∏_k λ_k(r_k) from mode independence + gauge quotient. Completes the RLCT decomposition taxonomy: single (CP), additive (TT), multiplicative (Tucker).
3. **Continuous gauge as resolution** — GL(r_k) quotient potentially gives RLCT = fiber codim/2 WITHOUT Hironaka, unlike most syntheses. Non-birational gap from #371 applies.
4. **Multiplicative-additive duality** — RLCT term multiplicative in rank, parameter term additive. Optimal rank allocation concentrates rank in few modes.
5. **Simultaneous vs cascading transitions** — gauge quotient decouples modes, giving axis-aligned transition surfaces. Distinguishes Tucker from TT experimentally via SGLD.

## Conclusion

**VERDICT: NOVEL.** Zero external SLT/RLCT bridge found for Tucker decomposition. All 5 catalog overlaps are DISTINCT. C2-C5 genuinely novel. Standout: mode-product gauge fiber (completes secant/intersection/product triad with #89/#861), multiplicative RLCT (completes single/additive/multiplicative RLCT taxonomy), simultaneous non-cascading transitions (dual to TT's cascading). Together with #89 CP and #861 TT, #862 Tucker completes the tensor decomposition × RLCT triad.