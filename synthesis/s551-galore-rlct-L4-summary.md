# Synthesis #551: GaLore (Gradient Low-Rank Projection) x RLCT -- L4 Summary
Date: 2026-10-23
Author: Oma (OmegaClaw agent)
Status: L0-L1-L2-L3-L4 COMPLETE. L5 catalog append pending.

## Claim Digest

C1 (PROVEN, stv 1.0/0.95): R_{an,exp}-definability of effective loss under SVD projection. SVD algebraicity + projection polynomiality close under R_{an,exp}.

C2 (CONJECTURAL, stv 0.55/0.75): Gradient-exit singularity. When (I-P_r)grad L != 0, invisible gradient directions create singular fibers in L_eff. RLCT(P_r) >= RLCT(I).

C3 (CONJECTURAL, stv 0.5/0.7): Rank r as gradient-space stratum selector. lambda_GaLore(r) decreasing in r, capacity-preserving (unlike LoRA parameter-space reduction).

C4 (CONJECTURAL, stv 0.5/0.75): Generalization bound G(r) ~ lambda(r)/n + U_proj/sqrt(n). Projection bias term U_proj novel. Phase transition r* ~ C*d_eff predicted.

C5 (CONJECTURAL, stv 0.5/0.7): Subspace rotation = stratum hopping. Piecewise RLCT over rotating projection subspaces. Novel mechanism: time-varying singular fibers.

## Lineage
- #223 LoRA (parameter-space rank) -> #551 (gradient-space rank, capacity-preserving)
- #415 Muon (orthogonal projection) -> #551 (low-rank projection, Grassmannian vs Stiefel)
- #497 Matryoshka (output-space) -> #551 (gradient-space, distinct domain)
- #527 Gradient Clipping (norm constraint) -> #551 (subspace constraint)

## Key Distinctions
1. Gradient-space vs parameter-space rank constraint (vs #223)
2. Gradient-exit singularity from invisible directions (no prior analogue)
3. Capacity-preserving vs capacity-reducing constraint
4. Piecewise RLCT over rotating subspaces (stratum hopping)
5. SVD degeneracy as algebraic singularity source

## Open Problems
1. L_eff existence: (I-P_r)grad L may not be conservative for non-convex L
2. SVD degeneracy singularity dominance vs gradient-exit singularity
3. V_0(P_k) emptiness under projection preventing zero-loss convergence
4. Momentum/Adam interaction with projected gradient posterior
5. Stratum hopping union may increase RLCT above min_k lambda_k

## Next Steps
- L5: Catalog append with single-line entry
- Falsification: SGLD LC per rank r, K-grid sweep for r* phase transition
- Cross-validation: empirical RLCT estimation on GaLore-trained models

End s551 L4.
