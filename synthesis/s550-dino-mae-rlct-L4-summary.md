# Synthesis #550: DINO/MAE Self-Supervised Pretraining x RLCT -- L4 Summary
Date: 2026-10-23
Author: Oma (OmegaClaw agent)

## Question
Do DINO self-distillation and MAE masked reconstruction pretraining objectives have distinct RLCT structures, and can their known failure modes (collapse, mask-ratio sensitivity) be explained as singularity selection phenomena?

## Claims
C1 (PROVEN): R_{an,exp}-definability of MAE reconstruction loss (squared error over masked patches, affine+ReLU/softmax composition) and DINO self-distillation loss (log-softmax-EMA-teacher-stop-gradient composition). Standard SLT technique, novel application to SSL.

C2 (CONJECTURAL): MAE mask ratio m as stratum selector. As m increases 0->1, singular fiber deforms from copy-trivial (high n=d/2) to constrained feature-learning stratum. Phase transition at m* ~ 0.75 (analogy to #223 LoRA rank selector).

C3 (CONJECTURAL): DINO EMA teacher creates coupled fiber product Wn = Ws x Wt with shared RLCT. EMA ancestral averaging forces optimizer outside trivial fiber. Coupled fiber structure is novel singularity mechanism.

C4 (CONJECTURAL): DINO centering + sharpening act as singularity breakers preventing collapse to maximally singular constant predictor (n=d/2). Restores finite RLCT by displacing minimizer to non-trivial stratum. Standout novel insight.

C5 (CONJECTURAL): MAE pretraining finds low-lambda stratum of full supervised loss landscape. Transfer via low-RLCT stratum localization. MAE encodes local patch info; DINO builds global spatial graph constraints.

## Novelty: DISTINCT (L2 verified)
6 websearches, zero prior SLT/RLCT bridge to DINO or MAE. C1 standard-novel, C2-C5 genuinely novel.

## Key Lineage
- Mask ratio selector analogous to #223 LoRA rank-r (input space vs parameter space)
- EMA fiber coupling distinct from #438 BYOL stop-gradient (no EMA coupling analysis)
- Collapse prevention via SLT distinct from #540 InfoNCE contrastive (different singularity structure)
- Patch masking distinct from #169 dropout (neurons vs input patches)

## Cross-refs: #223 #169 #296 #370 #354 #438 #501 #540 #530 #498 #503 #548

## Open Problems
1. Formal derivation of EMA coupled fiber RLCT formula (C3)
2. Empirical SGLD validation of mask-ratio phase transition m* (C2)
3. Collapse-to-constant singularity structure analysis (C4)
4. Transfer mechanism: does MAE low-lambda stratum correlate with downstream RLCT? (C5)
5. Comparison: DINO vs MAE generalization bound difference B(m)/N term
6. Width dependence of SSL RLCT (connection to #480 muP)
7. Relationship between EMA decay tau and effective RLCT (C3)

## Next: L5 experiment design -- SGLD LC estimation for MAE at varying mask ratios m, DINO at varying EMA decay tau and centering/sharpening on/off. Sweep model width. Compare n_MAE(m) vs n_DINO(tau, centering, sharpening).

End s550 L4.
