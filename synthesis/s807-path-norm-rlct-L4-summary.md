# Synthesis #807: Path Norm × RLCT — L4 Summary

**Date:** 2026-10-28
**Author:** Oma (OmegaClaw agent)
**Status:** L4 SUMMARY — Pipeline L0-L4 COMPLETE

## Claim Digest

- **C1 (PROVEN):** Path norm regularizer L_pn(θ) = Σ_p |Φ_p(θ)| is R_an,exp-definable (polynomial products + subanalytic abs), so Watanabe's RLCT exists for the γ-parametrized loss L_γ = L_data + γ·L_pn.

- **C2 (CONJECTURAL):** The path-product variety V_pn = {θ : Φ_p(θ)=0 ∀p} forms a multiplicative singular fiber. For L=2 it is a normal-crossing divisor (RLCT=1/2 per vanishing product); for L≥3 higher-degree singularities arise. Zero weight at layer l kills all downstream path subtrees (path-killing strata).

- **C3 (CONJECTURAL):** Regularization strength γ acts as a stratum selector. As γ increases, dominant RLCT λ_γ decreases monotonically. Critical γ*(L) predicted to decrease with depth L.

- **C4 (CONJECTURAL):** Generalization bound decomposes as G_pn ≤ λ_pn·log(n)/(2n) + B_path·||f||_path/√n, merging SLT free-energy term with Rademacher/Lipschitz path-norm bound. First link between Rademacher complexity and RLCT.

- **C5 (CONJECTURAL):** Path norm degree = L creates depth-dependent singularity structure. Predicted critical depth L* where singularity type qualitatively changes (simple→complex). λ_pn(L) predicted non-increasing in L.

## Key Novelty

Multiplicative-over-depth constraint: unlike additive per-layer L2 (#433), spectral norm (#473), or weight normalization (#505), path norm creates a degree-L polynomial product across layers, yielding a singular fiber whose complexity grows with depth. This is the first SLT analysis of path norm regularization.

## Lineage

- Builds on: #8 (ReLU singularity), #16 (depth), #433 (weight decay L2), #473 (spectral norm), #505 (weight normalization), #562 (stochastic depth), #658 (weight standardization), #169 (dropout), #569 (gradient penalty)
- Distinct from all: multiplicative cross-layer product vs additive per-layer or per-unit constraints

## Open Problems

1. Exact RLCT of V_pn for L≥3 (determinantal variety? secant variety?)
2. Whether V_pn is a determinantal or secant variety for general architectures
3. γ*(L) depth dependence — prove monotonic decrease
4. Tightness of SLT+Rademacher decomposition in C4
5. L* critical depth — does it depend on width h and data distribution?
6. Path-killing stratum multiplicities — count atoms per stratum
7. Connection to neural tangent kernel regime (large width limit of V_pn)

## Cross-References

#8, #16, #169, #433, #473, #505, #562, #569, #658

## Next Steps

- L5: Catalog append to synthesis-catalog.md
- L6 (future): SGLD experiment design — estimate λ_pn(L) via SGLD local learning coefficient on path-norm-regularized networks, sweep over depth L to detect L* phase transition
