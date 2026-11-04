# Synthesis #823: NoPE (No Positional Encoding) × RLCT

**Date:** 2026-10-29  
**Status:** L0 EXPLORATION

## Motivation

NoPE transformers (Kazemnejad et al. 2023) operate without any positional encoding, relying entirely on content-based attention. The model is permutation-equivariant by construction: permuting input tokens permutes the output correspondingly. This permutation symmetry S_n acts on parameter space, creating quotient singularities distinct from continuous group actions (RoPE SO(d/2) in #490) or additive biases (ALiBi in #503). NoPE models work surprisingly well, raising the SLT question: does permutation symmetry reduce RLCT?

## Key Observations

1. **Discrete group action:** S_n (symmetric group on n tokens) acts on the loss landscape. Unlike continuous groups (SO(d/2) for RoPE), discrete group actions create orbifold singularities at fixed points of non-trivial permutations.

2. **No PE parameters:** Unlike learned absolute PE (adds |V_pos|×d parameters, #224 C3), NoPE has zero positional parameters. The singular fiber has lower ambient dimension.

3. **Implicit position emergence:** NoPE models develop implicit positional information through attention patterns. This emergent structure may correspond to an RLCT phase transition at critical context length n*.

4. **Permutation-equivariant fiber:** The zero-loss set W_0 is invariant under S_n. The effective model class is W_0/S_n (quotient by permutation symmetry), which has different singularity structure than W_0 itself.

## Five Claims

**C1 (PROVABLE):** NoPE transformer loss is R_{an,exp}-definable. Without PE, attention is A = softmax(QK^T/sqrt(d))V where Q,K,V are linear projections of token embeddings only. All components (linear maps, softmax, matrix multiply) are analytic/semialgebraic. Composition preserves definability. Finite RLCT exists via resolution of singularities.

**C2 (CONJECTURAL):** The permutation group S_n creates an orbifold singular fiber W_0/S_n. The RLCT of the quotient satisfies λ_{NoPE} ≤ λ_{general} - log(|S_n|)/(2n) asymptotically, where the symmetry reduction removes effective parameter directions. Fixed points of non-trivial permutations (where tokens i,j have identical representations) create additional singular strata.

**C3 (CONJECTURAL):** NoPE has lower RLCT than learned absolute PE (#224 C3) due to: (a) zero positional parameters reducing ambient dimension by |V_pos|×d, (b) permutation quotient further reducing the fiber. Combined: λ_{NoPE} < λ_{learned_PE} - |V_pos|×d/2.

**C4 (CONJECTURAL):** Generalization bound: G_{NoPE}(n) ≤ λ_{NoPE}·log(n)/(2n) + U_{NoPE}/√n, where U_{NoPE} < U_{PE} because permutation equivariance constrains the hypothesis class. The bound improves (lower λ) for tasks with permutation-invariant target functions.

**C5 (CONJECTURAL):** Phase transition at critical context length n*: for n < n*, NoPE relies on local attention patterns (implicit position), λ stable. For n > n*, the model must encode global position implicitly, causing λ to increase (new singular strata from attention pattern specialization). Detectable via SGLD LLC trajectory as context length increases.

## Distinction from Prior Syntheses

- **#224 (Positional Encoding × RLCT):** Covered PE types broadly; mentioned NoPE as case 5 but did not analyze permutation symmetry singularity in depth. #823 is the dedicated deep dive.
- **#490 (RoPE × RLCT):** Continuous SO(d/2) gauge symmetry vs #823 discrete S_n orbifold. Fundamentally different singularity types (continuous quotient vs orbifold).
- **#503 (ALiBi × RLCT):** Additive linear bias creates translational symmetry. NoPE has no position injection at all — pure permutation equivariance.
- **#134 (Attention Mechanism):** General attention singularity (rank deficiency, softmax saturation). #823 focuses on the permutation symmetry of the FULL model without PE.
- **#8 (Softmax × RLCT):** Foundational definability. #823 builds on this but adds permutation group structure.

## Open Problems

1. Orbifold RLCT: How does resolution of singularities work for W_0/S_n where S_n acts by permuting token indices? The quotient has singularities at fixed points of transpositions (i↔j where tokens are identical).
2. Implicit position encoding: What is the SLT characterization of emergent positional information in attention patterns? Is it a new singular stratum?
3. Context length scaling: Is n* (phase transition) dependent on model dimension d, or on task structure?
4. Comparison with causal masking: Causal masking breaks permutation symmetry partially (only prefix permutations survive). How does this modify the orbifold?
5. Relation to set-equivariant architectures (DeepSets, Set Transformer): Do these share the same orbifold RLCT structure?
6. Finite vs asymptotic S_n: For fixed n, |S_n|=n! is finite but grows superexponentially. Does the log|S_n|/(2n) bound remain meaningful?
7. Interaction with #494 (activation sparsification): Does top-k attention in NoPE preserve or break permutation symmetry?

## Cross-References

#8 (softmax), #16 (depth), #100 (general framework), #134 (attention mechanism), #224 (positional encoding), #490 (RoPE), #503 (ALiBi), #494 (activation sparsification), #545 (sparse attention), #508 (induction heads), #520 (masked LM)

## Next Steps

L1: Formalize orbifold singular fiber W_0/S_n, define S_n action precisely on parameter space, derive RLCT bounds for quotient singularities.
