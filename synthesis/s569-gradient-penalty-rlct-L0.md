# Synthesis #569: Gradient Penalty (WGAN-GP) × RLCT
**Date:** 2026-10-23
**Status:** L0 Exploration
**Candidate:** Confirmed uncovered (zero catalog, zero SLT websearch)

## Background
WGAN-GP (Gulrajani et al. 2017) adds a gradient penalty term to the critic loss:
L_total = L_WGAN(D) + λ_gp · E[(||∇_x D_θ(x)||₂ - 1)²]
where x ~ (interpolation between real and fake samples), enforcing 1-Lipschitz.

## Key RLCT Bridge
The gradient penalty ||∇_x f_θ(x)||² - 1 = 0 defines a NEW singular locus in parameter space:
V_gp = {θ ∈ W : ||∇_x f_θ(x)||² = 1 ∀x ∈ X_gp}
This is fundamentally different from:
- #433 weight decay: ||θ||² penalty → singular locus at θ=0 (parameter space)
- #173 SAM: perturbation in parameter space → robust minima
- #527 gradient clipping: ||∇_θ L|| ≤ τ in gradient space
Gradient penalty constrains INPUT-SPACE Jacobian norm, creating singular fibers where the critic's input-gradient has unit norm.

## Five Claims

### C1: R_an,exp Definability (PROVEN)
- f_θ(x) analytic in θ → ∇_x f_θ(x) analytic in θ (derivative of analytic)
- ||∇_x f_θ(x)||² = Σ_j (∂f_θ/∂x_j)² → polynomial in analytic → R_an
- (||∇_x f||² - 1)² → polynomial composition → R_an
- L_total = finite sum of R_an terms + analytic WGAN loss → R_an,exp ∎

### C2: Gradient-Penalty Singular Fiber (CONJECTURAL)
- Zero-penalty set: V_gp = {θ : E_x[(||∇_x D||² - 1)²] = 0} = {θ : ||∇_x D(x)||² = 1 a.e.}
- This defines an algebraic constraint on θ through the input Jacobian
- The true singular fiber W_true = V_WGAN ∩ V_gp (intersection of WGAN zero-loss with GP constraint)
- Codim(V_gp) ≥ 1 (the unit-norm constraint is codim-1 generically)
- RLCT at W_true ≥ RLCT at V_WGAN alone (intersection raises RLCT by constraining)
- Key: V_gp is defined via INPUT derivatives, not parameter derivatives — novel fiber structure

### C3: λ_gp as Stratum Selector (CONJECTURAL)
- λ_gp controls strength of Lipschitz enforcement
- λ_gp → 0: V_gp constraint vanishes, standard WGAN landscape, λ = λ_WGAN
- λ_gp → ∞: V_gp dominates, critic forced to exact 1-Lipschitz, constrained optimization
- Intermediate λ_gp*: phase transition where GP constraint crosses dominant WGAN singular fiber
- λ_gp selects which stratum (unconstrained vs Lipschitz-constrained) the optimizer settles on
- Prediction: SGLD shows RLCT change at λ_gp*

### C4: Generalization Bound (CONJECTURAL)
- G_WGAN-GP ~ λ_total/(2n) + U_total/√n
- λ_total = RLCT of combined loss at θ̂
- Lipschitz constraint reduces model complexity → λ_total ≤ λ_WGAN (conjectured)
- Bias term: over-strong GP forces critic to be too smooth, under-fitting → U increases
- Optimal λ_gp* trades off λ reduction (complexity) vs U increase (bias)
- Distinct from #433: GP penalty acts on function behavior, not parameter magnitude

### C5: Phase Transition at λ_gp* (CONJECTURAL)
- Critical λ_gp* where RLCT undergoes fastest change
- For λ_gp < λ_gp*: GP weak, critic non-Lipschitz, λ ≈ λ_WGAN (unconstrained singularity)
- For λ_gp > λ_gp*: GP strong, critic forced Lipschitz, λ drops (smoother landscape)
- At λ_gp*: boundary crossing — GP constraint tangent to WGAN singular fiber
- SGLD-testable: estimate λ̂(λ_gp) via LLC, observe transition
- Connection to #527 gradient clipping: both constrain gradient norms, but GP in input space (structural) vs clipping in parameter space (algorithmic)

## Open Problems
1. **Exact codim(V_gp)**: Is V_gp generically codim-1? Or higher due to multi-point constraints?
2. **Input-gradient singularity type**: What singularity type does ||∇_x f||² = 1 define? Cusp? Smooth?
3. **λ_gp* scaling**: How does optimal λ_gp* scale with n, d, architecture depth?
4. **Comparison to spectral normalization**: SN enforces Lipschitz via weight constraint — does it have same RLCT effect? (Different mechanism: SN = parameter projection, GP = function-space penalty)
5. **Distribution of interpolation points**: Does uniform interpolation create different V_gp than other distributions?
6. **Interaction with generator**: In adversarial training, does generator's singular fiber interact with V_gp?
7. **Double gradient structure**: ∇_x f involves second-order info — does this create higher-order singularities?

## Cross-References
- #173: SAM (parameter-space perturbation vs input-gradient penalty)
- #433: Weight decay (parameter norm vs function-space norm)
- #527: Gradient clipping (parameter-space gradient vs input-space gradient)
- #528: Gradient clipping (duplicate candidate, same comparison)
- #506: Dropout (stochastic singularity selection vs deterministic GP constraint)
- #282: Weight decay complete (toric contraction vs input-Jacobian constraint)
- #169: Dropout (stochastic subnetwork selection vs Lipschitz constraint)
