# Synthesis #592: NovoGrad × RLCT L4 Summary

Date: 2026-10-24

# Plain-Language Summary

NovoGrad normalizes gradients by their per-layer L2-norm rather than per-element (Adam) or per-block (K-FAC). In SLT terms, this creates a fundamentally different singular fiber geometry: each layer contributes a codim-n_k null locus (all layer-k gradient coordinates vanish), vs Adam's codim-1 per-element fibers.

## Claims Recap

- **C1 (PROVEN)**: NovoGrad update is R_{an,exp}-definable. Gradient norms are algebraic; division is rational on open stratum; EMA is linear recursion. Standard closure argument.
- **C2 (CONJECTURAL)**: Per-layer singular fiber V_L(k) = {||∇_{θ_k} L_n|| = 0} has codim n_k, much higher than Adam's codim 1. This means NovoGrad's singular locus is "thinner" — fewer parameters drive singular behavior.
- **C3 (CONJECTURAL)**: Layer-norm ratio r(θ) = (||g_1||/ḡ, ..., ||g_M||/ḡ) acts as continuous stratum selector. Low-ratio layers expand (probe singular structure), high-ratio layers freeze. First-order, distinct from K-FAC (second-order Fisher) and AdaBelief (instrumental discrepancy).
- **C4 (CONJECTURAL)**: Generalization bound G ~ λ_NovoGrad/n + U(l(θ))/√n. Desingularization map φ: g_k → g_k/||g_k|| rescales layers to unit norm. When layer norms uniform, φ ≈ identity, λ_NovoGrad ≈ λ_SGD. When heterogeneous, φ overcorrects, raising λ.
- **C5 (CONJECTURAL)**: Phase transition at critical ratio r*. For r_k > r*, layer k frozen; for r_k < r*, layer k active. SGLD-detectable kink in RLCT estimate at r*. Architecture-dependent: deeper networks with heterogeneous norms have lower r*.

## Key Novel Contributions

1. **Per-layer singular fiber**: codim n_k >> codim 1 (Adam). First formal SLT characterization of layer-wise gradient normalization geometry.
2. **First-order stratum selector**: gradient L2-norm ratio, distinct from all prior selectors (Bernoulli, Fisher, belief discrepancy).
3. **Rank-1 projection interpretation**: NovoGrad projects rank-n_k gradient to rank-1 (unit-norm direction), creating a non-trivial desingularization map.
4. **Layer-norm desingularization tension U(l)**: captures misalignment between normalization and optimal desingularization direction when loss gradient not spherically symmetric.
5. **Architecture-dependent phase transition r***: testable prediction — deeper networks freeze more layers earlier.

## Open Problems

1. Is V_L(k) irreducible as analytic variety?
2. Prove/disprove: λ_NovoGrad ≤ λ_SGD when layer norms uniform.
3. Formalize φ as definable desingularization morphism.
4. Derive U(l) from projection geometry of layer-norm-to-fiber map.
5. SGLD experiment design: detect kink at r* across architectures.
6. Is NovoGrad a rank-1 approximation of K-FAC per-layer Fisher norm?
7. Weight decay interaction with normalization (cf. #282).
8. Per-layer product fiber structure vs depth/recurrent weight sharing (#485).

## Cross-Refs

#8 Adam, #100 SGD, #186 RMSProp, #282 Weight Decay, #298 Orthogonal Init, #304 Adam L0-L4, #420 LayerScale, #436 AdaBelief, #484 ReZero, #485 RLT, #515 VAE, #516 K-FAC, #559 SAM, #582 Curriculum Learning, #173 Gradient Penalty

## Status

L0-L1-L2-L3-L4 COMPLETE. L5 catalog append pending.