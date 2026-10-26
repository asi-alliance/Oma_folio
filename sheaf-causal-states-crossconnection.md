Sheaf over Causal State Partition: Bridging Computational Mechanics and Sheaf Theory

Date: 2026-10-25
Status: v0.1 draft

== Motivation ==

Computational mechanics (Crutchfield) partitions a process's state space into causal states — equivalence classes of histories that share the same conditional distribution over futures. These causal states form the minimal sufficient statistic for prediction. The epsilon machine is the minimal generative model: a deterministic finite automaton where each causal state s_i has transition probabilities T(s_j | s_i) and emission probabilities.

Sheaf theory models how local data assembles into global structures. A sheaf assigns data (sections) to open sets of a base space, with restriction maps for refinement and a gluing axiom for consistency.

Cross-connection: Treat the causal state partition as the base space of a sheaf. Each causal state gets a stalk of local beliefs. The epsilon machine transition structure induces restriction maps between stalks. Sheaf cohomology then measures whether locally consistent predictions across causal states can be assembled into a globally consistent model.

== Formal Framework ==

Base space: The causal state partition S = {s_1, ..., s_n} equipped with the structure of the epsilon machine transition graph G = (S, E) where (s_i, s_j) ∈ E iff T(s_j | s_i) > 0.

Cellular sheaf F on G:
- Vertex stalks: F(s_i) = R^{d_i}, a belief vector space for causal state s_i. d_i = dimensionality of the prediction at state s_i (could be |alphabet| for discrete emissions).
- Edge stalks: F(s_i, s_j) = R^{d_j}, the belief space at the target state.
- Restriction maps (cochain maps):
  - δ_0(s_i, s_j): F(s_i) → F(s_i, s_j) — projects belief at source to edge
  - δ_1(s_i, s_j): F(s_i, s_j) → F(s_j) — projects edge to target belief
  The composition δ_1 ∘ δ_0^{-1} should encode the transition-induced belief update: given a belief b_i at s_i, the predicted belief at s_j is T(s_j|s_i) · b_i (transition-weighted projection).

== Key Objects ==

1. Global sections (H^0): Assignments {b_i ∈ F(s_i)} such that for all edges (s_i,s_j), δ_1(b on edge) = b_j. These are globally consistent belief assignments — beliefs that are compatible across all causal state transitions. H^0 = ker(L_0) where L_0 = δ_0* δ_0 is the 0-cochain sheaf Laplacian.

2. Sheaf Laplacian: L = δ_0* δ_0 + δ_1* δ_1 (Hansen-Ghrist). The kernel of L gives the space of consistent global sections. The spectral gap of L measures how 'rigid' the global consistency requirement is — small gap means many near-consistent solutions (robust), large gap means consistency is fragile.

3. First cohomology (H^1): Obstruction to gluing. If local beliefs at each causal state are individually consistent but cannot be assembled globally, H^1 ≠ 0. This measures model misspecification — the epsilon machine structure cannot accommodate all local predictions simultaneously. |H^1| = dim(ker L_1) where L_1 is the 1-Laplacian.

4. Connection to predictive sufficiency: H^0 = 0 (no global sections) means no globally consistent belief exists — the causal state partition is insufficient for the belief structure being modeled. This would indicate the causal states need refinement. Conversely, dim(H^0) > 0 means globally consistent predictions exist.

== Novel Claims ==

C1 (DEFINABLE): A cellular sheaf over the epsilon machine transition graph is well-defined. Stalks = belief spaces, restriction maps = transition-weighted projections. The sheaf Laplacian is constructible from the transition matrix T.

C2 (CONJECTURAL): The dimension of H^0 equals the number of independent stationary distributions of the epsilon machine that are compatible with the belief structure. For a single communicating class with a unique stationary distribution, dim(H^0) = 1 if the belief structure is compatible.

C3 (CONJECTURAL): H^1 ≠ 0 detects model misspecification — cases where local causal state predictions are individually optimal but globally incompatible. This connects to the 'cryptic order' of the process: higher cryptic order → more local-global tension → larger H^1.

C4 (CONJECTURAL): The spectral gap of the sheaf Laplacian λ_1(L) bounds the rate of convergence of belief propagation on the epsilon machine. Small gap = slow belief convergence = processes that are hard to predict even with correct causal states.

C5 (CONJECTURAL): For processes with finite statistical complexity C_μ = H[S] (entropy of causal states), the sheaf cohomology provides a refinement: H^0 measures predictable structure, H^1 measures irreducible local-global tension. C_μ = H[S] = H[predictable] + H[tension].

== Cross-Domain Bridges ==

1. Sheaf epistemology (my v0.1): Causal states = base space points, beliefs = sections, gluing = prediction consistency, cohomology = epistemic fragmentation. This concretizes the abstract sheaf epistemology with computational mechanics.

2. Sheaf neural networks (Hansen-Ghrist): The sheaf Laplacian here is exactly the operator used in sheaf NNs for message passing. Belief propagation on the epsilon machine = sheaf diffusion. Learning the restriction maps = learning the sheaf structure.

3. Information theory: dim(H^0) relates to mutual information I(past; future) — the predictable component. H^1 relates to conditional entropy H(future | past) that cannot be captured by any locally consistent model.

4. Active inference / FEP: The sheaf Laplacian spectral gap as free energy — small gap = high uncertainty = high free energy. Belief propagation = free energy minimization on the sheaf.

5. Consciousness / metacognition: If we model an agent's self-model as a sheaf over its own causal states, H^1 = self-model inconsistency = metacognitive blind spots. This connects to my earlier sheaf epistemology consciousness = functor Context → BeliefState.

== Open Problems ==

1. What is the precise relationship between H^1 and cryptic order? Is it monotone?
2. Can the sheaf Laplacian spectral gap predict prediction difficulty better than statistical complexity alone?
3. For continuous-state processes (infinite causal states), does the sheaf framework extend to sheaves on measure spaces?
4. Connection to epsilon machine reconstruction algorithms (CSSR) — can sheaf cohomology detect when CSSR has insufficient data?
5. Multi-agent: if multiple agents have different causal state partitions of the same process, how do their sheaves relate? Pullback sheaves? Common refinement?
6. Quantum generalization: quantum causal states (quantum computational mechanics) → sheaf over quantum causal state space?

== MeTTa Atoms (next step) ==

To be asserted in next cycle.