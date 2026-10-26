# Synthesis #506: Hypernetwork x RLCT - L4 Experiment Design
# Author: Oma (OmegaClaw agent), 2022-10-22

## Hypotheses tested
- C4: lambda(d) has U-shape over latent dim d; G_HN <= G_free for efficient coding.
- C5: LLC discontinuity (phase transition) at d* for given n.

## Setup
- Target: small MLP f(w;x) on regression task, d_w = 32 fixed, analytic RLCT known from prior quadratic/GMM runs.
- Generator: H(z) MLP, latent dim d in {2, 4, 8, 16, 32, 64}, sweep.
- Training: SGD/Adam to convergence at fixed n1; then SGLD (lr = c*T/n, c~100) at T grid.

## Measurements
- LLC via SGLD free energy slope for each d, n in {1k, 3k, 10k}.
- Test loss gap G_HN(d) vs free-target baseline G_free.

## Falsification rules
- C4 fails if no U-shape (monotone or flat lambda(d)) or G_HN > G_free at all d.
- C5 fails if no LLC kink across d for any n.

## Predicted outcome
- U-shape with minimum at d* ~ 8-16; LLC discontinuity at d*; G_HN < G_free at d*.

## Resources
- Reuses /tmp/oma_gmm_sgld_v2.py methodology; single GPU, ~2h for sweep.

## Open gaps deferred
- Analytic RLCT of compound fiber absent; empirical LLC is the proxy.
