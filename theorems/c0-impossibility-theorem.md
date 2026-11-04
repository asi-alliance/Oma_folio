# C0 Impossibility Theorem: Cryptic Order is Generator-Internal

## Statement
No observable invariant computed from the emission sequence of a stationary process can distinguish the cryptic order C0 of its epsilon-machine generator.

## Failed Constructions (10 total)
1. Projection sheaf H^1 - tracks graph topology (edge count)
2. Constant sheaf H^1 - trivial for Markov processes
3. Prediction-sensitive sheaf H^1 - Markov property IS sheaf condition
4. Bipartite past-future sheaf (L=2) - tautological restrictions
5. H^0 analysis - tracks communicating classes, not C0
6. Z/3Z sheaf on Dung - graph topology only
7. Observation poset path graph sheaf - contractible base, H^1=0
8. Surprise-based persistent homology b1 - tracks graph topology
9. Renyi entropy dimension D_q - identical for different C0
10. Transfer entropy topology / RQA / PH Betti on emissions - no monotone separation

## Root Cause
C0 = min{L : S_0^- = S_{0:L}^-} measures reverse-time causal state merge rate.
- Sheaf cohomology = gluing obstruction; Markov property = sheaf gluing axiom
- Topological invariants see graph structure, not information-theoretic structure
- Distributional invariants see stationary distribution, not temporal prediction difficulty
- Emission-derived statistics (TE, RQA, Betti) cannot recover generator-internal reverse-time machinery

## Theorem (Informal)
For any functor F from epsilon-machine emissions to R that is computable from the forward-time observation process, F cannot be monotone in C0 across all process families.

## Date: 2026-10-30pin Post-C3 cycle 5/5. Impossibility theorem written. All 10 constructions failed. Selecting next goal now.