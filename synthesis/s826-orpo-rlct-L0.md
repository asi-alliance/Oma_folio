# Synthesis #826 L0: ORPO (Odds Ratio Preference Optimization) × RLCT
## Date: 2026-10-29
## Pipeline: L0 <- L1 L2 L3 L4 L5

## Background
ORPO (Hong et al., 2024) is a monolithic, reference-free preference alignment method. It combines SFT loss and an odds-ratio preference penalty in a single training pass — no separate alignment stage, no frozen reference model.

## ORPO Loss Function
L_ORPO = L_SFT + λ · L_OR

where:
- L_SFT = -log P(y_w | x)  (standard NLL on preferred response)
- L_OR = -log σ(log(odds(y_w | x) / odds(y_l | x)))
- odds(y | x) = P(y | x) / (1 - P(y | x))
- λ > 0 is the odds-ratio penalty weight

Expanded log-odds-ratio:
log(odds(y_w) / odds(y_l)) = [log P(y_w) - log(1 - P(y_w))] - [log P(y_l) - log(1 - P(y_l))]
                           = [log P(y_w) - log P(y_l)] - [log(1 - P(y_w)) - log(1 - P(y_l))]

## Key Distinctions from Prior Preference Optimization Syntheses

### vs DPO (#599, #567, #160, #532)
- DPO uses log-ratio with reference model: log π(y_w)/π_ref(y_w) - log π(y_l)/π_ref(y_l)
- ORPO uses odds ratio WITHOUT reference: log(odds(y_w)/odds(y_l))
- DPO has gauge degeneracy from reference model quotient; ORPO has NO gauge
- DPO loss is purely preference; ORPO is MONOLITHIC (SFT + preference coupled)

### vs KTO (#667)
- KTO is single-sample (Kahneman-Tversky utility), not pairwise
- ORPO is pairwise (winner vs loser)
- KTO has utility curvature; ORPO has odds-ratio pole structure

### vs IPO (#815)
- IPO uses polynomial L2 loss (no sigmoid, no odds)
- ORPO uses sigmoid + odds ratio (rational + analytic)
- IPO RLCT depends only on architecture; ORPO RLCT depends on loss geometry via odds pole

### vs SimPO (#668)
- SimPO uses length-normalized reward, no reference, sigmoid coupling
- ORPO uses odds ratio (pole at p=1), no length normalization
- SimPO boundary is γ-shifted; ORPO boundary is at odds-ratio = 1 (i.e., P(y_w) = P(y_l) in odds space)

## RLCT Bridge: Claims

### C1 (PROVEN): R_an,exp Definability
The ORPO loss is definable over R_an,exp:
- P(y|x) = softmax of logits = ratio of exponentials (in R_an,exp)
- odds(y|x) = P/(1-P) = ratio of analytic functions (rational, in R_an)
- log(odds) = composition of log with rational (in R_an,exp)
- σ(z) = 1/(1+exp(-z)) (in R_an,exp)
- L_ORPO = -log P(y_w) + λ·(-log σ(log OR)) — all components in R_an,exp ✓

### C2 (CONJECTURAL): Odds-Ratio Pole Singularity
The odds function p/(1-p) has a POLE at p=1 (probability saturation). When P(y_w|x) → 1 or P(y_l|x) → 1, the odds ratio diverges. This creates a singular fiber V_OR where:
- The zero-loss condition L_OR = 0 requires σ(log OR) → 1, i.e., odds(y_w) >> odds(y_l)
- Near p=1, the loss landscape has a pole-type singularity (1/(1-p) blowup)
- This is DISTINCT from DPO (log-ratio, no poles) and IPO (polynomial, no poles)
- The pole singularity has RLCT structure different from zero-type or cusp-type

### C3 (CONJECTURAL): Monolithic Intersection Fiber
ORPO's zero-loss variety is the INTERSECTION:
V_ORPO = V_SFT ∩ V_OR
where V_SFT = {θ : P(y_w|x) = 1} (SFT perfect fit) and V_OR = {θ : odds(y_w)/odds(y_l) → ∞}
The intersection structure means:
- At λ=0: V_ORPO = V_SFT (pure SFT, standard RLCT)
- At λ→∞: V_ORPO → V_OR (pure preference, pole-dominated)
- The intersection creates a coupled singular geometry where SFT and preference constraints compete
- This is the FIRST monolithic loss in the synthesis catalog — intersection of task-learning and alignment fibers

### C4 (CONJECTURAL): λ as Stratum Selector
The coupling weight λ acts as a continuous stratum selector:
- Small λ: SFT fiber dominates, RLCT ≈ λ_SFT (standard NLL)
- Large λ: odds-ratio pole dominates, RLCT → λ_OR (pole singularity)
- Critical λ* marks phase transition between SFT-dominated and preference-dominated regimes
- The transition may be non-smooth due to the pole structure
- Distinct from DPO's β (which controls boundary sharpness of a smooth sigmoid, no pole)

### C5 (CONJECTURAL): Generalization Bound
G_ORPO ~ λ_eff(λ) / (2n) + U(λ) / √n
where λ_eff(λ) interpolates between λ_SFT (at λ=0) and λ_OR (at λ→∞).
The pole at p=1 may cause λ_OR to be LARGER than expected (pole singularities can have higher RLCT), suggesting ORPO has WORSE generalization at high λ than DPO — consistent with ORPO's need for moderate λ values.

## Novelty Assessment
- Zero catalog hits for ORPO/odds-ratio/monolithic (confirmed via grep)
- Zero websearch hits for ORPO × SLT/RLCT
- Key novel contributions:
  1. FIRST monolithic loss synthesis (SFT+preference intersection fiber)
  2. FIRST pole-type singularity in preference optimization (odds p/(1-p) divergence at p=1)
  3. No gauge degeneracy (reference-free, unlike DPO)
  4. λ as stratum selector with potential non-smooth phase transition

## Open Problems (7)
1. RLCT of pole singularity vs cusp vs zero (classification of odds-ratio singularity type)
2. Intersection fiber V_SFT ∩ V_OR: is the RLCT additive (λ_SFT + λ_OR) or sub-additive?
3. Optimal λ* for generalization: theoretical prediction vs empirical tuning
4. Pole regularization: does p=1 saturation act as implicit regularizer or singular attractor?
5. Comparison of ORPO RLCT vs DPO RLCT at matched alignment quality
6. Effect of vocabulary size on odds-ratio pole structure (discrete vs continuous limit)
7. Connection to #825 C5: does λ_total = λ_SFT + λ_OR hold for monolithic losses?

## Cross-References
#160, #532, #567, #599 (DPO × RLCT), #667 (KTO × RLCT), #815 (IPO × RLCT), #668 (SimPO × RLCT), #414, #579 (GRPO × RLCT), #468 (PPO × RLCT), #185 (RLHF × RLCT), #825 (RRR-LoRA RLCT)

## Next Steps
L1: Formal definitions D1-D7, MeTTa-ready claim encoding.