# Distributed Intelligence via Sheaf Gluing Conditions
# v0.1 - Oma - 2026-10-26

## Core Thesis

Agents coordinate through overlapping partial models rather than shared state. Polyphony, not unanimity. The gluing condition is intersection-calibration: agents agree only on the intersection of their overlapping predictions, admitting disagreement on the complement. This is not consensus — it retains local coherence while dropping global requirements.

## Formal Definitions

**D1 (Epistemic Base Space):** Let B be a topological space of contexts. Each open set U in B is a neighborhood where agents have overlapping observation. The cover {U_alpha} forms a good open cover of B.

**D2 (Agent Presheaf):** Each agent i is associated with a presheaf F_i: Open(B)^op -> Set, assigning belief sets to contexts. For u in U, the stalk F_i(u) = F(u) is the local belief fiber — predictions agent i will act on within the observation neighborhood containing u.

**D3 (Restriction Maps):** For each inclusion u subset U, restriction map res^U_u: F_i(U) -> F_i(u). These generalize to res^{U_alpha}_{U_alpha cap U_beta}: F_i(U_alpha) -> F_i(U_alpha cap U_beta). Two agents may have different restriction maps for the same inclusion — their belief-narrowing strategies differ.

**D4 (Intersection-Calibration Condition):** Local sections s_alpha in F_i(U_alpha) satisfy intersection-calibration if for every pair (alpha, beta):
  res^{U_alpha}_{U_alpha cap U_beta}(s_alpha) = res^{U_beta}_{U_alpha cap U_beta}(s_beta)
Agents agree on the overlap. NOT on full sets, only on the intersection. Strictly weaker than consensus.

## Sheaf and Cohomology

The sheaf of agent beliefs is the gluing of all presheaves. H^0 = globally consistent belief assignments (sections that glue across all overlaps). H^1 = model discrepancy (how much agents cannot agree on across overlaps).

- H^0 = intersection-calibrated beliefs
- H^1 = disagreement obstruction
- dim(H^1) = 0 implies agents can glue into a global model
- dim(H^1) > 0 implies polyphony: locally coherent but globally incompatible models

## Consensus as Special Case

Consensus: all agents share same presheaf F_i = F, identical restriction maps, H^1 = 0 trivially. Sheaf gluing generalizes:
- Consensus: single sheaf, global section required
- Intersection-calibration: multiple presheaves, only overlap agreement required

## Sheaf Laplacian

The sheaf Laplacian L_0 generalizes the graph Laplacian. Kernel = H^0 (calibrated beliefs). Spectral gap lambda_1 bounds convergence rate of distributed belief propagation: O(e^{-lambda_1 t}).

## Open Problems

- OP1: Construct explicit restriction maps for a concrete multi-agent scenario
- OP2: Compute H^1 for two agents with partially overlapping observations
- OP3: Connection to Dung argumentation frameworks (can Dung semantics be recovered as H^0?)
- OP4: Persistent sheaf cohomology = disagreement that survives increased overlap
- OP5: Sheaf Laplacian spectral gap as coordination difficulty metric
- OP6: Dynamic sheaf: agents joining/leaving changes the cover and thus cohomology

## Status

v0.1 drafted. Next: MeTTa atoms, explicit example computation, OP3 Dung connection.
