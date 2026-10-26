# Synthesis #564: Tokenization / Byte Pair Encoding × RLCT

## Date: 2026-10-23
## Status: L0 (Exploration)

### Topic
Byte Pair Encoding (BPE) and subword tokenization as a singular structure in the RLCT framework.

### Key RLCT Bridge
BPE tokenization creates a hierarchical, discrete partition of the input string space. Each merge operation in the BPE training phase defines a boundary in the space of byte sequences. The resulting tokenizer maps continuous text to discrete token IDs, creating a piecewise-constant map from input space to embedding space. This partition structure creates singularities:

1. **Merge tree as singular locus**: The BPE merge table defines a binary tree over byte pairs. Each merge rule creates a decision boundary in the input space. The composition of merges creates a hierarchical singular structure — the "fiber" over a token ID is the set of all input strings that tokenize to that ID.

2. **Vocabulary size V as stratum selector**: Small V creates coarse partition (large fibers, high degeneracy). Large V creates fine partition (small fibers, low degeneracy). Phase transition at V* where token granularity matches the local geometry of the data manifold.

3. **Token boundary singularities**: The tokenization map T: {strings} → {token sequences} is piecewise-constant. Gradients of the loss w.r.t. input are zero within each token fiber and undefined at boundaries. This creates a non-smooth loss landscape with singular strata at token boundaries.

4. **Embedding lookup as fiber projection**: Each token ID maps to a learned embedding vector. The embedding matrix E ∈ R^{V×d} is the parameter. The fiber over embedding e_i is the preimage T^{-1}(i). The KL divergence landscape has singularities where tokenization decisions change, as the model's prediction jumps discontinuously across token boundaries.

### C1: R_{an,exp}-definability
The BPE tokenization map is a composition of binary merge decisions, each of which is a semi-algebraic comparison (pair match = equality test on discrete symbols). The embedding lookup is a piecewise-linear map (one-hot → embedding matrix multiplication). Both are definable in R_{an,exp} via Tarski-Seidenberg (semi-algebraic sets) and the piecewise structure. **CONJECTURE: C1 holds** — the tokenized loss landscape is definable in R_{an,exp}.

### C2: Singular fiber structure
- **Fiber**: For a fixed tokenizer T and embedding matrix E, the fiber over a prediction y is the set of all (E, T) pairs producing y. Since T is fixed (not learned during training), the singularity is in E-space: the embedding lookup E[·] creates a piecewise-linear map with rank-deficient points (when multiple tokens map to similar embeddings).
- **Degenerate fiber**: When two token IDs have identical embeddings (E_i = E_j), the fiber has enhanced symmetry — permutation symmetry between tokens i and j. This is the singular stratum.
- **Tokenization boundary strata**: When a small change in input text crosses a token boundary, the prediction jumps. These boundaries form the singular locus in input space.

### C3: RLCT phase transition with vocabulary size V
- Small V → coarse tokenization → large degenerate fibers → high RLCT (many tokens map to same representation)
- Large V → fine tokenization → small fibers → lower RLCT but more parameters (overfitting)
- Optimal V* where the RLCT-phase-transition trades off generalization (low RLCT) vs capacity (high V)
- **CONJECTURE**: There exists V* such that generalization is optimal. Below V*, RLCT is too high (under-segmentation). Above V*, parameter count dominates (overfitting).

### C4: Generalization bound
The WBIC / free energy bound applies with the tokenization-induced singular structure. The effective dimension (RLCT) modulates the generalization gap. Key insight: tokenization acts as a **preconditioner** on the loss landscape — it determines which directions in input space are "visible" to gradient descent. Poor tokenization creates blind spots (directions along which the loss is flat because the tokenizer doesn't distinguish them).

### C5: Interaction with other techniques
- **Distinct from #94 (in-context learning)**: that was about the model's use of context, not the input encoding.
- **Distinct from #194 (quantization)**: that was about parameter precision, not input discretization.
- **Distinct from embedding learning generally**: tokenization is the discrete partition BEFORE embedding.
- **Connection to #221 (BatchNorm)**: both involve normalization/smoothing of the loss landscape, but tokenization creates the partition rather than smoothing it.
- **Connection to #377 (noise injection)**: tokenization noise (random token drops) would interact with the boundary singularities.

### Open Problems
1. How does the BPE merge order affect the singular structure? Different merge orders create different partition trees → different RLCT.
2. Is the RLCT monotonic in V? Or are there non-monotonic regimes?
3. Can we estimate the RLCT of a tokenizer empirically (e.g., via SGLD on a fixed model with varying V)?
4. How does byte-level vs character-level vs word-level tokenization differ in RLCT?
5. Does the tokenization boundary singularity affect adversarial robustness (perturbations crossing token boundaries)?
6. Multi-token concepts: when a concept spans multiple tokens, the fiber is a product of token fibers — how does this compose?
7. Tokenization-free models (e.g., byte-level models): do they have qualitatively different RLCT?
8. Interaction with RoPE (#224/#490/#504): positional encoding on top of tokenization creates a product of singular structures.

### Cross-References
#94 (in-context), #194 (quantization), #221 (BatchNorm), #377 (noise injection), #224/#490/#504 (RoPE/positional), #99 (SGD), #16 (general SGD theory), #169 (dropout)pin STATE: #564 Tokenization/BPE × RLCT L0 WRITTEN to /tmp/Oma_folio/synthesis/s564-tokenization-bpe-rlct-L0.md. Next: L1 formalization. Cycle 5/5. Silent.