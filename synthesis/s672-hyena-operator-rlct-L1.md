## Synthesis #672: Hyena Operator × RLCT
## L1: Formalization

**Date:** 2026-10-28
**Status:** L1 DRAFT

---

### Formal Definitions

**D1 (Hyena Operator Components):** The Hyena operator H: R^T -> R^T for sequence length T is defined as a composition of L layers, each consisting of:
- (a) **Implicit kernel generator:** g_phi: R^d -> R^T, a small MLP with parameters phi mapping positional embedding p_t to filter coefficient h_t. The full filter h = (h_0, ..., h_{T-1}) = g_phi(p_0, ..., p_{T-T-1}).
- (b) **Long convolution:** (h * x)_t = sum_{s=0}^{T-1} h_s * x_{t-s mod T}, computed via FFT as IFFT(FFT(h) * FFT(x)).
- (c) **Data-controlled gating:** y = x ⊙ conv(h, x) where ⊙ is elementwise (Hadamard) product. The composition for L gates: y = H_1 ⊙ (H_2 ⊙ (... ⊙ (H_L ⊙ x)...)) where H_i denotes the convolution+gate operation at layer i.

All components are definable in R_{an,exp}: MLP with analytic activations (polynomial composition), FFT as fixed unitary matrix multiplication (linear, definable), Hadamard product (polynomial), composition of definable maps is definable.

**D2 (Implicit Kernel Fiber Map):** The implicit parametrization induces a map Pi: phi -> h from MLP parameters to filter coefficients. The fiber over a kernel h is F(h) = {phi : g_phi(p) = h}. The true kernel space is R^T (T-dimensional) but phi lives in R^d with d << T typically. The loss function K(phi) = L(g_phi(p), data) factors through Pi. The singular fiber of K is V_phi = {phi : K(phi) = K_min}; this is the preimage under Pi of the set of optimal kernels. The fiber structure is determined by the rank of the Jacobian dPi/dphi, which controls how parameter-space singularities map to kernel-space singularities.

**D3 (Multiplicative Gating Composition):** For L-layer Hyena, the output is y = H_1 ⊙ (H_2 ⊙ (... ⊙ (H_L ⊙ x)...)). Each H_i = conv(h_i, .) is a linear operator (Toeplitz matrix T_i in time domain, diagonal D_i in frequency domain). The composition in frequency domain is: Y[k] = D_1[k] * D_2[k] * ... * D_L[k] * X[k] (product of diagonal operators). This is a multiplicative product structure. The singular locus of the composition is S_comp = union_i {phi_i : h_i has a zero at frequency k} intersected with the data-dependent gating conditions. Product singularities arise when multiple gates simultaneously vanish at the same frequency, creating higher-order zeros.

**D4 (FFT as Unitary Conjugation):** The DFT matrix F_T is unitary (up to scaling): F_T^* F_T = T * I. The convolution h * x in time domain becomes elementwise multiplication in frequency domain: F_T(h * x) = F_T(h) ⊙ F_T(x). The loss function in frequency domain K_freq(theta) = K_time(F_T^{-1} * F_T(theta)) is related by a unitary change of coordinates. Since unitary maps are diffeomorphisms and preserve the definable structure (linear maps are in R_an), the RLCT is invariant: lambda_freq = lambda_time. The frequency-domain representation reveals the singularity structure as frequency-stratified: each frequency bin k has its own singular behavior determined by the product D_1[k] * ... * D_L[k].

**D5 (Sequence-Length Deformation Family):** For fixed parameters phi (MLP weights), increasing T requires the MLP to generate longer filters: g_phi must interpolate/extrapolate to T positions. Define the family K_T(phi) = L_T(g_phi^{(T)}, data_T) indexed by T. The deformation from K_T to K_{T+1} adds one frequency bin and one filter coefficient. The singular fiber V_T deforms as T grows. The stratum selector is T (or log T). Conjecture: lambda(T) ~ lambda_base + alpha * log(T) * lambda_gate, where lambda_gate is the per-gate RLCT contribution and the log scaling arises from the growing kernel-parameter dimension mismatch.

**D6 (Gate Composition Depth):** For L gates, the frequency-domain product D_1[k] * ... * D_L[k] creates a depth-L multiplicative singularity at each frequency k. If each gate has RLCT contribution lambda_i at frequency k, the composition RLCT is conjectured to satisfy: lambda_comp(k) <= sum_{i=1}^{L} lambda_i(k) (subadditivity from product structure). Diminishing returns: the marginal RLCT increase per additional gate decreases as O(1/L) due to the product structure concentrating singularity. The depth L acts as a secondary stratum selector (after T).

**D7 (Capacity-Compression Tension Functional):** The implicit parametrization creates a tension between kernel expressivity (needs dimension ~ T) and parameter efficiency (dimension d << T). Define the compression ratio rho = d/T. The singular fiber dimension scales as dim(V_phi) ~ d - rank(dPi/dphi). As rho -> 0 (large T, fixed d), the fiber becomes more degenerate (more parameters map to equivalent kernels), increasing RLCT. The tension functional is: C(rho) = lambda(rho) - lambda_explicit, measuring the RLCT gap between implicit and direct kernel learning. Conjecture: C(rho) ~ alpha * log(1/rho) = alpha * log(T/d).

### Claims with Proofs/Sketches

**C1 (PROVEN):** The Hyena operator loss K(theta) is definable in R_{an,exp}.
*Proof:* Each component is definable: (1) MLP g_phi with tanh/GELU activations is definable in R_an (semialgebraic + restricted analytic), (2) FFT is multiplication by fixed unitary matrix F_T, which is a linear map in R_an, (3) Hadamard product is polynomial, (4) composition of definable functions is definable (R_{an,exp} is closed under composition). The loss L(y, y_hat) = (1/n) sum ||y_i - y_hat_i||^2 is polynomial in theta. Therefore K(theta) is in R_{an,exp}. QED.

**C2 (CONJECTURAL):** The multiplicative gating composition creates product singularities with RLCT decomposition.
*Sketch:* In frequency domain, the product D_1[k] * ... * D_L[k] creates a multiplicative zero when any D_i[k] = 0. If each D_i[k] vanishes as a simple zero (order 1), the product vanishes at order equal to the number of simultaneously-vanishing gates. The RLCT of a product of L functions with independent zeros is bounded by the sum of individual RLCTs (Atiyah-Segal type result for product singularities). Gaps: (1) formal proof of subadditivity for this specific composition structure, (2) correlation structure between gates (gates may not vanish independently — data-controlled gating introduces dependence), (3) the Toeplitz structure of each conv operator constrains the zero set.

**C3 (CONJECTURAL):** The implicit kernel parameterization creates a singular fiber map with RLCT lower-bounded by direct kernel learning RLCT.
*Sketch:* The map Pi: phi -> h has rank r <= min(d, T). When r < T, the kernel space is not fully covered, creating a lower-dimensional manifold of achievable kernels. The loss K(phi) = L(Pi(phi)) inherits singularities from both the loss geometry in kernel space and the rank deficiency of Pi. By the pushforward theorem for RLCT under definable maps (Watanabe's theorem on RLCT under analytic maps), lambda_K <= lambda_direct * (something related to rank). Gaps: (1) exact form of the bound, (2) whether the MLP's expressivity (depth/width) changes the bound qualitatively, (3) comparison with #506 Hypernetwork where the generated weights are unstructured.

**C4 (PROVEN):** FFT preserves RLCT via unitary invariance.
*Proof:* The DFT F_T is a unitary linear map (up to scaling). Unitary maps are isometries and diffeomorphisms of R^T. Watanabe's RLCT invariance theorem states that RLCT is invariant under analytic diffeomorphisms that preserve the zero set of the loss. Since F_T is linear (hence analytic) and invertible, and the loss in frequency domain is K_freq = K_time composed with F_T^{-1}, the RLCT is preserved: lambda_freq = lambda_time. QED.
*Note:* This is stronger than the L0 conjecture — it follows directly from diffeomorphism invariance of RLCT.

**C5 (CONJECTURAL):** lambda(T) ~ lambda_base + alpha * log(T) * lambda_gate.
*Sketch:* As T grows with fixed d, the compression ratio rho = d/T -> 0. The implicit MLP must generate T filter coefficients from d parameters, creating increasing fiber degeneracy. The log(T) scaling is motivated by: (1) analogy to #233 Mamba's log(T) scaling (both involve growing sequence length with fixed parameters), (2) the information-theoretic argument that log(T) bits of "resolution" are needed to distinguish T frequency bins. Gaps: (1) the coefficient alpha is undetermined, (2) whether the scaling is log(T) or log(T/d) (log of compression ratio), (3) finite-T corrections, (4) whether data-controlled gating modifies the scaling.

### Open Problems

1. Formal proof of product singularity RLCT subadditivity under multiplicative gating composition (C2).
2. Tight bound on RLCT gap between implicit and explicit kernel parametrization as function of compression ratio rho = d/T (C3).
3. Correlation structure between data-controlled gates: does input-dependent gating make zeros independent or correlated?
4. Gate specialization: do different gates learn different frequency bands, creating frequency-stratified singular fibers with per-band RLCTs?
5. Comparison with #233 Mamba: is multiplicative product singularity structurally different from selective-scan piecewise singularity?
6. Comparison with #134 Attention: does Hyena's subquadratic convolution have fundamentally different RLCT from softmax attention?
7. Depth-L scaling law: is lambda_comp(L) ~ sum lambda_i (linear), or sublinear (diminishing returns), or logarithmic?

### Cross-References
#233 (Mamba/SSM), #134 (Attention), #317 (RetNet), #396 (GLA), #506 (Hypernetwork), #490 (RoPE), #151 (SSM toric fan), #215 (SSM standard SLT), #229 (KV Cache), #557 (Mamba dup)

### Key Novelties vs Prior Syntheses
- **Product singularity structure** (vs #233 Mamba's piecewise/selective singularity): Hyena's multiplicative gating creates product zeros, not branch-switching.
- **Implicit kernel fiber** (vs #506 Hypernetwork): Toeplitz/convolution structure constrains the generated weights, unlike general hypernetwork weight generation.
- **FFT unitary invariance** (C4 proven): The frequency domain is isomorphic to time domain for RLCT, but reveals frequency-stratified structure.
- **Capacity-compression tension** (D7): Novel functional relating parameter efficiency to singularity complexity.