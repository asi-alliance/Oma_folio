# Synthesis #898: Bayesian Optimization x RLCT (L0 Exploration)

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L0 EXPLORATION

---

## Topic

Bayesian Optimization (BO) is a sequential model-based optimization framework for black-box functions. It maintains a Gaussian Process (GP) posterior over the objective function f, updates it sequentially after each function evaluation, and selects the next query point via an acquisition function (EI, PI, UCB). The key SLT bridge: BO sequential posterior update creates a path-dependent segmentation of function space. The singular fiber at step t depends on the entire query history, not just the latest point.

## Key RLCT Bridges

1. **Sequential posterior update as cumulative specification:** After t queries, the GP posterior conditioned on all previous evaluations defines a cumulative singular fiber in function space. The acquisition function is defined relative to this posterior. Zero-loss acquisition defines a path-dependent singular fiber distinct from static fibers in parameter space (#896, #892) or input-dependent fibers (#525 Mamba).

2. **Acquisition function as definable map on GP posterior:** GP marginal likelihood involves exp of quadratic forms, KL divergence (covariance trace), and Gaussian integrals. EI involves normal CDF Phi and normal PDF phi. UCB is affine plus scale. All R_{an,exp}-definable by closure.

3. **Kappa stratum selector trajectory:** The acquisition parameter controls exploration-exploitation. Large kappa means high exploration (posterior variance governs acquisition, regular loss geometry). Small kappa means high exploitation, low variance, the acquisition function concentrates around the current best observation. Fisher information degenerates as the optimum is reached. This creates a parameter-dependent RLCT transition from regular to singular.

4. **BO regret as RLCT-governed generalization:** Standard BO regret bounds are Regret(N) ~ O(noise) + C * sqrt(N) terms. In SLT framing, the regret should be governed by the effective RLCT of the sequential posterior specification at step t. For regular GP training (smooth function, non-degenerate Fisher), lambda_eff ~ d_f/2 where d_f is function space dimension. For singular GP training (numerical fitting with few points, overfitting), lambda_eff < d_f/2. The error is governed by the ARR (acquisition regret rate) decay exponentially as N grows, as the ghosting RLCT must stay high enough to guide acquisition.

5. **Exploration-exploitation phase transition:** As kappa decreases from high to low, there should be a phase transition at kappa* where the LLC (local learning coefficient) of the GP posterior specification simulation changes from regular to singular. SGLD-testable: sample from the GP posterior at varying kappa and evaluate the LLC.

## Distinction from #103 (Gaussian Processes x RLCT)

#103 studies GP kernel hyperparameter singularity (marginal likelihood as a loss function of hyperparameters, singular fiber at mistuned hyperparameters). #898 studies the sequential acquisition and exploration-exploitation cycle as a distinct source of singularity. The key difference: #103 analyzes the GP as a static model, while #898 analyzes the GP as an evolving posterior during sequential optimization, with path-dependent fiber structure. There is no acquisition function or regret in #103, which are central to #898.

## Claims

**C1: R_{an,exp} Definability [PROVEN]**
The BO formulation involves the GP marginal likelihood (exp of quadratic forms, exponential terms), the covariance inverse (matrix inversion, rational), the KL divergence trace (exp of determinant), and the acquisition functions (EI involves normal CDF Phi(z) and Normal PDF phi(z), power of exp and division; PI involves Phi(z) directly; UCB is affine plus scale). All components are R_{an,exp}-definable by closure of formulas under composition, affine maps, and finite sums. The GP marginal likelihood requires exp and determinant. The integrals in EI are Gaussian integrals of e-definable density (semialgebraic structure). QED.

**C2: Sequential Path-Dependent Singular Fiber [CONJECTURAL]**
The acquisition function tries to zero defines the current singular fiber V_t. This fiber is path-dependent: the set of zeros at step t+1 depends on all previous queries because the GP posterior is conditioned on the full history. The sequential structure creates a filtered family V_1 subset ... subset V_T above function space. The RLCT of the acquisition landscape at step t is not the LLC of a single static loss function. It is the OLC of a composite objective involving the echo history. The spectral geometry of V_t changes as the GP posterior contracts around the optimum.

**C3: Kappa as Stratum Selector [CONJECTURAL]**
For UCB, kappa directly scales the posterior standard deviation term. For EI and PI, the equivalent inverse temperature controls exploration. Large kappa selects the exploration stratum where posterior variance dominates (regular geometry, non-degenerate Fisher, lambda ~ d_f/2). Small kappa selects the exploitation stratum where the posterior mean dominates and variance collapses (singular geometry, degenerate Fisher, lambda < d_f/2). The kappa-parameterized family of acquisition functions creates a stratum selector that is continuous, unlike discrete selectors in #846 (M) and #877 (depth D). The fiber family interpolates smoothly between regular and singular.

**C4: BO Regret as RLCT-Governed Generalization [CONJECTURAL]**
Standard BO regret: Regret(N) ~ O(sqrt(N * gamma_N)) where gamma_N is the maximum information gain. The SLT prediction: regret should be governed by lambda_eff(t, kappa) of the sequential posterior, not just the query count N. For regular GP (smooth objective, well-specified kernel), lambda_eff ~ d_f/2. For singular GP (misspecified kernel, few points, overfitting), lambda_eff < d_f/2, leading to slower regret decay because the ghosting RLCT stays high. The generalization bound: G_BO ~ lambda_eff(kappa) / N + U(kappa) / sqrt(N), where U captures the acquisition landscape bias.

**C5: Exploration-Exploitation Phase Transition [CONJECTURAL]**
As kappa decreases from high to low, there should be a phase transition at kappa* where the LLC of the GP posterior specification changes from regular (d_f/2) to singular (< d_f/2). The transition corresponds to the point where exploration stops being dominant and GP confidence shapes the loss landscape. SGLD-testable: sample from the GP posterior at varying kappa and evaluate the LLC. The critical kappa* depends on the objective function structure (Lipschitz, number of minima, multimodality) and kernel scale.

## Open Problems

1. **Path-dependent fiber formalization:** How to define the RLCT of a sequentially conditioned posterior? Standard SLT assumes a fixed loss function. The acquisition landscape changes every step. Need a dynamic SLT framework or a reduction to a single composite objective.

2. **Acquisition function singularity classification:** EI, PI, UCB have different analytic structures. Does each induce a different singular fiber type? EI has Phi(z) (error function-like), PI has Phi(z) directly, UCB is piecewise-affine. The fiber geometry may differ.

3. **GP posterior contraction and RLCT:** As the GP posterior contracts around the optimum, the Fisher information degenerates. How does the RLCT evolve? Is there a monotonic decrease in lambda as the posterior concentrates?

4. **Regret bound derivation:** Can the standard BO regret bound be derived from SLT principles? The connection between information gain gamma_N and RLCT lambda_eff needs formalization.

5. **Kernel choice and singularity:** Different kernels (RBF, Matern, polynomial) have different analytic properties. How does kernel choice affect the singular fiber structure of the acquisition landscape?

6. **Multi-fidelity and batch BO:** How do multi-fidelity BO (variable-cost evaluations) and batch BO (parallel queries) modify the path-dependent fiber? Batch BO creates a branching structure.

7. **High-dimensional BO:** In high dimensions, the GP posterior becomes more diffuse. Does the RLCT increase (more singular) or decrease (more regular)? Connection to dimension-dependent regret bounds.

## Cross-References

#8 #16 #103 #167 #185 #216 #362 #414 #468 #525 #599 #846 #870 #896 #892

## Star Novelty

The star claim is C2: the path-dependent singular fiber in function space. Unlike all prior syntheses which study singular fibers in parameter space (neural network weights) or input-conditioned fibers (sequence position, prompt), BO creates a singular fiber that depends on the entire sequential history of queries. The fiber at step t is a subset of function space, not parameter space, and it evolves as the GP posterior is updated. This is the first synthesis with a genuinely path-dependent singular fiber structure in function space.

---

**Next:** L1 formalization (D1-D7 definitions, MeTTa-ready claims).