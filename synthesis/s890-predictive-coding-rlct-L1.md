# Synthesis #890: Predictive Coding × RLCT
## L1 — Formalization

### Date: 2026-11-09

### Definitions

**D1 (Hierarchical Predictive Coding Model).** A PC model of depth L consists of:
- Generative parameters θ = {θ_l}_{l=0}^{L} where θ_l = (A_l, b_l) defines top-down predictions:
  x̂_l = A_l φ(x_{l+1}) + b_l
- Error neurons e_l = x_l - x̂_l at each level l
- Precision parameters π = {π_l}_{l=1}^{L}, where π_l ∈ R_{>0} is inverse variance at level l
- Energy function:
  F(x, θ, π) = Σ_{l=1}^{L} (π_l/2) ||x_l - A_l φ(x_{l+1}) - b_l||² + Σ_{l=1}^{L} (π_l/2) log(2π/π_l)

**D2 (Zero-Error Manifold).** The zero-prediction-error set at level l:
  V_l = {θ ∈ R^d : x_l - A_l φ(x_{l+1}) - b_l = 0}
The total zero-error set V(K) = ∩_{l=1}^{L} V_l, an algebraic variety (assuming φ is subanalytic).

**D3 (Precision-Weighted Loss).** Given training data D = {(x_i^{(n)})}, the empirical PC loss:
  L_n(θ, π) = (1/n) Σ_{i=1}^{n} Σ_{l=1}^{L} (π_l/2) ||e_l^{(i)}||² + const(π)
This is a precision-weighted sum of squared prediction errors across hierarchical levels.

**D4 (Singular Fiber).** For fixed precision π = (π_1,...,π_L), the precision-indexed singular fiber:
  V_π = {θ : ∇_θ L_n(θ, π) = 0, H_θ L_n is rank-deficient}
The fiber structure depends on π: different precision profiles select different singular strata.

**D5 (Stratum Selector).** The precision vector π acts as a continuous stratum selector:
  σ: R_{>0}^L → Strata(V(K)),  π ↦ dominant singular stratum S_π
Low π_l → level l errors contribute weakly → flat loss near V_l → higher degeneracy.
High π_l → level l errors dominate → sharp loss → lower degeneracy at that stratum.

**D6 (Generalization Functional).** The expected generalization gap:
  G_PC(n) = E_{D}[L_test(θ̂_D) - L_train(θ̂_D)]
Bound: G_PC ≤ λ(π)/n + U(π)/√n, where λ(π) is the RLCT at precision π, and U(π) depends on the precision-weighted error norm.

**D7 (Local Learning Rule Symmetry Group).** Permutation of error neurons within level l:
  G_l = Sym(d_l) acts on e_l by σ(e_l) = P_σ e_l
Since the energy ||e_l||² is invariant under G_l, the full symmetry group G = Π_l Sym(d_l) acts on parameter space θ. The quotient θ/G is an orbifold.

### Claims

**C1 (R_{an,exp} Definability) — PROVEN.**
The PC energy F(x,θ,π) = Σ_l (π_l/2)||x_l - A_l φ(x_{l+1}) - b_l||² + Σ_l (π_l/2)log(2π/π_l) is R_{an,exp}-definable:
- ||·||² is polynomial (semi-algebraic) ✓
- φ assumed subanalytic (e.g., ReLU, tanh) → composition with subanalytic is subanalytic ✓
- π_l are positive reals → multiplication by π_l preserves definability ✓
- log(2π/π_l) = log(2) + log(π) - log(π_l); log is definable on R_{>0} ✓
- Sum of definable functions is definable ✓
Thus L_n(θ,π) = (1/n)Σ_i F(x_i,θ,π) is R_{an,exp}-definable. ∎

**C2 (Precision-Weighted Singular Fiber) — CONJECTURAL.**
The singular fiber V_π depends on precision profile π. As π_l → 0 for some level l, the loss contribution from that level vanishes, effectively removing V_l from the intersection V(K) = ∩_l V_l. This enlarges the singular locus → lower RLCT. Conversely, π_l → ∞ sharpens level l constraints → smaller fiber → higher RLCT. The function λ(π) is predicted to be U-shaped in each π_l: there exists π_l* minimizing total generalization error.

*Gap:* Monotonicity of λ(π_l) and existence of π* require transversality assumptions on the intersection V_l ∩ V_{l'}.

**C3 (Hierarchical Depth RLCT Inequality) — CONJECTURAL.**
For depth-L PC models with same total parameter count:
  λ_{L+1}(π) ≤ λ_L(π)  for generic precision profiles
Adding a hierarchical level adds another zero-error manifold V_{L+1} to the intersection V(K) = ∩_l V_l. More intersections → potentially higher degeneracy → lower λ. However, beyond optimal depth L*, over-segmentation may increase λ (U-shaped).

*Gap:* The inequality direction depends on transversality of V_{L+1} with ∩_{l≤L} V_l. If transverse, codimension increases, λ may increase. If tangent, λ decreases.

**C4 (Generalization Bound) — CONJECTURAL.**
  G_PC(n) ≤ λ(π)·log(n)/(2n) + U(π)/√n
where:
- λ(π) is the RLCT of the precision-weighted PC loss
- U(π) depends on the precision-weighted error norm: U(π) ~ Σ_l π_l ||e_l||_{L²(P)}
- Optimal precision π* minimizes the bound: trades off λ(π) (lower when some π_l → 0) against U(π) (higher when π_l → 0 for informative levels)

*Gap:* The form of U(π) requires Rademacher complexity analysis of the precision-weighted function class, not yet established for PC.

**C5 (Local Rule Symmetry → Orbifold RLCT) — CONJECTURAL.**
The permutation group G = Π_l Sym(d_l) acts freely on the parameter space (generically). The quotient θ/G is an orbifold with singularities at fixed points (where error neurons coincide). The RLCT of the orbifold λ_orb satisfies:
  λ_orb ≤ λ_naive
because the group action identifies parameter configurations, reducing effective degeneracy. This predicts that local (symmetric) learning rules achieve better generalization than non-local rules with the same expressivity.

*Gap:* The orbifold RLCT bound requires Watanabe's framework extended to orbifold singularities, which is not standard. Fixed-point strata may have higher RLCT.

### Open Problems
1. Transversality conditions for V_l ∩ V_{l'} — when is the intersection non-transverse?
2. Monotonicity of λ(π_l) — is it always U-shaped, or can it be monotone?
3. Optimal depth L* — does the U-shaped λ(depth) prediction hold empirically?
4. Connection to variational Laplace — PC approximates posterior via Laplace; relation to RLCT?
5. Biological plausibility — do biological precision weights exhibit phase transitions?
6. Relation to #334 (self-distillation): PC is self-predictive; is the teacher-student gap an RLCT shift?
7. Orbifold RLCT extension — formal framework for group-action singularities in SLT

### Cross-References
#8 #16 #169 #201 #334 #388 #469 #501 #557 #889

