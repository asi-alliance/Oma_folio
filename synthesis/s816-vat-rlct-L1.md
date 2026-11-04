# Synthesis #816: Virtual Adversarial Training (VAT) × RLCT — L1 Formalization

### Date: 2026-10-28
### Status: L1
### Pipeline: L0 done L1 done L2 PENDING

---

# Formal Definitions

## D1: Parameter Space and Model
Let p(y|x, theta) = softmax(h_theta(x)) be a neural network with parameters theta in R^d.
The output is a probability distribution over C classes:
  p_c(y|x, theta) = exp(h_c) / sum_j exp(h_j), where h = h_theta(x).
All operations (linear, ReLU, softmax) are definable in R_{an,exp}.

## D2: Local Distributional Smoothness (LDS)
For input x_n and perturbation r with ||r|| <= epsilon:
  DKL_n(theta; r) = sum_c p_c(y|x_n, theta) * log(p_c(y|x_n, theta) / p_c(y|x_n + r, theta))
The virtual adversarial perturbation:
  r*_n(theta; epsilon) = argmax_{||r||<=epsilon} DKL_n(theta; r)
The VAT regularization term:
  L_VAT(theta; epsilon) = -(1/N) sum_n DKL_n(theta; r*_n(theta; epsilon))
Definability: DKL is sum of softmax * log(ratio of softmax) — all R_{an,exp}-definable.
argmax over compact semialgebraic ball — definable selection theorem applies. C1 PROVEN.

## D3: VAT Singular Fiber
V_VAT(epsilon) = { theta : L_VAT(theta; epsilon) = 0 }
= { theta : for all n, for all r with ||r||<=epsilon, p(y|x_n+r, theta) = p(y|x_n, theta) }
= { theta : for all n, ||grad_x p(y|x_n, theta)|| = 0 }

This requires local constancy of the prediction function on epsilon-balls.
Stronger than V_adv(epsilon) from #590 (correctness under perturbation).
The fiber V_VAT is defined by vanishing input-Jacobian conditions:
  for all n, for all c: grad_x p_c(y|x_n, theta) = 0
Each condition is a set of polynomial equations (after clearing denominators from softmax).
Codimension >= C * dim(input) per data point. C2 CONJECTURAL.

## D4: Epsilon-Stratified Loss Family
L_VAT(theta; epsilon) = -(1/N) sum_n sup_{||r||<=epsilon} DKL_n(theta; r)
V_VAT(epsilon_2) subset V_VAT(epsilon_1) for epsilon_2 > epsilon_1 (decreasing filtration).
lambda_VAT(epsilon) = RLCT of K_VAT(theta; epsilon) = L_VAT(theta; epsilon) - min_theta L_VAT(theta; epsilon).
At epsilon = 0: DKL = 0 for all r = 0, so L_VAT = 0 identically (gauge degeneracy, no RLCT).
At epsilon > 0: L_VAT is nontrivial, RLCT well-defined.
C3 CONJECTURAL: epsilon as continuous stratum selector with monotone lambda_VAT(epsilon) increasing in epsilon.

## D5: Power Iteration Approximation
The adversarial perturbation r* is approximated by K steps of power iteration:
  d_0 = random unit vector
  d_k = grad_r DKL(theta; epsilon * d_{k-1}) / ||grad_r DKL(theta; epsilon * d_{k-1})||
  r_K = epsilon * d_K
L_VAT^K(theta) = -(1/N) sum_n DKL_n(theta; r_K(theta))
Each step: grad_r of DKL is definable (chain rule on softmax), normalization is definable.
Finite K: L_VAT^K is R_{an,exp}-definable (composition of definable maps).
K -> infinity: fixed point may introduce new singularity type.
V_VAT^K(epsilon) = { theta : L_VAT^K(theta; epsilon) = 0 } approximates V_VAT(epsilon).
C5 CONJECTURAL: exists K* such that for K < K*, lambda_VAT^K < lambda_VAT^infty (underestimated).

## D6: Total Objective and Generalization Bound
L_total(theta) = L_sup(theta) + alpha * L_VAT(theta; epsilon)
V_total = V_sup intersect V_VAT(epsilon)
K_total(theta) = L_total(theta) - min_theta L_total(theta)
G_VAT(n) <= lambda_total(epsilon, alpha) * log(n) / (2n) + U_total(epsilon, alpha) / sqrt(n)
Under transversality: lambda_total approx lambda_sup + alpha * lambda_VAT(epsilon)
Semi-supervised benefit: VAT term uses N_labeled + N_unlabeled data,
effectively increasing n for the regularization component.
C4 CONJECTURAL: lambda_VAT captures smoothness complexity of the model.

## D7: Phase Transition at Critical Epsilon*
epsilon* = critical radius where:
  lambda_VAT(epsilon*) * log(n) / (2n) ~ U_VAT(epsilon*) / sqrt(n)
For epsilon < epsilon*: V_VAT(epsilon) is large (weak constraint), lambda_VAT low.
For epsilon > epsilon*: V_VAT(epsilon) is small (strong constancy), lambda_VAT high.
SGLD prediction: LLC trace shows kink/discontinuity at epsilon*.
Additional phase transition at K* (power iteration steps) and alpha* (VAT weight).
C5 CONJECTURAL.

---

# Claims

C1 (PROVEN): R_{an,exp} definability. DKL is softmax/log composition (definable). argmax over compact semialgebraic ball by definable selection theorem. Finite-K power iteration is composition of definable maps. QED.

C2 (CONJECTURAL): VAT smoothness fiber V_VAT(epsilon) has higher codimension than V_adv(epsilon) from #590, because output constancy is stronger than correct classification. V_VAT requires grad_x p = 0 at all data points.

C3 (CONJECTURAL): epsilon as continuous stratum selector. lambda_VAT(epsilon) monotonically increasing in epsilon. epsilon = 0 gives gauge degeneracy (L_VAT = 0 identically). Larger epsilon forces stronger smoothness, higher codimension fiber, higher RLCT.

C4 (CONJECTURAL): Generalization bound G_VAT(n) <= lambda_total * log(n)/(2n) + U_total/sqrt(n). Semi-supervised benefit: VAT uses unlabeled data, effectively increasing sample size for regularization term. lambda_VAT captures smoothness complexity.

C5 (CONJECTURAL): Dual phase transitions at epsilon* (perturbation radius) and K* (power iteration steps). SGLD predicts LLC kinks at both. K* related to spectral gap of input-space Hessian of DKL.

---

# Open Problems

P1: Exact RLCT of V_VAT(epsilon) — dependence on epsilon, network depth, width. Is lambda_VAT(epsilon) >= lambda_adv(epsilon) always?

P2: Does finite-K power iteration create a genuinely different singular fiber, or is V_VAT^K dense in V_VAT^infty? What is the convergence rate of lambda_VAT^K to lambda_VAT^infty?

P3: Transversality of V_sup and V_VAT(epsilon): does lambda_total = lambda_sup + alpha * lambda_VAT hold, or do higher-order singularities arise from the intersection?

P4: Connection to spectral norm regularization (#569): V_VAT requires grad_x p = 0, related to Lipschitz constraint. How does lambda_VAT relate to lambda_Lipschitz?

P5: Semi-supervised quantification: does the VAT term benefit from N_total = N_labeled + N_unlabeled, reducing lambda_VAT * log(n)/(2n) proportionally?

P6: VAT vs entropy regularization (#547): does VAT subsume entropy regularization, or do they target different singular strata?

P7: Power iteration and Hessian spectrum: how does the spectral structure of the input-space Hessian of DKL relate to the RLCT of V_VAT? Is K* determined by the spectral gap?

---

# Cross-References
#8 (RLCT basics), #97 (SGD), #100 (gradient descent), #327 (pseudo-labeling — self-referential),
#547 (entropy regularization — output distribution regularizer), #569 (gradient penalty — Lipschitz connection),
#590 (adversarial training — CE+labels vs KL+self), #615 (consistency regularization — augmentation invariance),
#540 (InfoNCE — contrastive KL), #541 (VICReg — geometric regularization), #224 (label smoothing — soft target),
#169 (dropout — stochastic regularization), #173 (SAM — parameter-space perturbation)