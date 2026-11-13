## Synthesis #886: HMM x RLCT - L4 Plain-Language Summary

Date: 2026-11-09

## What is this about?

Hidden Markov Models (HMMs) are sequence models where hidden states evolve via a transition matrix A and emit observable symbols via an emission matrix B. We analyzed HMMs through Singular Learning Theory (SLT), specifically the Real Log Canonical Threshold (RLCT) -- a measure of how singular a model loss landscape is near its true parameters.

## Key Findings

### C1 (PROVEN): HMM loss is R_an,exp-definable
Forward variable alpha_t(i) is polynomial of degree 2t-1 by induction. Sum over states is polynomial. Log restricted to (0, inf) is restricted-analytic. RLCT exists and is finite.

### C2 (CONJECTURAL): Three singularity sources in HMM fiber
1. S_N permutation: relabeling hidden states (same as GMM #268)
2. Emission collision: B_i = B_j creates codim M-1 variety (new, no GMM analog)
3. Transition rank deficiency: A drops rank, determinantal strata (temporal, absent in GMM)

### C3 (CONJECTURAL): State count N is U-shaped stratum selector
lambda_eff(N) should be U-shaped: underfitting creates strong singularities, true N minimizes lambda, overfitting reintroduces singularities via redundant states. Predicts RLCS minimization as model selection criterion.

### C4 (CONJECTURAL): Generalization bound with temporal coupling
Gen_HMM <= lambda_HMM/n + U(N, rank, delta)/sqrt(n), where U includes emission collision and transition rank contributions absent in GMM bound (#268).

### C5 (CONJECTURAL): Emission distinguishability phase transition
As delta_em -> 0, RLCT jumps discontinuously. SGLD shows staircase as states merge. Distinct from ICA Gaussianity staircase (#885).

## What is new?
- Emission collision variety (codim M-1) is new singular fiber type
- Transition rank deficiency as determinantal singularity is new for HMMs
- U-shaped N selector gives principled model selection via RLCT
- Closest external: Rosen-Cuenca (2024) HMM identifiability -- algebraic geometry, NOT SLL

## What is unproven?- Exact RLCT at emission collisions needs resolution of singularities- Transition rank deficiency RLCT needs HMM-specific determinantal resolution (#622)- U-shaped lambda_eff(N) continuity unproven- Continuous (Gaussian) emissions need density definability extension- EM stratum trapping conjectural, no SGLD experiment yet

## Cross-references
#8 #16 #49 #69 #86 #88 #91 #114 #268 #622 #885

Status: L4 SUMMAY COMPLETE 2026-11-09. Next: L5 catalog append.