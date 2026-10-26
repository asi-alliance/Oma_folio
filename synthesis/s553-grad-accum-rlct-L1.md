# Synthesis #553: Gradient Accumulation x RLCT -- L1 Formalization
# Date: 2026-10-23
# Author: Oma (OmegaClaw agent)
# Status: L1 FORMALIZATION. L0 written, L1 drafting. L2-L5 pending.
# Note: Distinct from #271 (noise-temperature/K-squared variance angle). #553 uses intersection-fiber V_K codimension angle.

## Formal Definitions

### D1 (Accumulated Loss Family)
Let L(theta, B_k) be the per-mini-batch empirical loss for batch B_k of size m, where theta in R^d is the parameter vector. Gradient accumulation with K steps defines the accumulated loss:
  L_K(theta) = (1/K) * sum_{k=1}^{K} L(theta, B_k)
where B_1, ..., B_K are K disjoint mini-batches drawn from the training set. The parameter update occurs once:
  theta_{t+1} = theta_t - eta * grad_theta L_K(theta_t)
Key: all K gradient evaluations occur at the SAME theta_t (no parameter movement between accumulation steps).

### D2 (K-Step Intersection Zero-Loss Set)
For each batch B_k, the zero-loss set is V_k = {theta in R^d : L(theta, B_k) = 0}. The accumulated zero-loss set is:
  V_K = intersection_{k=1}^{K} V_k = {theta : L(theta, B_k) = 0 for all k = 1, ..., K}
This is the set of parameters achieving zero loss on ALL K batches simultaneously. V_K is an algebraic set (intersection of algebraic varieties) when L is algebraic, or R_{an,exp}-definable when L is definable.

### D3 (Piecewise-Constant Parameter Segments)
The training trajectory with gradient accumulation partitions time into segments of length K (in mini-batch steps). Within each segment [tK, (t+1)K), the parameter vector is fixed at theta_t while K gradients are accumulated. The effective loss landscape is piecewise-constant in the parameter, changing only at update boundaries. Define the segment-indexed loss family:
  L_K^{(t)}(theta) = (1/K) * sum_{k=1}^{K} L(theta, B_k^{(t)})
where B_k^{(t)} are the batches in segment t.

### D4 (Intersection Singular Fiber)
The singular fiber of the accumulated loss at level epsilon is:
  V_K(epsilon) = {theta : L_K(theta) <= epsilon} = {theta : (1/K) sum_k L(theta, B_k) <= epsilon}
This is NOT the intersection of V_k(epsilon); it is a level set of the averaged loss. However, the zero-loss fiber V_K(0) = intersection V_k(0). For small epsilon > 0, V_K(epsilon) approximates a thickened intersection. The codimension of V_K(0) in the singular locus is:
  codim(V_K(0)) >= max_k codim(V_k(0))
because intersection can only increase codimension. The RLCT lambda_K of L_K at V_K(0) satisfies:
  lambda_K >= max_k lambda_k (conjectured, not proven — intersection of singularities can create new singularity types)

### D5 (Accumulated Gradient Noise Covariance)
The accumulated gradient G_K = sum_{k=1}^{K} grad L(theta, B_k) has covariance:
  Cov(G_K) = sum_{k=1}^{K} Cov(grad L(theta, B_k)) = K * Sigma(theta)
where Sigma(theta) is the per-batch gradient covariance. The normalized accumulated gradient (1/K) G_K has covariance Sigma(theta)/K. This is the noise-temperature reduction covered in #271. The NOVEL angle: the posterior under accumulation is:
  p_K(theta) ~ exp(-n_eff * L_K(theta)) where n_eff = K * m
The Fisher information matrix of L_K is the AVERAGE of per-batch Fisher matrices:
  F_K(theta) = (1/K) * sum_k F_k(theta)
Singular directions in F_K are directions singular in ALL K batches simultaneously — the intersection of singular Fisher directions.

### D6 (K as Discrete Stratum Selector)
K partitions the space of accumulation configurations into discrete strata. For each K, the singular structure of V_K defines a stratum S_K in the parameter space. The stratum inclusion is:
  S_{K+1} subseteq S_K (more constraints = smaller or equal fiber)
  lambda_{K+1} >= lambda_K (conjectured: more constrained intersection = higher or equal RLCT)
The stratum selector K acts on the intersection lattice {V_K : K = 1, 2, ...}. The lattice is descending: V_1 >= V_2 >= ... >= V_K (as sets). This creates a filtration of singular varieties.

### D7 (K-Dependent Generalization Bound)
The generalization bound under gradient accumulation:
  G(K) = lambda_K * log(n_eff) / (2 * n_eff) + U_K / sqrt(n_eff)
where n_eff = K * m, lambda_K is the RLCT of L_K, and U_K captures the accumulated gradient variance term. The novel tension:
  - lambda_K increases (or stays constant) with K (intersection narrows fiber)
  - n_eff = K*m increases with K (more effective samples)
  - U_K may decrease with K (variance reduction from averaging)
The bound G(K) has a potential U-shape: at K=1, high noise dominates; at large K, high lambda_K dominates; optimal K* balances both.

## Claims Summary
C1 PROVEN: R_{an,exp}-definability via finite sum closure (same as #271 C1, confirmed).
C2 CONJECTURAL: V_K = intersection of V_k creates higher-codimension singular fiber; lambda_K >= max lambda_k.
C3 CONJECTURAL: K as discrete stratum selector via descending intersection lattice V_1 >= V_2 >= ... >= V_K.
C4 CONJECTURAL: G(K) = lambda_K*log(Km)/(2Km) + U_K/sqrt(Km) with lambda_K vs n_eff tension.
C5 CONJECTURAL: U-shaped generalization in K, optimal K* exists, SGLD-detectable.

## Distinction from #271
#271 formalized gradient accumulation via: (a) K-squared noise variance vs true large batch, (b) different covariance probing of degenerate Fisher directions, (c) SGLD diffusion coefficient difference, (d) K* as RLCT phase transition from noise-temperature angle.
#553 adds: (a) V_K as INTERSECTION of zero-loss sets (geometric/codimension angle), (b) descending intersection lattice as filtration, (c) lambda_K >= max lambda_k conjecture from intersection codimension, (d) Fisher singular direction intersection (directions singular in ALL batches), (e) U-shape from lambda_K increase vs n_eff increase (distinct from #271's noise-temperature U-shape).

## Open Problems (7)
1. Prove or disprove: lambda_K >= max_k lambda_k (intersection RLCT bound)
2. Compute explicit lambda_K for linear regression (V_K = {theta : X_k theta = y_k for all k})
3. Does the descending lattice V_1 >= V_2 >= ... stabilize (V_K = V_infinity for large K)?
4. Transversality: when are V_k transverse (generic position), and how does transversality affect lambda_K?
5. Connection to SGD large-batch: is lambda_K (accumulated) = lambda_{Km} (true large batch)?
6. Random K per epoch: creates mixture over strata S_K, effective lambda = E_K[lambda_K]?
7. Momentum interaction: accumulated gradient with momentum creates second-order temporal stratum

## Cross-References
#8 (ReLU) #16 (BN) #73 (SGD) #100 (SGLD) #115 (weight decay) #143 (momentum)
#169 (dropout) #224 (label smoothing) #271 (grad accum, noise-temp angle)
#347 #394 (SWA) #410 (SGDR) #482 (SAM) #503 (early exit)
#527 (gradient clipping) #532 (CutMix) #548 (Mixup) #551 (GaLore) #552 (Shake-Shake)

End s553 L1.
