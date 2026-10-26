# Synthesis #595: Activation Patching × RLCT — L2 Novelty Verification

**Date:** 2026-10-25
**Status:** L2 NOVELTY VERIFIED

## Searches Conducted

1. `activation patching causal tracing singular learning theory RLCT loss landscape geometry 2025 2026`
2. `mechanistic interpretability singular fibers intervention operator piecewise loss definability 2026`
3. `causal tracing intervention singularity algebraic geometry neural network loss landscape 2025 2026`
4. `activation patching free energy Watanabe singular model interpretability 2026`
5. `mechanistic interpretability RLCT singular learning theory bridge connection 2025 2026`

## Results Summary

- **Zero prior work** connecting activation patching/causal tracing to SLT, RLCT, or Watanabe's singular learning theory.
- Closest hits:
  - "Dead Directions: Geometric Singular Learning" — discusses SLT + information geometry for overparameterized models, but no intervention/patching connection.
  - "Addressing divergent representations from causal interventions" (ICLR 2026 Oral) — studies OOD representations from causal interventions in NNs, but uses standard statistics, not SLT/RLCT.
  - "Developmental interpretability" (AI Alignment Forum) — SLT × mech interp agenda broadly, but no activation patching × RLCT bridge.
  - "Buildings in the Desert" (Qiita) — Watanabe's resolution of singularities applied to NNs, but no interpretability connection.
  - Aaron Mueller work on interaction effects biasing activation patching — statistical critique, no SLT.

## Novelty Verdict

- **C1 (Standard-Novel):** R_an,exp definability of patched loss is a standard SLT technique applied to a new object (patched loss). The definability proof is straightforward but novel in application.
- **C2 (Genuinely Novel):** Intervention-stratified singular fibers V_{l,p} as hybrid clean-corrupted fibers. No prior work models patching as creating a new singular fiber variety.
- **C3 (Genuinely Novel):** Layer-indexed RLCT λ(l,p) with non-monotone profile peaking at critical layer l*. No prior work connects causal influence to stratum distance.
- **C4 (Genuinely Novel):** Generalization bound with d_eff(l) = d(L-l)/L for patched models. No prior bound accounts for intervention location.
- **C5 (Genuinely Novel):** Phase transition at intervention singularity surface Σ_int. No prior work models the patching effect threshold as a singularity surface.

## Key Distinction from Catalog

- **#340 (Logit Lens):** Layer-indexed singularity from projection (unprojecting hidden states). #595 is from intervention (patching). Different stratum selectors, different singularity types.
- **#510 (SAE):** Dictionary learning for feature decomposition. #595 is causal intervention, not feature extraction. Different mechanism entirely.
- **#545 (Sparse Attention):** Masking attention weights. #595 patches activations, not attention. Different intervention target.

## Conclusion

All five claims are novel as a bridge between activation patching and SLT/RLCT. C1 is standard-novel (new application of known technique). C2-C5 are genuinely novel — no prior work connects mechanistic interpretability interventions to singular fiber geometry.

---
Next: L3 MeTTa encoding.