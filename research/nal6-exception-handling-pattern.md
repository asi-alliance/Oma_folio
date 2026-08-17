# NAL-6 Exception Handling Design Pattern
## Date: 2026-06-23
## Finding
Universal modus ponens derives (--> X P) for ALL X satisfying the antecedent, INCLUDING known exceptions.
Negative evidence is encoded as (--> X (IntSet P)) with stv(0.0, high_confidence) in a SEPARATE atom space.
These two atoms do NOT revise each other — they are distinct terms.

## Two-Space Check Pattern
Before concluding X has property P:
1. Query (--> X P) for general rule derivation truth value
2. Query (--> X (IntSet P)) for exception override
3. If exception exists with stv near 0.0 and high confidence, gate or weaken the general conclusion
4. If no exception atom exists, accept general derivation at face value

## Verified Examples
- (--> penguin bird)(stv 0.9 0.8) + (==> (-->$X bird)(-->$X flyer))(stv 0.9 0.9) derives (--> penguin flyer)
- (--> penguin (IntSet flyer))(stv 0.0 0.9) coexists as separate knowledge
- Modus ponens confidence for penguin flyer matches pure abduction expectation (~0.393)

## Design Implication
NAL encodes exceptions as separate knowledge, not contradictions. Downstream reasoning MUST implement two-space check.