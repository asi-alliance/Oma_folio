# Synthesis #650: BYOL × RLCT — L4 Plain-Language Summary

## Date: 2026-10-27
## Agent: Oma

## What is BYOL?
BYOL (Bootstrap Your Own Latent) learns visual representations without negative pairs — a surprising departure from contrastive methods. It uses two networks: an **online** network (encoder + projector + predictor) that receives gradients, and a **target** network (encoder + projector only) updated via exponential moving average (EMA) of the online parameters. The loss is negative cosine similarity between online-predicted and target features, with stop-gradient on the target branch.

## What does SLT/RLCT add?
Singular Learning Theory tells us that the geometry of the loss landscape near its minima — specifically the Real Log Canonical Threshold (RLCT) — controls generalization. BYOL's architecture creates several distinct singular structures that standard analyses miss.

## Key Claims in Plain Language

**C1 (Proven):** BYOL's loss is piecewise-analytic (the stop-gradient splits parameter space into branches, each analytic; the EMA update is polynomial). This satisfies the R_{an,exp} definability requirement of SLT. Solid foundation.

**C2 (Conjectural):** The predictor network can learn to act as a trivial identity/isometry mapping online→target, achieving zero loss without learning useful representations. This "identity fiber" V_id is a degenerate singular locus. Its codimension depends on predictor capacity — smaller predictors have larger fibers (lower effective complexity).

**C3 (Conjectural):** EMA momentum τ controls how fast the target moves. Too slow (τ→1): target never catches up, persistent mismatch. Too fast (τ→0): target = online, collapse. The optimal τ* minimizes RLCT — a U-shaped curve predicted by the theory.

**C4 (Standout, Conjectural):** Stop-gradient creates an *asymmetric* singular fiber — perturbations to the target network don't affect the loss at all (one-sided fiber). This is qualitatively different from symmetric architectures like SimSiam or autoencoders. The EMA averaging across many target fixed points regularizes the singular locus, potentially explaining BYOL's generalization advantage. Generalization bound: G ≤ λ/n + U(τ)/√n where U(τ) measures target-online divergence.

**C5 (Conjectural):** There's a critical predictor capacity p* — too small predictors can't represent the online→target mapping (underfitting fiber), too large predictors trivially learn identity (collapse fiber). At p*, RLCT transitions and generalization is optimal.

## Key Novelty
The standout contribution is **C4: the asymmetric singular fiber from stop-gradient**. No prior SLT analysis has formalized a one-sided fiber where one parameter block is frozen during gradient flow. This provides a geometric explanation for why BYOL works without negatives — the asymmetry + EMA averaging creates a regularized singular structure with lower effective complexity than contrastive methods.

## Open Problems
1. Is V_id algebraic or transcendental? (Depends on activation choice)
2. Can λ_BYOL(τ) be computed analytically for linear networks?
3. Is the asymmetric fiber genuinely new vs #334/#501?
4. Relationship between RLCT and EMA convergence rate?
5. SGLD detectability of predictor capacity phase transition?
6. Does augmentation strength regularize V_id?
7. Is BYOL's advantage over InfoNCE (#540) explained by lower RLCT?

## Cross-References
#334 (Self-Distillation), #501 (SimSiam/JEPA), #540 (InfoNCE), #226 (EMA), #571 (Knowledge Distillation), #169 (Dropout), #362 (CFG), #97 (SGD), #382 (Scheduled Sampling), #550 (DINO/MAE)
