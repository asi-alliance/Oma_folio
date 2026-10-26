# Synthesis #491: Grokking × RLCT — L4 Summary

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Topic
Grokking (delayed generalization phenomenon) × Real Log Canonical Threshold (RLCT) from Singular Learning Theory.

## Pipeline Status
L0 (topic selection) — COMPLETE
L1 (formalization: D1-D7, C1-C5) — COMPLETE
L2 (novelty verification) — COMPLETE (PARTIALLY NOVEL)
L3 (MeTTa encoding) — COMPLETE
L4 (this summary) — COMPLETE
L5 (catalog append) — PENDING

## Key Definitions
- D1: Grokking phenomenon (train loss → 0 early, test loss → 0 late, t_grok > t_train)
- D2: Grokking ratio r = t_grok / t_train
- D3: Pre-grok singular stratum W_pre (memorizing, high RLCT)
- D4: Post-grok singular stratum W_post (generalizing, low RLCT)
- D5: RLCT gap Δλ = λ_pre - λ_post > 0 (thermodynamic driving force)
- D6: Grokking transition as posterior mass ratio crossing ρ(t_grok) ≈ 1
- D7: Modularity threshold m* ~ AlgComplexity(q)

## Claims
- C1 (PROVEN): R_an,exp-definability of grokking loss landscape (CE+softmax+weight decay composition)
- C2 (CONJECTURAL): RLCT descent during grokking — OVERLAP with arXiv:2512.00686
- C3 (GENUINELY NOVEL): Grokking timing scaling law r ~ exp(Δλ·n/T_eff)
- C4 (GENUINELY NOVEL): Pre/post-grok Watanabe generalization bounds G ~ λ·log(n)/n + U/sqrt(n)
- C5 (CONJECTURAL): SGLD/LLC detectability — OVERLAP with arXiv:2512.00686

## Novelty Assessment
arXiv:2512.00686 independently studies grokking via SLT/LLC empirically. C2 (posterior migration to lower RLCT) and C5 (LLC detection) partially overlap. C3 (quantitative timing prediction), C4 (formal gen bound framework), and D7 (modularity threshold) are genuinely novel.

## Open Problems (7)
1. Rigorous SGD trajectory analysis (prove finite-time migration)
2. Order of phase transition (first vs second order)
3. Weight decay as stratum selector formalization
4. Architecture effects on Δλ and m*
5. Double descent connection (#189)
6. Dataset modularity and m* derivation
7. SGLD protocol design for grokking detection

## Cross-References
#490 RoPE, #485 RLT, #224 Positional Encoding, #468 PPO, #425 Zoneout, #362 CFG, #189 Double Descent, #415 Grokking candidate

## Files
- s491-grokking-rlct-L0.md (3271B)
- s491-grokking-rlct-L1.md (9828B)
- s491-grokking-rlct-L2-novelty.md (3273B)
- s491-grokking-rlct-L3.metta (4522B)
- s491-grokking-rlct-L4-summary.md (this file)