# Synthesis #892: Gradient Boosting (XGBoost/GBM) × RLCT — L1 Formalization

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L1 (formal definitions, pre-proof)

---

## Definitions

### D1: Cumulative Additive Model Space
Let H = {h_θ : X → R} be a family of base learners parametrized by θ ∈ Θ ⊂ R^d (e.g., decision trees of depth D with split thresholds and leaf weights). The M-round gradient boosting model with shrinkage ν ∈ (0,1] is:

F_M(x) = F_0 + Σ_{m=1}^{M} ν · h_{θ_m}(x)

where F_0 is the initial prediction (e.g., mean of y for squared loss). The full parameter space is:

W_M = Θ^M × {ν} × {F_0}, dimension d_M = M·d + 1

For tree base learners (depth D), d = (2^D - 1) split thresholds + 2^D leaf weights per tree.

### D2: GBM Loss with Second-Order Taylor Approximation
The training loss over n samples {(x_i, y_i)} is:

L_M(w) = (1/n) Σ_{i=1}^n ℓ(y_i, F_M(x_i))

where ℓ is a differentiable analytic loss (squared error, logistic, etc.). At round m, the second-order Taylor approximation around F_{m-1} is:

L̃_m(θ_m) = Σ_{i=1}^n [g_i · h_{θ_m}(x_i) + (1/2) · H_i · h_{θ_m}(x_i)²] + Ω(h_{θ_m})

where:
- g_i = ∂ℓ(y_i, F)/∂F |_{F=F_{m-1}(x_i)} (gradient, piecewise constant in previous params)
- H_i = ∂²ℓ(y_i, F)/∂F² |_{F=F_{m-1}(x_i)} (Hessian, piecewise analytic in previous params)
- Ω(h) = γ·T + (λ_reg/2)·Σ_j w_j² (regularization: T leaves, leaf weights w_j)

The optimal leaf weight for leaf j is:
w*_j = -G_j / (H_j + λ_reg), where G_j = Σ_{i∈leaf j} g_i, H_j = Σ_{i∈leaf j} H_i

This is a rational function of restricted sums of g_i and H_i, definable in R_{an,exp}.

### D3: Path-Dependent Singular Fiber
The cumulative singular fiber at round M with shrinkage ν is:

V_M(ν) = {w ∈ W_M : K_M(w; ν) = K*_M(ν)}

where K_M(w;ν) = (1/n) Σ ℓ(y_i, F_0 + ν·Σ_m h_{θ_m}(x_i)) is the KL-divergence proxy.

Path-dependence: at round m, the gradient g_i^{(m)} = ∂ℓ/∂F|_{F_{m-1}} depends on θ_1,...,θ_{m-1} through F_{m-1}. The fiber V_M is not a product of per-round fibers — it is sequentially conditioned:

V_M = {θ_M : K_M(θ_1*,...,θ_{M-1}*, θ_M) = K*_M | θ_1=θ_1*,...,θ_{M-1}=θ_{M-1}*}

The realized path (θ_1*,...,θ_{M-1}*) shapes the loss landscape for θ_M via g_i^{(M)} and H_i^{(M)}.

### D4: ν-Parameterized Stratum Family
Define the ν-stratified loss family:

K_M(w; ν) = (1/n) Σ ℓ(y_i, F_0 + ν·Σ_m h_{θ_m}(x_i))

For fixed M, this is a 1-parameter family {K_M(·; ν)}_{ν ∈ (0,1]}. The singular fiber V_M(ν) varies continuously with ν:
- ν → 0: F_M ≈ F_0 (constant), fiber is wide — many (θ_1,...,θ_M) yield nearly identical predictions
- ν → 1: F_M = F_0 + Σ h_{θ_m}, fiber is narrow — each θ_m strongly affects predictions

The effective fiber dimension grows with M but the accessible region shrinks with ν.

### D5: Cumulative RLCT
The cumulative RLCT of the M-round GBM ensemble with shrinkage ν:

λ_eff(M, ν) = RLCT(K_M(·;ν), V_M(ν))

Hypothesis: λ_eff(M,ν) ≤ λ_eff(M-1,ν) + δ_m(ν), where δ_m(ν) is the marginal RLCT contribution of the m-th tree. The marginal contribution is ν-dependent: for small ν, δ_m(ν) ≈ ν²·δ_m(1) (the tree parameters are shrunk, reducing their singular contribution). For large ν, δ_m(ν) ≈ δ_m(1) (full singular contribution).

Per-parameter effective RLCT: λ̄(M,ν) = λ_eff(M,ν) / (M·d)

### D6: Shrinkage ν as Continuous Stratum Selector
ν ∈ (0,1] serves as a continuous stratum selector. Define:
- λ_eff(ν): effective RLCT as function of ν for fixed M
- Critical ν*(M, D, n): the shrinkage value minimizing the generalization bound

The stratum selector acts by modulating fiber width:
- Width(ν) ∝ 1/ν (heuristic: small ν → wide fiber → more near-optimal configs → higher effective dimension but lower per-parameter singularity)

Optimal ν* balances:
- Bias: too small ν → insufficient learning (F_M barely moves from F_0)
- Variance: too large ν → each tree overfits (kink singularities dominate)

### D7: Generalization Bound with Hessian-Conditioned Complexity
The generalization bound for M-round GBM with shrinkage ν:

G(M, ν) ≤ λ_eff(M,ν)·log(n)/(2n) + B_newton(M,ν)/√n

where B_newton(M,ν) accounts for the Hessian-conditioned complexity:

B_newton(M,ν) = Σ_{m=1}^M ||I_m(θ_m*)^{-1/2}||_op · √(d_m)

Here I_m is the Fisher information matrix of the m-th tree's parameters, conditioned on F_{m-1}. The Newton step effectively rescales parameter space by I_m^{-1/2}, transforming the singular fiber. Well-conditioned I_m (uniform eigenvalues) preserves RLCT; degenerate I_m (near-zero eigenvalues along tree split directions) amplifies singularity.

The Hessian H_i = ∂²ℓ/∂F² enters as per-sample weight in tree fitting, so the Fisher information of leaf weights is:

I_leaf,j = Σ_{i∈leaf j} H_i² / (H_j + λ_reg)²

This connects GBM to the K-FAC / natural gradient framework (#516): the Newton step is a diagonal approximation to the natural gradient in function space.

## Claims (refined from L0)

### C1 (PROVEN): R_{an,exp}-Definability
K_M(w;ν) = (1/n) Σ ℓ(y_i, F_0 + ν·Σ_m h_{θ_m}(x_i)) is R_{an,exp}-definable.

Proof: For tree base learners, h_{θ_m}(x_i) is piecewise constant on a semialgebraic cell decomposition (split thresholds define inequalities, leaf weights are constants). The sum F_M(x_i) = F_0 + ν·Σ_m h_{θ_m}(x_i) is piecewise constant in θ (as a function of split parameters) and linear in leaf weights and ν. The loss ℓ(y, F) is analytic in F (squared error: polynomial; logistic: exp-definable). The gradient g_i and Hessian H_i are derivatives of analytic functions, hence analytic where defined. The optimal leaf weight w*_j = -G_j/(H_j+λ_reg) is a rational function of restricted sums. Composition, summation, and restriction to semialgebraic sets preserve R_{an,exp}-definability. QED.

### C2 (CONJECTURAL): Cumulative Path-Dependent Singular Fiber
V_M(ν) is path-dependent: the fiber geometry at round m depends on realized (θ_1*,...,θ_{m-1}*) through g_i^{(m)} and H_i^{(m)}. Unlike #846 AdaBoost (path-dependence via exponential reweighting), here path-dependence enters through the functional gradient evaluated at the cumulative prediction. The fiber has a recursive structure: V_m = Φ(V_{m-1}, θ_m) where Φ is the pullback through the additive model.

### C3 (CONJECTURAL): Shrinkage ν as Continuous Stratum Selector
ν creates a continuous 1-parameter family of strata {V_M(ν)}_ν. The effective RLCT λ_eff(ν) should decrease as ν → 0 (wider fiber, more degeneracy). Unlike #846's discrete M selector or #877's discrete depth D, ν is continuous, enabling smooth phase transitions. The optimal ν* minimizes G(M,ν), balancing bias (insufficient learning at small ν) against variance (overfitting at large ν).

### C4 (CONJECTURAL): Generalization Bound with Hessian-Conditioned Complexity
The Newton step incorporates Fisher information H_i as per-sample weights, creating a Hessian-conditioned complexity term B_newton in the generalization bound. This is distinct from first-order gradient boosting (no Hessian) and from #846 AdaBoost (exponential loss Hessian is implicitly the weights themselves). The connection to #516 K-FAC: the Newton step is a diagonal natural gradient approximation, and the Fisher information reshapes the singular fiber geometry.

### C5 (CONJECTURAL): Phase Transition at Critical ν*
As ν decreases from 1 to 0, a phase transition occurs at ν* ~ D·log(M)/n. Above ν*: individual tree split-point kink singularities (#877) dominate — λ_eff reflects tree singularity structure. Below ν*: shrinkage averages out kink singularities — F_M becomes smoother, singular fiber transitions to more regular geometry. At ν*, the SGLD local learning coefficient (LLC) should show a derivative kink. The scaling ν* ~ D·log(M)/n reflects the balance between tree complexity (D·M parameters) and sample size n.

## Open Problems

1. Exact RLCT for GBM with squared loss and depth-1 stumps: is λ_eff = ν²·d·M/2?
2. How does Newton-step Hessian conditioning modify RLCT vs first-order GBM (no Hessian)?
3. Joint phase boundary in (ν, D) space: is there a ridge where tree depth and shrinkage trade off exactly?
4. Column subsampling (XGBoost feature subsampling): stochastic stratum selector like dropout (#506)?
5. Recursive fiber structure: can V_m = Φ(V_{m-1}, θ_m) be analyzed inductively to bound λ_eff(M,ν)?
6. Functional gradient as trajectory on singular fiber: gradient descent in function space viewed as movement along V_M?
7. Comparison with #846: does ν·M ≈ const recover AdaBoost's effective complexity, or is the continuous/discrete distinction fundamental?

## Cross-References

#846 AdaBoost (discrete M vs continuous ν, exponential loss vs functional gradient), #877 Decision Tree (base learner A_1 kink singularities, depth D selector), #516 K-FAC (Fisher info / Hessian conditioning / natural gradient), #289 Adam (first vs second-order), #605 Adagrad (cumulative gradient structure), #506 Dropout (stochastic subsampling), #652 Ensemble/Bagging (parallel vs sequential), #383 Data Pruning (sample subset), #213 LR Scheduling (ν schedule as RLCT annealing), #241/#527 Gradient Clipping (gradient norm constraint), #433 Weight Decay (λ_reg as L2 on leaf weights), #553 Gradient Accumulation (cumulative gradient structure)
