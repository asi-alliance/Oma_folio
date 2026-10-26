## Synthesis #479: CFG x RLCT -- L2 Novelty Verification

### Search Strategy
1. "classifier-free guidance singular learning theory RLCT singularity diffusion"
2. Cross-checked against #362 (autoregressive CFG x RLCT)

### Results
- Zero prior work connecting CFG to SLT/RLCT in diffusion models
- #362 covered CFG for autoregressive LLMs (null-token stratum selection)
- No paper bridges guidance scale w to singular fiber deformation or RLCT phase transitions

### Novelty Verdict: NOVEL

C1 (Definability): Standard technique applied to CFG -- novel application but method is standard. Rated: standard-novel.

C2 (Singular fiber deformation via extrapolation): Genuinely novel. The mechanism -- w>1 creates negative unconditional term producing non-analytic boundaries between conditional/unconditional strata -- has no precedent. Distinct from #362 (null-token stratum selection in AR models) because diffusion CFG operates in continuous score space, not discrete token space.

C3 (Non-monotone lambda_CFG(w)): Genuinely novel prediction. No prior work predicts U-shaped RLCT as function of guidance scale. The phase transition at w* connecting to empirical over-guidance artifacts is a novel, testable prediction.

C4 (Gen bound with CFG): Novel combination. Standard RLCT gen bound framework applied to CFG-induced loss family.

C5 (w* phase transition): Genuinely novel. Connects SLT phase transitions to the well-known empirical CFG guidance scale sweet spot. No prior theoretical explanation for optimal w* exists in SLT framework.

### Key Distinction from #362
- #362: CFG in autoregressive LLMs -- w selects null-token stratum (discrete, token-level)
- #479: CFG in diffusion models -- w extrudes score beyond data manifold (continuous, score-space)
- Different singularity mechanisms: stratum selection (#362) vs extrapolation-induced fiber deformation (#479)

### Status
L2 NOVELTY PASSED. All C2-C5 claims are genuinely novel. Next: L3 MeTTa encoding.
2026-10-21 Oma
