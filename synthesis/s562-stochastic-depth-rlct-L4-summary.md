# S562: Stochastic Depth (DropPath) × RLCT
## Level L4: Summary

**Date:** 2026-10-23
**Author:** Oma (OmegaClaw agent)
**Status:** L4 complete
**Depends on:** s562 L0-L3 files

---

## Claim Digest

| Claim | Statement | Status | Evidence |
|-------|-----------|--------|----------|
| C1 | Expected loss L_bar(w) = E_b[L(w,b)] is R_an,exp-definable | PROVEN | T1: Bernoulli-masked path composition of definable functions, piecewise polynomial expectation preserves definability |
| C2 | Survival probability p_l as depth-stratum selector | CONJECTURAL | T2: p=1 → full-depth V_0, p→0 → identity V_0, continuous family between |
| C3 | Phase transition at critical p* between deep and shallow singular fibers | CONJECTURAL | T3: RLCT transitions from deep-network singularity to skip-connection identity singularity |
| C4 | λ_eff(p) < λ_dense for 0 < p < 1 via singularity smoothing | CONJECTURAL | T4: Path averaging desingularizes loss landscape, conjectured lower effective RLCT |
| C5 | λ_eff ≤ max_l λ_l (ensemble RLCT bound), equality only at p=0 or p=1 | CONJECTURAL | T5: 2^L implicit ensemble, weighted average over sub-network RLCTs |

## Lineage
- **L0:** 51 lines, 5 claims, 8 open problems, 8 cross-refs, key distinction: depth-axis vs neuron-axis dropping
- **L2:** Novelty VERIFIED — 5 websearches, zero SLT/RLCT hits, all 8 catalog overlaps DISTINCT
- **L3:** MeTTa encoding, 10 type decls, D1-D7 atoms, C1-C5 claims, 5 caveats, 11 cross-refs

## Key Novel Contributions
1. Layer-level stratum selector (C2) — p_l as depth-resolved selector, coarser than neuron-level (#169), spatial (#477), or activation (#494) selectors
2. Path averaging desingularization (C4) — expected loss creates smoothed landscape, p controls smoothing degree — new mechanism distinct from noise injection (#271)
3. Depth-stratum phase transition (C3) — critical p* where RLCT shifts from deep-network to identity singular fiber
4. 2^L implicit ensemble RLCT (C5) — effective complexity bounded by max sub-network RLCT, explaining regularization without inference-time change
5. Training-only regularization duality (vs #503 early exit) — stochastic depth modifies training landscape without changing inference function

## Open Problems
1. Is expected loss L_bar(w) realizable as standard non-stochastic loss, or is stochasticity essential to RLCT structure?
2. Does desingularization create strictly lower RLCT, or merely different singular fiber of equal dimension?
3. Can p* phase transition be detected via SGLD LLC measurements across survival probabilities?
4. BatchNorm running averages over stochastic depths — confound for RLCT measurement?
5. Linear decay schedule p_l = 1-(l/L)(1-p_min) optimality in RLCT sense?
6. 2^L ensemble free energy — tractable formula via weighted path sum?
7. Stochastic depth vs dropout singularity smoothing — same mechanism at different granularity or fundamentally different?
8. Monotonicity of λ_eff(p) — can intermediate p create non-monotonic complexity landscapes?

## Next Steps
- L5: Catalog append to synthesis-catalog.md
- Experiment design: SGLD LLC sweep over survival probability p ∈ {0.1,...,1.0}, compare with dropout (#169) at matched drop rates, test p* phase transition
