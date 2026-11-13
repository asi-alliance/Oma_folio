# Synthesis #847: Program Synthesis / Neurosymbolic × RLCT — L0 Formalization
Date: 2026-11-06 | Status: L0 IN PROGRESS

## Setup

Neurosymbolic program synthesis seeks to learn functions f: X → Y where the hypothesis class H consists of hybrid neural-symbolic programs. A program P ∈ H is defined by:
- A discrete structure s ∈ S (syntax tree, DSL program, logical rule set)
- Continuous parameters θ ∈ Θ (neural network weights embedding/interpreting s)

The combined parameter space is (s, θ) ∈ S × Θ, where S is a discrete (countable or structured) space and Θ ⊂ R^d is continuous.

**Loss:** L(s, θ) = (1/n) Σ ℓ(P_{s,θ}(x_i), y_i) + R(θ)

where ℓ is a task loss and R(θ) a regularizer. The discrete structure s indexes which continuous sub-model is active, creating a partition of Θ into fibers Θ_s.

## C1-C5 Claims

**C1 (PROVEN):** When the neural embedding φ_s: Θ → F (program semantics) is analytic for each fixed s, and the discrete search over S is finite (or compactifiable), the composite loss L(s, θ) is R_{an,exp}-definable. The discrete structure s acts as a stratum index, and each stratum Θ_s carries its own analytic singular structure. This follows from Watanabe's framework applied fiberwise plus the fact that finite unions of R_{an}-definable sets are R_{an}-definable.

**C2 (CONJECTURAL):** The singular fiber structure is stratified by program complexity |s| (e.g., AST node count, program length). Programs of the same complexity class k share a fiber V_k = ∪_{|s|=k} V_s. The effective RLCT λ_k is non-decreasing in k: longer programs create richer singular structure. This is the "complexity-RLCT ladder."

**C3 (STAR):** Differentiable program synthesis (e.g., differentiable interpreter, continuous relaxation of discrete choices via Gumbel-softmax) creates a single continuous relaxation of the discrete strata. The Gumbel temperature τ controls interpolation between discrete program fibers (τ → 0) and a smooth annealed landscape (τ → ∞). τ acts as a stratum selector analogous to dropout rate (#169) or boosting rounds (#846), but uniquely governs discrete-to-continuous interpolation. We conjecture a critical τ* where the RLCT transitions from piecewise-discrete (sum of stratum RLCTs) to unified (single merged singularity).

**C4 (CONJECTURAL):** Generalization bound for a neurosymbolic program P_{s,θ}: G ≤ λ_s/(2n) + |s|·log(|S|)/n + U(s,θ)/√n, where λ_s is the RLCT of fiber V_s and |s|·log(|S|)/n is a discrete complexity term (MDL-like). The total bound unifies SLT complexity (λ_s) with classical program complexity (|s|·log|S|).

**C5 (CONJECTURAL):** Under differentiable program search with Gumbel-softmax annealing (τ: τ_0 → 0), the SGLD local learning coefficient traces the merging of discrete strata: at high τ the LLC reflects a single broad basin; as τ → 0 it fragments into per-program LLCs. The LLC trajectory encodes the "program discovery" process.

## Open Problems (7)
1. Exact relationship between program complexity |s| and per-fiber RLCT λ_s — is it monotonic, or can short programs create high-RLCT singularities?
2. Does the MDL-like term |s|·log(|S|)/n in C4 combine additively or multiplicatively with λ_s?
3. Gumbel-softmax τ* critical transition: is it a genuine phase transition or a smooth crossover?
4. How does neurosymbolic program synthesis RLCT compare to pure neural RLCT when the program is trivial (s = identity)?
5. Can the complexity-RLCT ladder (C2) explain curriculum effects in program synthesis — easier programs first?
6. Effect of DSL expressivity on fiber structure — richer DSL = more strata = higher max RLCT?
7. Connection to #544 (Continual Learning / EWC): does program structure preservation (keeping s fixed) relate to fiber preservation in EWC?

## Cross-refs (8)
#544 (Continual Learning / EWC, fiber preservation), #169 (Dropout, stochastic stratum selector), #846 (Boosting, discrete round selector), #221 (Norm constraints, parameter space restriction), #532 (Contrastive, embedding manifold), #590 (Adversarial, min-max), #600 (Domain Adaptation, quotient singularity), #334 (Self-Distillation, fiber embedding)
