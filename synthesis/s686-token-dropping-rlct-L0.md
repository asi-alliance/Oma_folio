#686: Token Dropping × RLCT

## L0: Definitions & Claims

### Context
Token dropping is a training technique where individual tokens in the input sequence are stochastically removed (set to zero or skipped entirely) during the forward pass. Unlike dropout (#169, which zeros individual neuron activations within a layer), token dropping operates at the sequence level — removing entire token positions before or within attention computation. This creates a random sub-sequence at each forward pass, altering the attention graph topology.

### Definitions

**D1: Token Drop Mask**
Let $x = (x_1, ..., x_L)$ be an input sequence of length $L$. A token drop mask $m \in \{0,1\}^L$ is drawn i.i.d. from $\text{Bernoulli}(1-p)^L$, where $p$ is the drop probability. The masked sequence is $\tilde{x}_i = m_i \cdot x_i$. Dropped tokens ($m_i=0$) contribute zero to attention.

**D2: Stochastic Sub-Sequence Attention**
With mask $m$, the effective attention at layer $\ell$ becomes:
$$\text{Attn}_\ell^{(m)}(Q, K, V) = \text{softmax}\left(\frac{Q_m K_m^T}{\sqrt{d_k}}\right) V_m$$
where $Q_m, K_m, V_m$ are projections restricted to surviving tokens $\{i : m_i = 1\}$. Each mask realization $m$ selects a sub-graph of the attention computation.

**D3: Piecewise Attention Topology**
For each mask $m$, the set of surviving positions $S_m = \{i : m_i = 1\}$ defines an attention sub-matrix of size $|S_m| \times |S_m|$. The mask boundary — positions where $m_i$ transitions from 1 to 0 — creates discontinuities in the attention weight matrix. The collection of all $2^L$ possible masks defines a family of attention topologies, each with its own loss landscape geometry.

**D4: Drop Probability as Stratum Selector**
The drop probability $p$ controls the expected sub-sequence length $E[|S_m|] = L(1-p)$. As $p$ increases:
- $p \to 0$: Full sequence, full attention graph, desingularized limit
- $p \to 1$: Near-empty sequence, attention degenerates to trivial map (maximally singular)
- Intermediate $p$: Mixture over sub-sequence singular fibers, each with distinct RLCT

The parameter $p$ acts as a continuous stratum selector indexing a family of singular structures.

**D5: Mask-Averaged Loss**
The training loss under token dropping is:
$$\mathcal{L}_{drop}(\theta) = \mathbb{E}_m \left[ \ell(f_\theta(\tilde{x}_m), y) \right] = \sum_{m \in \{0,1\}^L} (1-p)^{|S_m|} p^{L-|S_m|} \cdot \ell(f_\theta(\tilde{x}_m), y)$$
This is a mixture over $2^L$ sub-network loss surfaces, each evaluated on a different sub-sequence.

**D6: Sub-Sequence Singular Fiber**
For mask $m$, the singular fiber $\mathcal{F}_\theta^{(m)}$ is defined by the set of parameters achieving near-zero KL divergence on sub-sequence $\tilde{x}_m$. The full drop-averaged fiber is:
$$\mathcal{F}_\theta^{drop} = \bigcap_{m} \mathcal{F}_\theta^{(m)}$$
intersected with the weight $p^{L-|S_m|}(1-p)^{|S_m|}$ weighting each mask's contribution.

**D7: Effective RLCT Under Token Dropping**
The RLCT under token dropping is:
$$\lambda_{drop}(p) = \min_\theta \lim_{n \to \infty} \frac{-\log \int_{\|\theta - \theta^*\| < \epsilon} \exp(-n \mathcal{L}_{drop}(\theta)) d\theta}{\log n}$$
Predicted: $\lambda_{drop}(p) \leq \lambda_{full}$ for $p > 0$ because the mask averaging regularizes the loss landscape by mixing over simpler sub-structures.

### Claims

**C1 (PROVEN)**: The token-drop-averaged loss $\mathcal{L}_{drop}(\theta)$ is $R_{an,exp}$-definable. Each mask realization produces a definable attention computation (polynomial matmul + definable softmax + cross-entropy). The finite weighted sum over all masks preserves definability by closure under finite sums. Bernoulli indicators are semi-algebraic (piecewise constant). Finite RLCT by resolution of singularities.

**C2 (CONJECTURAL)**: Each mask $m$ selects a distinct singular fiber $\mathcal{F}_\theta^{(m)}$ with its own RLCT $\lambda_m$. The drop-averaged RLCT satisfies $\lambda_{drop}(p) = \min_m \lambda_m$ in the most-likely-mask limit (dominant mask dominates the mixture). For small $p$, most masks retain most tokens, so $\lambda_{drop}(p) \approx \lambda_{full}$. For large $p$, masks with few surviving tokens dominate, and $\lambda_{drop}(p) \to \lambda_{trivial}$ where $\lambda_{trivial}$ is the RLCT of the degenerate near-empty attention.

**C3 (CONJECTURAL)**: The drop probability $p$ acts as a stratum selector. There exists a critical $p^*$ at which the dominant singular stratum transitions from the full-sequence stratum ($p < p^*$) to a reduced sub-sequence stratum ($p > p^*$). This is a phase transition in the RLCT: $\lambda_{drop}(p)$ is continuous but non-analytic at $p^*$. Predicted scaling: $p^* \sim 1 - c/\sqrt{L}$ for sequence length $L$.

**C4 (CONJECTURAL)**: The generalization bound under token dropping is:
$$G_{drop} \leq \frac{\lambda_{drop}(p)}{n} + \frac{U(p)}{\sqrt{n}}$$
where $U(p)$ is the fluctuation term from mask stochasticity. There is a tradeoff: increasing $p$ reduces $\lambda_{drop}$ (simpler effective singularity) but increases $U(p)$ (more variance from aggressive dropping). Optimal $p^*_{gen}$ balances these.

**C5 (CONJECTURAL)**: Token dropping creates a combinatorial singular structure: the $2^L$ possible masks define a hypercube of singular fibers. The intersection structure (parameters that are optimal for ALL masks) is a refinement of the full-sequence fiber. At the critical drop probability $p^*$, the intersection fiber undergoes a topological transition — the set of parameters optimal for all surviving sub-sequences changes connectivity. This is testable via SGLD on the drop-averaged loss.

### Cross-References
- #169/#506 Dropout × RLCT (drops individual neurons, not token positions)
- #500 Token Merging × RLCT (deterministic merging via similarity, not stochastic removal)
- #481 Data Pruning × RLCT (removes training examples, not tokens within a sequence)
- #220 Weight Pruning × RLCT (removes parameters, not input tokens)
- #545 Sparse Attention × RLCT (deterministic sparsity patterns, not stochastic token-level)
- #552 Stochastic Depth × RLCT (drops layers, not tokens)
- #8 Foundational RLCT
- #16 Watanabe generalization bound
- #529 Self-Consistency Decoding (output-space stochasticity, vs input-space here)
- #582 Curriculum Learning (data distribution as stratum selector)

### Open Problems
1. Exact computation of $\lambda_{drop}(p)$ — does the mixture over masks decompose additively or multiplicatively?
2. Interaction with positional encodings: does dropping tokens create gaps in positional structure that change the singularity type?
3. Does the $2^L$ mask hypercube have a percolation threshold analogous to DropBlock (#477)?
4. Interaction with attention masking (causal mask + drop mask = compound mask): how do two masks compose in the singular fiber?
5. Is there a closed-form for $p^*$ or only empirical characterization?
6. Does token dropping at different layers create hierarchical stratum selectors (layer-dependent $p_\ell$)?
7. Connection to information bottleneck: does dropping tokens impose an information constraint that regularizes RLCT?
