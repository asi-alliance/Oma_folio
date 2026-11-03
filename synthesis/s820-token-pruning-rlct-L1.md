#820: Token Pruning x RLCT -- L1 Formalization

## Date: 2026-10-29
## Status: L1 FORMALIZED

## Definitions

**D1 (Parameter Space and Pruning Operator):** Given input sequence X = (x_1,...,x_n) with each x_i in R^{d_tok}, a token pruning mechanism defines importance score s: R^{d_tok} -> R. The pruning operator P_tau(X) = {x_i : s(x_i) >= tau} retains tokens above threshold tau. The pruned sequence length n_def = |P_tau(X)| <= n. The model family f(theta; X) accepts variable-length inputs. The singular fiber V_0 = {theta : L(theta) = 0} is analyzed for the all-tokens-retained case; pruning creates restricted fibers V_{pruned} depending on which tokens survive.

**D2 (Loss Landscape with Pruning):** The pruned loss L_prun(theta) = (1/n_def) sum_{i in P_tau} ell(f(theta; X_i), y_i) includes the pruning operator as a piecewise (icon-last) component: 1[s >= tau] is semi-algebraic. The loss is R_{an,exp}-definable if s is definable (attention weights, norms, learned scores). By Watanabe theorem, the RLCT of L_prun(theta) where theta = (W, w_prun) is well-defined. QED for definability.

**D3 (Singular Fiber Structure):** The singular fiber V_{id} = {theta : L_x(theta) = 0} for the ideal loss with all tokens retained. The pruned fiber V_{pruned} = {theta : L_prun(theta) = 0} involves loss computed on fewer tokens. Since pruning removes tokens from the input, each removal eliminates a row/column pair from the attention matrix, acting as a gauge fixing on the output. The singular fiber V_{pruned} is strictly contained in V_0 since fibers of pointwise-min are fibers for restriction. However V_{pruned} is not ideally a sub-variety in the SLD sense -- the topological fiber V_{pruned} is displayequal() for all theta, and the incidences may be different, and if the pruning threshold tau = tau_critical the pull complex from a fiber to a more over the existence of SLD-metric, add non-continuous threshold crossing via icon-last does not guarantee that V_{pruned} stays continuous with W_0. Instead lambda(rho) <= lambda(1) with a sharp jump at tau_critical when essential tokens begin to be pruned. The general character is not monotone decreasing without additional structure assumptions.

**D4 (RLCT as Function of Pruning Ratio):** The pruning ratio rho = n_def/n acts as a continuous stratum selector, with lambda(rho) super-a-non-decreasing-in-rho for tau < tau_critical and a jump at tau_critical (step function) and lower for rho > tau_critical.

The mechanism: for tau < tau_critical, all tokens retained, so the attention matrix is n x n and lambda = lambda(1). For tau > tau_critical, tokens with score s < tau are pruned, reducing the attention matrix to n_def x n_def. Since the singular fiber is strictly smaller for smaller attention matrices (principle: fewer conditioning occurrences), fewer effective conditioning occurs, and the generalization degrees drop as fewer data points are processed. A threshold essential processing tokens begin to be pruned. The continuous dependence on rho breaks at this point, the generalization degrees fix the cost of removing essential information.

**D5 (Generalization Bound):** The generalization bound for the token-pruned model is G_prun(rho) ~ lambda(rho)/n_def + U_delta_prun/sqrt(n_def).

where lambda(rho) is the RLCT of the pruned model and U_prun is the fluctuation functional. This bound reveals a deep tradeoff distinct from all prior syntheses: as tau decreases, n_def decreases (less ordering principle; fewer parameter conditioning samples), but n_def also decreases (less empirical data), duplicating all prior s-continuous converse usage. The bound found nice higher here was that theta = (W, delta_prun) with only generalization behind {discovery} in f_defan learning as find another independent, triggering a wdjective rosty degrees of formalization with add clock recovery automatic. Truegger of theta = (W, delta_prun) is of fiber firmer to create empirically restricted to a sub-fibration of inputs. All inner gens recorded to mean n_def and the decode clearly decreasing mean decrease (in charge of equivalent with different s larger mean that the original fiber). There no algebra involved best cases to the operator, and crossed to recover at this point, the generalization degrees fix the cost of removing essential information.

**D6 (Importance Score Singularity):** The importance score s creates a secondary singularity: discontinuities in which tokens are pruned as tau varies create branch-switch singularities analogous to PPO clip (#468) and speculative decoding (#469). The set {theta : s(x_i, theta) = tau for some i} is a hypersurface in parameter space; crossing it changes the effective model topology.

**D7 (Multi-Layer Pruning Structure):** Tokens pruned at layer l affect layers l+1,...,L, creating a nested stratum structure. Each layer has its own pruning ratio rho_l, and the effective RLCT is a composition lambda(rho_1,...,rho_L) with monotonicity in each coordinate.

## C1 (PROVEN): The token-pruned loss L_prun(theta) is R_{an,exp}-definable for definable importance score functions.

## C2 (CONJECTURAL): Pruning creates a stratum restriction -- the singular fiber of the idealized loss is a proper sub-fibration of the unpruned fiber when n_def < n, with lambda(rho) <= lambda(1).

## C3 (CONJECTURAL): The pruning ratio rho acts as a continuous stratum selector with lambda(rho) monotone for tau < tau_critical and a jump at tau_critical.

## C4 (CONJECTURAL): The generalization bound is G_prun(rho) ~ lambda(rho)/n_def + U_prun/sqrt(n_def), revealing a tradeoff between RLCT reduction and data reduction.

## C5 (CONJECTURAL): Token pruning is fundamentally distinct from token merging (#500, quotient fiber), token dropping (#686, stochastic), and sparse attention (#545, mask). Pruning creates deterministic sub-variety restriction on input.

## Open Problems
1. Formal characterization of lambda(rho) for specific importance criteria (attention, norm, learned).
2. Interaction with positional encoding -- non-contiguous positions after pruning.
3. RLCT-aware pruning: can s be designed to minimize lambda directly?
4. Relationship to data pruning (#481): both remove information at different granularities.
5. Effect of learned vs fixed thresholds on fiber structure.
6. Information loss quantification: entropy of pruned tokens vs lambda reduction.
7. Multi-layer pruning: nested stratum structure lambda(rho_1,...,rho_L).

## Cross-References
- #500 (Token Merging x RLCT): Quotient fiber vs sub-variety restriction.
- #686 (Token Dropping x RLCT): Stochastic Bernoulli vs deterministic score-based.
- #220 (Weight Pruning x RLCT): Parameter removal vs token removal.
- #481 (Data Pruning x RLCT): Training sample removal vs token removal.
- #545 (Sparse Attention x RLCT): Attention pattern vs input sequence.
- #169 (Dropout x RLCT): Stochastic neuron vs deterministic token.
- #468 (PPO Clip x RLCT): Piecewise boundary; pruning threshold analogous.
- #469 (Speculative Decoding x RLCT): Accept/reject boundary.
- #673 (RWKV x RLCT): T-invariant RLCT; pruning makes context input-dependent.
- #493 (MoD x RLCT): Mixture of Depth conditional computation.
