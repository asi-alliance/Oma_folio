# Synthesis #879: Hidden Markov Model (HMM) × RLCT

## Date: 2026-11-09
## Status: L0 — Exploration & Claims

## Topic
Hidden Markov Models — probabilistic sequence models with discrete latent states following Markov dynamics and emission distributions mapping hidden states to observations. Trained via Baum-Welch (EM for HMMs). Used in speech recognition, bioinformatics, time series modeling.

## Architecture Structure
An HMM is defined by:
1. **Transition matrix** A ∈ R^{K×K}: A_{ij} = P(z_t = j | z_{t-1} = i), row-stochastic
2. **Emission matrix** B ∈ R^{K×M}: B_{ij} = P(x_t = j | z_t = i) (discrete obs) or emission distributions b_j(x) (continuous)
3. **Initial distribution** π ∈ R^K: π_i = P(z_1 = i)
4. **Hidden state sequence** z_1,...,z_T ∈ {1,...,K}
5. **Observation sequence** x_1,...,x_T

The likelihood factorizes: P(x_{1:T}) = Σ_{z_{1:T}} π_{z_1} ∏_{t=2}^{T} A_{z_{t-1},z_t} ∏_{t=1}^{T} B_{z_t,x_t}

## Core SLT Bridge

### Singularity Sources

- **State permutation non-identifiability**: As in #268 (GMM/EM), permuting hidden state labels {1,...,K} → {σ(1),...,σ(K)} leaves the likelihood invariant. The permutation group S_K acts on (A, B, π) simultaneously. This creates a discrete non-identifiability fiber of size |S_K| = K!.

- **Temporal coupling of permutation fiber**: CRITICAL DISTINCTION from #268 (GMM). In a GMM, permuting component labels is a static relabeling. In an HMM, the permutation must be applied CONSISTENTLY across the ENTIRE temporal sequence — the same σ permutes both the transition matrix rows/columns AND the emission distributions. The permutation acts as: (A, B, π) → (σ^T A σ, σ^T B, σ^T π). This couples the permutation fiber to the temporal Markov structure, making the singular locus a FIXED-POINT-CONSTRAINED quotient rather than a free group orbit.

- **Transition matrix singular fibers**:
  - **Absorbing states**: If A_{ii} = 1 (state i absorbs), the transition row degenerates. The fiber V_absorb = {A : ∃i, A_{ii} = 1} is a singular stratum where the Markov chain has rank-deficient dynamics.
  - **Disconnected components**: If the state space partitions into disconnected communicating classes, the transition matrix is block-diagonal (after permutation). V_disconnect = {A : A block-diagonalizable} creates a stratum where the effective state count K_eff < K.
  - **Deterministic transitions**: If A_{ij} ∈ {0,1} (deterministic), the transition loses stochasticity degrees of freedom.

- **Emission collision**: If two states i,j have identical emission distributions (B_i = B_j), the states are observationally indistinguishable. V_emit_collision = {B : ∃i≠j, B_i = B_j} creates a collision stratum analogous to #268 GMM component overlap.

- **K as stratum selector**: The number of hidden states K determines the dimension of the model manifold. Unlike neural network width (continuous stratum selector), K is DISCRETE. The effective singularity λ_HMM depends on K through both the permutation group size (log K!/2) and the transition/emission matrix degeneracy structure. This is analogous to #877 (Decision Tree depth D as discrete selector) but with TEMPORAL structure.

### Key RLCT Decomposition (Conjectural)

λ_HMM = λ_emit · K_eff + λ_trans(A) + λ_perm

where:
- λ_emit = RLCT of emission model (Gaussian mixture component → #268, discrete → #877-like)
- λ_trans(A) = RLCT contribution from transition matrix degeneracy strata
- λ_perm = log(K!)/2 (discrete group contribution, heuristic)

### Phase Transition at K*

As K increases, the HMM capacity grows as O(K^2 + K·M). The generalization transition occurs when K^2 + K·M ~ n (sample complexity matching). Below K*, the model is under-specified (fewer states than modes). Above K*, redundant states create emission collision and absorbing state degeneracies. The SGLD LLC profile should show a kink at K* analogous to neural network width transitions (#480 muP).

## Claims

### C1: Definability [PROVEN]
The HMM likelihood is R_{an,exp}-definable. The transition and emission probabilities are constrained to the simplex (polynomial inequalities: A_{ij} ≥ 0, Σ_j A_{ij} = 1). The likelihood is a sum of products of these probabilities (polynomial). The log-likelihood involves log of sums of products (subanalytic via Łojasiewicz inequality). Continuous emission models (Gaussian) add exp/quadratic terms (in R_{an,exp}). Composition closure guarantees definability.

### C2: Temporal Permutation Fiber [CONJECTURAL]
The permutation non-identifiability fiber in HMMs is structurally distinct from #268 (GMM). The temporal Markov constraint means the permutation σ must be a CONSISTENT relabeling across all time steps. The singular fiber V_perm = {(A,B,π) : ∃σ ∈ S_K, (A,B,π) = (σ^T A σ, σ^T B, σ^T π)}. The RLCT contribution from this fiber is λ_perm = log(K!)/2, but the TEMPORAL COUpling may modify this: the effective permutation group may be smaller if the transition matrix has symmetries (e.g., if A is already symmetric, some permutations are trivially satisfied).

### C3: Transition Stratum Selector [CONJECTURAL]
The transition matrix structure acts as a CONTINUOUS stratum selector within the discrete K-selected model class. Absorbing states, disconnected components, and deterministic transitions each define singular substrata within the K-state model. The RLCT λ_trans(A) is maximized when A has maximal symmetry (e.g., uniform transition A_{ij} = 1/K) and minimized when A is fully mixed with distinct eigenvalues.

### C4: Generalization Bound [CONJECTURAL]
The HMM generalization bound takes the form:
Gen(K, n, T) ≤ λ_HMM · log(n·T) / (2·n·T) + P(K, n, T)

where T is sequence length (effective sample size is n·T observations but only n sequences for transition estimation). The temporal structure creates a TWO-SCALE generalization: emission estimation benefits from n·T observations, but transition estimation is limited by n·(T-1) effective transitions.

### C5: Phase Transition at K* [CONJECTURAL]
The optimal number of hidden states K* satisfies K*^2 + K*·M ~ n·T / log(n·T). At K*, the SGLD LLC profile shows a kink. Below K*, the model underfits (insufficient states to capture temporal dynamics). Above K*, redundant states create emission collision degeneracies and the LLC plateaus. This is distinct from #268 GMM (no temporal structure, K* ~ M only) and #877 Decision Tree (D* ~ log₂(n), no emission model).

## Key Novelty

**Temporal coupling of permutation fiber.** The HMM permutation non-identifiability is not a free S_K orbit (as in #268 GMM) but a TEMPORALLY-COUPLED orbit where the same permutation must act consistently across all time steps. This creates a constrained singular fiber where the effective group may be a SUBGROUP of S_K determined by transition matrix symmetries. This is the first SLT analysis of temporal Markov constraint effects on discrete non-identifiability.

**Transition matrix as continuous stratum selector.** Within a fixed K, the transition matrix structure (absorbing, disconnected, uniform, mixed) selects substrata with different RLCT values. This is a novel mechanism: discrete K provides coarse stratum selection, but continuous transition parameters provide fine-grained substratum structure.

## Open Problems

1. Does the temporal coupling reduce the effective permutation group size compared to S_K?
2. Can the transition matrix RLCT λ_trans(A) be computed explicitly for absorbing/disconnected strata?
3. Is the two-scale generalization bound (emission vs transition) rigorously derivable from the free energy formula?
4. Does Baum-Welch (EM) converge to the most singular point in the HMM fiber, as gradient descent does for neural networks?
5. How does continuous-relaxation SGLD estimate λ_HMM when states are discrete?
6. Do HMMs with Gaussian emissions have HIGHER RLCT than discrete-emission HMMs (due to the additional Gaussian component singularity from #268)?
7. Does the phase transition at K* shift with sequence length T?

## Cross-References

#268 (EM/GMM label switching), #877 (Decision Tree discrete stratum selector), #873 (HMM catalog entry), #434 (MoE routing), #529 (absorbing states analogy), #870 (GRPO discrete actions), #100 (EM singular), #556 (VAE latent structure), #480 (muP width phase transition), #503 (Early Exit depth selector)

---
*Next: L1 formalization (D1-D7 definitions, C1-C5 formal statements).*
