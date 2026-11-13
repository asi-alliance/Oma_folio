#871: Decision Transformer × RLCT — L1 Formalization

## D1 (Parameter Space)
Let Θ ⊂ R^d be the parameter space of a GPT-style autoregressive model (embedding layers, transformer blocks, output head). The DT processes trajectories τ = (R̂_1, s_1, a_1, R̂_2, s_2, a_2, ..., R̂_T, s_T, a_T) where:
- R̂_t = target return-to-go at step t
- s_t = state observation
- a_t = action (discrete: token; continuous: vector)

The model predicts a_t from the causal context (R̂_{≤t}, s_{≤t}, a_{<t}). The loss is:
L(θ) = (1/T) Σ_{t=1}^{T} L_t(θ)

where L_t = -log π_θ(a_t | R̂_{≤t}, s_{≤t}, a_{<t}) for discrete actions (cross-entropy) or L_t = ||a_t - μ_θ(R̂_{≤t}, s_{≤t}, a_{<t})||^2 for continuous actions (MSE).

## D2 (DT Loss Function — Formal)
For discrete actions with vocabulary size |A|:
L_t(θ) = -log π_θ(a_t | R̂_{≤t}, s_{≤t}, a_{<t}) = -log softmax(W_o · h_t)_{a_t}

where h_t = TransformerBlocks(E_R(R̂_{≤t}), E_s(s_{≤t}), E_a(a_{<t})) is the hidden representation at position t, produced by causal self-attention over the interleaved sequence. E_R, E_s, E_a are linear embedding projections, W_o is the output projection.

For continuous actions:
L_t(θ) = ||a_t - μ_θ(R̂_{≤t}, s_{≤t}, a_{<t})||^2 = ||a_t - W_o · h_t||^2

Context window K ≤ T limits the conditioning to the last K timesteps.

## D3 (R_{an,exp} Definability — C1 PROVEN)
**Claim C1 (PROVABLE):** L_DT is definable in R_{an,exp}, hence RLCT is well-defined.

**Proof sketch:** Each component is definable:
- E_R, E_s, E_a: linear maps → polynomial → definable
- Self-attention: QK^T/d_k uses inner product (bilinear) → polynomial; softmax = exp(x_i)/Σexp(x_j) → definable in R_{an,exp}; causal mask is piecewise (0/1) → definable
- LayerNorm: (x - μ)/σ with σ = sqrt(var + ε) → definable (sqrt is definable in R_{an,exp}, var is polynomial)
- Residual connections: x + f(x) → sum of definable functions → definable
- MLP blocks: linear → activation (ReLU piecewise-linear or GELF definable) → linear → all definable
- Full transformer: finite composition of definable blocks → definable
- Cross-entropy: -log(softmax(z)_{a_t}) = -z_{a_t} + log(Σ_j exp(z_j)) → definable in R_{an,exp}
- MSE: ||a_t - W_o h_t||^2 → polynomial → definable
- Time average (1/T) Σ L_t → finite sum of definable → definable

The singular locus {σ_LayerNorm = 0} (constant activations) is definable (zero set of definable function). On open sets where LayerNorm denominators are nonzero, L_DT is sub-analytic. By Watanabe's definability theorem, RLCT λ is well-defined for L_DT on any compact K avoiding these loci. ∎

## D4 (RTG-Conditioned Singular Fiber — C2 CONJECTURAL)
**Claim C2 (CONJECTURAL):** The singular fiber V_DT(R̂) depends on target return R̂.

The zero-loss set V_DT(R̂) = {θ : L(θ; R̂) = 0} = {θ : π_θ(a_t | R̂_{≤t}, s_{≤t}, a_{<t}) = a_t ∀t} is conditioned on R̂. Properties:
- V_DT(R̂) is the set of parameters perfectly predicting actions given RTG targets
- Different R̂ values activate different trajectory distributions → different constraint sets on θ
- The family {V_DT(R̂)}_{R̂∈R} forms a one-parameter family of subvarieties
- RTG embedding E_R(R̂) = W_R · R̂ injects R̂ linearly into the attention computation → R̂ affects attention scores → different attention patterns → different singular fiber geometry
- Conjecture: V_DT(R̂) is generically a proper subvariety for each R̂, and the union ∪_{R̂} V_DT(R̂) may have strictly larger RLCT than any single fiber

The standard architectural singular fiber V_0 (inherited from transformer structure: attention rank degeneracy, LayerNorm singularity, ReLU kinks) persists and is R̂-independent.

## D5 (Context Window K as Stratum Selector — C3 CONJECTURAL)
**Claim C3 (CONJECTURAL):** Context length K acts as a discrete stratum selector on the singular fiber.

With context window K, the model conditions on at most K timesteps. This truncates the causal attention mask:
- Small K → short context → each prediction depends on few tokens → fewer cross-constraint interactions → simpler constraint surface → lower effective dimension of singular fiber → lower RLCT
- Large K → long context → rich cross-trajectory dependencies → more constraint intersections → higher-dimensional singular structure → higher RLCT
- K → T (full trajectory): maximal dependency → full RLCT
- K → 1: myopic, each a_t predicted from (R̂_t, s_t) only → resembles BC (behavioral cloning) → minimal RLCT

Conjectured scaling: λ_DT(K) ≈ λ_BC + (λ_full - λ_BC) · K/(K + K_0) where K_0 is architecture/training-distribution dependent. This mirrors the G/(G+G₀) scaling in #870 GRPO, but the mechanism is autoregressive context truncation rather than group normalization rank.

## D6 (Generalization Bound — C4 CONJECTURAL)
**Claim C4 (CONJECTURAL):** The generalization bound for DT is:

G(n) ≤ λ_DT(R̂, K) · log(n) / (2n) + U(R̂, K) / √n + O(1/n)

where:
- λ_DT(R̂, K) is the RLCT of the RTG-conditioned, K-context singular fiber
- U(R̂, K) captures bias from: (a) RTG-target mismatch (target R̂ vs actual trajectory return), (b) context truncation (K < effective trajectory length), (c) distribution shift between offline data and deployment
- The bound has a bias-variance tradeoff: larger K increases λ (complexity) but decreases U (stitching error)
- Optimal K* minimizes the bound: K* = argmin_K [λ_DT(K)·log(n)/(2n) + U(K)/√n]

This differs from policy gradient bounds (#414, #468) which lack the RTG-conditioning term U(R̂).

## D7 (Stitching Phase Transition — C5 CONJECTURAL)
**Claim C5 (CONJECTURAL):** There exists critical context length K* above which trajectory stitching enables generalization.

- K < K*: model treats each trajectory fragment independently → cannot infer cross-trajectory structure → U(R̂, K) ≈ constant (high bias) → poor generalization to unseen returns
- K > K*: causal attention captures inter-trajectory patterns (shared subgoals, state overlaps) → stitching works → U drops sharply → qualitative change in generalization
- This phase transition corresponds to a structural change in the singular fiber: below K*, fibers V_DT^K(R̂) for different R̂ are disconnected (no shared singular strata); above K*, fibers become connected via shared attention patterns → lower effective RLCT across the family
- K* depends on: trajectory overlap density, reward distribution width, model capacity d

## Open Problems
1. Exact form of λ_DT(R̂, K) — interaction between R̂ conditioning and K truncation
2. Whether V_DT(R̂) forms a genuine foliation (smooth family) or has singular parameter values R̂*
3. Comparison: λ_DT vs λ_policy_gradient — does supervised DT have lower RLCT than #414 GRPO?
4. Multi-game DT: game identity token as additional stratum selector — multi-dimensional fiber family
5. Online DT (trajectory generation during training): does this add a sampling-induced singular structure?
6. RTG noise injection: adding noise to R̂ as desingularization (analogous to #570 randomized smoothing)
7. Causal mask boundary: does the triangular attention pattern create definable boundary singularities at K?

## Cross-References
- #8 RLCT basics — definability framework
- #100 Transformer — base architecture singular structure
- #414 GRPO × RLCT — policy gradient vs supervised contrast
- #468 PPO × RLCT — clipping singular structure
- #136 RLHF × RLCT — reward model conditioning
- #584 World Models × RLCT — temporal coupling
- #870 GRPO × RLCT — G vs K stratum selector analogy
- #570 Randomized Smoothing × RLCT — noise desingularization
- #533 Gradient Accumulation × RLCT — accumulation vs autoregressive context
- #379 RWKV × RLCT — recurrent vs autoregressive temporal structure

## Pipeline Status
- L0: COMPLETE
- L1: COMPLETE (this file)
- L2-L5: PENDING