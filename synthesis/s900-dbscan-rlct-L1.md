## Synthesis #900: DBSCAN x RLCT -- L1 Formalization

Date: 2026-11-12

## D1 (Surrogate Loss Model Space)

Let X = {x_1, ..., x_n} be data points in R^d. Define the partition space:

  P_n = {pi : pi is a partition of {1,...,n} into clusters C_1,...,C_K plus noise set N}

For parameters (epsilon, minPts), define:

  N_eps(p) = {q in X : ||p - q|| <= epsilon}
  core(p) = 1[|N_eps(p)| >= minPts]
  directly_reachable(p, q) = core(p) AND q in N_eps(p)
  reachable(p, q) = transitive closure of directly_reachable
  connected(p, q) = exists o: reachable(o, p) AND reachable(o, q)

The surrogate loss model space:

  Theta_DBSCAN = {(pi, epsilon, minPts) : pi is consistent with density-connectivity for (epsilon, minPts, X)}

A partition pi is consistent iff:
  (a) Each cluster C_k is a maximal set of density-connected points
  (b) Noise set N = points not density-reachable from any core point
  (c) Border points assigned to exactly one reachable cluster

## D2 (Surrogate Loss Function)

L_DBSCAN(pi, epsilon, minPts) = sum_i L_i(pi, epsilon, minPts)

where:

  L_i = 0  if x_i is correctly classified by DBSCAN(pi, epsilon, minPts)
  L_i = 1  otherwise

Correctness check per point:
  - If core(x_i): x_i must be in some cluster C_k (not noise)
  - If border: x_i must be in a cluster C_k reachable from a core point
  - If noise: x_i must be in N

Formally, L_i is a Boolean combination of:
  (1) Polynomial inequalities: ||x_i - x_j||^2 <= epsilon^2  (semialgebraic)
  (2) Cardinality: sum_j 1[||x_i - x_j||^2 <= epsilon^2] >= minPts  (semialgebraic)
  (3) Graph connectivity: exists path in N_eps-graph from core to x_i

The loss L_DBSCAN is piecewise-constant and R_{an,exp}-definable (C1).

## D3 (Singular Fiber)

V_0(epsilon, minPts) = {pi in P_n : L_DBSCAN(pi, epsilon, minPts) = 0}

= {partitions that are valid DBSCAN outputs for (epsilon, minPts, X)}

Fiber structure:

  (a) Core points with unique cluster: fiber = singleton (regular)
  (b) Border points with single-cluster reachability: fiber = singleton (regular)
  (c) Border points with multi-cluster reachability: fiber = product of choice sets
      For each ambiguous border point b, fiber factor = {C_k : b reachable from C_k}
      This is the SINGULAR LOCUS
  (d) Noise points: fiber = {N} (singleton, boundary stratum)

Singular locus Sing(V_0) = {pi : at least one border point has |{reachable clusters}| >= 2}

Singular fiber dimension (combinatorial):
  dim_sing = sum over ambiguous border points b of (|reachable_clusters(b)| - 1)

This is FINITE (bounded by n * K). Contrast with #872 k-means S_k fiber (algebraic, dimension k(k-1)/2).

## D4 (Parameterized Stratum Family)

For (epsilon, minPts) in R_+ x N, define:

  Stratum(epsilon, minPts) = {pi : pi = DBSCAN(X, epsilon, minPts)}

The (epsilon, minPts) parameter space is tiled by open cells:

  Cell(pi_0) = interior of {(epsilon, minPts) : DBSCAN(X, epsilon, minPts) = pi_0}

Cell boundaries are at:
  (1) epsilon = ||x_i - x_j|| for some pair (i,j)  [edge appearance/disappearance]
  (2) minPts = |N_eps(x_i)| for some point x_i  [core/border transition]

Within each cell, the partition is constant. The RLCT lambda is constant within each cell.

Critical values: epsilon* = {||x_i - x_j|| : i neq j} (at most n(n-1)/2 values)

## D5 (epsilon as Continuous Stratum Selector -- C3 CONJECTURAL)

Claim C3 (CONJECTURAL): epsilon acts as continuous stratum selector.

- epsilon < min_{i<j} ||x_i - x_j||: graph fully disconnected, all points noise.
  Fiber: trivial singleton {all-noise}. lambda = 0 (trivial fiber, no singularity).

- epsilon increasing through critical values: edges appear, components merge.
  Core points emerge when |N_eps(p)| reaches minPts. Clusters form.
  Fiber: non-trivial, ambiguous border points create singular stratum.
  lambda > 0.

- epsilon large (>= max distance): fully connected graph. If minPts <= n, all points core.
  Single cluster. Fiber: trivial singleton. lambda = 0.

Profile: lambda(epsilon) is a STAIRCASE:
  - Constant within each cell
  - Jumps at each critical epsilon* = ||x_i - x_j||
  - Zero at extremes (all-noise, all-one-cluster)
  - Positive in intermediate regime (non-trivial clustering)

This is distinct from:
  - #888 spectral clustering: U-shaped lambda(sigma) with smooth minimum
  - #887 UMAP: U-shaped lambda(n_neighbors)
  - #872 k-means: monotonic lambda(k) with jump at K*

DBSCAN lambda(epsilon) is NON-MONOTONIC and DISCONTINUOUS (staircase with jumps).

minPts as discrete selector: increasing minPts reduces core set, increases noise, fragments clusters. Lambda shifts upward (more ambiguous borders) then drops (too few core points = trivial).

## D6 (Generalization Bound -- C4 CONJECTURAL)

Claim C4 (CONJECTURAL):

G_DBSCAN(epsilon, minPts) <= lambda(epsilon, minPts) * log(n) / (2n) + U(epsilon, minPts) / sqrt(n)

where:
  lambda(epsilon, minPts) = RLCT of surrogate loss at selected stratum
    = dim_sing (combinatorial fiber dimension from D3)
    = sum over ambiguous border points of (|reachable_clusters| - 1)

  U(epsilon, minPts) = combinatorial complexity term
    = log(|{valid DBSCAN partitions for (epsilon, minPts, X)}|)
    + log(number of critical epsilon values crossed)

Key insight: lambda and U have OPPOSING behavior across epsilon:
  - Small epsilon: lambda = 0 (trivial fiber), U = 0 (unique partition = all-noise). G = 0 but useless.
  - Intermediate epsilon: lambda > 0 (ambiguous borders), U > 0 (multiple valid partitions). G > 0.
  - Large epsilon: lambda = 0 (single cluster), U = 0. G = 0 but useless.

Optimal epsilon* is at a stratum boundary where the tradeoff lambda*log(n)/(2n) + U/sqrt(n) is minimized while producing meaningful clustering.

Comparison to #888: spectral clustering has G proportional to 1/(eigengap). DBSCAN has G proportional to combinatorial fiber dimension (counting ambiguous borders), not a spectral quantity.

## D7 (Phase Transition -- C5 CONJECTURAL)

Claim C5 (CONJECTURAL): Phase transitions at critical epsilon* = ||x_i - x_j||.

At each epsilon* where an edge (i,j) appears/disappears in the N_eps-graph:

  (1) Graph topology changes (components merge/split)
  (2) Core status of nearby points may change (|N_eps(p)| crosses minPts threshold)
  (3) Cluster assignment of border points may change
  (4) RLCT lambda(epsilon) JUMPS discontinuously

Detection via SGLD on surrogate loss:
  - Within a cell: LLC = lambda (constant)
  - At epsilon*: LLC jumps (discontinuity in lambda)
  - Magnitude of jump = change in dim_sing = change in number of ambiguous border points

Most significant transitions:
  (a) First cluster formation: epsilon crosses min pairwise distance within a dense region. lambda jumps from 0 to >0.
  (b) Cluster merge: two clusters connect via a border point. Ambiguous border count may increase then decrease.
  (c) All-noise to all-core: epsilon crosses max distance. lambda returns to 0.

HDBSCAN connection (open problem): the hierarchical epsilon sweep traces a PATH through stratum boundaries. Each level of the hierarchy corresponds to a stratum. Stable clusters (persisting across many epsilon levels) correspond to strata with LOW lambda (few ambiguous borders). This connects HDBSCAN stability to RLCT smoothness.

## Status: L1 COMPLETE
Next: L2 novelty verification
