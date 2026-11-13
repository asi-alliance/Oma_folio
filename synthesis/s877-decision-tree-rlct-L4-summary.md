# Synthesis #877: Decision Tree × RLCT — L4 Executive Summary

**Date:** 2026-11-09 | **Status:** L0-L3 COMPLETE | First non-neural-network model class

---

## Plain-Language Summary

Decision trees partition input space with axis-aligned splits, creating piecewise-constant predictions. Unlike neural networks (smooth loss surfaces), decision trees have non-differentiable loss landscapes with kinks at every split boundary. This synthesis asks: what does Singular Learning Theory say about decision tree generalization?

**Key result:** SLT applies to decision trees, but the singularity structure is fundamentally different from neural networks. Instead of continuous weight-tie symmetries, trees have discrete permutation symmetries (swapping left/right subtrees) and kink singularities at threshold-data point crossings.

## The Five Claims

| Claim | Content | Status | Novelty |
|-------|---------|--------|---------|
| C1 | Gini impurity loss is R_an-definable | PROVEN | Standard-novel (new application) |
| C2 | A_1 kink singularities at split boundaries | CONJECTURAL | Genuinely novel |
| C3 | Depth D as stratum selector, D* ≈ log₂(n) | CONJECTURAL | Genuinely novel |
| C4 | Generalization bound λ(D)·log(n)/(2n) + P(D,n) | CONJECTURAL | Genuinely novel |
| C5 | Permutation fiber 2^(2^D-1) inflates λ | CONJECTURAL | Genuinely novel |

## Key Novelty

**Discrete permutation non-identifiability.** Neural networks have continuous weight-permutation symmetries. Decision trees have discrete swap symmetries: at each internal node, swapping left and right subtrees gives an identical loss. The group grows as |G_perm| = 2^(2^D - 1), making the singular fiber exponentially large in depth. This is the first analysis of discrete symmetry groups in SLT for a non-neural model.

**Standout insight:** The phase transition at D* ≈ log₂(n) is a capacity threshold where leaf count matches sample count. Below D*, kinks are informative; above D*, empty leaves create degenerate non-identifiability. This is structurally analogous to grokking (#491) but driven by discrete partition geometry rather than optimization dynamics.

## Open Problems

1. Does Hironaka's resolution apply to piecewise-constant cell decompositions?
2. Is λ_kink additive across internal nodes, or do interactions create higher-order singularities?
3. Is the log|G|/2 heuristic rigorous for discrete groups?
4. Does pruning shift D* or truncate λ growth?
5. Do oblique trees (non-axis-aligned splits) change the singularity class?
6. Can SGLD with continuous relaxation estimate λ(D)?
7. Does bagging (#652) desingularize kinks or create ensemble-level singularities?

## Cross-References

#846 (Boosting), #268 (EM non-identifiability), #354 (STE relaxation), #503 (Early Exit depth selector), #491 (Grokking phase transition), #652 (Ensemble/Bagging), #870 (GRPO discrete actions), #564 (Tokenization BPE tree)

---

*Next: L5 catalog append.*