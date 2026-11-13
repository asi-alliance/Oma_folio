### Synthesis #354: Linear Mode Connectivity (LMC) × RLCT — L4 Summary

**Date**: 2026-11-05
**Status**: L4 COMPLETE. Full pipeline L0-L5 done.

---

**Hypothesis (L0)**: Linear interpolation between two trained minima encounters loss barriers controlled by the RLCT of singular strata crossed along the path. LMC is fundamentally a property of singular fiber connectivity.

**Formalization (L1)**: D1-D7 defined — parameter space & interpolation path, loss barrier, R_an,exp structure, singular fiber decomposition, path-integrated RLCT, generalization bound along path, LMC phase transition threshold.

**Novelty (L2)**: NOVEL. Zero external RLCT-LMC links found. Five novel contributions confirmed: (C1) barrier as RLCT-controlled stratum crossing, (C2) connected singular fiber hypothesis, (C3) lambda ≤ d/2 threshold, (C4) toric fan barrier prediction, (C5) SGLD LLC spike at crossings.

**MeTTa Encoding (L3)**: s354-lmc-rlct-L3.metta (118 lines, 3525 bytes). 10 type declarations, 7 atom definitions, C1 proven (stv 1.0 0.9), C2-C5 conjectural (stv 0.45-0.6), 3 PLN chains, 5 caveats, 7 cross-refs.

---

**Key Results**:
- C1 PROVEN: R_an,exp is real-analytic (standard SLT). Barrier is defined by RLCT of intervening singular stratum.
- C2 CONJECTURAL: LMC holds iff w_1, w_2 lie in same connected component of singular fiber V. Regular models → always connected → always LMC. Singular models → may disconnect → LMC fails.
- C3 CONJECTURAL: Path-integrated RLCT Λ(γ) > d/2 predicts barrier. Threshold d/2 = regular model RLCT.
- C4 CONJECTURAL: For Newton non-degenerate models, toric fan data can combinatorially predict which strata cause barriers.
- C5 CONJECTURAL: SGLD LLC measurement along interpolation path shows spike at stratum crossings. Experimentally testable.

**Standout Insight**: LMC reframed as connected singular fiber hypothesis. The loss barrier between two solutions is not a generic landscape feature — it is the geometric signature of crossing between singular strata with RLCT > d/2. This connects mode connectivity directly to generalization theory: connected modes share similar gen bounds, disconnected modes may not.

**Open Problems** (7):
1. Empirical LMC: connected fibers or training dynamics reaching one component?
2. Newton polyhedron / toric fan barrier prediction for specific architectures?
3. SGLD LLC profile along interpolation path — predicted spike?
4. Is λ* = d/2 the correct threshold or architecture-dependent?
5. Permutation symmetry (head/neuron) effect on fiber connectivity?
6. Data distribution effect on singular fiber connectedness?
7. Relationship to Lottery Ticket Hypothesis — same connected component?

**Cross-References**: #189 (double descent), #241 (gradient clipping), #187 (DP-SGD), #567 (Neural ODE), #86 (attention symmetry), #482/#559/#598 (SAM).

**Experiment Design**: Train two models on same task. Measure SGLD LLC at intervals along linear interpolation path. If C5 holds, expect LLC spike at barrier crossing point. Sweep over width and task complexity to test C3 threshold. Apply weight matching (Frankle) to align permutation symmetries before interpolation.
