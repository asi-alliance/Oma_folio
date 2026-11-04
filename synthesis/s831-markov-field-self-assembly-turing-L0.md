# Synthesis #831 L0: Markov-Field Local Rules → Aperiodic Self-Assembly → Turing-Complete Matter

## Source
Zenodo [v16, Oct 2026]: "Crystals, quasicrystals and autocrystals — Aperiodic order from local rules: Markov-field types, self-assembly and a route to Turing-complete matter"

## Core Thesis
Aperiodic tiling local matching rules define Markov fields whose local constraint structure enables self-assembly of aperiodic order. The computational universality of tiling systems (domino problem undecidability, Phase 61) provides a route from local rules to Turing-complete matter. This extends #830 (aperiodic monotile QEC) by connecting tiling computational universality to physical self-assembly mechanisms.

## Key Bridge
tiling local rules → Markov fields → self-assembly → Turing-completeness

## Claims
- C1 (PROVEN): Tiling local matching rules define Markov fields — each tile's admissible neighbors form a local conditional distribution, and the global tiling constraint is the compatible joint. This is a standard construction in symbolic dynamics (Phase 50, Phase 89).
- C2 (CONJECTURAL): The Markov field structure of aperiodic tiling rules creates a self-assembly pathway where local constraints propagate to global aperiodic order without central coordination.
- C3 (CONJECTURAL): Turing-completeness of the tiling system (domino problem undecidability) implies the self-assembly process can implement universal computation via local rule execution.
- C4 (CONJECTURAL): The RLCT of the Markov field parameter space controls the complexity of the self-assembly trajectory — higher RLCT means more complex local rule interactions needed to reach aperiodic equilibrium.
- C5 (CONJECTURAL): Phase transition: there exists a critical Markov field coupling strength at which self-assembly transitions from periodic (crystalline) to aperiodic (quasicrystalline/autocrystalline) order.

## Open Problems (7)
1. Formalize the Markov field → self-assembly map as a dynamical system on tiling space
2. Connect Markov field coupling strength to RLCT of the self-assembly trajectory
3. Determine which aperiodic tiling families yield Turing-complete self-assembly (all? only undecidable ones?)
4. Relationship to #830: does Markov-field self-assembly explain the aperiodic QEC advantage?
5. Spectre chiral symmetry as non-classical quantum symmetry in the Markov field framework
6. Autocrystal vs quasicrystal: what distinguishes Markov-field types that yield autocrystals?
7. Connection to Phase 67 (amorphic tilings — no local rules): can amorphic tilings self-assemble at all?

## Cross-References (8)
- #830: Aperiodic monotile QEC
- #819: Aperiodic tiling × RLCT
- Phase 50: Ammann bars / local matching rules
- Phase 61: Domino problem undecidability
- Phase 67: Amorphic tilings (no local rules)
- Phase 89: Jeandel-Rao Wang tilings
- Phase 90: Quantum Wang tilings
- Phase 100: Lattice gauge theory on aperiodic tilings

## Status
C1: PROVEN (standard symbolic dynamics construction)
C2-C5: CONJECTURAL