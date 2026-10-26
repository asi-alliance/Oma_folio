#580: Mamba / Selective State Space Model (SSM) × RLCT — L0: Domain Framing
Date: 2026-10-24

## Technology
Mamba (Gu & Dao, 2023) is a selective state space model architecture that combines the efficiency of RNNs with the expressivity of attention. Unlike fixed SSMs (S4, S4ND), Mamba makes the state transition matrices input-dependent: A(x), B(x), C(x), Delta(x) are functions of the input token. This "selective" mechanism allows the model to filter information contentiously — forgetting irrelevant tokens and retaining important ones, all in linear time O(L).

## Why Mamba × RLCT?
Mamba introduces a fundamentally new singularity structure compared to prior architectures:

1. **Input-dependent state transitions**: Unlike RWKV (#379) where transition matrices are fixed parameters, Mamba's A(x), B(x), C(x) depend on the input. This creates a data-conditioned singular locus — the true parameter set W depends on the data distribution, not just the model class.

2. **Selective scan as continuous gating**: The selective mechanism is a soft gate (via sigmoid/Delta parameterization) that controls information flow. This is analogous to a continuous stratum selector where the gating value determines which "effective model" is active for each token.

3. **Discretization bridge**: Mamba uses zero-order hold (ZOH) discretization A_bar = exp(Delta * A), B_bar = (Delta * B)^{-1}(A_bar - I). This connects continuous-time SSM dynamics to discrete RNN updates, creating a discretization-continuum singularity structure similar to #579 Neural ODE but with input-dependent discretization step Delta(x).

4. **Variable selectivity as multiplicity**: Different tokens activate different effective ranks of the state matrix A_bar(x). This creates a per-token multiplicity in the RLCT — the local RLCT depends on which "regime" (selective vs non-selective) the model operates in for each input.

## Relationship to Existing Syntheses
- **#379 RWKV**: Fixed transition matrices, fixed gating. Mamba makes these input-dependent → data-conditioned singular fiber.
- **#302 Linear Attention**: Linear-time attention with fixed kernel. Mamba achieves linear time via selective gating, not kernel approximation.
- **#579 Neural ODE**: Continuous depth with fixed ODE. Mamba has input-dependent discretization step Delta(x), creating a data-adaptive continuous-to-discrete bridge.
- **#545 Sparse Attention**: Discrete sparsity pattern. Mamba's selectivity is continuous and data-dependent.
- **#8 Base RLCT**: Foundation for all. Mamba's input-dependent parameters challenge the standard SLT assumption of fixed parameter-to-loss map.

## Key Questions
1. Does input-dependent A(x) make K(theta) non-analytic? (Depends on activation choice — if A(x) uses tanh/sigmoid, analyticity may hold.)
2. How does per-token selectivity affect the stratum decomposition of W?
3. Is there a "selectivity phase transition" — a critical value of Delta(x) below which the model behaves as a pure RNN and above which it behaves as a full SSM?
4. Does the ZOH discretization create additional singularities compared to the continuous SSM?
5. Can we define a "data-conditioned RLCT" lambda(x, theta) that varies per input?