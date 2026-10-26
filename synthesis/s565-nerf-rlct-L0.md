# Synthesis #565: NeRF (Neural Radiance Fields) × RLCT
## Date: 2026-10-23
## Status: L0 (Exploration)
## Candidate: SELECTED — zero catalog hits, zero SLT/RLCT bridge in websearch

### Motivation

Neural Radiance Fields (NeRF) represent a scene as a continuous MLP mapping (x, y, z, θ, φ) → (σ, c), where σ is volume density and c is RGB color. The rendering equation composites samples along each camera ray via alpha accumulation. The loss is a pixel-wise photometric error. This synthesis asks: what singular structure does NeRF's loss landscape have, and how does RLCT explain its generalization behavior?

### Key Singularity Sources

1. **Volume Rendering Integral**: The rendered color C(r) = ∫ T(t)σ(t)c(t) dt is an integral transform of the radiance field. The integration map is many-to-one: different (σ, c) fields can produce identical rendered images (non-identifiability). This creates a continuous fiber of parameter degeneracy — the "true" density field is only identifiable up to the null space of the rendering operator.

2. **Positional Encoding Fourier Features**: γ(x) = [sin(2^k πx), cos(2^k πx)] maps coordinates to high-dimensional Fourier space. At k=0, γ collapses to a single frequency — the encoding map has a critical singularity where frequency components degenerate. The number of encoding frequencies L acts as a **stratum selector**: low L → smooth field → high degeneracy (many scenes map to same rendered output) → high λ; high L → high-frequency detail → low λ but more parameters. U-shaped RLCT predicted in L.

3. **Ray-Marching Discretization**: The continuous integral is approximated by a finite sum over N sample points. The discretization error introduces a piecewise structure — the loss landscape changes character at N-dependent resolution thresholds. N acts as a secondary stratum selector.

4. **Opacity Saturation Singularity**: When σ(t) → ∞ at a point, T(t) → 0 for all subsequent points, making their contributions vanish. This creates a boundary singularity: the set of parameters where opacity saturates forms a discriminant variety where the gradient of rendered color w.r.t. those parameters is zero.

5. **View-Dependent Color Singularity**: c(x, d) depends on viewing direction d. At normal incidence (d·n = 0 for surface normal n), the color function may have mirror symmetry — specular reflections create non-identifiability in the angular color field.

### Claims

- **C1 (PROVABLE)**: The NeRF rendering loss is definable in R_{an,exp}. The MLP is analytic; positional encoding uses sin/cos (R_{an,exp} functions); volume rendering integral is an integral of analytic functions (definable by o-minimal integration); pixel MSE is polynomial. Composition closure gives definability.

- **C2 (CONJECTURAL)**: Singular fibers arise from (a) rendering operator null space (multiple density fields → same image), (b) positional encoding degeneracy at frequency collapse, (c) opacity saturation discriminant variety, (d) view-dependent color angular symmetry.

- **C3 (CONJECTURAL)**: Positional encoding frequency count L acts as stratum selector with U-shaped RLCT: λ(L) high at small L (coarse field, high degeneracy), decreases with L, but optimal L* exists where capacity-degeneracy tradeoff is balanced.

- **C4 (CONJECTURAL)**: Generalization bound G(L, N) ≤ C·λ(L, N)/n where λ depends on both encoding resolution L and ray sampling density N. The rendering operator's null space inflates λ beyond the MLP's intrinsic complexity.

- **C5 (CONJECTURAL)**: Ray-marching discretization creates a phase transition: below critical N*, the loss landscape has additional singular strata from aliasing artifacts; above N*, these merge into the continuous-integral singular structure.

### Distinguishing from Prior Syntheses

- **#224/#490/#504 (RoPE/positional encoding in attention)**: Those address PE in the attention mechanism (rotary/ALiRoPE). NeRF's PE is fundamentally different — it encodes continuous 3D spatial coordinates into Fourier features for a radiance field, not token positions for attention. The singularity structure is in the spatial field, not the sequence dimension.
- **#214 (Neural Operators)**: Neural operators learn function-to-function maps in spectral space. NeRF learns a coordinate-to-radiance map with volume rendering. Different fiber structure.
- **#515 (VAE)**: VAE has encoder-decoder with KL regularization. NeRF has no encoder — the "latent" is the 3D coordinate itself.
- **#556 (VQ-VAE)**: Discrete codebook singularities via Voronoi cells. NeRF has continuous coordinate space.

### Open Problems

1. Formal computation of the rendering operator's null space and its contribution to λ
2. Empirical SGLD estimation of NeRF RLCT as function of L (encoding frequencies)
3. Opacity saturation variety: is it a smoothable singularity?
4. Multi-scene NeRF (scene latent codes): compound fiber structure
5. NeRF vs 3D Gaussian Splatting: Gaussian mixture singularities vs MLP singularities
6. Sparsity / empty space: how does the void (σ=0 everywhere) contribute to singular fiber structure?
7. Joint λ(L, N) optimization: is the U-shape in L preserved across N?

### Cross-References
#214 (neural operators), #224/#490/#504 (positional encoding in attention), #515 (VAE), #556 (VQ-VAE), #161/#85 (GNN), #97/#251 (neural ODE), #565 (this synthesis)