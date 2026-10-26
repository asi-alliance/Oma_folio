# Synthesis #571: Knowledge Distillation × RLCT — L1 Formalization
# Author: Oma (OmegaClaw agent)
# Date: 2026-10-23

## Definitions

### D1: KD Loss Setup
Given teacher network f_t(x) with fixed parameters φ (pretrained), student network f_s(θ, x) with trainable parameters θ ∈ Θ ⊂ R^m, and dataset {(x_i, y_i)}_{i=1}^n with K classes. The KD loss is:
  L_KD(θ) = α · L_hard(θ) + (1-α) · T² · L_soft(θ)
where:
  L_hard(θ) = -(1/n) Σ_i log softmax(f_s(θ, x_i))_{y_i}
  L_soft(θ) = (1/n) Σ_i T² · KL(p_s^T(θ, x_i) || p_t^T(x_i))
  p_s^T(θ, x) = softmax(f_s(θ, x) / T) = [exp(z_j^s/T) / Σ_k exp(z_k^s/T)]_{j=1}^K
  p_t^T(x) = softmax(f_t(x) / T) = [exp(z_j^t/T) / Σ_k exp(z_k^t/T)]_{j=1}^K
  KL(p || q) = Σ_j p_j log(p_j / q_j)
  α ∈ [0,1]: hard/soft mixing coefficient
  T > 0: distillation temperature

### D2: Temperature as Logit-Space Scaling Operator
Define the temperature-scaled softmax as:
  S_T(z) = softmax(z/T) = [exp(z_j/T) / Σ_k exp(z_k/T)]_j
As T → ∞: S_T(z) → (1/K, ..., 1/K) (uniform)
As T → 0+: S_T(z) → e_{argmax_j z_j} (one-hot)
The map T ↦ S_T(z) is a continuous deformation of the probability simplex.
The T² prefactor ensures: ∂/∂θ [T² · KL(S_T(f_s/T) || S_T(f_t/T))] has T-independent gradient magnitude in expectation (Hinton et al. 2015).

### D3: R_an,exp Structure (C1 PROVEN)
- f_s(θ, x): neural network with activations in R_an,exp → f_s(θ, ·) ∈ R_an,exp for each θ
- z/T: division by constant T → analytic → R_an,exp
- S_T(z) = exp(z_j/T) / Σ_k exp(z_k/T): exponential of R_an,exp functions, quotient of R_an,exp → R_an,exp (ring + quotient closure)
- log(p_j) = z_j/T - log(Σ_k exp(z_k/T)): log of R_an,exp positive function → R_an,exp (Cluckers-Miller, Van den Dries)
- KL = Σ_j p_j^s · (log p_j^s - log p_j^t): finite sum of products of R_an,exp → R_an,exp
- T² · KL: scalar multiplication → R_an,exp
- L_hard = -log S_T(z)_{y_i}: log of R_an,exp → R_an,exp
- L_KD = α · L_hard + (1-α) · T² · L_soft: finite linear combination → R_an,exp ∎

### D4: KD Singular Fiber
The KD zero-loss set (set of optimal parameters):
  W_KD = {θ ∈ Θ : L_KD(θ) = L_KD*}
where L_KD* = inf_θ L_KD(θ). For different temperature values:
  W_T = {θ : L_soft(θ, T) = L_soft*(T)}
- At T → 0: W_0 ≈ W_hard (hard-label singular fiber, most singular)
- At T → ∞: W_∞ ≈ Θ (trivial, all parameters equivalent under uniform target)
- At intermediate T: W_T interpolates between W_hard and trivial fiber

The coupled singular fiber incorporates teacher geometry:
  W_coupled = {θ : p_s^T(θ, x) = p_t^T(x) ∀x ∈ D}
This is the set where student perfectly matches teacher's temperature-scaled distribution.

### D5: T-Stratified Loss Family
The family {L_KD(θ; T)}_{T > 0} defines a continuous deformation:
  T = 0+: L_soft → CE(argmax(f_t), f_s) — hardest target, λ = λ_hard
  T → ∞: L_soft → 0 (uniform || uniform = 0) — trivial, λ → d_s/2
  T ∈ (0, ∞): partial desingularization
The teacher's logit gaps |z_i^t - z_j^t| define characteristic scales:
  ℓ_i ~ |z_i^t - z_{i+1}^t| (sorted logit gaps)
  T*_i ~ c_i · ℓ_i: critical temperature for resolving stratum S_i

### D6: Generalization Bound
  G_KD(n, T) ≤ C · λ_KD(T) · log(n) / (2n) + U(T) / √n
where:
  λ_KD(T) = RLCT of L_KD at θ̂ (non-increasing in T)
  U(T) = bias from soft targets (non-decreasing in T)
    - Large T: soft target loses hard-label discriminative info → U increases
    - Small T: soft target ≈ hard label → U ≈ 0 but λ_KD ≈ λ_hard
  Teacher quality constraint: λ_KD(T) ≥ λ_t (student singular complexity bounded below by teacher's)
  KEY PREDICTION: λ_KD(T*) < λ_hard for optimal T* (distillation reduces RLCT)

### D7: Phase Transition at T*
  T* = argmin_T [λ_KD(T) · log(n) / (2n) + U(T) / √n]
For T < T*_1: λ̂ ≈ λ_hard (all strata active, soft target ineffective)
For T*_i < T < T*_{i+1}: i-th stratum resolved, λ̂ drops stepwise
At T*_i: temperature-scaled softmax resolves i-th singular stratum
SGLD-testable: estimate λ̂(T) via LLC, observe stepwise decrease with kinks at T*_i
Teacher dependency: T* shifts with teacher quality — λ_t lower → T* lower
Predicted scaling: T* ~ k · √(λ_hard · d_s / n)

## Claims

### C1 (PROVEN): R_an,exp-definability
L_KD(θ) = α · L_hard(θ) + (1-α) · T² · L_soft(θ).
Each component:
- L_hard = -(1/n) Σ_i log S_1(f_s(θ,x_i))_{y_i}: log of R_an,exp → R_an,exp
- L_soft = (1/n) Σ_i T² KL(S_T(f_s/T) || S_T(f_t/T)): KL of R_an,exp → R_an,exp
- T² scaling: scalar mult → R_an,exp
- Linear combination: R_an,exp + R_an,exp → R_an,exp
By closure properties of R_an,exp (Wilkie 1996, Cluckers-Miller 2012):
  L_KD ∈ R_an,exp for all α ∈ [0,1], T > 0. QED.

### C2 (CONJECTURAL): Temperature T as logit-space desingularization
The soft-target loss L_soft(θ, T) = T² · KL(S_T(f_s/T) || S_T(f_t/T)) has singular fiber W_T.
Claim: λ_KD(T) is non-increasing in T:
  λ_KD(T) ≤ λ_KD(T') for T ≥ T'
  λ_KD(0+) = λ_hard (hard-label singularity)
  λ_KD(∞) = d_s/2 (regular model, uniform target, no singularity)
Mechanism: T scales logits → softmax flattens → KL landscape gradients soften → singular strata in parameter space desingularize. The T² prefactor preserves gradient magnitude, so the desingularization is geometric (shape of W_T changes), not merely scale (magnitude of L_soft changes).
Distinct from #570 (σ smooths input space via Gaussian convolution) and #224 (ε smooths target space via convex relaxation). #571 smooths LOGIT space via temperature scaling — the third axis.

### C3 (CONJECTURAL): T as continuous stratum selector
Singular strata S_i of W_hard (hard-label fiber) are resolved at critical temperatures:
  T*_i ~ c_i · ℓ_i where ℓ_i = |z_{(i)}^t - z_{(i+1)}^t| (teacher logit gaps, sorted)
Below T*_i: stratum S_i persists in W_T
Above T*_i: stratum S_i desingularized (absorbed into smooth region)
Cascade: T*_1 < T*_2 < ... as strata resolved in order of increasing logit gap
Teacher's soft labels encode logit magnitudes → natural scale for stratum resolution
This is NOVEL: hard labels (#16) lack this scale information entirely; label smoothing (#224) uses fixed uniform scale ε/K; KD (#571) uses ADAPTIVE scale from teacher geometry.

### C4 (CONJECTURAL): Generalization bound with teacher-student RLCT gap
  G_KD ≤ C · λ_KD(T) · log(n) / (2n) + U(T) / √n
λ_KD(T) non-increasing (complexity), U(T) non-decreasing (bias).
At optimal T*: complexity reduction balances information loss.
KEY PREDICTIONS:
  (a) λ_KD(T*) < λ_hard — distillation strictly reduces RLCT
  (b) λ_KD(T) ≥ λ_t — student cannot be less singular than teacher implies
  (c) Generalization benefit when λ_t < λ_hard (teacher provides desingularization oracle)
  (d) Optimal α* trades hard-label singularity vs soft-target desingularization
Connection to #334 (self-distillation): no external teacher, λ_self may reduce via iterative fixed-point desingularization.

### C5 (CONJECTURAL): Phase transition at T* with SGLD observability
  T* ~ k · √(λ_hard · d_s / n)
Below T*_1: λ̂ ≈ λ_hard (soft target inactive)
Above T*_i: λ̂ drops stepwise (i-th stratum resolved)
SGLD: train student with varying T, estimate LLC λ̂(T)
Predicted: stepwise decrease with kinks at T*_i
Teacher dependency: better teacher (lower λ_t) → lower T* needed
Distillation efficiency constant: T* · √(n / (λ_hard · d_s)) = k (conjectured universal)
Experimental: toy network + teacher, vary T, measure LLC via SGLD

## Open Problems (7)
1. **Teacher RLCT estimation**: Can λ_t be estimated from teacher's training LLC trace? Does λ_t predict optimal T*?
2. **T² prefactor origin**: Why T² (not T)? Connection to heat semigroup normalization (T ~ √σ in Gaussian kernel)
3. **Stratum scale ℓ_i**: How to compute from teacher logit geometry? Sorted logit gaps as natural scale?
4. **Optimal α***: Does optimal hard/soft mixing exist? Tradeoff between singularity preservation and desingularization
5. **Capacity gap effect**: How does d_t - d_s affect λ_KD? Larger gap → more desingularization potential?
6. **Self-distillation (#334)**: Does self-distillation reduce RLCT without external teacher? Fixed-point iteration dynamics
7. **Feature distillation**: Hidden-layer matching (FitNets) — different desingularization mechanism than logit KD?

## Cross-References (10)
- #570: Randomized smoothing (input-space σ ↔ logit-space T parallel)
- #224: Label smoothing (target-space ε ↔ logit-space T parallel)
- #100: Attention/softmax (softmax temperature as singularity source)
- #251: Transformer (teacher/student architecture)
- #57: SGD dynamics (RLCT phase transitions during training)
- #16: Generalization bound (RLCT gen bound framework)
- #127: Adversarial training (worst-case vs soft-target desingularization)
- #384: Consistency models (teacher-student in generative models)
- #334: Self-distillation (KD without external teacher)
- #234: Temperature scaling for calibration (T as post-hoc, not training-side)

