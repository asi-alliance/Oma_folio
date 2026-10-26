# Synthesis #653: Depthwise Separable Convolution × RLCT
## L1 — Formalization

**Date:** 2026-10-26
**Status:** L1 formal definitions

### D1: Parameter Space

Let θ = (W_dw, b_dw, W_pw, b_pw) ∈ Θ where:
- W_dw ∈ R^{C × 1 × K × K}: depthwise weights, one K×K kernel per channel C (C input channels)
- b_dw ∈ R^C: depthwise bias
- W_pw ∈ R^{C_out × C × 1 × 1}: pointwise 1×1 conv weights (channel mixing)
- b_pw ∈ R^{C_out}: pointwise bias

For grouped convolution generalization with g groups (1 ≤ g ≤ C):
- W_g ∈ R^{C × (C/g) × K × K}: grouped conv weights, each group has C/g channels
- W_pw ∈ R^{C_out × C × 1 × 1}: pointwise mixing (unchanged)

Parameter dimension: dim(Θ) = C·K² + C + C_out·C + C_out (depthwise separable)
vs dense: dim(Θ_dense) = C_out·C·K² + C_out

### D2: Loss Function

Given input X ∈ R^{C × H × W}:

**Depthwise step:** Y_c[i,j] = Σ_{a,b} W_dw[c,a,b] · X[c, i+a, j+b] + b_dw[c] for each channel c
This is a block-diagonal operation: Y = (I_C ⊗ K_conv) · X where K_conv is the 2D conv operator.

**Pointwise step:** Z[k,i,j] = Σ_c W_pw[k,c,0,0] · Y_c[i,j] + b_pw[k]
This is a linear projection: Z = W_pw_mat · Y where W_pw_mat ∈ R^{C_out × C}.

**Composite map:** f_θ(X) = σ(Z) = σ(W_pw · (W_dw ⊙ X))
where σ is ReLU/SiLU (definable activation).

**Loss:** L_n(θ) = (1/n) Σ_i ℓ(f_θ(x_i), y_i)
with ℓ = cross-entropy (softmax + log) or MSE.

### D3: R_{an,exp}-Definability

The composite map f_θ(X) = σ(W_pw · D(X, W_dw)) where:
- D(X, W_dw) = depthwise conv = polynomial in (X, W_dw) → definable in R_{an}
- W_pw · (·) = linear → definable in R_{an}
- σ = ReLU = max(0, ·) = definable in R_{an} (piecewise polynomial)
- softmax = exp/log composition → definable in R_{an,exp}
- Cross-entropy = -log(softmax) → definable in R_{an,exp}

Therefore L_n(θ) is R_{an,exp}-definable, K(θ,L_n) is analytic, and RLCT λ is well-defined. ∎

### D4: Block-Diagonal Singular Fiber

**Jacobian of depthwise step:** J_dw = ∂Y/∂X = diag(J_1, ..., J_C) ∈ R^{(C·HW) × (C·K²)}
where J_c = ∂Y_c/∂vec(W_dw,c) ∈ R^{HW × K²} is the per-channel convolution Jacobian.

Block-diagonal structure: rank(J_dw) = Σ_c rank(J_c) ≤ C · min(HW, K²)
vs dense: rank(J_dense) ≤ min(C_out·HW, C_in·K²)

**Singular fiber (depthwise):**
V_dw = {θ ∈ Θ : rank(J_dw(θ)) < C · min(HW, K²)}
= {θ : ∃ c, rank(J_c) < min(HW, K²)}
= ∪_{c=1}^{C} V_c  (union of per-channel degeneracy loci)

Each V_c is a determinantal variety (rank deficiency of K² × HW matrix).
V_dw is a union of C independent determinantal varieties → RLCT(V_dw) = max_c RLCT(V_c) (by independence).

**Composite singular fiber:**
V_total = V_dw ∪ V_pw ∪ V_comp
where:
- V_dw: depthwise rank deficiency (per-channel)
- V_pw: pointwise rank deficiency (W_pw singular)
- V_comp: composition interaction (J_pw ∘ J_dw rank drops beyond individual)

### D5: Group-Count Stratified Family

Define the stratified family {λ_g}_{g=1}^{C} indexed by group count g:

For grouped conv with g groups, each group has C/g channels:
- J_g = diag(J_1, ..., J_g) where each block J_i ∈ R^{(C/g)·HW × (C/g)·K²}
- rank(J_g) = Σ_{i=1}^{g} rank(J_i) ≤ g · min((C/g)·HW, (C/g)·K²) = C · min(HW, K²) (same upper bound!)

But the SINGULAR LOCUS structure differs:
- g=1 (dense): single determinantal variety of dimension C_out·C·K²
- g=C (depthwise): C independent K²×HW determinantal varieties
- 1<g<C: g groups of (C/g)×(C/g) determinantal varieties

The stratum selector: λ_eff(g) = RLCT of the grouped model at group count g.
Conjecture: λ_eff(g) is monotonically decreasing in g (more groups = simpler singular structure).

### D6: Generalization Bound

By the RLCT generalization theorem (Watanabe):
E[L_test - L_train] ≤ (λ_eff / n) · (log n)^{m/2 + 1} + o(1/n)

For depthwise separable conv:
λ_eff = λ(V_dw ∪ V_pw ∪ V_comp)

**Conjectured bound:**
λ_depthwise ≤ λ_dense at comparable accuracy because:
1. V_dw decomposes into C independent low-dimensional fibers (each K² × HW) → RLCT additive within each, max across
2. V_pw is a single C_out × C rank-deficiency variety (small dimension)
3. V_comp interaction term is lower-order

The factorization trades O(C²K²)-dim singular locus (dense) for C·O(K²)-dim + O(C²)-dim loci.
By subadditivity: λ(C·K² + C²) ≤ λ(C²·K²) when the components are sufficiently independent.

### D7: Phase Transition at Critical Group Count g*

**Claim:** There exists g* ∈ (1, C) such that:
- For g > g*: λ_eff(g) < λ_dense (efficiency gain, accuracy maintained)
- For g < g*: λ_eff(g) ≈ λ_dense (no efficiency gain from grouping)
- At g = g*: phase transition where accuracy begins to degrade

**Mechanism:** As g increases toward C:
- Per-group rank decreases → singular fibers become lower-dimensional
- Channel mixing moves entirely to pointwise stage (C_out × C params)
- At g = g*, the per-group information becomes insufficient for the pointwise to reconstruct → accuracy loss

**SGLD testable prediction:** LLC(λ) estimated via:
λ_hat = (1/T) Σ_t [n · L(θ_t) - (n/2) · ||θ_t - θ_0||²]
where θ_t follows SGLD dynamics. Sweep g from 1 to C, measure λ_hat(g).
Predict: step-like decrease at g* with λ_hat(g>C*) < λ_hat(g< g*).

### Cross-References

- #16 ReLU (activation in conv stack)
- #134 Attention (channel mixing alternative)
- #220 Pruning (structural sparsity vs architectural)
- #223 LoRA (learned low-rank vs architectural)
- #234 Temperature (stratum selector pattern)
- #354 STE (quantized conv gradient)
- #434 MoE (conditional computation)
- #472 SE-Net (channel attention, distinct)
- #535 Word2Vec (dimension as stratum)
- #599 DPO (implicit regularization → lower RLCT)
- #609 SwiGLU (gated linear, distinct from factorized)
- #615 Consistency Reg (invariance fiber)

