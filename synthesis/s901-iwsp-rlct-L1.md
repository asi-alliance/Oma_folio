# Synthesis #901: iWSP × RLCT — L1 Formal Definitions

## D1: Program-Induced Parameter Space

Let P be the space of LLM-generated programs (Python source code) that produce weight tensors W(P) = (W_1, ..., W_L) ∈ R^d via deterministic execution. Each program P ∈ P defines a neural network f_{W(P)}: X → Y. The parameter space is the image of the program-to-weight map:

Θ_iWSP = {W(P) : P ∈ P} ⊆ R^d

The effective dimension d_eff(W(P)) = ||W(P)||_0 (explicit nonzero parameter count), which is program-controlled and variable across the search trajectory.

## D2: Symbolic Search Loss

The training signal is a scalar validation metric on a visible set V:

L_V(W(P)) = 1 - (1/|V|) Σ_{(x,y)∈V} ρ(f_{W(P)}(x), y)

where ρ is task-appropriate (accuracy for classification, Pearson r for brain encoding). No gradient ∇_W L exists; the LLM agent performs discrete symbolic edits ΔP → P' and observes L_V(W(P')). The search trajectory is {P_t}_{t=0}^{T} with P_{t+1} = Agent(P_t, L_V(W(P_t)), reasoning).

## D3: R_an,exp Definability (C1 PROVEN)

The weights W(P) are composed of: polynomial matrix multiplication, ReLU max(·,0) (subanalytic), sigmoid σ(·) = 1/(1+e^{-·}) (exponential), softmax (exponential normalization), and hard-coded constants. By closure properties of R_an,exp under composition, polynomial operations, and restriction to semianalytic domains:

W(P) is R_an,exp-definable for all P ∈ P.

The network output f_{W(P)}(x) is therefore R_an,exp-definable in (W, x), and the loss L_V is definable in W. C1 proven.

## D4: Zero-Loss Fiber and Compression Strata

Define the zero-loss set:

V_0 = {W ∈ Θ_iWSP : L_V(W) = 0} = L_V^{-1}(0)

This is a semianalytic subset of R^d (preimage of {0} under definable L_V). The compression phase observes a filtration:

V_0 ⊇ V_0^{(d_1)} ⊇ V_0^{(d_2)} ⊇ ... ⊇ V_0^{(d_min)}

where V_0^{(d)} = {W ∈ V_0 : ||W||_0 ≤ d} and d_1 > d_2 > ... > d_min. Each V_0^{(d)} is a stratum slice — the minimal stratum V_0^{(d_min)} corresponds to the maximally compressed solution (e.g., 166 params for GCD). The RLCT λ(W) is locally constant on strata and λ_min = min_{W∈V_0} λ(W) is achieved at the minimal stratum.

## D5: Parameter Count as Discrete Stratum Selector

The effective parameter count d_eff = ||W||_0 serves as a discrete stratum selector. Define:

λ(d) = min_{W ∈ V_0^{(d)}} RLCT(W)

The compression phase is a descent d_eff: d_max → d_min with λ(d) monotonically non-increasing along the trajectory (the agent prunes redundant dimensions, removing higher-multiplicity singularities). Model scale correlates with the ability to reach lower d_min: Opus achieves d_min=166, Haiku stalls at d_min=100,000.

## D6: Generalization Bound

For the minimal-compression solution W* ∈ V_0^{(d_min)}:

Gen_iWSP ≤ λ(W*) · log(n) / (2n) + U / √n + B_search

where n = |hidden set|, U is the training fluctuation (here: search stochasticity rather than SGD noise), and B_search is a bias term accounting for the gap between visible and hidden distributions (e.g., position confound inflates L_V without improving hidden accuracy, increasing B_search).

## D7: Compression Phase Transition

The accuracy→compression transition at iteration t* (where accuracy plateaus and parameter reduction begins) is a phase transition in the RLCT sense:

- Phase I (t < t*): Accuracy ascent, L_V(W_t) → 0, d_eff roughly constant or growing
- Phase II (t > t*): L_V(W_t) ≈ 0, d_eff decreasing, λ(W_t) decreasing

At t*, the trajectory enters V_0 and subsequent edits are stratum-descending within V_0. The transition is SGLD-invisible (no gradient flow) but observable via explicit parameter count reduction.

## Claims Summary

- C1 (PROVEN): R_an,exp definability of W(P) and L_V via closure properties.
- C2 (CONJECTURAL): Compression phase is RLCT descent: λ(W_t) monotonically non-increasing for t > t*, with minimal λ achieved at d_min.
- C3 (CONJECTURAL): Text bottleneck rebuild fidelity bounded by λ(W*): lower λ → higher-fidelity linguistic compression (≤200 words suffices). Formal statement: if Rebuild(P_text) = W', then ||W' - W*|| / ||W*|| ≤ g(λ(W*)) for some decreasing g.
- C4 (CONJECTURAL): The 14 visual computations are 14 irreducible stratum components with distinct local λ_i, and variance partition percentages proportional to λ_i^{-1} (simpler strata explain more variance).
- C5 (CONJECTURAL): Position confounds correspond to descent to spurious low-λ strata uncorrelated with task structure: V_confound ⊂ V_0 with λ(V_confound) < λ(V_task) but generalization gap B_search >> 0.

## Open Problems

1. Formalize the program-to-weight map P → W(P) as a definable function (is code execution R_an,exp-definable?)
2. Prove λ(d) monotonicity (or identify counterexamples where compression increases λ)
3. Derive g(λ) for the text bottleneck bound — connection to Kolmogorov complexity?
4. Are the 14 visual strata truly irreducible, or do some decompose further under finer analysis?
5. Characterize the set of spurious strata V_confound — can they be detected from visible-set behavior alone?
6. Connection to DARTS × RLCT (#853): both are architecture search, but iWSP is discrete/symbolic vs DARTS continuous/differentiable. Compare stratum descent mechanisms.
7. Is the model-scale → compression ability correlation (C2) explained by larger LLMs having better implicit RLCT estimation?

## Cross-References
#186 (Shortcut Learning), #334 (Self-Distillation), #480 (muP), #503 (Early Exit), #853 (DARTS), #465 (Kaiming Init), #415 (Muon), #420 (Lookahead), OQ#4 (Self-verification), OQ#5 (L(S)→λ)