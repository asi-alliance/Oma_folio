# Synthesis #495: Kolmogorov-Arnold Networks (KAN) × RLCT — L1 Formalization

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Formal Definitions

**D1 (B-Spline Basis).** A B-spline of degree p with knot vector t=(t_0,...,t_{G+p}) has basis functions B_{i,p}(x) defined by the Cox-de Boor recursion:
- B_{i,0}(x) = 1 if t_i <= x < t_{i+1}, else 0
- B_{i,p}(x) = (x-t_i)/(t_{i+p}-t_i) * B_{i,p-1}(x) + (t_{i+p+1}-x)/(t_{i+p+1}-t_{i+1}) * B_{i+1,p-1}(x)
Each B_{i,p} is piecewise polynomial of degree p on intervals [t_j, t_{j+1}), with C^{p-1} smoothness at knots. The indicator in B_{i,0} makes the basis semi-algebraic (polynomial inequalities).

**D2 (KAN Edge Function).** A KAN edge from node j to node i computes:
phi_{ij}(x) = sum_{m=1}^{G+p} c_{ij,m} * B_{m,p}(x; t_{ij})
where c_{ij,m} are learnable coefficients and t_{ij} are learnable knot vectors. Parameters per edge: theta_{ij} = (c_{ij,1},...,c_{ij,G+p}, t_{ij,0},...,t_{ij,G+p}). Total parameter space W = {theta_{ij}} with dimension d_w.

**D3 (KAN Layer).** A KAN layer with input dimension d_in and output dimension d_out computes:
f_l(x)_i = sum_{j=1}^{d_in} phi_{ij}(x_j) for i=1,...,d_out
This is a sum of univariate spline functions (Kolmogorov-Arnold representation), one per edge.

**D4 (KAN Network).** An L-layer KAN: F_w(x) = f_L(f_{L-1}(...f_1(x))) where each f_l is a KAN layer. The loss is K(w) = (1/N) sum_s [-log p_w(y_s|F_w(x_s))] with softmax output. Parameters w = {theta_{ij}^{(l)}} for all edges across all layers.

**D5 (Knot Configuration Space).** For edge (i,j), the knot configuration is the ordered tuple t_{ij} = (t_0 <= t_1 <= ... <= t_{G+p}). The knot stratification partitions parameter space by knot ordering:
- Simple stratum S_simple: all knots distinct (t_0 < t_1 < ... < t_{G+p})
- Coalescence stratum S_coalesce(k): exactly k pairs of adjacent knots coincide
- Degenerate stratum S_deg: three or more knots coincide
The singular locus V_KAN includes all strata where knot coalescence changes the piecewise-polynomial structure.

**D6 (KAN RLCT).** The RLCT for KAN at parameter w is:
lambda_KAN = max_{w' in V_KAN} RLCT_{w'}(K(w))
where V_KAN = V_smooth ∪ V_knot ∪ V_coef
- V_smooth: singular locus from the smooth spline composition (analogous to MLP smooth-activation singular fiber)
- V_knot: singular locus from knot boundaries {x : t_j <= x < t_{j+1}} (semi-algebraic hypersurfaces in input space, parameter-dependent via t_{ij})
- V_coef: singular locus from coefficient degeneracy (c_{ij,m}=0 for some m, analogous to weight-zero MLP fibers)

**D7 (Grid Resolution).** Grid resolution G = number of knot intervals per edge. At G=1: single polynomial piece per edge (linear approximation, minimal knot boundaries). At G→∞: infinite resolution (B-spline converges to smooth function, knot boundaries dense). The RLCT decomposes:
lambda(G) = max(lambda_smooth(G), lambda_knot(G), lambda_coef(G))
where lambda_knot(G) ~ (G+p)/2 * (number of active knot boundaries) increases with G, and lambda_smooth(G) decreases with G (better approximation = closer to true function = lower RLCT near true fiber).

## Formal Claims

**C1 (PROVEN): R_an,exp-definability of KAN loss.**

*Proof.* B-spline basis functions B_{i,p}(x;t) are defined by the Cox-de Boor recursion, which is a finite composition of:
1. Indicator functions 1_{[t_j,t_{j+1})} — semi-algebraic (polynomial inequalities t_j <= x and x < t_{j+1})
2. Polynomial divisions (x-t_i)/(t_{i+p}-t_i) — rational functions, definable where denominator nonzero (semi-algebraic open set)
3. Finite sums and products of the above

By induction on p, each B_{i,p} is piecewise polynomial with semi-algebraic pieces. The pieces are glued along semi-algebraic boundaries (knot hyperplanes x=t_j). By Tarski-Seidenberg, the graph of each B_{i,p} is subanalytic, hence R_an-definable.

The KAN edge phi_{ij}(x) = sum_m c_{ij,m} B_{m,p}(x;t_{ij}) is a finite linear combination of R_an-definable functions, hence R_an-definable. The KAN layer and network are finite compositions of linear maps and KAN edges, preserving definability. The KL divergence K(w) = (1/N) sum_s [-log p_w(y_s|F_w(x_s))] involves log and softmax (exp), which are in R_an,exp. Finite sums preserve definability. Therefore K(w) is R_an,exp-definable. QED.

**C2 (CONJECTURAL): Movable knot singularities create parameter-dependent singular fibers.**

In MLPs with fixed ReLU, the activation non-differentiability at x=0 is fixed in input space — the singular fiber structure depends only on weights, not on activation location. In KANs, knots t_{ij} are learnable parameters, so the non-differentiability locations move with w. When two knots coalesce (t_j = t_{j+1}), the B-spline loses a polynomial piece, creating a singularity in the parameter-to-function map. The fiber structure changes:
- For distinct knots: the edge function has G+p polynomial pieces
- For coalesced knots: the edge function has fewer pieces (reduced expressivity)
This creates a stratification of parameter space by knot configuration, with singular fibers at coalescence boundaries. These parameter-dependent singular fibers are absent in fixed-activation MLPs where the activation structure is immutable.

**C3 (CONJECTURAL): KAN RLCT structure — smoothness vs knot boundary tradeoff.**

Conjecture: lambda_KAN = max(lambda_smooth, lambda_knot, lambda_coef) where:
- lambda_smooth: RLCT from the smooth (C^{p-1}) spline composition. For p>=2, the activation is differentiable, removing ReLU-type kink singularities. This INCREASES RLCT relative to ReLU (smoother = fewer singularities = higher RLCT, since RLCT measures the complexity of the most singular stratum).
- lambda_knot: RLCT from knot boundaries. Each knot boundary is a semi-algebraic hypersurface (codim 1), contributing RLCT >= 1/2 per active boundary. With G+p knots per edge and E edges, total knot boundaries ~ (G+p)*E.
- lambda_coef: RLCT from coefficient degeneracy, analogous to MLP weight-zero fibers (#49).

Key prediction: for low-degree splines (p=1, linear B-splines), lambda_knot dominates (many boundaries, low smoothness). For high-degree (p>=3), lambda_smooth dominates (fewer effective singularities from smoothness, but knot boundaries still present). The optimal degree p* minimizes lambda_KAN.

**C4 (CONJECTURAL): KAN interpretability <-> low RLCT via knot-aligned singularity resolution.**

For target functions with natural breakpoints (e.g., piecewise-linear with K breakpoints):
- MLP must approximate each breakpoint with multiple ReLU units, creating redundant singularities. The RLCT reflects this redundancy: lambda_MLP ~ K_redundant / 2 where K_redundant > K.
- KAN can place knots exactly at breakpoints, resolving each singularity with a single spline piece. lambda_KAN ~ K / 2 (one knot per breakpoint, no redundancy).

Conjecture: for breakpoint-rich functions, lambda_KAN < lambda_MLP. For smooth functions without breakpoints, lambda_KAN >= lambda_MLP (KAN adds unnecessary knot boundaries). The interpretability advantage of KAN is an RLCT advantage for structured (non-smooth) target functions.

**C5 (CONJECTURAL): Grid refinement as singularity resolution — U-shaped RLCT in G.**

Grid refinement (increasing G) adds more knot intervals:
- For G < G*: each new knot interval can capture a natural breakpoint, reducing lambda_smooth (better approximation). Lambda_knot increases but is dominated. Lambda(G) decreases.
- At G = G*: all natural breakpoints captured. Lambda_smooth is minimal.
- For G > G*: excess knots create unnecessary boundaries. Lambda_knot increases (more semi-algebraic hypersurfaces). Lambda_smooth no longer decreases (already at minimum). Lambda(G) increases.

Conjecture: lambda(G) is U-shaped with minimum at G*. G* depends on the number of natural breakpoints in the target function. SGLD prediction: measure lambda_hat(G) for G = {1, 2, 4, 8, 16, 32} on a piecewise-linear target; expect U-shape with G* ~ K (number of breakpoints).

## Open Problems

1. [HIGH] Formal lambda_knot computation: for B-spline degree p with G intervals, is lambda_knot = (G+p)/2 or (G+p)*codim/2 where codim depends on knot boundary structure?
2. [HIGH] C2-smoothness vs C0 tradeoff: does removing ReLU kinks increase or decrease total RLCT? Mechanisms conflict.
3. [HIGH] SGLD protocol: train KAN and MLP on same piecewise-linear task, compare lambda_hat.
4. [MEDIUM] Knot coalescence dynamics: does the singular fiber vary continuously or jump at coalescence?
5. [MEDIUM] KAN width vs grid resolution: which contributes more to RLCT reduction for structured functions?
6. [MEDIUM] Interaction with #494 (Activation Sparsification): sparse KAN = selection boundaries + knot boundaries = double singularity.
7. [LOW] Kolmogorov-Arnold theorem constraint: does the KA representation (univariate edge functions) impose lower-dimensional singular structure than MLP (multivariate node functions)?

## Cross-References

#8 (RLCT basics), #16 (Watanabe SLT/SGLD), #49 (ReLU singularity), #58 (R_an definability), #72 (smooth activation), #73 (Tarski-Seidenberg), #132 (interpretability), #137 (SAE), #353 (ELU/SELU/Softplus), #396 (GLA), #494 (Activation Sparsification)

## Status
L1 written 2026-10-21. Next: L2 novelty verification.
