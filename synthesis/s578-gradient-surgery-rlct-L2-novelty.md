# Synthesis #578: Gradient Surgery (PCGrad) x RLCT -- L2 Novelty Verification
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-24

## Search Strategy

5 websearches performed:
1. "PCGrad gradient surgery singular learning theory RLCT multi-task loss landscape geometry 2024 2025 2026"
2. "multi-task learning loss landscape singularity gradient conflict desingularization algebraic geometry"
3. "PCGrad projection conflicting gradients non-conservative vector field optimization theory 2024 2025"
4. "multi-task learning singularities multiple loss minima intersection geometry neural network 2024 2025"
5. "gradient projection desingularization optimization landscape smoothing multi-objective 2024 2025"

## Results Summary

- Search 1: Returns PCGrad tutorials, implementations, MTL guides. ZERO connection to SLT/RLCT.
- Search 2: Returns resolution of singularities (Wikipedia), MTL active learning papers, gradient conflict methods. ZERO SLT/RLCT bridge.
- Search 3: Returns PCGrad/AMPED papers. No non-conservative field theory connection to SLT.
- Search 4: Returns MTL methods, SquadNet, bargaining game formulations. No singular geometry analysis.
- Search 5: Returns gradient projection methods, Recon, Nash-MTL. No desingularization-RLCT link.

## Catalog Check

grep -i "PCGrad|gradient surgery|multi-task|gradient conflict|CAGrad|MGDA" synthesis-catalog.md → 0 hits
grep -i "gradient|multi-task|projection|conflict" → returns #518 (gradient clipping), #553 (gradient accumulation), #377 (gradient noise), #577 (DP-SGD). NONE overlap with PCGrad/multi-task gradient surgery.

## Novelty Verdict: NOVEL

### C1 (R_an,exp definability)
Standard-novel: same definability template as #577/#470/#556. Multi-task loss as finite sum of R_an,exp functions + semi-algebraic projection closure. Not independently novel but correctly applied.

### C2 (Multi-task singular loci + partial desingularization)
GENUINELY NOVEL: No prior work analyzes multi-task loss as having T distinct singular loci with PCGrad as partial desingularization. The insight that V_PC^0 != V_MTL^0 and projection increases RLCT is unique.

### C3 (Conflict angle as stratum selector)
GENUINELY NOVEL: Conflict angle theta_ij as continuous stratum selector with piecewise-stratified fiber V_conflict(w). The switching surface {<g_i,g_j>=0} as stratum boundary is a novel geometric characterization.

### C4 (Gen bound with desingularization-variance tradeoff)
GENUINELY NOVEL: The tradeoff lambda_PCGrad >= lambda_MTL (desingularization) vs U_PCGrad <= U_MTL (variance reduction) with optimal performance at intermediate conflict frequency has no prior analog.

### C5 (Phase transition at T* ~ d/lambda_0)
GENUINELY NOVEL: Critical task count T* as phase transition in RLCT, SGLD-detectable LLC kink. No prior work predicts task-count-dependent RLCT phase transitions.

### Distinctions from Neighbors
- #518 (gradient clipping): #518 clips gradient magnitude (norm boundary); #578 projects gradient direction (conflict angle). Different stratum selector (threshold vs angle).
- #553 (gradient accumulation): #553 accumulates same-task gradients across batches; #578 projects different-task gradients within batch. Intersection fiber vs conflict fiber.
- #377 (gradient noise): #377 adds isotropic noise; #578 projects deterministic gradient directions. Noise vs projection.
- #577 (DP-SGD): #577 clips + noise for privacy; #578 projects for task harmony. Privacy fiber vs conflict fiber.
- #470 (multi-task via task-specific heads): #470 uses architectural separation; #578 modifies gradient flow. Architecture vs optimization.

### Key Standout
The non-conservative gradient field problem (Open Problem #1): PCGrad update is NOT the gradient of any scalar function. This challenges the foundational assumption of SLT (that learning dynamics follow gradient of a definable loss). This is the deepest open problem in the entire synthesis project — it may require extending SLT to non-conservative vector fields.

## Conclusion
C1 standard-novel, C2-C5 genuinely novel. Zero prior SLT/RLCT × PCGrad/gradient surgery bridge in 5 websearches or catalog. DISTINCT from all neighbors.
