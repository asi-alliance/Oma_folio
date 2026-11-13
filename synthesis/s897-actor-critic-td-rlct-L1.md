# Synthesis #897: Actor-Critic / TD-Learning × RLCT — L1 Formalization

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L1 (formal definitions, pre-proof)

---

## Definitions

### D1: Parameter Space

The actor-critic parameter space is a product space:

θ = (θ_π, φ_V) ∈ Θ = R^{d_π} × R^{d_V} = R^{d_π + d_V}

where θ_π are policy network parameters (logits) and φ_V are value network parameters. The policy and value networks may share early layers (parameter coupling), creating a submersion map m: Θ → Θ_shared ⊂ R^{d_shared}.

**Policy:** π_θ(a|s) = softmax(θ_π · f_θ(s))_a for shared-feature f_θ. For PPO, the clipped surrogate uses ratio r_t(θ) = π_θ(a_t|s_t)/π_θ_old(a_t|s_t).

**Value:** V_φ(s) = φ_V · g_φ(s), linear readout from value features g_φ.

**Effective dimension:** d_eff = d_π + d_V - d_shared (if shared layers). If fully separate, d_eff = d_π + d_V.

### D2: Composite Actor-Critic Loss

The TD(0) critic loss for a transition (s, a, r, s'):

L_TD(φ) = (1/N) Σ_t [r_t + γ·V_φ(s'_t) - V_φ(s_t)]²

The actor loss (PPO clipped surrogate):

L_actor(θ) = -(1/N) Σ_t [min(r_t(θ)·Â_t, clip(r_t(θ), 1-ρ, 1+ρ)·Â_t)] - ε·H[π_θ(·|s_t)]

where Â_t are advantage estimates (GAE or simple TD error), ρ is the PPO clip range, ε is the entropy coefficient, H is the Shannon entropy.

**Composite loss:**

L_{θ,φ} = L_actor(θ) + β·L_TD(φ)

where β balances the two losses. The TD target r + γ·V_φ(s') is itself a function of φ — this self-referential dependency is the key singularity source.

**KL divergence proxy:** K(θ,φ) = L(θ,φ) - L(θ*,φ*) where (θ*,φ*) is the global minimizer.

**Fisher information matrix:** Block structure:

I(θ,φ) = [[I_θθ, I_θφ], [I_φθ, I_φφ]]

where I_θφ captures actor-critic coupling. For decoupled architectures, I_θφ = 0 and the Fisher is block-diagonal.

### D3: R_{an,exp}-Definability (C1)

**Claim:** The composite actor-critic loss L_{θ,φ} is R_{an,exp}-definable.

**Proof:**

1. The TD loss L_TD(φ) = (1/N) Σ_t [r_t + γ·V_φ(s'_t) - V_φ(s_t)]² is a finite sum of squared affine functions of φ (assuming linear value readout V_φ(s) = φ·g(s)). Squaring is polynomial (R_an-definable). Sum is finite. γ is a constant. Definable.

2. For nonlinear value networks V_φ(s) = σ(W·s + b), the composition σ∘(affine) is definable (sigmoid/ReLU/GELU all R_{an,exp}-definable per #169, #350). Squared difference of definable functions is definable. Finite sum preserves definability.

3. The PPO actor loss involves: softmax π_θ(a|s) = exp(θ·f(s)) / Σ_a' exp(θ·f(s))_a' — definable (quotient of exp-definable functions, denominator strictly positive). The ratio r_t(θ) = π_θ/π_θ_old is a quotient of definable functions (π_θ_old is a constant). The min/clip operations are piecewise-definable (min of two definable functions is definable by R_{an,exp} closure under min/max). The advantage Â_t is a precomputed constant for the current batch.

4. Shannon entropy H[π_θ] = -Σ_a π_θ(a|s) log π_θ(a|s) involves log of a definable function (π_θ > 0 by softmax), which is R_{an,exp}-definable by closure under restricted log.

5. The composite loss L = L_actor + β·L_TD is a sum of definable functions. QED.

**Note:** If GAE (Generalized Advantage Estimation) is used for Â_t, the advantage involves a discounted sum of TD errors, each depending on φ — but these are precomputed per-batch and treated as constants during the loss evaluation, preserving definability. The self-referential dependency enters through the optimization trajectory (target networks), not the per-step loss formula.

### D4: Bellman Fixed-Point Singular Fiber (C2)

**Definition:** The Bellman equation V*(s) = E[r + γ·V*(s')] defines a fixed point of the Bellman operator T: V → TV. When V is parameterized as V_φ, the fixed-point condition becomes:

V_φ(s) = r + γ·V_φ(s') for all (s,r,s') in the MDP support

This defines a constraint surface in parameter space:

F_fixed = {φ ∈ R^{d_V} : V_φ(s) = r + γ·V_φ(s') ∀ (s,r,s') ∈ supp(P)}

**Non-injectivity:** The map φ → V_φ is generally non-injective (many parameter configurations yield the same value function on visited states). The bootstrapping target r + γ·V_φ(s') couples value estimates across states, creating a self-referential dependency: the loss L_TD(φ) depends on φ both through V_φ(s) and through V_φ(s').

**Singular fiber structure:** The fixed-point fiber V_fixed = {φ : K_TD(φ) = 0} (where K_TD = L_TD - L_TD*) is the set of parameters achieving zero TD error. For an MDP with n visited states and d_V-dimensional φ:

- If d_V > n: the fiber is (d_V - n)-dimensional (underdetermined — many solutions). The RLCT is determined by the codimension n and the multiplicity of the fixed-point map.
- If d_V = n: the fiber is 0-dimensional (potentially unique, but the Jacobian of the bootstrapping map may still be singular).
- If d_V < n: the fiber is empty for generic MDPs (no exact solution), but the near-minimizer set forms a thin region.

**Self-referential degeneracy:** The bootstrapping operator B: φ → (s ↦ r + γ·V_φ(s')) creates a composition V_φ ∘ B(φ). The Jacobian of this composition has the structure:

J = I - γ·P^π·J_V

where P^π is the state-transition matrix under policy π, and J_V = ∂V_φ/∂φ. When γ·P^π has eigenvalues near 1 (slow-mixing MDP), J becomes near-singular, creating a degenerate Fisher information matrix. The RLCT is governed by the spectral gap of P^π and the rank of J_V.

**Distinction from #327 (self-training):** #327 uses θ' = θ (same network updates its own target). TD updates φ' = φ + α·δ (target shifts with policy). The target network momentum τ (Polyak averaging) controls the lag between current and target parameters, adding a continuous parameter to the singular fiber.

**Distinction from #83 (POMDP):** #83 studies the POMDP value function semi-algebraic singularity (piecewise-linear structure). TD bootstrapping singularity is about the non-injective bootstrapping map, not the POMDP structure.

**Gap:** Exact RLCT for the fixed-point fiber depends on: (a) the MDP transition graph structure (branching factor), (b) the contraction rate γ, (c) the value network architecture (rank of J_V).

### D5: Discount Factor γ as Stratum Selector (C3)

The discount factor γ ∈ [0,1) selects between singular fiber regimes:

**γ → 0 (myopic):** V_φ(s) → E[r|s] — the value function collapses to immediate reward. The bootstrapping term γ·V_φ(s') → 0, breaking the self-referential dependency. The loss becomes L_TD(φ) = (1/N)Σ(r_t - V_φ(s_t))² — a standard regression. The singular fiber is a regular point (assuming d_V ≥ n). RLCT = d_V/2.

**γ → 1 (far-sighted):** The bootstrapping chain is maximally long. The fixed-point fiber V_fixed involves deep coupling across the entire state space. The Jacobian J = I - γ·P^π·J_V approaches singularity (eigenvalues of γ·P^π approach 1 for slow-mixing MDPs). The fiber dimension expands. RLCT < d_V/2.

**Critical γ*:** The transition point where the spectral gap of γ·P^π falls below the rank threshold of J_V. For a Markov chain with spectral gap Δ (second eigenvalue λ_2 of P^π):

γ* = 1/|λ_2|

When γ > γ* (if λ_2 > 0) or equivalently when γ·|λ_2| > 1 (wait, that can't happen for γ < 1 and stochastic P^π — the largest eigenvalue of P^π is 1). Actually the relevant condition is:

The Bellman operator T is a contraction with modulus γ. The Jacobian J = I - γ·P^π·J_V has det(J) → 0 when γ·|λ_i(P^π)|·|σ_i(J_V)| → 1 for some eigenvalue/eigenvector pair. The critical γ* depends on the interplay between the MDP transition spectrum and the value network Jacobian spectrum.

**Continuous selector:** Unlike #846 (discrete M) or #877 (discrete depth D), γ is a genuinely continuous parameter. This enables smooth phase transitions in the RLCT as γ varies, detectable via SGLD.

### D6: Compound Generalization Bound (C4)

For jointly trained actor-critic systems, the generalization bound involves both policy and value complexity, plus a coupling term:

G(n) ≤ λ_θ·log(n)/(2n) + λ_φ·log(n)/(2n) - c_coupling/2 + B_div(n)

where:
- λ_θ = RLCT of the actor loss fiber
- λ_φ = RLCT of the critic loss fiber
- c_coupling = coupling complexity from shared parameters and target-network dependence

**Coupling term:** c_coupling measures the mutual information between the actor and critic loss landscapes induced by:
1. Shared feature layers (if any)
2. The advantage estimate Â_t = r + γ·V_φ(s') - V_φ(s) which depends on φ but is used in the actor gradient
3. The on-policy distribution shift (policy updates change the data distribution, affecting the critic)

**Negative coupling:** The coupling term is subtracted because joint training provides regularization: the critic constrains the actor's gradient direction (through advantages), reducing effective complexity. However, when the critic is poorly trained (high TD error), the advantages are noisy, and the coupling benefit vanishes.

**Comparison to decoupled bounds:** For separately trained actor and critic, the bound would be G(n) ≤ λ_θ·log(n)/(2n) + λ_φ·log(n)/(2n) with no coupling correction. The joint training benefit is the -c_coupling/2 term.

**Divergence-aware term:** B_div(n) accounts for the bootstrapping divergence — when the TD target network diverges (parameter lag too large), the effective sample size decreases. B_div ~ τ^{-1}·log(n)/√n where τ is the target network Polyak coefficient.

### D7: Entropy Coefficient Phase Transition (C5)

The entropy coefficient ε in the actor loss L_actor = ... - ε·H[π_θ] controls exploration. As ε varies:

**Large ε (high entropy):** The policy is near-uniform. The actor loss is dominated by the entropy regularizer, which is strongly concave (entropy is concave in policy). The Fisher information is well-conditioned. The singular fiber is a regular point. RLCT ≈ d_π/2.

**Small ε (low entropy):** The policy concentrates on few actions. The entropy regularizer vanishes, and the PPO clipped surrogate has kinks (from the clip operation) and saturation (from softmax). The singular fiber may expand. RLCT may decrease below d_π/2.

**Critical ε*:** The transition where the entropy regularizer is no longer sufficient to regularize the policy gradient. Below ε*, the PPO clipping creates piecewise-defined loss regions whose boundaries are singular. The transition may be discontinuous (the clip boundary introduces a non-smooth ridge).

**SGLD detection:** The LLC profile as a function of ε should show:
- Plateau at d_π/2 for large ε
- Possible discontinuous drop at ε* (clip boundary onset)
- Gradual decrease for small ε

This is distinguishable from:
- #870 (L1/Lasso: coordinate-zero kink, not entropy-driven)
- #433 (weight decay: smooth L2, no piecewise structure)
- #502 (distributed policies: discrete action space, not continuous entropy)

## Claims

### C1 (PROVEN): R_{an,exp}-Definability
See D3. The composite PPO + TD(0) loss is definable by closure properties of R_{an,exp} under composition, finite sums, quotients (nonzero denominator), min/max (piecewise), and restricted log.

### C2 (CONJECTURAL): Bellman Fixed-Point Self-Referential Singular Fiber
The TD bootstrapping creates a self-referential dependency (V_φ appears in both prediction and target), making the loss map non-injective. The singular fiber V_fixed has dimension governed by the rank of the bootstrapping Jacobian J = I - γ·P^π·J_V. When the MDP is slow-mixing (spectral gap → 0) and γ → 1, J approaches singularity, creating a transcendental singularity distinct from algebraic (#831 SVM), polynomial (#833 PCA), or piecewise (#877 tree) singularities. This is a self-referential (fixed-point) singularity.

### C3 (CONJECTURAL): Discount γ as Continuous Stratum Selector
γ ∈ [0,1) creates a genuinely continuous family of strata {V_γ}. The transition from regular (γ small, myopic) to singular (γ → 1, deep coupling) is smooth in γ. The critical γ* depends on the MDP spectral gap and value network Jacobian rank. This enables a continuous LLC profile, unlike discrete selectors in #846 (M) or #877 (depth D).

### C4 (CONJECTURAL): Compound Generalization Bound with Coupling Correction
Joint actor-critic training yields a generalization bound G(n) ≤ λ_θ·log(n)/(2n) + λ_φ·log(n)/(2n) - c_coupling/2 + B_div(n). The coupling term c_coupling (from shared features, advantage-based gradient coupling, and on-policy distribution shift) provides a regularization benefit. The divergence-aware term B_div captures target-network lag.

### C5 (CONJECTURAL): Entropy Coefficient ε Phase Transition
The entropy coefficient ε controls a phase transition in the actor loss landscape. At large ε, the loss is regular (entropy-dominated). At ε*, the PPO clip boundary introduces non-smooth ridges, potentially causing a discontinuous RLCT change. Below ε*, the singular fiber expands as the policy concentrates.

## Open Problems

1. Exact RLCT for the Bellman fixed-point fiber: does it depend on the MDP spectral gap and value network rank in a closed form?
2. Target network Polyak coefficient τ: how does it control the singular fiber dimension (τ → 0: frozen target, no self-reference; τ → 1: immediate update, maximal self-reference)?
3. Multi-step TD(λ): does the λ-return create a family of fibers interpolating between TD(0) (λ=0) and Monte Carlo (λ=1)?
4. SGLD detection: can the γ* transition and ε* transition be detected via LLC measurements?
5. Coupled actor-critic degeneracy from shared backbone (analogous to #502 product-space singularity).
6. On-policy distribution shift: how does the policy update perturbation affect the critic's singular fiber?
7. Connection to double descent: does the interpolation threshold in the value network correspond to d_V = n (overparameterization)?
8. GAE advantage estimation: does the exponential weighting create additional singular structure?
9. What happens when γ ≥ 1 (non-contractive Bellman operator)?

## Cross-References

#327 (self-training fixed-point) | #107 (policy gradient RLCT) | #83 (POMDP value semi-algebraic) | #142 (offline RL distribution shift) | #272 (MCTS tree search) | #136 (RLHF) | #468 (PPO) | #502 (distributed policies) | #16 (basic network) | #185 (product space) | #567 (DPO) | #579 (GRPO) | #871 (decision transformer) | #896 (logistic regression) | #391 (repetition penalty) | #888 (VQ-VAE) | #883 (Kalman filter) | #433 (weight decay) | #870 (L1/Lasso) | #831 (SVM) | #350 (SiLU) | #169 (GELU)

---
*Next: L2 novelty verification.*
