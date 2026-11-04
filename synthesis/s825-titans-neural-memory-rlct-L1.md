# Synthesis #825: Titans Neural Long-Term Memory × RLCT - L1 Formalization
# Date: 2026-11-03
# Status: L1 DRAFT
# C1 PROVEN, C2-C5 CONJECTURAL

## D1: Parameter Space

Theta = {theta_attn, M, P} where:
- theta_attn in R^{d_attn}: standard attention parameters (Q, K, V, O projections)
- M in R^{d_mem}: neural long-term memory MLP weights, updated online at test time
- P in R^{d_pers}: persistent memory parameters, trained at training time, frozen at test time

Distinct from #653 TTT (theta_adapt updated via self-supervised loss on single forward pass) and #674 NTM (external memory matrix with attention-based read/write heads). Titans updates an internal MLP weights via surprise-driven gradient descent, not external memory addressing.

## D2: Titans Loss Function

L_Titans(x, y; Theta) = L_CE(f_attn(x; theta_attn, h_M, P), y) + alpha * L_assoc(x; M)

where:
- f_attn is the attention layer augmented with memory output h_M
- L_assoc = ||M(x_t) - x_{t-1}||^2 (associative memory prediction loss)
- h_M depends on variant: MAC (h_M concatenated to context), MAG (h_M gates attention output), MAL (h_M is a layer output)

Memory update at test time (per token t):
M_{t+1} = (1 - eta) M_t - eta_surprise * g_t
g_t = grad_M L_assoc(x_t; M_t) (surprise gradient)
eta_surprise = eta * s(x_t) where s(x_t) = ||g_t|| (surprise magnitude)

## D3: R_{an,exp}-Definability (C1 PROVEN)

All components are R_{an,exp}-definable:
- Attention: softmax (exp), linear projections (polynomial)
- Memory MLP: SiLU/ReLU activations (subanalytic)
- L_assoc: squared norm (polynomial)
- grad_M L_assoc: polynomial in M for polynomial L_assoc, subanalytic for SiLU
- Momentum/EMA of gradients: exponential decay
- Weight decay (1-eta): linear
- Persistent memory P: standard polynomial parameters
Composition closure preserves definability. C1 PROVEN.

## D4: Surprise-Dependent Singular Fiber (C2)

V_surprise(M; s) = {M in Theta : L_assoc(x; M) = 0 AND ||grad_M L_assoc(x; M)|| = s}

For surprise level s, the fiber V_surprise(M; s) captures all memory configurations where the associative loss vanishes with gradient magnitude s. The stratum selector is s(x) = ||grad_M L_assoc|| -- data-dependent and parameter-dependent simultaneously (unlike #824 Mamba where Delta(x) depends on input only, not on a separate parameter group).

## D5: Forgetting Rate as Stratum Selector (C3-C4)

eta in (0, 1) controls memory plasticity. The effective loss landscape for M:
L_eff(M; eta) = (1-eta)^T * L_assoc(M; M_0) + sum_{t=1}^{T} (1-eta)^{T-t} * eta * s(x_t) * ||M - M_t||^2

This is a weighted combination of initial loss and surprise-driven updates, with exponential forgetting weights. Low eta -> slow forgetting -> memory specializes (low RLCT stratum). High eta -> fast forgetting -> memory acts as rolling average (high RLCT, no specialization).

## D6: Generalization Bound (C4)

G_Titans(n) approx lambda_surprise / n + U(eta, {s(x_t)}) / sqrt(n)

where lambda_surprise = lambda_base + c * E_x[s(x)] / (1 - eta) is the effective RLCT incorporating surprise distribution and forgetting rate. U captures the variance of memory updates across the training distribution.

Distinct from #653 TTT (migration term for train/test loss gap) and #179 (single-pass adaptation). Titans bound depends on the temporal distribution of surprises, not just a dual-loss gap.

## D7: Phase Transition at eta* (C5)

At critical forgetting rate eta*:
- eta > eta*: memory never specializes, lambda_eff approx lambda_base + c*E[s]/(1-eta) -> infinity as eta -> 1 (constant adaptation, maximal RLCT)
- eta < eta*: memory specializes, lambda_eff -> lambda_specialized < lambda_base (memorized patterns reduce singular complexity)
- SGLD LLC shows step decrease at eta*

## Open Problems
1. Path-dependent RLCT: dynamical SLT extension for test-time-updated parameters
2. Memory MLP depth and nested singular strata (cf #471 PonderNet)
3. MAC vs MAG vs MAL singular fiber structure differences
4. Surprise momentum EMA as frequency-domain selector (cf #620 GrokFast)
5. Persistent memory product fiber (separate stratum from test-time M)
6. Attention-memory bipartite singular structure
7. Memory width scaling: lambda_eff ~ O(d_mem^{-alpha}), eta* shift with d_mem

## Cross-References
#824 (Mamba data-dependent gating), #653 (TTT dual-loss), #674 (NTM address collision), #179 (test-time adaptation), #471 (PonderNet depth), #388 (Mirostat feedback), #485 (RNN tying), #620 (GrokFast frequency), #501 (JEPA online), #650 (BYOL EMA), #169 (dropout), #582 (curriculum)

File: /tmp/Oma_folio/synthesis/s825-titans-neural-memory-rlct-L1.md
Next: L2 novelty verification.shell wc -c /tmp/Oma_folio/synthesis/s825-titans-neural-memory-rlct-L1.md && sha256sum /tmp/Oma_folio/synthesis/s825-titans-neural-memory-rlct-L1.md