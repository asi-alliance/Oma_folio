#657 DST × RLCT — L5 Experiment Design

## Experiment: SGLD LLC Estimation for Dynamic Sparse Training

### Setup
- Architecture: 3-layer MLP, width d in {64, 128, 256, 512}
- Dataset: MNIST subset (n=5000), 10-class classification
- DST methods: RigL, SET, SNIP — each with mask update interval Delta-T in {10, 50, 100, 200, 500}
- Sparsity s in {0.5, 0.7, 0.9, 0.95, 0.99}
- SGLD: beta (inverse temp) in {0.001, 0.002, 0.005, 0.01, 0.02}
- Steps: 20000 SGLD samples after burn-in (5000)

### Claims Tested
- C1 (PROVEN, not tested): R_an,exp definability of masked loss
- C2: Evolving mask M(t) creates time-varying singular fiber V_0(t). Test: measure LLC at multiple checkpoints during training. If LLC trajectory is flat across mask updates, C2 weakens.
- C3: Delta-T acts as stratum selector. Test: sweep Delta-T at fixed sparsity. If LLC does not change with Delta-T, C3 falsified.
- C4: Gen bound G_DST ~ lambda_eff(s,Delta-T)/n + U/sqrt(n). Test: compare test error with predicted bound across (s, Delta-T) grid. If no correlation, C4 weakens.
- C5: Phase transition at (s*, Delta-T*). Test: plot LLC surface over (s, Delta-T). If no sharp transition, C5 falsified.

### Falsification Rules
- C2 fails if LLC is constant across all mask-update checkpoints for all methods
- C3 fails if LLC is invariant under Delta-T sweep for all methods
- C4 fails if Pearson correlation between log(test_error) and log(G_DST) < 0.3
- C5 fails if LLC surface is smooth (no detectable sharp transition) across full grid

### Key Distinction from #169 (Dropout)
- #169: stochastic mask, per-sample randomness, static distribution
- #657: deterministic mask trajectory, per-step update rule, evolving singular fiber
- Test: compare LLC trajectories of DST vs equivalent dropout rate. If identical, novelty weakens.

### Estimated Cost: ~300 GPU-hours
### Priority: Medium (C1 proven, C2-C5 conjectural, first deterministic stratum trajectory)