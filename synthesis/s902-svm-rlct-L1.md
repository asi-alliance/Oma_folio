# Synthesis #902: SVM (Support Vector Machine) × RLCT — L1 Formalization

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L1 (formal definitions, pre-proof)

---

## Definitions

### D1: Parameter Space

**Linear SVM:** θ = (w, b) ∈ W = R^d × R = R^{d+1}. The decision function is:

f_θ(x) = w·x + b

**Kernel SVM:** θ is implicitly defined in the Reproducing Kernel Hilbert Space (RKHS) H_k associated with a positive semi-definite kernel k(x, x'). By the representer theorem, w = Σ_i α_i k(x_i, ·), so the effective parameter space is α ∈ R^n (dual coefficients) with the constraint that w ∈ H_k. The primal parameter space W_H = H_k is potentially infinite-dimensional.

**Regularized parameter space (soft-margin):** The full parameter space includes slack variables ξ = (ξ_1, ..., ξ_n) ∈ R_+^n. The augmented space is W_aug = R^{d+1} × R_+^n with the constraint that ξ_i ≥ 0 for all i. The slack variables are data-dependent auxiliary parameters.

**Norm constraint:** The weight norm ||w||² enters the objective as a regularizer. The feasible set for hard-margin SVM is {θ : y_i(w·x_i + b) ≥ 1 ∀i}, a convex polytope in R^{d+1} defined by n linear inequalities.

### D2: Hinge Loss and Soft-Margin Objective

The hinge loss for a single sample (x_i, y_i) with y_i ∈ {-1, +1}:

L_hinge(y_i, f_θ(x_i)) = max(0, 1 - y_i·f_θ(x_i))

The soft-margin SVM primal objective:

L_C(θ, ξ) = (1/2)||w||² + C·Σ_{i=1}^n ξ_i

subject to: y_i(w·x_i + b) ≥ 1 - ξ_i, ξ_i ≥ 0 ∀i

Equivalently, eliminating ξ_i = max(0, 1 - y_i·f_θ(x_i)):

L_C(θ) = (1/2)||w||² + C·Σ_{i=1}^n max(0, 1 - y_i·(w·x_i + b))

**KL divergence proxy:** K_C(θ) = L_C(θ) - L_C(θ*_C) where θ*_C is the minimizer.

**Fisher information matrix (primal):**

I(θ) = (1/n) Σ_{i=1}^n 𝟙[y_i·f_θ(x_i) < 1] · x_i x_i^T

where 𝟙[·] is the indicator function. The Fisher is piecewise-constant: it changes only when a data point crosses the margin boundary y_i·f_θ(x_i) = 1. This is fundamentally different from #896 (logistic regression) where I(θ) = Σ σ'(·)²·x_i x_i^T is smooth and varies continuously.

**Dual formulation:** The Lagrangian dual introduces multipliers α_i ≥ 0:

L_D(α) = Σ_i α_i - (1/2)Σ_{i,j} α_i α_j y_i y_j k(x_i, x_j)

subject to: Σ_i α_i y_i = 0, 0 ≤ α_i ≤ C. The KKT complementarity conditions: α_i(1 - ξ_i - y_i·f_θ(x_i)) = 0 and (C - α_i)·ξ_i = 0 define the singular structure.

### D3: R_{an,exp}-Definability (C1)

L_C(θ) is R_{an,exp}-definable.

**Proof:** The hinge loss max(0, 1 - y·(w·x+b)) = max(0, z) where z = 1 - y·(w·x+b) is affine in θ (hence R_an-definable). The function max(0, z) is semi-algebraic (defined by the formula (z ≥ 0 ∧ t = z) ∨ (z < 0 ∧ t = 0)), hence subanalytic, hence R_an-definable (subanalytic functions are definable in R_an by van den Dries). The regularizer (1/2)||w||² is a polynomial, hence R_an-definable. The sum Σ_{i=1}^n of definable functions is definable (finite sum closure). The product C·(definable) is definable (scalar multiplication). Addition of definable functions preserves definability. Therefore L_C(θ) = (1/2)||w||² + C·Σ max(0, 1-y_i·f_θ(x_i)) is R_an-definable, hence R_{an,exp}-definable (R_an ⊂ R_{an,exp}). For kernel SVM, k(x,x') is a Mercer kernel (e.g., Gaussian RBF: exp(-γ||x-x'||²), polynomial: (x·x'+c)^d), both R_{an,exp}-definable. The representer theorem reduces to α-space where the dual objective Σα_i - (1/2)Σα_iα_j y_i y_j k(x_i,x_j) is definable (polynomial in α for polynomial kernels, R_{an,exp} for RBF). QED.

### D4: Data-Dependent Singular Fiber

**Definition:** The singular fiber is determined by the support vector partition. For a given θ, classify each sample:

- **Margin support vectors (SV):** y_i·f_θ(x_i) = 1, i.e., on the margin boundary
- **Slack-active (violators):** y_i·f_θ(x_i) < 1, ξ_i > 0
- **Non-support vectors:** y_i·f_θ(x_i) > 1, ξ_i = 0

The singular fiber decomposes:

V_C = V_SV ∩ V_slack

where:
- V_SV = {θ : y_i·f_θ(x_i) = 1 for i ∈ SV_set} — equality constraints defining a linear subspace
- V_slack = {θ : y_i·f_θ(x_i) < 1 for i ∈ Slack_set} — open region constraints

**Key structural insight:** For non-support vectors, the loss gradient is exactly zero (max(0, z) = 0 for z < 0, gradient = 0). This means the Hessian has zero eigenvalues along directions that move non-SV points — these are flat directions of the loss landscape. The effective dimensionality of the fiber is:

dim(V_C) = (d+1) - |SV_set|

where |SV_set| is the number of (margin) support vectors. This is **data-dependent**: the same θ-space has different fiber dimensions depending on which data points are support vectors.

**Comparison to #896 (logistic regression):** In logistic regression, the Fisher I(θ) is always positive definite (σ'(z)² > 0 for all z), so there are no exact flat directions — the singularity is at infinity. In SVM, flat directions exist at finite θ because hinge loss is exactly zero for non-SV points. This is a fundamentally different singularity mechanism: finite flat directions (#902) vs. infinity divergence (#896).

**KKT singular points:** The complementarity conditions μ_i·ξ_i = 0 and (C-α_i)·ξ_i = 0 create a piecewise structure. Each combination of active/inactive constraints defines a stratum. The set of KKT-satisfying points forms a stratified space where each stratum corresponds to a particular SV partition.

### D5: C-Stratified Loss Family

Define the C-stratified loss family:

{L_C(θ)}_{C ∈ (0,∞)}

The singular fiber V_C varies with C:

- **C → ∞ (hard margin):** ξ_i = 0 for all i (no slack). The fiber is V_∞ = {θ : y_i·f_θ(x_i) ≥ 1 ∀i}. If data is linearly separable, the solution is unique (minimal ||w||), dim(V_∞) = 0. If not separable, infeasible — the fiber is empty. RLCT is minimal (most constrained).

- **C → 0 (weak regularization):** The penalty C·Σξ_i vanishes, so ξ_i → max(0, 1-y_i·f_θ). With w → 0, all points are violated (ξ_i = 1). The fiber becomes high-dimensional: w ≈ 0, b free, all slack active. RLCT is maximal (least constrained, most degenerate).

- **Critical C* values:** When C crosses a threshold, a data point transitions between SV and non-SV status (or between margin-SV and slack-active). Each transition changes |SV_set| by ±1, altering dim(V_C). These are discrete stratum transitions driven by the continuous parameter C.

**Comparison to #889 (mean shift):** In mean shift, bandwidth h controls mode count via saddle-node bifurcations (Morse theory). In SVM, C controls SV count via constraint activation/deactivation (KKT complementarity). Both are continuous parameters producing discrete stratum changes, but the mechanisms differ: Morse bifurcation (#889) vs. constraint activation (#902).

**Comparison to #433 (weight decay):** In weight decay, λ continuously deforms the fiber (norm compression). In SVM, C changes which constraints are active, producing piecewise-constant fiber dimension with jumps. This is a discontinuous stratum structure.

### D6: Generalization Bound with Margin-Width Complexity

The generalization bound for soft-margin SVM:

G(C) ≤ λ_eff(C)·log(n)/(2n) + U_margin(C)/√n

where:
- λ_eff(C) = RLCT(L_C, V_C), transitioning with C
- U_margin(C) = ||w*_C||^{-1} = margin-width-based complexity

**Margin-width term:**

U_margin(C) = 1/||w*_C||

For large C: ||w*_C|| is large (tight margin), U_margin small → good generalization but risk of overfitting if λ_eff is also small. For small C: ||w*_C|| → 0 (wide margin, many violations), U_margin → ∞ → poor generalization.

**Slack penalty bias:**

B_slack(C) = C·E[ξ] = C·(1/n)Σ max(0, 1-y_i·f_θ(x_i))

This adds a data-dependent bias term. For C → ∞, B_slack is large (penalizes violations heavily). For C → 0, B_slack → 0 (tolerates violations).

**VC dimension connection:** The SVM VC dimension is d_VC ≤ ||w||²·R² + 1 where R = max||x_i||. This connects the margin-width complexity U_margin to classical VC theory. The RLCT bound subsumes the VC bound: when the fiber is regular (dim(V_C) = d+1), λ_eff = (d+1)/2 ~ d_VC/2. When the fiber is singular (dim(V_C) < d+1 due to SV constraints), λ_eff < (d+1)/2, improving on VC.

**Comparison to #896:** In logistic regression, the divergence-aware term B_div = ||w*||·√(tr(I^{-1})) captures complexity of weights going to infinity. In SVM, the margin term U_margin = 1/||w*|| captures complexity of margin being too wide (underfitting). These are complementary: #896 worries about ||w|| → ∞, #902 worries about ||w|| → 0.

### D7: Phase Transition at Critical C*

**Definition:** Critical C* values are defined by support vector set changes:

C*_k = {C : ∃i, y_i·f_θ*(C)(x_i) = 1 and the point i transitions between SV and non-SV}

At each C*_k, the SV set changes by one element, dim(V_C) changes by ±1, and the RLCT λ_eff(C) has a discontinuity or kink.

**Predicted LLC profile:**

- C ≫ C*_max (hard margin): LLC ≈ |SV|/2 (regular, minimal fiber dimension)
- C ≈ C*_k: LLC has step change (stratum crossing)
- C ≪ C*_min (degenerate): LLC ≈ (d+1)/2 + n/2 (all slack active, maximal degeneracy)

**Non-smooth LLC:** Unlike #896 (smooth LLC profile in λ) or #889 (smooth U-shaped LLC in h), the SVM LLC profile is piecewise-constant with jumps at C*_k values. This is because the fiber dimension changes discretely, not continuously. Each jump corresponds to a constraint activation/deactivation event.

**KKT stratum diagram:** The space of (θ, C) can be decomposed into strata S_P where P ⊂ {1,...,n} is the active SV set. Each stratum S_P = {(θ, C) : i ∈ SV_set(θ,C) ⟺ i ∈ P}. Strata are separated by codimension-1 walls where y_i·f_θ(x_i) = 1. The LLC trajectory as C varies traces a path through this stratified space, with step changes at wall crossings.

**SGLD detection:** Subgradient SGLD on SVM requires care (hinge loss non-differentiable at y·f=1). The LLC should show step-like profile in C, distinguishable from: (a) #896 logistic (smooth knee), (b) #889 mean shift (U-shaped with bifurcation steps), (c) #870 L1/Lasso (kink at coordinate zero, not margin boundary), (d) #433 weight decay (smooth in λ).

## Claims (refined from L0)

### C1 (PROVEN): R_{an,exp}-Definability
See D3 above. Hinge loss is subanalytic (semi-algebraic max), regularization is polynomial. SVM objective is R_an-definable, hence R_{an,exp}-definable. Kernel extensions (RBF, polynomial) preserve definability.

### C2 (CONJECTURAL): Data-Dependent Singular Fiber
The singular fiber V_C = V_SV ∩ V_slack is data-dependent: its dimension is (d+1) - |SV_set|, determined by which data points are support vectors. Non-SV points contribute exact flat directions (zero gradient). This is the first data-dependent singular fiber in the catalog — all prior fibers (#896, #870, #889, #433) depend on model parameters, not on which data points activate constraints. The KKT complementarity conditions define a stratified space of singular points.

### C3 (CONJECTURAL): C as Constraint-Activation Stratum Selector
C is a continuous parameter that produces discrete stratum transitions: as C varies, points cross the margin boundary, changing the SV set and fiber dimension. Unlike #889 (continuous Morse bifurcations) or #433 (continuous fiber deformation), SVM has discontinuous fiber dimension jumps. C* values are data-dependent thresholds. The piecewise-constant structure of dim(V_C) is unique in the catalog.

### C4 (CONJECTURAL): Generalization Bound with Margin-Width Complexity
G(C) ≤ λ_eff·log(n)/(2n) + 1/(||w*||·√n) + C·E[ξ]/n. The margin-width term 1/||w*|| connects to VC dimension. The RLCT subsumes VC: when singular (SV constraints active), λ_eff < (d+1)/2 improves on VC bound. Slack bias B_slack adds data-dependent regularization cost. Distinct from #896 (divergence at infinity) — #902 worries about underfitting (||w||→0), not overfitting (||w||→∞).

### C5 (CONJECTURAL): Phase Transition at C*
Discrete phase transitions at C*_k values where SV set changes. LLC is piecewise-constant with jumps. KKT stratum diagram: (θ, C) space decomposed by active SV set, walls at y_i·f=1. Non-smooth LLC profile (step function) is qualitatively distinct from #896 (smooth knee), #889 (U-shaped), #870 (kink at zero), #433 (smooth deformation). Subgradient SGLD required for empirical verification.

## Open Problems

1. Formalize RLCT for non-smooth subanalytic loss: does resolution of singularities apply to piecewise-linear varieties?
2. Exact λ for hard-margin vs soft-margin: is λ = |SV|/2 (constraint dimension counting)?
3. Kernel trick: does RKHS feature map change RLCT? (Mercer kernel singularity, infinite-dimensional H_k)
4. Multi-class SVM (Crammer-Singer): how do class-wise SV sets interact in the stratum diagram?
5. VC dimension connection: is λ_SVM ≤ d_VC/2 always (RLCT tightens VC)?
6. Subgradient SGLD: does LLC still track RLCT when loss is non-differentiable at stratum boundaries?
7. Nu-SVM: parameter ν as alternative stratum selector (upper/lower bound on SV fraction) — does ν produce different stratum structure than C?

## Cross-References

#831 SVM cross-ref (nuclear norm), #896 Logistic Regression (smooth sigmoid vs piecewise-linear hinge), #870 L1/Lasso (coordinate-zero kink vs margin-boundary kink), #433 Weight Decay (continuous deformation vs discrete stratum jumps), #889 Mean Shift (Morse bifurcation vs constraint activation), #872 K-Means (unsupervised geometric vs supervised margin), #567 DPO (β stratum selector), #880 N-Gram (discrete counting), #877 Decision Tree (piecewise partition), #282 L2 regularization, #901 (prior synthesis), #8 (RLCT foundational)