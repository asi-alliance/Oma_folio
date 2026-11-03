# Synthesis #677: Model Soup × RLCT
## L3 Empirical Predictions — 2026-10-28

### P1: Soup RLCT Reduction
**Prediction:** lambda_soup(k) < min_i lambda_i for k >= 2, measurable via Local Learning Coefficient (LLC) estimation.
**Protocol:** Fine-tune k=5..20 models independently on CIFAR-100. Estimate LLC for each individual model and for the soup average using stochastic Langevin dynamics. Compare lambda_soup vs min(lambda_i).
**Expected:** lambda_soup < min(lambda_i) with gap proportional to fine-tuning diversity V.
**Falsification:** If lambda_soup >= min(lambda_i) across all configurations, C2 is false — soup does not access deeper strata.

### P2: Phase Transition at k*
**Prediction:** Generalization accuracy vs soup size k shows an S-curve with a knee at k* ~ O(d/V).
**Protocol:** Fix architecture (d params), vary k from 1 to 50, measure test accuracy at each k. Fit piecewise model: linear improvement below k*, plateau above.
**Expected:** Clear knee point k* that increases with diversity V (varied via different hyperparams/data orderings).
**Falsification:** If no knee exists or k* is independent of V, C5 is false.

### P3: Diversity-RLCT Correlation
**Prediction:** Fine-tuning diversity V = E[||w_i - w_j||^2] correlates negatively with lambda_soup at fixed k.
**Protocol:** Control diversity by varying fine-tuning LR, epochs, data ordering. Measure V and lambda_soup(k=10) for each configuration.
**Expected:** Pearson correlation r < -0.5 between V and lambda_soup.
**Falsification:** No significant correlation between diversity and soup RLCT.

### P4: Greedy Soup Descent Path
**Prediction:** Greedy soup (sequential addition) follows an RLCT descent path — each addition that improves held-out accuracy also decreases lambda.
**Protocol:** Track LLC at each greedy soup step. Compare RLCT trajectory with random addition order.
**Expected:** Greedy selection monotonically decreases LLC more effectively than random.
**Falsification:** Greedy soup RLCT is not consistently lower than random addition.

### P5: Stratum Crossing Signature
**Prediction:** Hessian spectrum of w_soup shows signature of stratum crossing: eigenvalue distribution intermediate between individual models but with additional near-zero eigenvalues indicating deeper singularity.
**Protocol:** Compute Hessian eigenvalues for each w_i and w_soup. Look for eigenvalue repulsion patterns characteristic of singular strata.
**Expected:** w_soup has more near-zero Hessian eigenvalues than any individual w_i.
**Falsification:** Soup Hessian spectrum is simple average of individual spectra with no new near-zero eigenvalues.

### Cross-References
#232 (SWA × RLCT — single trajectory, no stratum crossing expected), #497, #665

### Status
L3 complete. Five testable predictions, each with falsification criteria. Next: L4 (computational verification) or L5 (summary).