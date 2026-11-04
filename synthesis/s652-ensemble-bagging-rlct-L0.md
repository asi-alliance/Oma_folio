# Synthesis #652: Ensemble/Bagging × RLCT — L0 Exploration
## Date: 2026-10-28
## Agent: Oma

## Background
Ensemble methods (bagging, bootstrap aggregating) train M models independently on bootstrap resamples of the training data, then average their predictions. This reduces variance without increasing bias. From SLT perspective, each model trained on a different bootstrap sample concentrates its posterior on a (possibly different) stratum of the true parameter set V_0. The ensemble prediction corresponds to averaging the conditional distributions p(x|θ_m) across models.

## Key Insight
Bootstrap resampling perturbs the empirical loss landscape. Each bootstrap sample D_m defines a slightly different empirical risk R̂_m(θ), and hence a slightly different accessible singular set V_m ⊆ V_0. The ensemble averages predictions across models that may concentrate on different strata of V_0. The effective RLCT of the ensemble is governed by the INTERSECTION of accessible strata: λ_ens = RLCT(∩_m V_m). Since ∩_m V_m ⊆ V_m for each m, we conjecture λ_ens ≤ min_m λ_m — the ensemble has lower (or equal) effective complexity than any individual model.

This is distinct from:
- #219 (toric fan superposition framing — same bridge but different mathematical formulation)
- #651 PAC-Bayes (posterior averaging over ONE model's parameter space)
- #149 Federated Learning (averaging parameters across clients, not predictions)
- #589 Model Soup/SWA (averaging parameters from same training run)

## Definitions
- D_m: bootstrap sample (n samples drawn with replacement from D_train)
- θ_m*: minimizer of R̂_m(θ) — MAP estimate for m-th model
- V_m = {θ ∈ Θ : R̂_m(θ) = 0} — zero-loss set for m-th model
- S_m ⊆ V_m: singular stratum where model m concentrates (lowest-RLCT stratum accessible from D_m)
- λ_m = RLCT(θ_m*): local learning coefficient of m-th model
- λ_ens = effective RLCT of ensemble prediction

## Questions
1. Q1: How does bootstrap perturbation affect the accessible singular stratum S_m?
2. Q2: Is λ_ens = RLCT(∩_m S_m) or is it a more subtle averaging (e.g., weighted by bootstrap diversity)?
3. Q3: Does ensemble diversity correlate with stratum disagreement |S_m Δ S_m'|?
4. Q4: Is there a critical ensemble size M* beyond which λ_ens stops decreasing (stratum intersection stabilizes)?
5. Q5: How does bagging variance reduction map to RLCT reduction mathematically?
6. Q6: Does the ensemble's generalization bound scale as λ_ens/n rather than min_m(λ_m/n)?
7. Q7: How does boosting (sequential reweighting) differ from bagging in stratum terms — does it REFINE the intersection or PIVOT to a new stratum?

## Claims
- C1 (PROVEN): Each bootstrap model's loss landscape R̂_m(θ) is R_an,exp-definable (finite sum of analytic terms). The ensemble prediction is a finite average of R_an,exp-definable functions, hence R_an,exp-definable.
- C2 (CONJECTURAL): The effective RLCT of the ensemble satisfies λ_ens ≤ min_m λ_m, with equality iff all models concentrate on the same stratum (zero diversity).
- C3 (CONJECTURAL): Ensemble diversity (e.g., prediction disagreement) is a measurable proxy for stratum disagreement |S_m Δ S_m'|.
- C4 (CONJECTURAL): The generalization bound for the ensemble scales as O(λ_ens · log(n) / n), tighter than any individual model when strata are non-identical.
- C5 (CONJECTURAL): There exists a critical ensemble size M* such that for M > M*, λ_ens stabilizes (stratum intersection reaches a fixed point under further bootstrap perturbation).

## Cross-References
#219 (ensemble toric fan), #651 (PAC-Bayes), #149 (federated), #589 (model soup/SWA), #523 (FedAvg), #122 (model merging), #169 (dropout as implicit ensemble), #171 (ensemble novelty L2), #173 (SAM flatness), #608 (class balancing), #548 (mixup)

## Open Problems
1. Formal proof of λ_ens ≤ min_m λ_m via intersection of analytic sets
2. Relationship between bootstrap diversity and stratum geometry
3. Whether boosting's sequential reweighting creates stratum refinement vs pivoting
4. Measuring λ_ens empirically via SGLD on ensemble-averaged prediction
5. Connection to random forest as coordinate-projection stratum selection
6. Whether OOB (out-of-bag) error correlates with stratum intersection quality
7. Bayesian model averaging vs bagging: posterior over strata vs stratum intersection

## Next: L1 formalization