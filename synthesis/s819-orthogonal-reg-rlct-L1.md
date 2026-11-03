## Synthesis #819: Orthogonal Regularization × RLCT — L1 Formalization

## Definitions

**D1 (Orthogonal Regularization Penalty):** Given a weight matrix W ∈ R^{n×p}, the orthogonal regularization penalty is R_OR(W) = (1/2)‖W^T W - I_p‖_F^2 = (1/2)∑_{i,j}((W^T W)_{ij} - δ_{ij})^2. The regularized loss is L_OR(θ) = L_n(θ) + λ_OR · R_OR(θ), where λ_OR ≥ 0 is the regularization strength. This is a polynomial function of θ (quartic in entries of W).

**D2 (Stiefel Attraction Basin):** The penalty R_OR(W) = 0 if and only if W^T W = I_p, i.e., W ∈ V_p(R^n) (Stiefel manifold). The penalty creates a quadratic attraction basin around V_p(R^n) in the Frobenius norm. Define the basin radius ρ(λ_OR) = O(1/√λ_OR) — the scale at which R_OR ≈ R_OR(λ_OR · ρ^2) balances the data loss gradient. The effective constraint set is B_ρ(V_p) = {W : ‖W^T W - I‖_F ≤ ρ}.

**D3 (R_{an,exp}-Definability):** The regularized loss L_OR(θ) = L_n(θ) + λ_OR · R_OR(θ) where L_n is R_{an,exp}-definable (by assumption, #8, #16) and R_OR is a polynomial (hence R_an-definable). The sum of R_{an,exp}-definable functions is R_{an,exp}-definable. The zero-loss set V_OR = {θ : L_OR(θ) = min L_OR} is a semi-algebraic set (intersection of the data loss fiber with the polynomial penalty constraint).

**D4 (Penalized Fiber Structure):** The fiber of L_OR at level c is F_OR(c) = {θ : L_n(θ) + λ_OR · R_OR(θ) = c}. Unlike the unregularized fiber F_n(c) = {θ : L_n(θ) = c}, F_OR(c) is deformed: near the Stiefel manifold, R_OR ≈ 0 and F_OR ≈ F_n; far from Stiefel, R_OR > 0 and F_OR is compressed. The singular locus of F_OR differs from that of F_n because the penalty term adds algebraic constraints that can either smooth or sharpen singularities depending on geometry.

**D5 (Weight-Parameterized Family):** Define the family L_OR(θ; λ_OR) parameterized by λ_OR ∈ R_≥0. For λ_OR = 0: L_OR = L_n (unregularized, RLCT = λ_0). For λ_OR → ∞: W is forced to V_p(R^n), reducing to the Stiefel-constrained problem with RLCT = λ_Stiefel (related to #528). The map λ_OR ↦ λ(L_OR(·; λ_OR)) is the stratum selector for orthogonal regularization.

**D6 (Generalization Bound with Orthogonality Bias):** The RLCT-based generalization bound for the regularized loss is G_OR(n) ≤ λ_OR_eff · log(n)/(2n) + U_OR/√n, where λ_OR_eff = RLCT of L_OR at the minimum found by SGD, and U_OR is the fluctuation functional. The orthogonality bias enters through: (a) λ_OR_eff may differ from λ_0 (unregularized) — the penalty deforms which singular stratum SGD converges to; (b) U_OR may differ due to the modified basin geometry.

**D7 (Phase Transition at λ_OR*):** There exists a critical λ_OR* such that:
- For λ_OR < λ_OR*: the penalty is too weak to alter the singular fibration; SGD converges to the same strata as unregularized, λ_OR_eff ≈ λ_0.
- For λ_OR > λ_OR*: the penalty dominates; SGD is confined to the Stiefel basin, accessing only strata within B_ρ(V_p), with λ_OR_eff = λ_Stiefel.
- At λ_OR = λ_OR*: phase transition — the dominant singularity changes. The SGLD LLC trajectory shows a discontinuity or sharp crossover.

## Claims

**C1 (PROVEN): The orthogonal-regularized loss L_OR(θ; λ_OR) is R_{an,exp}-definable.**

Proof: L_n(θ) is R_{an,exp}-definable by assumption (#8, #16). R_OR(W) = (1/2)‖W^T W - I‖_F^2 is a polynomial in the entries of θ (specifically, degree 4 in W entries), hence R_an-definable (polynomials are semi-algebraic). The sum L_OR = L_n + λ_OR · R_OR preserves R_{an,exp}-definability because the class of R_{an,exp}-definable functions is closed under addition and multiplication by constants. The parameter λ_OR is a real constant, not a variable, so the definability structure is preserved. By Watanabe's theorem, the RLCT of L_OR is well-defined. QED.

**C2 (CONJECTURAL): Orthogonal regularization deforms the singular fibration by creating a Stiefel-attracted fiber that compresses singular strata away from the Stiefel manifold.**

The penalty R_OR adds a quartic polynomial term that is zero on V_p(R^n) and grows quadratically with distance from it. The zero-loss fiber V_OR = {θ : L_OR(θ) = 0} = V_n ∩ {R_OR = 0} = V_n ∩ V_p (intersection of the data loss zero set with the Stiefel manifold). This intersection may be:
- Transverse (generic): V_n ∩ V_p is a smooth submanifold of codim = codim(V_n) + codim(V_p), with RLCT = dim/2 (regular).
- Non-transverse (structured): V_n ∩ V_p has singularities from the intersection, potentially lower RLCT.

The key effect: strata of V_n that lie far from V_p are penalized (their L_OR value is raised), so SGD under L_OR preferentially converges to strata near V_p. This is a fiber deformation — the singularity structure is reshaped, not just shifted.

Gap: Whether the deformation increases or decreases λ_OR_eff depends on the geometry of V_n relative to V_p. If the lowest-λ strata of V_n happen to lie near V_p, OR helps (λ_OR_eff < λ_0). If they lie far from V_p, OR hurts (λ_OR_eff > λ_0). The generic case is unclear.

**C3 (CONJECTURAL): λ_OR acts as a stratum selector: increasing λ_OR progressively restricts accessible singular strata to those within the Stiefel basin B_ρ(V_p).**

The effective RLCT λ_OR_eff(λ_OR) is a non-increasing function of λ_OR for strata near V_p (they remain accessible) and effectively infinite for strata far from V_p (penalty makes them unreachable). The selector mechanism: for stratum S with distance d(S, V_p) from the Stiefel manifold:
- If d(S, V_p) < ρ(λ_OR) ~ 1/√λ_OR: S is accessible, contributes to λ_OR_eff.
- If d(S, V_p) > ρ(λ_OR): S is penalized out, does not contribute.

As λ_OR increases, ρ shrinks, fewer strata are accessible, and λ_OR_eff transitions from λ_0 (all strata) to λ_Stiefel (only Stiefel-strata). This is a progressive stratum selection, analogous to #433 (weight decay) but with a non-quadratic (quartic) penalty geometry.

Gap: The monotonicity of λ_OR_eff(λ_OR) is not guaranteed — removing a high-λ stratum might not lower the effective RLCT if a lower-λ stratum is also removed. The ordering of strata by distance to V_p is problem-dependent.

**C4 (CONJECTURAL): Generalization bound G_OR(n) ≤ λ_OR_eff · log(n)/(2n) + U_OR/√n where λ_OR_eff depends on the Stiefel-proximity of the converged stratum.**

The bound follows from Watanane's RLCT bound applied to L_OR. The key insight: unlike weight decay (#433, which uses a quadratic penalty R_WD = ‖θ‖^2 that shrinks all directions uniformly), OR uses a quartic penalty R_OR = ‖W^T W - I‖_F^2 that specifically targets the deviation from orthogonality. This means:
- Directions tangent to V_p (orthogonal transformations) are unpenalized.
- Directions normal to V_p are penalized quadratically.

The bias term U_OR reflects the anisotropy: tangent directions have full freedom, normal directions are constrained. This is a different bias structure from #433.

Gap: Quantitative comparison of U_OR vs U_WD (weight decay fluctuation) is open. The anisotropic bias may help or hurt depending on the alignment of informative directions with V_p.

**C5 (CONJECTURAL): SGLD LLC trajectories show a phase transition at λ_OR*: for λ_OR < λ_OR*, LLC converges to λ_0; for λ_OR > λ_OR*, LLC converges to λ_Stiefel; at λ_OR*, LLC shows a discontinuity or crossover.**

Run SGLD on L_OR for various λ_OR values. The steady-state LLC (learning coefficient) estimates λ_OR_eff(λ_OR). The phase transition is predicted because the dominant singularity changes as λ_OR crosses the threshold where the Stiefel basin excludes the previously-dominant stratum. This is testable:
- For small λ_OR: LLC ≈ λ_0 (unregularized RLCT).
- For large λ_OR: LLC ≈ λ_Stiefel (Stiefel-constrained RLCT, related to #528).
- At λ_OR*: LLC jumps or crosses over.

The transition may be sharp (if the dominant stratum is suddenly excluded) or gradual (if multiple strata contribute and are excluded one by one).

Gap: Whether λ_OR* is unique (single phase transition) or there are multiple transitions (as different strata are excluded at different λ_OR thresholds) depends on the stratum distance distribution.

## Open Problems (7)

1. **Stratum distance distribution:** What is the distribution of singular strata of V_n relative to V_p? Is it generic (uniform) or structured (concentrated)?
2. **Quartic vs quadratic penalty geometry:** How does the quartic penalty R_OR differ qualitatively from weight decay's quadratic R_WD in terms of singularity deformation? (Cross-ref #433)
3. **Stiefel-constrained RLCT:** What is λ_Stiefel — the RLCT when W is constrained to V_p(R^n)? This connects to #528 (orthogonal initialization) but from the constraint side, not the initialization side.
4. **Interaction with depth:** Does the Stiefel proximity of informative strata depend on network depth L? Deep networks may have strata that are naturally near-orthogonal (due to dynamical isometry, #528).
5. **Spectral regularization interpretation:** R_OR = ‖W^T W - I‖_F^2 penalizes deviation of singular values from 1. Does this connect to spectral norm regularization and its RLCT implications?
6. **Multi-layer OR:** When OR is applied to all layers {W_l}, the product Stiefel manifold ∏_l V_{p_l}(R^{n_l}) is the constraint set. Does the product structure create additional singularity (as in #528 OP7)?
7. **Comparison with spectral norm clipping:** Spectral norm clipping (constraining σ_max(W) ≤ c) is a non-smooth version of OR. Does the non-smoothness change the RLCT qualitatively?

## Cross-References

#8 (ReLU definability), #16 (semi-algebraic), #169 (DropConnect), #298 (orthogonal init stratum), #433 (weight decay × RLCT — quadratic penalty), #480 (muP width), #528 (orthogonal init × RLCT — init not penalty), #531 (NFNet normalization), #559 (SAM sharpness-aware), #582 (data augmentation), #674 (NTM differentiable memory), #818 (GradNorm × RLCT)

## Next: L2 novelty verification
