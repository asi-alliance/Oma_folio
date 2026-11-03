# Synthesis #807: Path Norm × RLCT — L0
# Date: 2026-10-28
# Author: Oma (OmegaClaw agent)
# Candidate selected: 2026-10-28 (zero catalog hits confirmed)
# Bridge: Path norm = product of layer weight norms along computation paths creates
#   multiplicative constraint defining novel singular fiber structure.

## Background

Path norm (Neyshabur et al.) for an L-layer ReLU network with weights W^(1),...,W^(L)
is defined as:

  ||f||_path = sum over all paths p from input to output of |product_{l=1}^{L} w_p^(l)|

where w_p^(l) is the weight along path p at layer l. Equivalently, for scalar output:

  ||f||_path = sum_{j_1,...,j_{L-1}} |w^{(L)}_{j_{L-1}}| * prod_{l=1}^{L-1} |w^{(l)}_{j_l, j_{l-1}}|

The 1-path-norm bounds the Rademacher complexity and Lipschitz constant of the network.
Path-norm-regularized training minimizes L(f) + gamma * ||f||_path.

## SLT Bridge

Path norm imposes a MULTIPLICATIVE constraint across depth: the product of weights
along each path is bounded. This is fundamentally different from:

- #433 Weight Decay (L2): additive constraint sum ||W^(l)||^2_F — acts on each
  layer independently, fiber is {theta: sum ||W^(l)||^2 <= c}
- #473 Spectral Norm: constrains MAX singular value per layer — max over directions
- #505 Weight Normalization: decomposes w = g * v/||v|| — direction-scale split
- #658 Weight Standardization: constrains per-channel filter to sphere

Path norm is MULTIPLICATIVE OVER DEPTH: the constraint couples all layers through
products along paths. This creates a fiber structure where:

1. Zero paths (any weight = 0) kill entire path subtrees — creating high-codim
   singular strata from single zero entries
2. Path products create polynomial constraint variety (product of weights = c)
3. Depth-dependent singularity: deeper networks have higher-degree products,
   creating more complex singular loci

## C1 (PROVEN): R_an,exp Definability

The path-norm-regularized loss:

  L_pn(theta) = L_data(theta) + gamma * ||f_theta||_path

where ||f_theta||_path = sum_p |prod_l w_p^(l)|.

- L_data is R_an,exp definable (standard, as in all prior syntheses)
- |w| = sqrt(w^2) is definable (algebraic)
- Product of weights is polynomial
- Sum over paths is a finite sum of polynomial terms
- Absolute value via sqrt(w^2) is subanalytic (R_an definable)
- Sum of R_an functions is R_an (closure under addition)
- Therefore ||f||_path is R_an definable
- L_pn = L_data + gamma * ||f||_path is R_an,exp definable
- RLCT exists by Watanabe theorem

## C2 (CONJECTURAL): Multiplicative Path-Product Singular Fiber

The zero-loss fiber of path-norm-regularized training:

  V_pn = {theta : L_data(theta) = 0 AND ||f_theta||_path = 0}

The path norm equals zero iff ALL paths have zero product, i.e., for every path
at least one weight is zero. This creates a rich singular structure:

- **Path-killing strata**: Setting w^(l)_{ij} = 0 kills all paths through edge (i,j)
  at layer l, creating a codimension-1 stratum per zero entry
- **Product variety**: The constraint prod_l w_p^(l) = 0 for all paths defines a
  determinantal-like variety (paths are products, constraints are polynomial)
- **Depth amplification**: In an L-layer network, the path norm polynomial has
  degree L in the weights. The fiber V_pn has singularity structure that
  depends on L — deeper networks have higher-degree multiplicative constraints
- **Sparsity-fiber connection**: Path norm = 0 requires maximal sparsity
  (every path blocked), connecting to lottery ticket / pruning

The singular locus of V_pn includes points where the Jacobian of the path norm
polynomial drops rank. For products of linear forms, this occurs at:
  (a) Points where multiple paths simultaneously vanish (intersection strata)
  (b) Points where the gradient of the path product has linear dependencies

Key novelty: multiplicative coupling across layers creates a fiber that is
NOT a simple intersection of per-layer constraints (unlike L2 weight decay).
The product structure means singularity at layer l propagates through all
downstream paths.

## C3 (CONJECTURAL): gamma as Stratum Selector

The regularization coefficient gamma controls the tradeoff between data fit and
path norm minimization. As gamma increases:

- gamma -> 0: No path norm constraint. Fiber = data-only fiber V_0 (standard)
- gamma -> infinity: Path norm dominates. Fiber -> V_pn (all paths killed)
  = degenerate network (all outputs zero)
- Intermediate gamma: Interpolating family between V_0 and V_pn

The RLCT lambda(gamma) is predicted to be:
- Monotonically decreasing in gamma (more constraint = simpler fiber = lower lambda)
- With a phase transition at gamma* where the path norm constraint becomes
  active enough to change the dominant singular stratum
- At gamma*, the transition from data-fit-dominated to path-norm-dominated
  singularity occurs

Depth dependence: gamma*(L) predicted to decrease with depth, since deeper
networks have more paths and higher-degree products, making path norm
constraint effective at smaller gamma.

## C4 (CONJECTURAL): Generalization Bound

  G_pn <= lambda_pn * log(n) / (2n) + U_pn / sqrt(n)

where lambda_pn is the RLCT of the path-norm-regularized fiber and U_pn
includes the path-norm Lipschitz complexity term.

The path norm directly bounds the Rademacher complexity:
  Rademacher <= C * ||f||_path / sqrt(n)

Combined with SLT:
  G_pn <= lambda_pn * log(n) / (2n) + B_path * ||f||_path / sqrt(n)

Tradeoff: gamma controls lambda_pn (decreasing) vs path norm magnitude
(decreasing) but data fit bias (increasing). Optimal gamma* balances these.

Predicted: G_pn < G_unregularized for moderate gamma, with the multiplicative
constraint providing tighter generalization than additive L2 (#433) because
path norm directly controls the function-space complexity (Lipschitz constant).

## C5 (CONJECTURAL): Depth-Dependent Phase Transition

Path norm has degree L in the weights. The fiber singularity structure depends
on depth:

- Shallow (L=2): Path norm = sum |w^(2) * w^(1)| — bilinear, rank-1 constraint.
  Fiber is a determinantal variety (det-like singularity)
- Deep (L>>2): Path norm = degree-L polynomial. Fiber has higher-codim
  singular strata from path intersections

Predicted phase transition at critical depth L*:
  - For L < L*: Path norm fiber is "simple" (low-degree, manageable singularity)
  - For L > L*: Path norm fiber becomes "complex" (high-degree, many
    intersection strata), and RLCT may increase despite more constraints
  - L* depends on width/depth ratio and gamma

This is the first prediction of depth-dependent RLCT phase transition from
a multiplicative regularization constraint.

## Novel Contributions

1. First SLT analysis of path norm — multiplicative-over-depth regularization
2. Product-of-weights fiber structure (vs additive L2 #433, max spectral #473)
3. Path-killing strata: zero weights create propagating singular directions
4. Depth-degree connection: path norm degree = L, creating depth-dependent
   singularity complexity
5. gamma*(L) depth-dependent phase transition prediction

## Open Problems

1. Is the path-norm zero fiber V_pn a known algebraic variety type?
2. Can SGLD measure lambda_pn(gamma) at different regularization strengths?
3. What is the exact relationship between path norm RLCT and spectral norm RLCT (#473)?
4. Does the depth-dependent phase transition L* exist empirically?
5. How does path norm interact with dropout (#169) or stochastic depth (#562)?
6. Is the product-of-linear-forms variety a determinantal variety or more complex?
7. Can the Rademacher/path-norm bound be decomposed into SLT + Lipschitz terms?

## Cross-references

#8 (ReLU), #16 (depth singularity), #169 (dropout), #433 (weight decay L2),
#473 (spectral norm), #505 (weight normalization), #562 (stochastic depth),
#658 (weight standardization), #569 (gradient penalty Lipschitz)
