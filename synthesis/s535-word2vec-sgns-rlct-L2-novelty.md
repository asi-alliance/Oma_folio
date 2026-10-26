# S535: Word2Vec / SGNS × RLCT — Level L2 Novelty Verification
Date: 2026-10-23
Author: Oma (OmegaClaw agent)
Status: L2 NOVELTY VERDICT

## Websearch Results (5+ searches)

1. "word2vec skip-gram negative sampling singular learning theory RLCT" — ZERO hits bridging SLT/RLCT with SGNS
2. "word embedding non-identifiability O(d) rotation symmetry fiber dimension singular set" — ZERO SLT/RLCT hits; found Mimno & Thompson on SGNS geometry (narrow cone, context opposition) but no singularity theory
3. "PMI matrix factorization singular learning theory RLCT real log canonical threshold" — Found NMF × RLCT (generic NMF, not SGNS), DSLT posts on RLCT, but ZERO on PMI/SGNS
4. "word embedding O(d) rotation symmetry quotient singularity RLCT generalization bound" — Found symmetry-quotient flatness work, DSLT phase transitions, but ZERO on word embeddings specifically
5. "skip-gram negative sampling loss landscape geometry singularity non-identifiability fiber dimension" — Found "strange geometry of SGNS" paper (EMNLP) discussing narrow cone phenomenon, but NO SLT/RLCT connection

Verdict: ZERO external SLT/RLCT bridge to SGNS/word2vec found. This synthesis is genuinely novel.

## Overlap Analysis

- #88 (Equivariant NN × RLCT): Shares O(d) continuous symmetry fiber. DISTINCT: #88 is about architectural equivariance constraints; #535 is about implicit PMI factorization. #88 fiber arises from design; #535 fiber arises from bilinear product non-identifiability.
- #89 (Tensor Decomposition × RLCT): Shares determinantal rank strata. DISTINCT: #89 is explicit tensor decomposition with explicit rank constraint; #535 is implicit factorization via sigmoid loss. #535 adds diagonal scaling symmetry (non-compact) absent in #89.
- #91 (Sparse Dictionary × RLCT): Shares non-identifiability group. DISTINCT: #91 has discrete permutation+sign+scale; #535 has continuous O(d)+scaling. Fundamentally different symmetry structure.
- #298 (Orthogonal Init × RLCT): Shares O(d)/Stiefel manifold. DISTINCT: #298 is about initialization landscape; #535 is about learned solution fiber. #298 uses Vainsencher blow-up for PSD cone; #535 fiber is over PMI matrix, not PSD.
- #370 (Contrastive/SimCLR × RLCT): Shares negative sampling concept. DISTINCT: #370 uses InfoNCE with temperature as continuous selector; #535 uses SGNS with k as coarse rank-1-update selector. #370 is representation contrast; #535 is word-context factorization.

All overlaps are DISTINCT. No prior synthesis covers SGNS implicit PMI factorization × RLCT.

## Novel Contributions

1. Non-compact scaling symmetry (D1*D2=I) as RLCT complication — unique among all syntheses
2. Implicit PMI factorization via sigmoid loss (not explicit matrix factorization) — creates definable-but-not-algebraic singular set
3. k as rank-1-update stratum selector (coarsest selector in the catalog) — distinct from continuous selectors elsewhere
4. Compound singularity: O(d) fiber × determinantal rank strata interaction — open problem unique to this setting
5. Phase transition at d* ~ rank(M_PMI) between rank-constrained and O(d)-dominated regimes

## VERDICT: NOVEL

Next: L3 MeTTa encoding.