# Oma Synthesis #574: Perceiver IO × RLCT

## L0: Hypothesis & Claims

**Date:** 2026-10-23  
**Candidate:** Perceiver IO (Jaegle et al. 2021) × Singular Learning Theory (Watanabe 2009)

---

### Architecture Summary

Perceiver IO replaces standard self-attention with an asymmetric cross-attention bottleneck:
- Input array X ∈ R^{N×d} (N potentially very large)
- Latent array Z ∈ R^{M×d} (M fixed, M << N)
- Cross-attention: Q = ZW_Q, K = XW_K, V = XW_V; A = softmax(QK^T/√d)V ∈ R^{M×d}
- Latent array Z serves as learned queries; input X serves as keys/values
- Iterative: multiple cross-attention + latent self-attention layers
- Decoder: another cross-attention from latent to output space

### Key Insight

The asymmetric cross-attention projects N inputs to M latents (M << N). This is a **quotient projection** — many input configurations map to the same latent representation. The fiber over a latent z is the equivalence class {X : CrossAttn(Z, X) = z}. This creates a **quotient-type singularity** in the loss landscape.

### Claims

**C1 (PROVEN):** The Perceiver IO cross-attention map is definable in R_{an,exp}. The function f(Z, X, W) = softmax((ZW_Q)(XW_K)^T/√d)(XW_V) is a composition of: matrix multiplication (polynomial), scaling (polynomial), softmax (analytic: exp/sum of exps, definable in R_{an,exp}), and iterated cross-attention layers (composition closure). The decoder cross-attention is similarly definable. Therefore the full Perceiver IO forward pass is R_{an,exp}-definable, satisfying Watanabe's conditions for SLT applicability.

**C2 (CONJECTURAL):** The cross-attention bottleneck creates a quotient-type singular fiber. Define the latent map π_W: X → CrossAttn(Z_W, X) = softmax(Z_W W_Q)(X W_K)^T/√d)(X W_V). For fixed Z, W, the fiber F_z = {X : π_W(X) = z} is generically (N-M)-dimensional (M constraints on N×d variables). The loss L(W) = ℓ(Decode(π_W(X), Y)) has singular locus where the Jacobian dπ_W/dW drops rank — i.e., where the projection becomes degenerate. The RLCT of this singular fiber governs the generalization gap via Watanabe's free energy formula.

**C3 (CONJECTURAL):** Latent array size M acts as a continuous stratum selector. As M increases, the quotient projection π_W becomes less compressive, the fiber dimension (N-M) shrinks, and the effective RLCT λ(M) increases. There exists a phase transition M* where the model transitions from "compressed" (low λ, information-lossy) to "sufficient" (high λ, near-full-rank). This predicts: (a) generalization improves then saturates as M increases past M*, (b) the RLCT jump at M* is detectable via SGLD/LLC estimation, (c) M* scales with intrinsic dimensionality of the input distribution.

**C4 (CONJECTURAL):** Iterative cross-attention layers create **repeated quotient projections** — each layer re-projects the latent through a new cross-attention bottleneck. This creates a tower of quotient singularities: the composed fiber is the preimage of the first projection intersected with the fiber of the second. Under transversality, the RLCT of L layers satisfies λ_L ≤ L·λ_1 (subadditivity), but when projections are aligned (same effective subspace), λ_L = λ_1 (no additional complexity). The depth L thus acts as a secondary stratum selector via fiber composition.

**C5 (CONJECTURAL):** Generalization bound. For Perceiver IO with latent size M, depth L, the generalization gap scales as G ~ λ(M,L)/n where λ(M,L) is the RLCT of the composed quotient fiber. The bound exhibits a tradeoff: smaller M reduces λ (better generalization) but increases approximation error (worse fit). The optimal M* minimizes the sum of approximation error and generalization gap, analogous to the bias-variance tradeoff but grounded in RLCT rather than VC dimension.

### Distinctions

- **#134 (Self-Attention × RLCT):** Standard self-attention has N=Q=K=V — no compression, no quotient projection. Perceiver IO's asymmetry (M queries vs N keys) is the novel singularity source.
- **#545 (Sparse Attention × RLCT):** Sparse attention constrains the attention pattern but doesn't compress — still N→N. Perceiver IO compresses N→M.
- **#342/#434 (GQA × RLCT):** GQA shares K,V heads — reduces KV parameters but doesn't reduce the query count or create input compression.
- **#302 (Linear Attention × RLCT):** Linear attention changes the kernel computation but maintains N→N mapping.
- **#251 (Neural ODE × RLCT):** Continuous-depth flow singularity, not quotient compression.

### Open Problems

1. Formal characterization of the fiber F_z — is it generically a smooth manifold of dimension (N-M)·d, or does it have singular strata within?
2. How does the learned latent array Z_W interact with the quotient structure — is Z a parameter or a learned prior on the quotient?
3. Empirical LLC estimation: does λ(M) show a detectable phase transition at M*?
4. Connection to rate-distortion: the N→M compression is an information bottleneck — does RLCT connect to the rate-distortion function?
5. Decoder cross-attention: does the M→output projection create a dual singularity?
6. Multi-modal Perceiver: when inputs from different modalities are concatenated, does the quotient fiber decompose into modality-specific sub-fibers?
7. Relationship to #273 (Data Pruning × RLCT): both involve compression/subsampling — is the latent array a learned coreset?

### Cross-References

#134 (self-attention RLCT), #302 (linear attention), #545 (sparse attention), #342/#434 (GQA), #251 (Neural ODE), #273 (data pruning), #223 (LoRA determinantal), #240 (weight tying quotient), #232 (model soup fibers), #568 (ResNet), #562 (stochastic depth)
 `