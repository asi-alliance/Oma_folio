#616 Z-Loss Regularization x RLCT - L0 FORMALIZATION (2026-10-25)

## Status: L0 COMPLETE | C1 PROVEN | C2-C5 CONJECTURAL

---

## Technique: Z-Loss [Golovneva et al., 2021; Press et al., 2021]

Z-loss adds an auxiliary penalty term to the cross-entropy loss:

L_total = L_CE + alpha * (log Z)^2

where Z = Sum_k exp(logit_k) is the softmax normalizer (log-partition function), and alpha is a small regularization coefficient. This regularizes the magnitude of logits indirectly by penalizing the log-normalizer.

## Key Insight

The standard cross-entropy loss L_CE = -log(p_y) = -logit_y + log Z already contains log Z. Adding alpha*(log Z)^2 creates a HIGHER-ORDER singularity in the loss landscape: the standard singularity is at Z->0 (or equivalently logit_y -> -inf relative to others), but the z-loss term adds a singularity at log Z -> 0 (i.e., Z -> 1, the uniform distribution limit).

This creates a NESTED singularity structure:
- Inner: log Z (already transcendental, present in CE)
- Outer: (log Z)^2 (polynomial of the inner transcendental)

The composition creates a degenerate critical point when log Z = 0 (Z = 1), where the gradient of the z-loss term vanishes. This is distinct from:
- #8 CE: singularity at argmax boundary (logit_y - log Z -> 0)
- #224 Temperature Scaling: T reshapes softmax but does not add polynomial structure to log Z
- #282 Weight Decay: L2 penalty on weights, singularity at theta=0, not in function space
- #359 Nucleus Sampling: truncation singularity at cumulative threshold

## Level 0: Definitions

### Precise Function Specification

Let theta in R^d be network parameters, producing logits l(theta, x) = (l_1, ..., l_K) for K classes.

Standard CE loss:
L_CE(theta) = -l_y(theta) + log(Sum_k exp(l_k(theta)))

Z-loss regularized loss:
L_z(theta) = L_CE(theta) + alpha * (log Z(theta))^2
where Z(theta) = Sum_k exp(l_k(theta))

The total loss is:
L(theta) = L_z(theta) = -l_y(theta) + log Z(theta) + alpha * (log Z(theta))^2

### Singularity Structure Analysis

The Kullback-Leibler divergence from true distribution q to model p:
KL(q || p) = Sum_k q_k log(q_k / p_k) = -H(q) + H(q, p)

The model cross-entropy H(q, p) = -Sum_k q_k log p_k where p_k = exp(l_k) / Z.

The z-loss modifies this to:
H_z(q, p) = H(q, p) + alpha * (log Z)^2

The singular set (where the loss achieves its minimum) is determined by the interaction between the CE minimum (perfect classification: p = q) and the z-loss minimum (Z = 1, i.e., uniform logits).

When the true distribution is one-hot (q = e_y), these two objectives COMPETE:
- CE wants: l_y >> l_k for k!=y, making Z approx exp(l_y) and log Z approx l_y (large)
- Z-loss wants: log Z approx 0, i.e., Z approx 1, i.e., all logits approx 0 (or equal)

This competition creates a NONTRIVIAL singular fiber: the global minimum is at a point where the CE gradient and z-loss gradient balance, creating a degenerate critical point that is neither the pure-CE minimum nor the uniform-distribution point.

### R_{an,exp}-definability (C1 - PROVEN)

The loss function L_z(theta) is R_{an,exp}-definable:
- l_k(theta) are polynomial (hence R_an-definable) in theta for a standard network
- exp(l_k) is R_{an,exp}-definable by definition
- Z = Sum_k exp(l_k) is a finite sum of R_{an,exp}-definable functions, hence R_{an,exp}-definable
- log Z is R_{an,exp}-definable (log is in the language)
- (log Z)^2 is polynomial of R_{an,exp}-definable, hence R_{an,exp}-definable
- L_z = -l_y + log Z + alpha*(log Z)^2 is a sum of R_{an,exp}-definable functions

Therefore L_z in R_{an,exp}^def. QED

### Five Claims

**C1 (PROVEN):** L_z is R_{an,exp}-definable. The z-loss term (log Z)^2 is a polynomial of a logarithm of an exponential sum, all within the R_{an,exp} structure. The standard RLCT framework applies.

**C2 (CONJECTURAL):** The z-loss creates a DISTINCT singular fiber from pure CE. The competition between CE minimization (log Z -> large) and z-loss minimization (log Z -> 0) creates a degenerate critical manifold at the balance point. The RLCT lambda_z of the z-regularized loss differs from lambda_CE of pure CE. Specifically, the Hessian of (log Z)^2 at the balance point has a vanishing eigenvalue along the log Z direction, potentially INCREASING the RLCT (more degenerate) relative to pure CE.

**C3 (CONJECTURAL):** The regularization coefficient alpha acts as a STRATUM SELECTOR. As alpha increases from 0 to infinity:
- alpha = 0: pure CE, standard RLCT lambda_CE
- Small alpha: perturbed CE, lambda shifts continuously
- Critical alpha*: phase transition - the global minimum jumps from the CE-favoring region to the z-loss-favoring region
- alpha -> infinity: loss dominated by (log Z)^2, minimum at Z=1 (uniform), lambda -> lambda_uniform

The stratum structure is parameterized by alpha, analogous to #224 temperature scaling but acting on the loss function rather than the inference-time softmax.

**C4 (CONJECTURAL):** Generalization bound. The z-loss modifies the standard SLT generalization bound. The free energy F_n(theta) = -E_n[log p] + alpha*(log Z)^2 has a modified RLCT lambda(alpha) controlling the asymptotic:

G(alpha) = L_0(alpha) + lambda(alpha)*(log n)/n - (m-1)*(log log n)/n + o(1/n)

where lambda(alpha) interpolates between lambda_CE (alpha=0) and lambda_uniform (alpha->infinity). The z-loss may IMPROVE generalization (lower lambda) when it reduces the effective complexity of the singular fiber, or HARM it when it increases degeneracy.

**C5 (CONJECTURAL):** Phase transition at critical alpha*. There exists alpha* where the global minimum of L_z transitions from the classification-optimal stratum (CE-dominated) to the uniformity-enforced stratum (z-loss-dominated). At alpha*, the RLCT lambda(alpha) has a discontinuity or sharp gradient, creating a detectable phase transition observable via SGLD/LLC estimation. The z-loss thus provides a tunable knob for controlling the singular geometry of the loss landscape.

## Open Problems

1. Compute lambda_z(alpha) explicitly for a simple model (e.g., 2-class logistic regression) and verify the alpha-dependence
2. Determine whether the (log Z)^2 term INCREASES or DECREASES degeneracy at the CE minimum
3. Characterize the phase transition alpha*: is it a discontinuous jump or a smooth crossover?
4. SGLD estimation: can LLC measurements detect the stratum transition as alpha varies?
5. Interaction with label smoothing (#224/#323): does smoothed z-loss create a richer singular fiber?
6. Interaction with weight decay (#282): does L2 + z-loss create a product singularity?
7. Z-loss in transformers: the log Z magnitude correlates with confidence - does z-loss regularization shift the RLCT of attention heads?

## Cross-References

- #8: Cross-entropy loss (base singularity)
- #224: Temperature scaling (T as softmax parameter, related but acts on inference not loss)
- #282: Weight decay (L2 penalty, different singularity locus)
- #323: Label smoothing (soft targets, modifies CE singularity)
- #359: Nucleus sampling (Z-threshold truncation)
- #411: Temperature scaling x RLCT (T reshapes loss landscape)
- #392: Top-k sampling (discrete stratum via rank truncation)
- #390: Locally typical sampling (entropy-constrained selection)
- #618: Sparsemax/entmax (alternative softmax relaxations)
- #243/#409: Gumbel-softmax (discrete relaxation via noise injection)

---
## L0 COMPLETE. Next: L1 formalization (rigorous definitions of singular set, fiber structure, RLCT computation for simple model).