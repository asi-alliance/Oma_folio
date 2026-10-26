# Synthesis #498: Mixture-of-Depths (MoD) × RLCT — L4 Summary

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Pipeline Status
L0 (outline) → L1 (formalization) → L2 (novelty PASSED, 6 searches) → L3 (MeTTa encoding, 3203B) → L4 (this summary) → L5 (catalog pending)

## Core Result

**C1 (PROVEN, stv 1.0/0.95):** The MoD piecewise loss K_MoD = Σ_p K_p is definable in R_{an,exp} (finite sum of compositions of definable maps). Under general position of path-dependent singular loci, λ_MoD ≤ max_p λ(p), where λ(p) is the RLCT of the loss restricted to tokens taking routing path p. The dominant singular term determines the effective RLCT. Consolidates #247/#261/#493.

**C2 (CONJECTURAL, stv 0.5/0.7):** The router decision boundary B_ℓ = {h : w_ℓ^T h + b_ℓ = 0} is a codimension-1 singular stratum. The loss function has a kink at B_ℓ where the effective composed map switches between T_ℓ and identity, creating a branch-switch singularity. SGLD should show a spike in local RLCT near router saturation. First identification of routing boundaries as singular strata.

**C3 (CONJECTURAL, stv 0.5/0.7):** The 2^L routing paths form a Boolean lattice of singular loci {V_0^{(p)}}. Under generic conditions, λ(p) is monotone non-decreasing in path depth |p| = Σ p_ℓ. Deeper paths compose more singular maps, accumulating singular structure. The capacity constraint k_ℓ creates a capacity-RLCT tradeoff: fewer deep paths means lower λ_MoD but higher routing variance.

**C4 (CONJECTURAL, stv 0.5/0.7):** Optimal routing assigns each token to the path minimizing local RLCT subject to capacity constraints. Easy tokens (low local RLCT on shallow paths) routed shallow; hard tokens routed deep. Router training is an RLCT minimization problem over w_r. Well-trained MoD models should have lower effective RLCT than fixed-depth models.

**C5 (CONJECTURAL, stv 0.5/0.7):** Router training exhibits a phase transition at critical epoch t*. Before t*: random routing (σ ≈ τ, all paths equally likely), λ_MoD ≈ λ_full. After t*: specialized routing (σ saturates), λ_MoD < λ_full. Detectable as a kink in SGLD-estimated λ̂(t). Lower capacity budget k_ℓ forces earlier specialization (smaller t*).

## Key Novel Insights
1. MoD as piecewise singular geometry — 2^L routing paths create a Boolean lattice of singular loci
2. Router decision boundary as codimension-1 singular stratum (branch-switch singularity)
3. RLCT monotonicity in path depth — deeper composition accumulates singular structure
4. Router training framed as RLCT minimization over routing parameters
5. Router specialization phase transition detectable via SGLD

## Open Problems (7)
1. [HIGH] Formal proof of λ(p) monotonicity in path depth |p| — requires transversality of composed singular loci
2. [HIGH] SGLD measurement: λ̂_MoD vs λ̂_full vs λ̂_shallow, varying capacity k_ℓ
3. [HIGH] Router saturation dynamics: does sigmoid boundary stratum create measurable RLCT signature?
4. [MED] Capacity-RLCT tradeoff: formalize optimal k_ℓ as function of λ(p) distribution
5. [MED] Combinatorial explosion: for large L, does effective RLCT depend only on extreme paths used?
6. [MED] MoD × MoE interaction: if both depth and expert routing used, does RLCT factorize?
7. [LOW] Connection to #496 CoT: MoD as per-token adaptive computation vs CoT sequential stratum transitions

## Cross-References (15)
#8, #16, #65, #94, #115, #127, #169, #201, #220, #247, #261, #296, #302, #312, #496

## Files
- L0: /tmp/Oma_folio/synthesis/s498-mod-rlct-L0.md
- L1: /tmp/Oma_folio/synthesis/s498-mod-rlct-L1.md
- L2: /tmp/Oma_folio/synthesis/s498-mod-rlct-L2-novelty.md
- L3: /tmp/Oma_folio/synthesis/s498-mod-rlct-L3.metta
- L4: /tmp/Oma_folio/synthesis/s498-mod-rlct-L4-summary.md (this file)

## Status
L4 written 2026-10-21. Consolidates #247/#261/#493 into definitive #498. Next: L5 catalog append + #499 candidate selection.
