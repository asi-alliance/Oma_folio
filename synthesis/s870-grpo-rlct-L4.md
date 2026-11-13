#870: GRPO × RLCT — L4 Summary

## One-Line
GRPO's group-relative advantage normalization creates a novel reward-tie singular locus (σ_G→0) and uses group size G as a discrete stratum selector on the singular fiber, while critic elimination reduces total RLCT below PPO.

## Key Results
- C1 (PROVEN): L_GRPO is R_{an,exp}-definable — clip, min/max, ratio, KL all definable; RLCT well-defined on {σ_G > 0}
- C2 (CONJECTURAL): Group size G acts as discrete stratum selector; λ_GRPO(G) ≈ λ_π · G/(G+G₀)
- C3 (CONJECTURAL): Critic-free design reduces RLCT: λ_GRPO ≈ λ_π < λ_π + λ_V = λ_PPO
- C4 (CONJECTURAL): KL coefficient β acts as continuous stratum selector via tube T_β intersecting singular fiber
- C5 (CONJECTURAL): Critical G* phase transition for reward collapse below threshold

## Novelty
Zero prior work connecting GRPO with singular learning theory. Key new concepts:
1. σ_G→0 reward-tie locus as algebraic variety in parameter space (genuine singular fiber component)
2. Group size G as discrete stratum selector (analogous to LoRA rank in #558)
3. Critic removal as singular fiber elimination (λ_V contribution removed)
4. KL β as continuous stratum selector (tube-fiber intersection)
5. G* phase transition for reward collapse

## Confidence
C1: high (definability follows from standard results). C2-C5: low-moderate (conjectural scaling laws, transversality unproven, empirical LLC estimation needed).

## Extends
#414 (GRPO × RLCT earlier draft — this synthesis refines with σ_G→0 locus, G* phase transition, and full L1 formalization)

## Cross-References
#8 (RLCT basics), #100 (Transformer), #173 (SAM), #213 (LR scheduling), #223 (LoRA), #394 (SWA), #496 (CoT), #527 (gradient clipping), #558 (LoRA × RLCT), #579 (GRPO L0)

## Pipeline Status
- L0-L3: COMPLETE
- L4: COMPLETE (this file)
- L5: PENDING