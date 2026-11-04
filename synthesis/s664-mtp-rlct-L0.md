# Synthesis #664: Multi-Token Prediction (MTP) × RLCT
## Date: 2026-10-28

## Candidate Selection
- Topic: Multi-Token Prediction (MTP) × Singular Learning Theory (RLCT)
- Catalog check: ZERO hits for MTP/multi-token in synthesis-catalog.md
- Websearch: No prior work bridges MTP with SLT/RLCT
- Distinct from #538 Speculative Decoding × RLCT (inference-time verification vs training-time auxiliary objective)
- Distinct from #468 PPO × RLCT, #599 DPO × RLCT

## Background

### Multi-Token Prediction (MTP)
MTP trains LLMs to predict multiple future tokens simultaneously at each position, using D auxiliary prediction heads arranged in a causal chain. At each position t, the model predicts tokens y_{t+1}, y_{t+2}, ..., y_{t+D} in addition to the standard next-token y_{t+1}.

DeepSeek V3 formalization: Each depth-d head (d=1..D) takes the hidden state h_t and the previous prediction embedding e_{t+d-1} to predict token y_{t+d}. The loss is:

L_MTP = (1/D) Σ_{d=1}^{D} L_d(θ)

where L_d is the cross-entropy loss for the d-th prediction head. The total training loss combines standard next-token loss with MTP auxiliary loss:

L_total = L_next(θ) + α · L_MTP(θ)

Key structural features:
1. Causal chain: each head d depends on the prediction of head d-1 (sequential, not independent)
2. Shared backbone: all heads share the transformer backbone parameters θ_backbone
3. Depth-specific parameters: each head has its own parameters θ_d
4. Full parameter set: Θ = (θ_backbone, θ_1, ..., θ_D)

### RLCT Bridge
The MTP loss landscape has novel singular structure:

(a) **Multi-scale loss composition**: L_MTP is an arithmetic mean of D depth-specific losses. Each L_d has its own zero-loss set V_0^{(d)} ⊂ Θ. The combined zero-loss set is V_0^{MTP} = ∩_{d=1}^{D} V_0^{(d)} — an intersection of D varieties.

(b) **Causal chain singularity**: The sequential dependency (head d depends on head d-1) creates a composition map Φ_d: Θ × Ŷ_{<d} → Ŷ_d. When intermediate predictions are wrong, the downstream heads operate on degenerate inputs, creating a cascade of singular fibers.

(c) **Depth as stratum selector**: The number of MTP heads D acts as a discrete stratum selector (analogous to #663 device count D, but for prediction depth rather than parallelism). Each D defines a different loss landscape topology.

(d) **Auxiliary weight α as continuous stratum selector**: The mixing weight α between L_next and L_MTP acts as a continuous interpolation parameter, analogous to #433 weight decay λ, #362 CFG guidance scale.

## Claims

**C1 (PROVABLE): L_total(θ) = L_next(θ) + α · (1/D) Σ L_d(θ) is R_an,exp-definable.**
Proof: Cross-entropy loss is R_an,exp-definable (softmax = exp/log composition). Finite arithmetic mean of definable functions is definable. Linear combination with definable L_next is definable. Composition with causal chain embedding (polynomial/linear) preserves definability.

**C2 (CONJECTURAL): The combined zero-loss set V_0^{MTP} = ∩ V_0^{(d)} has RLCT λ_MTP that depends on D.**
The intersection of D varieties creates a more constrained zero-loss set. Intuition: intersection of smooth varieties is generically smooth (codimension adds), but when varieties are singular or non-transverse, the intersection acquires worse singularities. Conjecture: λ_MTP(D) ≤ λ_next (auxiliary heads regularize the backbone by constraining it to satisfy D simultaneous prediction conditions).

**C3 (CONJECTURAL): Causal chain creates cascade singular fibers with depth-dependent RLCT.**
The composition map Φ_d = head_d ∘ embed ∘ head_{d-1} creates a cascade. When head_{d-1} produces a wrong prediction, the input to head_d is off-manifold, creating a singular fiber in the d-th loss component. The RLCT of the cascade λ_cascade(D) grows with depth d due to accumulated composition complexity.

**C4 (CONJECTURAL): Depth D is a discrete stratum selector with λ_MTP(D) initially decreasing then flat.**
Adding MTP heads constrains the backbone more (regularization), decreasing λ. But beyond some D*, the causal chain complexity dominates and λ may stabilize or increase. Conjecture: λ_MTP(D) is L-shaped or U-shaped with optimal D* ≈ 2-3 (matching empirical MTP sweet spots).

**C5 (CONJECTURAL): Auxiliary weight α as continuous stratum selector with phase transition at α*.**
At α=0, MTP heads are inactive (λ = λ_next). At α→∞, MTP dominates (λ → λ_MTP). Between, there is a phase transition α* where the loss landscape transitions from next-token-dominated to MTP-dominated singularity structure. λ_eff(α) = λ_next + g(α)·(λ_MTP - λ_next) for some transition function g.

## Open Problems (8)
1. Exact RLCT of intersection of D cross-entropy zero-loss varieties
2. Whether V_0^{(d)} are generically transverse (codimension adds) or have special structure
3. Cascade fiber RLCT: does composition with wrong predictions create worse singularities?
4. Optimal D* formal derivation from RLCT minimization
5. Interaction between α and D: joint stratum (α, D) selection
6. Whether MTP regularization (λ_MTP ≤ λ_next) can be proven rigorously
7. Effect of shared backbone on RLCT vs independent heads
8. Comparison with #334 self-distillation × RLCT (MTP as implicit self-distillation?)

## Cross-References (14)
#334 Self-Distillation, #538 Speculative Decoding, #663 Distributed Training (D as discrete selector), #433 Weight Decay (α as continuous selector), #362 CFG Guidance, #8 RLCT Foundation, #16 Gen Bound, #100 SGD, #226 Beam Search, #359 Nucleus Sampling, #468 PPO, #599 DPO, #302 Linear Attention, #292 Flash Attention

## Next Steps
- L1: Formal definitions D1-D7, proof sketches for C1, conjecture elaboration C2-C5
- L2: Novelty verification via websearch
- L3: MeTTa encoding
- L4: Summary
- L5: Catalog append