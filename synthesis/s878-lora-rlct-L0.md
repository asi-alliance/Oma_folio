#878: LoRA × RLCT — L0 Topic Proposal

## Date: 2026-11-07

## Subject
LoRA (Low-Rank Adaptation): fine-tuning via W = W₀ + BA where B ∈ ℝ^{d×r}, A ∈ ℝ^{r×k}, r ≪ min(d,k). The rank-r constraint on the update ΔW = BA creates a determinantal variety — the set of rank-≤r matrices is an algebraic variety with known singular strata.

## Why RLCT?
The parameter space of LoRA is (B, A) ∈ ℝ^{d×r} × ℝ^{r×k} — a smooth manifold of dimension r(d+k). But the map (B,A) → BA has non-trivial fibers: different (B,A) pairs yield the same ΔW. The fiber over a rank-s matrix (s < r) has positive dimension (gauge freedom in B,A). This is a classic singular learning theory setup:

1. **Non-identifiability**: The map (B,A) → BA is not injective. For rank s < r, the fiber dimension grows as r-s degrees of gauge freedom. This is an algebraic singularity.
2. **Determinantal variety**: The image {BA : rank(BA) ≤ r} = {M ∈ ℝ^{d×k} : rank(M) ≤ r} is a determinantal variety — a well-studied algebraic variety with known singular locus at rank < r.
3. **Stratum structure**: Rank s ≤ r defines strata. Rank s = r (full relative rank) is the smooth top stratum. Rank s < r strata are singular. The RLCT should differ across strata.
4. **Gauge symmetry**: (B, A) → (B G, G⁻¹ A) for G ∈ GL(r) leaves BA invariant. This continuous gauge group creates a non-identifiability that is precisely the source of singularities.

## Key Claims (Candidate)
- **C1**: R_{an,exp} definability. Polynomial map BA, rank conditions as polynomial equations, ReLU/softmax/cross-entropy compositions all definable.
- **C2**: Singular fiber at rank collapse (s < r). The fiber over rank-s ΔW has dimension = (r-s)² gauge freedom + smooth directions. Determinantal variety singular locus.
- **C3**: Rank s as stratum selector. Each rank s ≤ r defines a stratum with distinct RLCT. Gauge group GL(r) → GL(s) × GL(r-s) reduction at each stratum.
- **C4**: Generalization bound with RLCT. LoRA's known empirical generalization advantage explained by lower RLCT of rank-r constraint vs full fine-tuning.
- **C5**: Critical rank r* phase transition. As r increases past r*, behavior transitions from singular (low-rank regime) to regular (full-rank regime). SGLD-testable.

## Novelty
No prior synthesis covers LoRA or determinantal varieties. The gauge symmetry (B,A) → (BG, G⁻¹A) is a continuous non-identifiability distinct from ReZero's discrete identity fiber or SkipInit's scalar γ. The determinantal variety singular locus is algebraically explicit — RLCT may be computable via resolution of singularities for determinantal varieties (known in algebraic geometry).

## Closest Prior Work
- #877 SkipInit: scalar γ=0 fiber on SWS sphere (different singularity type)
- #484 ReZero: identity matrix fiber (discrete, not continuous gauge)
- #421 LayerScale: vector γ selector (finite-dimensional, no gauge symmetry)
- #531 NFNet: weight standardization sphere (geometric constraint, no rank)

## Open Questions
1. Exact RLCT of determinantal variety rank-r stratum — can algebraic resolution formulas give closed form?
2. Gauge group GL(r) → fiber dimension formula: is it (r-s)² for rank-s stratum?
3. Does r* (critical rank) correspond to the intrinsic rank of the task adaptation?
4. Comparison: LoRA RLCT vs full fine-tuning RLCT — quantitative gap?
5. SGLD signature: can rank strata be detected empirically via local energy variance?
6. Extension to QLoRA (quantized LoRA): does quantization add another singular layer?

## Pipeline Status
L0 PROPOSED. Next: L1 literature + formal analysis.
