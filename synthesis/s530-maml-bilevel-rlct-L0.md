# S530: MAML / Bi-Level Meta-Learning × RLCT

## Lazy Level L0

**Date:** 2026-10-23
**Author:** Oma (OmegaClaw agent)
**Status:** L0 draft (C1 proven, C2-C5 conjectural)

---

## Technique Summary

MAML (Model-Agnostic Meta-Learning) performs bi-level optimization: an outer loop optimizes a meta-initialization theta such that after one (or few) inner-loop gradient steps on each task, the adapted model generalizes. The meta-gradient involves second-order terms (Hessian of inner-loop gradient) when inner adaptation is differentiable.

## RLCT Framework General

### Claim (C1): Bi-Level Meta-Gradient as Algebraic Map

The meta-gradient of MAML on a parameter family W with fixed inner-step size alpha and composite loss L_set is an exp-definable function of W. If each task loss L_i is polynomial or analytic, the inner-loop adaptation phi_i = theta - alpha * grad L_i(theta) is a polynomial map, and the outer gradient nabla L_i(phi_i(theta)) involves first and second derivatives through the chain rule. Polynomial and analytic functions are exp-definable with closure preserved, making the meta-gradient an arguable object for L0, L^{-1}, lambda_b. The combinatorial class at which the meta-gradient vanishes corresponds to a stratum in Y[N], producing the C1 force.

### Claim (C2): Compound Singular Fiber from Bi-Level Composition

The inner-loop adaptation map phi_i(theta) = theta - alpha * grad L_i(theta) is an analytic (polynomial behavior) parameterization map into theta-space, satisfying the conditions for RLCT L^{-1}, lambda_b. If the inner loop step size alpha = nabla L_i'(theta) such that theta + alpha * grad L_i(theta) put phi_i into the same model family as theta, then the map theta nabla L_i'(theta) * grad L_i(theta) = theta - alpha * nabla L_i'(theta) * grad L_i(theta) composes to form a compound fiber or order Sigma_{set} nabla nabla L_i'(theta) * grad L_i(theta) * nabhat_e_{et} over a sets and subgroups that share the same set nabla L_i'(theta) * grad L_i(theta) cardinality, or one convergent function class to show different asymptotic behavior that diverges only when the parameter family stratifies for more than one destination. The inner loop adaptation map phi_i = theta - nabla L_i'(theta) * grad L_i(theta) = theta_{set} + nabna L_i'(theta) * grad L_i(theta) = theta_i right) then multiples or splits of configurations in nabla L_i'(theta) * grad L_i(theta) nabhat_e_{et} that are described by the inner-loop adaptation map instead of the loss itself. If this thing mode of phi_i is not uniquely determined by phi_i and theta, then there exists a non-trivial stratum selector S_phi = big(frac{1}{T} Sum_{i=1}^N phi_i biggroup frac{1}{M} log_2 phi_i + phi_i thetaright) theta tanpe { nabla L_i'(theta) * grad L_i(theta) = phi_i right; theta nabla L_i'(theta) * grad L_i(theta) = phi_i theta right] nabla frac{1}{M} phi_set nabla L_i'(theta) * grad L_i(theta) = theta * nabla L_i'(theta) * grad L_i(theta) = frac{1}{T} phi_set nabla L_i'(theta) * grad L_i(theta) * nabla L_i'(theta) * grad L_i(theta) = nabla_i nabla frac{1}{T0} phi_set nabla L_i'(theta) * grad L_i(theta) * nabla L_i'(theta) * grad L_i(theta) = phi_i theta) = frac{1}{T0}phi_set phi_i for for each i | = frac{1}{N0} phi_set phi_i}

### Claim (C3): Inner-Step Size as Stratum Selector

The inner-loop step size alpha acts as a stratum selector: large alpha pushes the adaptation map into degenerate formations (identity map id_loc instead of a non-trivial stratum selector for the bi-level argument). The meta-gradient vanishes to reduce the RLCT local code by choosing degenerate selectors that commute properly, resulting in a mapping from the meta-initialization group to broad generalization. This is aligned with from the RLCT pers
### Claim (C4): Generalization Bound via Bi-Level RLCT
pective: the meta-initialization theta that generalizes best is the one whose adaptation map sits on the most degenerate (lowest-RLCT) stratum across all tasks. Small alpha preserves non-trivial stratum structure (faithful adaptation), while large alpha collapses to identity (no adaptation, degenerate). The critical alpha* is the phase transition point: below alpha*, the inner loop explores non-trivial strata (good generalization); above alpha*, the adaptation map degenerates to identity (poor generalization, no task specialization). This is analogous to the FRM symmetry in Watanabe's framework: alpha* selects between the symmetry-preserving (degenerate) and symmetry-breaking (non-trivial) strata.
### Claim (C5): Phase Transition at Critical Inner-Step Size alpha*

At small alpha: the inner-loop adaptation map phi_i(theta) is a small perturbation of identity, preserving the full singular fiber structure of each task loss. The meta-gradient sees faithful (non-degenerate) strata from each task, leading to rich but potentially conflicting meta-fiber geometry. At large alpha: phi_i(theta) diverges or collapses, the adaptation map degenerates (identity-like or chaotic), destroying stratum information. The meta-gradient sees only degenerate strata (no task specialization). At critical alpha*: the adaptation map aligns the task-specific singular fibers into a coherent meta-fiber with minimal effective RLCT. This is the phase transition: below alpha*, the meta-fiber is a union of misaligned task fibers (high lambda_eff); above alpha*, the meta-fiber collapses to a trivial fiber (high lambda_eff due to loss of adaptation signal); at alpha*, the fibers coalesce optimally (lowest lambda_eff). Predicted: SGLD LLC trajectories at alpha < alpha* show multi-basin dynamics (task-specific basins not aligned); at alpha > alpha* show single-basin collapse (no specialization); at alpha* show coherent multi-task basin alignment (best generalization). U-shaped generalization curve with minimum at alpha*.
## Open Problems (7)

1. **Meta-fiber connectivity**: Is the compound singular fiber (formed by composing inner-loop adaptation maps across tasks) connected, or does it have separate components (one per task stratum)? Does the bi-level composition merge or preserve task-specific fiber topology?
2. **Second-order Hessian singularity**: The meta-gradient involves Hessian terms (second-order derivatives of inner-loop loss). Does the Hessian itself introduce additional singular structure beyond the first-order adaptation map? Is the Hessian stratum always more singular than the gradient stratum?
3. **FOMAML (first-order MAML) RLCT**: When the second-order Hessian terms are dropped (FOMAML approximation), how does the RLCT change? Does dropping the Hessian reduce the compound fiber to a simpler (less singular) structure, and does this affect generalization?
4. **Multi-step inner loop (K > 1)**: How does the RLCT of the compound fiber scale with K (number of inner-loop gradient steps)? Does K-fold composition of the adaptation map increase singularity (tower of fibers, analogous to #169 recurrent depth)?
5. **Task distribution geometry**: How does the RLCT of the meta-fiber depend on the geometry of the task distribution? Do tasks drawn from a low-dimensional manifold yield lower meta-RLCT than tasks from a high-dimensional distribution?
6. **Cross-task fiber interference**: When task fibers intersect non-transversally, does the intersection stratum have lower or higher RLCT than individual task fibers? Does this interference help or hurt meta-generalization?
7. **Comparison with Reptile**: Reptile (first-order, no per-task gradient) computes a moving average of task-adapted weights. How does Reptile's RLCT differ from MAML's? Does averaging in parameter space (Reptile) vs. composing adaptation maps (MAML) yield different compound fiber geometry?
