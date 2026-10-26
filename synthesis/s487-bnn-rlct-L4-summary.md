# Synthesis #487: BNN × RLCT — L4 Cross-Reference Validation & Summary

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Pipeline Status
L0 (Exploration) ✓ | L1 (Formalization) ✓ | L2 (Novelty) ✓ | L3 (MeTTa) ✓ | L4 (Summary) ✓

## Claims Summary
- C1 PROVEN: BNN loss on finite Theta_b is trivially R_an,exp-definable (any function on finite set is definable).
- C2 CONJECTURAL: STE phantom geometry inflates each discrete point to full-dimensional cell, lambda_STE >= lambda_d.
- C3 CONJECTURAL: Bit-width b as complexity parameter. U-shaped lambda_eff(b) with critical b* (combinatorial→geometric crossover).
- C4 CONJECTURAL: Generalization bound G_b(n) <= C·min(b·d/n, lambda_eff(b)/n + U/sqrt(n)) interpolating PAC and Watanabe bounds.
- C5 CONJECTURAL: SGLD on STE surrogate reveals LLC kink at b* — observable phase transition.

## Standout Novelty
Discrete RLCT via counting measure. BNN parameter space is 0-dimensional (finite set {±1}^d). Classical Watanabe RLCT (Lebesgue-based) replaced by counting exponent lambda_d = lim log(M_delta)/log(1/delta). STE creates phantom continuous geometry where each discrete point inflates to a full-dimensional orthant. Unlike all prior quantization syntheses (#244/#470/#354/#319), BNN has NO continuous base — purely discrete parameter space. Bit-width controls combinatorial→geometric phase transition.

## Cross-Reference Validation
- #8 (ReLU singularity): BNN uses sign activation, not ReLU. Distinct.
- #16 (permutation symmetry): BNN has discrete permutation over configs. Related.
- #100 (transformer RLCT): BNN transformer would combine #100 + #487. Open.
- #169 (dropout): Binary mask related but stochastic vs deterministic. Distinct.
- #222 (spectral norm): Spectral regularization on discrete weights. Distinct.
- #244 (post-training quantization): Projects continuous→lattice. BNN has no continuous base. SUPERSEDED for discrete case.
- #319 (mixed precision): Per-layer bit-width selection, continuous base. Distinct.
- #354 (STE): Studies STE gradient approximation. #487 uses STE but novelty is discrete geometry. Extended.
- #470 (QAT): Fake-quant with continuous base. BNN is purely discrete. Distinct.
- #473 (spectral norm full): Operator bounds on continuous weights. Distinct.
- #486 (MoE): Gating stratum selection in parameter space. Distinct mechanism.

## Distinctions from All Prior Syntheses
No prior synthesis addresses fully discrete (0-dimensional) parameter space in RLCT framework. #244/#470/#319 all assume continuous base projected to lattice. #354 studies STE but not discrete geometry. #487 is the first to define counting-measure RLCT, STE phantom geometry inflation, and bit-width phase transition from combinatorial to geometric regime.

## Open Problems
1. Formalize counting exponent lambda_d — existence and computability
2. Relate lambda_d to combinatorial structure of Boolean function class (VC dimension connection)
3. Prove/disprove lambda_STE >= lambda_d rigorously
4. Characterize b* as function of d, n, target complexity
5. Ternary vs binary: discontinuous or smooth jump?
6. Weight initialization effect on phantom geometry
7. BNN transformer: combining #100 + #487

## Status
L4 COMPLETE. Next: L5 catalog append.
