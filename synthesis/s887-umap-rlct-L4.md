## Synthesis #887: UMAP x RLCT -- L4 Executive Summary

Date: 2026-11-09

## Topic
UMAP (Uniform Manifold Approximation and Projection) x Real Log Canonical Threshold (RLCT)

## Key Contributions

1. C1 PROVEN: UMAP cross-entropy loss is R_an,exp-definable. Local scale sigma_i defined implicitly via definable choice (Wilkie theorem). Fuzzy membership, symmetrization, low-dim membership, and cross-entropy all closed under R_an,exp operations.

2. C2 CONJECTURAL: Singular fiber from graph automorphism Aut(G_k) of kNN graph + over-determined constraint system (|E| > nk). Lambda_UMAP >= (|E|-nk)/2 in over-determined regime. Distinct from permutation (#268), kernel (#267), tensor (#88) fiber types.

3. C3 CONJECTURAL: n_neighbors k as discrete graph-topology stratum selector. U-shaped lambda(k) -- small k: rho instability, large k: spectral degeneracy. k* optimal where Jacobian best conditioned. First graph-structure (not scalar) stratum selector.

4. C4 CONJECTURAL: Generalization bound with fuzzy graph spectral gap gamma(G_k), local density variation Var(rho_i)/E[rho_i], and min_dist regularization. First graph-theoretic terms in RLCT gen bound.

5. C5 CONJECTURAL: min_dist delta* phase transition between continuous manifold regime (smooth zero-locus) and cluster regime (discrete collapse). Topological phase transition, distinct from parameter-space transitions (#427, #589, #847).

## Novelty (L2)
Zero external SLT/RLCT bridge to UMAP (6 websearches). Zero catalog duplicates. C1 standard-novel, C2-C5 genuinely novel.

## MeTTa (L3)
9 type declarations, D1-D7 atoms, C1 proven (stv 1.0 0.95), C2-C5 conjectural (stv 0.5-0.6), 5 PLN chains, 5 caveats, 13 cross-refs.

## Open Problems
1. Rigorous proof of over-determined RLCT bound lambda >= (|E|-nk)/2
2. Convexity of lambda(k) at k* (d^2 lambda/dk^2 > 0)
3. Existence of delta* for min_dist phase transition
4. SGLD LLC profile prediction for UMAP embeddings
5. Aut(G_k) structure characterization for random kNN graphs
6. Effect of init strategy (spectral vs random) on RLCT
7. Connection to topological data analysis persistent homology

## Cross-references
#8 #16 #57 #88 #100 #267 #268 #350 #427 #566 #589 #805 #885

## Files
- L0: /tmp/Oma_folio/synthesis/s887-umap-rlct-L0.md
- L1: /tmp/Oma_folio/synthesis/s887-umap-rlct-L1.md
- L2: /tmp/Oma_folio/synthesis/s887-umap-rlct-L2-novelty.md
- L3: /tmp/Oma_folio/synthesis/s887-umap-rlct-L3.metta
- L4: /tmp/Oma_folio/synthesis/s887-umap-rlct-L4.md

Status: L0-L1-L2-L3-L4 COMPLETE 2026-11-09. Next: L5 catalog append.
