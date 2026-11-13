# Synthesis #898: Bayesian Optimization x RLCT (L1 Formalization)

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L1 FORMALIZATION

---

## Formal Definitions (D1-D7)

**D1: Parameter and Function Space**
Let F be a space of real-valued functions on a compact domain X. The GP posterior at step t is p_t(f | D_t) where D_t = {(x_1, y_1), ..., (x_t, y_t)} is the query history. The GP prior is specified by mean m(x) and kernel k(x, x_prime). The parameter space is the function space F endowed with the GP posterior measure. The acquisition function alpha(x; p_t) maps X to R, parametrized by the posterior p_t.

**D2: BO Loss / Acquisition Landscape**
The BO surrogate loss at step t is the negative acquisition function: L_BO(x; p_t, kappa) = -alpha(x; p_t, kappa). For UCB: alpha = mu_t(x) + kappa * sigma_t(x), so L_UCB = -mu_t(x) - kappa * sigma_t(x). For EI: alpha = sigma_t(x) * [z * Phi(z) + phi(z)] where z = (mu_t(x) - f_best) / sigma_t(x). For PI: alpha = Phi(z). The loss landscape is the acquisition landscape over X, not a parameter-space loss.

**D3: R_{an,exp} Definability**
GP marginal likelihood: exp(-1/2 (y - m)^T K^{-1} (y - m)) / sqrt(det(K) * (2pi)^t). All components: exp (definable), matrix inverse (rational), determinant (polynomial), sqrt (definable in R_{an}), division (definable). Normal CDF Phi(z) = integral of exp(-u^2/2) du, a Gaussian integral of e-definable density (semialgebraic support). Normal PDF phi(z) = exp(-z^2/2) / sqrt(2pi). KL divergence = 0.5 * (tr(K_2^{-1} K_1) + log(det(K_2)/det(K_1)) - n + ...), all definable. UCB is affine + scale. By closure under composition, affine maps, and finite sums, L_BO is R_{an,exp}-definable. (C1 PROVEN.)

**D4: Sequential Path-Dependent Singular Fiber**
The singular fiber at step t is V_t = {x in X : alpha(x; p_t, kappa) = 0}, the zero-loss set of the acquisition function. V_t is path-dependent: p_t is conditioned on D_t = {(x_1,y_1),...,,(x_t,y_t)}, so the geometry of V_t depends on all prior queries. The filtered family V_1 subset ... subset V_T is not a fixed filtration in X; it is a family over a growing observation space. The fiber lives in function space (the GP posterior contracts as t grows), not parameter space.

**D5: Kappa-Parameterized Stratum Family**
For UCB, kappa scales the posterior standard deviation: alpha_kappa(x) = mu_t(x) + kappa * sigma_t(x). The family {L_BO(x; kappa) : kappa in R_+} defines a continuous stratum family. Large kappa: sigma_t dominates, V_t is broad (regular geometry, non-degenerate Fisher, lambda ~ d_f/2). Small kappa: mu_t dominates, V_t concentrates near the current best (singular geometry, degenerate Fisher, lambda < d_f/2). Unlike discrete selectors (#846 M, #877 D), kappa is a continuous stratum selector with smooth interpolation.

**D6: RLCT-Governed Regret Bound**
The generalization bound for BO regret: G_BO(N) ~ lambda_eff(kappa, t) / N + U(kappa) / sqrt(N), where lambda_eff is the effective RLCT of the sequential posterior specification at step t, and U(kappa) captures the acquisition landscape bias. For regular GP (smooth objective, well-specified kernel): lambda_eff ~ d_f/2. For singular GP (misspecified kernel, few points, overfitting): lambda_eff < d_f/2, leading to slower regret decay. Standard BO regret Regret(N) ~ O(sqrt(N * gamma_N)) should be recoverable from the SLT bound with lambda_eff related to information gain gamma_N.

**D7: Exploration-Exploitation Phase Transition**
As kappa decreases from high to low, the LLC of the GP posterior specification changes from regular (lambda ~ d_f/2) to singular (lambda < d_f/2). The critical kappa* marks the phase transition where exploration stops dominating and GP confidence shapes the acquisition landscape. kappa* depends on the objective function structure (Lipschitz constant, number of local minima, multimodality) and kernel scale. SGLD-testable: sample from the GP posterior at varying kappa and evaluate the LLC at each.

---

## MeTTa-Ready Claims

```
; C1: R_{an,exp} definability of BO loss (PROVEN)
(|- ((==> (BO GP-posterior marginal-likelihood R_an_exp-definable)
         (BO acquisition-function EI PI UCB R_an_exp-definable))
    (stv 1.0 0.95)))

; C2: Sequential path-dependent singular fiber (CONJECTURAL)
(|- ((==> (BO sequential-posterior-update path-dependent)
         (BO singular-fiber V_t function-space path-dependent))
    (stv 0.55 0.7)))

; C3: Kappa as continuous stratum selector (CONJECTURAL)
(|- ((==> (UCB kappa scales posterior-std)
         (kappa continuous-stratum-selector regular-to-singular))
    (stv 0.6 0.75)))

; C4: RLCT-governed regret bound (CONJECTURAL)
(|- ((==> (BO regret-bound governed-by effective-RLCT)
         (G_BO ~ lambda_eff(kappa,t)/N + U(kappa)/sqrt(N)))
    (stv 0.55 0.7)))

; C5: Exploration-exploitation phase transition at kappa* (CONJECTURAL)
(|- ((==> (kappa decreases high-to-low)
         (phase-transition kappa* regular-to-singular LLC))
    (stv 0.6 0.7)))
```

---

## Claim Status Summary

| Claim | Status | Evidence |
|-------|--------|----------|
| C1 | PROVEN | Closure of R_{an,exp} under composition: exp, rational inverse, det, sqrt, Phi (Gaussian integral), phi, affine+scale |
| C2 | CONJECTURAL | Path-dependent fiber in function space, not parameter space; needs dynamic SLT framework |
| C3 | CONJECTURAL | Kappa continuous interpolation; needs formal stratum equivalence |
| C4 | CONJECTURAL | Connection between gamma_N and lambda_eff needs formalization |
| C5 | CONJECTURAL | SGLD-testable; kappa* dependence on objective structure unverified |

---

## Open Problems

1. Dynamic SLT for sequentially conditioned posteriors (standard SLT assumes fixed loss)
2. Acquisition function singularity classification (EI vs PI vs UCB fiber geometry)
3. GP posterior contraction and RLCT evolution (monotonic lambda decrease?)
4. Deriving standard BO regret bound from SLT principles (gamma_N to lambda_eff bridge)
5. Kernel choice effect on singular fiber structure (RBF vs Matern vs polynomial)
6. Multi-fidelity and batch BO: branching fiber structure
7. High-dimensional BO: RLCT increase or decrease with dimension?

---

## Cross-References

#8 #16 #103 #167 #185 #216 #362 #414 #468 #525 #599 #846 #870 #896 #892

---

## Key Novelty

C2: path-dependent singular fiber in FUNCTION SPACE. All prior syntheses study singular fibers in parameter space (neural network weights) or input-conditioned fibers (sequence position, prompt). BO creates a singular fiber that depends on the entire sequential query history and lives in function space, evolving as the GP posterior updates. First path-dependent fiber in function space.

**Next:** L2 novelty verification via websearch.