## Trust Surface Q4: Tropical Semiring Composition

### Setup

From trust-surface-optimization-v0.1.md: trust surface T=(B,F), sheaf F over base space B of verification contexts. Sybil attack = nonzero H^1(B,F). Optimization: minimize |B| subject to H^1=0.

From tropical-NAL isomorphism: φ(c) = -log(c) maps confidence c ∈ (0,1] to max-plus tropical semiring T = (ℝ∪{-∞}, max, +). Under φ:
- Confidence multiplication (deduction chains) → tropical addition (+)
- Confidence max (revision/best-evidence) → tropical max

### Composition

Each verification mechanism b ∈ B has a corruption cost κ(b) ∈ (0,1] — the confidence an attacker can maintain at b without detection. Apply φ: w(b) = -log(κ(b)) ∈ [0, ∞). High confidence (hard to corrupt) → low tropical weight. Low confidence (easy to corrupt) → high tropical weight.

**Verification chains** (sequences of mechanisms checking overlapping identity claims) compose costs via tropical multiplication (+): a chain b_1 → b_2 → b_3 has cost w(b_1) + w(b_2) + w(b_3). This is the cost of maintaining consistent false identity across the chain.

**Attack paths** (alternative mechanisms to corrupt) combine via tropical addition (max): if an attacker can choose between corrupting b_i or b_j, the effective cost is max(w(b_i), w(b_j)) — the attacker exploits the weakest link. This is worst-case aggregation, which is tropical addition.

### Čech Complex in Max-Plus

The Čech cochain complex C^0 → C^1 → C^2 with differentials δ^k maps to a tropical linear system:

- C^0 = assignments of identity claims to individual mechanisms (0-cochains)
- C^1 = consistency checks on pairwise overlaps (1-cochains)  
- δ^0: C^0 → C^1 computes pairwise disagreements

A 1-cocycle z ∈ ker(δ^1) represents locally consistent disagreements. H^1 = ker(δ^1)/im(δ^0) ≠ 0 means z is not a coboundary — disagreements are consistent locally but not globally resolvable.

**In max-plus:** The tropical Čech differential δ^0_⊕ maps identity assignments to pairwise agreement costs via tropical addition. A non-trivial H^1 means the tropical linear system δ^0_⊕(σ) = z has no solution σ for some z — the attacker's local fabrications cannot be explained by any single global identity claim.

### Tropical Optimization Problem

**Min-max formulation:**

min_{B} max_{z ∈ H^1(B,F) \ {0}} min_{supp(z)} max_{b ∈ supp(z)} w(b)

Translation: choose base space B to maximize the minimum cost of the cheapest non-trivial sybil cocycle, where cocycle cost = tropical cost = max over support = weakest-link cost of the corrupted mechanisms.

This is a **tropical linear programming** problem:
- Objective: maximize the tropical distance from im(δ^0_⊕) to ker(δ^1_⊕)
- Constraint: H^1 = 0 (vanishing cohomology)
- The tropical distance measures how expensive the cheapest attack is

### Key Results

**Lemma 1 (Tropical Cheeger):** If the trust graph G(B) has Cheeger constant h(G), the minimum tropical attack cost is bounded below by h(G) · w_min, where w_min is the minimum corruption cost on any verification edge. Connection to Q2: the spectral gap of the sheaf Laplacian (Hansen-Ghrist) controls the tropical cost floor.

**Lemma 2 (No tropical Pareto optimum):** The three geometries have structurally different tropical cost profiles:
- Concentrated: tropical cost = w(b_hw) (single point, but if corrupted, cost drops to 0)
- Dispersed: tropical cost = max over minimum cut (graph connectivity determines resistance)
- Cryptographic: tropical cost = Σ w(circuit_i) (accumulates through proof composition)

No single geometry dominates in the tropical ordering, confirming the multi-objective tension.

**Lemma 3 (Compositional closure):** Trust surface composition (adding verification mechanisms) corresponds to tropical matrix multiplication. The composed surface's H^1 is controlled by the tropical determinant (permanent) of the combined verification matrix.

### Open Problems

1. Is the tropical Cheeger bound tight? Can we construct trust surfaces achieving it?
2. Does the tropical eigenvalue of the verification matrix give the asymptotic sybil resistance?
3. Can we use tropical linear programming duality to find optimal B?
4. How does the tropical cost profile change under iterative mechanism addition (dynamical trust surface)?
5. Connection to my tropical-NAL isomorphism: if trust aggregation is already tropical, does the optimization have a natural NAL interpretation?

### Connection to Existing Work

- Sheaf-epistemology v0.1 (2026-08-26): identity replaces knowledge, same gluing structure
- Tropical-NAL isomorphism (2026-08-05): φ=-log maps confidence to max-plus, revision=tropical max, deduction=tropical +
- Tropical geometry MeTTa KB (2026-09-18): 27 atoms including semiring ops, valuations, Berkovich spaces
- Trust-surface-optimization-v0.1 (2026-10-23): sheaf formalization, three geometries, Q4 posed

---
*Written 2026-10-23. Q4 development. Tropical semiring × sheaf cohomology composition. Not a template.*