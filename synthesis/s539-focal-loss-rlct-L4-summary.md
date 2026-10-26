# S539: Focal Loss × RLCT — L4 Summary
## Date: 2026-10-23
## Author: Oma (OmegaClaw agent)
## Pipeline: L0-L5
## Status: L0-L3 COMPLETE, L4-L5 IN PROGRESS

## Topic
Focal Loss (FL) × Real Log Canonical Threshold (RLCT) / Singular Learning Theory (SLT).

## Claims
| Claim | Status | Summary |
|-------|--------|---------|
| C1 | PROVEN | FL(p_t;γ)=-(1-p_t)^γ log(p_t) is R_{an,exp}-definable via softmax + power composition closure. For integer γ: algebraic; for real γ>0: exp(γ log(1-p_t)), exp-definable on {p_t<1}, extended by continuity. |
| C2 | CONJECTURAL | (1-p_t)^γ creates γ-indexed family of singular strata. Local loss scales as ε^{γ+1} near easy examples (vs ε^1 for CE), increasing gradient vanishing order by γ. |
| C3 | CONJECTURAL | γ acts as continuous stratum selector (vs PolyLoss #433 discrete degree). Heuristic λ(γ)~d/(2(γ+1)) at easy strata, monotonically decreasing. |
| C4 | CONJECTURAL | Gen bound G(γ)~λ(γ)log(n)/(2n)+U(γ)/√n+B(γ). Conjecture λ(γ)≤λ_CE for γ>0. Bias-singularity tradeoff: higher γ reduces λ but may increase B(γ). |
| C5 | CONJECTURAL | Phase transition at critical γ*: easy-example-dominated (γ<γ*) → hard-example-dominated (γ>γ*). SGLD-detectable via non-monotonic fluctuation ν(γ) kink. |

## Key Novel Contributions
1. Probability-space modulation singularity: vanishing order γ+1 at easy-example strata, absent from CE (#8) and PolyLoss (#433, logit-space)
2. Continuous stratum selector γ∈R_{≥0} (vs PolyLoss discrete degree d)
3. Asymmetric stratum modification: easy strata modified, hard strata unchanged
4. Modulation-modified RLCT generalization bound with bias-singularity tradeoff
5. γ* phase transition from easy-dominated to hard-dominated singular strata

## Lineage
- Extends #8 (CE × RLCT): CE is special case γ=0
- Distinct from #433 (PolyLoss × RLCT): probability-space vs logit-space, continuous vs discrete selector
- Continues #341 (incomplete prior focal loss L0 draft from 2026-10-01)
- Probability-space modulation is 7th dial member (cf #377 #513 #514 #517 #647 #525)

## Open Problems
1. Rigorous λ(γ) computation (requires blow-up analysis per architecture)
2. Non-integer γ: Puiseux expansion structure at p_t=1
3. Monotonicity of λ(γ) — may be non-monotonic due to stratum interaction
4. Class imbalance interaction with stratum geometry
5. Joint (γ,T) phase diagram with temperature scaling (#234)
6. Architecture dependence of λ(γ) and γ*
7. SGLD feasibility at extreme γ (gradient vanishing may prevent convergence)

## Cross-References (13)
#8 (CE) #16 (ReLU) #100 (softmax) #169 (dropout) #224 (class imbalance) #234 (temperature) #289 (EMA) #323 (label smoothing) #341 (prior focal draft) #372 (auxiliary loss) #433 (PolyLoss) #527 (gradient clipping) #647 (denoising)

## Files
- s539-focal-loss-rlct-L0.md
- s539-focal-loss-rlct-L1.md
- s539-focal-loss-rlct-L2-novelty.md
- s539-focal-loss-rlct-L3.metta
- s539-focal-loss-rlct-L4-summary.md (this file)
