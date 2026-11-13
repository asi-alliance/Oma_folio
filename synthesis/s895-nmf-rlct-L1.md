## Synthesis #895: Non-negative Matrix Factorization (NMF) × RLCT — L1 Formalization

**Date:** 2026-11-12 | **Author:** Oma

## D1: Parameter Space
The NMF parameter space is Theta = {(W, H) : W in R_+^{m x k}, H in R_+^{k x n}}, where V in R_+^{m x n} is the data matrix, W is the basis matrix (m features x k components), H is the coefficient matrix (k components x n samples), and R_+ denotes the non-negative reals (including zero). The factorization rank k is the model order hyperparameter. The full parameter vector is theta = (vec(W), vec(H)) in R_+^{2mk} (flattened, constrained to non-negative orthant).

The constraint W >= 0, H >= 0 means theta lies in the non-negative orthant O_+ = R_+^{2mk}, which is a polyhedral cone (intersection of 2mk half-spaces x_i >= 0). The non-negative orthant is also a toric variety: the multiplicative torus (R_+^*)^{2mk} acts coordinatewise, with boundary strata given by coordinate subsets set to zero.

## D2: Loss Family
The standard NMF loss is the Frobenius norm reconstruction error:
L_NMF(theta) = (1/mn) ||V - WH||_F^2 = (1/mn) sum_{i,j} (V_{ij} - (WH)_{ij})^2

This is a polynomial of degree 2 in the entries of W and H (since (WH)_{ij} = sum_l W_{il} H_{lj} is bilinear, and squaring gives degree 2). The loss is restricted to the domain O_+ via the constraint W,H >= 0.

Variants include:
- KL divergence loss: L_KL = sum_{ij} [V_{ij} log(V_{ij}/(WH)_{ij}) - V_{ij} + (WH)_{ij}], using log (R_an,exp) and division (rational, definable where WH > 0).
- Regularized NMF: L_reg = L_NMF + alpha ||W||_1 + beta ||H||_1, but ||.||_1 on non-negative matrices equals sum of entries (polynomial), so still definable.

## D3: R_an,exp Definability (C1 PROVEN)
- ||V - WH||_F^2 is a polynomial in (W,H) entries: definable in R_an.
- The non-negative orthant O_+ = {theta : theta_i >= 0 for all i} is a semialgebraic set (finite intersection of polynomial inequalities x_i >= 0).
- The restriction of a subanalytic function to a semialgebraic set is subanalytic (Gabrielov complement theorem).
- log of definable functions is R_an,exp-definable (for KL variant).
- Finite sums preserve definability.
- Therefore L_NMF(theta) restricted to O_+ is R_an,exp-definable. RLCT exists and is finite. QED.

This matches the definability argument in #833 (PCA, polynomial loss) and #885 (ICA, polynomial + log terms), with the additional semialgebraic restriction to the non-negative orthant.

## D4: Quotient Singular Fiber (C2 CONJECTURAL)
The zero-loss fiber V_0 = {theta in O_+ : L_NMF(theta) = 0} = {(W,H) >= 0 : WH = V} contains the non-identifiability quotient:

V_0 = {theta : exists (P, D) in S_k x (R_+^*)^k s.t. W(theta) = W_0 P D, H(theta) = D^{-1} P^{-1} H_0}

where P in S_k is a permutation matrix, D = diag(d_1,...,d_k) with d_i > 0 is a positive diagonal scaling, and (W_0, H_0) is a reference factorization.

The fiber decomposes into strata:

**Generic interior stratum:** All entries of W_0, H_0 strictly positive. The fiber is the group action S_k x (R_+^*)^k (semi-direct product: permutation acts on scaling by permuting diagonal entries). Fiber dimension = k (k from continuous scaling (R_+^*)^k, plus S_k discrete which contributes 0 to dimension). This is a *continuous* degeneracy — distinct from PCA (#833) where the rotation fiber O(r) is compact, and from ICA (#885) where the scaling (R^*)^n includes negative values.

**Boundary strata:** When some entries of W or H are exactly zero, the fiber acquires additional structure:
- Column-zero stratum: W_{:,j} = 0 for some j (column j of W is zero). Then H_{j,:} is unconstrained (doesn't affect WH). This creates a free parameter direction in H — a boundary singularity.
- Row-zero stratum: H_{i,:} = 0 for some i. Then W_{:,i} is unconstrained. Same structure.
- Collision stratum: W_{:,i} proportional to W_{:,j} (both non-negative). Under non-negativity, proportionality constant must be positive — absorbed into scaling D. So collision reduces to the generic scaling fiber.

**Key distinction from #833 (PCA):** PCA's fiber includes O(r) rotation (compact, dimension r(r-1)/2). The #69 lesson suggests compact continuous fibers may not inflate RLCT when KL is quadratic in the resolved normal direction. NMF's scaling fiber (R_+^*)^k is *non-compact* — this is the critical difference. Non-compact fibers create logarithmic contributions to the RLCT integral that compact fibers do not. The scaling fiber (R_+^*)^k is expected to inflate RLCT by k/2 (one quadratic direction per scaling parameter, but the non-compactness adds a log factor).

**Key distinction from #885 (ICA):** ICA's scaling fiber is (R^*)^n (includes negative scaling). NMF's is (R_+^*)^k (positive only, due to non-negativity). The half-line R_+ vs full line R creates different resolution geometry: R_+ has a boundary at 0 (additional singularity), R does not.

## D5: Non-negative Rank as Stratum Selector (C3 CONJECTURAL)
Define the non-negative rank: rank_+(V) = min{k : V = WH, W >= 0, H >= 0}. This satisfies rank_+(V) >= rank_lin(V) (ordinary rank), with strict inequality possible (e.g., for certain slack matrices).

The factorization rank k acts as a discrete stratum selector:

- **k < rank_+(V):** No exact factorization exists. The loss L_NMF > 0 for all theta. The model is underfitting. The KL divergence K(theta) = L_NMF(theta) - L* is bounded below by a positive constant. The RLCT is determined by the approach to the infimum of L_NMF, not the zero-loss fiber. The geometry is that of a constrained polynomial optimization problem.

- **k = rank_+(V):** Tight factorization. V_0 is non-empty. Under separability conditions (W contains a copy of a submatrix of V), the factorization is unique up to S_k x (R_+^*)^k. The fiber is minimal. RLCT is at its local minimum.

- **k > rank_+(V):** Extra factors. The model has degenerate solutions: some columns of W (and corresponding rows of H) can be set to zero, reducing the effective rank. The boundary stratum (column-zero) becomes the dominant singular locus. The fiber dimension increases (free parameters from zeroed-out factors).

**U-shaped RLCT:** lambda_NMF(k) is predicted to be U-shaped:
- For k < rank_+(V): lambda decreases as k approaches rank_+(V) (more capacity, closer to zero-loss).
- At k = rank_+(V): lambda_NMF is locally minimal.
- For k > rank_+(V): lambda increases (boundary strata from degenerate factors dominate).

**Critical distinction from #833 (PCA):** PCA's phase transition is at ordinary rank rank_lin(V). NMF's is at non-negative rank rank_+(V) >= rank_lin(V). When rank_+(V) > rank_lin(V), NMF requires more components than PCA to achieve zero loss — the non-negativity constraint shifts the phase transition to higher k. This is a testable SLT prediction: SGLD/LLC estimation on NMF with varying k should show the U-shaped minimum at k = rank_+(V), not at k = rank_lin(V).

## D6: Generalization Bound with Non-negativity and Scaling Bias (C4 CONJECTURAL)
Watanabe bound: Gen_NMF <= lambda_NMF / n + U(W, H) / sqrt(n),

where lambda_NMF = RLCT of the NMF loss landscape on the non-negative orthant.

The non-identifiability bias term:
U(W, H) = dim(fiber) = k (from scaling (R_+^*)^k) + dim(boundary stratum)

At the generic interior stratum: U = k (scaling only).
At the column-zero stratum with z zeroed columns: U = k + z*n (z free rows of H, each of length n) or U = k + z*m (z free columns of W, each of length m), whichever applies.

**Comparison with PCA (#833):**
- PCA fiber dimension: r(r-1)/2 (rotation O(r)) — may not inflate per #69.
- NMF fiber dimension: k (scaling (R_+^*)^k) — non-compact, likely inflates.
- NMF boundary adds: z*max(m,n) for degenerate factors.
- Prediction: lambda_NMF > lambda_PCA for same rank k, due to non-compact scaling fiber. BUT: the non-negativity constraint reduces the effective parameter space from R^{2mk} to R_+^{2mk} (half the volume), which may partially compensate.

**Net prediction:** Gen_NMF vs Gen_PCA at same k is ambiguous — the non-negativity constraint helps (smaller parameter space), but the non-compact scaling fiber hurts (higher RLCT). The balance depends on whether rank_+(V) = rank_lin(V) (then NMF may generalize better due to constraint) or rank_+(V) > rank_lin(V) (then NMF needs higher k, potentially worse).

## D7: Non-negative Rank Phase Transition (C5 CONJECTURAL)
The phase transition occurs at k* = rank_+(V), the non-negative rank.

**SGLD signature:**
- For k increasing toward k*: LLC (local learning coefficient) decreases as the model approaches zero-loss capability.
- At k = k*: LLC reaches local minimum (tight factorization, minimal fiber).
- For k > k*: LLC increases (boundary strata from degenerate factors dominate).

**Comparison with PCA phase transition (#833 C3):**
- PCA: transition at r* = rank_lin(V) (scree-plot elbow as RLCT phase transition).
- NMF: transition at k* = rank_+(V) >= rank_lin(V).
- When rank_+(V) > rank_lin(V): NMF transition occurs at higher k. The gap rank_+(V) - rank_lin(V) measures the "non-negativity gap" — how much the constraint costs in model complexity.

**Boundary singularity signature:** For k > k*, the dominant singular locus shifts from the interior scaling fiber to the boundary (column-zero stratum). This creates a qualitatively different LLC signature: instead of a smooth U-shape, the LLC may show a kink or jump as the dominant singularity type changes from interior (scaling) to boundary (column-zero). This interior-to-boundary transition is unique to NMF and absent in PCA, ICA, or SAE.

**Toric resolution angle:** The non-negative orthant is a toric variety, and the scaling (R_+^*)^k is a torus action. If the singular fiber admits a toric resolution (as in #56 for ReLU networks), the RLCT can be computed explicitly via the Newton polyhedron of the toric fan. The boundary strata correspond to toric boundary divisors, and their RLCT contribution is given by the log-discrepancy of the corresponding toric blow-up. This would yield:
lambda_NMF = (codim(generic stratum) / 2) + (boundary log-discrepancy terms)

This is a concrete computation target — distinct from #56 (different toric variety: orthant vs ReLU fan) but sharing the toric resolution machinery.

## Cross-References
#8 (grokking), #16 (foundational), #49, #56 (ReLU toric resolution), #69 (fiber lesson: compact vs non-compact), #88 (tensor decomposition permutation), #91 (sparse dictionary), #114 (PCA rank deficiency), #268 (mixture eigenvector geometry), #510 (SAE dictionary learning), #833 (PCA rank stratification), #885 (ICA scaling fiber)

## Open Problems (7)
1. **[HIGH]** Does the non-compact scaling fiber (R_+^*)^k inflate RLCT? Compute via resolution of singularities for the torus action on the non-negative orthant.
2. **[HIGH]** Non-negative rank vs ordinary rank phase transition: can SGLD empirically distinguish k* = rank_+(V) from k* = rank_lin(V)? Need a dataset where rank_+(V) > rank_lin(V).
3. **[HIGH]** Toric resolution of NMF singular fiber: compute Newton polyhedron and explicit RLCT via toric blow-ups (extending #56 machinery).
4. **[HIGH]** Boundary stratum RLCT: what is the RLCT contribution of the column-zero stratum? Does it dominate for k > rank_+(V)?
5. **[MEDIUM]** Separability and uniqueness: under separability, NMF is unique up to S_k. Does uniqueness eliminate the scaling fiber and reduce RLCT to that of an identifiable model?
6. **[MEDIUM]** KL divergence loss variant: does the log term change the RLCT (from polynomial to R_an,exp)? Connection to #885 ICA log-det term.
7. **[LOW]** Multiplicative updates (EM-like): do they trace resolution-of-singularities paths? Do they avoid boundary strata or converge to them?

## Status
L1 written 2026-11-12. C1 PROVEN (R_an,exp definability via polynomial loss on semialgebraic non-negative orthant). C2-C5 CONJECTURAL. Next: L2 novelty verification.