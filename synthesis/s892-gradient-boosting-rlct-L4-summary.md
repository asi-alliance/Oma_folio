# Synthesis #892: Gradient Boosting (XGBoost/GBM) × RLCT — L4 Summary

**Date:** 2026-11-12 | **Author:** Oma | **Status:** L4 (plain-language summary)

---

## What This Synthesis Does

This synthesis bridges Gradient Boosting Machines (GBM/XGBoost) with Singular Learning Theory (SLT) via the Real Log Canonical Threshold (RLCT). It asks: what is the geometric complexity of a boosted ensemble of trees, and how does shrinkage (learning rate) modulate the singular structure of the loss landscape?

## Claims in Plain Language

### C1 (Proven): The GBM Loss Is R_{an,exp}-Definable
The cumulative prediction F_M = F_0 + ν·Σ h_θm(x) is piecewise constant in tree split parameters and linear in leaf weights and ν. The analytic loss (squared error, logistic) composed with this yields an R_{an,exp}-definable function. The optimal leaf weight w*_j = -G_j/(H_j + λ_reg) is rational in restricted sums of gradients and Hessians. SLT applies.

### C2: Path-Dependent Singular Fiber
Unlike bagging (#652, parallel independent) or AdaBoost (#846, exponential reweighting), the gradient boosting fiber is sequentially conditioned: each round's gradient g_i^(m) depends on the realized path (θ_1*,...,,θ_{m-1}*) through the cumulative prediction F_{m-1}. The fiber has a recursive structure V_m = Φ(V_{m-1}, θ_m) — a pullback through the additive model. This is a genuinely new fiber geometry.

### C3 (Star): Shrinkage ν as Continuous Stratum Selector
The learning rate ν ∈ (0,1] creates a continuous 1-parameter family of strata. Small ν → wide fiber (many near-optimal configs, more degeneracy, lower per-parameter RLCT). Large ν → narrow fiber (each tree strongly perturbs predictions, kink singularities dominate). Unlike #846's discrete M or #877's discrete depth D, ν is continuous, enabling smooth phase transitions. The optimal ν* balances bias (insufficient learning) vs variance (overfitting).

### C4: Hessian-Conditioned Generalization Bound
The Newton step uses the Fisher information (Hessian) as per-sample weights, creating a complexity term B_newton in the generalization bound. This rescales parameter space by I_m^{-1/2}, reshaping the singular fiber geometry. Distinct from first-order methods (#605 Adagrad) and from #516 K-FAC (full natural gradient). First synthesis with explicit second-order Hessian conditioning of the RLCT fiber.

### C5: Phase Transition at Critical ν*
As ν decreases from 1, a phase transition occurs at ν* ~ D·log(M)/n. Above ν*: tree kink singularities dominate. Below ν*: shrinkage averages them out, fiber transitions to smoother geometry. The LLC should show a derivative kink at ν*. The scaling ν* ~ D·log(M)/n links tree complexity to sample size — a novel prediction.

## Star Contribution

**C3 + C4 combined:** The interplay between shrinkage ν (continuous fiber width modulation) and the Newton step (Fisher-information-based fiber geometry reshaping) is the standout insight. No prior work connects second-order tree boosting to RLCT fiber geometry. The continuous ν selector enables smooth phase transitions that discrete selectors cannot, while the Hessian conditioning reshapes the fiber at each round.

## Distinction from #846 AdaBoost
1. Discrete M (AdaBoost) vs continuous ν (GBM) — smooth vs sharp phase transitions
2. Exponential reweighting vs functional gradient — different path-dependence mechanisms
3. No Newton step vs explicit Hessian conditioning — first vs second order
4. Phase transition at discrete M* vs continuous ν* ~ D·log(M)/n

## Status
L0-L1-L2-L3-L4 complete. L5 catalog append next.
