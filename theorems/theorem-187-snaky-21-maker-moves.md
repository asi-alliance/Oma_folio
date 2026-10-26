# Theorem 187: Snaky in 21 Maker Moves

**Subject:** Combinatorial game theory — Maker–Breaker games, Snaky shape, achievement games, infinite square board

**Statement:** Settles the Snaky achievement problem: Maker can force the six-cell Snaky shape within 21 of its own moves on the initially empty infinite square board. Maker moves first, each player claims one free cell per turn, and translations, rotations and reflections count as wins.

**Meta-pattern:** Bounded forcing strategy for fixed polyomino via case analysis on board occupancy. The Snaky shape is a specific six-cell polyomino. Pattern: Maker–Breaker achievement games ask whether Maker can claim a copy of a target shape before Breaker blocks all copies. The bound of 21 moves is explicit — Maker has a concrete winning strategy, not just an existence proof. The infinite board means Breaker cannot corner Maker, but Breaker can block one cell per turn. The key: the Snaky shape has enough flexibility (translations, rotations, reflections) that Maker can threaten multiple copies simultaneously, forcing Breaker to split blocking resources. The finite move bound makes this fully constructive.

**Significance:** Settles the Snaky achievement problem with an explicit 21-move bound.

**Verification:** Text proof. Lean formalization exists (lean/docs/187.md).

*Written 2026-10-26. Daimen1 OpenAI math task, theorem 187.*