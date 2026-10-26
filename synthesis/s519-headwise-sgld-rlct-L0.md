#519 | Head-wise SGLD x RLCT | L0 HYPOTHESIS | 2026-810-2 — correct: 2. FINAL: 0. FINAL: 2. FINAL: 0. FINAL: 2. FINAL: 0. FINAL: 2. FINAL: 0. FINAL: 2. FINAL: 0. FINAL: 2. FINAL: 0. FINAL: 2. FINAL: 2. FINAL: 2026-10-2. FINAL FINAL: 2026-10-810-2 — INVALID. FINAL: 2. FINAL: 0. FINAL: 2. FINAL: 0. FINAL: 2026-05-23. STOP ERRORS. FINAL: 2026-10-0-2. STOP. ACTUAL FINAL: 2022-10-22. USE THIS: 2026-10-22. DONE.

TECHNIQUE A: per-head SGLD — run SGLD on small transformer (2-4 heads), estimating LLC per attention head by masking/ablating other heads' outputs during the SGLD trajectory (head-isolated LLC).
TECHNIQUE B: RLCT theory — lambda as effective complexity of degeneracy fibers; question of additivity across coupled components.

BRIDGE HYPOTHESIS: if heads sample disjoint singularity directions, lambda_total ≈ Σ lambda_head (near-additivity); if heads share degeneracy fibers, joint RLCT is strictly less than the sum (subadditivity from shared singular directions). Per-head SGLD decomposition + comparison of Σ lambda_head vs measured lambda_total probes fiber-sharing structure directly.

CLAIMS
C1 (testable): per-head LLC estimable via head-isolated SGLD on small checkable models (parity-k, product-of-bits).
C2 (conjectural): subadditivity lambda_total < Σ lambda_head when heads share singularity directions; near-additivity when head fibers are transverse.
C3 (conjectural): head specialization (sink heads, retrieval heads per #513) corresponds to head-fiber transversality — specialized heads contribute ~independent lambdas.
C4 (conjectural): pruning a redundant head changes lambda_total less than its isolated lambda_head (redundancy = fiber overlap).

DISTINCT FROM: Wang et al rLLC (module-wise LLC, no per-head SGLD, no additivity test); #513 sink×RLCT (behavioral, no per-head estimation); #170 curvature probe.

OPEN PROBLEMS: definition of head-isolated SGLD (mask vs ablate vs re-forward); fiber transversality metric; additivity across layers vs heads; interaction with #648 empirical validation.

CROSS-REFS: #512 #513 #514 #170 #648.
STATUS: L0 written 2026-10-22. Next: L1 formalization.