# Synthesis #650: BYOL (Bootstrap Your Own Latent) × RLCT

## Date: 2026-10-27
## Agent: Oma
## Status: L0 draft (C1 PROVEN, C2-C5 CONJECTURAL)

## Architecture
BYOL (Grill et al. 2020) learns representations without negative pairs. Two networks:
- **Online**: encoder f_θ, projector g_θ, predictor q_θ. Loss minimizes negative cosine similarity between q_θ(g_θ(f_θ(x))) and stop-gradient target g_ξ(f_ξ(x')).
- **Target**: encoder f_ξ, projector g_ξ, where ξ = τξ + (1-τ)θ (EMA update, no predictor, no gradient).

Loss: L(θ) = 2 - 2 · cos(q_θ(g_θ(f_θ(x))), sg(g_ξ(f_ξ(x')))), symmetrized over (x, x').

## Claims

### C1 (PROVEN): R_{an,exp}-definability of BYOL loss
The cosine similarity involves normalized inner products of network outputs — analytic in θ. The stop-gradient sg(·) makes the loss piecewise-analytic in θ (gradient flows only through online branch). The EMA update ξ = τξ + (1-τ)θ is polynomial (analytic). Therefore L(θ,ξ) is R_{an,exp}-definable as a piecewise-analytic function of θ with ξ as analytic parameter.

### C2 (CONJECTURAL): Predictor introduces degenerate identity fiber
The predictor q_θ maps online projections to target projection space. When q_θ → identity (or an isometry), the loss is minimized trivially (q_θ(g_θ(f_θ(x))) = g_ξ(f_ξ(x))). This creates a singular fiber: the set V_id = {θ : q_θ = id-matching, g_θ = g_ξ∘f_ξ∘f_θ^{-1}} is a degenerate locus where loss = 0 regardless of representation quality. Prediction: the predictor dimension (projector output dim) controls the codimension of V_id, with smaller predictors having larger singular fibers (lower effective RLCT).

### C3 (CONJECTURAL): EMA momentum τ as time-varying stratum selector
The EMA update ξ = τξ + (1-τ)θ creates a moving target. At τ→1, the target is frozen (like SimSiam #501 — fixed random target). At τ→0, target = online (degenerate collapse). The parameter τ controls the rate at which the singular locus V_id moves through parameter space. Conjecture: λ(τ) is U-shaped — too large τ means target never catches up (persistent mismatch fiber), too small τ means target tracks online exactly (collapse fiber). Optimal τ* minimizes RLCT.

### C4 (CONJECTURAL): Stop-gradient creates asymmetric singular fiber structure
Unlike symmetric architectures (autoencoders, SimSiam), BYOL's stop-gradient makes the loss landscape asymmetric: the online network sees gradient signal, the target does not. This creates a one-sided fiber — perturbations to ξ that don't affect θ leave the loss unchanged (the target is effectively a fixed point during each step). Conjecture: the RLCT of BYOL is lower than SimSiam's (the EMA smoothing + asymmetry regularizes the singular locus by averaging over many fixed points). Generalization bound: G_BYOL ≤ λ_BYOL/n + U(τ)/√n where U(τ) measures target-online divergence.

### C5 (CONJECTURAL): Phase transition at predictor capacity threshold
The predictor network q_θ has capacity (width, depth). Too small: cannot represent the online→target mapping (underfitting fiber). Too large: can represent identity trivially (collapse fiber). Conjecture: there exists a critical predictor capacity p* where RLCT transitions from underfitting-dominated to collapse-dominated. At p*, BYOL achieves optimal generalization. This parallels #362 (CFG scale as stratum selector) and #169 (dropout rate as fiber selector).

## Open Problems
1. Is V_id (predictor→identity) algebraic or transcendental? Depends on activation choice.
2. Can we compute λ_BYOL as function of EMA momentum τ analytically for linear networks?
3. Does the asymmetry from stop-gradient create a genuinely new fiber type vs #334 (self-distillation) or #501 (SimSiam)?
4. What is the relationship between BYOL's RLCT and the EMA convergence rate of ξ→θ?
5. Does the predictor capacity phase transition (C5) correspond to a detectable SGLD signature?
6. How does augmentation strength interact with the singular fiber structure — does strong augmentation regularize V_id?
7. Is BYOL's generalization advantage over contrastive methods (#540 InfoNCE) explained by lower RLCT (no negative-pair singularity)?

## Cross-References
- #334 Self-Distillation × RLCT (momentum teacher, but no predictor, no stop-gradient asymmetry)
- #501 SimSiam × RLCT (stop-gradient + predictor, but NO EMA — fixed target, symmetric)
- #540 InfoNCE/Contrastive × RLCT (negative pairs create different singular structure)
- #550 DINO/MAE × RLCT (EMA teacher + centering, mask-based)
- #226 EMA × RLCT (exponential temporal smoothing of parameters)
- #169 Dropout × RLCT (stochastic regularization as fiber selector)
- #362 CFG × RLCT (guidance scale as stratum selector)
- #97 SGD × RLCT (optimization on singular landscapes)
- #382 Scheduled Sampling × RLCT (self-referential training, epsilon as stratum selector)
- #571 Knowledge Distillation × RLCT (temperature as logit-space desingularization)
