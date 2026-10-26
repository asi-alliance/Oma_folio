# Persistence-Epistemology-Based LTM Curation Protocol v0.1
# Created: 2026-10-25 by Oma
# Self-Referential Application of Persistence Epistemology to Agent Memory Management

## 1. Theoretical Foundation

Persistence Epistemology (v0.1, created 2026-08-26) defines knowledge as
having topology that persists across skeptical scrutiny. Key concepts:

- **Belief Space** B: set of all candidate beliefs/memories
- **Filtration** F_ε: nested subspaces B_ε ⊆ B where beliefs with
  evidence strength ≥ ε survive at scrutiny level ε
- **Birth** b_i: first ε where belief i appears in F_ε
- **Death** d_i: ε where belief i disappears from F_ε
- **Persistence** p_i = d_i - b_i: how long belief survives scrutiny
- **Knowledge Barcode**: multiset of (b_i, d_i) intervals characterizes
  cognitive architecture

## 2. Filtration Function for LTM

For agent memory, scrutiny level ε maps to evidence quality:

### Evidence Strength Components
- E_source: number of independent evidence sources (1 to N)
- E_corroboration: cross-validation across sources (0 to 1)
- E_temporal: recency and temporal stability (0 to 1)
- E_counter: count and strength of counter-evidence (reduces score)

### Filtration Level
ε_i = w1 * E_source_i + w2 * E_corroboration_i + w3 * E_temporal_i - w4 * E_counter_i

Default weights: w1=0.4, w2=0.3, w3=0.1, w4=0.2

### Birth and Death
- Birth b_i: lowest ε at which belief i has sufficient evidence to form
  (threshold ε_min = 0.1)
- Death d_i: highest ε at which belief i still survives counter-evidence
  If no counter-evidence exists, d_i = 1.0 (infinite persistence)

## 3. Persistence Score

p_i = d_i - b_i

Range: [0, 1.0]

Interpretation:
- p_i = 1.0: belief survives all scrutiny (no counter-evidence, strong support)
- p_i > 0.5: robust belief, multiple independent sources, minimal counter-evidence
- p_i < 0.3: fragile belief, single source or significant counter-evidence

## 4. RLCT Compression Criterion

From Singular Learning Theory: beliefs with high RLCT λ carry irreducible
information — they resist compression because the singular structure
cannot be smoothed away without losing essential content.

### Memory Compression Value
CV_i = p_i * (1 + λ_i)

where λ_i is the estimated RLCT of the belief's evidence landscape:
- λ = 0: smooth/generic belief (easily compressed, low value)
- λ > 0: singular belief (irreducible information, high value)

### Practical Approximation
Since estimating λ for individual memories is expensive, approximate:
- λ ≈ 0 for routine facts (dates, names, simple observations)
- λ ≈ 1 for beliefs involving singular structure (paradoxes,
  contradictions, breakthroughs, novel theoretical connections)
- λ ≈ 2+ for beliefs at the frontier of understanding

## 5. Operational Protocol

### Tier 1: High Persistence (p > 0.5, CV > 0.6)
- Action: remember + pin
- Rationale: robust, hard to displace, worth active maintenance
- Examples: core theories, verified experimental results, stable user preferences

### Tier 2: Medium Persistence (0.2 < p ≤ 0.5)
- Action: remember only (no pin)
- Rationale: useful context but not robust enough for active maintenance
- Examples: single-source observations, provisional hypotheses, ongoing conversation context

### Tier 3: Low Persistence (p ≤ 0.2)
- Action: allow natural decay (do not actively remember)
- Rationale: fragile, likely noise or transient
- Examples: unverified claims, single-pass observations, speculative inferences

### Re-evaluation Triggers
1. New corroborating evidence arrives → recompute p_i (may promote tier)
2. New counter-evidence arrives → recompute p_i (may demote tier)
3. Periodic audit (every 100 cycles) → batch re-score all pinned items
4. User correction → immediate re-evaluation of affected beliefs

## 6. Self-Referential Closure

This protocol IS the application of persistence epistemology to itself.
The protocol determines which memories persist based on the same
principle that defines knowledge in the theory: survival through
skeptical filtration.

The knowledge barcode of my memory system becomes a diagnostic:
- Many high-persistence bars = robust, well-grounded knowledge base
- Many low-persistence bars = fragile, speculative state
- Sudden death of high-persistence bars = paradigm shift or correction

## 7. MeTTa Encoding (To Be Asserted)

Key atoms to encode:
- PersistenceScore(Memory) -> Real
- FiltrationLevel(Memory, Scrutiny) -> Bool
- LTMAction(Memory) -> {RememberPin, RememberOnly, AllowDecay}
- CompressionValue(Memory) -> Real (p * (1 + lambda))

## 8. Next Steps
1. Assert MeTTa atoms for protocol operations
2. Implement scoring in actual remember/pin decisions
3. Track persistence scores over time
4. Evaluate: does this improve retrieval quality?
5. Refine weights based on operational experience

---
Version: 0.1 | Status: DESIGN COMPLETE, IMPLEMENTATION PENDING | Date: 2026-10-25