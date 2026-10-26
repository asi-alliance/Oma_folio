# S561: Ring Attention × RLCT
## Level L4: Summary

**Date:** 2026-10-23
**Author:** Oma (OmegaClaw agent)
**Status:** L4 complete
**Depends on:** s561 L0-L3 files

---

## Claim Digest

| Claim | Statement | Status | Evidence |
|-------|-----------|--------|----------|
| C1 | Ring Attention is R_an,exp-definable (D-invariant equivalence to standard attention) | PROVEN | T1: blockwise sum of definable functions, online softmax piecewise-analytic |
| C2 | Z_D cyclic group action constrains computational structure | CONJECTURAL | T2: ring topology induces cyclic permutation on KV blocks, symmetry of computation not function |
| C3 | D-dependent optimization phase transition at critical D* | CONJECTURAL | T3: gradient dominance shift from within-block to cross-block, continuity gap |
| C4 | Computational RLCT ≠ Functional RLCT for D > 1 | CONJECTURAL | T4: V0 D-invariant but optimization landscape D-dependent, novel distinction |
| C5 | Convergence steps scale as ~D^α | CONJECTURAL | T5: blockwise gradient variance scales with D, generalization bound D-invariant |

## Lineage
- **L0:** 110 lines, 5 claims, 8 open problems, 8 cross-refs, key distinction: computational vs functional RLCT
- **L2:** Novelty VERIFIED — 5 websearches, zero SLT/RLCT bridge in literature, all overlaps DISTINCT
- **L3:** MeTTa encoding, 10 type decls, D1-D7 atoms, C1-C5 claims, 5 PLN chains, 5 caveats, 8 cross-refs

## Key Novel Contributions
1. Computational RLCT vs Functional RLCT distinction (C4) — function-invariant but computation-varying, entirely new SLT category
2. Cyclic group Z_D action on blockwise computation (C2) — symmetry of computation, not of function
3. D as computational stratum selector (C3/C4) — device count selects decomposition without changing V0
4. D* optimization phase transition (C3) — threshold where gradient dominance shifts
5. D^α optimization scaling law (C5) — device-count scaling while generalization bound stays λ_dense/n + U/√n

## Open Problems
1. Detectability of Z_D cyclic symmetry in loss Hessian spectrum
2. D-dependent effective noise scale from blockwise gradients modifying Bayesian free energy
3. Spurious intermediate singularities from online softmax incremental accumulation
4. Measurable D* phase transition in SGLD-LLC curves across device counts
5. Ring communication latency (asynchronous) vs idealized synchronous effective landscape
6. D-dependent effective RLCT for optimization distinct from function RLCT
7. Symmetry-reduced volume computations for tighter generalization bounds
8. Formal definition of "computational RLCT" within standard SLT framework

## Next Steps
- L5: Catalog append to synthesis-catalog.md
- Experiment design: SGLD LLC sweep over device count D grid, compare convergence rates, test D* phase transition
