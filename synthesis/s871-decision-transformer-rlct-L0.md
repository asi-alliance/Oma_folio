#871: Decision Transformer × RLCT — L0 Rough Paths

## Topic Motivation
The Decision Transformer (DT) recasts reinforcement learning as supervised sequence modeling: a GPT-style autoregressive model predicts actions conditioned on return-to-go (RTG), state, and action tokens via causal self-attention. Unlike policy gradient methods (#414 GRPO, #468 PPO, #136 RLHF), the loss is standard cross-entropy or MSE — a supervised objective on interleaved trajectories. This creates a fundamentally different singular structure: the loss landscape is shaped by autoregressive conditioning and RTG target injection rather than reward gradients. No prior work connects DT to singular learning theory.

## Key Insight
RTG conditioning creates a **family of loss functions** L(θ; R̂) parameterized by target return R̂. The RTG embedding acts as a continuous conditioning variable that selects submanifolds of the singular fiber. Additionally, the context window length K controls trajectory stitching capacity and may act as a discrete stratum selector — analogous to group size G in #870 but through a sequence-modeling mechanism.

## Five Candidate Claims

### C1 (PROVABLE): R_{an,exp} Definability
The DT per-timestep loss L_t = CE(a_t, π_θ(·|R̂_{≤t}, s_{≤t}, a_{<t})) is a composition of: embedding layers (linear, definable), softmax (analytic), cross-entropy (log + exp, definable). The autoregressive conditioning is a finite composition of definable functions. MSE variant (continuous actions) is polynomial. All operations preserve R_{an,exp} definability. RLCT is well-defined.

### C2 (CONJECTURAL): RTG-Conditioned Singular Fiber
The singular fiber V_DT(R̂) = {θ : ∇L(θ; R̂) = 0} depends on the target return R̂. Different R̂ values select different submanifolds of the true zero-loss set:
- R̂ matching trajectory returns → standard supervised landscape
- R̂ mismatched → biased landscape with additional singular strata from RTG-target tension
- The fiber family {V_DT(R̂)}_{R̂} forms a foliation of parameter space indexed by target return

### C3 (CONJECTURAL): Context Window K as Stratum Selector
The context length K controls how many trajectory steps the model conditions on:
- Small K → myopic predictions → limited credit assignment → simpler singular structure, lower RLCT
- Large K → long-range dependencies → richer singular structure, higher RLCT
- K acts as discrete stratum selector: λ_DT(K) increasing in K, with saturation as K exceeds effective trajectory length
- Analogous to group size G in #870 but through autoregressive context rather than group sampling

### C4 (CONJECTURAL): Generalization Bound
Gen ≤ λ_DT(R̂, K) · log(n) / (2n) + U(R̂) / √n
where:
- λ_DT(R̂, K) is the RLCT of the RTG-conditioned, K-context singular fiber
- U(R̂) captures the bias from RTG-target mismatch (stitching error)
- Optimal R̂* and K* minimize the bound — there is a tradeoff between RTG precision (lower U) and fiber complexity (higher λ)

### C5 (CONJECTURAL): Stitching Phase Transition
There exists a critical context length K* above which trajectory stitching enables generalization to unseen return distributions:
- K < K*: model memorizes trajectory fragments, cannot stitch → high bias U(R̂) dominates
- K > K*: causal attention captures cross-trajectory patterns → stitching works → U drops sharply
- This phase transition in generalization corresponds to a qualitative change in singular fiber structure (stratum connectivity)

## Open Problems
1. Exact form of λ_DT(R̂, K) — is it monotone in both R̂ and K? Interaction effects?
2. RTG embedding geometry: does RTG token create a genuine foliation or just a parameterized family?
3. Comparison with online RL RLCT: does supervised DT loss have lower RLCT than policy gradient (#414, #468)?
4. Multi-game DT (one model, many games): game identity as additional stratum selector
5. Equivalence between DT and autoregressive policy gradient in the RLCT limit
6. RTG noise injection as desingularization (analogous to #570 randomized smoothing)
7. Temperature in RTG sampling: continuous stratum selector interaction with K
8. Causal mask as definable constraint: does the triangular attention pattern create boundary singularities?

## Cross-References
- #8 RLCT basics — definability framework
- #100 Transformer — base architecture
- #414 GRPO × RLCT — policy gradient vs supervised contrast
- #468 PPO × RLCT — clipping singular structure
- #136 RLHF × RLCT — reward model conditioning
- #584 World Models × RLCT — temporal coupling structure
- #870 GRPO × RLCT — group size vs context window analogy
- #570 Randomized Smoothing × RLCT — noise as desingularization
- #533 Gradient Accumulation × RLCT — accumulation vs autoregressive context
- #379 RWKV × RLCT — recurrent vs autoregressive temporal structure

## Pipeline Status
- L0: COMPLETE (this file)
- L1-L5: PENDING