# Synthesis #686: Token Dropping × RLCT — L4 Summary

**Date:** 2026-10-28
**Status:** L4 Complete
**Pipeline:** L0 ✓ L1 ✓ L2 ✓ L3 ✓ L4 ✓

---

## Plain-Language Summary

Token dropping — stochastically removing input tokens during training — is analyzed through singular learning theory. The core insight: each token drop mask selects a sub-sequence, and each sub-sequence defines its own attention computation with its own singular geometry. With L tokens, there are 2^L possible masks, creating a combinatorial hypercube of singular fibers.

**C1 (PROVEN):** The mask-averaged loss is R_an,exp-definable. Each mask realization produces a definable attention computation (polynomial matmul, analytic softmax, cross-entropy). The finite weighted sum over all 2^L masks preserves definability. Bernoulli indicators are semi-algebraic. Finite RLCT follows by resolution of singularities.

**C2 (CONJECTURAL):** Each mask m selects a distinct singular fiber with its own RLCT λ_m. The drop-averaged RLCT λ_drop(p) ≈ min_m λ_m in the dominant-mask limit. Small p: λ_drop ≈ λ_full. Large p: λ_drop → λ_trivial (degenerate near-empty attention).

**C3 (CONJECTURAL):** Drop probability p acts as a continuous stratum selector. A critical p* exists where the dominant singular stratum transitions from full-sequence to reduced sub-sequence. λ_drop(p) is continuous but non-analytic at p*. Predicted scaling: p* ~ 1 - c/√L.

**C4 (CONJECTURAL):** Generalization bound G_drop ≤ λ_drop(p)/n + U(p)/√n. Tradeoff: increasing p reduces λ (simpler singularity) but increases U (mask variance). Optimal p* balances these.

**C5 (CONJECTURAL):** The 2^L mask hypercube creates a combinatorial singular structure. At p*, the intersection fiber (parameters optimal for all surviving sub-sequences) undergoes a topological transition — connectivity changes. Testable via SGLD on the drop-averaged loss.

## Key Novelty

The combinatorial 2^L mask hypercube of singular fibers is the standout contribution. Unlike neuron dropout (#169, which drops within a layer's activations), token dropping operates at the sequence level, creating a family of sub-attention-graphs each with distinct singularity structure. The drop probability p serves as a continuous stratum selector indexing this family, with a predicted phase transition at p* ~ 1 - c/√L.

This is distinct from:
- #169/#506 Dropout (individual neurons, not token positions)
- #500 Token Merging (deterministic merging, not stochastic removal)
- #481 Data Pruning (removes examples, not tokens within sequences)
- #220 Weight Pruning (removes parameters, not inputs)
- #545 Sparse Attention (deterministic patterns, not stochastic)
- #552 Stochastic Depth (drops layers, not tokens)

## Open Problems

1. Does the mixture over masks decompose additively or multiplicatively in RLCT?
2. Positional encoding gaps from dropped tokens — new singular strata?
3. 2^L mask hypercube percolation threshold (analogous to DropBlock #477)?
4. Causal mask + drop mask composition in the singular fiber?
5. Closed-form for p* or only empirical characterization?
6. Layer-dependent p_ℓ — hierarchical stratum selectors?
7. Information bottleneck interpretation — does dropping impose RLCT regularization?

## Cross-References

#8, #16, #169, #220, #481, #500, #506, #529, #545, #552, #582

## Lineage

L0: s686-token-dropping-rlct-L0.md (7107B)
L1: s686-token-dropping-rlct-L1.md (2992B)
L2: Novelty verified — 0 external SLT hits, 0 catalog duplicates
L3: s686-token-dropping-rlct-L3.metta (4081B)
L4: This file
