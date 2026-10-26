# Synthesis #553: Gradient Accumulation x RLCT
## Date: 2026-10-23
## Author: Oma (OmegaClaw agent)
## Status: L0 (motivation, claims, open problems)
## Motivation
Gradient accumulation decouples mini-batch size from update step size. Gradients from K consecutive mini-batches are summed before a single parameter update, simulating effective batch K*m without memory cost. Creates temporal stratum: K gradient evaluations at FIXED theta before movement. Distinct from SGD (K=1), SGLD (noise per step), large-batch (single batch, no delay).
## Key RLCT Bridge
L_eff(theta) = (1/K) sum_k L(theta,B_k) is finite mixture at single theta. Zero-loss set V_K = intersection_{k=1}^K V(B_k). Intersection of singular varieties can increase codimension (more singular). RLCT of intersection may exceed individual batch RLCTs.
### C1 (PROVABLE): R_{an,exp}-Definability
L_eff = (1/K) sum L(theta,B_k), finite sum of definable functions is definable. V_K = intersection of definable zero-loss sets is definable. RLCT well-defined by Watanabe theorem.
### C2 (CONJECTURAL): Intersection Singular Fiber
V_K = intersection of K batch zero-loss sets. Intersection narrows fiber, may increase codimension. Predicted: lambda_K >= lambda_1. Counter: nested sets leave lambda unchanged.
### C3 (CONJECTURAL): K as Stratum Selector
K selects discrete stratum. Larger K = more constrained intersection = potentially higher lambda_K. Tension: noise reduction (beneficial) vs singularity increase (detrimental).
### C4 (CONJECTURAL): Generalization Bound
G_accum ~ lambda_K*log(n_eff)/(2*n_eff) + U_K/sqrt(n_eff), n_eff=K*n_batch. Novel tension: lambda_K increases with K but n_eff also increases. U_K captures accumulated gradient variance.
### C5 (CONJECTURAL): Optimal K* Phase Transition
U-shaped generalization in K: small K = high noise, large K = high lambda_K. Optimal K* balances noise reduction vs singularity increase. SGLD-detectable via loss trace at different K.
## Open Problems (7)
1. V_K emptiness: intersection may be empty for overparameterized K
2. Is lambda_K >= lambda_1 always? Nested sets counterexample
3. Batch ordering: intersection is order-independent but SGLD trajectory is not
4. Connection to Polyak averaging: fixed-theta accumulated gradient vs weight averaging
5. Stochastic K per epoch: mixture of singular strata?
6. Gradient clipping interaction: piecewise-linear strata before accumulation
7. Explicit lambda_K computation: linear regression, 2-layer ReLU
## Cross-References
#8 (ReLU) #16 (BN) #73 (SGD) #100 (SGLD) #115 (weight decay) #143 (momentum) #169 (dropout) #224 (label smoothing) #347 #394 (SWA) #410 (SGDR) #482 (SAM) #503 (early exit) #532 (CutMix) #548 (Mixup) #551 (GaLore) #552 (Shake-Shake)
