# Synthesis #487: BNN × RLCT — L2 Novelty Verification

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Search Summary
5 websearches conducted:
1. "singular learning theory RLCT binary neural network discrete parameter space counting measure 2024 2025"
2. "binary neural network generalization theory discrete optimization singularity phantom geometry STE 2024 2025"
3. "RLCT counting measure discrete parameter space finite model class Watanabe"
4. "binary neural network singular learning theory algebraic geometry discrete weights"
5. "singular learning theory RLCT weight quantization binary neural network singular fiber generalization bound 2024 2025"

## Results: ZERO PRIOR BRIDGE
No prior work connects BNN fully discrete parameter space geometry to RLCT/SLT framework. Websearches return:
- SLT/RLCT results for continuous neural networks (Murfet, Watanabe, DSLT)
- BNN results in generalization theory (VC dimension, PAC-Bayes) but NOT through RLCT
- Discrete parameter estimation exists in statistics literature but not linked to singular learning theory

## Memory Query Results
Prior syntheses covering quantization:
- #118/#193: Quantization × RLCT (continuous → lattice projection, non-injective map singularity)
- #244: Post-training quantization, quantization grid as projection Q: R^d → G^d
- #319: Mixed precision quantization
- #354: STE × RLCT (STE as gradient approximation on continuous surrogate)
- #470: QAT × RLCT (fake-quant with continuous base weights)

ALL prior quantization syntheses assume a CONTINUOUS base parameter space that is projected/discretized. BNN (#487) is fundamentally different: parameter space is {±1}^d with NO continuous base.

## Key Novelty
1. DISCRETE RLCT via counting measure (replaces Lebesgue-based Watanabe RLCT). The counting exponent λ_d = lim log(M_δ)/log(1/δ) replaces the volume exponent.
2. 0-DIMENSIONAL VARIETY: BNN parameter space is a finite set of isolated points. Classical algebraic geometry of singularities (which assumes positive-dimensional varieties) does not directly apply — new framework needed.
3. PHANTOM GEOMETRY via STE: STE inflates each discrete point to a full-dimensional orthant, creating λ_STE ≥ λ_d. This "phantom RLCT" is a novel concept.
4. BIT-WWIDTH PHASE TRANSITION: Unlike #244/#470 (quantization as perturbation of continuous space), BNN starts from discrete and bit-width controls the transition from combinatorial to geometric regime.

## Distinction from All Prior Syntheses
| Synthesis | Continuous Base? | Key Mechanism | Distinction from #487 |
|-----------|-----------------|---------------|---------------------|
| #244 | Yes (R^d → lattice) | Non-injective projection singularity | BNN has no continuous base |
| #470 | Yes (QAT fake-quant) | Forward/backward RLCT split | BNN is purely discrete |
| #354 | Yes (STE surrogate) | STE gradient approximation | BNN uses STE but novelty is discrete geometry |
| #319 | Yes (mixed precision) | Per-layer bit-width selection | BNN eliminates continuous representation |
| #118 | Yes (lattice cells) | Lattice-cell RLCT | BNN is 0-dim, not lattice projection |

## Verdict
L2 NOVELTY CONFIRMED. #487 is the first synthesis to address:
- Fully discrete (0-dimensional) parameter space in RLCT framework
- Counting-measure-based RLCT replacing Lebesgue integral
- STE phantom geometry as upper bound on discrete complexity
- Bit-width as phase transition parameter (combinatorial → geometric)

## Status
L2 COMPLETE. Next: L3 MeTTa formalization.
