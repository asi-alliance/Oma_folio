# Synthesis #505: Weight Normalization × RLCT — L1 Formalization
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-22

## Formal Definitions

D1 (WeightNorm Map): For weight w in R^d, reparameterize as w = g * v / ||v||_2 where g in R+, v in R^d. The map phi: (g,v) -> g*v/||v|| is definable in R_an (polynomial multiplication, algebraic norm, rational division).

D2 (Training Landscape): L(g,v) = (1/n) sum l(y_i, f(g*v/||v||; x_i)). KL divergence K(g,v) = E_q[log(q/p_{g,v})]. Gradient splits: dL/dg = <dL/dw, v/||v||>, dL/dv = g*(I - vv^T/||v||^2)/||v|| * dL/dw. Direction gradient has 1/||v|| factor.

D3 (True Parameter Set): W_0 = {(g,v) : K(g,v) = 0}. Non-identifiability: (g,v) ~ (g, cv) for c > 0 (gauge symmetry). Quotient space: W_0 / ~ = R+ x S^{d-1} / R+ = S^{d-1} (direction only matters up to scale).

D4 (KL Neighborhood): K(w) ~ (1/2)||w - w_0||^2 for regular points. Near ||v||=0: K ~ (g^2/2||v||^2)||v_hat - v_hat_0||^2 + (g-g_0)^2/2 (rational blowup in direction component). The 1/||v||^2 term creates non-quadratic local geometry.

D5 (Fisher Information): I(g,v) block structure: I_gg = ||v/||v||||^2 = 1 (scale), I_vv = g^2/||v||^2 * (I - v_hat v_hat^T) (direction, rank d-1), I_gv = cross terms. Singular at ||v||=0: I_vv ~ 1/||v||^2 -> infinity (Fisher singularity).

D6 (RLCT): lambda_WeightNorm = RLCT at singular stratum S_0 = {v : ||v||=0}. Conjecture: lambda ~ (d-1)/2 from compact direction fiber S^{d-1} of dimension d-1. Contrast: lambda_WeightNorm vs lambda_unconstrained (no normalization).

D7 (Singular Fiber): Fiber = S^{d-1} (compact, dimension d-1) x R_+ (scale). Collapse at ||v||=0 identifies all directions. Epsilon regularization: w = g*v/(||v||+eps) smooths singularity, eps as stratum selector analogous to #466 RMSNorm.

## Claims

C1 (PROVEN): phi(g,v) = g*v/||v|| is definable in R_an. Multiplication and ||v|| = sqrt(sum v_i^2) are algebraic. Division by ||v|| is rational. R_an is closed under algebraic and rational operations. QED.

C2 (CONJECTURAL): Singular fiber at ||v||=0 is pole-type with codimension d. The direction fiber S^{d-1} (compact, dimension d-1) collapses to a point. RLCT lambda ~ (d-1)/2 from the compact fiber dimension. Distinct from #466 RMSNorm (activation norm, fiber R^d/R_+) and #221 BatchNorm (batch statistics, fiber R^d/R_+ x R). WeightNorm fiber is compact (S^{d-1}), RMSNorm/BN fibers are non-compact quotients.

C3 (CONJECTURAL): Epsilon in w = g*v/(||v||+eps) acts as stratum selector. Small eps -> near-singular stratum (high RLCT). Large eps -> regularized stratum (low RLCT, direction blurred). Provides smooth family S_eps of strata. U-shaped optimal eps* where lambda(eps) has minimum. Analogy to #466 RMSNorm, #433 PolyLoss, #434 MoE.

C4 (CONJECTURAL): Generalization bound G_WeightNorm ~ lambda_WN * log(n)/(2n) + U_WN/sqrt(n) where U_WN encodes epsilon-regularization boundary. Conjecture: G_WN <= G_unconstrained due to compact fiber constraint (S^{d-1} bounded, regularizes direction). Scale g provides explicit magnitude control absent in unconstrained.

C5 (CONJECTURAL): Phase transition at eps* where singular stratum (eps->0) crosses to regularized regime (eps large). SGLD residual estimator should show LLC kink at eps*. Testable: train WeightNorm models with varying eps, measure SGLD LLC, expect non-monotonic behavior with kink at eps*.

## Open Problems

1. RLCT computation for compact fiber S^{d-1} (vs non-compact quotient fibers in #221/#466)
2. Interaction of WeightNorm with BatchNorm (common in practice, double normalization)
3. Scale parameter g dynamics: does g act as adaptive learning rate?
4. Multi-layer WeightNorm: cumulative fiber structure across depth
5. RLCT comparison: lambda_WN vs lambda_LN (#264) vs lambda_BN (#221) vs lambda_RMS (#466)
6. Epsilon regularization: exact eps* formula and width dependence
7. WeightNorm + data-dependent initialization: how initialization on first batch affects singular stratum

## Cross-references
#466 RMSNorm, #221 BatchNorm, #222 spectral norm, #264 LayerNorm, #363 adaLN, #369 #402 GroupNorm, #493 Sandwich Norm, #58 ReLU, #350 SiLU, #424 Fixup, #421 LayerScale
