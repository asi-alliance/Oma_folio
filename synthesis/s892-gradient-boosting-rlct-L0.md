# Synthesis #892: Gradient Boosting (XGBoost/GBM) × RLCT — L0 Exploration

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L0 EXPLORATION

---

## Topic

Gradient Boosting Machines (GBM/XGBoost/LightGBM) analyzed through Singular Learning Theory (SLT) and the Real Log Canonical Threshold (RLCT). Gradient boosting builds an additive model F_M(x) = Σ_{m=1}^{M} ν·h_m(x; θ_m) where each h_m is a weak learner (typically a decision tree) fit to the negative gradient of the loss, and ν is the shrinkage/learning rate. XGBoost uses a second-order Taylor approximation of the loss, incorporating Hessian information into the tree fitting objective.

## Distinction from #846 (AdaBoost × RLCT)

Four structural differences create genuinely novel RLCT structure:

1. **Functional gradient descent vs reweighting**: AdaBoost reweights samples via exponential loss; GBM fits base learners to the *functional gradient* of an arbitrary differentiable loss L(y, F). The gradient ∂L/∂F is evaluated at the current cumulative prediction, creating a path-dependent loss landscape that shifts each round.

2. **Shrinkage ν as continuous stratum selector**: AdaBoost's M (number of rounds) is a discrete stratum selector. GBM's shrinkage ν ∈ (0,1] is *continuous* — it controls the step size in function space, directly modulating how each round's parameters perturb the cumulative model. This creates a 1-parameter family of singular fibers indexed by ν, with qualitatively different geometry at small vs large ν.

3. **Second-order Taylor / Newton step**: XGBoost approximates L(y, F+νh) ≈ L(y,F) + νh·g + (ν²/2)h²·H where g = ∂L/∂F (gradient) and H = ∂²L/∂F² (Hessian). The tree fitting objective becomes weighted by Hessian: obj_m = Σ g_i·h(x_i) + (1/2)Σ H_i·h(x_i)² + Ω(h). The Hessian H_i = ∂²L/∂F² enters as a per-sample weight, and the optimal leaf weight is w*_j = -Σ_{i∈j} g_i / (Σ_{i∈j} H_i + λ_reg). This means the Fisher information (Hessian) conditions the update explicitly — linking directly to the natural gradient / K-FAC framework of #516.

4. **Tree base learner split-point singularities composed with boosting**: From #877, individual decision trees have A_1 kink singularities at split thresholds. In GBM, these kink singularities are *composed* across M rounds — the cumulative prediction F_M is piecewise constant on a partition refined by each round's splits. The singular locus is the union of all split boundaries across all rounds, creating a stratified singular set whose complexity grows with M.

## Claims

**C1: R_{an,exp} Definability [PROVEN]**
The GBM loss landscape is R_{an,exp}-definable. The cumulative prediction F_M is piecewise constant (for tree base learners) on a semialgebraic cell decomposition defined by the union of all split inequalities across M rounds. The loss L(y, F_M) is analytic in F_M (squared error, logistic loss, etc. — all exp-definable). The second-order Taylor objective involves g (piecewise constant in F_{M-1}, hence R_an) and H (piecewise analytic in F_{M-1}). The optimal leaf weights w*_j = -G_j/(H_j + λ) are rational functions of restricted sums, definable in R_{an,exp}. By closure properties (composition, addition, restriction to semialgebraic sets), the entire GBM loss is R_{an,exp}-definable. QED.

**C2: Cumulative Path-Dependent Singular Fiber [CONJECTURAL]**
At round m, the parameter space Θ_m = {θ_1,...,θ_m} (all tree parameters up to round m) defines a cumulative model F_m. The singular fiber W_m = {(θ_1,...,θ_m) : K_m(θ_1,...,θ_m) = K*_m} depends on the *path* — the optimal θ_m depends on F_{m-1}, which depends on all previous θ_j. This creates a path-dependent singular fiber where the geometry at round m is conditioned on the realized parameter values from rounds 1,...,m-1. Unlike #846 AdaBoost (where reweighting creates a similar path-dependence but through exponential sample weights), here the path-dependence enters through the *functional gradient* evaluated at the cumulative prediction, creating a singular fiber that is the pullback of the loss landscape through the additive model structure. The KL divergence K_m is a sum of per-sample contributions K_m = (1/n)Σ L(y_i, Σ_{j=1}^m ν·h_j(x_i;θ_j)), and the singular set is the intersection of {∂K_m/∂θ_j = 0 for all j} with degeneracy conditions on the Hessian. Each round adds a new block of parameters, growing the fiber dimension.

**C3: Shrinkage ν as Continuous Stratum Selector [CONJECTURAL]**
The shrinkage parameter ν controls the "width" of the accessible singular fiber. For small ν, each tree contributes a small perturbation, and the cumulative model F_M changes slowly — the singular fiber is "wide" (many parameter configurations produce nearly identical predictions, as ν·h is small). For large ν, each tree dominates, and the fiber is "narrow" (individual tree parameters strongly affect predictions). This creates a continuous 1-parameter family of strata indexed by ν, unlike the discrete strata of #846's M or #877's depth D. The effective RLCT λ_eff(ν) should decrease as ν → 0 (wider fiber, more parameters near optimum, but each contributes less) — analogous to how small learning rates in SGD create flatter minima. The generalization bound should be U-shaped in ν: too large → high variance (each tree overfits), too small → high bias (insufficient learning). The optimal ν* balances fiber width against effective model capacity.

**C4: Generalization Bound with Hessian-Conditioned Complexity [CONJECTURAL]**
The Newton step incorporates Hessian information H_i = ∂²L/∂F². At the singular fiber, the Fisher information matrix I(θ) has a block structure: each round's tree parameters θ_m couple to previous rounds through the Hessian of the cumulative loss. The generalization bound takes the form G(M,ν) ≈ (λ_eff(M,ν)·log(n))/(2n) + B_newton(M,ν) where B_newton accounts for the Hessian conditioning. The Hessian conditioning enters because the Newton step effectively rescales the parameter space by I(θ)^{-1/2}, transforming the singular fiber geometry. Well-conditioned Hessians (uniform eigenvalues) preserve the RLCT; ill-conditioned Hessians (degenerate directions) amplify the singularity. This connects GBM to the K-FAC / natural gradient framework of #516, where the Fisher information reshapes the loss landscape geometry.

**C5: Phase Transition at Critical ν* [CONJECTURAL]**
As ν decreases from 1 to 0, there should be a phase transition at a critical ν* where the effective RLCT changes qualitatively. Above ν*, individual tree split-point kink singularities (#877) dominate the loss landscape — the singular locus is the union of split boundaries, and λ_eff reflects the tree singularity structure. Below ν*, the shrinkage averages out the kink singularities — the cumulative model F_M becomes smoother (approaching a step function with infinitesimal steps), and the singular fiber transitions to a more regular geometry. At ν*, the SGLD local learning coefficient (LLC) should show a kink or discontinuity in its derivative, marking the transition from "tree-dominated" to "averaged" singularity structure. The critical ν* should depend on M, n, and the tree depth D, scaling roughly as ν* ~ D·log(M)/n.

## Open Problems

1. Exact RLCT for GBM with squared loss and depth-1 trees (stumps): is λ = d·M/2 where d is input dimension?
2. How does the Newton step Hessian conditioning modify the RLCT compared to first-order gradient boosting (no Hessian)?
3. Interaction between shrinkage ν and tree depth D: is there a joint phase boundary in (ν, D) space?
4. Column subsampling (XGBoost feature subsampling): does it create a stochastic stratum selector like dropout (#506)?
5. Does the path-dependent fiber (C2) have a recursive structure: W_m = f(W_{m-1}, θ_m) that can be analyzed inductively?
6. Connection to gradient boosting as gradient descent in function space: can the functional gradient be analyzed as a trajectory on the singular fiber manifold?
7. Comparison with #846 AdaBoost: is the continuous ν stratum selector fundamentally different from discrete M, or does ν·M ≈ const recover the same effective complexity?

## Cross-References

#846 AdaBoost (discrete M vs continuous ν, exponential loss vs functional gradient), #877 Decision Tree (base learner split-point singularities, depth D selector), #516 K-FAC (Fisher information / Hessian conditioning), #289 Adam (first-order vs second-order optimization), #605 Adagrad (cumulative gradient structure), #506 Dropout (stochastic subsampling analogy), #652 Ensemble/Bagging (parallel vs sequential ensemble), #383 Data Pruning (sample subset selection), #213 LR Scheduling (ν schedule as RLCT annealing), #241 Gradient Clipping (gradient norm constraint on functional gradient), #433 Weight Decay (λ_reg in XGBoost objective as L2 penalty on leaf weights), #527 Gradient Clipping RLCT (clip threshold as stratum selector analogy)
