# Synthesis #903: VSA x RLCT
## L2: Novelty Verification
## Date: 2026-11-13

### Websearch Results (3 searches)
1. "RLCT singular learning theory vector symbolic architecture hyperdimensional computing" -> ZERO hits
2. "singular learning theory RLCT normal crossing divisor hyperplane arrangement neural network" -> ZERO hits
3. "VSA vector symbolic architecture capacity threshold phase transition learning theory" -> ZERO hits

### Catalog Overlap Check
grep for VSA/hyperdimensional/vector symbolic/normal-crossing in synthesis-catalog.md -> ZERO matches. No prior synthesis covers VSA or hyperdimensional computing.

### Overlap Analysis with Related Syntheses

#305 (Lion sign-based RLCT): Uses sign() as optimizer update direction. VSA uses sign() as ENCODING (bipolar quantization of representation). Distinct: #305 sign is in optimizer space, #903 sign is in feature/activation space creating the representational substrate. No overlap in singular fiber structure (Clarke subdifferential vs normal-crossing divisor).

#354 (STE x RLCT): Sign() with straight-through estimator for quantization in training. VSA sign() is inherent to the model architecture (bipolar hypervectors), not a training trick. #354 singular fiber from STE gradient mismatch; #903 from binding zero-locus + superposition saturation. Different singularity mechanisms.

#396 (GLA discrete saturation): Gated linear attention with discrete saturation points. Saturation creates singular strata in attention weights. VSA superposition saturation is in REPRESENTATION space (bundling limit), not gate activation space. Different locus, different fiber geometry.

#868 (VQ-VAE quantization): Discrete codebook assignment creates piecewise-constant partition of latent space. VSA sign() also creates piecewise-constant partition. PARTIAL OVERLAP in mechanism (piecewise constant via quantization). KEY DISTINCTION: VQ-VAE uses k-means assignment (Voronoi cells, distance-based), VSA uses sign() (hyperplane partition, linear). VQ-VAE singularity from codebook collapse; VSA from normal-crossing divisor at binding zero-locus. Different algebraic geometry.

#134 (Attention toric fiber): Attention low-rank factorization creates toric variety singular fiber. VSA binding (elementwise multiply) creates normal-crossing divisor. Toric vs normal-crossing are distinct singularity types. Toric = monomial ideal, normal-crossing = union of coordinate hyperplanes. Novel distinction.

#613 (DropConnect masking): Coordinate hyperplane sections from Bernoulli masking. VSA zero-locus is ALSO union of hyperplanes. PARTIAL OVERLAP. KEY DISTINCTION: #613 hyperplanes are RANDOM (stochastic masking), #903 hyperplanes are STRUCTURAL (binding geometry, deterministic from E and x). #613 is in weight space, #903 in encoding/representation space. Different fiber origin.

### Novelty Assessment
- C1 (definability): STANDARD-NOVEL. R_an,exp definability of sign() is known from #354, but VSA-specific composition (encode+bind+superpose+readout) is novel.
- C2 (normal-crossing divisor fiber): GENUINELY NOVEL. First synthesis to identify binding zero-locus as normal-crossing divisor in HD space. Distinct from toric (#134), determinantal (#622), coordinate-section (#613).
- C3 (k as stratum selector with k*~0.18d): GENUINELY NOVEL. Capacity threshold from Kanerva (1997) connected to RLCT stratum selection. No prior SLT work on VSA capacity.
- C4 (gen bound with JL trade-off): GENUINELY NOVEL. Dimension-dependent lambda vs U(d) trade-off specific to random projection encoding.
- C5 (phase transition at k*): GENUINELY NOVEL. SLT phase transition prediction at superposition capacity threshold.

### Key Novel Contributions
1. FIRST SLT analysis of hyperdimensional computing / VSA
2. Normal-crossing divisor as singular fiber from binding operation (distinct from toric/determinantal)
3. Capacity threshold k*~0.18d as RLCT phase transition
4. JL-RLCT trade-off for optimal dimension d*
5. Sign partition combinatorics as RLCT determinant

### Verdict: NOVELTY PASSED. Zero prior SLT×VSA work. C1 standard-novel, C2-C5 genuinely novel.

### Pipeline Status
L0 -> L1 -> L2 (this file) -> L3 (MeTTa) -> L4 (summary) -> L5 (catalog)
