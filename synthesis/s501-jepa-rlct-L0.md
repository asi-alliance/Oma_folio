# Synthesis #501: JEPA (Joint Embedding Predictive Architecture) × RLCT - L0 Exploration

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## 1. Architecture Summary

JEPA consists of three components:
- Context encoder f_c(x_context): encodes visible/context view into latent representation z_c
- Target encoder f_t(x_target): encodes target view into latent representation z_t (updated via EMA of context encoder)
- Predictor g(z_c, pos): predicts target representation from context embedding + positional encoding

Training loss: L = ||g(z_c, pos) - z_t||^2 (L2 in latent space, not pixel space)

Key asymmetries preventing collapse:
1. Target encoder is EMA (slow-moving) of context encoder — non-symmetric gradient flow
2. Stop-gradient on target representation (z_t.detach())
3. Predictor is capacity-limited — cannot trivially map everything

## 2. Questions

Q1: What is the fiber structure of the predictor map g: Z_c × Pos → Z_t?
Q2: Does representational collapse (g = const) form a singular stratum of the loss landscape?
Q3: How does EMA averaging affect the definability class of the target encoder?
Q4: Is the stop-gradient creating a piecewise or non-smooth fiber structure?
Q5: What RLCT does the EMA dynamics induce vs SGD dynamics?
Q6: Does predictor capacity (width/depth) act as stratum selector?
Q7: How does the latent-space loss (vs pixel-space) change the RLCT compared to autoencoders?

## 3. Claims

### C1 (PROVEN): Definability
L_JEPA is definable in R_{an,exp}. The encoder maps are neural networks (analytic compositions of polynomial, ReLU, exp via softmax/sigmoid). The predictor g is a neural network. EMA update f_t = alpha * f_t + (1-alpha) * f_c is polynomial in parameters. L2 loss is polynomial. Stop-gradient = identity on forward, zero on backward = definable piecewise. All components preserve R_{an,exp}-definability.

### C2 (CONJECTURAL): Collapse Fiber
The trivial collapse solution (g maps all z_c, pos to constant c) forms a singular stratum S_collapse in the loss landscape. On S_collapse, the fiber dimension is maximal (all input variation absorbed by predictor degeneracy). The RLCT at S_collapse is higher than at non-collapsed solutions, making collapse a "deep" local minimum in the RLCT sense. EMA + stop-gradient + limited predictor capacity create barriers that raise the effective RLCT for reaching collapse.

### C3 (CONJECTURAL): EMA Momentum as Stratum Selector
EMA decay rate alpha acts as a continuous stratum selector. At alpha → 1 (frozen target), the target encoder defines a fixed embedding variety V_t — the predictor must match a static target, RLCT = RLCT(g|_{V_t}). At alpha → 0 (target = context), the system becomes symmetric and collapse is trivially reachable, RLCT → 0 (flat landscape). For intermediate alpha*, there is a phase transition where the EMA timescale matches the predictor learning timescale, creating optimal latent diversity.

### C4 (CONJECTURAL): Generalization Bound
G_gap <= lambda_JEPA / n + U / sqrt(n), where lambda_JEPA is the RLCT of the predictor restricted to the embedding variety V_t, and U accounts for the EMA drift between f_t and f_c. The EMA drift term is O((1-alpha) * ||grad||) per step, contributing a tension term analogous to recurrent weight sharing (#485).

### C5 (CONJECTURAL): Phase Transition at alpha*
At critical EMA decay alpha*, the RLCT of the system transitions from collapse-dominated (low alpha, trivial minimum) to prediction-dominated (high alpha, rich latent structure). Below alpha*, the predictor converges to constant (lambda ~ 0). Above alpha*, the EMA target drifts too slowly and the predictor overfits to static targets (lambda increases from overfitting). Optimal alpha* balances EMA drift rate with predictor learning rate. Testable via SGLD.

## 4. Open Problems

1. Exact fiber structure of predictor g restricted to embedding variety V_t
2. Collapse stratum resolution via blow-up (Hironaka)
3. EMA dynamics as non-gradient flow — does it preserve RLCT properties?
4. Stop-gradient: definable but non-smooth — piecewise RLCT contribution
5. Predictor capacity as discrete vs continuous stratum selector
6. Comparison with contrastive learning fiber (#18)
7. Latent-space vs pixel-space RLCT comparison (vs autoencoder #82)
8. Multi-target JEPA: additive or multiplicative RLCT?

## 5. Cross-References

#8 (ReLU definability), #16 (semi-algebraic foundation), #82 (autoencoder), #86 (attention non-identifiability), #169 (pruning fiber), #185 (constitutional AI constraint manifold), #201 (early exit branch), #485 (RLT recurrent tension), #491 (grokking), #500 (token merging quotient fiber)

## 6. Novelty Hypothesis

JEPA × RLCT has zero catalog hits. The novel mechanism is: prediction in latent space means the loss landscape lives on the embedding variety V_t defined by the (EMA) target encoder. The RLCT is that of the predictor g restricted to V_t — a "projected" or "restricted" RLCT not seen in pixel-space losses. EMA dynamics create a moving variety, adding temporal stratum structure. Stop-gradient creates piecewise definability distinct from standard smooth training.

## Status

L0 EXPLORATION DRAFTED. 2026-10-21. Next: L1 formalization.
