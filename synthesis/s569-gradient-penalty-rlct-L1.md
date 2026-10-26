# Synthesis #569: Gradient Penalty (WGAN-GP) × RLCT L1 Formalization
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-23

## Definitions

### D1: WGAN-GP Critic Objective
The WGAN-GP critic loss is:
  L_GP(θ) = E_{x~P_r}[D_θ(x)] - E_{x~P_g}[D_θ(x)] + λ_gp · E_{x~P_x}[(||∇_x D_θ(x)||₂ - 1)²]
where P_r is real data, P_g is generator distribution, P_x is interpolation distribution (uniform along lines between real and fake samples), and λ_gp > 0 is the penalty coefficient. The critic maximizes L_GP (or minimizes -L_GP).

### D2: Input-Gradient Penalty Term
The gradient penalty term is:
  R_gp(θ) = E_{x~P_x}[(||∇_x D_θ(x)||₂² - 1)²]
Since ||∇_x D_θ(x)||₂² = Σ_j (∂D_θ/∂x_j)², the penalty is:
  R_gp(θ) = E_{x~P_x}[(Σ_j (∂D_θ(x)/∂x_j)² - 1)²]
This is a polynomial of degree 4 in the partial derivatives of D_θ w.r.t. input x, composed with the analytic function D_θ.

### D3: R_an,exp Structure (C1 PROVEN)
- D_θ(x) is analytic in θ (neural network with analytic activations, e.g., smooth MLP or ResNet)
- ∇_x D_θ(x) = (∂D_θ/∂x_1, ..., ∂D_θ/∂x_d) — each component analytic in θ (derivative of analytic is analytic)
- ||∇_x D_θ(x)||² = Σ_j (∂D_θ/∂x_j)² — sum of squares of analytic functions → analytic
- (||∇_x D||² - 1)² — polynomial composition of analytic → analytic
- R_gp(θ) = E_x[(||∇_x D||² - 1)²] — integral of analytic over compact support → analytic (under regularity)
- L_GP(θ) = analytic WGAN term + λ_gp · R_gp(θ) → R_an,exp-definable ∎

### D4: Gradient-Penalty Singular Fiber
The gradient-penalty zero set:
  V_gp = {θ ∈ W : R_gp(θ) = 0} = {θ : ||∇_x D_θ(x)||₂ = 1 for P_x-almost every x}
This is the set of parameters where the critic is exactly 1-Lipschitz on the interpolation distribution. The combined singular fiber:
  W_true = V_WGAN ∩ V_gp
where V_WGAN = {θ : L_WGAN(θ) = 0} is the WGAN zero-loss set. The true fiber is the intersection of the WGAN optimal set with the Lipschitz constraint.

### D5: λ_gp-Stratified Loss Family
The total loss depends on λ_gp:
  L_λ(θ) = L_WGAN(θ) + λ_gp · R_gp(θ)
For λ_gp = 0: L_0 = L_WGAN, standard WGAN, singular fiber = V_WGAN.
For λ_gp → ∞: R_gp dominates, optimizer forced toward V_gp, singular fiber → V_gp ∩ (nearest WGAN fiber).
The family {L_λ} defines a deformation of the loss landscape parametrized by λ_gp, analogous to #362 CFG scale or #234 temperature.

### D6: Generalization Bound
  G_WGAN-GP(n, λ_gp) ≤ C · λ_total(λ_gp) / (2n) + U_total(λ_gp) / √n
where:
  λ_total(λ_gp) = RLCT of L_λ at θ̂ (the learned parameters)
  U_total(λ_gp) = bias term from Lipschitz constraint
Conjecture: λ_total(λ_gp) ≤ λ_WGAN (Lipschitz constraint reduces effective complexity).
Conjecture: U_total(λ_gp) ≥ U_WGAN (constraint introduces bias, critic too smooth).
Optimal λ_gp* minimizes G by trading off complexity reduction vs bias increase.

### D7: Phase Transition at λ_gp*
  λ_gp* = inf{λ_gp : λ̂_total(λ_gp) < λ̂_WGAN - δ}
For λ_gp < λ_gp*: GP term negligible, λ̂ ≈ λ̂_WGAN, critic non-Lipschitz.
For λ_gp > λ_gp*: GP term active, λ̂ < λ̂_WGAN, critic forced Lipschitz.
At λ_gp*: GP constraint surface tangent to dominant WGAN stratum — fastest RLCT change.
SGLD-testable: estimate λ̂(λ_gp) via LLC across λ_gp values, observe kink at λ_gp*.

## Claims

### C1 (PROVEN): R_an,exp-definability
L_GP(θ) = L_WGAN(θ) + λ_gp · R_gp(θ). L_WGAN is R_an,exp-definable (standard result, see #8, #16). R_gp(θ) = E_x[(||∇_x D||² - 1)²] is analytic in θ (composition of polynomial with analytic derivatives, integrated over compact support). Sum of R_an,exp functions is R_an,exp. Therefore L_GP is R_an,exp-definable. QED.

### C2 (CONJECTURAL): Input-Gradient Singular Fiber
V_gp = {θ : ||∇_x D_θ(x)||₂ = 1 a.e.} defines a singular fiber in parameter space via the INPUT Jacobian. This is structurally novel: all prior syntheses (#433 weight decay, #173 SAM, #527 gradient clipping) constrain parameter-space or parameter-gradient quantities. V_gp constrains the function's input-space derivative. The combined fiber W_true = V_WGAN ∩ V_gp has codim ≥ codim(V_WGAN) (intersection raises codimension). RLCT at W_true ≥ RLCT at V_WGAN alone (more constrained → more singular). Key distinction: V_gp is defined through ∇_x f (input gradient), not ∇_θ f (parameter gradient) — this is a genuinely new fiber type.

### C3 (CONJECTURAL): λ_gp as Continuous Stratum Selector
λ_gp continuously interpolates between unconstrained WGAN (λ_gp=0) and exact-Lipschitz regime (λ_gp→∞). As λ_gp increases, the optimizer is pushed from V_WGAN strata toward V_gp ∩ V_WGAN strata. The strata of W_true are subsets of V_WGAN strata satisfying the additional 1-Lipschitz constraint. High-RLCT WGAN strata that violate Lipschitz (sharp critics with large input gradients) are filtered as λ_gp grows. λ_gp* marks where the dominant stratum switches from non-Lipschitz to Lipschitz-constrained.

### C4 (CONJECTURAL): Generalization Bound
G_WGAN-GP ≤ C·λ_total/(2n) + U_total/√n where λ_total(λ_gp) is non-increasing in λ_gp (more constraint → less complexity) and U_total(λ_gp) is non-decreasing (more constraint → more bias). At optimal λ_gp*: complexity reduction balances bias increase, G_WGAN-GP < G_WGAN. Distinct from #433 weight decay: GP constrains function behavior (input Lipschitz) not parameter magnitude (θ norm), so the complexity reduction is geometrically different — GP reduces the class of functions, weight decay reduces the class of parameters.

### C5 (CONJECTURAL): Phase Transition at λ_gp*
Critical λ_gp* where RLCT changes fastest. Below λ_gp*: GP inactive, λ̂ ≈ λ_WGAN. Above λ_gp*: GP active, λ̂ drops. At λ_gp*: GP constraint surface tangent to WGAN dominant stratum — transition analogous to phase boundary. SGLD observable: LLC vs λ_gp shows kink at λ_gp*. Connection to #527: both constrain gradient norms but GP is input-space (structural, affects fiber geometry) while clipping is parameter-space (algorithmic, affects trajectory only). Predicted: λ_gp* ~ 1/√n (empirical landscape resolution scale, same as #559 SAM rho*).

## Open Problems (7)
1. **Exact codim(V_gp)**: Is V_gp generically codim-1? The constraint ||∇_x D||² = 1 is one scalar equation, but it must hold a.e. — does this raise codimension?
2. **Singularity type of V_gp**: Is ||∇_x f||² = 1 a smooth constraint, or does it create cusp-type singularities (like ||∇_x f||² = 0 would)?
3. **λ_gp* scaling**: Does λ_gp* ~ 1/√n like SAM rho*? Or does the double-gradient structure change scaling?
4. **Spectral normalization comparison**: SN enforces Lipschitz via weight projection (parameter space). Does SN create the same V_gp fiber? Or a different fiber? (#473 spectral norm may overlap)
5. **Interpolation distribution**: Does uniform interpolation P_x create different V_gp than other distributions (e.g., real data only)?
6. **Generator interaction**: In adversarial training, generator updates change P_g, hence P_x, hence V_gp — dynamic fiber. Does this create a time-varying RLCT?
7. **Double gradient structure**: ∇_x D involves derivatives of the network w.r.t. input. For deep networks this is a product of Jacobians — does the multiplicative structure create higher-order singularities (e.g., products of strata)?

## Cross-References (7)
- #173: SAM (parameter-space perturbation vs input-gradient penalty — both select flat regions but GP is structural)
- #433: Weight decay (parameter norm vs function-space Lipschitz — both reduce complexity but different geometry)
- #527/#528: Gradient clipping (parameter-gradient norm vs input-gradient norm — both constrain gradients but different spaces)
- #506: Dropout (stochastic singularity selection vs deterministic Lipschitz constraint)
- #282: Weight decay complete (toric contraction vs input-Jacobian constraint)
- #169: Dropout (stochastic subnetwork vs Lipschitz-constrained function class)
- #473: Spectral normalization (if exists — parameter projection vs function-space penalty)

## Status
L1 written 2026-10-23. Next: L2 novelty verification.
