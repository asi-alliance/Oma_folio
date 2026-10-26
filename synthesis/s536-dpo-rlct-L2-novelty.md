# Synthesis #536: L2 - DPO x RLCT Novelty Verification

## Date
2026-10-23

## External Novelty (Websearch)
- Search 1: "DPO singular learning theory RLCT fiber geometry 2025" — zero hits bridging DPO to SLT/RLCT. Found general SLT references (Watanabe, Wei/Murfet) but no DPO-specific RLCT analysis.
- Search 2: "implicit reward map non-identifiability preference optimization statistical learning theory 2025" — found papers on implicit reward (NeurIPS 2025, "Implicit Reward as the Bridge") but these use standard statistical learning theory, NOT singular learning theory. No RLCT, no fiber geometry.
- Verdict: Zero external prior bridge. DPO x RLCT remains unexplored in literature.

## Internal Novelty (vs #160)
#160 (DPO x RLCT) completed L0-L5 on 2026-09-23. Key claims covered:
- C1: R_an,exp definability (SAME as #536 C1)
- C2: Implicit reward fiber in logit-difference space (OVERLAP with #536 C2)
- C3: Beta as boundary-sharpness (OVERLAP with #536 C3 preference boundary)
- C4: Reference policy quotient — #160 noted compactness vs PPO but did NOT formalize quotient space Q or gauge-theoretic framing (NOVEL REFINEMENT in #536)
- C5: #160 compared DPO to PPO qualitatively; #536 C5 predicts explicit RLCT gap lambda_DPO < lambda_RLHF as SGLD-measurable (NOVEL REFINEMENT)

## Overlap Assessment
| Claim | #160 | #536 | Verdict |
|-------|------|------|---------|
| C1 (definability) | Proven | Proven | OVERLAP (same technique) |
| C2 (fiber) | Implicit reward fiber | Quotient space + gauge framing | REFINEMENT |
| C3 (boundary) | Beta boundary-sharpness | Preference boundary as variety + phase transition | REFINEMENT |
| C4 (reference) | Not formalized | Partial gauge fixing, residual degeneracy | NOVEL |
| C5 (DPO vs RLHF) | Qualitative PPO comparison | Explicit RLCT gap prediction, SGLD-measurable | NOVEL |

## External Distinctness
- #468 (PPO x RLCT): branch-switch singularity at r=1±epsilon — distinct mechanism (non-analytic clip) vs DPO analytic sigmoid
- #414 (GRPO x RLCT): consensus fiber S_consensus — group-based, distinct from DPO pairwise preference
- #136 (RLHF x RLCT): explicit reward model fiber — sequential composition vs DPO compound fiber

## Verdict: NOVEL REFINEMENT
- C1: OVERLAP with #160 (standard definability, identical proof technique)
- C2-C3: NOVEL REFINEMENTS (quotient space, gauge-theoretic framing, boundary as algebraic variety with explicit phase transition mechanism)
- C4-C5: GENUINELY NOVEL (gauge fixing of reference policy, explicit DPO vs RLHF RLCT gap prediction)

## Key Novel Contributions
1. Quotient space Q = R^d / ~ with effective dimension d_eff = rank(J_Phi)
2. Reference policy as partial gauge fixing — residual gauge freedom = fiber directions
3. Preference boundary B_{w,l} as real algebraic variety (not just "boundary sharpness")
4. Explicit prediction: lambda_DPO < lambda_RLHF for well-aligned data, SGLD-measurable
5. Transition region width ~ 1/beta as temperature-controlled RLCT transition

## Caveats
- Significant overlap with #160 on C1; #536 should be viewed as refinement/extension
- C2 fiber dimension formula unproven (needs transversality)
- C5 prediction direction (lambda_DPO < lambda_RLHF) is conjectural
- ker(J_Phi) not explicitly characterized for transformer architectures