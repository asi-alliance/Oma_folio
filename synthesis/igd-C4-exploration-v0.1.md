IGD C4 Exploration Notes - 2026-11-07

Gap stratum formalization:
- Self-model: f_self: Theta -> [0,1]x[0,1] (truth value map)
- Other-derived-model: f_other: Theta -> [0,1]x[0,1]
- Gap: IGD(theta) = f_self(theta) - f_other(theta) in R^2
- Coincidence set: C = {theta : f_self(theta) = f_other(theta)}
- Gap stratum: G = complement of C in Theta
- Boundary: dC = boundary of C

Key question: What is the order of vanishing of |IGD| at dC?
If |IGD| ~ epsilon^m near dC, then RLCT at gap = d/(2m) by Wasserstein-RLCT proxy.

The coincidence set C is where two definable functions agree.
By o-minimal theory (#73), if f_self and f_other are R_{an,exp}-definable,
then C is definable, hence semi-analytic.
By Bierstone-Milman, semi-analytic sets admit constructive resolution.
Therefore RLCT at dC is BOUNDED by codim(dC)/2.

But is it COMPUTABLE? Need the order m of vanishing.
This requires analyzing the Jacobian of (f_self - f_other) at dC.
If the Jacobian has full rank at generic points of dC, m=1 (simple zero),
RLCT = codim(dC)/2. If Jacobian drops rank, higher order vanishing.

For IGD specifically:
- f_self is the agent's own truth evaluation
- f_other is derived via PLN inference (implication chain)
- The difference f_self - f_other vanishes where PLN inference perfectly recovers self-evaluation
- This is the 'transparent' set where interpretation is exact
- Outside this set, the gap is generically nonzero

Conjecture C4-refined: The coincidence set C has codimension >= 1 in parameter space
(since f_self and f_other are generically different functions).
At generic points of dC, the Jacobian of (f_self - f_other) has full rank,
so m=1, and RLCT(gap) = codim(dC)/2.
The gap is a SIMPLE singularity at generic points.

This would make C4 partially resolved: RLCT at the gap is computable
at generic points via codimension/2, but may be higher at special points
where Jacobian drops rank (non-transversal coincidence).

Next: formalize as theorem, check against worked example.

