#524: Weight Tying (Shared Embeddings) × RLCT -- L1 Formalization
Date: 2026-10-22
Status: L1 FORMALIZATION (C1 PROVEN, C2-C5 CONJECTURAL)

## Setup

### Parameter Spaces
- Untied: Theta = Theta_in x Theta_out, Theta_in ~ R^{d x V}, Theta_out ~ R^{d x V}
- dim(Theta) = 2dV (embedding dim d, vocab size V)
- Tied: diagonal Delta = {(W, W) : W in R^{d x V}} isomorphic to R^{d x V}
- dim(Delta) = dV (half of untied)

### Loss Functions
- Untied: L_untied(W_in, W_out) = E_{(x,y)~D} [ell(f_{W_out}(g_{W_in}(x)), y)]
  g_{W_in}: input embedding lookup, f_{W_out}: output projection
- Tied: L_tied(W) = L_untied(W, W) = E_{(x,y)~D} [ell(f_W(g_W(x)), y)]

### Quotient Fiber Structure
- Equivalence: (W_in, W_out) ~ (W_in', W_out') iff W_in = W_in' and W_out = W_out'
- Tying imposes W_in = W_out, defining quotient pi: Theta -> Theta/~
- Zero-loss fiber: F_tied(0) = F_untied(0) intersect Delta
- F_tied(0) = {(W, W) : L_untied(W, W) = 0} -- intersection of untied fiber with diagonal

## C1 (PROVEN): R_{an,exp} Definability

### Claim
L_tied(W) = L_untied(W, W) is R_{an,exp}-definable.

### Proof
1. L_untied(W_in, W_out) is R_{an,exp}-definable (standard neural network loss)
2. Diagonal map iota: W -> (W, W) is polynomial, hence R_{an,exp}-definable
3. L_tied = L_untied composed with iota is composition of R_{an,exp}-definable functions
4. By closure of R_{an,exp} under composition: L_tied is R_{an,exp}-definable
5. Corollary: K_tied(W) = L_tied(W) - min_W L_tied(W) is R_{an,exp}-definable
6. Therefore RLCT lambda_tied is well-defined. QED

## C2 (CONJECTURAL): RLCT Change Under Tying

### Claim
lambda_tied != lambda_untied in general. The diagonal constraint changes singular fiber geometry.

### Argument
- F_untied(0) subset Theta has RLCT lambda_untied from its singularity structure
- F_tied(0) = F_untied(0) intersect Delta is intersection with codimension-dV subspace
- Generic transversality: if Delta meets F_untied(0) transversally, singularity is cut -- typically reducing dimension but potentially changing singularity type
- Non-generic tangency: if Delta is tangent to singular locus of F_untied(0), intersection can be MORE singular
- Dual-role problem: W serving as both input and output may force tangency at optimal W*

### Key Gap
- Whether transversality or tangency is generic depends on F_untied(0) structure
- Dual-role constraint may make tangency non-generic

## C3 (CONJECTURAL): Diagonal as Balanced-Rank Stratum Selector

### Claim
The diagonal Delta selects the balanced-rank stratum of F_untied(0).

### Formalization
- Singular strata of F_untied(0) determined by rank conditions: rank(W_in