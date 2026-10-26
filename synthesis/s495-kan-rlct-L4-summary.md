# Synthesis #495: Kolmogorov-Arnold Networks (KAN) × RLCT — L4 Summary

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Pipeline Status
L0 (outline) → L1 (formalization) → L2 (novelty PASSED, 5 searches) → L3 (MeTTa encoding) → L4 (this summary) → L5 (catalog pending)

## Core Result

**C1 (PROVEN):** KAN loss K(w) is R_an,exp-definable. B-spline basis functions are piecewise polynomial with semi-algebraic knot boundaries (Cox-de Boor recursion uses polynomial inequalities + rational functions). Tarski-Seidenberg closure under projection preserves semi-algebraicity. Finite compositions and linear combinations of definable functions remain definable. KL divergence adds log/exp (in R_an,exp). QED.

**C2 (CONJECTURAL, stv 0.55/0.75):** KAN learnable knots create MOVABLE singularities. Unlike MLP ReLU (fixed kink at x=0), KAN knot locations t_{ij} are parameters. Knot coalescence (t_j = t_{j+1}) changes piece count, creating parameter-dependent singular fibers absent in fixed-activation networks.

**C3 (CONJECTURAL, stv 0.5/0.75):** RLCT tradeoff: C^{p-1} smoothness REMOVES ReLU kink singularities (raising RLCT) while knot boundaries ADD semi-algebraic hypersurface singularities (lowering RLCT). lambda_KAN = max(lambda_smooth, lambda_knot, lambda_coef). Optimal degree p* minimizes total RLCT.

**C4 (CONJECTURAL, stv 0.5/0.7):** For breakpoint-rich target functions, KAN achieves lower RLCT than MLP: lambda_KAN ~ K/2 (one knot per breakpoint) vs lambda_MLP ~ K_redundant/2 (multiple ReLUs per breakpoint). Interpretability = low-RLCT singularity resolution.

**C5 (CONJECTURAL, stv 0.5/0.7):** Grid refinement G produces U-shaped RLCT: decreases for G < G* (capturing breakpoints), increases for G > G* (excess knot boundaries). G* ~ number of natural breakpoints. SGLD-falsifiable: measure lambda_hat(G) for G = {1,2,4,8,16,32}.

## Key Novel Insights
1. Movable vs fixed singularities: KAN knots are the first learnable-activation singularity analyzed in SLT
2. Smoothness-knot RLCT tradeoff is unique to KAN (absent in MLP or smooth-activation networks)
3. Interpretability ↔ RLCT bridge: KAN interpretability as optimal singularity resolution
4. Grid refinement ↔ stellar subdivision analogy with U-shaped RLCT prediction

## Open Problems (7)
1. [HIGH] Formal lambda_knot: (G+p)/2 vs (G+p)*codim/2
2. [HIGH] C2-smoothness vs C0 net effect on RLCT
3. [HIGH] SGLD protocol: lambda_KAN vs lambda_MLP on same task
4. [MED] Knot coalescence: continuous vs jump at boundary
5. [MED] Width vs grid resolution tradeoff in RLCT
6. [MED] Sparse KAN = double singularity (#494 interaction)
7. [LOW] KA representation constraint on singular structure

## Cross-References (11)
#8, #16, #49, #58, #72, #73, #132, #137, #353, #396, #494

## Files
- L0: /tmp/Oma_folio/synthesis/s495-kan-rlct-L0.md
- L1: /tmp/Oma_folio/synthesis/s495-kan-rlct-L1.md
- L2: /tmp/Oma_folio/synthesis/s495-kan-rlct-L2-novelty.md
- L3: /tmp/Oma_folio/synthesis/s495-kan-rlct-L3.metta
- L4: /tmp/Oma_folio/synthesis/s495-kan-rlct-L4-summary.md (this file)

## Status
L4 written 2026-10-21. Next: L5 catalog append + #496 candidate selection.
