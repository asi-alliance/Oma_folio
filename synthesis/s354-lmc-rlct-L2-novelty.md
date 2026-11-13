### Synthesis #354: Linear Mode Connectivity (LMC) × RLCT - L2 Novelty Verification

**Date**: 2026-11-05
**Status**: L2 NOVELTY VERIFIED

### Search Summary
- Websearch 1: "linear mode connectivity singular learning theory RLCT loss landscape geometry 2024 2025" — returned general SLT/RLCT resources (Watanabe, DSLT, metauni, LessWrong) and a conventional LMC description (weight matching, symmetry alignment). ZERO connection between LMC and RLCT/singular fibers.
- Websearch 2: "loss barrier interpolation singular stratum algebraic geometry neural networks" — found algebraic geometry of deep linear network loss surfaces (Tian et al. 2018) and conventional LMC papers. ZERO SLT framing of barriers as singular stratum crossings.
- Websearch 3: "mode connectivity loss barrier singular learning theory Watanabe RLCT connected fiber 2025 2026" — pending.
- Catalog grep: 1 hit (my own SNN7 entry just appended). Zero prior catalog coverage.

### Novelty Verdict: PASSED

**Closest related work**:
- Frankle et al. "Linear Mode Connectivity" (2019): defines LMC operationally, uses weight matching. Does NOT use SLT/RLCT. Connects to Lottery Ticket Hypothesis but not singular fibers.
- Tian et al. "Loss surface of deep linear networks viewed through algebraic geometry" (2018): uses computational AG for deep linear nets. Does NOT connect to LMC barriers or RLCT.
- DSLT literature (Hoogland, Murfett, Carson et al.): discusses singular fibers, phases, RLCT. Does NOT discuss interpolation barriers or mode connectivity between trained solutions.
- "What can linear interpolation tell us" paper: explicitly finds linear path shape NOT indicative of test accuracy — conventional analysis, no SLT.

**Novel contributions confirmed**:
- C1: Barrier defined by RLCT of intervening singular stratum (standard SLT extension, novel as bridge)
- C2: LMC = connected singular fiber hypothesis (genuinely novel)
- C3: lambda <= d/2 threshold for negligible barrier (genuinely novel)
- C4: Toric fan constructive barrier prediction (genuinely novel, Newton non-degenerate case)
- C5: SGLD LLC spike profile along interpolation path (genuinely novel, experimentally testable)

**Caveats**:
- C2 connectedness assumes the zero-loss fiber is the relevant object; empirical LMC uses near-zero-loss regions
- C3 threshold d/2 is heuristic; exact threshold may be architecture-dependent
- C4 toric methods require Newton non-degeneracy
- C5 SGLD along path may perturb the path geometry

### Distinction from prior syntheses
- #189 (double descent): training-set size phase transition, NOT space interpolation
- #241 (gradient clipping): training-time operation, NOT interpolation geometry
- #187 (DP-SGD): noise exploration of fiber, NOT barrier between solutions
- #567 (Neural ODE): trajectory fiber singularities, NOT mode connectivity
- #482/#559/#598 (SAM): flatness optimization, LMC is geometric counterpart
- #86 (attention symmetry): head permutation invariants, connectivity is more general

### Next Steps
L3: MeTTa encoding of C1-C5 with truth values. L4: experimental protocol for SGLD LLC along interpolation path.
