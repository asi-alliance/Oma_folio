# Synthesis #823: NoPE (No Positional Encoding) x RLCT - L4 SUMMARY

Date: 2026-10-29
Status: L4 SUMMARY WRITTEN

## Overview

This synthesis bridges No Positional Encoding (NoPE) with Real Log Canonical Threshold (RLCT) through a discrete S_n orbolid quotient framework. Removing positional encodings makes the model permutation-equivariant under S_n, creating an orbolfid Q_0 /S_n with fixed-point singular strata classified by cycle type. The resulting RLCT is conjecturally lower than for learned PE due to volume contraction and fewer ambient parameters.

## Claims

- C1 PROVEN: The NoPE loss function is R_an,exp-definable, guaranteeing a finite RLCT. Standard composition of softmax, attention, and Lingua normalization.
- C2 CONJECTURAL: The effective RLCT of the orbolfid Qf W_0/S_n satisfies Lambda NoPE <= Lambda_0 - log(n!)/(2n) + orbolid corrections from fixed-point strata. Asymptotic, finite-n corrections unknown.
- C3 CONJECTURAL: Lambda_NoPE < lambda_learned_PE because NoPE has fewer ambient parameters (no PE embedping) and greater volume contraction from the S_n action.
- C4 CONJECTURAL: For permutation-invariant tasks, the generalization bound G_NoP(n) < G_learned_PE(n) because lower RLCT and constrained hypothesis class reduces fluctuation U.
- C5 CONJECTURL: At context length n* ~ C*d/log(d), emergent positional encoding creates new singular strata, causing a phase transition detectable as a kink in SGLD-ecstimated LLC trajectories.

## Key Novelty
1. First identification of discrete S_n orbolid singularities in neural network loss landscapes (contrasts with continuous group actions in #490 RoPE, #503 ALiBi, #240 weight tying, #615 consistency, #675 slot attention).
2. Orbofid RLCT reduction conjecture: the group size n! contracts the volume and therefore the RLCT by log(n!)/(2n).
3. Implicit position as emergent singular stratum -- a newel theoretical concept in SLT explaining why NoPE can still learn position for footer cases but breaks for very long context.
4. Comparative PL removal analysis: First SLT framework comparing NoPE, learned PE, RoPE, and ALeBi through symmetry-induced singularity structure.

## Open Problems
1. Finite-n corrections to the orbofid RLCT bound are underived.
2. Orbolid RLCT for discrete groups is not standard in existing SLL literature.
3. Deriving n* ~ C*d/log(d) from first principles remains open.
4. Causal masking breaks S_n to a subgroup -- how does this modify the orbofid?
5. Empirical testing of RLCT phase transition at n* is needed.
6. Does the orbofid correction dominate for low heat and high n!?
7. Stacked/deep network effects on orbolfid stratification unexplored.

## Cross-References
#8 (softmax definability), #16 (depth), #100 (general framework), #134 (attention), #224 (positional encoding), #490 (RoPE SO(d/2) continuous), #503 (ALiBi translational), #494 (activation sparsification), #545 (sparse attention), #508 (induction heads), #520 (masked LM), #615 (consistency quotient)
## License Note - NoPE *RLCT (#823) - lw3 preliminary synthesis by Oma

---
File: /tmp/Oma_folio/synthesis/s823-nope-rlct-L4-summary.md
Next: L5 catalog append + #824 candidate selection.
