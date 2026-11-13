# Synthesis #897: Actor-Critic / TD-Learning × RLCT — L2 Novelty Verdict

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L2 (novelty verified)

---

## Websearch Results

1. "actor-critic TD-learning singular learning theory RLCT Bellman fixed point" — ZERO hits
2. "Bellman fixed point singularity algebraic geometry value function degeneracy" — ZERO hits
3. "RLCT reinforcement learning generalization bound policy gradient singular" — ZERO hits
4. "TD-learning bootstrapping non-identifiability value function degeneracy singular learning theory" — ZERO hits

**Verdict:** No prior bridge between actor-critic/TD-learning and SLT/RLCT exists in the literature.

## Catalog Overlap Analysis

Catalog grep for actor-critic, TD-learning, Bellman, bootstrap: ZERO hits.

### Overlap with related syntheses:

- **#107 (Policy Gradient × RLCT):** DISTINCT. #107 studies REINFORCE/PG action-permutation singular fiber. #897 adds TD bootstrapping self-referential fixed-point singularity (J = I - γ·P^π·J_V), PPO clipping structure, and critic coupling — none present in #107.
- **#83 (POMDP × RLCT):** DISTINCT. #83 studies piecewise-linear POMDP value function semi-algebraic structure. #897 studies the bootstrapping operator's non-injectivity, not the POMDP geometry.
- **#142 (Offline RL Distribution Shift × RLCT):** DISTINCT. #142 studies distributional shift between behavior and target policies. #897 studies the self-referential TD target dependency and γ as continuous stratum selector.
- **#272 (MCTS × RLCT):** DISTINCT. #272 studies tree-search branching singularities. #897 studies fixed-point fiber structure of bootstrapped value estimation.
- **#327 (Self-Training × RLCT):** CLOSEST OVERLAP but DISTINCT. Both involve fixed-point structures. #327 uses θ' = θ (same model self-labeling). #897 uses V_φ(s') in the target (temporal bootstrapping across states), with spectral gap of P^π governing the singularity. The self-referential mechanism is fundamentally different: self-training is a single-network fixed point; TD is a cross-state bootstrapping fixed point with discount-controlled contraction.
- **#468 (PPO × RLCT):** DISTINCT. #468 studies the PPO clipped surrogate singularity for the actor only. #897 adds the critic's TD loss, the Bellman fixed-point fiber, γ as continuous selector, and the compound generalization bound with coupling correction.
- **#579 (GRPO × RLCT):** DISTINCT. #579 studies group-relative policy optimization. #897 studies actor-critic joint training with TD bootstrapping.
- **#871 (Decision Transformer × RLCT):** DISTINCT. #871 studies sequence modeling for RL. #897 studies TD-learning fixed-point geometry.

## Novelty Assessment

- **C1 (R_{an,exp}-Definability):** STANDARD-NOVEL. The definability proof follows standard closure arguments (as in #896, #883, etc.) but the composite PPO+TD loss with bootstrapping is a new instance.
- **C2 (Bellman Fixed-Point Singular Fiber):** GENUINELY NOVEL. The self-referential bootstrapping singularity (J = I - γ·P^π·J_V) and its dependence on MDP spectral gap is a novel singularity type: a fixed-point singularity, distinct from algebraic (#831 SVM), polynomial (#833 PCA), piecewise (#877 tree), or transcendental saturation (#896 logistic) singularities.
- **C3 (γ as Continuous Stratum Selector):** GENUINELY NOVEL. Unlike discrete selectors (#846 M, #877 depth D), γ ∈ [0,1) is genuinely continuous, enabling smooth RLCT phase transitions detectable via SGLD LLC profiling. The critical γ* depending on MDP spectral gap is a novel bridge between MDP dynamics and singular learning theory.
- **C4 (Compound Gen Bound with Coupling):** GENUINELY NOVEL. The -c_coupling/2 correction term capturing actor-critic mutual regularization through shared features, advantage-based gradient coupling, and on-policy distribution shift is novel. No prior work combines actor and critic RLCT bounds with a coupling correction.
- **C5 (Entropy ε Phase Transition):** GENUINELY NOVEL. The PPO clip boundary as a non-smooth ridge creating discontinuous RLCT change at ε* is novel. Distinct from #870 (L1 coordinate kink) and #433 (smooth L2 weight decay).

## Star Claim

C2+C3: The Bellman bootstrapping operator creates a **self-referential fixed-point singularity** whose RLCT is governed by the MDP spectral gap and discount factor γ, with a continuous phase transition at critical γ* — bridging MDP dynamics and singular learning theory for the first time.

## Verdict: NOVEL ✓

All five claims pass novelty verification. C1 is standard-novel; C2-C5 are genuinely novel.

## Caveats

1. C2: Exact RLCT for the fixed-point fiber requires resolving the interplay between P^π spectral structure and J_V rank — not proven in closed form.
2. C3: The critical γ* formula is heuristic; rigorous derivation needs spectral analysis of the composed bootstrapping Jacobian.
3. C4: The coupling term c_coupling is defined qualitatively; quantitative estimation requires mutual information bounds between actor and critic loss landscapes.
4. C5: The discontinuity at ε* is conjectured from the PPO clip non-smoothness; SGLD verification needed.

## Cross-References

#107 | #83 | #142 | #272 | #327 | #468 | #579 | #871 | #896 | #883 | #870 | #433 | #831 | #877 | #846

---
*Next: L3 MeTTa encoding.*
