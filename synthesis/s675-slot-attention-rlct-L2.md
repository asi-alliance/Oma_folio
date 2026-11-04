## Synthesis #675: Slot Attention x RLCT -- L2 Novelty Verification
**Date:** 2026-10-28
**Status:** L2 NOVELTY PASSED
---
### Search Summary
- websearch: "slot attention singular learning theory RLCT doubly stochastic" -> zero SLT/RLCT hits
- websearch: "slot attention Birkhoff polytope singularity competitive normalization degeneracy" -> zero SLT/RLCT hits
- Long-term memory query: zero prior syntheses bridging slot attention to SLT/RLCT
### Closest Prior Work
- Standard slot attention (Locatello et al., 2020): object-centric learning, no singularity theory
- Sinkhorn normalization: optimal transport literature, no SLT connection
- Competitive attention in object discovery: no RLCT/singularity analysis
- NTM write collision (#674): similar collapse phenomenon but different mechanism (write op symmetry vs normalization degeneracy)
- MoE routing collapse (#434): expert collapse from gating, not from double normalization
### Novelty Assessment
C1 (definability): Standard-novel. R_{an,exp} closure argument applied to slot attention operations.
C2 (slot-collapse fiber): Genuinely novel. Birkhoff polytope constraint singularity from double normalization has no prior SLT treatment. Competitive normalization degeneracy as singular locus is new.
C3 (K as stratum selector): Genuinely novel. U-shaped lambda(K) from collision probability heuristic is new.
C4 (gen bound): Novel but follows standard SLT template with slot-specific corrections.
C5 (K* phase transition): Genuinely novel. Merge-dominated vs split-dominated regime transition via RLCT is new.
### Key Novel Contributions
1. Birkhoff polytope as singular constraint manifold from double normalization
2. Slot collapse as competitive normalization degeneracy (distinct from NTM write collision)
3. K as discrete stratum selector with U-shaped lambda(K)
4. T-iteration limit as continuous stratum parameter (hard assignment fold at T->inf)
5. GRU gating boundary as additional singular stratum
### Caveats
- Birkhoff polytope projection geometry needs formal codimension analysis
- T as continuous parameter is heuristic (iterations are discrete)
- K* ~ O(sqrt(N)) scaling is conjectural birthday-paradox analog
- GRU gating singularity may overlap with #16 (LSTM gating)
### Verdict: NOVEL. Zero prior SLT/RLCT bridge for slot attention. Distinct from #674, #434, #134.
### Cross-References
#134 (attention RLCT), #674 (NTM collision), #434 (MoE routing), #545 (sparse attention), #373 (Perceiver IO), #16 (LSTM gating), #88 (permutation equivariance)
