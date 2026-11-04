## Synthesis #671: Maxout Networks x RLCT
## L1: Formal Definitions and L1 Specification

**Date:** 2026-10-28
**Status:** L1 Formalization

---

### D1: Parameter Space
A maxout unit with k pieces computes f(x) = max(z_1, ..., z_k) where z_i = w_i^T x + b_i, w_i in R^d, b_i in R.

For a network with L layers, each unit having k pieces, parameter space:
Theta = prod_{l=1}^{L} prod_{v=1}^{V_l} (R^{d_l x d_in} x R^{d_in})^k

Working core: K_Theta = prod_n L(theta) where L_theta = (1/n) * sum (f_theta(x_n) - y_n)^2.

### D2: Tie Hyperplane Arrangement
Tie surfaces: H_{ij} = {x in R^d : z_i(x) = z_j(x)} = {x : (w_i - w_j)^T x = (b_j - b_i)}.

- Codimension 1 in input space for a single unit.
- Pairwise gives C(k,2) = k(k-1)/2 tie hyperplanes.
- P = union_{i<j} H_{ij} is a hyperplane arrangement.
- Depends on matroid of hyperplane arrangement, strictly richer than ReLU single switching surface.
- Arrangement combinatorics determine singular fiber structure.

### D3: Semi-Algebraic Definability (C1 PROVEN)
max(z_1,...,z_k) is semi-algebraic: split input space into regions R_i = {x : z_i(x) >= z_j(x) for all j}, each R_i is an intersection of affine half-spaces (semi-algebraic). On each R_i, f = z_i (affine, hence polynomial). The loss L(theta) = (1/n) sum (f_theta(x_n) - y_n)^2 is piecewise polynomial, hence semi-algebraic. By Watanabe framework, R_an definability holds. Same definability class as ReLU #58 but richer combinatorial structure.

### D4: Singular Fiber - Tie Geometry (C2, CONJECTURAL)
At tie surface H_{ij}, maxout is non-differentiable (C^0 not C^1, same as ReLU #58). Fisher information matrix has rank deficiency when:
(a) Two+ pieces tied (z_i = z_j) on positive-measure input set — gradient direction ambiguous.
(b) A piece z_i dominated (z_i < z_j for all x in support) — dead piece, k-generalization of ReLU dead unit.
(c) Multiple pieces simultaneously tied (z_i = z_j = z_m) — higher-order ties, higher-codimension strata.

Singular fiber W_0 = {theta : L(theta) = min} contains tie arrangement stratification: codim-1 pairwise ties, codim-2 triple ties, etc. This is a hyperplane arrangement singularity, richer than ReLU's single switching surface {w.x = 0}.

Gap: Fisher rank deficiency at tie surfaces needs formal proof. Combinatorial stratification from k-piece ties more complex than ReLU binary switch.

### D5: k as Discrete Stratum Selector (C3, CONJECTURAL)
k acts as discrete stratum selector controlling combinatorial complexity of activation regions.

- k=1: linear, no singularity, lambda = d/2 (regular model).
- k=2: max(z_1,z_2) = |z_1-z_2|/2 + (z_1+z_2)/2, ReLU-equivalent, lambda ~ lambda_ReLU.
- k>=3: additional tie surfaces create additional singular strata, lambda(k) >= lambda(k-1) conjectured.

Linear regions grow as O(k^d) per unit (vs 2^d for ReLU). Each boundary is a potential singular locus.

Gap: Monotonicity of lambda(k) unproven — more tie surfaces could increase multiplicity (raise lambda) or create flat directions (lower lambda). Net effect depends on multiplicity-codimension interaction.

### D6: Generalization Bound (C4, CONJECTURAL)
Delta G_k <= lambda_k * log(n) / (2n) + U_k / sqrt(n) + B_k

where lambda_k is RLCT for k-piece maxout, U_k captures finite-sample fluctuation, B_k absorbs semi-algebraic complexity constants.

Capacity-singularity tradeoff: more pieces (higher k) gives richer function class (lower approximation error) but higher lambda_k (worse generalization bound). Optimal k balances these.

Gap: Asymptotic validity for semi-algebraic (non-analytic) loss. Constant B_k depends on combinatorial complexity of k-piece arrangement.

### D7: Piece Differentiation Phase Transition (C5, CONJECTURAL)
Early training: many pieces tied (low effective k, simple function). As training progresses, pieces differentiate, effective k increases. Phase transition when loss curvature at tie surfaces becomes sufficient to separate pieces. Critical time t* depends on learning rate and tie arrangement geometry.

SGLD prediction: multiple local learning coefficient (LLC) transitions, one per distinct piece-pair differentiation event. For k>2, transitions may be gradual rather than sharp since multiple pieces can differentiate simultaneously.

Gap: Phase transition dynamics for k>2 not well understood. Competitive adaptation between pieces may create non-trivial dynamics.

### Open Problems
1. Formal proof of Fisher rank deficiency at tie surfaces H_{ij}.
2. Is lambda_k = lambda_2 + (k-2)*delta for some delta > 0?
3. Do tie surfaces at multi-layer maxout create additional cap elements or singularity intersections?
4. Explicit dimensional lower bound on fiber structure for general k and P.
5. Parametrization difference in RLCT between maxout(k=2) and ReLU(2x)?
6. Dead-piece dynamics: fraction of dead pieces during training vs ReLU dead units.
7. Optimal k selection: does SLT predict optimal k for given n via gen bound tradeoff?

### Cross-References
#58 (ReLU), #555 (GELU), #350 (SiLU), #353 (ELU), #609 (SwiGLU), #169 (GELU dropout), #354 (STE), #409 (Gated Gumbel), #465 (Kaiming Init), #527 (Gradient Clipping), #532 (CutMix), #622 (Determinantal Variety), #666 (Fiber Bundle)

**Next:** L2 novelty verification.