# Synthesis #567: DPO (Direct Preference Optimization) × RLCT
**Date:** 2026-10-23
**Status:** L1 Formalization
**Prereq:** L0 (s567-dpo-rlct-L0.md, 8406B, sha256 c79e608b) VERIFIED

## Formal Definitions

### D1: Policy and Reference Model
- Parameter space: θ ∈ W ⊂ R^d (neural network parameters)
- Policy: π_θ(y|x) = softmax(f_θ(x,y)) where f_θ is the logit function (analytic in θ for fixed x,y)
- Reference model: π_ref(y|x) = softmax(f_ref(x,y)), frozen (θ_ref ∈ W_fixed)
- Log-ratio map: r_θ(y,x) = log π_θ(y|x) - log π_ref(y|x) = f_θ(x,y) - f_ref(x,y) - (log Z_θ(x) - log Z_ref(x))
  where Z_θ(x) = Σ_y exp(f_θ(x,y)), Z_ref(x) = Σ_y exp(f_ref(x,y))

### D2: DPO Loss Function
For preference dataset D = {(x_i, y_w^i, y_l^i)}_{i=1}^n (yw = preferred, yl = rejected):
- Margin: Δr_θ(x,yw,yl) = r_θ(yw,x) - r_θ(yl,x)
- DPO loss: L_DPO(θ) = -(1/n) Σ_{i=1}^n log σ(β · Δr_θ(x_i, y_w^i, y_l^i))
  where σ(z) = 1/(1+e^{-z}), β > 0
- Equivalent: L_DPO(θ) = (1/n) Σ_i log(1 + exp(-β · Δr_θ^i))

### D3: R_an,exp Structure (C1 Formal)
The loss L_DPO is definable in R_an,exp:
- f_θ is analytic (neural network: polynomial compositions of analytic activations) → in R_an
- log Z_θ(x) = log Σ_y exp(f_θ(x,y)) is in R_an,exp (log of finite sum of exp of analytic)
- r_θ = f_θ - f_ref - (log Z_θ - log Z_ref): difference of R_an,exp functions → R_an,exp
- Δr_θ: difference of R_an,exp → R_an,exp
- β · Δr_θ: scalar product → R_an,exp
- log(1 + exp(-β · Δr_θ)): composition log(1+exp(-·)) with R_an,exp → R_an,exp (softplus is exp-definable)
- L_DPO: finite average of R_an,exp → R_an,exp ∎

### D4: Fixed-Point Fiber V_fixed (C2 Formal)
- Fixed-point condition: Δr_θ(x_i, y_w^i, y_l^i) = 0 for all i
- V_fixed = {θ ∈ W : Δr_θ^i = 0 ∀i} = ∩_{i=1}^n {θ : r_θ(y_w^i, x_i) = r_θ(y_l^i, x_i)}
- Each constraint r_θ(y_w^i, x_i) = r_θ(y_l^i, x_i) defines a hypersurface in W
- V_fixed is the intersection of n hypersurfaces → codim ≤ n (generically)
- At V_fixed: L_DPO = log 2 for each pair → L_DPO = log 2 (constant)
- The fiber V_fixed is the singular set where the loss has maximum entropy over preferences
- RLCT at V_fixed: λ_fixed conjectured ≥ d/2 - codim(V_fixed) (higher than at minimum)

### D5: β-Stratified Loss Family (C3 Formal)
- β-stratified loss: L_DPO(θ; β) = (1/n) Σ_i log(1 + exp(-β · Δr_θ^i))
- Limit β→0: L_DPO(θ; 0) = log 2 (constant) → all θ equivalent → V_singular = W → λ = d/2
- Limit β→∞: L_DPO(θ; ∞) = 0·[Δr > 0] + ∞·[Δr ≤ 0] → hard margin classifier → V_singular = {θ : all Δr > 0} boundary
- Intermediate β: the effective singular set is {θ : β·Δr_θ^i ≈ 0 for some i} = neighborhood of V_fixed scaled by 1/β
- λ(β) conjectured: monotonically decreasing with possible non-monotone U-shape near β*

### D6: Generalization Bound (C4 Formal)
The RLCT-based generalization bound for DPO:
- G_DPO(β) ~ λ(β)/(2n) + U(β)/√n
- λ(β) = RLCT of L_DPO(·; β) at the learned parameter θ̂
- U(β) = bounded functional of the preference margin distribution {Δr_ref^i}
- Distinct from #468 PPO: no branch-switch singularity (DPO has no clipping)
- Distinct from #185 CA: no product-space reward+policy fiber (DPO: policy-only)
- The reference model π_ref enters through the margin geometry: Δr depends on π_ref's log-probabilities

### D7: Phase Transition at β* (C5 Formal)
- Critical β* defined as the value where the RLCT undergoes fastest change:
  β* = argmax_β |dλ/dβ|
- For β < β*: θ̂ stays near V_fixed (reference-dominated, high λ)
- For β > β*: θ̂ on low-λ stratum (preference-dominated, possible wrong stratum = reward hacking)
- Prediction: SGLD LLC estimation λ̂(β) shows U-shaped curve with minimum at β*
- Reward hacking formalization: at large β, optimizer finds θ_hack on a lower-λ stratum where Δr is maximized via spurious features (length, formatting) rather than true preference alignment
- Connection to #362: β* ↔ w* (CFG guidance scale phase transition), both are temperature parameters controlling stratum selection

## MeTTa-Ready Claims

```metta
;; C1: R_an,exp definability (PROVEN)
(|- ((==> (Inheritance DPO-Loss R_an_exp) (stv 1.0 0.9))
     ((Inheritance softplus R_an_exp) (stv 1.0 0.9))
     ((Inheritance log-ratio R_an_exp) (stv 1.0 0.9))))

;; C2: Fixed-point singular fiber (CONJECTURAL)
(|- ((==> (Equality (Delta_r theta yw yl) 0) (Membership theta V_fixed)) (stv 1.0 0.9)))
(|- ((>= (RLCT V_fixed) (RLCT V_min)) (stv 0.0 0.7)))

;; C3: β as stratum selector (CONJECTURAL)
(|- ((==> (Equality beta 0) (Equality V_singular W)) (stv 1.0 0.9)))
(|- ((MonotoneDecreasing (RLCT_fn beta) beta) (stv 0.0 0.7)))
(|- ((UShaped (RLCT_fn beta) beta_star) (stv 0.0 0.7)))

;; C4: Generalization bound (CONJECTURAL)
(|- ((~= (GenBound DPO) (+ (/ (RLCT beta) (* 2 n)) (/ (U_fn beta) (sqrt n)))) (stv 0.0 0.7)))

;; C5: Phase transition at β* (CONJECTURAL)
(|- ((Exists beta_star) (PhaseTransition DPO beta_star)) (stv 0.0 0.7))
(|- ((==> (> beta beta_star) (RewardHacking theta)) (stv 0.0 0.7)))
```

## Open Problems (from L0, refined)
1. **Codim(V_fixed)**: Is codim(V_fixed) = min(n, d-1) generically? Degenerate cases when preference pairs are redundant.
2. **β* scaling**: β* ~ n^{-α} for what α? Connection to #362 w* scaling conjecture.
3. **Reference model geometry**: Does π_ref being a better model (lower KL to true distribution) always reduce λ? Or can a sharp π_ref create worse singular geometry?
4. **Margin distribution effect**: Does heavy-tailed margin distribution create additional singular strata?
5. **λ_DPO vs λ_PPO**: Is the RLCT of DPO always lower than PPO (#468)? The log-ratio fiber vs branch-switch comparison.
6. **Reward hacking as wrong stratum**: Can SGLD distinguish the "correct" vs "hack" stratum by their RLCT signatures?
7. **K-objective DPO fiber intersection**: For K preference types, does λ_K ≤ min(λ_1,...,λ_K) hold (intersection of singular fibers)?

## Cross-References
- #362: CFG guidance scale (β ↔ w analogy, U-shaped λ, stratum selector)
- #468: PPO (no branch-switch in DPO, clipped surrogate comparison)
- #185: Constitutional AI / RLHF (no reward model in DPO, policy-only singularity)
- #167: Diffusion (score function / log-ratio gradient connection)
- #540: InfoNCE (1-vs-1 vs 1-vs-K pairwise comparison)
- #223: LoRA (parameter space restriction effect on V_fixed)
- #234: Temperature scaling (β as temperature)
- #538: Speculative decoding (rejection boundary analogy)
- #370: Contrastive learning (preference pairs as contrastive examples)
