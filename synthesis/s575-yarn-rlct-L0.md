#575 - YaRN (NTK-by-Parts + Attention Temperature) x RLCT

Selected: 2026-10-23

## Architecture Summary

YaRN extends RoPE to longer contexts by modifying the frequency spectrum piecewise and applying attention temperature scaling. Each RoPE frequency pair i has base angle theta_i = a^(2i+1)/d. YaRN scales theta_i by a piecewise function h(theta_i) with three bands:
- Low-freq (theta_i < theta_low): h = theta_i (no scaling, full resolution)
- Ramp (theta_low <= theta_i <= theta_high): smooth interpolation between identity and 1/s
- High-freq (theta_i > theta_high): h = theta_i / s (full interpolation, degenerate to constant)
Attention logits are additionally divided by sqrt(1/r) where r is the scaling factor.

## Key Insight

The piecewise ramp boundaries are non-analytic transitions. They split the frequency spectrum into strata with different RLCT scaling: high-dim interpolated (lower resolution, degenerate fiber) vs low-dim unscaled (rich detail, higher fiber dim). The ramp stratum is a differentiated singular fiber governed by s and boundary positions.

## Claims

C1 (PROVEN): YaRN modified rotation map h(theta_i) is definable in R_an,exp. h is piecewise with finitely many pieces, each piece analytic (identity, scaling by s, rational interpolation). The attention temperature sqrt(1/r) is a composition of rational functions. Softmax via exp/sum-exp composition preserves definability. The full YaRN forward pass satisfies Watanabe conditions for SLT applicability.

C2 (CONJECTURAL): The ramp boundaries create distinct singular fibers separated by frequency band. Fix s > 1 and ramp points theta_low, theta_high. Three band strata: S_low (full rotations, degenerate fiber), S_high (interpolated to constant identity, degenerate to fixed class), S_ramp (continuous radial fiber with singular position at boundaries where map is non-differentiable). The ramp stratum is governed by a singular fiber with RLCT lambda_ramp depending on s and boundary positions.

C3 (CONJECTURAL): The scaling factor s acts as stratum selector via control of ramp boundary positions theta_low(s), theta_high(s). As s increases, more frequencies enter interpolated region. Effective RLCT = lambda_low + lambda_ramp(s) + lambda_high, with lambda_ramp the dominant factor. Phase transition at critical ramp width w* = theta_high - theta_low.

C4 (CONJECTURAL): The attention temperature factor sqrt(1/r) adds a multiplicative singularity to the loss landscape, contracting the softmax distribution as approximate inverse temperature on attention fiber. This creates a fiber distinct from RoPE #490 because temperature modifies softmax singular structure directly.

C5 (CONJECTURAL): Critical ramp width w* determines optimal context extension. w* ~ n^{1/(lambda_ramp+1)} analogous to critical sample size. Testable via SGLD: measure RLCT descent rate as s crosses ramp boundaries.

## Cross-References
#490 (RoPE), #224 (ALiBi), #134 (positional encoding), #302 (attention), #545 (context extension), #386 (warmup scheduling), #234 (temperature scaling)

## Open Problems
1. Exact lambda_ramp as function of s, theta_low, theta_high
2. Does non-analytic boundary create genuinely new RLCT contribution?
3. Interaction between attention temperature and ramp scaling: independent or coupled?
4. Generalization bound: does lambda_YaRN < lambda_RoPE for extended contexts?
5. Phase transition universality: is w* ~ n^{1/(lambda+1)} or does ramp geometry change exponent?
6. Effect of trainable ramp boundaries: does optimization discover w* automatically?
7. Connection to attention sink phenomenon: does low-freq degenerate fiber explain sink tokens?