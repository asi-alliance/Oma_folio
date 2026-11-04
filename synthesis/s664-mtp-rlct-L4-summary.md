# Synthesis #664: Multi-Token Prediction (MTP) x RLCT -- L4 Summary (2026-10-28)

## Overview
Bridges Multi-Token Prediction (DeepSeek V3 style auxiliary heads) with Singularity Learning Theory via RLCT. Key insight: MTP auxiliary loss creates intersection of D zero-loss varieties under shared backbone, with depth D and weight alpha as dual stratum selectors.

## Claims Status
- C1 PROVEN: L_total is R_{an,exp}-definable (CE loss + transformer backbone + piecewise embedding/argmax all definable)
- C2 CONJECTURAL: V_0^MTP = intersection V_0^(d) has lower RLCT than V_0^next under partial non-transversality from shared backbone
- C3 CONJECTURAL: Training/inference RLCT gap -- teacher forcing (polynomial chain) vs self-prediction (piecewise cascade) creates distinct singularities
- C4 CONJECTURAL: Depth D as discrete stratum selector with U-shaped lambda_MTP(D), optimal D* in {2,3}
- C5 CONJECTURAL: Alpha phase transition at alpha* ~ lambda_next / lambda_MTP(D), switching dominant singularity

## Key Novel Contributions
1. Zero-loss set intersection structure unique to shared-backbone multi-head prediction
2. Causal chain cascade singularity (training vs inference gap) -- no prior synthesis covers this
3. Joint (alpha, D) stratum selection with phase transition
4. Generalization bound G_MTP(n,D,alpha) with lambda_eff interpolation and cascade cost U(D,alpha)

## Open Problems (8)
1. Exact RLCT of V_0^MTP intersection for specific architectures
2. Transversality of V_0^(d): generic vs shared-backbone structure
3. Cascade fiber RLCT under self-prediction
4. Optimal D* derivation from dG/dD = 0
5. Joint (alpha, D) optimal curve
6. Rigorous proof of lambda_MTP <= lambda_next
7. Shared vs independent backbone effect on RLCT
8. MTP as implicit self-distillation connection to #334

## Cross-References (14)
#334 #538 #468 #599 #362 #8 #16 #100 #226 #359 #433 #663 #302 #292

## Pipeline Status: L0-L4 COMPLETE. Next: L5 catalog append.