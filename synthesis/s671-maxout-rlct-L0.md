# Synthesis #671: Maxout Networks × RLCT
## L0: Claims and Novelty
**Date:** 2026-10-28
**Status:** L0 Draft
**Selected from:** Zero-hit candidate screening (all activation functions covered: #58 ReLU, #555 GELU, #350 SiLU, #353 ELU, #609 SwiGLU; maxout = zero catalog hits + zero websearch hits for SLT/RLCT).

---

### Formal Object

A maxout unit with k pieces computes:
f(x) = max(z_1, ..., z_k), where z_i = w_i^T x + b_i, w_i in R^d, b_i in R.

The output is piecewise linear and convex in x, with up to k affine regions separated by tie hyperplanes H_{ij} = {x : z_i(x) = z_j(x)} = {x : (w_i - w_j)^T x = (b_j - b_i)}.

For a maxout network with L layers, each unit has k pieces, the parameter space is Theta = product of all w_i, b_i across layers.

### C1: R_an Definability (PROVEN)

**Claim:** The maxout loss function is definable in R_an (semi-algebraic, no transcendental terms).

**Proof sketch:** max(z_1,...,z_k) = (sum of z_i for active region) where region R_i = {x : z_i >= z_j for all j}. Each R_i is semi-algebraic (intersection of affine half-spaces). The composition of semi-algebraic functions is semi-algebraic. The loss L(theta) = sum (f_theta(x_n) - y_n)^2 is polynomial within each region partition, hence semi-algebraic. By Watanabe's framework, R_an definability holds (R_an includes semi-algebraic sets). ∎

**Note:** Unlike #350 SiLU (transcendental sigmoid), #555 GELU (erf transcendental), #169 (transcendental), maxout is PURELY algebraic — same definability class as #58 ReLU but with richer combinatorial structure.

### C2: Singular Fiber — Tie Hyperplane Arrangement (CONJECTURAL)

**Claim:** The singular fibers of the maxout loss landscape contain a hyperplane arrangement from tie surfaces {z_i = z_j}.

**Conjecture:** At a tie surface H_{ij}, the maxout function is non-differentiable (C^0-not-C^1, same regularity class as ReLU #58). The Fisher information matrix has rank deficiency at parameters where:
- (a) Two or more pieces are tied (z_i = z_j) on a positive-measure input set — the gradient direction is ambiguous.
- (b) A piece z_i is dominated (z_i < z_j for all x in support) — dead piece, analogous to ReLU dead units.
- (c) Multiple pieces are simultaneously tied (z_i = z_j = z_m) — higher-order ties create higher-codimension strata.

The singular fiber structure is an arrangement of codim-1 hyperplanes (pairwise ties), codim-2 intersections (triple ties), etc. — a hyperplane arrangement singularity, richer than ReLU's single switching surface {w·x = 0}.

**Gap:** Fisher rank deficiency at tie surfaces needs formal proof; the combinatorial stratification from k-piece ties is more complex than ReLU's binary switch.

### C3: k as Discrete Stratum Selector (CONJECTURAL)

**Claim:** The piece count k acts as a discrete stratum selector for the RLCT.

**Conjecture:** The RLCT lambda(k) is non-decreasing in k:
- k=1: linear function, no singularity, lambda = d/2 (regular model).
- k=2: max(z_1, z_2) — isomorphic to |z_1 - z_2|/2 + (z_1+z_2)/2, essentially ReLU-like, lambda ≈ lambda_ReLU.
- k>=3: additional tie surfaces create additional singular strata, lambda(k) >= lambda(k-1).

The number of linear regions grows as O(k^d) for a single maxout unit (vs 2^d for ReLU). Each region boundary is a potential singular locus. The RLCT captures the effective complexity of the singular fiber, which increases with the combinatorial complexity of the hyperplane arrangement.

**Gap:** Monotonicity of lambda(k) is intuitive but unproven — more tie surfaces could either increase multiplicity (raising lambda) or create additional flat directions (lowering lambda). The net effect depends on the interaction between multiplicity and codimension.

### C4: Generalization Bound (CONJECTURAL)

**Claim:** The generalization error for maxout networks satisfies:
Delta G_k <= (lambda_k / (2n)) * log(n) + C_k

where lambda_k is the RLCT for k-piece maxout, and C_k absorbs constants from the semi-algebraic complexity.

**Conjecture:** For k=2 (ReLU-equivalent), lambda_2 ≈ lambda_ReLU (#58 result). For k>2, the bound is worse (higher lambda) but the model class is richer — the tradeoff between capacity (more regions) and singularity (higher lambda) determines optimal k.

**Comparison:** Unlike #353 Softplus (continuous temperature T as selector), maxout's k is DISCRETE — there is no smooth interpolation between k and k+1. The stratum selector creates a discrete family of models, not a continuous deformation.

**Gap:** Asymptotic validity of the bound for semi-algebraic (non-analytic) loss; constant C_k depends on combinatorial complexity of k-piece arrangement.

### C5: k-Selection Phase Transition (CONJECTURAL)

**Claim:** During training, the effective k (number of active pieces with distinct weight configurations) undergoes a phase transition.

**Conjecture:** Early in training, many pieces are tied (low effective k, simple function). As training progresses, pieces differentiate and the effective k increases. The phase transition occurs when the loss landscape curvature at tie surfaces becomes sufficient to separate pieces. The critical point t* depends on the learning rate and the geometry of the tie arrangement.

**Testable prediction:** SGLD on maxout networks should show a phase transition in the local learning coefficient (LLC) as pieces differentiate, analogous to #58 ReLU dead-unit resolution but with multiple simultaneous transitions (one per piece-pair).

**Gap:** The dynamics of piece differentiation are not well-understood; the phase transition may be gradual rather than sharp for k>2.

---

### Novelty Assessment

**Overlaps checked:**
- #58 ReLU: maxout with k=2 is ReLU-equivalent. But #58 studies fixed 2-piece structure; maxout generalizes to k pieces with combinatorial tie arrangement. DISTINCT — k as variable creates new singular structure.
- #555 GELU: smooth activation, no non-differentiable surfaces. DISTINCT.
- #350 SiLU: mixed algebraic-transcendental singularity. DISTINCT.
- #353 ELU: C^1-not-C^2 partial smoothing. DISTINCT.
- #609 SwiGLU: multiplicative gating singularity. DISTINCT.
- #354 STE: straight-through estimator, different non-differentiability. DISTINCT.

**Key novel contributions:**
1. Hyperplane arrangement singularity: maxout's tie surfaces form a combinatorial hyperplane arrangement, generalizing ReLU's single switching surface to k(k-1)/2 pairwise tie hyperplanes.
2. Discrete stratum selector: k is the first DISCRETE stratum selector in the catalog (vs continuous selectors like temperature T in #353, #409, saturation in #396).
3. Combinatorial region growth O(k^d): the singular fiber complexity scales combinatorially with k, creating a new class of singularities not present in fixed-structure activations.
4. Dead-piece vs dead-unit: maxout's dead piece (z_i always dominated) is a k-generalization of ReLU's dead unit, with different codimension structure.

### Open Problems

1. Formal proof of Fisher rank deficiency at tie surfaces H_{ij}.
2. Exact RLCT for k-piece maxout: is lambda_k = lambda_2 + (k-2)*delta for some delta>0?
3. Combinatorial bound: does lambda scale with number of active tie surfaces rather than k itself?
4. Interaction between layers: does stacking maxout layers create multiplicative or additive singularity growth?
5. Comparison with ReLU at k=2: is maxout(k=2) exactly ReLU in RLCT, or does the parametrization difference matter?
6. Dead-piece dynamics: how does the fraction of dead pieces evolve during training vs ReLU dead units?
7. Optimal k selection: does SLT predict an optimal k for given n (sample size) via the gen bound tradeoff?

### Cross-References

#58 (ReLU), #555 (GELU), #350 (SiLU), #353 (ELU/SELU/Softplus), #609 (SwiGLU), #169 (Dropout/GELU), #354 (STE), #409 (Gumbel-Softmax), #465 (Kaiming Init), #527 (Gradient Clipping), #532 (CutMix)

---

**Next:** L1 formalization (rigorous definitions, C1 proof, C2-C5 refinement).