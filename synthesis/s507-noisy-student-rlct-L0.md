# Synthesis #507: Noisy Student × RLCT — L0 Exploration (2026-10-22)

## Topic
Noisy Student self-training (Xie et al. 2020): teacher trained on clean data generates pseudo-labels;
student (equal or larger) trained on these labels with noise (augmentation, dropout, stochastic depth)
injected ONLY into student inputs; iterate. Interpreted via Singular Learning Theory (RLCT).

## Prior art
- Xie et al. 2020 (Self-Training With Noisy Students Improves ImageNet). No SLT/RLCT treatment found (2 websearches, zero hits).
- Catalog neighbors: #261 KD × RLCT (temperature analogy), #327 pseudo-labeling (no noise in training), #334 self-distillation (no noise), #296 stochastic depth (noise as mechanism, not curriculum).

## Claims skeleton
- C1 (definability, PROVABLE): The student expected loss E_{ε~D_noise}[L(f_θ(x+ε), ŷ_teacher)] is a Gaussian-type smoothing (ambient convolution) of the teacher-labeled loss; the smoothed empirical process satisfies Watanabe regularity conditions, so RLCT λ_student is well-defined.
- C2 (desingularization, CONJECTURAL): Noise convolution acts as a heat-semigroup smoother: λ_student(σ) ≤ λ_teacher for σ > 0, with strict desingularization of narrow strata as σ grows; σ* = sqrt(2·η·ΔE) predicts stratum transitions (cf. #377 Itô correction, #261 temperature).
- C3 (stratum selector, CONJECTURAL): Confidence-filtered pseudo-labeling selects data points in low-ambiguity strata; the retained subset has lower effective RLCT than the full data (filtering as projection onto a semi-algebraic subset, cf. #424 speculative decoding acceptance region).
- C4 (capacity asymmetry, CONJECTURAL): Equal-or-larger student in a smoother landscape has larger fiber dimension but lower complexity measure — generalization gap shrinks not by capacity but by noise-flattened singularities.
- C5 (iterative decay, CONJECTURAL): Repeated teacher→student rounds monotonically decrease measured RLCT (student posteriors concentrate near fewer singular fibers), predicting diminishing returns per round — a phase transition at round r*.

## Experimental design (falsification)
1. Estimate RLCT (LLC, SGLD) of teacher vs student across noise magnitudes — test C2 monotonicity.
2. Vary confidence threshold τ — test C3 stratum-selection effect on λ.
3. Equal vs smaller student under same noise — test C4 asymmetry claim.
4. Per-round LLC trajectory — test C5 decay and r*.

## Status
L0 done. Next: L1 formalization (C1 proof sketch, C2-C5 math).
