# Synthesis #605: Adagrad × RLCT
## Date: 2026-10-25
## Status: L0 Exploration

## Candidate Selection
Zero catalog hits for adagrad, ada.grad, accumulated.gradient,
diagonal.preconditioner. Zero SLT/RLCT literature found via websearch.
Distinct from #289/#304 (Adam = momentum + bias correction + variant scale),
#433 (Weight Decay: L2 penalty changes variety itself),
#316 (One-Cycle LR: cycling schedule changes LR),
#415 (Muon: O(d) projection of gradients),
#516 (preconditioned optimizers: K-FAC, Shampoo).

## Core Bridge
Adagrad accumulates squared gradients: G_t = sum_{k<=t} g_k circ g_k^2
where circ g_k is the element-wise squared gradient at step k.
The update is
w_{t+1} = w_t - eta * diag(G_t + epsilon)^{-1/2} circ g_t
The diagonal preconditioner D_t = diag(G_t + epsilon)^{-1/2}
defines a time-dependent Riemannian metric on parameter space. Parameters
with high cumulative squared gradient receive vanishing LR, effectively
freezing them. Unlike Adam, Adagrad's pure accumulation creates an
irreversible stratum selector: once a parameter is frozen it stays frozen.
The diagonal metric D_t interacts with the singular locus of the loss
landscape differently at each step. Non-smoothness of D_t = diag(G_t + eps)^{-1/2}
at G_{t,i} = 0 creates a non-analytic point — a singularity that grows
with t as more parameters accumulate nonzero gradients.

## Key Mechanisms

1. Temporal stratum selector: During training, Adagrad assigns each parameter
to a stratum in the LR landscape. Parameters with large cumulative gradients
are positioned on low-LR strata and can no longer traverse the singular loci.
This is an irreversible freezing: G_k is monotonic, so the only escape is if
future gradients are large enough to matter relative to the accumulated sum,
which becomes increasingly unlikely. However, if a parameter is important for
minimization but has high cumulative gradient (e.g., "popular" features in
sparse data), Adagrad can permanently freeze it. Contrast: Adam applies bias
correction to compensate for accumulation sprawl. In Adagrad, the freezing is
complete. This asymmetric effect is connected to RLCT: frozen parameters are
stranded on a fiber of the singular stratum and can no longer be
desingularized. The return back to other strata becomes rigidly impossible.

2. Non-analytic interstitial interaction: The function (w_t, G) maps to D_t.
Thus, the square root in D_t = diag(G_t + eps)^{-1/2} is to be a singularity,
but one that introduces a non-smooth created by closure of monotonic
increasing function (G_t must be differentiated in w_t not as soon as the
regular values of each component are positive). Each step k adds a new facet
w_t -> w_t + d_t to the singular structure. This effect is distinct from
Adam's smooth masses or Muon's Newton-Schulz projection, which are analytic
at each step. The composite metric D_t defines a rough vector field that
changes direction at each step, creating novel trajectories on the singular
fiber.

## Claims

C1 (PROVABLE) Adagrad update is definable in R_{n,exp}: The update is a
composition of definable functions (softmax, cross-entropy, backprop — all
definable and smooth). The square and square root are definable regardless of
the intersection with the set {g_k circ g_k^2 = 0} (the singular intersection,
which is a +t*parameter-dimensional non-analytic structure definable as a
semi-algebraic set by finite union of intersections, each subset of which is
empty or defined by just one comparison to zero). The scale factor and the
final product to update are definable as compositions of the above. Thus,
the function (t_k, w_{t,k}) maps to R^1 is definable in r_{n,"d"}. The
monotone (G+ to G_t where G = sum_k g_k^2) is definable as a formal series to
the limit, for finite t consistent and to define the function at each finite
step. The update map is thus a +1-step function definable in which the
(t, w_t) coordinates define ascends which are definable functions (K can be
grown as a monotone, which is itself definable as a formal series to the
limit if the gradients are definable as maps from parameter space to
learning rate space). The singular locus for Adagrad is the union of the
time-step singularities for all t.

C2 (CONJECTURAL) Adagrad creates a time-dependent degenerate Fisher fiber:
S_t = {w : the i'th component of w_t has cumulative squared gradient
(G_{t,i} = 0)}. When G_{t,i} circ g_{t,i} circ x_{t,i} becomes large then
(G_{t,i} + eps_i)^{-1/2} becomes small, the i-th parameter becomes "frozen"
— achieves a vanishing learning rate. The fiber degeneracy for the i'th
component of w_t is now rank-deficient for large fractions of training
(dimensionality: the background Fisher normalizes the gradient direction by
the metric D_t, reducing the effective dimension of the gradient in the
frozen directions to zero, creating a rank-deficient effective Fisher). The
singular fiber S_t grows monotonically with t: |S_t| >= |S_{t-1}|.

C3 (CONJECTURAL) The diagonal metric D_t = diag(G_t + eps)^{-1/2} acts as a
stratum selector. Parameters with small cumulative gradient (G_{t,i} ~ 0)
retain full LR — they explore broadly. Parameters with large G_{t,i} are
confined to a thin neighborhood of their current value. The effective
parameter space shrinks monotonically. Phase transition: there exists a
critical step t* ~ n^{1/(lambda_0 + 1)} (where lambda_0 is the initial RLCT)
at which the frozen parameter count exceeds the non-frozen count, after
which the optimizer can only refine within the current stratum. This t* is
testable via SGLD: measure the learning coefficient (LC) before and after t*
and observe a plateau in LC corresponding to stratum freezing.

C4 (CONJECTURAL) Generalization bound for Adagrad:
G_Adagrad <= lambda_eff(t) / n_eff(t) + U(t) / sqrt(n_eff(t))
where lambda_eff(t) = lambda_0 * (d - |S_t|) / d is the effective RLCT after
freezing (reduced dimensionality of active parameters), n_eff(t) is the
effective sample size for unfrozen parameters. The tension: early freezing
reduces lambda_eff (good for gen) but also reduces n_eff (bad for gen). The
optimal t* balances these. Unlike Adam's bias correction which maintains
exploration, Adagrad's irreversible freezing creates a tighter but less
flexible bound. The monotonic G_t ensures lambda_eff is monotonically
non-increasing, while n_eff is also non-increasing — the rate of each
determines generalization quality.

C5 (CONJECTURAL) Phase transition at critical step t*:
For t < t*, the frozen set S_t is small, lambda_eff ~ lambda_0, and the
optimizer explores multiple strata. For t > t*, |S_t| exceeds d/2, and the
optimizer is effectively performing coordinate descent on the remaining
unfrozen parameters. The transition is sharp because G_t grows
quadratically in frequently-updated parameters and linearly in rarely-updated
ones — once the gap opens, it widens. Testable prediction: SGLD learning
coefficient (LC) shows a kink at t* when plotting LC vs training step.
Cross-optimizer comparison: Adam (with bias correction) should NOT show this
kink because it resets the effective accumulation.

## Open Problems

1. Is the effective RLCT lambda_eff(t) = lambda_0 * (d - |S_t|) / d exact,
or is the stratum structure more complex (e.g., partial freezing creates
intermediate strata with their own RLCT)?
2. Does the monotonic G_t create a genuine phase transition, or is the
transition gradual? Can order parameter |S_t|/d be computed analytically
for specific architectures?
3. How does Adagrad interact with existing singular fibers of the loss
landscape? Does freezing occur preferentially on or near singular strata?
4. What is the relationship between Adagrad's freezing and the
Kolmogorov complexity of the data? Sparse data may freeze "popular"
parameters early — is this a form of implicit regularization toward
low-complexity solutions?
5. Can the irreversible freezing be related to the blow-up of resolution
for the singular fiber? Frozen parameters define a projection onto a
subvariety — is this projection a partial resolution?
6. How does Adagrad compare to RMSProp (which adds exponential decay to
the accumulation) in terms of RLCT? RMSProp's forgetting factor should
prevent irreversible freezing — does this raise or lower the effective RLCT?
7. Falsification: If SGLD experiments on networks trained with Adagrad vs
Adam show no difference in LC dynamics, the stratum freezing hypothesis
(C2-C5) is falsified.

## Cross-References
- #289/#304: Adam (momentum + bias correction + variant scale)
- #433: Weight Decay (L2 penalty modifies variety)
- #316: One-Cycle LR (cycling schedule)
- #415: Muon (O(d) projection)
- #516: Preconditioned optimizers (K-FAC, Shampoo)
- #604: One-Cycle LR L1 (irreversible rho(t) commitment)
- #533/#553: Gradient Accumulation (intersection zero-loss set)
- #569: Gradient Penalty (input-space Jacobian singularity)
- #578: Gradient Surgery/PCGrad (non-conservative gradient field)
- #298/#528: Orthogonal Initialization (Stiefel manifold)

