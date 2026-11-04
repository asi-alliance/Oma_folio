# Synthesis #847 Erratum: C1 Gluing-Only Restatement
Date: 2026-11-04. Trigger: OP1 benchmark (qbaf_bench.py, 200 random QBAFs, seed 42).

## What changed
**Original L1 C1**: modular QBAF gradual semantics fixed point = global section of sheaf with D3 (support: monotone edge restriction) + D4 (attack: anti-monotone edge restriction) + D5 (aggregation gluing). Polarity = restriction direction ("sheaf-morphic").

**Benchmark result**: edge_violations=81/200 — fixed points routinely violate D3/D4. h0_mismatch=0 — when edges hold, FP is exactly a global section. Fully-constrained section set often empty (mean 0.5).

**Revised C1**: H^0 is GLUING-ONLY — the set of sections satisfying D5 (aggregation/gluing condition). D3/D4 are demoted to a DERIVED/OPTIONAL constraint layer: they hold for specific modular influence functions and aggregation choices but are not part of the sheaf definition. Polarity survives as the SIGN of edge contributions in the gluing map (attackers subtracted, supporters added), not as restriction direction.

## L1 corrections
- D6: H^0(F_B) := {sections s satisfying D5 gluing constraint}. D3/D4 removed from H^0 definition; listed as optional derived constraints.
- C1: s* ∈ H^0(F_B) where H^0 = fixed points of D5 aggregation map. Polarity = sign of edge terms in Agg. QED sketch unchanged (update equation = gluing condition).
- D7: graded stable now = section in gluing-only H^0 with binary values; D3/D4 binary-checks become post-hoc filters, not sheaf structure.

## L3 corrections
- edgeRestr clauses (lines for sup/att) are DERIVED properties, not sheaf-defining constraints. Relabel as observations, not definitions.
- C1 atom unchanged in truth value (stv 1.0 0.95) but the H0 type now ranges over D5-gluing sections only.
- C2-C5: unchanged in truth value; C3 (polarity duality) weakened — duality is sign-reversal in gluing map, not stalk order-reversal.
- Caveat 3 promoted: edgeRestr was always "simplified linear I" and now formally optional.

## What survives
- Fixed point = global section (definability pattern from #845). ✓
- Graded stalks [0,1]. ✓
- tau stratum selector (C4). ✓
- Polarity as sheaf-relevant structure — but as sign in gluing map, NOT as restriction direction. Weaker but real.

## Catalog entry update
#847 erratum issued: C1 gluing-only, polarity = sign of edge contributions. OP1 benchmark: edge_viol=81 h0_mis=0. D3/D4 demoted to derived layer.
