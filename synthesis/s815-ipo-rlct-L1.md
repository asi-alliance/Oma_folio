# Synthesis #815: IPO (Identity Preference Optimization) × RLCT
**Date:** 2026-10-28
**Status:** L1 Formalization
**Prereq:** L0 (s815-ipo-rlct-L0.md, 40 lines, sha256 3e1feee) VERIFIED

## Formal Definitions

### D1: Policy and Reference Model
- Parameter space: θ ∈ W ⊂ R^d (neural network parameters)
- Policy: π_θ(y|x) = softmax(f_θ(x,y)) where f_θ is the logit function (analytic in θ for fixed x,y)
- Reference model: π_ref(y|x) = softmax(f_ref(x,y)), frozen (θ_ref ∈ W_fixed)
- Log-ratio map: r_θ(y,x) = log π_θ(y|x) - log π_ref(y|x) = f_θ(x,y) - f_ref(x,y) - (log Z_θ(x) - log Z_ref(x))
  where Z_θ(x) = Σ_y exp(f_θ(x,y)), Z_ref(x) = Σ_y exp(f_ref(x,y))

### D2: IPO Loss Function
For preference dataset D = {(x_i, y_w^i, y_l^i)}_{i=1}^n (yw = preferred, yl = rejected):
- Margin: Δr_θ(x,yw,yl) = r_θ(yw,x) - r_θ(yl,x)
- Target offset: c = 1/(2β), β > 0
- IPO loss: L_IPO(θ) = (1/n) Σ_{i=1}^n (Δr_θ(x_i, y_w^i, y_l^i) - c)^2
- Key contrast with DPO: NO sigmoid σ(·), NO log(1+exp(·)). Loss is polynomial degree 2 in Δr_θ.

### D3: R_an,exp Structure (C1 Formal)
The loss L_IPO is definable in R_an,exp:
- f_θ is analytic (neural network: polynomial compositions of analytic activations) → in R_an
- log Z_θ(x) = log Σ_y exp(f_θ(x,y)) is in R_an,exp (log of finite sum of exp of analytic)
- r_θ = f_θ - f_ref - (log Z_θ - log Z_ref): difference of R_an,exp functions → R_an,exp
- Δr_θ: difference of R_an,exp → R_an,exp
- (Δr_θ - c)^2: polynomial (degree 2) applied to R_an,exp → R_an,exp (polynomials preserve definability)
- L_IPO: finite average of R_an,exp → R_an,exp ∎
- NOTE: Unlike DPO (#567), no softplus log(1+exp(-β·Δr)) composition is needed. The loss avoids the transcendental sigmoid entirely.

### D4: Quadratic Target Fiber S_IPO (C2 Formal)
- Target condition: Δr_θ(x_i, y_w^i, y_l^i) = c = 1/(2β) for all i
- S_IPO = {θ ∈ W : Δr_θ^i = 1/(2β) ∀i} = ∩_{i=1}^n {θ : r_θ(y_w^i, x_i) - r_θ(y_l^i, x_i) = 1/(2β)}
- Each constraint defines a hypersurface in W (level set of analytic function = constant)
- S_IPO is the intersection of n hypersurfaces → codim ≤ n (generically)
- At S_IPO: L_IPO = 0 (global minimum, unlike DPO where L_DPO = 0 requires log-sigmoid saturation)
- Contact order: The loss vanishes as (Δr - c)^2, i.e. order-2 vanishing
- Contrast with DPO: DPO's L_DPO = log(1+exp(-β·Δr)) vanishes as exp(-β·Δr) (order-1 in the exponent), creating a different singularity type
- RLCT at S_IPO: λ_IPO conjectured = d/2 - codim(S_IPO) + m/2 where m is the multiplicity from the quadratic contact (m=2 for generic quadratic). This is potentially HIGHER than DPO's RLCT at its fiber.

### D5: Beta-Stratified Loss Family (C3 Formal)
- Define family: {L_IPO^β}_{β>0} where L_IPO^β(θ) = (1/n) Σ_i (Δr_θ^i - 1/(2β))^2
- As β → ∞: c = 1/(2β) → 0, fiber S_IPO → {Δr = 0} = DPO boundary (D4 of #567)
- As β → 0: c → ∞, fiber S_IPO → ∅ (no θ satisfies Δr = ∞)
- For finite β: S_IPO is a smooth algebraic hypersurface shifted away from origin
- λ_IPO(β) is conjectured monotone: larger β → fiber approaches DPO boundary → λ decreases toward λ_DPO
- At β=0: trivial (no fiber, λ=0)

### D6: Generalization Bound (C4 Formal)
- Standard RLCT bound: G_IPO ≤ λ_IPO / n + U_IPO / √n
- Key property: Since L_IPO is polynomial degree 2 (no sigmoid), the RLCT λ_IPO is determined by:
  (a) Network architecture singularities (permutation symmetries, scale symmetries)
  (b) The quadratic contact order (m=2)
  NOT by loss-function nonlinearity (no transcendental singularity)
- This is the ARCHITECTURE-ONLY regime: λ_IPO = λ_arch + m/2 - codim(S_IPO)/2
  where λ_arch is the RLCT from network symmetries alone
- Contrast: DPO/PPO have λ = λ_arch + λ_loss where λ_loss comes from sigmoid/clipping nonlinearity

### D7: Phase Transition β* (C5 Formal)
- Architecture-limited regime (β < β*): c = 1/(2β) >> typical log-ratio scale
  → λ_IPO ≈ λ_arch + 1 (dominated by network geometry, quadratic contact adds m/2=1)
- Loss-limited regime (β > β*): c → 0, fiber approaches DPO boundary
  → λ_IPO → λ_DPO (sigmoid-induced singularity begins to dominate via proximity)
- Transition: β* defined by c* = 1/(2β*) ~ σ_typical (typical scale of Δr fluctuations)
- Predicted signature: For β < β*, generalization gap is constant (architecture-only).
  For β > β*, generalization gap transitions to DPO-like behavior.

## MeTTa-Ready Claims

C1: (|- ((==> (Inheritance IPO-Loss R_an_exp-definable)) (stv 1.0 0.9)))
C2: (|- ((==> (Inheritance S_IPO Quadratic-Target-Fiber)) (stv 0.0 0.7)))
C3: (|- ((==> (Inheritance Beta Stratum-Selector-IPO)) (stv 0.0 0.7)))
C4: (|- ((==> (Inheritance G_IPO Architecture-Only-RLCT)) (stv 0.0 0.7)))
C5: (|- ((==> (Inheritance Beta-star Phase-Transition-IPO)) (stv 0.0 0.7)))
