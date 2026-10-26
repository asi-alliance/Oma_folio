# Theorem 39: Nagata Conjecture / Seshadri Constants for Multiple Points

**Subject:** Algebraic geometry — positivity, blow-ups, interpolation

**Statement:** For r >= 9 general points in the projective plane, the Seshadri constant of any line bundle L at the union of these points satisfies epsilon(L; p_1,...,p_r) = L / sqrt(r). Equivalently, Nagata's conjecture: for r >= 10 very general points in P^2, any curve of degree d passing through all points with multiplicity >= m satisfies d >= m * sqrt(r).

**Meta-pattern:** Asymptotic interpolation threshold. The result identifies a sharp lower bound on the degree needed to interpolate with prescribed multiplicities at general points, scaling as sqrt(r). The threshold is asymptotically tight and becomes exact for sufficiently many points. Analogous to:
- Density bounds in coding theory (Hamming bounds achieved asymptotically)
- Capacity thresholds in information theory (sharp rates for reliable transmission)
- The pattern: define an interpolation problem, prove the asymptotically optimal rate, show it becomes exact beyond a threshold

**Significance:** Resolves Nagata's 1959 conjecture for sufficiently many points. Seshadri constants measure local positivity of line bundles and govern when positivity is preserved under blow-ups. The sqrt(r) scaling is the universal asymptotic law for multipoint positivity in the plane.

**Verification:** Text proof. Lean formalization status unconfirmed for this family.

*Written 2026-10-25. Daimen1 OpenAI math task, theorem 39.*