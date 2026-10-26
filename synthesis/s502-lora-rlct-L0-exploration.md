# Synthesis #502: LoRA (Low-Rank Adaptation) × RLCT — L0 Exploration

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Motivation

LoRA (Low-Rank Adaptation) freezes pre-trained weights W and injects trainable rank-r matrices BA where W' = W + BA, B ∈ R^{d×r}, A ∈ R^{r×d}, r << d. The rank constraint creates a natural algebraic variety: the set of rank-≤r matrices forms a determinantal variety — a classical singular variety in algebraic geometry. This makes LoRA a natural candidate for Singular Learning Theory analysis: the parameter space has a built-in singular stratum (rank-deficient matrices) whose RLCT should govern generalization.

## Key Observations

1. **Determinantal variety:** The constraint rank(BA) ≤ r defines a determinantal variety V_r ⊂ R^{d×d}. Matrices of rank exactly r form the smooth part; matrices of rank < r are singular points of V_r.

2. **Natural singular stratum:** When BA has effective rank k < r (some singular values vanish), the parameter space (B, A) has a fiber with higher multiplicity — the factorization BA = B'A' is non-unique when rank drops, creating a symmetry group that inflates the RLCT.

3. **Gauge symmetry:** For any invertible P ∈ GL(r), (B, A) and (BP, P^{-1}A) yield the same BA. This GL(r) gauge symmetry means the effective parameter space is the quotient R^{d×r} × R^{r×d} / GL(r). The quotient inherits singularities from the rank-deficient locus.

4. **Rank as stratum selector:** The rank r acts as a discrete stratum selector (like depth d in #433 PolyLoss, or predictor capacity h in #501 JEPA). Different r values select different determinantal varieties V_r with different RLCTs.

5. **Connection to #223 / #385:** Need to check if LoRA was already covered. If #223 or #385 covered LoRA × RLCT, this synthesis must be rejected or refocused.

## Claims (Draft)

- **C1 (Definability):** The LoRA-augmented loss L(W + BA) is R_{an,exp}-definable. W is frozen (constant), BA is polynomial in (B, A), and the loss composition preserves definability (#8, #16).

- **C2 (Singular stratum from rank deficiency):** The rank-deficient locus {rank(BA) < r} is a singular stratum of the determinantal variety V_r. The RLCT at rank-deficient points λ_k (k < r) exceeds the RLCT at full-rank points λ_r. The gauge symmetry GL(r-k) at rank k inflates multiplicity.

- **C3 (Rank r as discrete stratum selector):** The adaptation rank r selects the determinantal variety V_r. RLCT λ(r) is monotone non-decreasing in r (higher rank = more complex variety = potentially lower RLCT at generic points but more singular strata). Hypothesis: optimal r* minimizes the generalization bound, trading capacity against singularity.

- **C4 (Generalization bound):** G_gap ≤ λ_LoRA(r) · log(n) / (2n) + V_r / n, where λ_LoRA(r) is the RLCT of the loss on V_r, and V_r is the volume of the determinantal variety (grows with r). The bound predicts an optimal r* where the singularity penalty and the capacity penalty balance.

- **C5 (Phase transition at critical rank r*):** There exists a critical rank r* where the RLCT contribution transitions from rank-deficiency-dominated (r < r*, λ large due to singular strata) to capacity-dominated (r > r*, λ smaller but variety volume grows). Testable via SGLD learning coefficient estimation at different ranks.

- **C6 (Gauge symmetry and effective parameter count):** The GL(r) gauge symmetry means the effective dimension of (B, A) is 2dr - r², not 2dr. The r² reduction is the gauge orbit dimension. At rank-deficient points, the gauge group enlarges to GL(r-k), further reducing effective dimension and inflating RLCT.

## Open Problems

1. **Exact RLCT of determinantal varieties:** Known results from algebraic geometry give codimension of rank-≤k strata as (d-k)², but the RLCT (log canonical threshold) of determinantal varieties needs explicit computation for the LoRA setting.

2. **Gauge quotient singularity:** The quotient R^{d×r} × R^{r×d} / GL(r) is a GIT quotient with singularities. What is the RLCT of the loss pulled back to this quotient?

3. **Dynamic rank evolution:** During training, the effective rank of BA may change. Does gradient flow on V_r stay within V_r, or can it cross strata? If singular values of BA can grow from zero, the training trajectory crosses singular strata.

4. **Comparison with full fine-tuning:** Full fine-tuning corresponds to r = d (no rank constraint). Is λ_full < λ_LoRA for all r < d? If so, LoRA's generalization advantage must come from the capacity term, not the RLCT term.

5. **Scaling factor α/r:** LoRA uses W' = W + (α/r)BA. How does the scaling factor α affect the RLCT? Is α a continuous stratum selector like EMA decay α in #501?

6. **Multi-adapter composition:** If multiple LoRA adapters are composed (W + B₁A₁ + B₂A₂), is the RLCT additive or does the composition create new singularities?

7. **LoRA on different layer types:** How does the RLCT depend on which layers receive LoRA adapters? Attention layers (#86) vs MLP layers may have different fiber structures.

## Cross-References

#8 (ReLU definability), #16 (semi-algebraic foundation), #86 (attention non-identifiability), #127 (MoE gating — also a discrete selector), #169 (pruning fiber — rank reduction), #201 (early exit — discrete stratum selector), #223 (check overlap), #385 (check overlap), #433 (PolyLoss degree as selector), #434 (MoE as stratum selector), #501 (JEPA capacity as selector)

## Status

L0 EXPLORATION DRAFTED. 2026-10-21. Must verify #223/#385 overlap before proceeding to L1. If already covered, reject and select alternative candidate (Chain-of-Thought).
