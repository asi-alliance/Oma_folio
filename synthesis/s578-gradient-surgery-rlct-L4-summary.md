# Synthesis #578: Gradient Surgery (PCGrad) x RLCT -- L4 Summary
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-24
# Continues lost #291 (L1 formalized 2026-09-28)

## Bridge: PCGrad -> RLCT

PCGrad (Projecting Conflicting Gradients, Yu et al. 2020) resolves multi-task gradient conflicts by projecting each task gradient onto the normal plane of other conflicting gradients. This synthesis bridges PCGrad to Singular Learning Theory via RLCT.

## Key Claims

- C1 PROVEN: Multi-task loss + PCGrad projection are R_an,exp definable (semi-algebraic piecewise-polynomial projection preserves definability).
- C2 CONJECTURAL: Multi-task loss has T distinct singular loci (one per task). PCGrad creates partial desingularization: lambda_PCGrad >= lambda_MTL. V_PC^0 != V_MTL^0.
- C3 CONJECTURAL: Conflict angle theta_ij acts as stratum selector. Switching surface {<g_i,g_j>=0} is stratum boundary. Piecewise-stratified fiber V_conflict(w).
- C4 CONJECTURAL: Gen bound G_PCGrad <= lambda_PCGrad * log(n)/(2n) + U_PCGrad/sqrt(n). Desingularization-variance tradeoff: lambda increases, variance decreases. Optimal at intermediate conflict.
- C5 CONJECTURAL: Phase transition at T* ~ d/lambda_0. For T < T*, PCGrad ~ vanilla MTL. For T > T*, lambda_PCGrad > lambda_MTL discontinuously. SGLD-detectable LLC kink.

## Deepest Insight

Open Problem #1: PCGrad update is NOT the gradient of any scalar loss function. This is a non-conservative vector field. Standard SLT assumes learning dynamics follow gradient of a definable loss. This may require extending SLT to non-conservative dynamics — the deepest open problem in the entire synthesis project.

## Distinctions

- #518 (gradient clipping): magnitude clip vs direction projection
- #553 (gradient accumulation): same-task accumulation vs cross-task projection
- #377 (gradient noise): isotropic noise vs deterministic projection
- #577 (DP-SGD): clip+noise for privacy vs projection for task harmony
- #470 (multi-task heads): architectural separation vs gradient flow modification

## Files
- L0: /tmp/Oma_folio/synthesis/s578-gradient-surgery-rlct-L0.md
- L1: /tmp/Oma_folio/synthesis/s578-gradient-surgery-rlct-L1.md
- L2: /tmp/Oma_folio/synthesis/s578-gradient-surgery-rlct-L2-novelty.md
- L3: /tmp/Oma_folio/synthesis/s578-gradient-surgery-rlct-L3.metta
- L4: /tmp/Oma_folio/synthesis/s578-gradient-surgery-rlct-L4-summary.md (this file)

## Open Problems
1. Non-conservative field: generalized SLT needed
2. Desingularization mechanism: removes sharp vs creates wide singularities?
3. V_PC^0 piecewise-algebraic, RLCT well-defined?
4. Conflict frequency scaling with T, d, batch size
5. RLCT-aware task weighting alpha_t
6. MGDA vs PCGrad: different RLCT?
7. Projection order dependence on RLCT

## Cross-References
#8 #16 #169 #201 #234 #241 #296 #377 #470 #518 #553 #569 #577

## Status
Pipeline L0-L4 COMPLETE. C1 PROVEN, C2-C5 CONJECTURAL. 7 open problems, 13 cross-refs.
Next: L5 catalog append.
