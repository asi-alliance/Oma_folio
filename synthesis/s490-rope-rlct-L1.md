# Synthesis #490: RoPE (Rotary Position Embedding) × RLCT — L1 Formalization

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Formal Definitions

**D1 (RoPE Rotation Map).** For position k and dimension pair i (i = 0, ..., d/2-1), the rotation angle is θ_i(k) = k · base^{-2i/d} where base is a fixed constant (typically 10000). The rotary matrix R_k ∈ R^{d×d} is block-diagonal: R_k = diag(R(θ_0(k)), R(θ_1(k)), ..., R(θ_{d/2-1}(k))) where each 2×2 block R(θ) = [[cos θ, -sin θ], [sin θ, cos θ]]. The functions cos, sin are restricted analytic (R_an-definable), base^{-2i/d} = exp(-(2i/d) log(base)) is R_an,exp-definable, and k is integer-valued (semialgebraic). Hence R_k is R_an,exp-definable.

**D2 (Rotary Attention).** Given query q_i ∈ R^d and key k_j ∈ R^d at positions i, j, the RoPE-modified attention score is:
S(i,j) = Re[⟨R_i q_i, R_j k_j⟩] = Σ_{l=0}^{d/2-1} Re[q_i^{(2l)} k_j^{(2l)*} e^{i(θ_l(i) - θ_l(j))}]
= Σ_l [q_i^{(2l)} k_j^{(2l)} cos(θ_l(i) - θ_l(j)) - q_i^{(2l+1)} k_j^{(2l+1)} sin(θ_l(i) - θ_l(j))]
This is a sum of products of definable functions (cos, sin, linear forms), hence R_an,exp-definable. The full attention A(i,j) = softmax(S(i,j)/√d_k) inherits definability from exp and the definable scores.

**D3 (SO(d/2) Gauge Fiber).** The rotation group G = SO(2)^{d/2} acts on the parameter space by global phase rotation: for g = (φ_0, ..., φ_{d/2-1}) ∈ G, the transformed parameters are q' = R(φ) q, k' = R(φ) k where R(φ) applies rotation φ_l to dimension pair l. The attention score S(i,j) depends only on differences θ_l(i) - θ_l(j), so a global rotation φ_l → φ_l + ψ for any ψ leaves S(i,j) invariant. This creates a continuous fiber F_gauge = {R(ψ) w : ψ ∈ R^{d/2}} of dimension d/2 (one free rotation angle per pair). The quotient space W/G has dimension d - d/2.

**D4 (Loss Function).** The RoPE-equipped Transformer loss for a sequence of N tokens is:
K(w) = -(1/N) Σ_{s=1}^{N} log p_w(y_s | y_{<s})
where p_w(y_s|...) = softmax(ffn(h_s) · e_{y_s}) and h_s is computed through L layers of rotary attention. Cross-entropy -log softmax is R_an,exp-definable (exp + log). The full loss K(w) is a finite sum of definable functions composed through L layers, hence R_an,exp-definable.

**D5 (Singular Fiber).** The singular fiber is:
V_0 = {w ∈ W : K(w) = K(w*, t) for the true distribution}
= {w : p_w(y_s|...) = q(y_s|...) for all s, all sequences}
The gauge fiber F_gauge ⊂ V_0 since any global rotation leaves attention scores invariant. Additionally, frequency-dependent degenerate strata V_i = {w : θ_i(k) ≈ 0 for all k} (near-identity rotation for pair i) create rank-deficient sub-fibers where the positional information from pair i is lost.

**D6 (RLCT).** The Real Log Canonical Threshold for RoPE-equipped models is:
λ_RoPE(w) = max_{w' ∈ V_0} RLCT_{w'}(K(w))
The gauge fiber quotient reduces the effective dimension: λ_RoPE = λ_base - (d/2)·c where c measures the fiber's contribution to the RLCT. The frequency-stratified structure means λ_RoPE = Σ_i λ_i where λ_i is the per-pair contribution, with λ_i being U-shaped in frequency index i.

**D7 (Frequency Stratum Selector).** The frequency index i ∈ {0, ..., d/2-1} serves as a stratum selector. Define the stratum V_i = {w ∈ V_0 : pair i dominates the positional encoding structure}. The effective RLCT on stratum V_i is λ_i. Low-frequency pairs (i near d/2, θ_i ≈ k·base^{-1} ≈ 0) create near-identity rotations (degenerate, high λ_i from rank deficiency). High-frequency pairs (i near 0, θ_i ≈ k·base^{0} = k) create rapid rotation with potential aliasing (high λ_i from aliasing singularities). Mid-frequency pairs create smooth rotations (lowest λ_i).

## Formal Claims

**C1 (PROVEN): R_an,exp-definability of K(w).**

*Proof.* By structural induction:
1. Token embeddings are constants (no parameters in R_k).
2. Rotation angles θ_i(k) = k·base^{-2i/d} = k·exp(-(2i/d)·log(base)). The functions exp and log are in R_an,exp, k is semialgebraic, multiplication is polynomial. Hence θ_i(k) is R_an,exp-definable.
3. Rotation blocks R(θ) = [[cos θ, -sin θ], [sin θ, cos θ]]. cos and sin are restricted analytic (R_an-definable). Matrix entries are definable.
4. Rotary attention S(i,j) = Σ_l [q_i^{(2l)} k_j^{(2l)} cos(Δθ_l) - q_i^{(2l+1)} k_j^{(2l+1)} sin(Δθ_l)] where Δθ_l = θ_l(i) - θ_l(j). Each term is a product of definable functions. Finite sum preserves definability.
5. Softmax A(i,j) = exp(S(i,j)/√d_k) / Σ_j' exp(S(i,j')/√d_k) is R_an,exp-definable (exp + division by definable nonzero).
6. Feedforward layers: linear maps (polynomial), ReLU (subanalytic/R_an), layer norm (polynomial + sqrt = R_an). Composition preserves definability.
7. Cross-entropy -log softmax(v · e_y) involves exp and log, both in R_an,exp.
8. K(w) = (1/N) Σ_s [-log softmax(...)] is a finite sum of definable functions, hence definable.

Therefore K(w) is R_an,exp-definable. QED.

**C2 (CONJECTURAL): SO(d/2) gauge fiber reduces RLCT.**

The gauge group G = SO(2)^{d/2} acts freely on parameter space (away from rank-deficient strata). The attention score S(i,j) depends only on θ_l(i) - θ_l(j), invariant under global rotation φ_l → φ_l + ψ. The fiber F_gauge has dimension d/2 (one free angle per pair). Conjecture: the RLCT of the quotient W/G satisfies λ_{W/G} = λ_W - (d/2)·c for some c > 0 related to the fiber's singularity contribution. This is lower than additive PE (no gauge symmetry, no fiber reduction) and learned PE (discrete lookup, non-smooth, no continuous gauge). The gauge fiber is structurally distinct from #86 (permutation symmetry, discrete) and #371 (GL(r) gauge, full-rank only).

**C3 (CONJECTURAL): Frequency index i as stratum selector.**

At i = d/2-1 (lowest frequency), θ_i(k) ≈ k·base^{-1} ≈ 0 for moderate k, creating near-identity rotations. The pair contributes no positional information, creating a rank-deficient sub-fiber (high λ_i). At i = 0 (highest frequency), θ_i(k) = k, creating rapid rotation and potential aliasing (θ wrapping mod 2π), creating aliasing singularities (high λ_i). At mid-frequencies, rotations are smooth and non-degenerate (lowest λ_i). Conjecture: λ_i is U-shaped in i, with minimum at mid-frequencies. This is testable via SGLD by ablating frequency pairs.

**C4 (CONJECTURAL): Generalization bound with rotation fiber.**

Standard RLCT bound: G(n) ≤ C·λ_RoPE/n + U/√n. The gauge fiber reduces λ_RoPE below the no-gauge baseline (additive PE). For context length L > L_train, new rotation angles θ_k access unexplored singular strata, increasing λ: G(n, L) ≤ C·λ_RoPE(L)/n + U(L)/√n where λ_RoPE(L) > λ_RoPE(L_train) for L > L_train. Conjecture: the extrapolation penalty scales as Δλ(L) ~ (L/L_train)^{α} for some α > 0 related to the frequency spectrum density.

**C5 (CONJECTURAL): Context length phase transition at L*.**

There exists L* where RoPE transitions from smooth (λ within trained stratum) to singular (λ spikes from unexplored strata). Below L*: all θ_k for k ≤ L remain within the smooth stratum seen during training. Above L*: new θ_k values access singular strata, causing a phase transition in λ. Detectable via SGLD on the loss landscape as context length increases. Conjecture: L* depends on base frequency and training distribution. Position interpolation methods (NTK-aware, YaRN) shift L* by rescaling the frequency spectrum.

## Open Problems

1. [HIGH] Exact RLCT of the SO(d/2) gauge fiber for specific architectures — is the reduction exactly d/2·c?
2. [HIGH] Prove or disprove U-shape of λ_i vs frequency index i — is the aliasing singularity real or artifact?
3. [HIGH] SGLD protocol: measure λ_i by ablating frequency pairs, verify U-shape
4. [HIGH] Formal derivation of L* from base frequency and training distribution
5. [MEDIUM] RoPE variants (NTK-aware, YaRN, position interpolation) — do they shift L* or change λ_i shape?
6. [MEDIUM] Multi-head RoPE: independent frequency strata per head? Does head diversity reduce overall λ?
7. [LOW] Infinite context limit L→∞: does λ converge or diverge? Connection to ergodicity of rotation.

## Cross-References

#224 (Positional Encoding × RLCT — parent synthesis, RoPE claim C2 there formalized here), #8 (softmax definability), #16 (attention sharing), #134 (self-attention Q/K non-identifiability), #379 (RWKV position decay vs rotation), #233 (Mamba/SSM state-space position), #485 (RLT recurrent sharing)

## Status

L1 written 2026-10-21. Next: L2 novelty verification.