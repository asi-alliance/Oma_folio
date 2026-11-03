# Synthesis #823: MLP-Mixer × RLCT - L4 Summary
# Date: 2026-11-03
# Pipeline: L0-L3 COMPLETE | L4 summary

## Plain-Language Summary

MLP-Mixer replaces attention with two alternating MLPs: one mixes across spatial tokens (token-mixing), the other mixes across channels (channel-mixing). This synthesis applies the Singularity Learning Theory (SLT) / Real Log Canonical Threshold (RLCT) framework to analyze the singular geometry of MLP-Mixer's loss landscape.

**Key insight:** Token-mixing and channel-mixing each carry a permutation symmetry group — S_N (spatial) and S_C (channel). Their sequential composition creates a product orbifold singularity S_N × S_C with an interaction term λ_int beyond simple additive log(N!) + log(C!).

## Claims

- **C1 PROVEN**: MLP-Mixer loss is R_{an,exp}-definable. Matrix multiplications W_1@X and W_2@X̃^T are polynomial, GELU/ReLU subanalytic, softmax involves exp — all closed under composition.

- **C2 CONJECTURAL**: Dual permutation orbifold S_N × S_C creates a product fiber with λ_int > 0 interaction correction. Orbifold strata dimensions and transversality unproven.

- **C3 CONJECTURAL**: Stratum selector R = S/C controls which symmetry dominates. R=1 maximizes interaction complexity (both fibers break simultaneously).

- **C4 CONJECTURAL**: Generalization bound λ_MM ≈ log(N!) + log(C!) + L·d(S×C)² with dual symmetry correction exceeding either fiber alone.

- **C5 CONJECTURAL**: Phase transition at R=1 manifests as SGLD LLC step decrease when both fibers resolve.

## Key Novel Contributions

1. First product orbifold S_N × S_C analysis in sequentially composed architecture
2. λ_int interaction term beyond additive fiber contributions
3. Stratum selector R = S/C as geometric control parameter
4. Gen bound with dual symmetry complexity correction
5. Non-trivial interaction from sequential composition (token-mixing outputs feed channel-mixing)

## Open Problems

1. Equivariance and fiber resolution via SGLD for dual spatial+channel fibers
2. Dimensional stratification of S_N × S_C orbifold (Mackay stratification applicability)
3. Are token-mixing and channel-mixing RLCTs isomorphic or distinct?
4. Connection to sparse MLP (#545): does dual symmetry create sparsity?
5. Connection to MoE (#434): discrete gating vs continuous mixing complementarity

## Cross-References

#496 (CoT), #434 (MoE), #500 (Token Merging), #546 (BPE), #545 (sparse MLP), #169 (dropout), #490 (RoPE), #221 (BatchNorm), #468 (PPO clip), #822 (Manifold Mixup)
