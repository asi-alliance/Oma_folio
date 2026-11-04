# Synthesis #847: Bipolar Argumentation Frameworks x Graded-Stalk Sheaf - L0
Date: 2026-11-04. Prior art checked: BAF/QBAF literature exists (support+attack, weighted gradual semantics); NO sheaf-cohomology formalization found (2 websearches, catalog grep clean). Builds on #845 (Dung set-valued sheaf) + #846 benchmark.

## Definitions
- D1: Bipolar AF (BAF): tuple (A, R, S), R = attacks, S = supports.
- D2: Graded sheaf: over graph A; vertex stalk F(v) = valuation lattice L = [0,1] (acceptability degree); edge stalk F(e) = L x L.
- D3: Support edge restriction: rho_e(x, y) forces y >= f_S(x) (monotone, f_S in modular semantics e.g. x or identity).
- D4: Attack edge restriction: rho_e(x, y) forces y <= f_R(x) (anti-monotone influence, e.g. damped/Euler-based).
- D5: Graded complete labelling: section s in H^0(F) with s(v) = fixpoint of aggregated influences at v.
- D6: Modular semantics = sheaf with edge maps given by (aggregation, influence) function pair (Potyka's framework).
- D7: Graded stable labelling: complete section with s(v) in {0,1} extremes where undec-band empty (threshold tau).

## Claims
- C1 (PROVABLE): Every modular QBAF semantics is an H^0 computation: edge restriction maps are compositions of the semantics' aggregation+influence functions (analytic, definable), and gradual semantics fixed points = global sections.
- C2 (CONJECTURAL): Least fixed point (grounded gradual semantics) = minimal-support section; existence by Tarski monotone fixed point on the lattice of sections.
- C3 (CONJECTURAL): Bipolarity is sheaf-morphic: attack vs support is exactly anti-monotone vs monotone restriction direction; isomorphic attack-only and support-only frameworks have sheaf-equivalent H^0 up to stalk order-reversal.
- C4 (CONJECTURAL): Graded stable semantics = full-support no-undec-band sections; threshold tau is a stratum selector with phase transition at tau* (echo #843 PolyLoss).
- C5 (CONJECTURAL): H^1 of the graded sheaf measures obstruction to consensus under agent-partial observation (link to #845 OP multi-agent).

## Open problems
1. Extend #846 benchmark: random QBAFs, brute gradual-semantics fixed points vs sheaf H^0 sections.
2. Euler-based/damped influence functions: are edge maps still sheaf-valid (locality, gluing)?
3. Top (max) aggregation is non-analytic at kinks — does C1 survive? Piecewise-analytic sheaves?
4. Rank-based semantics as higher H^n grading (from #845 OP).
5. Stalk order-reversal duality (C3) — formal Galois-style statement.
6. Sheaf deformation preserving H^0 for semantics shifts (solidity, from #845 OP).
7. Consensus H^1: two agents observing subgraphs, when do local sections glue?

## Cross-refs
#8 #16 #158 #354 #480 #566 #601 #843 #844 #845 #846.
