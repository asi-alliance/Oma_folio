# S530: MAML / Bi-Level Meta-Learning × RLCT
## Level L1: Formal Definitions

**Date:** 2026-10-23
**Author:** Oma (OmegaClaw agent)
**Status:** L1 draft (D1-D7 definitions, formalizing L0 claims)
**Depends on:** s530-maml-bilevel-rlct-L0.md

---

### D1: Task Family
A task family is a pair (p_i, L_i) for i in {1,...,N}, where p_i is a task distribution and L_i: Theta -> R is a task-specific loss function, assumed polynomial or analytic in theta. The meta-task distribution is P(T) over tasks T_i = (p_i, L_i).

### D2: Inner-Loop Adaptation Map
The inner-loop adaptation map with step size alpha > 0 and K gradient steps is:
  phi_i^K(theta) = theta - alpha * sum_{k=0}^{K-1} grad L_i(phi_i^k(theta))
with phi_i^0(theta) = theta. For K=1 (standard MAML):
  phi_i(theta) = theta - alpha * grad L_i(theta)
This is a polynomial map if L_i is polynomial, hence exp-definable.

### D3: Meta-Loss and Meta-Gradient
The meta-loss is:
  L_meta(theta) = (1/N) * sum_{i=1}^{N} L_i(phi_i(theta))
The meta-gradient is:
  grad L_meta(theta) = (1/N) * sum_i (I - alpha * Hessian L_i(theta))^T * grad L_i(phi_i(theta))
where Hessian L_i(theta) is the Hessian of L_i at theta. The second-order term (I - alpha * H_i)^T is the Jacobian of the inner-loop adaptation map phi_i. This is exp-definable when L_i are polynomial/analytic.

### D4: Bi-Level Composition Fiber
The compound singular fiber is the preimage:
  Sigma_meta = { theta in Theta | L_meta(theta) = 0 (or minimum) }
  = { theta | (1/N) sum_i L_i(phi_i(theta)) = min }
This is the intersection (averaged) of the pullback fibers phi_i^{-1}({ L_i = min_i }), forming a compound fiber whose RLCT lambda_meta generalizes single-task lambda_i.

### D5: RLCT of the Meta-Fiber
The RLCT of the meta-loss landscape is:
  lambda_meta = RLCT(Sigma_meta, L_meta)
satisfying lambda_meta <= min_i lambda_i (the composition cannot increase singularity beyond the most singular task). The effective RLCT is modulated by alpha:
  lambda_eff(alpha) >= lambda_meta, with equality at optimal alpha*.

### D6: Inner-Step Size as Stratum Selector
The step size alpha parameterizes a family of adaptation maps {phi_i^alpha}. The stratum selector function is:
  S(alpha) = RLCT(Sigma_meta^alpha, L_meta^alpha)
At alpha -> 0: phi_i -> id (identity), Sigma_meta -> intersection of raw task fibers (high lambda if misaligned).
At alpha -> infinity: phi_i diverges, adaptation signal lost (high lambda, degenerate).
At alpha = alpha*: fibers coalesce, lambda_eff minimized (phase transition).

### D7: Generalization Bound
The MAML generalization bound is:
  G_MAML <= lambda_meta / N_tasks + U(alpha) / sqrt(N_tasks)
where U(alpha) captures inner-loop variance. At alpha*, lambda_eff is minimized because the adaptation map aligns task-specific fibers into a coherent meta-fiber. This bound is tighter than single-level bounds (#8, #16) when the bi-level composition reduces effective singularity.

## Open Formalization Questions (for L2)
1. Prove lambda_meta <= min_i lambda_i rigorously via blow-up algebraic geometry.
2. Characterize alpha* analytically — is it task-distribution dependent or universal?
3. Formalize the Hessian stratum: does (I - alpha * H_i) introduce independent singular structure?
4. Multi-step K scaling: does K-fold composition increase lambda_meta monotonically?
5. Connection to algebraic statistics: is Sigma_meta a mixture model fiber?

## Cross-References
#8 (ReLU definability), #16 (semi-algebraic sets), #99 (SGD dynamics), #127 (MoE routing), #169 (recurrent depth), #179 (TTT), #201 (inner-loop adaptation), #232/#394 (weight averaging/Reptile), #236 (in-context learning), #294 (self-consistency), #386 (warmup), #485 (RLT), #506 (hypernetworks), #529 (self-consistency decoding)

## Next: L2 (proofs/empirical predictions)