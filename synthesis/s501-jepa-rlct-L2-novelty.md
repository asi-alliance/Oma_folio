# Synthesis #501: JEPA (Joint Embedding Predictive Architecture) × RLCT - L2 Novelty Verification

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Websearch Summary (5 searches)

1. "JEPA singular learning theory RLCT real log canonical threshold latent representation" — zero hits connecting JEPA to SLT/RLCT
2. "JEPA joint embedding predictive architecture learning coefficient generalization bound singular" — zero hits
3. "BYOL EMA target encoder singular learning theory RLCT representation collapse" — zero hits
4. "JEPA representation collapse singular learning theory generalization bound 2025 2026" — general JEPA/collapse papers, no SLT bridge
5. "Stop-gradient EMA target encoder singular learning theory piecewise definable loss landscape 2025 2026" — stop-gradient theory papers, no SLT/RLCT connection

**Verdict: Zero prior JEPA × SLT/RLCT bridge in the literature.**

## Catalog Check

grep -ci "JEPA|joint.embed|predictive.arch|embedding.predict" synthesis-catalog.md → 0 hits
grep -ci "masked.auto|MAE" synthesis-catalog.md → 0 hits

**No prior catalog entries for JEPA or masked autoencoder.**

## Overlap Analysis

### #438 BYOL × RLCT (closest analog)
- BYOL: online encoder + EMA target encoder + predictor. Self-prediction: online branch predicts its own EMA target.
- JEPA: separate context encoder + EMA target encoder + predictor with positional encoding. Prediction is conditional on position (product space Z × P → Z).
- **Overlap:** Both use EMA target encoder, stop-gradient, predictor network, latent-space prediction. Both have collapse stratum.
- **Distinction 1 (Embedding Variety):** JEPA's loss lives on the embedding variety V_t defined by target encoder — the RLCT is that of the predictor g restricted to V_t. BYOL's #438 analysis uses a three-level fiber (predictor/collapse/self-prediction) without explicit embedding variety restriction. JEPA's V_t restriction is a genuinely new mechanism.
- **Distinction 2 (Positional Encoding):** JEPA predictor takes positional encoding pos ∈ P as input, creating a product-space fiber F ⊂ Z × P × W_p → Z. This product-space structure (prediction depends on WHERE in the target to predict) has no analog in BYOL, where the predictor maps Z_online → Z_target without positional conditioning.
- **Distinction 3 (Separate Encoders):** JEPA uses separate context and target encoders (f_c and f_t), while BYOL uses the same encoder architecture with EMA copy. The context-target separation means the embedding variety V_c and V_t are distinct, and the predictor must bridge between them — a fiber mapping V_c → V_t not present in BYOL.
- **Distinction 4 (Architecture Hierarchy):** JEPA explicitly varies predictor capacity (width h, depth L_p) as a design parameter. BYOL's predictor is auxiliary. JEPA's capacity-as-stratum-selector (C6) is more explicit.
- **Verdict: DISTINCT from #438 BYOL.** The embedding-variety-restricted RLCT and positional-encoding product-space fiber are genuinely novel contributions.

### #18 Contrastive Learning × RLCT (covered)
- Contrastive uses similarity (cosine/dot product) with negative pairs. JEPA uses prediction (neural network) without negatives.
- Fiber structure differs: contrastive fiber = level sets of similarity; JEPA fiber = level sets of predictor output.
- **Verdict: DISTINCT.**

### #82 Autoencoder × RLCT (covered)
- Autoencoder: pixel-space reconstruction (x → x̂). JEPA: latent-space prediction (z_c → z_t).
- RLCT lives on different varieties: pixel space vs embedding variety.
- **Verdict: DISTINCT.**

### #500 Token Merging × RLCT (covered)
- Token merging: quotient by bipartite matching. JEPA: prediction in latent space.
- **Verdict: DISTINCT.**

## Novelty Assessment

| Criterion | Status |
|-----------|--------|
| C1 (Definability) | Standard-novel (R_an,exp definability via piecewise-analytic + EMA, consistent with #8, #16, #499) |
| C2 (Collapse fiber) | NOVEL — embedding-variety-restricted singular stratum. Distinct from #438's three-level fiber. |
| C3 (EMA as stratum selector) | NOVEL refinement — α as continuous selector between frozen (α→1) and symmetric (α→0) regimes. #438 has EMA but treats it as time-dependent regulator, not as continuous stratum selector with U-shaped optimum. |
| C4 (Generalization bound) | NOVEL — λ_JEPA restricted to V_t + EMA drift tension U_EMA. The embedding-variety restriction is the key novel element vs #438's self-prediction fiber. |
| C5 (Phase transition α*) | NOVEL — U-shaped λ(α) with collapse-dominated vs prediction-dominated regimes. #438 predicts phase transition but in predictor-capacity space, not EMA-decay space. |

## Key Novel Contributions

1. **Embedding-variety-restricted RLCT:** The RLCT of the predictor g restricted to V_t (target embedding variety) — a projected/restricted RLCT not seen in prior syntheses. This is the standout novelty.
2. **Positional-encoding product-space fiber:** The predictor fiber F ⊂ Z × P × W_p → Z, where positional encoding creates a product-space structure absent from BYOL (#438).
3. **Context-target encoder separation fiber:** V_c → V_t mapping as a fiber between two distinct embedding varieties, more general than BYOL's self-prediction.
4. **EMA decay α as continuous stratum selector with U-shaped optimum:** Refinement of #438's EMA analysis to a continuous selector perspective.

## Status

L2 NOVELTY PASSED. 5 websearches, zero SLT/RLCT bridge. Zero catalog hits. C1 standard-novel, C2-C5 genuinely novel. Distinct from #438 BYOL (embedding-variety restriction, positional-encoding product space, context-target separation). File at /tmp/Oma_folio/synthesis/s501-jepa-rlct-L2-novelty.md. Next: L3 MeTTa encoding.
