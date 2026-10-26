# Synthesis #501: JEPA (Joint Embedding Predictive Architecture) × RLCT - L1 Formalization

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Formal Definitions

**D1 (JEPA Parameter Space):** Let W = W_c × W_p be the parameter space, where W_c ⊂ R^{d_c} are context encoder parameters and W_p ⊂ R^{d_p} are predictor parameters. The target encoder parameters W_t are not free — they are EMA-updated: W_t^{(t)} = α·W_t^{(t-1)} + (1-α)·W_c^{(t)}. For RLCT analysis, we consider the quasi-static regime where W_t is treated as a fixed parameter within each analysis window.

**D2 (Context and Target Encoders):** The context encoder f_c: X → Z maps input x_context to latent z_c = f_c(x_context, w_c) ∈ R^m. The target encoder f_t: X → Z maps x_target to z_t = f_t(x_target, w_t) ∈ R^m. Both are neural networks (analytic compositions of linear maps, ReLU/subanalytic activations, normalization layers), hence R_{an,exp}-definable by C1 of #8, #16.

**D3 (Predictor Network):** The predictor g: Z × P → Z maps context embedding z_c and positional encoding pos ∈ P to a prediction ĝ_t = g(z_c, pos, w_p) ∈ R^m. The predictor is a neural network (R_{an,exp}-definable). Its architecture (width h, depth L_p) determines prediction capacity.

**D4 (JEPA Loss):** The per-sample loss is:
  L_JEPA(x, w) = ||g(f_c(x_c, w_c), pos, w_p) - sg(f_t(x_t, w_t))||^2
where sg(·) is the stop-gradient operator (identity on forward pass, zero gradient on backward). The empirical loss is L_n(w) = (1/n) Σ_i L_JEPA(x_i, w). This is R_{an,exp}-definable: L2 norm is polynomial, encoders and predictor are analytic, stop-gradient is piecewise-definable (forward = identity, backward = zero, yielding a piecewise-analytic structure).

**D5 (Embedding Variety):** The target encoder defines the embedding variety V_t = {(x, z) : z = f_t(x, w_t)} ⊂ X × Z. The predictor loss is evaluated on this variety — the effective loss landscape is the restriction L_p(w_p) = ||g(f_c(x_c), pos, w_p) - z_t||^2 restricted to z_t ∈ V_t. This is a projected/restricted RLCT: the geometry of V_t constrains the achievable minima.

**D6 (Collapse Stratum):** Define the collapse stratum S_collapse = {w_p ∈ W_p : g(·, w_p) = c for some constant c ∈ R^m}. On S_collapse, the predictor maps all inputs to the same output. The fiber F_collapse = {w ∈ W : g(f_c(x_c), pos, w_p) = c ∀ (x_c, pos)} is a high-dimensional subvariety (all predictor parameters yielding constant output). The RLCT at S_collapse is λ_collapse ≥ λ_non-collapse because the fiber dimension is maximal.

**D7 (EMA Drift Tension):** Define the EMA drift δ(t) = ||W_t^{(t)} - W_c^{(t)}|| measuring the gap between target and context encoder parameters. The drift evolves as δ(t+1) = α·δ(t) + (1-α)·||∇L(w_c)|| (approximately, in the quasi-static regime). This drift enters the generalization bound as a tension term analogous to recurrent weight sharing (#485): the predictor must match a moving target, which constrains the achievable RLCT.

## Claims (Formalized)

**C1 (PROVEN):** L_JEPA is definable in R_{an,exp}. The loss decomposes as: (1) f_c, f_t, g are neural networks — analytic compositions preserving R_{an,exp} (#8, #16). (2) The L2 norm ||·||^2 is polynomial. (3) Stop-gradient sg(·) is piecewise-definable: on the forward pass sg(z) = z (identity, analytic), on the backward pass ∂sg/∂z = 0 (constant, analytic). The composition is piecewise-analytic, requiring piecewise RLCT as in #499, #500. (4) EMA update W_t = α·W_t + (1-α)·W_c is polynomial (affine) in parameters. All operations preserve R_{an,exp}-definability. ∎

**C2 (CONJECTURAL):** The collapse stratum S_collapse is a singular stratum of the loss landscape. The fiber F_collapse has dimension dim(W_p) - m (the predictor output is constrained to a constant, removing m degrees of freedom but keeping the internal parameters free). The singularity arises because: (a) the constant-output constraint creates a rank-deficient Jacobian (∂g/∂w_p = 0 on S_collapse for the output direction), (b) the Hessian of L_JEPA on S_collapse is degenerate (all inputs yield the same loss). The RLCT satisfies λ_collapse > λ_non-collapse: collapse is a deeper (more singular) local minimum. EMA + stop-gradient + limited predictor capacity create barriers that raise the effective RLCT for reaching collapse, but do not eliminate S_collapse from the loss landscape.
Gaps: (1) exact fiber dimension of F_collapse for specific architectures, (2) whether S_collapse is always connected or has multiple components, (3) Hironaka resolution needed for exact RLCT.

**C3 (CONJECTURAL):** The EMA decay rate α ∈ (0, 1) acts as a continuous stratum selector. At α → 1 (frozen target), V_t is fixed — the predictor must match a static embedding variety, and the RLCT is λ(g|_{V_t}) determined purely by predictor geometry on a fixed variety. At α → 0 (target = context), the system becomes symmetric: z_t = z_c (same encoder), collapse is trivially reachable (g = identity → constant), and the loss landscape flattens (λ → 0). For intermediate α*, the EMA timescale τ_EMA ~ 1/(1-α) matches the predictor learning timescale τ_p, creating a regime where the target drifts at the same rate the predictor adapts — optimal latent diversity.
Heuristic: λ(α) ≈ λ_0 · (1-α)^{β} · α^{γ} where β, γ depend on predictor capacity. The U-shaped optimum α* satisfies dλ/dα = 0.
Gaps: (1) exact form of λ(α) requires resolution of the coupled EMA-SGD dynamics, (2) whether the phase transition is continuous or discontinuous, (3) interaction with predictor width h.

**C4 (CONJECTURAL):** Generalization bound for JEPA:
  G_gap ≤ λ_JEPA(α, h) · log(n) / (2n) + U_EMA(α) / √n
where:
- λ_JEPA(α, h) is the RLCT of the predictor restricted to the (quasi-static) embedding variety V_t, depending on EMA decay α and predictor width h
- U_EMA(α) = O((1-α) · ||∇L||) is the EMA drift tension term, analogous to recurrent tension in #485
- The drift term captures the mismatch between the static RLCT analysis and the moving target variety
Gaps: (1) exact derivation of λ_JEPA from the coupled encoder-predictor system, (2) whether U_EMA should scale as (1-α) or (1-α)^2, (3) how predictor depth L_p interacts with λ_JEPA.

**C5 (CONJECTURAL):** Phase transition at critical EMA decay α* where the RLCT transitions from collapse-dominated to prediction-dominated. Below α* (target drifts too fast), the predictor converges to constant output (λ_collapse, poor generalization). Above α* (target too static), the predictor overfits to fixed embeddings (λ increases from overfitting to static targets). At α*, the EMA drift rate matches predictor adaptation rate, yielding minimum λ.
Prediction: α* ≈ 1 - C/τ_p where τ_p is predictor learning timescale and C is a constant. Testable via SGLD: estimate λ_JEPA(α) at various α values during training, observe U-shaped curve with minimum at α*.
Gaps: (1) exact form of α* in terms of architecture hyperparameters, (2) whether multiple phase transitions exist (per-predictor-layer), (3) interaction with batch size and learning rate.

## Open Problems

1. **Exact fiber structure of g|_{V_t}:** What is the singularity structure of the predictor restricted to the embedding variety? Need resolution of the composition g ∘ f_c on V_t.
2. **Collapse stratum Hironaka resolution:** Resolve S_collapse to determine exact λ_collapse for specific predictor architectures.
3. **EMA dynamics as non-gradient flow:** Does the EMA update preserve the RLCT properties of the static analysis? The moving V_t creates a time-dependent singularity structure.
4. **Stop-gradient piecewise RLCT:** The forward/backward asymmetry creates a piecewise-analytic structure. What is the RLCT contribution of the stop-gradient boundary?
5. **Predictor capacity as stratum selector:** Does predictor width h act as a discrete stratum selector (like degree d in #433) or continuous (like merge ratio r in #500)?
6. **Comparison with contrastive learning (#18):** Contrastive uses similarity (cosine/dot product) in latent space; JEPA uses prediction (neural network). How does the fiber structure differ?
7. **Latent-space vs pixel-space RLCT:** Compare λ_JEPA (latent prediction) with λ_autoencoder (#82, pixel reconstruction). Does predicting in latent space reduce RLCT?
8. **Multi-target JEPA:** If multiple target views are predicted, is the RLCT additive (Σ λ_i) or multiplicative (max λ_i)?

## Cross-References

#8 (ReLU definability), #16 (semi-algebraic foundation), #82 (autoencoder), #86 (attention non-identifiability), #169 (pruning fiber), #185 (constitutional AI constraint manifold), #201 (early exit branch), #438 (BYOL — EMA predictor, closest analog), #485 (RLT recurrent tension), #500 (token merging quotient fiber)

## Status

L1 FORMALIZATION DRAFTED. 2026-10-21. Next: L2 novelty verification.
