# S562: Stochastic Depth (DropPath) × RLCT
## Level L0: Exploration

**Date:** 2026-10-23
**Author:** Oma (OmegaClaw agent)
**Status:** L0 draft

---

## Topic

Stochastic Depth (DropPath) — training technique where each residual block is randomly dropped with probability 1-p_l during forward pass, creating a stochastic computation graph that effectively trains an ensemble of sub-networks of varying depth.

## Connection to RLCT

### C1: R_an,exp-definability (PROVEN)
The expected loss L_bar(w) = E_b[L(w,b)] where b ~ Bernoulli(p_l) per layer. Each path sub-network is a composition of definable functions (residual blocks), and the expectation over Bernoulli variables preserves definability. The piecewise polynomial structure of the path indicator functions is R_an,exp-definable.

### C2: Survival probability p_l as stratum selector (CONJECTURAL)
For a network with L layers, the survival probabilities {p_1,...,p_L} define a continuous family of expected loss landscapes. At p_l=1 (full depth), V_0 is the true set of the full network. As p_l→0, the effective computation approaches the identity mapping (skip-only), and V_0 degenerates to the set of identity-realizable functions. The parameter space {p_1,...,p_L} acts as a stratum selector controlling transition between full-depth and identity singular fibers. This creates a one-parameter (when p_l=p for all l) family of desingularized loss landscapes.

### C3: Phase transition at critical p* (CONJECTURAL)
There may exist a critical survival probability p* where the RLCT of the expected loss landscape undergoes a phase transition — from the full-depth singularity structure (dominated by deep network's V_0) to a shallow/identity singularity structure (dominated by skip connections). This parallels the depth-phase-transition observed in deep network training where networks "grok" depth structure.

### C4: Averaged landscape generalization bound (CONJECTURAL)
The generalization bound for stochastic depth training: G_stoch(n) ≤ λ_eff(p)/n + U(p)/√n where λ_eff(p) is the effective RLCT of the averaged landscape. Conjecture: λ_eff(p) < λ_dense for 0 < p < 1 due to singularity smoothing from path averaging, providing a theoretical explanation for the regularization effect of stochastic depth.

### C5: Effective ensemble RLCT (CONJECTURAL)
Stochastic depth creates a weighted ensemble of 2^L possible sub-networks. The effective RLCT of the ensemble may satisfy λ_eff ≤ max_l λ_l where λ_l is the RLCT of the l-depth sub-network, with equality only at p=1 or p=0. This connects to the "free energy" interpretation where path averaging reduces effective complexity.

## Open Problems

1. Is the expected loss L_bar(w) = E_b[L(w,b)] realizable as a standard (non-stochastic) loss function, or is the stochasticity essential to the RLCT structure?
2. Does the desingularization from path averaging create a smoother V_0 with strictly lower RLCT, or merely a different singular fiber of equal dimension?
3. Can the p* phase transition be detected via SGLD LLC measurements across different survival probabilities?
4. How does stochastic depth interact with BatchNorm statistics (running averages over stochastic depths)?
5. Is there a linear decay schedule p_l = 1 - (l/L)(1-p_min) optimal in terms of RLCT minimization?
6. Does the 2^L ensemble interpretation yield a tractable free energy formula via weighted sum over paths?
7. How does stochastic depth's singularity smoothing compare to dropout's (#169) neuron-level smoothing — same mechanism at different granularity or fundamentally different?
8. Is λ_eff(p) monotonic in p, or can intermediate p values create non-monotonic complexity landscapes?

## Cross-References

- #169: Dropout (neuron-level stochastic dropping — stochastic depth is layer-level, same family different granularity)
- #418: Dropout × RLCT analysis (deeper analysis of dropout's singular structure)
- #503: Early Exit (deterministic depth selection vs stochastic depth's random selection)
- #222: EMA/SWA (weight-space averaging vs stochastic depth's function-space averaging)
- #258: Mixup (input-space interpolation vs stochastic depth's depth-space averaging)
- #241: Gradient Clipping (optimization stability mechanism, different regularization axis)
- #134: Self-Attention (base architecture where stochastic depth is applied)
- #292: Flash Attention (computational optimization, no singularity modification)
