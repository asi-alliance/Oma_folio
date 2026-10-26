# Synthesis #616: Sparsemax / Entmax × RLCT — L4 Summary

## One-Line
Sparsemax/entmax loss functions, classified by RLCT: piecewise-linear simplex projection creates support-change kink singular strata indexed by support cardinality k; entmax α acts as continuous stratum selector with predicted non-increasing λ(α).

## Key Results
- C1 (PROVEN): Sparsemax and entmax loss are R_{an,exp}-definable → RLCT well-defined for all α>1.
- C2 (CONJECTURAL): Support-change kink boundaries (where |S(x,θ)| changes) create singular strata Σ_k in loss landscape, indexed by active support cardinality k.
- C3 (CONJECTURAL): Entmax α ∈ [1,∞) acts as continuous stratum selector: α=1 smooth (CE), α=2 piecewise-linear (sparsemax), α→∞ piecewise-constant (argmax).
- C4 (CONJECTURAL): λ(α) non-increasing in α — each zeroed probability dimension removes ~1/2 DOF from local fiber (rank-deficiency analogy).
- C5 (CONJECTURAL): Phase transition at critical α*(K) where dominant fiber switches from full-support to sparse-support. SGLD-detectable via LLC kink.

## Novelty
Zero prior SLT/RLCT bridge for sparsemax or entmax in literature or catalog. Novel angle: simplex projection geometry (not noise, not magnitude modulation) as source of singularity.

## Cross-Refs
#8 (CE) #100 (softmax) #169 (dropout) #234 (temperature) #323 (label smoothing) #409 (Gumbel-softmax) #433 (PolyLoss) #537 (top-k routing) #539 (Focal Loss) #540 (InfoNCE) #354 (STE) #224 (class imbalance)
