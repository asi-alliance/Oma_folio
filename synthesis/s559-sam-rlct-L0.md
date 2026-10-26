# Synthesis #559: Sharpness-Aware Minimization (SAM) × RLCT L0 Exploration
# Date: 2026-10-23
# Status: L0 — exploration and initial claims

## Background
Sharpness-Aware Minimization (Foret et al. 2021) minimizes a perturbed loss: w_{t+1} = w_t - eta * grad L(w_t + rho*), where rho* = argmin_{||eps||<=rho} L(w+eps). The perturbation finds the worst-case direction within a ball of radius rho, then the gradient is computed at that perturbed point. SAM explicitly seeks flat minima by penalizing sharp directions.

## Key Questions
1. How does SAM's perturbation radius rho relate to RLCT stratum selection?
2. Does SAM preferentially find low-RLCT solutions by avoiding sharp (high-RLCT) directions?
3. What is the singular fiber structure of the SAM objective vs standard ERM?
4. Does rho act as a continuous stratum selector analogous to temperature in #234/#539?
5. Is there a phase transition in rho* where SAM transitions from flat-seeking to standard SGD behavior?

## Claims (Initial)

**C1 (Provable):** The SAM loss L_SAM(w) = max_{||eps||<=rho} L(w+eps) is R_{an,exp}-definable. The inner maximization over a compact ball is definable (o-minimal selection), and L is definable by assumption. The outer loss is a composition of definable functions with a definable selection theorem application.

**C2 (Conjectural):** SAM's perturbation radius rho acts as a continuous stratum selector. Small rho: SAM approximates standard ERM (rho->0). Large rho: SAM averages over a ball, smoothing the loss landscape. The perturbation smooths singular fibers by averaging over nearby strata, analogous to noise injection (#271/#507) but deterministic (worst-case vs stochastic). lambda_SAM(rho) <= lambda_SGD for rho > 0, with lambda_SAM(0) = lambda_SGD.

**C3 (Conjectural):** The worst-case perturbation eps* = rho * grad_L / ||grad_L|| lies along the steepest ascent direction. This direction is the normal to the level set of L, which near a singular fiber is the direction of maximal RLCT contribution. SAM penalizes exactly the singular directions, reducing effective RLCT by damping the sharpest stratum contributions.

**C4 (Conjectural):** Generalization bound: G_SAM(n) <= lambda_SAM(rho) * log(n)/(2n) + U_SAM(rho)/sqrt(n), where lambda_SAM(rho) <= lambda_SGD. The bias term U_SAM(rho) >= U_SGD because perturbation introduces bias (optimizing a different point). Tradeoff: optimal rho* balances RLCT reduction (improves gen) against bias increase (degrades gen). U-shape in rho.

**C5 (Conjectural):** Phase transition at critical rho*: below rho*, SAM behaves like SGD (small perturbation, negligible smoothing). Above rho*, SAM actively finds flat regions. The transition manifests as an LLC plateau: SGLD on SAM-trained models shows lower LLC than SGD-trained models for rho > rho*. Prediction: rho* ~ 1/sqrt(n) — perturbation radius should shrink with more data because the landscape is better resolved.

## Open Problems (7)
1. Exact lambda_SAM(rho) formula: is the reduction lambda_SGD - lambda_SAM(rho) proportional to rho^2 (quadratic) or rho (linear)?
2. Does the worst-case perturbation align with the most singular direction, or can it miss singular strata that are flat in gradient but singular in higher-order terms?
3. Connection to Hessian spectrum: SAM penalizes largest eigenvalue of Hessian. Is there a direct Hessian eigenvalue -> RLCT mapping?
4. SAM with momentum/Adam: does the perturbation interact with momentum in a way that changes the RLCT?
5. Multi-Loss SAM (M-SAM): does per-loss perturbation create independent stratum selection?
6. Non-uniform perturbation norms (ASAM, F-SAM): do these change the stratum selection geometry?
7. Empirical: SGLD LLC comparison SAM vs SGD at matched settings, varying rho

## Cross-References (10)
#8 (ReLU definability), #16 (semi-algebraic), #234 (temperature scaling — rho as analogous dial), #271 (noise injection — stochastic vs deterministic smoothing), #289 (EMA — different smoothing mechanism), #507 (noisy student — asymmetric noise), #526 (schedule-free — trajectory averaging), #539 (focal loss — gamma as stratum selector), #213 (weight decay — L2 as implicit flatness), #466 (RMSNorm — normalization as singularity reduction)

## Novelty Notes
- SAM × RLCT bridge: SAM's deterministic worst-case perturbation is distinct from stochastic noise (#271/#507) and trajectory averaging (#289/#526). The deterministic nature means the perturbation ALWAYS targets the sharpest direction, whereas stochastic noise samples random directions.
- Key insight: SAM as singularity-aware optimization — the worst-case perturbation is a probe of the local singularity structure, and penalizing it reduces RLCT.
- Flat minima = low RLCT connection (Hochreiter & Schmidhuber 1997 "flat minima" -> Watanabe 2009 RLCT) is the foundational link, but SAM as a mechanism for achieving low RLCT via optimization is novel.

Next: L1 formalization.pin STATE: #559 SAM × RLCT L0 WRITTEN. L1 formalization next. Silent mode.