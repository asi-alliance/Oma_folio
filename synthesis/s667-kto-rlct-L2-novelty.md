# Synthesis #667: KTO × RLCT — L2 Novelty Verification
## Date: 2026-10-28

## Websearch Results (5 searches)
1. "KTO Kahneman-Tversky optimization singular learning theory RLCT loss landscape generalization 2025 2026" — ZERO SLT/RLCT hits
2. "KTO loss function prospect theory utility asymmetry singular fiber algebraic geometry" — ZERO SLT/RLCT hits
3. "KTO prospect theory loss aversion RLCT singularity generalization bound deep learning" — ZERO SLT/RLCT hits
4. "Kahneman-Tversky optimization loss landscape geometry singular fiber stratum selector preference alignment" — ZERO SLT/RLCT hits
5. "KTO vs DPO singular learning theory real log canonical threshold loss landscape comparison" — ZERO SLT/RLCT hits

## Catalog Overlap Check
- grep -ic 'KTO\|Kahneman\|Tversky\|prospect.theory' synthesis-catalog.md = 0 hits

## Overlap Analysis with Prior Syntheses
1. #599 DPO × RLCT: PAIRWISE fiber (coupled pair y_w × y_l at Δ=0 boundary). KTO is SINGLE-SAMPLE fiber (independent V+ ∪ V- at z_ref boundary). DISTINCT fiber structure.
2. #579 GRPO × RLCT: GROUP-NORMALIZED fiber (group advantage normalization). KTO has no group structure. DISTINCT.
3. #468 PPO × RLCT: CLIP RATIO fiber (ε-constrained trust region in policy space). KTO has no clip constraint. DISTINCT.
4. #224 Label Smoothing × RLCT: SYMMETRIC soft target fiber. KTO is ASYMMETRIC (κ-weighted). DISTINCT.
5. #136 RLHF × RLCT: General RLHF framework. KTO is a specific instantiation with prospect theory. KTO's asymmetric fiber and reference-point gauge are not present in general RLHF treatment.

## Verdict: NOVEL
KTO × RLCT is genuinely novel. Zero external SLT/RLCT bridge found. Zero catalog entries. All 5 prior synthesis overlaps are DISTINCT.

Key novel contributions:
1. Asymmetric singular fibers V+ ≠ V- with different RLCTs (λ+ ≠ λ-)
2. Loss aversion κ as continuous stratum selector compressing V-
3. Reference point z_ref as codimension-1 gauge slice (weaker than DPO's full gauge)
4. Single-sample fiber structure (vs DPO's coupled pair-fiber)
5. Weighted RLCT formula λ_eff(κ) = (λ+ + κ·λ-)/(1+κ)
6. β* × κ* phase transition surface for optimal generalization

## Next: L3 MeTTa encoding
