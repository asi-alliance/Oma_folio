# Synthesis #567: DPO (Direct Preference Optimization) × RLCT
**Date:** 2026-10-23
**Status:** L0 Exploration
**Novelty:** Zero catalog hits, zero SLT/RLCT literature hits

## Topic
Direct Preference Optimization (DPO; Rafailov et al. 2023) replaces RLHF's reward model + PPO pipeline with a direct classification loss on preference pairs. The policy is reparameterized as a log-ratio against a frozen reference model, and the Bradley-Terry pairwise preference model yields a closed-form loss.

## Mathematical Setup
- Policy: π_θ(y|x), Reference: π_ref(y|x) (frozen)
- DPO Loss: L_DPO(θ) = -E_{(x,yw,yl)}[log σ(β·(log π_θ(yw|x)/π_ref(yw|x) - log π_θ(yl|x)/π_ref(yl|x)))]
- β > 0: temperature parameter controlling preference sharpness
- σ(z) = 1/(1+e^{-z}): sigmoid function
- Log-ratio: r_θ(y,x) = log π_θ(y|x) - log π_ref(y|x)

## Key RLCT Bridge
The DPO loss introduces a novel singular structure via:
1. **Log-ratio reparameterization**: The loss operates in log-ratio space r_θ(y,x), not raw log-probability space. The map θ → r_θ is a composition of softmax (exp-definable) and log (analytic), placing it in R_an,exp.
2. **Fixed-point singularity**: Where r_θ(yw,x) = r_θ(yl,x) (equal log-ratio for preferred and rejected), the sigmoid argument vanishes and the loss is at its maximum (σ(0)=1/2, -log(1/2)=log 2). This creates a fixed-point fiber where all parameter perturbations preserving the margin equality are in the null space.
3. **Bradley-Terry fiber**: The pairwise structure creates asymmetric fibers — the preference margin Δr = r_θ(yw,x) - r_θ(yl,x) defines a one-dimensional projection of the full parameter space. The fiber {θ : Δr(θ) = c} is a level set whose geometry depends on the reference model.
4. **β as stratum selector**: β scales the sigmoid argument, controlling the sharpness of the preference boundary. Small β → smooth landscape (high RLCT, many near-optimal params). Large β → sharp landscape (low RLCT, concentrated optimum). Analogous to #362 CFG guidance scale.

## Claims

### C1 (PROVEN): R_an,exp Definability
The DPO loss L_DPO(θ) is definable in R_an,exp.
- σ(z) = 1/(1+e^{-z}) is exp-definable (quotient of 1 and 1+exp(-z)).
- log σ(z) = -log(1+e^{-z}) is composition of log (analytic) with exp-definable function → in R_an,exp.
- log π_θ(y|x) = log(softmax(θ)_y) = θ_y - log Σ_j exp(θ_j), which is in R_an,exp.
- r_θ = log π_θ - log π_ref is difference of R_an,exp functions → R_an,exp.
- β·(Δr) is polynomial (scalar mult) in R_an,exp → R_an,exp.
- L_DPO = -E[log σ(β·Δr)] is finite sum of R_an,exp functions → R_an,exp. ∎

### C2 (CONJECTURAL): Fixed-Point Singular Fiber
The set V_fixed = {θ : r_θ(yw,x) = r_θ(yl,x) ∀ (x,yw,yl) in dataset} is a singular fiber of the DPO loss landscape. At V_fixed, the loss is constant (L = log 2 per pair), and all parameter perturbations preserving the margin equality form a degenerate fiber. The RLCT λ_DPO at V_fixed is conjectured to be higher than at the global minimum (where Δr → +∞), because V_fixed is a higher-dimensional manifold (many θ satisfy equal log-ratios) while the global minimum is a point (or lower-dimensional set) where all margins are maximized. The reference model π_ref determines the geometry of V_fixed — if π_ref is near-uniform, V_fixed is large (high λ); if π_ref is peaked, V_fixed is constrained.

### C3 (CONJECTURAL): β as Stratum Selector
β acts as a stratum selector analogous to #362 CFG guidance scale w:
- β → 0: L_DPO → log 2 (constant), all θ are equivalent → maximum RLCT (d/2, full parameter space is singular)
- β → ∞: L_DPO → 0·[Δr > 0] + ∞·[Δr ≤ 0] (hard margin), only θ with all correct preferences survive → minimum RLCT
- Intermediate β: stratum transition where the effective singular set shrinks
- λ(β) is conjectured monotonically decreasing on average, but non-monotone near β* where overfitting to preference pairs creates new singular structure (analogous to #362 U-shaped λ(w))
- Prediction: U-shaped λ(β) with optimal β* balancing preference learning and generalization

### C4 (CONJECTURAL): Generalization Bound
The RLCT-based generalization bound for DPO takes the form:
G_DPO ~ λ(β)/(2n) + U(β)/√n
where λ(β) is the RLCT at the learned parameter, n is the number of preference pairs, and U(β) is a bounded functional depending on the preference margin distribution. Distinct from PPO (#468) where the bound involves the clipped surrogate's branch-switch: DPO has no clipping, so no branch-switch singularity — instead the singularity is in the log-ratio fixed-point fiber. Distinct from RLHF/Constitutional AI (#185): DPO has no explicit reward model, so the singular structure lives entirely in policy parameter space (no product-space reward+policy fiber).

### C5 (CONJECTURAL): Phase Transition at β*
There exists a critical β* where the DPO training dynamics undergo a phase transition:
- β < β*: insufficient preference signal, model stays near reference (high RLCT, poor preference learning)
- β > β*: overfitting to preference pairs, model collapses to degenerate solutions (mode collapse, low RLCT but poor generalization)
- β ≈ β*: optimal balance, RLCT phase transition where the system escapes the fixed-point fiber V_fixed and concentrates on the preference-aware minimum
- Empirical signature: SGLD LLC estimation should show λ(β) transition near β*, with U-shaped curve
- Connection to length bias / reward hacking: at large β, the model exploits spurious features (length, formatting) to maximize margin — this corresponds to a lower-λ stratum that is the "wrong" singular fiber (cf #160 C4 length bias)

## Cross-References
- #362: CFG guidance scale w as stratum selector (β ↔ w analogy)
- #468: PPO clipped surrogate branch-switch singularity (DPO has no clip, different mechanism)
- #185: Constitutional AI / RLHF (DPO is the closed-form alternative)
- #167: Diffusion score matching (score function connection to log-ratio gradient)
- #540: InfoNCE contrastive loss (pairwise comparison structure)
- #223: LoRA rank constraint singularity (parameter space restriction)
- #234: Temperature scaling (β as temperature)
- #538: Speculative decoding (rejection boundary as singularity)
- #370: Contrastive learning (preference pairs as contrastive examples)

## Open Problems
1. **Fiber dimension of V_fixed**: What is the codimension of the fixed-point fiber V_fixed in parameter space? Depends on reference model architecture and dataset size.
2. **β* scaling**: Does β* scale with n (number of preference pairs) as n^{-1/(λ+1)}? If so, this mirrors #362's w* scaling.
3. **Reference model dependence**: How does the RLCT of DPO depend on the reference model π_ref? Is a stronger reference (lower perplexity) always better, or does it create more complex singular geometry?
4. **Preference margin distribution**: Does the distribution of preference margins (easy vs hard pairs) affect λ(β)? Conjecture: hard pairs (small true margin) create additional near-singular strata.
5. **DPO vs PPO RLCT comparison**: Is λ_DPO < λ_PPO always (DPO has simpler loss, no clipping)? Or does the log-ratio fixed-point create higher RLCT than PPO's branch-switch?
6. **Length bias as wrong stratum**: Can reward hacking (length, formatting) be formalized as the optimizer settling on a lower-λ but wrong singular stratum? Testable via SGLD on length-matched vs length-mismatched pairs.
7. **Multi-preference DPO**: For K-objective DPO (e.g., helpfulness + harmlessness), does the singular fiber decompose as intersection of K fixed-point fibers, and does the RLCT satisfy λ_K ≤ min(λ_1, ..., λ_K)?

## Key Novelty vs Prior Syntheses
- vs #468 (PPO): DPO has no clipped surrogate → no branch-switch singularity. Instead, log-ratio fixed-point fiber is the novel mechanism.
- vs #185 (Constitutional AI): DPO has no explicit reward model → no product-space reward+policy fiber. Singularity lives entirely in policy space.
- vs #362 (CFG): β ↔ w analogy is structural (both are sigmoid/logit temperature scales), but DPO's fiber is in parameter space while CFG's is in score space.
- vs #540 (InfoNCE): Both use pairwise comparison, but DPO's Bradley-Terry is 1-vs-1 while InfoNCE is 1-vs-K. Fiber structure differs: DPO has per-pair fixed-point, InfoNCE has K-ary partition.
