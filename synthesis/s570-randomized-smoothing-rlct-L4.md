# Synthesis #570: Randomized Smoothing × RLCT — L4 Summary
**Date:** 2026-10-23
**Status:** L4 Summary Complete

## Five Claims

**C1 (PROVEN, stv 1.0/0.95):** The randomized smoothing loss is R_{an,exp}-definable. The original loss h_θ(x,y) is analytic in θ. The Gaussian density φ_σ(ε) = (2πσ²)^(-d/2) exp(-||ε||²/(2σ²)) is in R_{an,exp}. The smoothed loss L_σ(θ) = ∫ h_θ(x+ε,y) φ_σ(ε) dε is definable by Wilkie's theorem closure of R_{an,exp} under definable integration over semi-algebraic domains. The empirical smoothed loss (1/n)Σ_i L_σ(θ; x_i, y_i) inherits definability by finite sum closure.

**C2 (CONJECTURAL, stv 0.8/0.85):** Gaussian convolution via the heat semigroup e^{(σ²/2)Δ_x} acts as an input-space desingularization operator on the loss landscape. The smoothed singular fiber W_σ = {θ : L_σ(θ) = L_σ*} has RLCT λ(σ) ≤ λ(0) = λ_orig. The heat semigroup smooths singularities in the input directions, reducing the multiplicity of critical points. This is the FIRST RLCT synthesis to apply desingularization in INPUT space (x → x+ε), distinct from #525 (parameter-space Entropy-SGD), #377 (parameter-gradient noise), and #224 (target-space label smoothing).

**C3 (CONJECTURAL, stv 0.7/0.8):** σ acts as a continuous stratum selector with a cascade structure. As σ increases from 0, singular strata S_i of W_0 are resolved sequentially at critical scales σ*_i ~ c_i · ℓ_i, where ℓ_i is the characteristic scale of stratum S_i. Below σ*_i, stratum S_i persists in W_σ; above σ*_i, it is smoothed away. The certification radius R(σ, p*) = σ·Φ⁻¹(p*) connects robustness guarantees to RLCT stratum selection — larger σ gives certified robustness but desingularizes more strata, reducing λ but increasing bias.

**C4 (CONJECTURAL, stv 0.7/0.8):** Generalization bound G_RS ≤ C·λ(σ)·log(n)/(2n) + U(σ)/√n, where λ(σ) is non-increasing (smoothing reduces complexity) and U(σ) is non-decreasing (smoothing introduces bias). At optimal σ*: complexity reduction balances bias increase. Distinct from #569 gradient penalty: GP constrains function-space complexity via Lipschitz, RS smooths input-space geometry via heat kernel. Different desingularization mechanism: algebraic constraint vs analytic convolution.

**C5 (CONJECTURAL, stv 0.6/0.75):** Phase transition at σ* ~ k·√(λ_orig·d/n). Below σ*: smoothing inactive, λ̂ ≈ λ_orig. Above σ*: smoothing active, λ̂ decreases stepwise as each stratum is resolved. SGLD observable: LLC vs σ shows stepwise decrease with kinks at σ*_i. The heat semigroup resolves strata in order of decreasing scale ℓ_i, creating a staircase LLC profile. Predicted scaling σ* ~ √(λ_orig·d/n) analogous to SAM ρ* ~ 1/√n (#559) and GP λ_gp* ~ k/√n (#569).

## Key Novelty
1. **Input-space heat semigroup desingularization** — first RLCT synthesis using input-space Gaussian convolution as desingularization operator
2. **Certified robustness ↔ RLCT bridge** — certification radius R(σ) connects robustness theory to singular stratum selection
3. **Cascade structure** — sequential stratum resolution at σ*_i ~ c_i·ℓ_i, distinct from single phase transition in most regularizers
4. **Input-space vs parameter-space vs target-space** — completes the three-axis taxonomy of smoothing-based regularization in RLCT

## Cross-References (10)
- #377: gradient noise injection (parameter-space stochastic)
- #525: Entropy-SGD (parameter-space deterministic smoothing)
- #507: noisy student (semi-supervised input noise)
- #169: dropout (stochastic subnetwork selection)
- #224: label smoothing (target-space smoothing)
- #569: gradient penalty (input-gradient Lipschitz constraint)
- #127: adversarial training (worst-case input perturbation)
- #433: weight decay (parameter norm regularization)
- #545: sparse attention (structural sparsity)
- #113: differential privacy (gradient-space noise)

## Next Steps
- L5: Catalog update
- Potential follow-up: composition of input + parameter smoothing (#570 × #525), non-Gaussian kernels (uniform/L∞) desingularization geometry
