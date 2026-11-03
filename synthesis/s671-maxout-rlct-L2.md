## Synthesis #671: Maxout Networks x RLCT
## L2: Novelty Verification

**Date:** 2026-10-28
**Status:** L2 Novelty Verification COMPLETE

---

### Prior Art Search Results
- Websearch (2026-10-28): "maxout networks singular learning theory RLCT" — zero relevant results. No prior work connecting maxout to SLT/RLCT.
- Catalog grep: single entry (#671) for maxout. No overlap with any prior synthesis.

### Overlap Analysis

**#58 ReLU x RLCT:** Maxout with k=2 reduces to ReLU-like structure (max(z_1,z_2) = |z_1-z_2|/2 + (z_1+z_2)/2). However #58 studies fixed 2-piece binary switching; #671 generalizes to k pieces with C(k,2) tie hyperplanes creating a hyperplane arrangement singularity. k as variable introduces a discrete stratum selector absent in #58. Novelty: COMBINATORIAL GENERALIZATION of switching surface to arrangement.

**#350 SiLU x RLCT:** SiLU has mixed algebraic-transcendental singularity (x*sigmoid). Maxout is purely algebraic (semi-algebraic). Different singularity class, different definability structure. No overlap.

**#353 ELU/SELU/Softplus x RLCT:** Smoothing spectrum with continuous temperature T as selector. Maxout uses discrete k. Different selector type, different singularity geometry. No overlap.

**#555 GELU x RLCT:** Smooth activation via erf (transcendental). No non-differentiable surfaces. Completely different singularity class. No overlap.

**#609 SwiGLU x RLCT:** Multiplicative gating singularity. Maxout is additive max operation. Different fiber structure. No overlap.

**#622 Determinantal Variety x RLCT:** Rank-based singularity. Maxout singularity is arrangement-based. Different geometric structure. No overlap.

### Novelty Assessment: CONFIRMED

1. Hyperplane arrangement singularity from C(k,2) pairwise ties — first in catalog.
2. Discrete stratum selector k — first in catalog (vs continuous T, saturation, rank).
3. O(k^d) combinatorial region growth creates new singularity complexity class.
4. Dead-piece as k-generalization of dead-unit (#58) with different codimension structure.

### L2 Status: NOVELTY VERIFIED

All overlaps checked. No prior art found. Key contributions genuinely new to SLT/RLCT framework.

**Next:** L3 (empirical predictions) or L4 (summary).