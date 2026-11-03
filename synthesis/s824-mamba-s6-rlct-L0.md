# Synthesis #824: Mamba/S6 Selective State Space Models × RLCT - L0 Scoping
# Date: 2026-11-03
# Status: L0 IN PROGRESS

## Background

Mamba (Gu & Dao, 2023) replaces attention with selective state spaces. The S6 architecture uses input-dependent parameters: the state transition matrix A, input gate B, and output gate C vary with the input x_t at each timestep. This selectivity mechanism distinguishes Mamba from fixed S4/S4D models where A, B, C are static.

The continuous-time SSM is: h'(t) = A h(t) + B x(t), y(t) = C h(t) + D x(t). Mamba makes B(x_t), C(x_t), and Delta(x_t) (discretization step) input-dependent, while A remains parameterized (HIPPO or diagonal init) but modulated by Delta.

## Key SLT/RLCT Insight

**Input-dependent selective scan creates data-dependent singular fibers.** Unlike standard RNNs (fixed recurrence) or Transformers (permutation-equivariant attention), Mamba's selective mechanism makes the effective transition matrix A_eff(x) = f(Delta(x), A) input-dependent. This creates:

1. **Data-dependent stratum structure**: The singularity locus depends on the input sequence, not just parameters. Different inputs activate different singular strata.
2. **Selective gating as fiber selector**: The input-dependent Delta(x) acts as a continuous stratum selector — large Delta approximates full attention (high-rank update), small Delta approximates identity (low-rank/no update). This is analogous to temperature τ in Gumbel-Softmax (#839).
3. **Discretization singularity**: Zero-order hold (ZOH) discretization A_bar = exp(Delta * A) creates an exp-map singularity. When Delta -> 0, A_bar -> I (identity), collapsing the state fiber. When Delta -> inf, A_bar -> 0 (forgetting), different collapse mode.

## Claims

- **C1**: Mamba/S6 loss is R_{an,exp}-definable. Selective scan involves linear algebra (matmul), GELU/SiLU activations (subanalytic), exp in ZOH discretization, and softmax in output. All closed under R_{an,exp}.
- **C2**: Input-dependent Delta(x) creates a continuous stratum selector. The singular fiber dimension varies with Delta: lambda(Delta) is non-monotonic, with a critical Delta* where the effective rank of state updates transitions.
- **C3**: ZOH discretization exp(Delta*A) introduces an exponential singularity. At Delta=0, A_bar=I creates a degenerate fiber (state never updates). At Delta->inf, A_bar->0 creates a forgetting fiber (state resets).
- **C4**: Generalization bound depends on the distribution of Delta(x) across training data. Sequences with bimodal Delta distribution (some tokens "important", some "ignored") create richer singular structure than uniform Delta.
- **C5**: Phase transition in SGLD LLC as model transitions from "copy-all" (large Delta) to "ignore-all" (small Delta) regime, with critical Delta* detectable via LLC.

## Open Questions

1. Does input-dependence of A_eff break permutation symmetry entirely, or create a residual data-dependent symmetry?
2. How does HIPPO initialization interact with the singular structure? Does structured A init reduce RLCT compared to random A?
3. Connection to RNN × RLCT (#?): Mamba is a gated RNN with selective gating. How does selectivity change the singular fiber vs standard GRU/LSTM?
4. Connection to attention × RLCT: Mamba replaces attention — is the singular structure simpler (lower lambda) or more complex?
5. Multi-head Mamba: does parallel SSM heads create product fibers analogous to multi-head attention?

## Cross-References (preliminary)
#839 (Gumbel-Softmax, temperature as stratum selector), #496 (CoT), #545 (sparse attention), #169 (dropout), #823 (MLP-Mixer dual symmetry), #490 (RoPE positional encoding)

File: /tmp/Oma_folio/synthesis/s824-mamba-s6-rlct-L0.md
Next: L1 formalization, L2 novelty check, L3 MeTTa, L4 summary, L5 catalog.