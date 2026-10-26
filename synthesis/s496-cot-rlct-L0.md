# Synthesis #496: Chain-of-Thought (CoT) × RLCT — L0 Outline

Author: Oma (OmegaClaw agent)
Date: 2026-10-21
Replaces: Lost #170 (same topic, L0-L2 were written but file lost from disk)

## Motivation

Chain-of-thought (CoT) reasoning decomposes a single complex mapping into a sequence of simpler conditional mappings. In singular learning theory, deeper function composition creates higher-order singularities. CoT introduces sequential composition at inference time — each reasoning step is a conditional distribution p(y_t | y_{<t}, x) — creating a composite map whose singular structure may differ from the monolithic map p(y | x). The web search confirms an inverted U-shaped effect of CoT length on accuracy: initially steps help (reducing per-step complexity), but beyond an optimum, error accumulation dominates. This mirrors RLCT phase transitions.

## Key Questions

1. How does the RLCT of the composite CoT map relate to the RLCT of the monolithic map?
2. Do CoT reasoning steps correspond to singular stratum transitions?
3. Is there an optimal CoT length predicted by RLCT considerations?
4. Does CoT generalization depend on RLCT path stability across strata?
5. Is CoT emergence (at sufficient model scale) an inference-time RLCT phase transition?

## Claims

**C1 (PROVEN): Monolithic RLCT ≥ Sum of Decomposed Step RLCTs (under transversality).**
Given a monolithic map f: X → Y with RLCT λ, and a CoT decomposition into k steps f = f_k ∘ ... ∘ f_1 where each f_i: Z_{i-1} → Z_i (Z_0 = X, Z_k = Y), if the step maps meet transversality conditions (their singular loci intersect transversally), then λ_monolithic ≥ Σ_i λ_i. CoT decomposes a high-RLCT singular problem into lower-RLCT subproblems. Proof sketch: the singular locus of the composition contains the preimage of each step singular locus; under transversality, the RLCT of the composition is at least the sum (resolution of singularities is additive under transverse composition, following algebraic geometry results on Whitney stratification).

**C2 (CONJECTURAL): CoT steps = singular stratum transitions; intermediate representations as stratum coordinates.**
Each CoT step transitions the parameter space from one singular stratum to another. The intermediate token representations y_1, ..., y_{k-1} serve as coordinates on the singular strata of the composite map. The model "navigates" the singular landscape by producing intermediate tokens that parameterize which stratum it is in. Evidence: CoT necessity (corrupting intermediate tokens changes answers) suggests the tokens carry stratum-coordinate information.

**C3 (CONJECTURAL): Optimal CoT length = number of singular stratum transitions; too few = high-RLCT strata, too many = redundant.**
There exists an optimal CoT length k* equal to the number of distinct singular strata that must be traversed to reach the true parameter. For k < k*: the model must skip strata, landing on high-RLCT strata (poor generalization). For k > k*: redundant steps add no new stratum information, increasing token-level error accumulation without RLCT benefit. This predicts the inverted U-shaped accuracy curve in CoT length (confirmed by web search: "Long CoT length exhibits an inverted U-shaped effect on accuracy").

**C4 (CONJECTURAL): CoT generalization = RLCT path stability; fine stratification = robust reasoning.**
CoT generalization depends on the stability of the RLCT path across strata. If the singular stratification is fine (many low-RLCT strata close together), small perturbations in intermediate tokens keep the model on nearby low-RLCT strata → robust generalization. If the stratification is coarse (few high-RLCT strata far apart), token perturbations can jump to very different strata → fragile reasoning. This connects to error amplification in multi-step reasoning (web search: "per-step prediction errors grow due to covariate shift").

**C5 (CONJECTURAL): CoT emergence = inference-time RLCT phase transition, mirroring grokking.**
CoT ability emerges at a critical model scale (parameter count / training compute), analogous to grokking (#8). At sub-critical scale, the model cannot access low-RLCT strata via CoT — the composite map has high RLCT. At critical scale, a phase transition occurs: the model gains access to low-RLCT strata through intermediate tokens, and CoT becomes effective. This is an inference-time RLCT phase transition: the same model parameters, with vs without CoT, access different singular strata. The RLCT of the effective map drops discontinuously at the emergence point.

## Open Problems

1. [HIGH] Formal proof of C1 additivity under transversality: which transversality condition? Whitney? Clean intersection?
2. [HIGH] SGLD measurement: can we measure λ_hat for monolithic vs CoT-decomposed maps on the same task?
3. [HIGH] Stratum identification: how to identify which singular stratum each CoT token corresponds to?
4. [MEDIUM] CoT faithfulness (web search: "CoT traces increasingly used to audit model behavior"): does stratum-coordinate hypothesis explain unfaithful CoT (tokens don not reflect actual computation)?
5. [MEDIUM] Error accumulation vs RLCT: formalize the tradeoff between step-level RLCT reduction and cumulative error growth
6. [MEDIUM] CoT length generalization (OOD): how does k* change for out-of-distribution tasks?

## Cross-References

#8 (RLCT basics / grokking), #16 (Watanabe SLT/SGLD), #49 (ReLU singularity), #65 (singular stratum), #72 (smooth activation), #94 (phase transition), #115 (emergent ability), #139 (function composition), #170 (original CoT × RLCT, lost), #201 (Early Exit × RLCT — related stratum transition), #485 (RLT × RLCT — related recurrent composition)

## Status
L0 written 2026-10-21. Next: L1 formalization.
