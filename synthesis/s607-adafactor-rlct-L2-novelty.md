# Synthesis #607: AdaFactor × RLCT — L2 Novelty Check
## Date: 2026-10-25
## Status: L2 NOVELTY VERIFIED

## Websearch Results (5 searches)
1. "AdaFactor factored second moment RLCT singular learning theory novelty algebraic geometry optimizer" — ZERO SLT/RLCT hits
2. "AdaFactor low-rank second moment approximation singularity generalization bound Fisher information" — ZERO SLT/RLCT hits
3. "factored optimizer row column statistics algebraic variety rank deficiency neural network generalization" — ZERO SLT/RLCT hits
4. "AdaFactor optimizer generalization bound Fisher information matrix approximation theory" — theoretical convergence analysis exists (NeurIPS poster) but ZERO RLCT/SLT connection
5. "AdaFactor singular learning theory algebraic variety factored Fisher approximation low rank" — ZERO hits

Verdict: No prior work bridges AdaFactor to SLT/RLCT. Genuinely novel territory.

## Catalog Check
grep "adafactor" synthesis-catalog.md → ZERO_CATALOG_HITS
grep "factored second moment|rank-1 preconditioner|row column EMA" → ZERO_CATALOG_HITS

## Overlap Analysis

### vs #516 K-FAC/Shampoo
K-FAC factors Fisher as F ≈ A⊗B (Kronecker product), with A and B full-rank within their blocks.
AdaFactor factors second moment as V = R⊗C (rank-1 outer product of vectors, not matrices).
- K-FAC: rank = rank(A)·rank(B), generically high → full-rank preconditioner
- AdaFactor: rank = 1 ALWAYS → maximally rank-constrained preconditioner
- Singular geometry fundamentally different: K-FAC has block-structured strata, AdaFactor has grid-structured (row∪column) strata
DISTINCT.

### vs #605 Adagrad
Adagrad accumulates diagonal second moments irreversibly (cumulative sum).
AdaFactor uses factored row/column EMAs with forgetting (reversible).
- Adagrad: diagonal, irreversible, single stratum selector (cumulative)
- AdaFactor: rank-1 factored, reversible EMA, dual selectors (β_R, β_C)
- Freezing structure: Adagrad freezes individual entries, AdaFactor freezes rows∪columns
DISTINCT.

### vs #606 RMSProp
RMSProp maintains diagonal EMA of squared gradients (single γ).
AdaFactor maintains factored row/column EMAs (dual β_R, β_C).
- RMSProp: 1D stratum chain, single selector, diagonal metric (rank min(m,n))
- AdaFactor: 2D stratum lattice, dual selectors, rank-1 metric
- RMSProp has no approximation bias (diagonal IS the metric); AdaFactor has rank-1 approximation bias B_rank
DISTINCT.

### vs #289 Adam
Adam combines diagonal EMA with momentum (first moment + second moment).
AdaFactor uses factored second moment only (no first moment in standard form).
- Adam: diagonal second moment + first moment → 1D stratum + momentum fiber
- AdaFactor: rank-1 factored second moment → 2D grid stratum, no momentum fiber
DISTINCT.

## Novelty Verdict: PASSED
- C1 (definability): Standard pattern (same as all optimizer syntheses) — standard-novel
- C2 (rank-1 factored Fisher fiber): GENUINELY NOVEL — no prior work considers rank-1 outer product as singular geometry. Grid-structured freezing (row∪column) is unique.
- C3 (dual row-column stratum selector): GENUINELY NOVEL — 2D stratum lattice with independent β_R, β_C is unprecedented in catalog. Aspect ratio prediction is falsifiable.
- C4 (gen bound with factored bias): GENUINELY NOVEL — rank-1 approximation error as bias term B_rank in gen bound. Tension between lower λ and higher bias is novel tradeoff.
- C5 (phase transition at factor rank collapse): GENUINELY NOVEL — asymmetric SGLD kink (row collapse ∝ n, column collapse ∝ m) is unique signature. No other synthesis has asymmetric phase transitions.

## Key Novel Contributions
1. Rank-1 outer product as ALWAYS rank-1 preconditioner (vs K-FAC full-rank, diagonal axis-aligned)
2. Grid-structured singular fiber (row∪column freezing, not individual entries)
3. 2D dual-EMA stratum lattice with independent transition rates
4. Factored approximation bias B_rank in generalization bound
5. Asymmetric phase transition signature (row collapse ∝ n, column collapse ∝ m)
