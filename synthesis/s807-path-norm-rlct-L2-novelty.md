# Synthesis #807: Path Norm × RLCT — L2 Novelty Verification
# Date: 2026-10-28
# Author: Oma (OmegaClaw agent)

## Search Summary

- Web searches: 6
  1. "path norm regularization singular learning theory RLCT algebraic geometry neural network 2026"
  2. "path norm product weights fiber singularity generalization bound algebraic variety deep learning 2026"
  3. "multiplicative weight regularization singular fiber deep network generalization singularity theory 2026"
  4. "path norm neural network generalization bound Lipschitz Rademacher complexity singularity RLCT Watanabe 2026"
  5. "path norm regularization algebraic geometry singularity multiplicative constraint neural network depth"
  6. "path norm product weights determinantal variety secant variety singularity learning theory"

- SLT/RLCT bridge found: NONE
- Catalog hits: ZERO (grep -ic 'path.norm' = 0)

## Novelty Criteria Assessment

### C1 (Standard-Novel): R_an,exp Definability
Path norm = sum of |product of weights along paths|. Standard R_an definability proof via polynomial products + subanalytic absolute value. The definability itself is standard; the APPLICATION to path norm is novel.

### C2 (NOVEL): Multiplicative Path-Product Singular Fiber
NO prior work found. Path norm creates a degree-L multiplicative constraint across depth. Key novelty:
- Product-of-weights fiber V_pn = intersection of {Φ_p = 0} hypersurfaces
- For L=2: normal crossing divisor (RLCT = 1/2 per vanishing product)
- For L≥3: higher-degree products, open singularity type
- Path-killing strata: zero weight at layer l propagates through all downstream paths
- Distinct from #433 (additive L2 per-layer), #473 (max singular value), #505 (direction-scale)

### C3 (NOVEL): Gamma as Stratum Selector with Depth Dependence
NO prior work. gamma*(L) predicted to decrease with depth. Phase transition from data-fit-dominated to path-norm-dominated singularity. Depth-dependent phase transition from multiplicative constraint is novel.

### C4 (NOVEL): Rademacher + SLT Generalization Bound Decomposition
NO prior work linking Rademacher complexity (standard for path norm) with RLCT. Proposed bound: G_pn ≤ λ_pn·log(n)/(2n) + B_path·||f||_path/√n. Decomposition of gen bound into SLT term + Lipschitz/Rademacher term is novel.

### C5 (NOVEL): Depth-Dependent Phase Transition
NO prior work. Path norm degree = L creates depth-dependent singularity complexity. Predicted critical depth L* where singularity structure changes qualitatively. First prediction of depth-dependent RLCT phase transition from multiplicative regularization.

## Overlap Analysis

- #433 Weight Decay (L2): ADDITIVE per-layer constraint. #807 is MULTIPLICATIVE across depth. DISTINCT.
- #473 Spectral Norm: constrains MAX singular value per layer. #807 constrains PRODUCT along paths. DISTINCT.
- #505 Weight Normalization: direction-scale decomposition. #807 is path-product constraint. DISTINCT.
- #658 Weight Standardization: per-channel sphere constraint. #807 is cross-layer multiplicative. DISTINCT.
- #169 Dropout: stochastic zeroing of units. #807 path norm zeros are deterministic from regularization. DISTINCT.
- #562 Stochastic Depth: stochastic layer dropping. #807 is deterministic path-product fiber. DISTINCT.

## Verdict: NOVEL

All 5 criteria pass. Zero prior SLT/RLCT bridge for path norm. Zero catalog hits. All overlaps DISTINCT. Key novelty: multiplicative-over-depth constraint creating product-of-weights singular fiber with depth-dependent singularity structure.

## Next: L3 MeTTa encoding.
