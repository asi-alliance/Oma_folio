#472 Information Bottleneck × RLCT — L5 Experiment Design

## Experiment: SGLD LLC Estimation Across IB Lagrange Multiplier β

### Goal
Estimate local learning coefficient (LLC) λ(β) via SGLD loss-negativity on IB-trained models, test whether λ(β) is piecewise constant with jumps at critical β* values.

### Setup
- Architecture: 2-layer MLP, width d=128, ReLU activation
- Dataset: MNIST subset (n=5000), 10-class classification
- IB formulation: Variational IB (Alemi et al. 2017), L_IB = I(Z;X) − β·I(Z;Y) + H(Y|Z)
- β values: {0.001, 0.01, 0.05, 0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10.0} (log-spaced)
- SGLD: β_SGLD (inverse temp) in {0.01, 0.02, 0.05}, steps 20000 after burn-in 5000
- Seeds: 5 per β value
- Encoder/decoder: fixed architecture, only β varies

### Claims Tested
- C2: Phase transition at β*. Test: plot λ_hat(β) across β values. If λ_hat is smooth monotonic (no jumps), C2 falsified.
- C3: Compression phase (low β) maps to RLCT reduction. Test: compare λ_hat at β→0 (pure compression) vs β→∞ (pure relevance). If λ_hat does not decrease as β→0, C3 falsified.
- C4: Deep networks with IB compression phases have non-trivial RLCT stratification. Test: measure λ_hat at multiple training checkpoints for selected β values. If λ_hat trajectory is flat across training, C4 weakens.
- C5: Relevance term I(Z;Y) at β* equals gen gap bound λ/n. Test: compare measured I(Z;Y) with predicted λ_hat/n at β*. If no correlation (Pearson r < 0.3), C5 falsified.

### Measurements
- LLC via E[L]^(1-t) negativity fit per β-stratum
- I(Z;X) and I(Z;Y) via MINE estimator at each checkpoint
- Test accuracy / loss for generalization gap G
- Dead neuron fraction in encoder (compression proxy)

### Sweeps
- β: 10 values (log-spaced) × 5 seeds = 50 runs
- SGLD inverse temp: 3 values × 5 β values (subset) = 15 SGLD runs
- Training checkpoints: {1000, 5000, 10000, 20000, 50000} steps

### Falsification Rules
- C2 fails if λ_hat(β) is smooth (no detectable jump) across all β values within CI
- C3 fails if λ_hat(β→0) ≥ λ_hat(β→∞) for all seeds
- C4 fails if λ_hat trajectory is flat (< 10% variation) across all checkpoints for all β
- C5 fails if Pearson correlation between I(Z;Y) and λ_hat/n < 0.3

### Key Distinction from #169 (Dropout)
- #169: stochastic noise injection, per-sample mask, no explicit compression-relevance tradeoff
- #472: deterministic compression objective, explicit β-controlled information tradeoff, Lagrangian structure
- Test: compare λ_hat(β_IB) with λ_hat(p_dropout) at matching information rates. If identical, novelty weakens.

### Key Distinction from #471 (VIB)
- #471 would test variational IB specifically — #472 tests the IB principle generically (deterministic IB, VIB, etc.)
- If only VIB is tested here, #472 collapses into #471

### Estimated Cost: ~200 GPU-hours
### Priority: Medium (C1 proven, C2-C5 conjectural, first direct λ(β) measurement in IB context)