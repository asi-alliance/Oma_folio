# Synthesis #529: Self-Consistency Decoding × RLCT — L0 Exploration

## Candidate Confirmation
Self-consistency decoding (Wang et al. 2022) samples N reasoning paths from a language model at temperature τ > 0, generates answers from each path, and selects the most frequent answer via majority vote. Zero catalog hits. Zero prior SLT/RLCT bridge in 5 websearches.

## Key RLCT Bridge
Multiple sampled reasoning paths = independent samples from the singular fiber neighborhood of the trained model. Temperature τ controls the exploration radius within the fiber. Majority vote over answers = selecting the dominant stratum (most populated answer cluster). Path diversity (controlled by τ) measures how broadly the singular fiber is explored. Agreement fraction = confidence proxy analogous to RLCT-gated stratum consensus. The composite mechanism — stochastic sampling + discrete aggregation — creates a definable map from parameters to answer distribution with singularity structure at answer tie boundaries.

## Definitions (Draft)
- D1 (SelfConsistency): Sample N paths y_1,...,y_N ~ p_θ(y|x) at temperature τ, extract answers a_i, select argmax_a count(a_i = a)
- D2 (FiberNeighborhood): B_τ(w*) = set of parameter points reachable via stochastic sampling at temperature τ from optimal w*
- D3 (StratumConsensus): The answer cluster with highest occupancy across N samples = dominant singular stratum
- D4 (PathDiversity): D(τ, N) = entropy of answer distribution across N samples
- D5 (AgreementFraction): f_agree = max_a count(a_i=a) / N
- D6 (TieBoundary): {(a,b) : count(a_i=a) = count(a_i=b)} — semi-algebraic boundary in sample space
- D7 (TemperatureExploration): τ as fiber neighborhood radius selector

## Questions (7)
1. How does the singular fiber structure of p_θ determine which answers are reachable across sampling paths?
2. Does majority vote correspond to maximum-likelihood stratum selection or a different criterion?
3. Is the agreement fraction f_agree correlated with RLCT λ_eff of the sampled answer stratum?
4. What happens at the tie boundary — is there a phase transition when two answer clusters have equal count?
5. How does N (number of paths) interact with τ in controlling fiber exploration completeness?
6. Does self-consistency reduce effective RLCT compared to single-sample greedy decoding?
7. Is there an optimal τ* that maximizes stratum coverage without introducing noise-path contamination?

## Claims
### C1 (PROVEN): R_an,exp-definability
The self-consistency map — sampling from softmax(θ·h/T), extracting answers via deterministic parsing, and counting/aggregating via argmax of counts — is definable in R_an,exp. Softmax is exp-definable, count indicators are semi-algebraic (finite comparison), argmax of counts is definable via finite max. The composite is closed under these operations.

### C2 (CONJECTURAL): Temperature τ as fiber neighborhood stratum selector
Temperature τ controls the exploration radius within the singular fiber. At τ → 0: greedy/MAP decoding, single path, visits only nearest stratum (low RLCT, low diversity). At τ → ∞: uniform sampling, all paths equally likely, visits all strata (high diversity, noise-dominated). τ acts as a continuous stratum selector: B_τ(w*) grows with τ, exposing more singular strata. The reachable strata at temperature τ define an effective RLCT λ_eff(τ) that increases with τ.

### C3 (CONJECTURAL): Majority vote as dominant stratum consensus
The most frequent answer across N paths corresponds to the dominant singular stratum — the stratum with highest posterior mass. This is the stratum consensus mode: argmax over answer clusters = argmax over accessible strata weighted by their fiber volume. Agreement fraction f_agree estimates the posterior mass concentrated on the dominant stratum. Higher f_agree → more peaked stratum distribution → lower effective RLCT (model confident in one stratum). Lower f_agree → diffuse stratum distribution → higher effective RLCT (model spread across multiple strata).

### C4 (CONJECTURAL): Generalization bound with path diversity
G_SC ≤ λ_eff(τ, N) / N + U(τ) / √N where λ_eff(τ, N) is the effective RLCT of the dominant stratum identified by N samples at temperature τ, and U(τ) captures the variance from non-dominant strata. The bound improves with N (more paths → better stratum identification) but degrades with τ too high (noise paths contaminate the dominant stratum estimate). Optimal N and τ minimize the bound. This is distinct from single-sample bounds (#8, #16) which don't account for multi-path aggregation.

### C5 (CONJECTURAL): Phase transition at critical τ*
At low τ: single dominant stratum, high agreement, low λ_eff — but may miss the correct stratum (under-exploration). At high τ: many strata explored, low agreement, high λ_eff — noise paths dominate (over-exploration). Critical τ* = phase transition where exploration is sufficient to identify the dominant stratum but not so high that noise overwhelms signal. At τ*: agreement fraction drops sharply (from ~1 to <1/k for k competing strata), analogous to order-disorder transition. U-shaped λ_eff(τ) with minimum at τ*. Predicted: SGLD LLC trajectories at τ < τ* show single-basin convergence, at τ > τ* show multi-basin diffusion.

## Open Problems (7)
1. Fiber neighborhood topology: is B_τ(w*) connected or does it have multiple components (one per answer stratum)?
2. Stratum posterior mass estimation: how many samples N needed to reliably identify the dominant stratum with confidence 1-δ?
3. Tie boundary structure: what is the RLCT of the tie manifold {count(a) = count(b)}? Is it a new singularity type?
4. Temperature-stratum duality: is τ ↔ λ_eff(τ) invertible, or are multiple strata accessible at the same τ?
5. Interaction with chain-of-thought (#170, #496): does CoT reasoning create additional singular structure in the fiber that self-consistency exploits?
6. Comparison with ensemble methods (#232, #394): self-consistency averages in output space (answer votes) vs parameter space (weight averaging) — different singular geometry?
7. Path correlation: are the N sampled paths independent samples from the fiber, or are they correlated (shared prefix tokens)? Does correlation reduce effective N?

## Cross-References
#8 (ReLU definability), #16 (semi-algebraic), #99 (SGD dynamics), #127 (MoE routing — stratum selection in parameter space), #170 (CoT reasoning), #201 (early exit — single-path confidence), #236 (early stopping — epoch as stratum selector), #294 (self-consistency — need to check overlap), #359 (nucleus sampling — τ as stratum selector in token space), #388/#435 (beam search — width K as stratum selector), #393 (contrastive decoding — two-model, not multi-sample), #496 (CoT × RLCT), #503 (early exit — single-path, distinct from multi-path)

## Distinctions
- #503 (Early Exit): Single forward pass with depth-conditioned exit. #529 uses multiple full forward passes with output-space aggregation. Different stratum selection dimension.
- #393 (Contrastive Decoding): Two-model logit subtraction creates zero-crossing singularity. #529 uses single-model multi-sample — no subtraction, different singularity type (aggregation boundary, not zero-crossing).
- #388/#435 (Beam Search): Width K selects top-K partial sequences deterministically. #529 samples N full paths stochastically and aggregates final answers. Different exploration mechanism (greedy pruning vs stochastic sampling).
- #359 (Nucleus Sampling): τ controls token-level truncation. #529 τ controls path-level diversity. Different granularity (token vs sequence).
- #232/#394 (Weight Averaging): Aggregation in parameter space. #529 aggregates in output (answer) space. Different fiber geometry (convex hull of weights vs vote counting).

## Next: L1 formalization