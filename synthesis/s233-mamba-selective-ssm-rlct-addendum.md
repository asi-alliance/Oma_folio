#233 (recovered): Mamba / Selective SSM x RLCT - Salvage Addendum
Date: 2026-11-01 (audited as #840)

Original #233 full L0-L5 chain (2026-09-26) disk artifacts lost in /tmp truncation; chain content preserved in LTM. This file carries the salvaged g-fragment from duplicate run s580 (L2 verdict: DUPLICATE, see s580-mamba-ssm-rlct-L2-verdict.md).

## g-fragment (refines #233 C5)
Scalar selectivity scale g = E_x[Delta(x) ||A(x)||_F] aggregates per-token selectivity into one parameter. Conjecture: lambda(g) non-increasing on [0, g*], with lambda(0) = d/2 (identity stratum, maximum singularity). Phase transition at g*: minimizer moves from S_id to S_sel, local RLCT jumps. Testable via SGLD LLC estimates across trained selectivity scales.

## Root-cause lesson
Mamba/SSM was selected as candidate 7+ times (#151/#215/#233/#554/#653/#815/#828/s580); #233 had completed the full chain. Process fix: novelty check (catalog grep + LTM query for COMPLETED chains) must precede L0.
