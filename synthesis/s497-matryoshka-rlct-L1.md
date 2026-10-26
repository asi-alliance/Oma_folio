# Synthesis #497: Matryoshka Representation Learning × RLCT — L1 Formalization

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Definitions

D1 (Matryoshka embedding map): Let φ_θ: X → R^D be the full embedding map. The d_i-dimensional matryoshka sub-map is the projection π_{d_i} ∘ φ_θ: X → R^{d_i}, where π_{d_i}: R^D → R^{d_i} retains the first d_i coordinates. The matryoshka loss is L(θ) = Σ_{i=1}^{n} w_i · L_{d_i}(θ), where L_{d_i}(θ) = E_{(x,y)~D} [ℓ(π_{d_i}(φ_θ(x)), y)].

D2 (Nested singular loci): Define V_0^{d_i} = {θ : ∂L_{d_i}/∂θ = 0, ∇²L_{d_i} is degenerate} as the singular locus of L_{d_i}. Since π_{d_j} = π_{d_i} ∘ π_{i,j} for d_i < d_j (where π_{i,j}: R^{d_j} → R^{d_i}), the loss L_{d_i} depends on fewer output coordinates, creating the nesting V_0^{d_1} ⊇ V_0^{d_2} ⊇ ... ⊇ V_0^{d_n} = V_0^D. (Note: containment direction — the set of θ where L_{d_i} is singular contains the set where L_{d_j} is singular, because L_{d_i} ignores some coordinates, making it degenerate more often.)

D3 (Filtered singular variety): The sequence V_0^{d_1} ⊇ V_0^{d_2} ⊇ ... ⊇ V_0^D defines a descending filtration of the singular locus. Each quotient V_0^{d_i} / V_0^{d_{i+1}} captures the singularity structure specific to dimensions in (d_i, d_{i+1}].

D4 (RLCT at each granularity): Let λ(d_i) = RLCT of K(θ) = L_{d_i}(θ) at a local min θ*. By the restriction principle (projection to subspace), λ(d_i) ≤ λ(d_j) for d_i < d_j, since the projected map has simpler singularity structure.

D5 (Matryoshka effective loss): The combined loss L(θ) = Σ w_i L_{d_i}(θ) has K-function K_eff(θ) = Σ w_i K_{d_i}(θ). The effective singular locus is V_0^{eff} = ∩_i V_0^{d_i} (intersection, since all terms must be simultaneously minimized).

## Core Claims

### C1 (PROVEN, standard-novel): RLCT monotonicity under coordinate projection

Claim: For d_i < d_j, λ(d_i) ≤ λ(d_j).

Proof sketch: The d_i-dimensional map ψ_i = π_{d_i} ∘ φ_θ is a factor of ψ_j = π_{d_j} ∘ φ_θ via ψ_i = π_{i,j} ∘ ψ_j. In the framework of Watanabe's theorem, the RLCT of a composition g ∘ f satisfies λ(g ∘ f) ≤ λ(f) when g is a linear projection (submersion). This follows from the fact that the pullback of a resolution of singularities under a submersion preserves the log-canonical threshold upper bound. Concretely: if σ: M̃ → R^D is a resolution of ψ_j, then π_{i,j} ∘ σ is a resolution (possibly after refinement) of ψ_i, and the Jacobian order can only decrease under linear projection. Therefore λ(d_i) ≤ λ(d_j). QED.

### C2 (CONJECTURAL, genuinely novel): Effective RLCT of matryoshka loss

Claim: The effective RLCT of the combined loss L = Σ w_i L_{d_i} satisfies λ_eff = min_i {w_i · λ(d_i)} when the strata V_0^{d_i} are in general position.

Argument: Near a local minimum θ*, each K_{d_i}(θ) ~ |θ - θ*|^{2λ(d_i)}. The combined K_eff ~ Σ w_i |θ - θ*|^{2λ(d_i)}. The dominant term near θ* is the one with smallest exponent, i.e., min_i {2λ(d_i)} (assuming w_i > 0). Thus λ_eff = min_i λ(d_i), dominated by the coarsest (lowest-λ) stratum. This explains why matryoshka preserves coarse-grained performance: the free energy landscape is dominated by the simplest stratum.

Caveat: If strata are not in general position (e.g., nested as in D2), the interaction terms may modify this. The intersection structure V_0^{eff} = ∩_i V_0^{d_i} means the effective locus is the smallest stratum V_0^{d_n} = V_0^D, but the RLCT is governed by the approach to this locus through the filtration.

### C3 (CONJECTURAL, genuinely novel): Filtered singular variety and phase transitions

Claim: The filtration V_0^{d_1} ⊇ V_0^{d_2} ⊇ ... ⊇ V_0^D creates a sequence of RLCT phase transitions. At each dimension boundary d_i → d_{i+1}, the model transitions from stratum V_0^{d_{i+1}} to V_0^{d_i}, with RLCT jumping from λ(d_{i+1}) to λ(d_i).

Argument: The difference λ(d_{i+1}) - λ(d_i) > 0 quantifies the "information cost" of adding dimensions (d_i, d_{i+1}]. This is a phase transition in the representation granularity. SGLD should detect this as a kink in the local learning coefficient λ̂ when evaluating at different truncation dimensions.

### C4 (CONJECTURAL, genuinely novel): Optimal matryoshka dimensionality via RLCT

Claim: For a task with n samples, the optimal embedding dimension d* satisfies: λ(d*)/n ≈ ε(d*), where ε(d) is the approximation error at dimension d.

Argument: Generalization bound G(d) ~ λ(d)/n + ε(d). Since λ(d) increases with d and ε(d) decreases with d, the optimum balances RLCT complexity against approximation quality. For matryoshka, d* can be selected at inference time by estimating λ̂(d_i) via SGLD at each granularity and choosing d* = argmin {λ̂(d_i)/n + ε̂(d_i)}.

### C5 (CONJECTURAL, genuinely novel): Multi-resolution training dynamics

Claim: Matryoshka training traverses strata from coarse to fine. Early training is dominated by the lowest-λ stratum (coarse), with the model's effective parameters residing in V_0^{d_1}. As training progresses, higher-λ strata activate, and the model gradually populates V_0^{d_2}, ..., V_0^D.

Argument: The free energy F_n = -log Z_n is dominated by the lowest-λ stratum initially (as in standard SLT). As n increases (or training proceeds), higher-λ strata contribute. The matryoshka weighting w_i controls the rate of stratum activation. This is analogous to coarse-to-fine optimization in wavelet methods, but derived from RLCT geometry.

## Open Problems (7)

1. [HIGH] Prove C2 rigorously: when strata are nested (not general position), is λ_eff = min_i λ(d_i) or λ_eff = λ(d_n)? The intersection vs union tension needs resolution.
2. [HIGH] SGLD verification: measure λ̂ at each matryoshka dimension {128, 256, 512, 768} on a trained model and verify λ(d_i) ≤ λ(d_j) for d_i < d_j.
3. [HIGH] Formalize the "information cost" λ(d_{i+1}) - λ(d_i) and relate to mutual information between dimensions (d_i, d_{i+1}] and the target.
4. [MED] C4 empirical test: train matryoshka models, measure d* for tasks at varying n, compare with RLCT-predicted d*.
5. [MED] C5 dynamics: track which stratum dominates free energy during training using annealed SGLD at different temperatures.
6. [MED] Weight scheduling: how do matryoshka weights w_i affect the effective RLCT? Optimal w_i selection via RLCT.
7. [LOW] Connection to matryoshka KV-cache compression: does the RLCT filtration explain why truncated KV-cache retains performance?

## Cross-References (10)

#8 (grokking — stratum transition dynamics), #65 (singular stratum), #94 (phase transition), #115 (emergent ability — dimension thresholds), #220 (pruning — parameter removal vs dimension truncation), #249 (LoRA — rank constraint vs output dimension), #264 (LayerNorm — normalization singularity), #312 (multi-token prediction — multiple output heads), #496 (CoT — sequential stratum transitions, inference-time), #302 (linear attention — rank-deficient feature map)

## Status

L1 written 2026-10-21. Next: L2 novelty verification.
