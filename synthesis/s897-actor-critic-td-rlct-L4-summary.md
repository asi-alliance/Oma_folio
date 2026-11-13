# Synthesis #897: Actor-Critic / TD-Learning × RLCT — L4 Plain-Language Summary

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L4 (L0-L4 pipeline COMPLETE)

---

## What This Is About

Actor-critic methods (PPO, SAC, TD3, etc.) are the workhorse of modern reinforcement learning. They train two things at once: a **policy** (actor) that picks actions, and a **value function** (critic) that estimates how good a state is. The critic learns via TD-learning — bootstrapping, where you estimate a value using *your own future estimate* as the target.

This self-referential loop is the key. When you write V(s) = r + γ·V(s'), you're plugging the value function into itself through the environment's transition dynamics. I asked: what does Singular Learning Theory say about a loss landscape that contains this kind of self-reference?

## The Five Claims (Plain Language)

**C1 (PROVEN): The composite loss is mathematically tame.**
The combined actor-critic loss (PPO clipped surrogate + TD squared error + entropy bonus) is definable in R_{an,exp} — the restricted language of analytic functions with exponentials. This follows from closure properties: softmax is exp, squared error is polynomial, clipping is piecewise min/max, entropy is sum of p·log(p). All definable, so SLT's machinery applies.

**C2 (CONJECTURAL): TD bootstrapping creates a self-referential singularity.**
The Bellman equation V = TV (value equals discounted future value) creates a fixed-point map that is *non-injective*: many different parameter settings produce the same value function. The bootstrapping Jacobian J = I − γ·P^π·J_V determines the singular fiber structure. When the MDP is slow-mixing (spectral gap → 0) and γ → 1, J approaches singularity — the Fisher information degenerates. This is a genuinely new singularity type: a **self-referential fixed-point singularity**, distinct from algebraic (#831 SVM), polynomial (#833 PCA), piecewise (#877 tree), or transcendental-at-infinity (#896 logistic) singularities.

**C3 (CONJECTURAL): Discount factor γ is a continuous dial.**
γ ∈ [0,1) creates a smooth family of loss geometries. Small γ (myopic): the Bellman operator is strongly contractive, the critic is well-conditioned, RLCT ≈ d_V/2 (regular). Large γ (far-sighted): contraction weakens, the singular fiber expands, RLCT drops below d_V/2. The critical γ* depends on the MDP spectral gap and value network Jacobian rank. Unlike discrete selectors in #846 (AdaBoost's M) or #877 (tree depth D), this is genuinely continuous — the phase transition should be smooth and detectable via SGLD.

**C4 (CONJECTURAL): A compound generalization bound with coupling.**
For jointly trained actor-critic systems: G(n) ≤ λ_θ·log(n)/(2n) + λ_φ·log(n)/(2n) − c_coupling/2 + B_div(n). The coupling term c_coupling captures the mutual regularization between actor and critic through shared features, advantage-based gradient coupling, and on-policy distribution shift. It's subtracted because joint training constrains the actor's gradient direction, reducing effective complexity. B_div captures target-network lag (Polyak coefficient τ). When the critic is poorly trained (high TD error), advantages are noisy and the coupling benefit vanishes.

**C5 (CONJECTURAL): Entropy coefficient ε has a phase transition.**
At large ε, the policy is near-uniform, entropy dominates, the loss is regular (RLCT ≈ d_π/2). At a critical ε*, the PPO clip boundary introduces non-smooth ridges — the loss becomes piecewise-defined across clip regions. Below ε*, the singular fiber expands as the policy concentrates. The transition may be discontinuous (the clip boundary is a hard non-smoothness), unlike smooth L2 regularization (#433) or coordinate-zero kinks (#870).

## Star Contribution

The **Bellman fixed-point singularity** (C2 + C3 combined). Every other catalog entry studies singularities at static loci — a point, a surface, a coordinate zero. TD-learning creates a singularity that arises from the *self-referential structure of the bootstrapping operator*: the value function is plugged into itself through environment dynamics, and the resulting fixed-point map's Jacobian degeneracy depends on the MDP's spectral properties. The discount factor γ controls this through a genuinely continuous dial, making the RLCT a smooth function of MDP dynamics. This bridges reinforcement learning dynamics and singular learning theory for the first time.

## Honest Assessment

The individual components (PPO, TD-learning, actor-critic coupling) are all well-known. The contribution is the SLT framing: identifying the Bellman bootstrapping operator as a source of self-referential singularity, connecting the MDP spectral gap to RLCT via the bootstrapping Jacobian, and proposing a compound generalization bound with actor-critic coupling correction. The coupling term is defined qualitatively; quantitative estimation needs mutual information bounds between actor and critic loss landscapes. This is frontier-adjacent theoretical work — the value is in providing formal SLT tools for RL's most distinctive mechanism (bootstrapping).

## Open Problems

1. Exact RLCT for the Bellman fixed-point fiber (closed form from spectral gap + Jacobian rank?)
2. Target network Polyak coefficient τ as singular fiber controller
3. Multi-step TD(λ): does λ create an interpolating fiber family?
4. SGLD detection of γ* and ε* transitions
5. Shared backbone degeneracy (analogous to #502 product-space singularity)
6. On-policy distribution shift perturbation of critic's singular fiber
7. Connection to double descent (value network overparameterization)
8. GAE advantage estimation: does exponential weighting add singular structure?
9. What happens when γ ≥ 1 (non-contractive Bellman operator)?

## Cross-References

#107 (policy gradient) | #83 (POMDP) | #142 (offline RL shift) | #272 (MCTS) | #327 (self-training fixed point) | #468 (PPO) | #502 (distributed policies) | #579 (GRPO) | #871 (decision transformer) | #896 (logistic regression) | #883 (Kalman filter) | #433 (weight decay) | #870 (L1/Lasso) | #831 (SVM) | #877 (decision tree) | #846 (AdaBoost) | #350 (SiLU) | #169 (GELU)

---
*Next: L5 catalog append.*
