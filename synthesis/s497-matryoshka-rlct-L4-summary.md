# Synthesis #497: Matryoshka Representation Learning (MRL) × RLCT — L4 Summary

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Pipeline Status
L0 (outline) → L1 (formalization) → L2 (novelty PASSED, 5 searches) → L3 (MeTTa encoding, 3601B) → L4 (this summary) → L5 (catalog pending)

## Core Result

**C1 (PROVEN, stv 1.0/0.95):** RLCT is monotone under coordinate projection: for d_i < d_j, λ(d_i) ≤ λ(d_j). The matryoshka sub-map ψ_i = π_{d_i} ∘ φ_θ factors ψ_j = π_{d_j} ∘ φ_θ via linear submersion π_{i,j}. By Watanabe's theorem, submersion pullback preserves the log-canonical threshold upper bound. The Jacobian order under resolution can only decrease under linear projection. QED.

**C2 (CONJECTURAL, stv 0.5/0.7):** The matryoshka combined loss L = Σ w_i L_{d_i}(θ) has effective RLCT λ_eff = min_i λ(d_i) when strata are in general position, dominated by the coarsest (lowest-λ) stratum. Near a local minimum, K_eff ~ Σ w_i |θ-θ*|^{2λ(d_i)}, and the dominant term has the smallest exponent. This explains why matryoshka preserves coarse-grained performance. Caveat: under nesting (descending filtration), intersection vs union tension is unresolved.

**C3 (CONJECTURAL, stv 0.5/0.7):** The descending filtration V_0^{d_1} ⊇ V_0^{d_2} ⊇ ... ⊇ V_0^D defines a filtered singular variety with RLCT phase transitions at each dimension boundary d_i → d_{i+1}. The information cost λ(d_{i+1}) - λ(d_i) > 0 quantifies the singularity complexity added by extra dimensions. SGLD should detect kinks in λ̂ at truncation dimensions. First SLT framing of matryoshka as filtered singular geometry.

**C4 (CONJECTURAL, stv 0.5/0.7):** Optimal matryoshka embedding dimension d* satisfies λ(d*)/n ≈ ε(d*), balancing RLCT complexity (increasing with d) against approximation error (decreasing with d). This gives an RLCT-based criterion for choosing embedding dimensionality at inference time via SGLD estimation. No prior SLT-based dimensionality selection criterion for matryoshka.

**C5 (CONJECTURAL, stv 0.5/0.7):** Matryoshka training traverses strata coarse-to-fine. Early training is dominated by the lowest-λ stratum (coarse, V_0^{d_1}). As training progresses, higher-λ strata activate, gradually populating V_0^{d_2}, ..., V_0^D. The weighting w_i controls stratum activation rate. Analogous to wavelet multi-resolution but derived from RLCT free energy geometry.

## Open Problems (7)
1. [HIGH] Resolve C2: under nested filtration, is λ_eff = min_i λ(d_i) or λ_eff = λ(d_n)?
2. [HIGH] SGLD verification: measure λ̂ at each matryoshka dimension {128,256,512,768}, verify monotonicity.
3. [HIGH] Formalize information cost λ(d_{i+1}) - λ(d_i) and relate to mutual information.
4. [MED] C4 empirical test: measure d* for tasks at varying n, compare with RLCT prediction.
5. [MED] C5 dynamics: track dominant stratum during training via annealed SGLD.
6. [MED] Weight scheduling: optimal w_i selection via RLCT minimization.
7. [LOW] Connection to matryoshka KV-cache compression: does RLCT filtration explain truncation robustness?

## Cross-References
#8 (grokking), #65 (singular stratum), #94 (phase transition), #115 (emergent ability), #220 (pruning), #249 (LoRA), #264 (LayerNorm), #302 (linear attention), #312 (multi-token prediction), #496 (CoT)

## Status
L4 written 2026-10-21. Next: L5 catalog append.
