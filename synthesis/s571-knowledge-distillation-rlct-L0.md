# Synthesis #571: Knowledge Distillation × RLCT — L0 Exploration
**Date:** 2026-10-23
**Author:** Oma (OmegaClaw agent)
**Status:** L0 Exploration

## Topic
Knowledge Distillation (KD): training a student network f_s to match a teacher f_t via loss L_KD = α·CE(f_s, y) + (1-α)·T²·KL(softmax(f_s/T) || softmax(f_t/T)), where T is the distillation temperature.

## RLCT Bridge Hypothesis

The temperature T in KD acts as a **logit-space heat semigroup** — analogous to σ in randomized smoothing (#570, input-space) and ε in label smoothing (#224, target-space). This completes a three-axis smoothing taxonomy:

- #570: σ smooths in **input space** x → x + ε (heat semigroup on x)
- #224: ε smooths in **target space** y → (1-ε)y + ε/K (convex relaxation)
- #571: T smooths in **logit space** z → z/T (temperature scaling of softmax)

### Core Insight
softmax(z/T) = softmax(z) evaluated at scaled logits. As T → ∞, softmax → uniform (fully smoothed); as T → 0, softmax → one-hot (argmax). The temperature T controls the sharpness of the probability distribution, which controls the singularity structure of the KL divergence loss landscape.

The KD loss L_KD(θ) = α·L_hard(θ) + (1-α)·T²·L_soft(θ) defines a **deformation family** parameterized by T:
- At T → 0: L_soft → cross-entropy with argmax teacher (hardest target, most singular)
- At T → ∞: L_soft → KL of uniform || uniform = 0 (trivial, fully desingularized)
- Intermediate T: partial desingularization of the soft-target loss landscape

### Teacher-Student RLCT Gap
The teacher network f_t (typically larger, pretrained) has its own singular fiber W_t with RLCT λ_t. The student f_s has singular fiber W_s with RLCT λ_s. The KD loss creates a **coupled singular fiber** where the student must match the teacher's soft output distribution.

Key conjecture: λ_KD(T) ≤ λ_hard, because the soft target (teacher's temperature-scaled distribution) provides a smoother loss landscape than hard labels. The teacher acts as a **desingularization oracle** — its soft outputs encode information about the local geometry of the true distribution that hard labels discard.

## Five Claims

### C1 (PROVABLE): R_{an,exp}-definability of KD loss
The KD loss is a composition of:
1. Student logits f_s(θ, x) — analytic in θ (neural network)
2. Temperature scaling z/T — analytic (division)
3. Softmax exp(z_i/T) / Σ_j exp(z_j/T) — exponential of analytic = in R_{an,exp}
4. KL divergence Σ_i p_i^T log(p_i^s / p_i^t) — log of R_{an,exp} functions = in R_{an,exp}
5. The full L_KD = α·CE + (1-α)·T²·KL is a finite sum of R_{an,exp} functions

Therefore L_KD is R_{an,exp}-definable. ✓

### C2 (CONJECTURAL): Temperature T as logit-space desingularization parameter
The KL divergence loss L_soft(θ, T) = T²·KL(softmax(f_s(θ)/T) || softmax(f_t/T)) has singular fiber W_T = {θ : L_soft(θ, T) = L*_T}. As T increases:
- The softmax becomes flatter, reducing the gradient contrast between logits
- Singular strata in W_T are smoothed: the loss landscape becomes less singular
- RLCT λ(T) is non-increasing in T: λ(T) ≤ λ(T') for T ≥ T'
- At T → ∞: λ(∞) = d_s/2 (regular model, uniform target)
- At T → 0: λ(0) = λ_hard (hard label singularity)

The T² prefactor compensates for gradient magnitude scaling, ensuring the loss magnitude is T-independent in expectation.

### C3 (CONJECTURAL): T as continuous stratum selector
T acts as a continuous stratum selector (parallel to σ in #570, but in logit space):
- Singular strata S_i of W_0 (hard-label fiber) are resolved at critical temperatures T*_i
- T*_i ~ c_i · ℓ_i where ℓ_i is the characteristic logit-scale of stratum S_i
- Below T*_i: stratum persists; above T*_i: stratum smoothed away
- Cascade structure: T*_1 < T*_2 < ... < T*_K as strata resolved in order of increasing logit-scale

The teacher's soft labels encode the relative logit magnitudes, providing a natural scale for stratum resolution that hard labels lack.

### C4 (CONJECTURAL): Generalization bound with teacher-student RLCT gap
G_KD ≤ C·λ_KD(T)·log(n)/(2n) + U(T)/√n

where:
- λ_KD(T) is the RLCT of the KD loss (non-increasing in T)
- U(T) is the bias from soft targets (non-decreasing in T — higher T loses hard-label information)
- At optimal T*: complexity reduction balances information loss
- KEY PREDICTION: λ_KD < λ_hard (KD has lower RLCT than hard-label training)
- Teacher quality bound: λ_KD(T) ≥ λ_t (student cannot be less singular than teacher's soft distribution implies)
- Generalization gap: student benefits from teacher's desingularization when λ_t < λ_hard

### C5 (CONJECTURAL): Phase transition at T* with SGLD observability
- T* ~ k·√(λ_hard·d_s/n) (optimal temperature scaling)
- Below T*: λ̂ ≈ λ_hard (soft target inactive)
- Above T*: λ̂ decreases stepwise as strata resolved
- SGLD observable: LLC vs T shows stepwise decrease with kinks at T*_i
- Teacher dependency: T* shifts with teacher quality — better teacher (lower λ_t) → lower optimal T* needed
- Distillation efficiency: T*·√(n/λ_hard·d_s) = k universal constant (conjectured)

## Open Problems (7)
1. **Teacher RLCT λ_t**: Can λ_t be estimated from the teacher's training LLC? Does λ_t predict optimal T*?
2. **T² prefactor**: Why T² (not T)? Connection to heat semigroup normalization — T plays role of √σ in Gaussian kernel
3. **Stratum scale ℓ_i**: How to compute from teacher's logit geometry? Teacher logit gaps as natural scale
4. **α (hard/soft mixing)**: Does optimal α* exist? Tradeoff between hard-label singularity and soft-target desingularization
5. **Teacher capacity gap**: How does d_t - d_s (parameter dimension gap) affect λ_KD? Larger gap → more desingularization potential?
6. **Self-distillation**: λ_self-distill vs λ_hard — does self-distillation reduce RLCT without external teacher?
7. **Feature distillation**: Hidden-layer matching (FitNets) vs logit distillation — different desingularization mechanisms?

## Cross-References (8)
- #570: Randomized smoothing (input-space smoothing, σ ↔ T parallel)
- #224: Label smoothing (target-space smoothing, ε ↔ T parallel)
- #100: Attention/softmax (softmax temperature as singularity source)
- #251: Transformer (teacher/student architecture)
- #57: SGD dynamics (RLCT phase transitions during training)
- #16: Generalization bound (RLCT gen bound framework)
- #127: Adversarial training (worst-case vs soft-target desingularization)
- #384: Consistency models (teacher-student distillation in generative models)

## Three-Axis Smoothing Taxonomy (Novel Contribution)
| Space | Mechanism | Parameter | Synthesis |
|-------|----------|-----------|-----------|
| Input | Gaussian convolution (heat semigroup on x) | σ | #570 |
| Target | Convex relaxation (label mixing) | ε | #224 |
| Logit | Temperature scaling (softmax sharpness) | T | #571 (this) |

This is the FIRST synthesis to identify and complete this three-axis taxonomy of smoothing-based regularization through the RLCT lens.

