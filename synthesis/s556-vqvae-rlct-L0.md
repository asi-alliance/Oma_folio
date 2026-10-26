# Synthesis #556: VQ-VAE (Vector Quantized Variational Autoencoder) × RLCT

## Date: 2026-10-23
## Status: L0 (sketch + claims). C1 PROVEN, C2-C5 CONJECTURAL.

## Topic
Vector Quantized Variational Autoencoders (VQ-VAE) replace the continuous
latent space of a VAE with a discrete codebook via nearest-neighbor
quantization. The encoder outputs continuous vectors z_e(x), each mapped
to the nearest codebook entry e_k by argmin_k ||z_e - e_k||^2. The decoder
reconstructs from the quantized code z_q. Training uses the straight-through
estimator (STE) for the non-differentiable argmin, plus a commitment loss
||z_e - sg[e_k]||^2 and codebook loss ||sg[z_e] - e_k||^2.

## RLCT Bridge: Why VQ-VAE Creates Singularity

The quantization map Q(z) = argmin_k ||z - e_k||^2 is a **piecewise constant**
function. It partitions latent space into Voronoi cells V_k, each mapping
to a single codebook vector e_k. The loss landscape is:

L(θ, E) = E_x[||x - D(Q(E(x)))||^2] + ||sg[E(x)] - e_k||^2 + β||E(x) - sg[e_k]||^2

where E = encoder, D = decoder, E = {e_1,...,e_K} = codebook.

**Singularity sources:**
1. **Voronoi boundaries**: where ||z - e_i|| = ||z - e_j||, the argmin is
   non-differentiable. The loss landscape has gradient discontinuities across
   these codim-1 hyperplanes. This creates a non-smooth singular locus.

2. **Codebook collapse / dead codes**: when e_k is never the nearest neighbor
   for any input, gradient flow to e_k vanishes. The codebook effectively
   shrinks from K to K_eff < K. Dead codes create degenerate fibers where
   the loss is locally insensitive to e_k parameters.

3. **STE surrogate gradient**: the straight-through estimator replaces the
   true (non-existent) gradient of argmin with identity. This creates a
   mismatch between the surrogate loss landscape (smooth, STE-based) and the
   true loss landscape (piecewise constant, non-smooth). The surrogate
   landscape's singularities may differ from the true landscape's.

4. **Commitment loss scale β**: controls how tightly encoder outputs are
   pulled toward codebook entries. Large β → all z_e collapse to nearest
   e_k (discrete manifold), small β → z_e drift away from codebook
   (continuous manifold). β acts as a regularization parameter selecting
   between singular regimes.

## Formal Claims

### C1 (PROVEN): R_{an,exp}-Definability
The VQ-VAE loss is piecewise R_{an,exp}-definable. Within each Voronoi cell
V_k, the quantization is constant (Q(z) = e_k), so the reconstruction loss
||x - D(e_k)||^2 is R_{an,exp}-definable (composition of analytic decoder
with constant codebook entry). The commitment and codebook losses are
quadratic (algebraic). The full loss is a finite union of definable functions
over definable sets (Voronoi cells are semi-algebraic), hence R_{an,exp}-
definable by closure under finite union. QED.

### C2 (CONJECTURAL): Voronoi Boundary Singular Fibers
The Voronoi boundary ∂V_{ij} = {z : ||z - e_i|| = ||z - e_j||} is a codim-1
semi-algebraic set where the loss landscape has a gradient discontinuity.
Points (θ, E) where encoder outputs lie exactly on ∂V_{ij} form singular
fibers: the loss is locally non-differentiable, and the fiber dimension
increases because perturbations along ∂V_{ij} do not change the quantized
output. RLCT λ at such boundary fibers is predicted to be higher than
interior fibers. The singularity is analogous to the ReLU kink singularity
(#8) but in the latent-to-codebook mapping rather than the activation map.

### C3 (CONJECTURAL): Codebook Size K as Stratum Selector
K controls the Voronoi tessellation granularity. Small K → large cells,
coarse quantization, fewer boundary singularities but higher quantization
error. Large K → small cells, many boundary singularities, risk of dead
codes. K acts as a stratum selector: each K defines a different algebraic
variety (different Voronoi partition), and the RLCT λ(K) is predicted to
be non-monotonic. The effective codebook size K_eff ≤ K (after dead code
collapse) is the true selector. K_eff/K ratio measures codebook utilization.

### C4 (CONJECTURAL): Generalization Bound with Quantization Bias
Gen error G(K) ≤ λ(K_eff)·log(n)/(2n) + B(K,K_eff), where B(K,K_eff) is
a quantization bias term measuring the information loss from dead codes
and cell coarseness. B increases with K - K_eff (dead codes waste capacity
without reducing loss). U-shape predicted: small K → high B (under-quantized),
large K → high λ (many boundary singularities + dead code degeneracy),
optimal K* minimizes λ·log(n)/2n + B. Distinct from #515 VAE (continuous
latent, no Voronoi boundary singularity).

### C5 (CONJECTURAL): Codebook Collapse Phase Transition
At critical ratio (K*/n)*, codebook utilization undergoes a phase transition:
below K*/n*, all codes are active (K_eff = K); above K*/n*, dead codes
emerge (K_eff < K). This is testable via SGLD: measure LLC along training
trajectory for different K. Predicted: LLC shows a kink at K*/n* where
dead codes appear, analogous to capacity phase transitions in #362 (#434
MoE expert count). The commitment loss β modulates the transition:
high β pushes the transition to smaller K*/n* (more aggressive collapse).

## Distinction from Prior Syntheses
- #515 (VAE × RLCT): continuous latent, no quantization singularity
- #354 (STE × RLCT): focuses on STE gradient, not Voronoi geometry
- #372 (deep supervision × RLCT): different non-smoothness source
- #434 (MoE × RLCT): expert routing is softmax (smooth), VQ is argmin (discrete)
- #8 (ReLU × RLCT): kink in activation, not in latent quantization
- #362 (CFG depth): depth-based stratum selector, not codebook size

## Open Problems
1. Exact RLCT of piecewise constant loss: does the Voronoi boundary
   contribute a distinct λ term, or is it absorbed into the encoder/decoder
   singularity?
2. Dead code dynamics: is codebook collapse a bifurcation (sudden) or
   gradual? Does SLT predict the K*/n* critical ratio?
3. STE vs true gradient: does the surrogate loss landscape have the same
   RLCT as the true (non-smooth) landscape? If not, which controls
   generalization?
4. VQ-VAE-2 (hierarchical): multi-scale codebooks create nested Voronoi
   tessellations. Does each level contribute independent singular strata?
5. Finite Scalar Quantization (FSQ): replaces argmin with round-to-grid.
   Does rounding singularity differ from Voronoi boundary singularity?
6. Codebook EMA updates (VQ-VAE from encoder outputs, not gradient descent):
   does this change the singular structure vs gradient-based codebook updates?
7. Relationship to #354 STE: the STE gradient mismatch creates a "phantom"
   loss landscape. Is the true RLCT that of the phantom or the real landscape?

## Cross-References
#8 (ReLU) #16 (loss landscape) #100 (SGLD) #127 (GAN) #168 (posterior collapse)
#354 (STE) #362 (CFG depth) #372 (deep supervision) #434 (MoE routing)
#515 (VAE) #241 (gradient clipping boundary) #234 (temperature scaling)
#393 (contrastive decoding) #553 (grad accum U-shape)
