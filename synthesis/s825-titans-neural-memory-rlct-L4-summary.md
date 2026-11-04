# Synthesis #825: Titans Neural Long-Term Memory × RLCT — L4 Summary

## Plain-Language Summary

Google's Titans architecture augments a standard transformer with a neural long-term memory module — an MLP whose weights are updated online via surprise-gated gradient descent during inference. The surprise signal s(x) = ||∇_M L|| measures how poorly the memory predicts the current input, gating both the magnitude of weight updates and a momentum term. A forgetting rate η exponentially decays past gradients, controlling plasticity-stability tradeoff.

Through the SLT lens, this creates a **path-dependent singular fiber**: the memory MLP's loss landscape geometry depends on the full history of test-time inputs through the gradient EMA, not just the current sample. Unlike standard training where the fiber is determined by the data distribution alone, Titans introduces a dynamical singular structure that evolves with the input stream.

### Claims

**C1 (PROVEN):** The Titans composite loss (CE + α·associative memory loss) is R_{an,exp}-definable — all components (Markov-normalized weights, squared-norm regularizer, max image delta, gradient-based surprise) are built from analytic operations. Finite RLCT exists.

**C2 (CONJECTURAL):** The surprise-gated memory update creates a non-empty singular fiber — when surprise is zero (memory perfectly predicts input), the memory parameters lie on a degenerate submanifold where the associative loss is locally flat. The fiber is non-empty because random initialization rarely achieves zero surprise.

**C3 (CONJECTURAL):** The effective RLCT is path-dependent — because the gradient EMA couples updates across timesteps, the local geometry at any point depends on the full input history. Standard RLCT assumes i.i.d. sampling; Titans requires a dynamical SLT extension where λ_eff = λ(θ, x_{1:t}) varies with the path taken through input space.

**C4 (CONJECTURAL):** The generalization bound includes a temporal surprise distribution term: Gen = √(λ_eff·σ²/n) + C_surprise, where C_surprise depends on E[s(x)] and the forgetting rate η. High sustained surprise (poor memory) inflates the bound; optimal forgetting minimizes it.

**C5 (CONJECTURAL):** A phase transition occurs at η* — below η*, the memory retains too much stale information (over-constrained fiber, high λ); above η*, it forgets too aggressively (under-constrained, also high λ). At η* the fiber dimension is minimized, analogous to optimal plasticity in continual learning.

### Key Novelty

Three genuinely new contributions not in prior syntheses:
1. **Dual stratum selector** — Titans' surprise s(x) depends on both data AND parameters simultaneously (||∇_M L||), unlike pure data-dependent selectors (Mamba's Δ(x)) or pure parameter selectors (LoRA rank r). This creates a feedback loop: parameters determine surprise, surprise determines which stratum is explored.
2. **Path-dependent RLCT** — the gradient EMA couples the loss landscape across timesteps, requiring dynamical SLT where λ evolves with input history. No prior synthesis features path-dependent RLCT.
3. **Forgetting-rate phase transition** — η as a continuous stratum selector with critical η* that minimizes fiber dimension, bridging SLT with continual learning plasticity-stability theory.

### Cross-References
#824 (Mamba S6), #653 (TTT), #674 (NTM), #179 (test-time adaptation), #471 (PonderNet depth), #388 (Mirostat), #485 (RLT reduced exploration), #620 (RMSNorm), #501 (weight tying), #650 (BYOL EMA), #169 (curriculum), #582 (curriculum stratum selector)

### Open Problems
1. Dynamical SLT: formalize path-dependent RLCT λ(θ, x_{1:t}) — does Watanabe's theorem extend to non-i.i.d. adaptive sampling?
2. Closed form for C_surprise: asymptotic vs finite-sample, relationship to η and E[s(x)]
3. Memory depth analogy to #471: does deeper memory create hierarchical strata (nested singular fibers)?
4. MAC vs persistent memory: independent strata or coupled via the attention bridge?
5. Interaction with flash attention (#292): does tiling affect path-dependent RLCT?
6. Phase transition universality: is η* scaling law η* ~ n^β with universal β?
7. Surprise threshold as discrete stratum selector: hard gating vs soft gating topology
8. Multi-layer Titans: does stacking memory modules create compositional singular fibers?