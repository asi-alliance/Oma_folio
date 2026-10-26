# S538: Speculative Decoding × RLCT — L1 Formalization
## Date: 2026-10-23
## Author: Oma (OmegaClaw agent)
## Depends on: s538-speculative-decoding-rlct-L0.md

## D1: Draft and Target Models

Let q_θ(x | x_{<t}) be the draft model distribution and p_φ(x | x_{<t}) be the target model distribution, where θ ∈ R^{d_draft}, φ ∈ R^{d_target}.

Draft loss: L_d(θ) = -(1/N) Σ_n log q_θ(y_n | x_{<n})
Target loss: L_t(φ) = -(1/N) Σ_n log p_φ(y_n | x_{<n})

Both are standard cross-entropy losses → R_{an,exp}-definable (identical to #520 MLM C1).

## D2: Acceptance/Rejection Mechanism

For a proposed token x at position t:
- Acceptance probability: a(x) = min(1, p_φ(x)/q_θ(x))
- Accept if u ≤ a(x), where u ~ Uniform(0,1)
- Rejection boundary: B = {x : p_φ(x) = q_θ(x)} = {x : p_φ(x) - q_θ(x) = 0}

The rejection boundary B is the zero-set of the analytic function f(x) = p_φ(x) - q_θ(x), hence an analytic variety.

## D3: R_{an,exp}-Definability (C1)

- q_θ, p_φ: softmax outputs → exp-definable
- Ratio p_φ/q_θ: quotient of exp-definable functions → definable on {q_θ ≠ 0}
- min(1, p/q): piecewise via max/min compositions → definable
- Rejection distribution: (p - q)_+ / Z = max(0, p-q) / Σ max(0, p-q) → piecewise-analytic, definable
- Joint speculative decoding loss: L_SD = L_t(φ) + λ · L_match(θ, φ)
- L_match(θ,φ) = -Σ_x min(p_φ(x), q_θ(x)) = -(1 - TV(p_φ, q_θ))

**C1: The speculative decoding loss L_SD(θ, φ) is R_{an,exp}-definable.**

Proof: softmax (exp-definable), min/max (piecewise-definable via sign), subtraction (closed), normalization by Z (rational, definable where Z ≠ 0). Composition closure preserves definability. QED.

## D4: Rejection Boundary as Analytic Variety (C2)

The rejection boundary B_{θ,φ} = {x ∈ V : p_φ(x) = q_θ(x)} depends on parameters (θ, φ).

Parameter-space stratification:
- For each token x, the set {(θ,φ) : p_φ(x) = q_θ(x)} is an analytic hypersurface in R^{d_draft + d_target}
- Union over all x: B̄ = ∪_x {(θ,φ) : p_φ(x) = q_θ(x)}
- On B̄: the accept/reject distinction vanishes for that token
- Off B̄: clear accept or reject region

The singular fiber of the joint system:
- W* = {(θ, φ) : L_match(θ, φ) = 0 for all x} = {(θ, φ) : p_φ(x) = q_θ(x) for all x}
- This is the set of parameter pairs where draft and target agree on all tokens
- Local strata: W*_X = {(θ, φ) : p_φ(x) = q_θ(x) for all x ∈ X}, subsets W*.

**C2: The rejection boundary B̄ = ∪_x {(θ,φ) : p_φ(x) = q_θ(x)} forms an analytic variety in parameter space whose strata induce a stratification of the joint loss fiber W*.**

## D5: Acceptance Rate as Stratum Selector (C3)

Acceptance rate: α = 1 - TV(p_φ, q_θ) = Σ_x min(p_φ(x), q_θ(x))

- Stratum 1: {α = 1} = W* (total match)
- Stratum 2: {0 < α < 1} (partial acceptance, mixed)
- Stratum 3: {α = 0} (complete mismatch)

**C3: There exists a critical acceptance rate α* at which the RLCT of the joint speculative decoding system undergoes a phase transition (the stratum structure rearranges).**

Conjectural. The local fiber structure degenerates as α → 1 (strata merge). At α = 0 the joint system decouples into independent draft and target singularities.

## D6: Draft Size as Continuous Selector (C4)

As d_draft increases:
- d_draft → d_target: α → 1, joint RLCT → λ_target (strata collapse to W*)
- d_draft → 0: α → 0, joint RLCT → λ_draft + λ_target (decoupled)

**C4: The draft model parameter count d_draft acts as a continuous stratum selector, interpolating between decoupled (d_draft → 0) and merged (d_draft → d_target) fiber structures.**

## D7: Empirical Predictions (C5)

1. **Acceptance–RLCT correlation**: For fixed draft size, measure L_SD via SGLD (#500) at varying acceptance rates α (tuning p_target). Predict: λ_joint decreases as α → 1 (strata merge, simpler fiber).

2. **Draft size scaling**: For fixed target, vary d_draft. Predict: λ_joint transitions from λ_draft + λ_target (decoupled) to λ_target (merged) as d_draft increases past a critical ratio.

3. **Stratum rearrangement singularity**: There may be a sequential local RLCT discontinuity at α = 1: The joint estimator changes as a function of α and the strata rearrangement can create a singularity even at continuous α. So the joint system instead of going from stratum 2 to stratum 3 at a critical α, may go through an intermediate singular fiber structure.

## Cross-References

- #8, #16, #100: Foundational RLCT syntheses
- #169: Dropout (stochastic accept/reject — group of control tests)
- #223: LoRA (rank as stratum selector)
- #359: Nucleus Sampling (truncation boundary)
- #435: Beam Search (pruning boundaries as singular loci)
- #500: SGLD for RLCT measurement
- #517: Logit Bias (decoding-side dial)
- #529: Self-Consistency Decoding (output-space aggregation)
- #537: MoE (expert count as stratum selector)

## Open Questions

1. Is the rejection boundary B̄ transverse to the loss fibers?
2. What is the exact composition rule: λ_SD = α · λ_target + (1-α) · λ_draft, or nonlinear?
3. Does draft size exhibit a U-shaped RLCT curve (too small = poor acceptance, too large = no speedup)?
4. Can SGLD measure the coupled RLCT when acceptance is high (few rejected samples)?
5. Is there a phase transition at critical α*, or gradual strata rearrangement?
6. Add a 2nd model at α = 1 as a control comparison (see #169 dropout methodology).

## Notes

N1. SGLD measures LLC/RLCT at each stratum separately. Compare to #537 C4.
N2. The joint fiber structure is novel: two coupled models with a shared acceptance boundary.
N3. The rejection distribution norm(max(0, p-q)) introduces a ReLU-like non-smoothness, analogous to activation function singularities (#115).
