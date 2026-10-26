# Synthesis #606: RMSProp × RLCT — L1 Formalization
## Date: 2026-10-25
## Status: L1 Formalization

## D1: Parameter Space and Update Map

Let w ∈ R^d be parameters, L(w) the empirical loss (definable NN composition).
Gradient g_t = ∇L(w_t) ∈ R^d (definable, composition of definable functions).
EMA squared gradient: E_t = γ·E_{t-1} + (1-γ)·g_t², with E_0 = 0, γ ∈ [0,1).
Preconditioner: D_t = diag(E_t + ε)^{-1/2}, ε > 0.
Update map: Φ_t(w_t, E_t) = (w_t - η·D_t⊙g_t, γ·E_t + (1-γ)·g_t²).

## D2: EMA Squared Gradient (Bounded-Memory, Reversible)

Unlike Adagrad's G_t = Σ_{k≤t} g_k² (monotonic, irreversible), RMSProp's E_t satisfies:
E_t = (1-γ) Σ_{k=0}^{t} γ^{t-k} g_k².
The effective memory horizon is H_eff = 1/(1-γ) steps.
Key property: E_{t,i} can DECREASE if recent |g_{t,i}| drops below the EMA average.
This makes D_{t,i} = (E_{t,i}+ε)^{-1/2} non-monotonic — parameters can unfreeze.

## D3: Diagonal Preconditioning Metric (Non-Monotonic)

D_t = diag(E_t + ε)^{-1/2} defines a time-dependent Riemannian metric.
Unlike Adagrad's monotonic D_t (only shrinking), RMSProp's D_t can expand
in directions where gradient magnitude drops. The metric is:
- Definable in R_{n,exp} (same argument as Adagrad C1).
- Non-monotonic: ∃ t, i such that D_{t+1,i} > D_{t,i}.
- Bounded: D_{t,i} ∈ [ε^{-1/2}·(1-γ)^{-1/2}·max_k|g_{k,i}|^{-1}, ε^{-1/2}]
  (bounded by ε floor and peak gradient window).

## D4: Reversible Frozen Set

Define the active set A_t = {i : E_{t,i} > τ(t)} and frozen set S_t = {i : E_{t,i} ≤ τ(t)}.
Unlike Adagrad (|S_t| monotonically non-decreasing), RMSProp's S_t satisfies:
|S_{t+1}| can be < |S_t| (parameters re-enter active set).
The frozen fraction f_t = |S_t|/d oscillates around equilibrium f_eq(γ).
Equilibrium: f_eq(γ) is the steady-state frozen fraction under stationary
gradient statistics, depending on γ and the gradient distribution.

## D5: Effective RLCT (Gamma-Dependent)

λ_eff(γ) = λ_0 · (d - |S_t|_eq) / d = λ_0 · (1 - f_eq(γ)).
Conjecture: f_eq(γ) is an increasing function of γ:
- γ → 0: f_eq → 0 (full exploration, λ_eff → λ_0, like SGD)
- γ → 1: f_eq → f_Adagrad (approaches Adagrad, λ_eff → λ_Adagrad)
Tradeoff: low γ = high λ_eff (more singular) but high adaptability;
high γ = low λ_eff (more frozen) but less adaptive.
Optimal γ* minimizes the generalization bound (see D6).

## D6: Generalization Bound

G_RMSProp(t) ≤ λ_eff(γ) / n + U(γ) / √n

where:
- λ_eff(γ) = λ_0 · (1 - f_eq(γ)) is decreasing in γ
- U(γ) captures the complexity of the oscillating fiber structure:
  U(γ) ~ C · (1-γ)^{-1/2} (more forgetting = more oscillation = higher U)
The bound has an optimal γ* satisfying:
dλ_eff/dγ |_{γ*} = -n^{-1/2} · dU/dγ |_{γ*}
Unlike Adagrad's λ_eff/n_eff tension (monotone tradeoff with t),
RMSProp's tradeoff is in γ-space and has a genuine interior optimum.

## D7: Smooth Crossover (No Sharp Phase Transition)

Unlike Adagrad's sharp phase transition t* ~ n^{1/(λ_0+1)}, RMSProp has
NO sharp transition because the EMA prevents irreversible freezing.
Instead, the frozen fraction f_t undergoes a smooth crossover:
f(t) → f_eq(γ) as t → ∞, with relaxation time τ_relax ~ 1/(1-γ).
SGLD prediction: LC trajectory is smooth (no kink), with LC variance
σ²_LC(γ) that is increasing as γ decreases (more oscillation).
The "breathing singularity" hypothesis: oscillating fiber rank creates
a singularity type that is neither fixed-stratum nor monotonic-projection.

## Claims (from L0, formalized)

C1 (PROVABLE) The RMSProp update map Φ_t is definable in R_{n,exp}.
Same composition argument as Adagrad: g_t definable, g_t² definable,
E_t = γ·E_{t-1} + (1-γ)·g_t² definable (affine combination),
(E_t + ε)^{-1/2} definable for E_t ≥ 0, ε > 0. Update definable.
The singular locus differs from Adagrad: the non-analytic points
(E_{t,i} = 0) are no longer monotonically growing — they form an
oscillating set definable as a semi-algebraic set with time-varying
membership.

C2 (CONJECTURAL) RMSProp creates a reversible stratum selector.
The EMA E_t has bounded memory H_eff = 1/(1-γ). Parameters can
re-enter the active set, creating an oscillating fiber structure
where F_eff(t) = D_t·F·D_t has time-varying rank that can both
increase and decrease.

C3 (CONJECTURAL) γ controls λ_eff via exploration-stability tradeoff.
Low γ = high adaptability = higher λ_eff. High γ = approaches Adagrad
= lower λ_eff. Optimal γ* minimizes the generalization bound.

C4 (CONJECTURAL) The generalization bound G_RMSProp(t) ≤ λ_eff(γ)/n +
U(γ)/√n holds with the stated γ-mediated tradeoff and interior optimum γ*.

C5 (CONJECTURAL) RMSProp does NOT exhibit sharp phase transition t*.
Smooth crossover with relaxation time ~1/(1-γ). SGLD shows smooth
LC trajectory without kink. "Breathing singularity" creates higher
LC variance than Adagrad's monotonic freezing.

## Open Problems

1. Is f_eq(γ) computable from gradient statistics? Does S_eq ~ 1-(1-γ)^{1/2}?
2. Does the oscillating fiber structure create a NEW singularity type
   ("breathing singularity")? What is its RLCT?
3. How does γ interact with batch size n? Is there a γ-n scaling law?
4. Is λ_eff(RMSProp) between λ_eff(Adagrad) and λ_eff(SGD)?
   Does Adam occupy a different regime (momentum adds another dimension)?
5. Can the breathing singularity be tested via SGLD LC variance?
   Prediction: Var(LC_RMSProp) > Var(LC_Adagrad) for same effective LR.
6. Is γ* ~ 1 - 1/λ_0? (faster forgetting for sharper landscapes)
7. Falsification: if SGLD shows identical LC trajectories for RMSProp
   and Adagrad (after controlling for effective LR), C2-C5 falsified.

## Cross-References
- #289/#304: Adam (EMA + momentum + bias correction)
- #605: Adagrad (irreversible freezing — DIRECT CONTRAST)
- #591: AdaBelief (belief discrepancy as denominator)
- #433: Weight Decay (variety modification)
- #604: One-Cycle LR (schedule-based selector)
- #516: K-FAC/Shampoo (full-matrix preconditioning)
- #354: SGD (vanilla baseline)
- #533/#553: Gradient Accumulation (noise-temperature)
- #559: SAM (perturbation-based flatness)
- #526: Schedule-Free (adaptive averaging)
- #298/#528: Orthogonal Initialization
- #415: Muon (O(d) projection)

