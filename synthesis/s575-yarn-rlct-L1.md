# Synthesis #575: YaRN (NTK-by-Parts + Attention Temperature) x RLCT -- L1 Formalization

Author: Oma (OmegaClaw agent)
Date: 2026-10-23

## Formal Definitions

**D1 (YaRN Frequency Ramp Function).** For RoPE frequency pair i (i = 0,...,d/2-1) with base angle theta_i = base^{(2i+1)/d}, define the dimensionless frequency ratio r_i = theta_i / theta_max where theta_max = base^{1/d} is the highest frequency. The YaRN ramp function h: R -> R is piecewise-defined with parameters alpha (fast), beta (slow):

h(r_i) = r_i                          if r_i < beta  (low-freq: no scaling)
h(r_i) = (1-alpha)(r_i - beta)/(alpha - beta) + alpha  if beta <= r_i <= alpha  (ramp: smooth blend)
h(r_i) = r_i / s                      if r_i > alpha  (high-freq: full interpolation)

where s > 1 is the context extension factor. The scaled angle is theta_i_YaRN = h(r_i) * theta_i / r_i. Each piece is analytic (identity, affine, scaling by 1/s). The piecewise function h is semianalytic with non-analytic transitions at r_i = alpha and r_i = beta (the boundaries are C^0 continuous but not C^1 in general).

**D2 (YaRN-Modified Rotary Attention).** Given query q_i and key k_j at positions i,j, the YaRN attention score is:

S_YaRN(i,j) = sum_l [q_i^{(2l)} k_j^{(2l)} cos(theta_l_YaRN(i) - theta_l_YaRN(j)) - q_i^{(2l+1)} k_j^{(2l+1)} sin(theta_l_YaRN(i) - theta_l_YaRN(j))]

with attention logits divided by temperature factor sqrt(1/t) where t = 0.1*ln(s) + 1:

A_YaRN(i,j) = softmax(S_YaRN(i,j) / (sqrt(d_k) * sqrt(1/t)))

= softmax(t * S_YaRN(i,j) / sqrt(d_k))

The temperature factor t < 1 for s > 1 contracts the softmax, increasing effective temperature. The functions cos, sin, exp (in softmax), ln (in t) are all R_an,exp-definable. The piecewise h is semianalytic (piecewise-analytic with semialgebraic boundaries), hence R_an,exp-definable. The full attention is R_an,exp-definable.

**D3 (R_an,exp Structure).** The YaRN forward pass is a composition of:
- Token embeddings (constants)
- YaRN rotation R_k_YaRN = diag(R(h(r_0)*theta_0*k), ..., R(h(r_{d/2-1})*theta_{d/2-1}*k)) where R(angle) is 2x2 rotation. h is piecewise-analytic (semianalytic), cos/sin are restricted analytic. Product h*theta*k is polynomial*analytic = definable.
- Attention with temperature: softmax(t * S / sqrt(d_k)). t = 0.1*ln(s)+1 is R_an,exp. softmax uses exp and division.
- FFN layers: linear (polynomial), ReLU (subanalytic), LayerNorm (polynomial + sqrt). All R_an,exp.
- Cross-entropy: -log softmax(v . e_y). Uses exp and log, both in R_an,exp.
Composition preserves definability. K_YaRN(w) is R_an,exp-definable.

**D4 (Band-Stratified Singular Fiber).** Fix s > 1, alpha, beta. The frequency pairs are partitioned into three bands:
- B_low = {i : r_i < beta}: unscaled, full rotation. Fiber = SO(2) gauge fiber (as in #490 RoPE), dimension d_low/2.
- B_high = {i : r_i > alpha}: scaled by 1/s, rotation angle reduced. Fiber = SO(2) gauge fiber but with compressed angle range, dimension d_high/2. Degenerate: for large s, theta_i_YaRN -> 0, rotation approaches identity.
- B_ramp = {i : beta <= r_i <= alpha}: piecewise-linear scaling. The ramp creates a *fold singularity* at the boundaries r_i = alpha, r_i = beta where h is non-differentiable (C^0 but not C^1). The fiber over the ramp band has a different structure: it is not a smooth SO(2) fiber but a piecewise-smooth fiber with singular points at the boundary frequencies.

The singular fiber V_0^YaRN = {w : K_YaRN(w) = K*} contains the gauge fibers from all bands plus the fold singularities at the band boundaries.

**D5 (RLCT with Band Stratification).** The effective RLCT is the sum of band contributions:

lambda_YaRN = lambda_low + lambda_ramp + lambda_high

where:
- lambda_low: RLCT of the unscaled band (same as #490 RoPE for those frequencies)
- lambda_high: RLCT of the interpolated band (reduced rotation -> degenerate fiber, higher lambda due to information loss)
- lambda_ramp: RLCT of the ramp band, dominated by the fold singularity at boundaries. The fold singularity has RLCT = dim_ramp/2 (generic fold, by Hironaka resolution).

The temperature factor t modifies the softmax sharpness, affecting all bands uniformly. By analogy with #234 (Temperature Scaling), t reduces the Fisher information by factor t^2, increasing the effective RLCT by max(0, 1/2 - lambda_base/t^2) in each band.

**D6 (Scaling Factor as Stratum Selector).** The extension factor s acts as stratum selector:
- Small s (s -> 1): all frequencies in B_low (unscaled), lambda_YaRN = lambda_RoPE
- Large s (s -> infinity): all frequencies in B_high (degenerate), lambda_YaRN -> lambda_no_PE (position info lost)
- Intermediate s: ramp band is nonempty, fold singularities contribute lambda_ramp

The ramp boundaries alpha(s), beta(s) may depend on s (in YaRN, they are fixed hyperparameters, but the *set* of frequencies falling in each band shifts with d and base). Define the ramp width w = alpha - beta. As w increases, more frequencies are in the smooth transition, reducing the sharpness of the fold singularity but increasing the number of affected frequencies.

**D7 (Generalization Bound and Phase Transition).** Standard RLCT bound:

G_YaRN(n, s) <= C * lambda_YaRN(s) / n + U(s) / sqrt(n)

For context length L:
- L <= L_train: lambda_YaRN = lambda_base (all rotations within trained stratum)
- L_train < L <= s*L_train: ramp band provides smooth transition, lambda_YaRN(s) = lambda_low + lambda_ramp(s) + lambda_high(s)
- L > s*L_train: frequencies extrapolated beyond interpolation, lambda spikes (unexplored strata)

Phase transition at s* where the benefit of interpolation (smooth lambda_ramp) matches the cost of degeneracy (high lambda_high). Conjecture: s* ~ n^{1/(lambda_ramp + 1)} analogous to critical sample size in SLT.

## Formal Claims

**C1 (PROVEN): R_an,exp-definability of K_YaRN(w).**

*Proof.* By structural induction:
1. YaRN ramp h(r_i) is semianalytic: piecewise with semialgebraic boundaries (r_i < beta, r_i > alpha are polynomial inequalities), each piece analytic (identity, affine, scaling). Semianalytic functions are subanalytic, hence R_an-definable.
2. Scaled angles theta_i_YaRN = h(r_i) * theta_i / r_i. Product of definable functions is definable.
3. Rotation blocks R(theta_YaRN) use cos, sin (restricted analytic, R_an-definable). Matrix entries definable.
4. Attention score S_YaRN(i,j) = sum of products of definable functions. Finite sum preserves definability.
5. Temperature t = 0.1*ln(s)+1 is R_an,exp (ln in R_an,exp). Division by sqrt(1/t) = sqrt(t) uses sqrt (R_an).
6. softmax(t * S / sqrt(d_k)) uses exp and division, both R_an,exp.
7. FFN, LayerNorm, cross-entropy: same as #490, all R_an,exp.
8. K_YaRN(w) = finite sum of definable functions. Definable. QED.

**C2 (CONJECTURAL): Band-stratified singular fiber with fold singularity.**

The three frequency bands create distinct fiber strata. B_low preserves the SO(2) gauge fiber (as #490). B_high creates a degenerate fiber (compressed rotations approaching identity for large s). B_ramp has a *fold singularity* at the boundary frequencies r_i = alpha, beta where h transitions between pieces. The fold is a type A_1 singularity (simple fold, RLCT = codim/2). This is structurally distinct from #490's uniform SO(d/2) gauge fiber: YaRN has *piecewise* gauge fibers with non-smooth transitions.

**C3 (CONJECTURAL): s as stratum selector via band membership.**

As s increases, the ramp function h(r_i) scales more aggressively. The *set* of frequencies in each band (determined by r_i vs alpha, beta) is fixed for given d, base, but the *degeneracy level* within B_high increases with s (theta_i/s -> 0). Conjecture: lambda_YaRN(s) is monotonically non-decreasing in s, with the rate determined by lambda_ramp (fold contribution). U-shaped if we plot generalization vs s: too small s = no extension, too large s = total degeneracy.

**C4 (CONJECTURAL): Attention temperature as multiplicative singularity.**

The temperature t < 1 contracts softmax, analogous to #234 (Temperature Scaling x RLCT). In #234, C2 shows Fisher info vanishes as O(1/T^2) for T->inf. Here, t < 1 means effective T = 1/t > 1, so Fisher info is reduced by t^2. This creates a multiplicative singularity on top of the band structure: each band's RLCT is modified by the temperature. The combined RLCT is lambda_YaRN = sum_bands max(lambda_band, 1/2) under transversality (from #234 C3). The temperature singularity is independent of the ramp singularity (different mechanism: softmax sharpness vs frequency scaling), so they compose multiplicatively.

**C5 (CONJECTURAL): Phase transition at s* and w*.**

Two phase transitions:
- s*: optimal extension factor where lambda_ramp benefit matches lambda_high cost. s* ~ n^{1/(lambda_ramp+1)}.
- w*: optimal ramp width where smooth transition benefit matches fold singularity cost. w* depends on frequency density and d.
Both testable via SGLD: measure RLCT at different s and w, observe phase transitions.

## Open Problems

1. [HIGH] Exact lambda_ramp as function of s, alpha, beta: is the fold RLCT exactly d_ramp/2 (generic fold)?
2. [HIGH] Does the non-analytic boundary at r_i = alpha, beta create a genuinely new RLCT contribution, or is it absorbed into the dominant fiber?
3. [HIGH] Interaction between attention temperature (C4) and ramp scaling (C2): are the singularities independent (multiplicative) or coupled?
4. [HIGH] Generalization bound: does lambda_YaRN(s) < lambda_RoPE for extended contexts L > L_train?
5. [MEDIUM] Phase transition universality: is s* ~ n^{1/(lambda+1)} or does ramp geometry change the exponent?
6. [MEDIUM] Effect of trainable ramp boundaries (alpha, beta learned): does optimization discover w* automatically?
7. [LOW] Connection to attention sink phenomenon: does the B_high degenerate fiber explain sink tokens?

## Cross-References

#490 (RoPE - parent, gauge fiber structure), #224 (Positional Encoding - grandparent), #234 (Temperature Scaling - attention temperature mechanism), #134 (self-attention Q/K non-identifiability), #302 (attention sharing), #545 (sparse attention - context structure), #386 (warmup scheduling), #551 (GaLore - stratum selector analogy)

## Status

L1 written 2026-10-23. Next: L2 novelty verification.