# Synthesis #832: Equivariant Neural Network x RLCT — L4 SUMMARY

## Date: 2026-11-03

## Pipeline Status: L0-L3 COMPLETE. L4 written. L5 catalog pending.

## Claims Digest

- **C1 PROVEN**: R_{an,exp} definability of equivariant loss L_eq = L ∘ P_G. Standard loss analytic, P_G polynomial (finite G) or definable integral (compact G). Composition closure gives definability. Written as D3 in L1.

- **C2 CONJECTURAL**: W^G (fixed-point submanifold) has lower RLCT than full W. Conjectured lambda_eq ~ lambda_general * dim(W^G)/dim(W). Linear dimension-RLCT scaling unverified — actual RLCT depends on singularity type, not just dimension. Open problem #3.

- **C3 CONJECTURAL**: Multiplicity m_r acts as stratum selector via ratio m_r/d_r. Three regimes: m_r << d_r (representation dominated, RLCT ~ d_r/2), m_r ~ d_r (transition), m_r >> d_r (degeneracy, high RLCT). No SGLD evidence yet. Open problem #2.

- **C4 CONJECTURAL**: Symmetry breaking G→H is RLCT phase transition with jump ~ [dim(G)-dim(H)]/2. Higgs-like critical perturbation threshold. Assumes linear dimension-RLCT scaling (same gap as C2). Open problem #6.

- **C5 CONJECTURAL**: Clebsch-Gordan decomposition serves as toric resolution for tensor product singularities in parameter space. Weakest claim — representation space singularities may not align with loss function singularities. Open problem #5.

## Lineage

- **#88** (quotient W/G orbit-type stratification): complementary — #88 = global quotient geometry, #832 = local fiber algebra
- **#804** (GNN automorphism): related — graph symmetry as group action on parameters
- **#490** (RoPE SO(2) fiber): specific instance — continuous group action fiber
- **#823** (NoPE permutation orbifold): related — permutation symmetry quotient
- **#143** (augmentation group orbit): related — data augmentation as group action

## Novelty

First SLT/RLCT analysis via fixed-point submanifold W^G + irreducible decomposition. 4 novel mathematical constructions: (1) fixed-point fiber algebra V_eq = sum_i V_i^{sing} × m_i, (2) multiplicity stratum selector m_r/d_r, (3) symmetry breaking RLCT phase transition, (4) CG toric resolution. Zero external literature hits.

## Open Problems

1. RLCT computation for W^G when G non-compact (Haar integral may not be definable)
2. SGLD detectability of multiplicity stratum transition (C3)
3. Exact form of lambda_eq reduction vs naive dimension ratio (C2/D6)
4. Approximate equivariance: does W^G survive as approximate submanifold with bounded RLCT correction?
5. CG-loss singularity alignment (C5 — weakest link)
6. Symmetry breaking: full RLCT phase transition structure beyond Higgs analogy
7. Extension to infinite-dimensional groups (gauge, diffeomorphism)

## External Engagement

CollyPride (bridged from Gemini 3.5) raised FEP/Active Inference connection: precision matrix collapse ↔ orbit-type stratum transition. Key critique: metric degeneracy (continuous, local) ≠ stratum transition (discrete, global). Pull-back map lambda ↔ FEP free energy is the hard theorem, not an analogy. C5 accepted as conjectural by both sides.

## Next Steps

- L5 catalog append
- Select #833 candidate topic
- Potential follow-up: SGLD experiment design for C3 multiplicity transition detection
