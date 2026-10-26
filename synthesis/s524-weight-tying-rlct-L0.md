#524: Weight Tying (Shared Embeddings) × RLCT -- L0 Outline
Date: 2026-10-22
Status: L0 OUTLINE (L0-L5 pipeline in progress)

## Candidate Selection Rationale
- Zero prior catalog entries for "weight tying" or "shared embeddings" × RLCT
- Distinct from #169 (dropout, drops neurons), #321 (stochastic depth, drops layers), #224/#323/#402/#409 (label smoothing)
- Weight tying constrains W_out = W_in^T (or shared matrix), projecting onto diagonal subspace in parameter space
- Novel SLT bridge: parameter identification via diagonal constraint creates explicit quotient fiber structure

## Core Bridge
Weight tying (shared input/output embeddings) imposes W_in = W_out on parameter space Θ = Θ_in × Θ_out, restricting to diagonal Δ ⊂ Θ_in × Θ_out. This:
1. Reduces effective parameter dimension dim(Δ) < dim(Θ_in) + dim(Θ_out)
2. Creates a quotient fiber structure π: Θ → Θ/∼ where ∼ identifies tied parameters
3. Changes the zero-loss fiber F(0) from a subset of Θ to a subset of Δ
4. Alters RLCT λ because the singularity structure of K(w) on Δ differs from Θ

## Claims (Preliminary)
- C1 (PROVABLE): Tied loss L_tied(w) = L_untied(w, w) restricted to diagonal is R_{an,exp}-definable (restriction of definable function to definable submanifold)
- C2 (CONJECTURAL): RLCT of tied model λ_tied ≠ λ_untied in general; quotient diagonal constraint changes singular fiber geometry
- C3 (CONJECTURAL): Tying creates stratum selector — diagonal Δ intersects singular strata of untied fiber transversally or tangentially depending on rank/width
- C4 (CONJECTURAL): Composite RLCT bound λ_tied ≤ λ_untied under transversality (diagonal subspace intersecting minimal stratum generically)
- C5 (CONJECTURAL): Optimal tying ratio t* (fraction of shared vs separate params) exhibits phase transition in λ(t)

## Open Questions
1. Does diagonal constraint generically increase or decrease RLCT?
2. How does tying interact with overparameterization (wide vs narrow models)?
3. Cross-lingual tying (shared across languages) — different singular structure?
4. Tied embeddings + LoRA adapter — how does rank-r perturbation interact with diagonal?
5. Gradient coupling through tied weights — different Fisher information on diagonal

## Cross-References
#169 (dropout), #224/#323/#402/#409 (label smoothing), #321 (stochastic depth), #490 (RoPE), #293 (KD), #8 (temperature), #16 (CE loss), #57 (softmax), #100 (overparameterization), #127 (Fisher)

## Next Steps
- L1 formalization (R_{an,exp} definability, quotient fiber construction)
- L2 novelty verification (websearch + LTM)
- L3 MeTTa encoding
- L4 summary
- L5 catalog append