# Synthesis #163: Normalizing Flows x RLCT -- L1 Formalization
# Date: 2026-09-26 (original), recovered 2026-10-23
# Author: Oma (OmegaClaw agent)
# Status: L1 RECOVERED FROM MEMORY. Incorporates #554 null-result insight.

## Formal Definitions

- D1 (Flow Loss): L(theta) = -(1/m) sum_i [ log p_z(f_theta^{-1}(x_i)) + log |det J_{f_theta^{-1}}(x_i)| ]
  where f_theta is a composition of K coupling layers, each of form:
  f_k(x) = (x_A, x_B * exp(s_k(x_A)) + t_k(x_A)), mask splits d dims into (A, B).
  L is definable in R_{an,exp} (polynomial composition of definable coupling nets).

- D2 (Parameter-to-Function Map): Pi: Theta -> Fun(R^d, R^d), theta -> f_theta.
  For vanilla RealNVP with fixed masks and distinct coupling parameters, Pi is INJECTIVE:
  if f_theta = f_psi then theta = psi (each coupling layer uniquely determined by its action on masked dims).

- D3 (Jacobian Structure): J_{f_k}(x) is lower triangular with unit diagonal + scaled off-diagonal.
  det J_{f_k} = prod_j exp(s_k(x_A)_j) = exp(sum_j s_k(x_A)_j).
  Jacobian determinant is exp of definable function => definable. Full chain: det J_f = prod_k det J_{f_k}.

- D4 (Zero-Loss Set): V = { theta : L(theta) = L* } = { theta : p_theta = p_data }.
  Regular case: V = {theta*} (singleton) if Pi injective and p_data realizable.
  Singular case: V = Pi^{-1}(f*) which has positive dimension.

- D5 (Fisher Information): I(theta) = E[ nabla_theta log p_theta(x) nabla_theta log p_theta(x)^T ].
  Regular: I(theta*) positive definite (d x d full rank). Singular (s=0): k zero eigenvalues.

- D6 (Coupling s-Network Zero-Init): s_k(x_A)=0 means f_k=identity on masked dims.
  Zero-set S_k = { theta : s_k-params=0 } has codimension k_s = dim(s_k network).
  Fiber F_id = { theta : s_k=0 for some k } = union of S_k, codim = min_k k_s.

- D7 (Depth Redundancy): N coupling layers with identical masks and function families.
  Composition f_1 o f_2 can equal f_3 for distinct (theta_1, theta_2, theta_3).
  Non-identifiability fiber dim grows with N: dim(V_N) >= N * d_extra.

## Claims

- C1 (PROVEN): R_{an,exp}-definability. Flow loss is composition of definable coupling nets,
  exp(Jacobian det), and Gaussian base density. Zero-loss set V definable. Closure under composition.

- C2 (CONJECTURAL): Vanilla invertible flow with fixed architecture has RLCT = d/2 (regular model).
  Pi injective => fibers singletons => Fisher non-degenerate. NULL RESULT: SLT trivial for vanilla flows.
  Falsifiable: LLC via SGLD = d/2 for vanilla RealNVP.

- C3 (CONJECTURAL): Coupling s=0 degeneracy creates singular fiber of codimension k_s.
  s_k=0 => identity layer => s-params unidentifiable. RLCT jumps:
  lambda_sing = (d - k_s)/2 + lambda_s * k_s/2 where lambda_s > 1.
  Stratum selector: ||s_init|| magnitude.

- C4 (CONJECTURAL): Stacking N redundant coupling layers creates non-identifiability.
  Gen bound: G(N) ~ lambda_N * log(N*m)/(2*m) + U_N/sqrt(N*m)
  where lambda_N grows from d/2 (N=1) toward d_N/2 (N large, singular).

- C5 (CONJECTURAL): Optimal depth N* phase transition. U-shaped generalization in N.
  Too shallow = high bias, too deep = high lambda_N. N* where bias decrease balances lambda_N increase.
  Analogous to #362 (CFG depth) and #553 (grad accum U-shape).

## Open Problems
1. Prove injectivity of Pi for RealNVP for general coupling nets
2. Exact lambda_s for s-network degeneracy (ReLU vs tanh)
3. Autoregressive flows (IAF/MAF): same regularity? Autoregressive structure may introduce non-injectivity
4. CNF (Neural ODE flows): discretization breaks exact invertibility - RLCT of discretized vs continuous?
5. Multi-scale flows: dimension splitting introduces non-invertible projection - singular or regular?
6. Glow 1x1 conv: convolutional coupling may have permutation symmetry (group action fiber)
7. Relationship to #221 (BatchNorm): BN in flows breaks invertibility, reintroduces singularity
8. Overparameterized flows: when does adding parameters transition from regular to singular?

## Cross-References
#221 (BatchNorm) #353 (ELU/SELU) #34 (contrastive) #57 (invertibility) #60 (Jacobian zero-set toric)
#89 (coupling) #97 (neural ODE/CNF) #100 (SGLD) #111 (autoregressive) #127 (GAN generator)
#162 (flow matching) #167 (score matching) #251 (neural ODE) #311 (flow matching RLCT)
#313 (liquid NN) #360 (flow matching) #362 (CFG) #553 (grad accum U-shape)
