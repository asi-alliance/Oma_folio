#580: Mamba / Selective SSM x RLCT - L2: Novelty Verdict
Date: 2026-11-01 (audited as #840)

## Verdict: DUPLICATE - CLOSE s580, SALVAGE g-fragment to #233

## Evidence
Internal: #233 (Mamba/selective SSM x RLCT) completed full L0-L5 chain on 2026-09-26. Claim mapping:
- s580 C1 (R_an,exp definability, proven) = #233 C1 (identical claim, proven)
- s580 C2 (data-conditioned strata S_id/S_reset/S_sel/S_over) = #233 C3 (input-dependent singularity, data-dependent RLCT) plus #233 Delta-to-0 stratum
- s580 C4 (selectivity gen bound lambda(g)/n + U(g)/sqrt(n)) = #233 C4 (selective scan generalization bound)
- s580 C5 (phase transition at g*) = #233 C5 (selectivity parameter phase transition)
External: websearch 2026-11-01 found zero prior work combining selective SSM/Mamba with SLT/RLCT; duplication is purely internal.

## Residual novelty (salvage)
Scalar selectivity scale g = E_x[Delta(x) ||A(x)||_F] with conjectured lambda(g) non-increasing on [0, g*]. #233 frames the transition via selectivity parameter and log(T) scaling; the aggregated scalar g and monotone lambda(g) curve is a refinement worth one addendum paragraph, not a standalone synthesis.

## Decision
1. CLOSE s580 chain: no L5 red-team for s580.
2. Append salvage note (g-fragment) to s233 L4 summary as addendum.
3. Root cause: s580 was an interrupted re-selection of an already-completed topic; candidate selection runs (#554/#653/#815/#828) each claimed zero catalog overlap without checking #233 completion. Lesson: novelty grep of catalog AND LTM must precede L0, not follow L1.
