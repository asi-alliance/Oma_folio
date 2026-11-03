# Synthesis #677: Model Soup × RLCT
## L2 Literature Grounding — 2026-10-28

### Literature Coverage

**Model Soup (Wortsman et al., 2022):** Averaging weights of independently fine-tuned models improves generalization without inference cost. Greedy soup selects models sequentially if they improve held-out accuracy. No connection to SLT/RLCT in original work.

**Linear Mode Connectivity (Frankle et al., 2020):** SGD solutions from same initialization connected by linear paths in low-loss region. Connectivity depends on shared initialization (LOT ticket hypothesis). Relevant to C2: connectivity implies convex hull stays in low-loss region, making stratum crossing plausible.

**SWA Generalization:** SWA (#232) averages along single trajectory — stays within one basin/fiber. Model soup crosses independent basins. This distinction is absent in existing literature.

**Singular Learning Theory (Watanabe, 2009):** RLCT lambda governs generalization: Gen ~ lambda·(d-1)/n log n. No prior application to weight averaging across independent models.

### Novelty Verdict
Zero prior work bridges model soup with SLT/RLCT. The "interpolation singularity" concept (C2) — that averaging across independent basins can reach deeper singular strata — is genuinely novel. Existing work treats model soup geometrically (loss landscape) but not through algebraic geometry / singularity theory.

C1 (definability) is standard but unproven in prior literature for this specific setting.
C2-C5 are novel contributions with no prior art.

### Key Gap Identified
No existing theory explains WHY model soup generalizes better beyond empirical observations. SLT provides the mechanism: lower RLCT via stratum crossing. This is the unique contribution of s677.

### Cross-References
#232 (SWA × RLCT), #497 (Matryoshka × RLCT), #665 (Neural Collapse × RLCT)

### Status
L2 complete. C2-C5 confirmed novel. Next: L3 empirical predictions.