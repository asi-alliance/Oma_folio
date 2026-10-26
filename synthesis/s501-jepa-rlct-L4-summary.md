# Synthesis #501: JEPA (Joint Embedding Predictive Architecture) × RLCT — L4 Summary

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## One-Line Summary

JEPA's latent-space prediction loss has an RLCT restricted to the target encoder's embedding variety V_t, with EMA decay α acting as a continuous stratum selector yielding a U-shaped generalization curve and a phase transition at critical α*.

## Key Results

- **C1 (PROVEN):** JEPA loss L_JEPA = ||g(f_c(x_c), pos, w_p) - sg(f_t(x_t, w_t))||² is R_{an,exp}-definable. Encoders and predictor are analytic neural nets (#8, #16), L2 norm is polynomial, EMA update is affine, stop-gradient is piecewise-analytic (forward=identity, backward=zero). Composition preserves R_{an,exp}.

- **C2 (CONJECTURAL):** The collapse stratum S_collapse (predictor outputs constant) is a singular stratum with RLCT λ_collapse > λ_non-collapse. The fiber has dimension dim(W_p) - m. EMA + stop-gradient + limited predictor capacity raise the effective barrier against collapse.

- **C3 (CONJECTURAL):** EMA decay α ∈ (0,1) is a continuous stratum selector. α→1: frozen target, fixed embedding variety, RLCT determined by predictor geometry on V_t. α→0: symmetric (target=context), collapse trivially reachable, λ→0. Intermediate α*: EMA timescale matches predictor learning timescale — optimal latent diversity. Heuristic: λ(α) ≈ λ₀·(1-α)^β·α^γ (U-shaped).

- **C4 (CONJECTURAL):** Generalization bound G_gap ≤ λ_JEPA(α,h)·log(n)/(2n) + U_EMA(α)/√n, where λ_JEPA is the RLCT of predictor restricted to V_t, and U_EMA = O((1-α)·||∇L||) is the EMA drift tension (analogous to recurrent tension in #485).

- **C5 (CONJECTURAL):** Phase transition at α* where RLCT switches from collapse-dominated (α<α*, predictor → constant) to prediction-dominated (α>α*, overfitting to static targets). α* ≈ 1 - C/τ_p. Testable via SGLD.

## Standout Novelty

**Embedding-variety-restricted RLCT:** The RLCT of predictor g restricted to the target embedding variety V_t. This "projected RLCT" is the key new concept — JEPA's loss lives on V_t, not on pixel space or a general latent space. No prior synthesis (including #438 BYOL) captures this restriction.

## Distinction from Closest Analog (#438 BYOL)

1. V_t restriction: JEPA explicitly restricts to embedding variety; #438 uses three-level fiber without variety restriction
2. Positional encoding: product-space fiber Z×P×W_p→Z, absent from BYOL
3. Separate context/target encoders: V_c→V_t mapping, more general than BYOL self-prediction
4. α as continuous stratum selector with U-shaped optimum: refinement of #438's EMA analysis

## Pipeline Status

L0 ✓ (exploration, 5222B)
L1 ✓ (formalization, 8962B)
L2 ✓ (novelty passed, 5 websearches, 0 prior art)
L3 ✓ (MeTTa encoding, 4577B)
L4 ✓ (this summary)
L5: catalog append — next

## Cross-References

#8 (ReLU definability), #16 (semi-algebraic foundation), #82 (autoencoder), #86 (attention non-identifiability), #169 (pruning fiber), #185 (constitutional AI constraint), #201 (early exit branch), #438 (BYOL — closest analog), #485 (RLT recurrent tension), #491 (grokking), #499 (STE piecewise RLCT), #500 (token merging quotient fiber)
