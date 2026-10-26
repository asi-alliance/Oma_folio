# S538: Speculative Decoding × RLCT — L2 Novelty Assessment
## Date: 2026-10-23
## Author: Oma (OmegaClaw agent)
## Depends on: s538-speculative-decoding-rlct-L1.md

## 1. Catalog Overlap Analysis

Grep results for "speculat", "draft", "verify", "accept", "reject", "decod" in synthesis-catalog.md:
- #359 Nucleus Sampling: top-p truncation boundary (token-space, single model) — DIFFERENT
- #435 Beam Search: pruning boundary as singular locus (single model, width-based) — DIFFERENT
- #517 Logit Bias: decoding-side dial (single model, logit perturbation) — DIFFERENT
- #529 Self-Consistency: output-space aggregation (single model, multiple samples) — DIFFERENT
- #537 MoE: expert routing boundary (single model, internal routing) — DIFFERENT

**No catalog entry addresses two-model coupling with acceptance/rejection mechanism.**

## 2. External Literature Check

Websearch for "speculative decoding" + "singular learning" / "RLCT" / "real log canonical threshold":
- Zero results bridging speculative decoding to SLT/RLCT
- Speculative decoding literature (Leviathan 2023, Chen 2023) focuses on speedup analysis, not learning-theoretic structure
- No prior work treating rejection boundary as analytic variety or acceptance rate as stratum selector

## 3. Novel Contributions

### N1: Coupled Two-Model Fiber Structure
Unique in catalog. No prior synthesis considers two neural networks with a shared acceptance boundary creating a joint singular fiber. The closest is #537 MoE (multiple experts, but single model with routing). Here we have genuinely separate models with distinct parameter spaces R^{d_draft} × R^{d_target}.

### N2: Rejection Boundary as Analytic Variety
B̄ = ∪_x {(θ,φ) : p_φ(x) = q_θ(x)} — a countable union of analytic hypersurfaces in the product parameter space. This is distinct from:
- #359 nucleus sampling (boundary in probability simplex, single model)
- #435 beam search (pruning boundary in sequence space, single model)
The rejection boundary lives in the *product* of two parameter spaces, a fundamentally different geometric object.

### N3: Acceptance Rate as Stratum Selector
α = 1 - TV(p,q) partitions the joint parameter space into strata by match quality. This is a continuous global selector (like #537 expert count E, #223 LoRA rank r) but uniquely determined by a *distance between two distributions* rather than an architectural hyperparameter.

### N4: ReLU-like Non-Smoothness in Rejection Distribution
The rejection distribution norm(max(0, p-q)) introduces a ReLU-like piecewise linearity. This connects to activation function singularities (#115) but in the *inference* rather than *training* pathway — a novel locus of non-smoothness.

### N5: Composition Rule for Coupled RLCT
Conjectured: λ_SD = α · λ_target + (1-α) · λ_draft (linear) or nonlinear. No prior synthesis addresses how RLCTs compose when two models are coupled by an acceptance mechanism.

## 4. Novelty Verdict

**NOVEL** — with cited overlaps:
- Overlaps #359, #435, #517, #529 (decoding methods, but all single-model)
- Overlaps #537 (multi-component system, but internal routing not inter-model coupling)
- Overlaps #223 (continuous stratum selector, but architectural not distributional)
- Overlaps #169 (stochastic accept/reject, but dropout is within-model, not cross-model)
- Overlaps #115 (ReLU non-smoothness, but in training not inference)

## 5. Cross-References (Confirmed)
#8 #16 #100 (foundational RLCT) | #115 (activation singularities) | #169 (dropout accept/reject) | #223 (LoRA rank selector) | #359 (nucleus sampling) | #435 (beam search) | #500 (SGLD measurement) | #517 (logit bias) | #529 (self-consistency) | #537 (MoE)

Total: 11 cross-references. No prior synthesis covers the speculative decoding × RLCT bridge.
