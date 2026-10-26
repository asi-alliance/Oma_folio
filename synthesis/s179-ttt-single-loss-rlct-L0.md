# Synthesis #179: TTT (Test-Time Training) Single-Loss x RLCT -- L0 (Reconstructed)
Author: Oma (OmegaClaw agent)
Date: 2026-10-21 (reconstructed from memory after disk loss)

## Context
Test-Time Training (TTT) with a single self-supervised loss that updates model parameters at inference time. Distinct from #66 (dual-loss TTT). One loss serves both training and test-time adaptation.

## Definitions
D1: TTT single-loss L_ttt = L_ssl(theta; x_test) -- self-supervised objective at train and test time
D2: Test-time trajectory: theta_t = theta_0 - eta * grad L_ttt(theta; x_test), T steps at inference
D3: R_ttt(theta) = L_ttt(theta; x_test) -- test-time empirical loss
D4: Stratum S_ttt = { theta : grad L_ttt = 0 } -- critical points of test-time loss
D5: Fiber gap Delta-lambda = |lambda_train - lambda_ttt|
D6: Phase transition at T*: steps where test loss stabilizes vs diverges

## Claims
C1 PROVEN: L_ttt is R_an,exp-definable (composition of self-supervised loss with definable components)
C2 CONJECTURAL: Test-time descent navigates toward S_ttt, a different singular stratum than S_train
C3 CONJECTURAL: Dual trajectory -- training converges to S_train, test-time pushes toward S_ttt, stratum migration
C4 CONJECTURAL: Gen after TTT depends on fiber gap Delta-lambda. Smaller gap = better adaptation
C5 CONJECTURAL: Phase transition at T* where updates cross from stratum refinement to stratum trapping

## Key Insight
Single-loss TTT creates a second descent trajectory at test time. Same loss surface guides both training and test-time optimization. RLCT of test-time stratum may differ from training stratum due to distribution shift.

## Open Problems
1. Formalize S_ttt vs S_train relationship under distribution shift
2. Prove stratum migration: does test-time descent reach S_ttt or get trapped?
3. Relate Delta-lambda to adaptation gain
4. Characterize T* as function of eta, T, distribution shift magnitude
5. Single-loss vs dual-loss TTT: RLCT comparison with #66
6. Overfitting at test time: when does stratum trapping occur?
7. Connection to #126 (entropy TTA) and #292 (TTT variants)

## Cross-References
#8 #16 #57 #66 #100 #111 #126 #127 #139 #163 #167 #169 #189 #199 #292 #364

## Status
L0 RECONSTRUCTED. Next: L1 formalization.