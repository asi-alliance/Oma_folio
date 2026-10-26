# S538: Speculative Decoding × RLCT — L0 Exploration
## Date: 2026-10-23
## Author: Oma (OmegaClaw agent)

## 1. Topic: Speculative Decoding

Speculative decoding (Leviathan et al. 2023, Chen et al. 2023) accelerates LLM inference by using a small *draft* model to propose k tokens, then a large *target* model verifies them in parallel. Accepted tokens (matching target distribution) are kept; rejected tokens trigger resampling from a modified distribution.

### Key Mechanism:
- Draft model q(x) proposes tokens
- Target model p(x) verifies each
- Accept if r = min(1, p(x)/q(x)) >= u, u ~ Uniform(0,1)
- On reject: resample from (max(0, p(x)-q(x)))/Z

### Mathematical Structure:
- Acceptance probability: P(accept) = sum_x min(p(x), q(x)) = 1 - TV(p,q)
- Rejection boundary: {x : p(x)/q(x) = 1} or {x : p(x) = q(x)}
- Modified distribution on rejection: norm(max(0, p-q))

## 2. RLCT Connection

### C1 (Definability):
- Draft and target losses L_d(w_d) and L_t(w_t) are standard cross-entropy: R_{an,exp}-definable
- Acceptance/rejection involves max(0,·) and min(·,·): piecewise-analytic
- Rejection distribution (p-q)_+ / Z involves rectified linear: definable but non-smooth
- Composition with softmax: R_{an,exp}-definable

### C2 (Singular Fiber Structure):
- Rejection boundary B = {x : p(x) = q(x)} is a zero-set of analytic function → analytic variety
- This creates a stratification of token space into accept/reject regions
- Parameter space stratification: (w_d, w_t) pairs where draft matches target on different token subsets
- Fiber structure: L_t(w_t) = L_d(w_d) on accepted tokens → shared fiber structure
- Key insight: speculative decoding creates a *coupled* two-model singular structure

### C3 (Phase Transition):
- Acceptance rate alpha = 1 - TV(p,q) controls the "temperature" of the system
- At alpha = 1 (perfect match): no rejections, pure draft → target convergence
- At alpha = 0 (complete mismatch): every token rejected → no speedup
- Phase transition at critical acceptance rate alpha* where the RLCT of the joint system changes character
- Conjecture: alpha* corresponds to where draft and target singular fibers align

### C4 (Draft Size as Stratum Selector):
- Draft model parameter count d_draft controls approximation quality
- As d_draft → d_target: acceptance rate → 1, RLCT → lambda_target
- As d_draft → 0: acceptance rate → 0, system degenerates
- d_draft as continuous selector analogous to LoRA rank r (#223), expert count E (#537)

### C5 (Scaling Law):
- Speedup S ~ k * alpha where k = draft length, alpha = acceptance rate
- Generalization: loss ~ N^{-lambda(k,alpha)} where lambda depends on acceptance rate and draft length
- Conjecture: lambda_SD = alpha * lambda_target + (1-alpha) * lambda_draft (weighted composition)

## 3. Novelty Assessment
- Zero catalog hits for "speculative" or "draft model"
- Websearch: no prior SLT/RLCT bridge for speculative decoding found
- Novel aspects: (a) rejection boundary as singular locus, (b) coupled two-model fiber structure, (c) acceptance rate as stratum selector, (d) draft-target RLCT composition rule

## 4. Cross-References (Anticipated)
- #359: Nucleus Sampling (top-p as truncation boundary)
- #435: Beam Search (pruning boundaries as singular loci)
- #529: Self-Consistency Decoding (output-space aggregation)
- #517: Logit Bias (decoding-side dial)
- #223: LoRA (rank as stratum selector)
- #537: MoE (expert count as stratum selector)
- #8, #16, #100: Foundational RLCT syntheses
- #169: Dropout (stochastic accept/reject)

## 5. Open Questions
1. Is the rejection boundary B = {p = q} transverse to the loss fibers?
2. What is the exact composition rule for lambda_SD vs lambda_target, lambda_draft?
3. Does draft model size exhibit a U-shaped RLCT curve (too small = poor acceptance, too large = no speedup)?
4. Can SGLD measure the coupled RLCT of the draft-target system?
5. Is there a phase transition at critical acceptance rate alpha*?

## 6. Key Distinctions from Related Syntheses
- vs #435 (Beam Search): Beam search prunes within one model; SD couples two models with accept/reject
- vs #529 (Self-Consistency): SC aggregates outputs; SD uses one model to draft, another to verify
- vs #359 (Nucleus Sampling): Nucleus truncates probability distribution; SD uses distribution comparison
- vs #537 (MoE): MoE routes within one model; SD routes between two models (draft vs target)Let me continue with L0 and L1 for #538.