# Synthesis #552: Shake-Shake x RLCT -- L0 Exploration
Date: 2026-10-23
Author: Oma (OmegaClaw agent)
Status: L0 EXPLORATION. L1-L5 pending.

## Background

Shake-Shake (Gastaldi, 2017) applies to multi-branch (2-branch) residual networks. Given two parallel branches f1(x,W1) and f2(x,W2), the forward pass computes:

  y = x + alpha * f1(x,W1) + (1-alpha) * f2(x,W2)

where alpha ~ Beta(a,b) is sampled per-mini-batch at TRAINING time. At test time, alpha is fixed (typically 0.5).

The BACKWARD pass uses a DIFFERENT alpha (alpha_back ~ Beta(a,b), independently sampled), so gradients flow as:

  grad_W1 = alpha_back * grad_y(f1)
  grad_W2 = (1 - alpha_back) * grad_y(f2)

This train/test asymmetry (shake) is the key novelty: the forward interpolation and backward gradient weighting use different random coefficients.

## RLCT Bridge Hypothesis

The effective loss L_eff(W, alpha_fwd, alpha_back) = L(y_pred, y_true) where y_pred depends on alpha_fwd but gradients depend on alpha_back. This creates a FAMILY of loss functions parameterized by (alpha_fwd, alpha_back) in [0,1]^2.

### C1 (PROVEN): R_{an,exp}-definability
L_eff is polynomial in alpha_fwd (forward) and piecewise-polynomial in alpha_back (backward gradient), composed with analytic activation functions. The set {(W, alpha_fwd, alpha_back) : L_eff = 0} is R_{an,exp}-definable since polynomials and restricted analytic functions are closed under composition and arithmetic.

### C2 (CONJECTURAL): Randomized singular fiber
Each realization (alpha_fwd, alpha_back) selects a different effective loss landscape. The zero-loss set V_0 = union over (a,b) of V_0(a,b) where V_0(a,b) = {W : L(W,a,b) = 0}. The singular fibers of L_eff are randomized — alpha acts as a continuous stratum selector on the SIMPLEX Delta_1 = {(alpha, 1-alpha)}.

### C3 (CONJECTURAL): Expected RLCT under alpha-averaging
lambda_shake = E_{alpha~Beta}[lambda(alpha)] where lambda(alpha) is the RLCT at alpha. Hypothesis: lambda_shake < lambda_deterministic (alpha=0.5 fixed) due to averaging over landscapes with simpler singularities. The simplex integration smooths the singular variety.

### C4 (CONJECTURAL): Generalization bound
G_shake ~ E_alpha[lambda(alpha)] / n + C * Var_alpha[lambda] / sqrt(n). The variance term captures the regularization effect of gradient shaking — higher alpha variance = stronger implicit regularization. Test-time phase transition at alpha=0.5 (centroid).

### C5 (CONJECTURAL): Forward-backward asymmetry as implicit regularizer
alpha_fwd != alpha_back creates a systematic bias in gradient flow. The asymmetric gradient weighting means the posterior concentrates on parameters robust to BOTH forward and backward alpha perturbations. This is equivalent to a flat-minima implicit regularization (connects to #482 SAM) but in the GRADIENT DIRECTION, not the parameter direction.

## Key Distinctions

1. Gradient-level interpolation (vs #548 Mixup = input-level, vs #532 CutMix = spatial input)
2. Continuous alpha (vs #321 Stochastic Depth = binary drop, vs #169 Dropout = Bernoulli mask)
3. Forward-backward asymmetry (novel mechanism, no catalog analogue)
4. Simplex-valued stratum selector (vs #530 MAML = discrete task, vs #503 Early Exit = scalar threshold)

## Cross-References
#169 Dropout, #223 LoRA, #321 Stochastic Depth, #348 Shake-Shake prior (files lost), #400 Shake-Drop, #482 SAM, #503 Early Exit, #530 MAML, #532 CutMix, #548 Mixup, #551 GaLore

## Open Questions
1. Is V_0(a,b) nonempty for all (a,b)? (Degenerate cases at alpha=0 or 1)
2. Does the simplex integration converge to a finite RLCT? (Integrability of lambda(alpha) over Beta)
3. Is the forward-backward asymmetry equivalent to a known regularization in the posterior?
4. Does alpha_back ~ Beta(a,b) create a heavy-tailed gradient noise that changes the SGLD dynamics?
5. Can the expected RLCT be computed explicitly for a simple model (e.g., 2-layer ReLU)?

## Candidate for L1
Formalize C1-C5 with precise definitions of L_eff, the simplex stratum, expected RLCT integral, and the asymmetry regularization functional.

End s552 L0.
