## Synthesis #659: Fractional Calculus Gradient (Daskin) x RLCT - L0 Exploration

## Date: 2026-10-26
## Status: L0 Exploration

## Background

Fractional calculus generalizes derivatives to non-integer order. The fractional gradient (Caputo derivative of order a, 0 < a < 1) introduces a power-law memory kernel, making each update depend on all previous positions as g(t-a) ~ integral of (t-s)^(-a) * grad(s) ds. For a=1 this recovers SGD; for a<1 it creates anomalous diffusion on the loss landscape (subdiffusion for a<1, Levy flights for a>1).

## Claims

C1: Fractional gradient descent with 0 < a < 1 produces subdiffusive trajectories that get trapped near singularities longer, increasing the effective RLCT lambda by a factor of 1/a relative to standard SGD.

C2: The power-law memory kernel in fractional gradients is mathematically equivalent to a continuum limit of momentum with a power-law decay schedule (beta_t ~ t^(-(1-a))), connecting to synthesis #98 (momentum) and #221 (EMA) via a fractional-order generalization.

C3: At a true singularity (K(w)=0), the fractional gradient's non-locality causes the trajectory to sample a larger neighborhood of the singular fiber, potentially improving generalization by escaping sharp directions that local gradients miss.

C4: The transition from subdiffusion (a<1) to superdiffusion (a>1) marks a phase boundary in the loss landscape; near this boundary (a close to 1), the RLCT is minimized because the trajectory balances memory (exploration of singular fiber geometry) and locality (gradient signal).

C5: Fractional calculus provides a natural bridge between RLCT theory and anomalous diffusion models of SGD; the Wasserstein distance between fractional-SGD and standard-SGD stationary distributions scales as |1-a|^(1/2) near a=1, controlled by the local RLCT.

## Cross-References

- #97 SGD x RLCT: standard case a=1
- #98 Momentum x RLCT: discrete analog of fractional memory
- #221 EMA x RLCT: exponential vs power-law memory
- #527 Gradient Clipping x RLCT: interaction with anomalous dynamics
- #658 Weight Standardization x RLCT: effect on landscape geometry

## Open Problems

1. Can the fractional order a be adaptively scheduled to track the local RLCT during training?
2. Does fractional gradient descent find flatter minima than SGD on benchmark tasks?
3. What is the exact relationship between the Caputo derivative order and the multiplicity of the singularity?
4. Can RLCT bounds be tightened using fractional calculus machinery (e.g., fractional Taylor expansions near singularities)?

## Next Steps

- L1: Formalize C1-C5 in terms of RLCT definitions
- L2: Dimensional analysis and novelty verification
- L3: Literature cross-check
- L4: Summary and catalog entry