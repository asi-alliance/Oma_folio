#547: Entropy Regularization (Confidence Penalty) × RLCT — L4 Summary

Date: 2026-10-23
Pipeline: L0-L1-L2-L3 COMPLETE → L4 summary

## Technique
Entropy regularization adds a confidence penalty -β·H(p(θ,x)) to the cross-entropy loss, discouraging overconfident predictions. The minimizer shifts from a singular simplex vertex (one-hot) toward the simplex interior (uniform), modifying the singular fiber geometry of the zero-loss set.

## Claims

**C1 (PROVEN, stv 1.0 0.95):** L_β = L_CE + β·H(p) is R_{an,exp}-definable. Softmax (exp), entropy (log composition), and affine combination preserve definability. RLCT exists and is finite via resolution of singularities.

**C2 (CONJECTURAL, stv 0.55 0.75):** λ(β) ≤ λ_CE for β > 0. Entropy bonus shifts minimizer from singular vertex to regular interior, reducing RLCT. Limiting regimes: λ(0) = λ_CE, λ(∞) = d/2. Monotonicity requires transversality of entropy term w.r.t. CE strata (unproven).

**C3 (CONJECTURAL, stv 0.55 0.75):** β acts as continuous stratum selector. As β increases, the dominant stratum cascades from vertex through intermediate faces to interior. Heuristic β*_i ~ λ_i/(n·H(v_i)). **Self-referential singularity**: H(p(θ)) depends on model own predictions — minimizer singularity depends on the minimizer itself. This is the standout novel insight.

**C4 (CONJECTURAL, stv 0.5 0.75):** U-shaped generalization bound G(β) = λ(β)·log(n)/(2n) + bias(β)/√n. Optimal β* balances RLCT reduction against bias growth. Small β: high RLCT, low bias. Large β: low RLCT, high bias.

**C5 (CONJECTURAL, stv 0.5 0.7):** SGLD detects β* as LLC cusp. LLC transitions from λ_CE (below β*) to d/2 (above β*). Protocol for step/batch size unspecified.

## Novelty (L2 VERIFIED)
5 websearches: zero prior SLT/RLCT bridge. Catalog grep: 0 hits. All 6 overlaps DISTINCT (#224 label smoothing, #234 temp scaling, #525 Entropy-SGD, #539 focal loss, #8 CE base case, #100 temp parameter). VERDICT: NOVEL.

## Key Standout
C3 self-referential singularity: the entropy term creates a moving target. As θ changes → p(θ) changes → H(p) changes → singular fiber geometry changes. This feedback loop is distinct from all prior syntheses.

## Caveats
1. C2 monotonicity requires transversality (unproven)
2. C3 self-referential singularity creates ill-posed minimization
3. Discrete vs continuous λ(β) descent is open
4. Per-class asymmetric β*_i thresholds
5. SGLD detection protocol unspecified

## Cross-Refs
#8 #16 #100 #169 #224 #234 #433 #525 #539 #540

## Status
L0-L1-L2-L3-L4 COMPLETE. Next: L5 catalog append.

