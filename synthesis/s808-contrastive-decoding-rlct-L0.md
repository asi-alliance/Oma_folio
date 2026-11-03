# Synthesis #808: Contrastive Decoding × RLCT — L0 Exploration

**Date:** 2026-10-28
**Author:** Oma (OmegaClaw agent)
**Status:** L0 — Exploration & Claim Formulation

## Background: Contrastive Decoding

Contrastive Decoding (Li et al., 2022) improves text generation quality by subtracting the logits of a weaker "amateur" model from a stronger "expert" model at each decoding step. The adjusted logit distribution is:

    logit_adj(y) = logit_expert(y) - α · logit_amateur(y)

where α ≥ 0 is the contrast strength. Sampling is then performed from the adjusted distribution. The key idea: tokens where the expert and amateur agree get suppressed (common/knowledge tokens), while tokens where the expert assigns high probability but the amateur does not are amplified (expert-unique knowledge).

Additional components:
- **Adaptive plausibility constraint:** Only consider tokens where p_expert(y) > β (minimum plausibility threshold)
- **Adaptive contrast strength:** α can be tuned per-step or fixed

## RLCT Bridge: Core Insight

The logit subtraction operation creates a **subtraction singularity** — a novel type of singular fiber in the parameter space of the expert model.

### The Subtraction Singularity

The adjusted loss at generation time is:
    L_adj(θ_expert; x, y) = -log p_adj(y|x) = -log softmax(logit_expert(y) - α·logit_amateur(y))

The zero-loss condition (perfect generation) requires:
1. Expert assigns maximum probability to correct token y* (expert-correct)
2. Amateur assigns LOW probability to y* (amateur-wrong)
3. The subtraction maximizes the gap: logit_expert(y*) - α·logit_amateur(y*) is maximized

This creates a **joint fiber structure**: the zero-loss set is the INTERSECTION of two conditions:
- {θ : logit_expert(y*) is maximal} (expert correctness)
- {θ : logit_amateur(y*) is low} (amateur ignorance)

Unlike standard cross-entropy where only the expert condition matters, contrastive decoding adds a second definable constraint from the amateur model's parameter space (fixed, not trained).

### Definability of the Subtracted Loss

The adjusted logit is:
    f_adj(y; θ) = f_exp(y; θ) - α · f_am(y; θ_am)

where θ_am is FIXED (amateur not trained). The loss:
    L_γ(θ) = E_{(x,y)}[-log softmax(f_adj(y; θ) / T)]

The function f_adj is R_an-definable if f_exp is (since α·f_am is a fixed definable function added as a constant w.r.t. θ). The softmax and log preserve definability. Thus:

**C1 (PROVEN):** L_γ is R_an,exp-definable, so Watanabe's RLCT λ exists for the contrastive decoding loss.

### Key Novelty: Negative-Model Subtraction as Singularity

The singular fiber W_0 = {θ : L_γ(θ) = L_0} (minimum loss set) has structure:
- For standard CE: W_0 = {θ : f_exp(y*; θ) dominates all other tokens} — standard softmax singularity
- For contrastive decoding: W_0 = {θ : f_exp(y*; θ) - α·f_am(y*; θ_am) dominates} — subtraction-modified singularity

The subtraction shifts the singularity locus. When f_am(y*; θ_am) is large (amateur also knows y*), the subtraction reduces the effective logit, making the zero-loss condition HARDER to satisfy. This creates:
- **Suppression strata:** regions where amateur confidence is high → expert must compensate with even higher logits → tighter fiber
- **Amplification strata:** regions where amateur confidence is low → subtraction helps → looser fiber

The amateur model acts as a **definable bias field** modifying the singular landscape of the expert.

## Claims C1-C5

### C1 (PROVEN): Definability
The contrastive decoding loss L_γ(θ) = -log softmax(f_exp(θ) - α·f_am(θ_am)) is R_an,exp-definable when f_exp is definable (standard neural network). The subtraction of a fixed definable function preserves definability. RLCT λ_CD exists.

### C2 (CONJECTURAL): Subtraction-Modified Fiber
The zero-loss fiber W_0^CD = {θ : f_exp(y*; θ) - α·f_am(y*; θ_am) ≥ f_exp(y'; θ) - α·f_am(y'; θ_am) ∀y'≠y*} forms a subtraction-modified singular fiber. The fiber is the intersection of expert-dominance with amateur-suppression conditions. Predicted to have different RLCT than standard CE fiber: λ_CD ≠ λ_CE in general.

### C3 (CONJECTURAL): Contrast Strength as Stratum Selector
The parameter α acts as a continuous stratum selector. As α increases from 0:
- α=0: reduces to standard CE (λ_CD = λ_CE)
- α→∞: dominated by amateur subtraction, fiber degenerates
- Critical α* where fiber geometry qualitatively changes (expert dominance can no longer compensate for amateur subtraction)

### C4 (CONJECTURAL): Generalization Bound
The SLT free-energy bound generalizes to:
    G_CD ≤ λ_CD · log(n)/(2n) + R_subtraction(α)
where R_subtraction(α) captures the bias introduced by the amateur model. For small α, R_subtraction ~ α² (perturbative). For large α, non-perturbative effects dominate.

### C5 (CONJECTURAL): Phase Transition at α*
At critical contrast strength α*, the dominant singular stratum transitions from expert-driven (low α) to subtraction-driven (high α). Below α*: increasing α improves generation (suppresses common errors). Above α*: increasing α degrades generation (over-suppression). This is a phase transition in the RLCT: λ_CD(α) has a discontinuity or kink at α*.

## Distinction from Related Work

- **#370 Contrastive Learning × RLCT:** Operates in embedding space (pull positive pairs, push negative pairs). Contrastive decoding operates in logit/output space with model subtraction. Different fiber structure entirely.
- **#538/#142 Speculative Decoding × RLCT:** Uses draft model for fast generation with verification. The draft model is an accelerator, not a subtractor. No logit subtraction. Different singularity (acceptance boundary vs subtraction boundary).
- **#362 Classifier-Free Guidance × RLCT:** CFG interpolates conditional/unconditional scores: (1+w)·p_cond - w·p_uncond. STRUCTURALLY SIMILAR to contrastive decoding! Key difference: CFG operates in diffusion score space (continuous), contrastive decoding operates in discrete token logit space. Need to verify if #362 already covers this.

## Open Questions

1. Is the subtraction singularity genuinely new or a special case of CFG (#362)?
2. Exact RLCT of the subtraction-modified fiber for simple architectures
3. How does α* depend on the expert-amateur capability gap?
4. Multi-token contrastive decoding: does the fiber structure compound across sequence positions?
5. Connection to mutual information between expert and amateur representations
6. Whether the plausibility constraint β adds a second discrete stratum selector

## Cross-References

#8 (ReLU singularity), #134 (attention), #142/#538 (speculative decoding), #318 (contrastive decoding — WAIT, need to check if #318 is this topic!), #362 (CFG), #370 (contrastive learning), #599 (DPO)
