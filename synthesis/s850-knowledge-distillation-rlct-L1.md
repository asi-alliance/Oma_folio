# Synthesis #850: Knowledge Distillation × RLCT
## L1: Formal Definitions & Definability
**Date:** 2026-11-06
**Status:** L1 Formalization

---

### D1: Parameter Space
Let theta in R^d be the student parameters. Let mu in R^{n|d} be the fixed teacher parameters (not optimized). Let alpha in [0,1] be the hard-label mixing weight and T > 0 the distillation temperature. Let K be the number of classes.

The full parameter space for the loss landscape is Theta_KD = R^d (student) x [0,1] (alpha) x R_{>0} (T), with teacher mu fixed.

### D2: KD Composite Loss
For input x_i with label y_i (one-hot) and teacher logits z_t[x_i]:

M(x_i, y_i, z_t) = alpha * CE(y_i, z_s) + (1-alpha) * T^2 * KL(p_t || p_s)

where:
- CE(y, z_s) = -sum_k y[k] log softmax(z_s)[k]  (hard-label cross-entropy)
- p_t[k] = softmax(z_t/T)[k], p_s[k] = softmax(z_s/T)[k]  (temperature-scaled distributions)
- KL(p_t || p_s) = sum_k p_t[k] (log p_t[k] - log p_s[k])
- T^2 factor compensates for gradient magnitude scaling by 1/T

The empirical loss: L_KD(theta) = (1/n) sum_i M(x_i, y_i, z_t[i])

Note: The T^2 prefactor on KL is analytic (polynomial) in T. The softmax is analytic. The log is analytic on positive reals. The entire loss is a composition of analytic functions in theta for fixed alpha, T, mu.

### D3: R_{an,exp}-Definability (C1 PROVEN)
**Claim:** The KD composite loss L_KD(theta; alpha, T, mu) is R_{an,exp}-definable in theta for all alpha in [0,1], T > 0.

**Proof:**
1. softmax(z) = exp(z_k) / sum_j exp(z_j) is real-analytic in z (exponential and division of analytic functions).
2. z_s/T is analytic in theta for T > 0 (T fixed, network is analytic composition).
3. log(softmax(z_s/T)[k]) is analytic where softmax > 0 (always true for finite z).
4. CE = -sum_k y[k] log softmax(z_s)[k]: polynomial in y, analytic in theta. R_{an,exp}-definable.
5. KL(p_t || p_s) = sum_k p_t[k] log(p_t[k]/p_s[k]): p_t is constant (teacher fixed), p_s analytic in theta, log analytic. R_{an,exp}-definable.
6. T^2 * KL: polynomial (T^2) times R_{an,exp}-definable. Still R_{an,exp}-definable.
7. alpha * CE + (1-alpha) * T^2 * KL: convex combination of two R_{an,exp}-definable functions. R_{an,exp} is closed under addition and scalar multiplication. QED.

### D4: Singular Fiber V(alpha, T, theta) [C2 CONJECTURAL]
**Hard fiber:** V_hard(theta) = {theta : L_KD = 0 forall i} when alpha=1, i.e. softmax(z_s)[k] = y_i[k] for all i (perfect hard-label classification). This is the standard cross-entropy zero-loss set with A1-type corner singularities at decision boundaries.

**Soft fiber:** V_soft_T(theta) = {theta : f_T(theta) = const_T forall i} when alpha=0, i.e. softmax(z_s/T) = softmax(z_t/T) for all i (perfect teacher matching). The soft fiber depends on T: as T -> inf, the target approaches uniform (1/K), making the fiber trivially satisfied. As T -> 0+, the target approaches one-hot at argmax(z_t), converging to V_hard at the teacher's argmax labels.

**Composite fiber:** V(alpha, T, theta) = {theta : alpha * CE(theta) + (1-alpha) * T^2 * KL_T(theta) = 0}. For alpha in (0,1), this requires BOTH CE = 0 AND KL = 0 simultaneously (sum of non-negative terms = 0 implies each = 0). Therefore:

V(alpha, T) = V_hard intersect V_soft_T  for 0 < alpha < 1

This is a KEY structural insight: the composite fiber is the INTERSECTION of hard and soft fibers, not a convex blend. The intersection can have HIGHER codimension than either fiber alone, creating new intersection singularities absent in both V_hard and V_soft.

For alpha = 0: V = V_soft_T (soft-only).
For alpha = 1: V = V_hard (hard-only).

**Gap:** The intersection V_hard intersect V_soft_T may be empty for finite T (hard and soft targets incompatible). The RLCT of the intersection lambda_intersect >= max(lambda_hard, lambda_soft) by codimension inequality. This CONTRADICTS the L0 claim that lambda_hard >= lambda(alpha,T) >= lambda_soft. The correct bound is lambda_intersect >= max(lambda_hard, lambda_soft), meaning the composite fiber is MORE singular, not less. Revising C2.

### D5: Temperature T as Continuous Stratum Selector [C3 CONJECTURAL]
T controls the resolution of the soft target distribution:
- T -> inf: p_t -> uniform(1/K). KL(uniform || p_s) = log K - H(p_s). Soft fiber becomes {theta : H(p_s) = log K} = {theta : p_s = uniform}, which is a low-complexity singularity (all logits equal).
- T -> 0+: p_t -> one-hot(argmax z_t). Soft fiber converges to V_hard at teacher argmax labels.
- Intermediate T: soft fiber encodes class similarity structure (dark knowledge).

The stratum selector acts via T: lambda_soft(T) is monotonically increasing as T decreases from inf to 0 (more singular as targets sharpen). The composite intersection fiber V_hard intersect V_soft_T has:

lambda(alpha, T) >= max(lambda_hard, lambda_soft(T))

As T decreases, lambda_soft(T) increases toward lambda_hard, and the intersection fiber becomes increasingly singular. At T -> 0, V_soft -> V_hard (if teacher argmax = true labels), and the intersection collapses to V_hard with lambda = lambda_hard.

**Critical T*:** There exists T* where lambda_soft(T*) = lambda_hard. For T > T*, the soft fiber is less singular than hard, and the intersection is dominated by V_hard. For T < T*, the soft fiber is more singular, and the intersection is dominated by V_soft. At T*, the two singularities are balanced.

### D6: Generalization Bound [C4 CONJECTURAL]
Gen bound: G_KD ~ lambda(alpha, T) / (2n) * log(n) + U(alpha, T) / sqrt(n)

where lambda(alpha, T) = RLCT of V(alpha, T) and U(alpha, T) is the fluctuation functional.

For 0 < alpha < 1: lambda(alpha, T) = lambda(V_hard intersect V_soft_T) >= max(lambda_hard, lambda_soft(T)).

The KD generalization advantage does NOT come from lower RLCT (as L0 hypothesized). Instead, it comes from the FLUCTUATION term U(alpha, T): the soft-label KL term provides additional gradient signal that reduces the variance of the empirical process, lowering U. The bias-variance-RLCT tradeoff is:

- Low T: lambda_soft high (more singular soft fiber), but rich class-structure signal (low U)
- High T: lambda_soft low (smooth soft fiber), but uninformative targets (high U)
- Optimal T* minimizes lambda(alpha,T)/(2n)*log(n) + U(alpha,T)/sqrt(n)

### D7: Alpha Mixing Phase Transition [C5 CONJECTURAL]
At alpha = 0: V = V_soft_T (soft fiber only).
At alpha = 1: V = V_hard (hard fiber only).
At 0 < alpha < 1: V = V_hard intersect V_soft_T (intersection).

The phase transition occurs at alpha* where the optimization trajectory switches from being dominated by V_hard to V_soft_T. Since the composite fiber is the intersection (not a blend), the transition is NOT a smooth interpolation but a discrete jump in fiber structure:

- For alpha near 1: optimization primarily minimizes CE, KL is secondary. Effective fiber approx V_hard.
- For alpha near 0: optimization primarily minimizes KL, CE is secondary. Effective fiber approx V_soft_T.
- At alpha*: both terms contribute equally. SGLD should detect a transition in the local learning coefficient.

The empirically observed optimal alpha ~ 0.5-0.7 corresponds to the regime where the intersection fiber's RLCT and the fluctuation term are balanced.

---

## Open Problems
1. Is V_hard intersect V_soft_T non-empty for finite T? (Depends on teacher quality and student capacity)
2. Compute lambda_soft(T) for specific architectures (e.g., ResNet teacher -> CNN student on CIFAR)
3. Is the intersection singularity type A_k, D_k, or E_k? (Depends on teacher-student architecture pair)
4. How does teacher quality (lambda_teacher) affect lambda_soft(T)?
5. Multi-teacher KD: intersection of multiple soft fibers V_soft_T1 intersect V_soft_T2?
6. Does T* depend on K (number of classes)?
7. Connection to #582: is temperature scheduling T(t) a stratum traversal through intersection fibers?

## Cross-References
- #334 (Self-Distillation): EMA teacher, temporal coupling, NOT fixed external teacher
- #169 (Dropout): stochastic regularization, no teacher guidance
- #599 (DPO): preference distillation, logistic loss not KL
- #654 (GFlowNet): temperature in sampling, not in target distribution
- #582 (Curriculum Learning): scheduling as stratum traversal
- #435 (Beam Search): decision boundary singularities at argmax
- #471 (Mixup): interpolation between samples (data level, not loss level)
- #470 (QAT): forward/backward RLCT split
- #8 (SGD): foundational optimizer dynamics
- #16 (Architecture): foundational model singularity
