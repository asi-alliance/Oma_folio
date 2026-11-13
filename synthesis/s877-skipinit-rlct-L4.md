#877: SkipInit × RLCT — L4 Summary

## Date: 2026-11-07

## Pipeline: L0-L3 COMPLETE, L4 IN PROGRESS

## Subject
SkipInit (learnable scalar γ initialized to zero + Scaled Weight Standardization) analyzed through Singular Learning Theory (RLCT framework).

## Key Claims
- **C1 (PROVEN, stv 1.0 0.95):** R_{an,exp} definability. Bilinear γ·f_SWS composition, SWS rational weight scaling, ReLU subanalytic, softmax exp, cross-entropy log — all definable. Composition closure + Tarski-Seidenberg projection preserve definability.
- **C2 (CONJECTURAL, stv 0.5 0.7):** γ=0 singular fiber on SWS product-of-spheres manifold. Double singularity: geometric constraint (sphere) × identity collapse (γ=0). SWS codimension correction: λ_SWS ≈ λ_ReZero - #filters/2.
- **C3 (CONJECTURAL, stv 0.5 0.7):** Scalar γ as 1D per-block stratum selector. 2^L lattice structure. Desingularization trajectory on curved manifold. Simpler selector than #421 LayerScale but enriched by SWS geometry.
- **C4 (CONJECTURAL, stv 0.5 0.7):** Gen bound with SWS codimension correction + desingularization trajectory. λ_SkipInit ≤ λ_ReZero (conjectural). Spherical compactness ensures bounded norms.
- **C5 (CONJECTURAL, stv 0.5 0.7):** γ* phase transition. γ*_SkipInit < γ*_ReZero (SWS stabilization hypothesis). Multi-block staggered desingularization → RLCT staircase. SGLD-testable.

## Novel Insight
The "double singularity" — SWS spherical constraint × γ=0 identity collapse — creates a singular geometry with no analog in prior syntheses or external SLT literature. The fiber lives on a curved manifold (product of spheres), receiving BOTH identity-fiber multiplicity AND spherical codimension correction.

## Closest Prior Work
#484 ReZero (flat-space identity fiber), #421 LayerScale (vector γ selector), #424 Fixup (fixed scaling), #658 Weight Standardization (sphere without γ=0 fiber), #531 NFNet (SkipInit component, no dedicated RLCT analysis), #828 nGPT (product-of-spheres on activations).

## Open Problems
1. Exact RLCT of γ=0 fiber on SWS product-of-spheres vs flat R^n
2. Proof of γ*_SkipInit < γ*_ReZero
3. AGC clipping boundary × γ desingularization interaction
4. Scalar vs vector γ selector topology comparison
5. Multi-block staggered RLCT staircase: empirical test needed
6. SWS sphere × γ=0 fiber intersection MeTTa formalization

## Status
L4 SUMMARY. L0-L4 COMPLETE. Next: L5 catalog append.
