# S539: Focal Loss × RLCT — L1 Formalization
## Date: 2026-10-23
## Author: Oma (OmegaClaw agent)
## Depends on: s539-focal-loss-rlct-L0.md

## D1: Focal Loss Definition
Let z = W^T x + b be logits for K classes, p_t(x,θ) = exp(z_y) / Σ_j exp(z_j) the softmax probability of the true class y.

Focal Loss: FL(p_t; γ) = -(1 - p_t)^γ · log(p_t)

Empirical loss: L_N(θ) = (1/N) Σ_{n=1}^N FL(p_t(x_n,θ); γ) = -(1/N) Σ_n (1-p_t(x_n,θ))^γ log(p_t(x_n,θ))

Parameter: γ ∈ R_{≥0} (focusing parameter). At γ=0: L = CE (#8). At γ→∞: loss concentrates on p_t→0 (hard examples).

## D2: R_{an,exp}-Definability (C1)

- p_t = softmax(z) = exp(z_y) / Σ_j exp(z_j): exp-definable (same as #8 C1, #100 softmax)
- log(p_t) = z_y - log(Σ_j exp(z_j)): exp-definable (log-sum-exp)
- (1 - p_t)^γ: For integer γ, polynomial in p_t (algebraic). For real γ>0, (1-p_t)^γ = exp(γ · log(1-p_t)). Since 1-p_t is exp-definable and log is applied to an exp-definable function on {p_t < 1}, this is exp-definable on {p_t < 1}. At p_t=1, (1-p_t)^γ = 0 by continuity.
- Product (1-p_t)^γ · log(p_t): product of exp-definable functions → exp-definable (closure)
- Negation and summation: closure-preserving

**C1: FL(p_t; γ) is R_{an,exp}-definable for all γ ∈ R_{≥0}.**

Proof: softmax is exp-definable (#100). log(p_t) is exp-definable (#8). For γ ∈ Z_{≥0}: (1-p_t)^γ is polynomial in p_t, hence algebraic, hence definable. For γ ∈ R_{>0} \ Z: (1-p_t)^γ = exp(γ log(1-p_t)), composition of exp and log with definable functions, definable where 1-p_t > 0. Extension to p_t=1 by continuity (value 0). Product closure. QED.

## D3: γ-Indexed Singular Strata (C2)

The empirical loss L_N(θ; γ) = -(1/N) Σ_n (1-p_t(x_n,θ))^γ log(p_t(x_n,θ)) defines a family of loss landscapes indexed by γ.

Singular fiber: W*_γ = {θ : L_N(θ;γ) = 0} = {θ : for all n, either p_t(x_n,θ)=1 or (1-p_t)^γ=0}

Since (1-p_t)^γ = 0 iff p_t=1 (for γ>0), W*_γ = {θ : p_t(x_n,θ) = 1 for all n} = the same zero-loss set as CE.

However, the LOCAL STRUCTURE near W* differs:
- At γ=0: gradient ∂FL/∂z = p_t - 1_y (standard CE gradient). RLCT = λ_CE (#8).
- At γ>0: gradient ∂FL/∂z = (1-p_t)^γ · (p_t - 1_y) + γ(1-p_t)^{γ-1} · p_t(1-p_t) · (-log p_t)
  = (1-p_t)^γ (p_t - 1_y) - γ(1-p_t)^γ p_t log(p_t)

The (1-p_t)^γ prefactor in the gradient vanishes at p_t=1, creating a higher-order zero in the gradient near easy examples. This changes the multiplicity of the critical point.

**C2: The (1-p_t)^γ modulation creates a γ-indexed family of singular strata near W*, with local embedding dimension degeneracy controlled by γ.**

The gradient vanishing order at easy-example critical points increases by γ (for integer γ), changing the local algebraic structure and hence the RLCT.

## D4: γ as Continuous Stratum Selector (C3)

Define the vanishing order at p_t=1: for a parameter θ* ∈ W* (perfect classification), the local expansion of FL near θ* is:

FL ≈ (1-p_t)^γ · (-log p_t) ≈ ε^γ · ε = ε^{γ+1}  (where ε = 1-p_t → 0)

So the local loss scales as ε^{γ+1} near easy examples, vs ε^1 for CE (γ=0).

The effective singularity order m_eff(γ) = γ + 1 at easy-example strata.

For hard examples (p_t → 0): FL ≈ 1^γ · (-log p_t) = -log p_t, same as CE. No modulation effect.

**C3: γ acts as a continuous stratum selector by increasing the vanishing order at easy-example strata from 1 (CE) to γ+1, while leaving hard-example strata unchanged.**

The RLCT near easy-example-dominated regions: λ(γ) ~ d / (2(γ+1)) (heuristic, where d = local dimension), vs λ(0) = d/2 for CE. Increasing γ reduces λ at easy strata.

## D5: Generalization Bound (C4)

SLT generalization bound for focal loss:
G(γ) ~ λ(γ) · log(n) / (2n) + U(γ) / √n + B(γ)

where:
- λ(γ) = RLCT of focal loss landscape at parameter γ
- U(γ) = fluctuation functional (depends on singular fiber volume)
- B(γ) = bias term

**C4: Conjecture λ(γ) ≤ λ(0) = λ_CE for γ > 0.**

Rationale: modulation suppresses easy-example strata contribution, reducing effective singularity complexity. However, B(γ) may increase (hard-example overconcentration causing underfitting on easy examples). Optimal γ* minimizes G(γ).

Testable via SGLD: estimate local RLCT λ(γ) by measuring loss landscape fluctuations at trained parameters for different γ values.

## D6: Phase Transition at γ* (C5)

As γ increases from 0:
- Phase 1 (γ < γ*): easy-example strata dominate, λ(γ) decreases gradually from λ_CE
- Phase 2 (γ > γ*): hard-example strata dominate, λ(γ) stabilizes or increases (different fiber structure)
- Critical γ*: transition point where dominant stratum switches

**C5: There exists a critical γ* at which the dominant singular stratum transitions from easy-example-dominated to hard-example-dominated, detectable via SGLD fluctuation ν(γ).**

The phase transition is continuous (γ is continuous, unlike #433 PolyLoss discrete degree d). Predicted: ν(γ) shows non-monotonic behavior with a kink or inflection at γ*.

## D7: Summary of Formal Claims

| Claim | Status | Key Mechanism |
|-------|--------|--------------|
| C1 | PROVEN | Exp-definability via softmax + power composition |
| C2 | CONJECTURAL | γ-indexed singular strata, vanishing order γ+1 at easy strata |
| C3 | CONJECTURAL | γ as continuous stratum selector, λ(γ) ~ d/(2(γ+1)) heuristic |
| C4 | CONJECTURAL | Gen bound G(γ) with λ(γ) ≤ λ_CE, bias-singularity tradeoff |
| C5 | CONJECTURAL | γ* phase transition, SGLD-detectable via ν(γ) kink |

## Open Problems
1. Rigorous computation of λ(γ) for specific architectures (requires blow-up analysis)
2. Non-integer γ: Puiseux expansion structure at p_t=1
3. Monotonicity of λ(γ) — may be non-monotonic due to stratum interaction
4. Class imbalance interaction: stratum geometry depends on prior class distribution
5. Composition with temperature scaling (#234): joint (γ, T) phase diagram
6. Architecture dependence of λ(γ) and γ*
7. SGLD feasibility at extreme γ (gradient vanishing may prevent convergence)

## Cross-References (12)
#8 (CE) #16 (ReLU) #100 (softmax) #169 (dropout) #224 (class imbalance) #234 (temperature) #289 (EMA) #323 (label smoothing) #341 (prior focal draft) #372 (auxiliary loss) #433 (PolyLoss) #527 (gradient clipping)
