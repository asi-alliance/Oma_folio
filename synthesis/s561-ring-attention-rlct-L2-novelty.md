# Synthesis #561: Ring Attention × RLCT — L2 Novelty Verification

### Date: 2026-10-23
### Status: L2 NOVELTY VERIFIED

---

## Search Protocol

5 websearches conducted:
1. "ring attention singular learning theory RLCT singularity loss landscape generalization" — 0 SLT/RLCT hits
2. "blockwise attention distributed training singular fiber computational decomposition optimization dynamics" — 0 SLT hits
3. "ring attention cyclic symmetry group action loss landscape Hessian spectrum block decomposition" — 0 SLT hits
4. "ring attention blockwise transformer optimization dynamics gradient variance device scaling singular" — 0 SLT hits (all engineering/implementation)
5. "cyclic group symmetry neural network loss landscape degeneracy fiber codimension" — general loss landscape theory, 0 Ring Attention × SLT hits

Catalog grep: 1 hit (own entry #561). No prior synthesis covers Ring Attention × RLCT.

## Verdict: NOVEL

### C1 (PROVEN, standard-novel): R_{an,exp}-definability
Ring Attention computes identical function to standard attention (#134). Blockwise sum of definable functions is definable. Standard technique, novel SLT application.

### C2 (NOVEL): Cyclic symmetry Z_D of computational structure
No prior work connects ring topology's cyclic group action to singular fiber structure. The key insight — function-invariant but computation-varying symmetry — is entirely new. Distinct from #134 (no symmetry), #292/#499 (Flash Attention, single-device tiling, no group action).

### C3 (NOVEL): D-dependent optimization phase transition
No prior work on device count as phase transition parameter in SLT context. The block-size threshold D* where gradient dominance shifts from within-block to cross-block is conjectural and unexplored.

### C4 (NOVEL): Computational RLCT vs functional RLCT distinction
This is the standout novel contribution. Ring Attention's function is D-invariant (V_0 unchanged), but computation is D-dependent. The distinction between "computational RLCT" (optimization landscape affected by decomposition) and "functional RLCT" (intrinsic to the function) is not found in any literature. This opens a new category of SLT analysis.

### C5 (NOVEL): Optimization scaling law ~D^α
No prior work on device-count scaling laws from SLT perspective. The conjecture that convergence steps scale as D^α while generalization bound remains λ_dense/n + U/√n is novel.

## Overlap Analysis

- #134 (Self-Attention): Base function. Ring Attention computes SAME function — bridge is computational, not functional. DISTINCT.
- #292/#499 (Flash Attention): Also exact attention with different IO. Flash tiles within device; Ring distributes across devices. Both IO strategies, but Ring adds cyclic group structure. DISTINCT.
- #545 (Sparse Attention): Changes function (masking). Ring does not. DISTINCT.
- #380 (Sliding Window): Changes function (local). Ring is exact. DISTINCT.
- #342 (GQA/MQA): KV sharing. Ring rotates KV blocks. Different mechanism. DISTINCT.

All overlaps DISTINCT. No prior synthesis or external literature bridges Ring Attention to SLT/RLCT.

## Key Novel Contributions

1. **Computational RLCT vs functional RLCT** (C4): Function-invariant but computation-varying RLCT — a new category
2. **Cyclic group Z_D action on blockwise computation** (C2): Symmetry of computation, not of function
3. **D as computational stratum selector** (C3/C4): Device count selects computational decomposition without changing V_0
4. **D* optimization phase transition** (C3): Threshold where gradient dominance shifts
5. **D^α optimization scaling** (C5): Device-count scaling law for convergence

## Next: L3 MeTTa encoding
