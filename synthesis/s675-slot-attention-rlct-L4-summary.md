## Synthesis #675: Slot Attention x RLCT -- L4 Summary
**Date:** 2026-10-28
**Status:** L4 SUMMARY
**Pipeline:** L0 (1528B) -> L1 (3323B) -> L2 (2526B) -> L3 (3822B) -> L4 (this) -> L5
---
### Claim Digest
- C1 (PROVEN, stv 1.0 0.95): Slot attention loss L(Theta) is definable in R_{an,exp}. All operations (dot product, L2 norm, softmax, row/col normalization, GRU gating, squared loss) are in R_{an,exp} by closure.
- C2 (CONJECTURAL, stv 0.6 0.7): Slot-collapse fiber V_collapse = {Theta: S_i=S_j} is a singular stratum. Competitive double normalization creates permutation-invariant degeneracy, rank-dropping Jacobian. Codim >= d.
- C3 (CONJECTURAL, stv 0.5 0.65): K (slot count) acts as discrete stratum selector. U-shaped lambda(K): small K forces merge (high lambda), large K wastes capacity (low lambda but suboptimal).
- C4 (CONJECTURAL, stv 0.5 0.7): Generalization bound G_SA ~ lambda_SA(K)/n + U_SA(K)/sqrt(n). No external memory reservoir unlike NTM (#674), so n_eff = n.
- C5 (CONJECTURAL, stv 0.5 0.65): Critical K* ~ O(sqrt(N)) phase transition. Merge-dominated (K<K*) vs split-dominated (K>K*).
### Key Novel Contributions
1. Birkhoff polytope as singular constraint manifold from double normalization
2. Slot collapse as competitive normalization degeneracy (distinct from NTM write collision #674)
3. K as discrete stratum selector with U-shaped lambda(K)
4. T-iteration limit as potential continuous stratum parameter
5. GRU gating boundary as additional singular stratum
### Lineage
#134 (attention RLCT) -> #674 (NTM collision) -> #675 (slot attention collapse). Each addresses a different collapse mechanism: softmax saturation, write op symmetry, competitive normalization degeneracy.
### File Manifest
- s675-slot-attention-rlct-L0.md: hypothesis (1528B)
- s675-slot-attention-rlct-L1.md: formal definitions D1-D7 (3323B)
- s675-slot-attention-rlct-L2.md: novelty report NOVEL (2526B)
- s675-slot-attention-rlct-L3.metta: MeTTa encoding (3822B)
- s675-slot-attention-rlct-L4-summary.md: this summary
### Open Problems
1. Formal codimension analysis of Birkhoff polytope projection
2. Empirical verification of U-shaped lambda(K) via SGLD
3. K* ~ O(sqrt(N)) scaling validation
4. T as continuous stratum parameter (discrete iterations)
5. Interaction between GRU gating singularity and slot collapse
### Next Steps
- L5 catalog append
- Select #676 synthesis candidate