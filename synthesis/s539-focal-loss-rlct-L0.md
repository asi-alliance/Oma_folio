# Synthesis #539: L0 - Focal Loss × RLCT

## Date
2026-10-23

## Topic
Focal Loss as a singular statistical model classified by RLCT. Focal Loss FL(p_t) = -(1 - p_t)^{γ} log(p_t) introduces a modulation factor (1 - p_t)^γ that reshapes the loss landscape singular structure. The factor vanishes at p_t = 1 (easy examples), creating a family of loss landscapes indexed by γ. At γ=0 reduces to CE (#8); at γ→∞ focuses on hard examples. Novel: probability-space modulation-induced singularity, distinct from PolyLoss #433 (logit-space polynomial) and CE #8. No prior PLT/RLCT bridge exists.

## Claims

### C1 (PROVEN): Focal Loss is definable in R_{an,exp}
FL(p_t) = -(1-p_t)^γ log(p_t) where p_t = exp(z_y) / Σ_j exp(z_j). Log term is CE-definable (#8). (1-p_t)^γ is polynomial in p_t for integer γ, analytic for real γ>0. p_t is analytic in logits z (softmax). Product of analytic and CE-definable is definable (closure). Negation is closure-preserving. Thus FL is definable in R_{an,exp}. By Watanabe theorem, RLCT is well-defined. QED.

### C2 (CONJECTURAL): (1-p_t)^γ modulation creates γ-indexed family of singular strata
The loss L(θ) = -Σ_{(x,y)} [(1-p_t(x,θ))^γ log(p_t(x,θ))] satisfies a family of empirical composite losses powered by θ^γ. Each γ determines distinct singular strata: (i) γ=0: standard CE (#8) with its singular fiber; (ii) γ>0: (0,1) exponential vanishing at p_t=1 creates new singular variety with embedding dimension degenerate by γ-1. Local RLCT λ_{θ_γ} is conjectured against easy-example compositions that compensate the critical easy-to-hard example crossing. Stratum selection: increasing θ_γ points deeper into model space structure as critical example basin grows in relative growth, changing RLCT. Predicted phase transition: periodic and post-critical RLCT behavior as γ varies.

### C3 (CONJECTURAL): γ as continuous stratum selector via easy-example vanishing
At p_t=1 (correctly classified), the modulation (1-p_t)^γ vanishes, suppressing gradient and loss contribution. The vanishing order γ at p_t=1 acts as a continuous deformation parameter on the singular fiber near easy-example strata. Interplay of p_t=1 vanishing and log(p_t) blow-up creates an intermediate singular regime. Curve double hills (in singular context, double double hills mean inflations, compact domains). Activated by the (1-p_t)^γ digital area the gradient matrix modulation which forms the invariant of p_t=1.

### C4 (CONJECTURAL): Generalization bound with modulation-modified RLCT
SLT generalization bound: G(γ) ~ λ_γ log(n)/(2n) + U_γ/√n + B_γ where λ_γ = RLCT of focal loss at parameter γ. Conjecture: λ_γ ≤ λ_CE for γ>0 (modulation reduces effective singularity complexity by suppressing easy-example strata). Tradeoff: higher γ reduces λ but may increase bias B_γ (hard-example overconcentration). Optimal γ* minimizes total bound. Testable via SGLD local proposed characteristic analysis as a function of θ.

### C5 (CONJECTURAL): γ* phase transition at critical modulation depth
Training dynamics exhibit phase transition at critical γ* where RLCT behavior changes: below γ* easy-example strata dominate (high λ), above γ* hard-example strata dominate (different fiber structure). SGLD-detectable via fluctuation ν_γ. Distinct from #433 PolyLoss (discrete degree stratum selector), focal loss γ is continuous.

## Distinctness
- vs #8 CE: FL adds probability-space modulation, CE has no modulation factor
- vs #433 PolyLoss: PL modifies logit-space polynomial, FL modifies probability-space weight
- vs #323 Label Smoothing: LS changes targets (soft labels), FL changes weighting
- vs #169 Dropout: D adds binary noise, FL modifies loss formula
- vs #304 Random Label Smoothing: RS changes marginal probability, FL changes loss multiplicative

## Open Problems
1. Monotonicity of λ_γ in γ (unproven — may be non-monotonic)
2. Singularity type at p_t=1 for non-integer γ (Puiseux expansion?)
3. Interaction with class imbalance ratio (stratum geometry depends on π_class?)
4. Composition with temperature scaling (#234)
5. Architecture dependence of λ_γ
6. γ=0 to γ→∞ limit: smooth deformation or phase transition?
7. SGLD feasibility at extreme γ

## Cross-References (12)
#8 (CE) #16 (ReLU) #100 (softmax) #169 (dropout) #224 (class imbalance) #234 (temperature) #289 (EMA) #323 (label smoothing) #341 (prior focal loss draft) #372 (auxiliary loss) #411 (prior focal selection) #433 (PolyLoss)
