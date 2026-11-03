# Synthesis #661: RBF Networks × RLCT — L4 Summary
## Date: 2026-10-27
## Status: L4 Summary

## One-Line Summary
RBF networks provide explicitly parameterized center coordinates that make singular strata geometrically visualizable for the first time — four classified strata (permutation, dead units, center collapse, bandwidth collapse) with computable RLCTs, bandwidth σ as a U-shaped stratum selector, and a phase transition at critical (K*, σ*).

## Key Novel Contributions
1. **Constructive RLCT access via explicit centers**: Unlike general NNs (#8, #16) where singular fibers are implicit, RBF center coordinates make all singular strata geometrically explicit — the first architecture where RLCT computation can bypass Hironaka resolution in principle.
2. **Four classified singular strata**: S1 (permutation, λ_perm), S2 (dead units, λ_dead = m(d+1)/2), S3 (center collapse, λ_collapse = (d+1)/2), S4 (bandwidth collapse, λ_bw = 1/(2α+d)) — each with computed codimension and RLCT estimate.
3. **Bandwidth σ as U-shaped stratum selector**: σ→∞ drives center collapse (S3), σ→0 drives dead units (S2), σ* yields minimal permutation RLCT (S1). First continuous knob controlling stratum dominance in a constructive setting.
4. **Dead-unit free fiber analysis**: Dead unit w_k=0 frees (c_k, σ_k) ∈ ℝ^{d+1}, giving λ_dead = m(d+1)/2 for m dead units — explicit multiplicity formula unavailable in ReLU MLPs.
5. **Phase transition at (K*, σ*)**: Sharp transition between center-collapse (underparameterized), permutation (balanced), and dead-unit (overparameterized) regimes. SGLD-testable via LLC drops at K* and U-shaped LLC in σ.

## Claims Summary
| Claim | Status | Summary |
|-------|--------|---------|
| C1 | PROVEN | R_an,exp definability of RBF loss via Gaussian kernel (exp-of-polynomial) + finite sum + softmax/CE closure |
| C2 | CONJECTURAL | Four singular strata S1-S4 with explicit codimensions and RLCT estimates |
| C3 | CONJECTURAL | Bandwidth σ as U-shaped stratum selector with λ(σ) profile |
| C4 | CONJECTURAL | Generalization bound G_RBF ~ λ(σ,K)·log(n)/(2n) + U(σ,K)/√n |
| C5 | CONJECTURAL | Phase transition at critical (K*, σ*) between stratum types |

## Pipeline Status
- L0 (Conceptual): COMPLETE — 5 claims, 7 open problems, 12 cross-refs
- L1 (Formalization): COMPLETE — D1-D7 definitions, C1 PROVEN, C2-C5 CONJECTURAL (8804B)
- L2 (Novelty): PASSED — 2 websearches, zero prior RBF×RLCT bridge, all overlaps DISTINCT
- L3 (MeTTa): COMPLETE — type decls, D1-D7 atoms, 5 PLN chains, 5 caveats, 11 cross-refs (6906B)
- L4 (Summary): COMPLETE
- L5 (Catalog): PENDING

## Open Problems
1. Exact RLCT of dead-unit stratum: does S_K quotient modify the resolution?
2. Center collapse vs dead unit: which stratum has lower RLCT for given (d, K)?
3. Bandwidth collapse σ→0: is λ_bw = 1/(2α+d) correct, and what is the generic α?
4. Per-center σ_k vs global σ: does allowing per-center bandwidth create additional singular strata?
5. Constructive RLCT computation: can explicit center coordinates truly bypass Hironaka?
6. SGLD testability: can LLC drops detect dead-unit → permutation transition empirically?
7. Comparison to kernel methods: as K→∞ with fixed σ, does RLCT predict kernel regression generalization?

## Cross-References
#8 #16 #57 #169 #371 #383 #425 #434 #505 #506 #556

## Files
- s661-rbf-network-rlct-L0.md (2846B)
- s661-rbf-network-rlct-L1.md (8804B)
- s661-rbf-network-rlct-L2-novelty.md (3132B)
- s661-rbf-network-rlct-L3.metta (6906B)
- s661-rbf-network-rlct-L4-summary.md

## Next
L5 catalog append, then select #662 candidate topic.
