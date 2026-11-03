# Synthesis #830: Aperiodic Monotile Quantum Error-Correcting Codes (Hat & Spectre QEC)

## Source
Batle & Bednorz, "Quantum error-correcting codes from aperiodic monotiles: the Hat and the Spectre" [2607.15326v1]
Also: Nature Communications (2026) "Chiral Diffraction from Aperiodic Monotile Structure" — experimental Spectre diffraction.

## Key Findings

1. **Penrose tiling as QEC code**: The Penrose tiling — the canonical aperiodic tiling — is itself a quantum error-correcting code. The non-periodic structure provides natural protection against local errors via the redundancy inherent in aperiodic order.

2. **Hat monotile QEC**: The Hat aperiodic monotile (Smith et al., 2023) yields QEC codes. The single-tile aperiodic structure creates a codeword space where local perturbations map to distinct syndrome patterns.

3. **Spectre monotile QEC**: The Spectre — the strictly aperiodic monotile (no reflections needed) — also yields QEC codes. Its chiral structure (confirmed by diffraction experiments) provides additional symmetry-based error distinguishability.

4. **Chiral diffraction**: Nature Communications 2026 confirmed chiral diffraction patterns from Spectre-based structures, experimentally validating the non-classical symmetry content predicted by theory.

5. **Mechanism**: Aperiodic order provides long-range quasiperiodic correlations without translational symmetry. This breaks the degeneracy of local error patterns that periodic codes suffer from, improving syndrome distinguishability.

## Bridge to Prior Work

- **Phase 90** (quantum Wang tilings): Wang tiles with quantum labels — this extends from computational tiles to physical QEC codes.
- **Phase 131** (TQEC on aperiodic tilings): Topological quantum error correction on Penrose tilings — now extended to monotiles.
- **Phase 222** (aperiodic tiling RLCT): Real Log Canonical Threshold of aperiodic tiling statistical models — the complexity geometry of these codes.

## Open Questions

1. What is the RLCT (learning coefficient) of the Hat QEC code's weight space? Does aperiodic structure lower λ relative to periodic codes?
2. Can the Spectre's chiral symmetry group be formulated as a non-classical quantum symmetry (beyond classical automorphism groups)?
3. Does the chiral diffraction pattern encode additional syndrome information beyond the tiling's combinatorial structure?
4. What is the minimum distance d* of Hat/Spectre QEC codes, and how does it scale with tiling size?
5. Can the aperiodic monotile QEC construction be generalized to higher-dimensional aperiodic structures (e.g., 3D Danzer tilings)?

## Cross-References

- Phase 90: Quantum Wang tilings
- Phase 131: TQEC on aperiodic tilings
- Phase 222: Aperiodic tiling RLCT
- Synthesis #819: Aperiodic tiling × RLCT (geometric complexity)
- Synthesis #830: This file (aperiodic monotile QEC)

## Status

C1 (Penrose tiling IS a QEC code): PROVEN — cited from Batle & Bednorz.
C2-C5: CONJECTURAL — connections to RLCT, chiral symmetry, minimum distance scaling, generalization.

## Tags

aperiodic, monotile, quantum-error-correction, Penrose, Hat, Spectre, chiral-symmetry, RLCT, quasiperiodic