#483 Dynamical vs Static RLCT — L0 EXPLORATION
Date: 2026-10-21
Status: EXPLORATION
Extends #482 C2 gap. Connects to SGLD/LLC measurement (#482 open problem #7).

## Motivation
Standard RLCT (Watanabe 2009) is defined on the asymptotic posterior pi_n(w|D_n) as n->infinity. It is a STATIC property of the loss landscape geometry at the singular set W={w:K(w)=0}. However, training dynamics (optimizer, LR schedule, regularization) determine WHICH singular fiber is reached by the trajectory w(t). The effective complexity experienced during training is therefore TRAJECTORY-DEPENDENT — a dynamical quantity lambda_dyn(t) that may differ from the static RLCT lambda_static.

This distinction was identified as an unresolved gap in #482 C2 and is implicitly assumed by #236 (early stopping), #394 (SWA), #410 (SGDR), #420 (Lookahead), #213 (LR scheduling), #386 (warmup).

## Definitions (Draft)
- D1: Static RLCT lambda_static = standard Watanabe RLCT of K(w) at W
- D2: Singular fiber strata S_1 ⊃ S_2 ⊃ ... ⊃ S_k (nested by RLCT: lambda(S_1) > lambda(S_2) > ... > lambda(S_k))
- D3: Training trajectory w(t) = discrete map defined by optimizer (SGD/Adam/SAM/etc.)
- D4: Instantaneous fiber membership Sigma(t) = {S_i : w(t) in neighborhood of S_i}
- D5: Dynamical RLCT lambda_dyn(t) = lambda(Sigma(t)) = RLCT of the stratum containing w(t)
- D6: Trajectory-averaged dynamical RLCT: bar(lambda)_dyn = (1/T) sum_t lambda_dyn(t)
- D7: Stratum crossing time t_cross(i->j) = first t where Sigma(t) moves from S_i to S_j

## Claims
C1 (PROVEN): Static RLCT lambda_static exists and equals standard Watanabe RLCT. This is the reference quantity.
C2 (CONJECTURAL): Dynamical RLCT lambda_dyn(t) is well-defined via instantaneous fiber membership Sigma(t). For any definable trajectory w(t), lambda_dyn(t) is a piecewise-constant function taking values {lambda(S_i)}.
C3 (CONJECTURAL): lambda_dyn is optimizer-dependent: different optimizers (SGD vs Adam vs SAM) produce different trajectories reaching different strata, yielding different lambda_dyn profiles. SAM biases toward low-lambda strata (#482), SGD may overshoot.
C4 (CONJECTURAL): Generalization bound with dynamical RLCT: G_dyn <= bar(lambda)_dyn / n + O(1/sqrt(n)). When bar(lambda)_dyn < lambda_static, dynamical regularization provides tighter bound than static SLT predicts.
C5 (CONJECTURAL): SGLD-measurable phase transition: LLC measured at checkpoint w(t_k) reflects lambda_dyn(t_k), not lambda_static. Discontinuities in LLC(t) across training indicate stratum crossings. Testable via SGLD v8 protocol (random walk MH, #367 breakthrough).

## Open Problems (7)
1. Formal definition of "neighborhood of S_i" for instantaneous fiber membership
2. Piecewise-constant assumption: is lambda_dyn truly stepwise or smooth?
3. Optimizer-dependent stratum selection: can we predict which stratum SGD/Adam/SAM reaches?
4. Relationship between bar(lambda)_dyn and the true generalization error
5. Measuring lambda_dyn via SGLD LLC at checkpoints — noise vs stratum crossing
6. Connection to finite-n RLCT (lambda as function of n, not just n->inf)
7. Does early stopping (#236) optimize bar(lambda)_dyn by truncating before high-lambda strata?

## Cross-references
#482 (SAM, C2 gap origin), #236 (Early Stopping), #394 (SWA), #410 (SGDR), #420 (Lookahead), #213 (LR Scheduling), #386 (Warmup)