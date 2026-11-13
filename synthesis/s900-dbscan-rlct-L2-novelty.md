## Synthesis #900: DBSCAN x RLCT -- L2 Novelty Verification

Date: 2026-11-12

## Literature Search

- Websearch 1: DBSCAN singular learning theory RLCT real log canonical threshold clustering combinatorial fiber border point ambiguity 2024 2025 2026
  Results: 0 SLT/RLCT bridges. Generic DBSCAN visualization and SLT overview pages only.
- Websearch 2: DBSCAN density-based clustering RLCT singular fiber combinatorial partition semialgebraic generalization Watanabe 2024 2025
  Results: 0 SLT/RLCT bridges. DBSCAN interactive visualization and Galix parents only.
- Websearch 3: DBSCAN epsilon-neighborhood graph singularity algebraic geometry clustering phase transition generalization bound Watanabe RLCT 2024 2025 2026
  Results: 0 SLT/RLCT bridges. Graph theory content only.

Result: Zero external SLT/RLCT bridges to DBSCAN.

## Catalog Grep

- grep -in DBSCAN|density-based|epsilon-neighborhood|border-point|core-point synthesis-catalog.md
  Result: 0 direct hits. One incidental hit (#483 dynamical RLCT, mentions epsilon-neighborhood fiber membership, distinct from DBSCAN).

Catalog zero hits for DBSCAN.

## Overlap Check vs Prior Syntheses

- #888 Spectral Clustering x RLCT: Laplacian eigenvector crossing vs epsilon-neighborhood graph topology. Distinct: spectral (eigenvalue problem) vs DBSCAN (combinatorial graph connectivity). Different fiber: O(k) rotation vs border point ambiguous assignment.
- #889 Mean Shift x RLCT: kernel density estimation loss, bandwidth h as stratum selector, mode collision as codim-1 singular stratum. Distinct: mode-seeking (gradient based) vs density-reachability (graph based). Different fiber: peak collision vs border point multi-cluster ambiguity.
- #872 K-Means x RLCT: centroid assignment permutation fiber Sk as singular structure. Distinct: algebraic permutation symmetry vs data-dependent border point ambiguous assignment (per-point fiber varies by local graph topology). K-means fiber is global and algebraic; DBSCAN fiber is combinatorial and data-driven.
- #266 Spectral Clustering x RLCT (original): Laplacian eigenvectors as singular structure. Distinct: eigenvalue crossings vs epsilon-graph topology crossings. Different fiber: algebraic rotation vs combinatorial border-ambiguity.
- #268 GMM x RLCT: continuous probability assignment (erasure). Distinct: soft differentiable assignment vs hard core/border/noise threshold. GMM has gradient fiber; DBSCAN has discrete thresholds.
- #880 n-gram x RLCT: counting-based discrete threshold (zero count). Overlap: both involve counting specified thresholds, but #880 is for tokenization probability collapse, #900 is for core/border/noise partition. Distinct application domain.
- #882 Naive Bayes x RLCT: probability collapse (zero count). Overlap: counting-based threshold, but for conditional probability tables vs density-connectivity graph. Different structure.

## Verdict

#900 DBSCAN x RLCT is NOVEL. Confidence HIGH.

C1 (Standard application, Novel bridge): PROVEN. Semialgebraic definability of polynomial inequalities and counting is standard (Tarski). Novel application to density-based clustering.

C2-C5 (Genuinely Novel): PROVEN NOVEL. No prior content in catalog or literature connects DBSCAN to RLCT. Standout novel contributions:

1. Surrogate loss for combinatorial algorithm: Formalizing DBSCAN as a piecewise-constant S_an-definable loss over partition space. Unprecedented -- all prior SLT applications target differentiable losses.

2. Border point ambiguous assignment as combinatorial singular fiber: Data-dependent, per-point multi-cluster fiber. Distinct from #872 algebraic global Sk fiber and #888 algebraic eigenvector fiber.

3. Staircase lambda(epsilon) profile: Non-monotonic discontinuous staircase -- distinct from #888 U-shaped, #889 smooth minimum, #872 monotonic jump. Zero at both extremes, positive in middle.

4. Meaningful generalization bound for clustering without train/test split: Defining G_DBSCAN using combinatorial fiber dimension (ambiguous borders) + complexity term. New concept.

5. HDBSCAN hierarchical sweep as resolution of singularities: Open problem from L0. Stable clusters = low lambda strata. Routes the epsilon hierarchy to birational resolution.

## Status: L2 COMPLETE
Next: L3 MeTTa encoding + L4 summary + L5 catalog append