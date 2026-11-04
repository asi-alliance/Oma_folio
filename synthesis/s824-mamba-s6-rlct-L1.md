# Synthesis #824: Mamba/S6 Selective State Space Models × RLCT - L1 Formalization
# Date: 2026-11-03
# Status: L1 COMPLETE
# C1 PROVEN, C2-C5 CONJECTURAL

## Definitions

**D1 (Selective SSM Architecture)**
The Mamba/S6 model is defined by input-dependent parameters at each timestep t:
- B_t = Linear_B(x_t), C_t = Linear_C(x_t), Delta_t = softplus(s_1(x_t)) - s_2(x_t)
- Discretization (ZOH): A_bar_t = exp(Delta_t * A), B_bar_t = Delta_t * B_t (first-order approximation)
- State update: h_t = A_bar_t * h_{t-1} + B_bar_t * x_t
- Output: y_t = C_t * h_t + D * x_t
- Parameters: W = {A, Linear_B, Linear_C, s_1, s_2, D, output projections}. A is diagonal (d-dimensional).

**D2 (Loss Function)**
L_n(W) = (1/n) * sum_i CE(y_i, f_W(x_i)), where f_W applies the selective scan above plus a final linear + softmax layer. CE involves log(softmax) which uses exp. The selective scan involves matmul (polynomial), SiLU (subanalytic), and exp(Delta*A) (exponential).

**D3 (R_{an,exp}-Definability Structure) — C1 PROVEN**
- A_bar_t = exp(Delta_t * A): exp of polynomial (Delta_t = softplus(linear(x)) is subanalytic + softplus is definable). exp is in R_{an,exp}.
- B_bar_t = Delta_t * B_t: polynomial composition.
- h_t = A_bar_t * h_{t-1} + B_bar_t * x_t: polynomial in (A_bar_t, B_t, x_t, h_{t-1}). Sequential scan is polynomial iteration.
- SiLU(x) = x * sigmoid(x): sigmoid = 1/(1+exp(-x)) is R_{an,exp}-definable. Product with x is definable.
- Softmax = exp(z_i)/sum_j exp(z_j): ratio of exp functions, R_{an,exp}-definable.
- Composition closure: R_{an,exp} is closed under composition, addition, multiplication, division (where denominator nonzero). ∴ L_n ∈ R_{an,exp}. ∎

**D4 (Delta-Stratified Loss Family)**
For a fixed scale parameter g controlling the distribution of Delta(x), define the family:
L_n^{(g)}(W) = (1/n) sum_i CE(y_i, f_W^{(g)}(x_i))
where f_W^{(g)} scales Delta_t -> g * Delta_t. This creates a one-parameter family of loss landscapes.

**D5 (Singular Fiber V_Delta)**
Define V_Delta = {W : L_n^{(g)}(W) = 0 for the Delta->0 regime} where A_bar -> I (identity), h_t = h_{t-1} + B_bar * x_t (accumulation, no forgetting). This fiber has degenerate dynamics — the state carries all past inputs without compression. RLCT lambda(Delta->0) is maximal (most singular).

Define V_forget = {W : Delta -> infinity} where A_bar -> 0, h_t = B_bar * x_t (state resets each step, no memory). This fiber has trivial dynamics — only current input matters.

**D6 (Generalization Bound)**
G_Mamba ~ lambda(Delta) / n + U(Delta) / sqrt(n)
where lambda(Delta) is the effective RLCT of the selective scan architecture, and U(Delta) captures the bias from input-dependent gating. Bimodal Delta distribution (selective retention) conjectured to give lower lambda than uniform Delta.

**D7 (Phase Transition Delta*)**
There exists critical Delta* where lambda(Delta) transitions between accumulation-dominated (Delta < Delta*, high lambda) and selection-dominated (Delta > Delta*, lower lambda) regimes. SGLD LLC shows step decrease at Delta*.

## Claims

**C1 PROVEN**: Mamba/S6 loss is R_{an,exp}-definable. Proof in D3 above.

**C2 CONJECTURAL**: Input-dependent Delta(x) creates a continuous stratum selector. The singular fiber dimension lambda(Delta) is non-monotonic: at Delta->0, accumulation fiber dominates (high lambda, state carries everything); at Delta->inf, forgetting fiber dominates (low lambda, state carries nothing); optimal selection at intermediate Delta* minimizes lambda by balancing memory and compression.

**C3 CONJECTURAL**: ZOH discretization exp(Delta*A) introduces an exponential singularity at Delta=0 (A_bar=I, degenerate accumulation) and Delta=inf (A_bar=0, degenerate forgetting). These are distinct singular strata connected by the continuous Delta parameter. The exp map creates a non-algebraic singularity structure, unlike standard RNN fixed recurrence.

**C4 CONJECTURAL**: Generalization bound depends on Delta(x) distribution across training data. Sequences with bimodal Delta (selective retention of important tokens, forgetting of irrelevant ones) create richer singular structure with lower effective lambda than uniform Delta (either all-retain or all-forget).

**C5 CONJECTURAL**: Phase transition in SGLD LLC at Delta* separates accumulation regime (high LLC) from selection regime (lower LLC). This is detectable by varying the selectivity scale g and observing LLC step decrease.

## Open Problems

1. Does input-dependence of A_eff break GL(d) gauge symmetry entirely, or create residual data-dependent symmetry? Contrast with #233 (fixed SSM where GL(d) gauge is broken only by discretization).
2. HIPPO initialization of A: does structured A (HiPPO matrix) reduce RLCT compared to random diagonal A? Hypothesis: HiPPO structure constrains singular locus to lower-dimensional stratum.
3. Connection to RNN × RLCT: selective gating vs fixed GRU/LSTM gates — does selectivity increase or decrease lambda? Key difference: Mamba's Delta is input-dependent, GRU/LSTM gates are parameter-dependent.
4. Multi-head Mamba: parallel SSM heads with different A matrices — product fibers analogous to multi-head attention? See #134 (attention × RLCT).
5. Connection to attention × RLCT: Mamba replaces attention with O(n) selective scan. Is the singular structure simpler (lower lambda) or more complex? Hypothesis: selective scan has lower lambda than attention (fewer parameters, structured recurrence).
6. Zero-order hold vs bilinear discretization: does the choice of discretization scheme affect RLCT? ZOH uses exp (R_{an,exp}), bilinear uses (I + Delta*A/2)/(I - Delta*A/2) (rational, subanalytic).
7. Does the selectivity mechanism (input-dependent Delta) create non-transverse singularities that require desingularization?

## Cross-References
#839 (Gumbel-Softmax, temperature as stratum selector), #496 (CoT), #545 (sparse attention), #169 (dropout), #823 (MLP-Mixer dual symmetry), #490 (RoPE positional encoding), #468 (PPO clip branch-switch), #233 (fixed SSM × RLCT), #134 (attention × RLCT), #485 (RNN weight tying)

File: /tmp/Oma_folio/synthesis/s824-mamba-s6-rlct-L1.md
Next: L2 novelty verification.