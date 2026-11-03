# Synthesis #821: Classifier-Free Guidance x RLCT - L4 Summary

## Date: 2026-10-29
## Status: L4 Summary (Pipeline L0-L4 Complete)

## Plain-Language Summary

**C1 (PROVEN):** The classifier-free guidance (CFG) loss landscape is R_an,exp-definable. The guided score is a linear combination of neural network outputs (analytic activations), and the loss is polynomial (degree 2) in the guided score. Tarski-Seidenberg closure preserves definability.

**C2 (CONJECTURAL):** The null-token fiber F_empty — where conditional and unconditional scores coincide — is the most singular stratum. Conditioning dropout collapses all class information into a single degenerate point, creating the largest codimension singularity. We conjecture lambda_empty >= lambda_c for all c.

**C3 (CONJECTURAL):** The guidance scale w acts as a continuous stratum selector, smoothly interpolating between the null-token-dominated stratum (w=0) and the extrapolated conditional stratum (w->inf). The effective RLCT lambda_eff(w) is conjectured monotone non-increasing, though non-monotonicity from over-saturation remains possible.

**C4 (CONJECTURAL):** The generalization bound E[L_test] <= E[L_train] + C*sqrt(lambda_eff(w)*log(n)/n) replaces d/2 with the w-dependent lambda_eff(w). This predicts an optimal w* balancing generalization (lower lambda_eff) and diversity (higher lambda_eff), explaining empirical w* ~ 3-8 in diffusion models.

**C5 (CONJECTURAL):** At critical w*, the loss landscape undergoes a phase transition detectable via SGD LLC estimation. The dominant singular stratum shifts from null-token-dominated to conditional-dominated, producing a discontinuity in the local learning coefficient.

## Key Novelty
CFG introduces a continuous interpolation stratum selector (guidance scale w) between unconditional and conditional singular fibers. Unlike discrete selectors (#468 PPO eps-clipping) or architectural selectors (#673 RWKV time-decay), CFG creates smooth polynomial-interpolated singular fiber families. The null-token fiber F_empty is a unique singularity mechanism: information collapse via conditioning dropout, distinct from architectural degeneracies in prior syntheses. Inference-time RLCT modulation (lambda_eff changes at test time without retraining) is unprecedented in the catalog.

## Open Problems (7)
1. Exact form of lambda_eff(w): strict monotonicity or non-monotonicity from score geometry?
2. Over-saturation singularity: does w->inf create a NEW singularity absent at finite w?
3. Conditioning dropout rate p: separate stratum selector or coupled with w?
4. Connection to #167 (DDPM) and #360 (Flow Matching): multiplicative or additive RLCT composition?
5. Discrete vs continuous conditioning: different fiber structure?
6. LLC estimation at different w: experimental protocol for detecting phase transition?
7. Relationship to #201 (Meta-learning): is CFG meta-learning over guidance scales?

## Cross-References (9)
#167 DDPM, #311 DDIM, #360 Flow Matching, #361 Flow Matching variant, #201 Meta-learning/MAML, #213 Optimizer modulation, #507 Watermarking, #651 PAC-Bayes, #805

## Pipeline Status
L0 (exploration) -> L1 (formalization) -> L2 (novelty verification) -> L3 (MeTTa encoding) -> L4 (summary) COMPLETE
Next: L5 catalog append
