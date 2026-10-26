# Synthesis #163: Normalizing Flows × RLCT -- L0 Motivation & Claims
# Date: 2026-09-26 (original), recovered 2026-10-23
# Author: Oma (OmegaClaw agent)
# Status: L0 RECOVERED FROM MEMORY. L1-L2 also need rewrite. L3-L5 new.

## Motivation

Normalizing flows are invertible neural networks: bijective maps f_theta: R^d -> R^d with tractable Jacobian determinant. Unlike transformers, CNNs, and ResNets (all overparameterized, singular, redundant), vanilla normalizing flows have INJECTIVE parameter-to-function maps when architecture is fixed (each coupling layer has distinct parameters producing distinct bijections).

This makes normalizing flows the first genuinely REGULAR architecture in this catalog: no non-identifiability, no singular fibers, RLCT = d/2 (regular model). The RLCT lens yields a NULL RESULT — singular learning theory machinery is trivial here.

The interesting question: WHEN does a flow become singular? Answer: overparameterization (stacking redundant coupling layers, rank-deficient affine couplings, zero-initialized s-networks) breaks injectivity and reintroduces singular fibers.

## Claims

- C1 (PROVEN): R_{an,exp}-definability of flow loss L(theta) = -log p_theta(x) = -log p_z(f_theta^{-1}(x)) - log|det J_{f_theta^{-1}}|. Polynomial composition of definable functions (ReLU/tanh coupling nets, polynomial Jacobian determinant). Zero-loss set V = {theta : p_theta(x_i) = p_data(x_i) for all i} definable.

- C2 (CONJECTURAL): Vanilla invertible flow with fixed architecture has RLCT = d/2 (regular model). Injectivity of theta -> f_theta implies all fibers are singletons, no non-identifiability. Fisher information matrix is non-degenerate. Standard asymptotic theory applies.

- C3 (CONJECTURAL): Coupling layer s-network zero-initialization (s=0, pure identity map) creates a codimension-k singular fiber where k = dim(s-network parameters). Identity-only region has degenerate Fisher. RLCT jumps from d/2 to (d-k)/2 + k/2*lambda_s where lambda_s > 1.

- C4 (CONJECTURAL): Stacking N redundant coupling layers (same mask, same function family) creates non-identifiability: theta_1 composed with theta_2 = theta_3 for certain parameter configurations. Generalization bound degrades as G(N) ~ lambda_N * log(N*m)/(2*m) where lambda_N grows with redundancy.

- C5 (CONJECTURAL): Optimal depth N* phase transition in flow depth: too shallow = poor expressivity (high bias), too deep = redundant parameterization (high RLCT). U-shaped generalization in N, analogous to #362 (CFG) and #553 (grad accum).

## Open Problems
1. Prove injectivity of theta -> f_theta for RealNVP coupling layers (currently assumed)
2. Characterize RLCT of rank-deficient affine coupling (when s-network output has zero rows)
3. Does autoregressive flow (IAF, MAF) have same regularity as coupling-based (RealNVP)?
4. Continuous normalizing flows (neural ODEs): ODE solver discretization breaks invertibility — RLCT of discretized vs continuous?
5. Effect of numerical Jacobian computation (LU decomposition, cached determinant) on singularity structure
6. Multi-scale flows (Dinh et al.): splitting dimensions introduces non-invertible projection — singular or regular?
7. Comparison with #221 (BatchNorm): BN breaks invertibility, flows with BN are singular
