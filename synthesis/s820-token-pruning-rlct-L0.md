#820: Token Pruning × RLCT — L0 Exploration
## Date: 2026-10-29
## Status: CANDIDATE SELECTED, L0 DRAFT

### 1. Topic Definition
Token Pruning permanently removes low-importance tokens from the input sequence before or during processing, reducing effective sequence length from n to n' < n. Unlike Token Merging (#500, which averages pairs) and Token Dropping (#686, which stochastically zeros), pruning uses a deterministic or learned importance score s(t_i) to select a subset S' ⊂ S of tokens to retain.

### 2. RLCT Bridge
- **B1 (Piecewise partition):** The importance threshold τ partitions the token set into retained {t_i : s(t_i) ≥ τ} and pruned {t_i : s(t_i) < τ}. This partition is a semi-algebraic set in (embedding, weight) space, creating a piecewise-analytic loss landscape with singular boundaries at s(t_i) = τ.
- **B2 (Dimensionality reduction):** Pruned sequence length n' < n restricts the effective parameter space — the attention matrix shrinks from n×n to n'×n', reducing the singular fiber dimension. This is a stratum restriction: V_0^{(n')} ⊂ V_0^{(n)}.
- **B3 (Stratum selector):** The pruning ratio ρ = n'/n acts as a stratum selector. Low ρ → aggressive pruning → smaller fiber → lower λ(ρ). High ρ → near-full sequence → original λ. We predict λ(ρ) is monotone non-decreasing in ρ.
- **B4 (Generalization bound):** Gen bound becomes R(f) ≤ R_emp(f) + C·√(λ(ρ)·(d + log(1/δ))/n') where both λ and n' depend on ρ, creating a tradeoff: lower ρ reduces λ but also reduces n' (less data).

### 3. Five Claims
- **C1 (PROVEN):** The token pruning operator P_τ(x) = {x_i : s(x_i) ≥ τ} is definable in R_{an,exp} given that s is a definable function (e.g., attention-weight-based, norm-based). The indicator 1[s ≥ τ] is semi-algebraic.
- **C2 (CONJECTURAL):** The singular fiber V_0^{(n')} of the pruned model is a proper sub-variety of V_0^{(n)}: V_0^{(n')} ⊊ V_0^{(n)} when n' < n, with λ(ρ) ≤ λ(1).
- **C3 (CONJECTURAL):** There exists an optimal pruning ratio ρ* ∈ (0,1) minimizing the generalization bound, arising from the tradeoff between λ(ρ) decreasing and 1/n' increasing. We predict ρ* ~ 1 - c/√n for some constant c.
- **C4 (CONJECTURAL):** The importance score function s creates a secondary singularity structure: discontinuities in which tokens are pruned as τ varies create branch-switch singularities analogous to #468 (PPO clip) and #469 (speculative decoding).
- **C5 (CONJECTURAL):** Token pruning is fundamentally distinct from weight pruning (#220, which removes parameters) and token merging (#500, which averages). Pruning removes data points (tokens), creating a data-manifold stratum restriction rather than a parameter-space restriction.

### 4. Five Predictions
- P1: λ(ρ) is continuous and non-decreasing in ρ for definable importance scores.
- P2: Phase transition in λ at ρ = ρ_critical where essential tokens begin to be pruned.
- P3: Score-based pruning (attention weights) has lower λ than uniform random pruning at same ρ.
- P4: The gen bound tradeoff ρ* shifts with model capacity d — larger models have lower ρ* (more aggressive pruning optimal).
- P5: Cross-token attention singularity (information bottleneck when critical tokens removed) creates a sharp λ jump at ρ_critical.

### 5. Open Problems
- O1: Formal characterization of λ(ρ) as function of pruning criterion (attention-based vs norm-based vs learned).
- O2: Interaction between token pruning and positional encoding — pruning creates non-contiguous token positions, altering positional singularity structure.
- O3: Can the importance score s be designed to minimize λ directly (RLCT-aware pruning)?
- O4: Relationship to data pruning (#481): both remove information, but token pruning operates on input sequence while data pruning on training set.
- O5: Effect of learned vs fixed pruning thresholds on fiber structure.
- O6: Quantification of information loss: entropy of pruned tokens vs λ reduction.
- O7: Multi-layer pruning: tokens pruned at layer ℓ affect layers ℓ+1,...,L — nested stratum structure.

### 6. Cross-References
- #500 (Token Merging × RLCT): Non-injective averaging creates quotient fiber; pruning creates sub-variety restriction.
- #686 (Token Dropping × RLCT): Stochastic Bernoulli mask creates 2^L hypercube; pruning is deterministic score-based.
- #220 (Weight Pruning × RLCT): Removes parameters (coordinate projection); token pruning removes input tokens (data restriction).
- #481 (Data Pruning × RLCT): Removes training samples; token pruning removes tokens within a sample.
- #545 (Sparse Attention × RLCT): Sparse attention modifies attention pattern; pruning modifies input sequence.
- #169 (Dropout × RLCT): Stochastic neuron zeroing; pruning is deterministic token removal.
- #468 (PPO Clip × RLCT): Piecewise boundary singularity; pruning threshold creates analogous branch-switch.
- #469 (Speculative Decoding × RLCT): Accept/reject boundary; pruning retain/discard boundary.
- #307 (Token Merging L0): Earlier exploration of merging; pruning is the "hard" version.
- #673 (RWKV × RLCT): T-invariant RLCT; token pruning breaks this by making effective context length input-dependent.

### 7. Key Novelty Summary
Token pruning creates a **deterministic, score-governed sub-variety restriction** on the singular fiber. The pruning ratio ρ serves as a continuous stratum selector (distinct from stochastic #686 and averaging #500). The piecewise partition at s(t_i) = τ creates branch-switch singularities. The gen bound tradeoff between λ(ρ) and n' predicts an optimal ρ*. This is the first analysis of token-level data restriction through the SLT/RLCT lens.