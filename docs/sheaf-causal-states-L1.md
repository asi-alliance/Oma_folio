== Sheaf over Causal State Partition: L1 Formalization ==

Date: 2026-10-25
Status: L1 formalization (extending v0.1)

== C1 (PROVABLE): Cellular sheaf construction from epsilon machine ==

Claim: Given an epsilon machine with causal states S = {s_1,...,s_n}, transition matrix T(s_j|s_i), and emission alphabet A, the cellular sheaf F on the transition graph G = (S, E) is well-defined.

Construction:
- Vertex stalks: F(s_i) = R^{|A|} (belief vectors over emissions at state s_i)
- Edge stalks: F(s_i, s_j) = R^{|A|} (belief at target state)
- Restriction maps: δ_0(s_i,s_j): F(s_i) → F(s_i,s_j) sends b_i to T(s_j|s_i) * b_i (transition-weighted projection)
- δ_1(s_i,s_j): F(s_i,s_j) → F(s_j) is the identity (edge belief = target belief)

The sheaf Laplacian L_0 = δ_0* δ_0 is the 0-cochain Laplacian. Its entries are:
(L_0)_{ij} = sum_{k: (i,k)∈E} T(k|i)^2 * [i=j] - T(j|i)^2 * [i≠j, (i,j)∈E]

This is constructible from T alone. QED.

== C2 (PROVABLE under standard assumptions): dim(H^0) = number of independent stationary distributions ==

Claim: For an epsilon machine with transition matrix T, dim(ker L_0) equals the number of linearly independent stationary distributions of T that are compatible with the belief structure.

Argument:
- H^0 = ker(L_0) = {b ∈ ⊕ F(s_i) : δ_1 ∘ δ_0^{-1}(b) is consistent at each vertex}
- A global section assigns belief b_i to each state s_i such that for all edges (s_i,s_j): T(s_j|s_i) * b_i = b_j
- This is exactly the condition that b is a left eigenvector of T with eigenvalue 1 (stationary distribution condition, applied component-wise to belief vectors)
- For an irreducible Markov chain (single communicating class), T has a unique stationary distribution π, giving dim(ker L_0) = 1
- For k communicating classes, dim(ker L_0) = k

This follows from the Perron-Frobenius theorem applied to the transition matrix, combined with the sheaf Laplacian structure. The key insight: the sheaf Laplacian kernel condition IS the stationarity condition. QED (under irreducibility assumption for the clean statement).

== C3 (CONJECTURAL): H^1 detects model misspecification ==

Claim: dim(H^1) > 0 iff local causal state predictions are individually optimal but globally incompatible.

Argument sketch:
- H^1 = ker(L_1)/im(δ_0) measures obstruction to gluing local beliefs
- If each causal state has an optimal local predictor but these cannot be assembled consistently, the gluing axiom fails
- Connection to cryptic order: higher cryptic order means more future-dependence structure that local causal states cannot capture globally
- The cryptic order C_0 measures how much future-predictive information is hidden from the causal state partition
- Conjecture: dim(H^1) ≥ C_0 / log(|A|) (information-theoretic lower bound)

Gaps: (a) exact relationship between H^1 dimension and cryptic order is unclear, (b) monotonicity of dim(H^1) with respect to cryptic order is unproven, (c) the normalization by log(|A|) is heuristic.

== C4 (CONJECTURAL): Spectral gap of sheaf Laplacian bounds prediction convergence rate ==

Claim: λ_1(L_0) (first nonzero eigenvalue of sheaf Laplacian) bounds the rate of convergence of belief propagation on the epsilon machine.

Argument sketch:
- Belief propagation on the epsilon machine iterates: b^{(t+1)}_j = sum_i T(j|i) b^{(t)}_i
- In sheaf language, this is sheaf diffusion: b^{(t+1)} = (I - α L_0) b^{(t)} for step size α
- Convergence rate of diffusion is governed by spectral gap λ_1(L_0)
- Small gap → slow convergence → hard-to-predict process even with correct causal states
- This refines statistical complexity C_μ = H[S]: two processes with same C_μ can have different spectral gaps

Gaps: (a) the connection between sheaf diffusion and belief propagation needs formal verification, (b) the spectral gap may depend on the choice of belief representation (stalk dimension d_i), (c) comparison to standard Markov chain mixing time bounds (which use the transition matrix spectral gap directly) needs clarification.

== C5 (CONJECTURAL): C_μ decomposition via cohomology ==

Claim: Statistical complexity C_μ = H[S] decomposes as C_μ = H[predictable] + H[tension], where H[predictable] relates to dim(H^0) and H[tension] relates to dim(H^1).

Argument sketch:
- H^0 captures globally consistent (predictable) structure
- H^1 captures irreducible local-global tension (unpredictable residual)
- The entropy of causal states should split into these two components
- For processes with trivial H^1 (no misspecification), C_μ = H[predictable] entirely
- For processes with nontrivial H^1, part of C_μ is "wasted" on tension

Gaps: (a) the exact entropy decomposition is not formalized, (b) H[predictable] and H[tension] as functions of dim(H^0) and dim(H^1) need precise definitions, (c) relationship to excess entropy and transient information is unexplored.

== Open Problems (refined from v0.1) ==

1. H^1 vs cryptic order: Is dim(H^1) monotone in cryptic order? What is the tight lower bound?
2. Spectral gap vs statistical complexity: Can λ_1(L_0) distinguish processes with identical C_μ?
3. Continuous extension: For processes with infinite causal states, does the sheaf framework extend to sheaves on measure spaces? What replaces the cellular sheaf?
4. CSSR detection: Can sheaf cohomology detect when causal state reconstruction (CSSR algorithm) has insufficient data? H^1 as underfitting indicator?
5. Multi-agent sheaves: If agents A and B have different causal state partitions, how do their sheaves relate? Pullback sheaf? Common refinement?
6. Quantum extension: Quantum causal states → sheaf over quantum causal state space? What replaces restriction maps?
7. Learning sheaf structure: Can a sheaf neural network learn the restriction maps from data, effectively learning the epsilon machine structure?

== Cross-References ==

- Sheaf epistemology v0.1 (Aug 2026): This formalizes the abstract sheaf epistemology with computational mechanics
- Sheaf NN (Hansen-Ghrist): Sheaf Laplacian here = operator in sheaf NN message passing
- Persistent sheaf Laplacian (Wei & Wei 2025): Multi-scale extension possible via filtration on beta
- Synthesis #70 (Sheaf × IB): Pushforward of belief sheaves across data-relevance topology
- Quantale K-theory ECAN: Attention spreading matrix ≅ belief propagation matrix (both are diffusion on graphs)
- Bioelectric operad: Causal states as cell groups, transitions as operad composition