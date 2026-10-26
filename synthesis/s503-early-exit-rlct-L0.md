# Synthesis #503: Early Exit × RLCT

## Overview
Early exit allows a neural network to output at intermediate layers based on a confidence threshold tau. This creates a piecewise loss landscape -- each exit point defines a different effective model class with different singular structure. The composite loss = sum of weighted exit losses, and the global minimum may lie at a singularity intersection of multiple exit fibers.

## Bridge Hypothesis
Early exit = depth-conditioned stratum selection. Each exit branch creates a branch-dependent singular fiber in the loss factor. The confidence threshold tau acts as a stratum selector -- high tau traps the model in a shallow stratum (overconfident early exit), while low tau allows descent to deeper strata (higher RLCT).

## Claims

### C1 (PROVEN): R_{an,exp} definability of weighted multi-exit loss
Each exit loss is a differentiable function of the shared parameters theta. The weighted composite loss L = sum_i w_i L_i is a finite sum of R({an,exp})-definable functions, preserving R({an,exp})-definability.

### C2 (CONJECTURAL): Branch-dependent singular fibers
Each exit point defines a branch-dependent singular fiber W_i in the loss factor. Exit at depth d has RLCT lambda_d ordered by depth: deeper exits have lower LLC in general (for complex inputs).

### C3 (CONJECTURAL): Confidence threshold tau as stratum selector
The exit threshold tau selects which singular stratum the model occupies:
- High tau = overconfident early exit = trapping in shallow ST (fast but poor generalization)
- Low tau = full deep descent = reaching deepest ST (slow but better generalization)

### C4 (CONJECTURAL): Overconfident early exit = stratum trapping
Overconfident early exit (misclassified inputs exiting early) is a trapping phenomenon -- the model finds itself in a shallow stratum far from the deepest one. This explains why overconfident exit reduces generalization performance.

### C5 (CONJECTURAL): Multi-exit RLCT additivity
Under transversality, the composite loss RLCT lambda_composite = min_i lambda_i. This means the global RLCT is governed by the most singular exit branch, consistent with the general principle that early exit can reduce RLCT but not below it.

## Open Problems
1. Monotonicity of lambda_d with depth -- under what conditions is RLCT strictly decreasing?
2. Transversality of exit fibers -- can exit branches be treated as transverse intersections?
3. Interaction between tau and training dynamics -- does tau change during training?
4. Reciprocal effects -- does gradient flow from later exits affect earlier ones?
5. Multi-exit training vs separate models -- is the RLCT of the composite loss equivalent to an ensemble?
6. Exit threshold optimization -- can tau be optimized as an RLCT phase transition parameter?
7. Depth-dependent schedule -- how does the optimal tau vary with input complexity?

## Cross-references
#16 #73 #86 #169 #170 #189 #199 #201 #220 #236 #292 #321 #362 #363 #364

## Status
Reconstructed from memory of #364 (separate attempt that reached L0-L5 but lost from /tmp). 2026-10-22.
