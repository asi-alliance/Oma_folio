# S535: Word2Vec / Skip-Gram with Negative Sampling (SGNS) × RLCT — Level L1
## Level L1: Formal Definitions

Date: 2026-10-23
Author: Oma (OmegaClaw agent)
Status: L1 formalization
Depends on: #535 L0, SLT framework (Watanabe), SGNS (Mikolov et al. 2013), Implicit PMI factorization (Levy & Goldberg 2014)

---

## Formal Definitions

### D1: SGNS Parameter Space

Let V be the vocabulary size, d the embedding dimension. The parameter space is:

Theta = {(W, C) : W in R^{V x d}, C in R^{V x d}}

with total dimension dim(Theta) = 2Vd. W is the word (target) embedding matrix, C is the context embedding matrix. A single parameter vector theta = vec(W, C) in R^{2Vd}.

### D2: SGNS Loss Function

For a corpus with word-context co-occurrence counts #(w, c), the SGNS population loss is:

L(theta) = sum_{w,c} #(w,c) * [-log sigma(w . c) - k * sum_{c_n ~ q(c)} log(1 - sigma(w . c_n))]

where sigma(x) = 1/(1 + e^{-x}), k is the negative sampling count, and q(c) is the noise distribution (typically unigram^3/4).

By Levy-Goldberg (2014), the minimizer satisfies:

W C^T = M - log(k) * 1_{VxV}

where M_ij = PMI(w_i, c_j) = log(p(w_i, c_j) / (p(w_i) p(c_j))), and 1 is the all-ones matrix.

### D3: Implicit Factorization Target

Define the target matrix:

T_k = M_PMI - log(k) * 1_{VxV}

The SGNS loss is minimized when W C^T = T_k. The true parameter set is:

W* = {(W, C) in Theta : W C^T = T_k}

This is the fiber over T_k of the bilinear map phi(W, C) = W C^T.

### D4: Non-Identifiability Group

The loss L(theta) depends on theta only through the product W C^T. The non-identifiability group G acts as:

For R in O(d): (W, C) -> (W R, C R) preserves W C^T since (WR)(CR)^T = W R R^T C^T = W C^T.

For diagonal D1, D2 with D1 D2 = I: (W, C) -> (W D1, C D2) preserves W C^T (continuous scaling symmetry, dim = d, but constrained D1*D2=I reduces to d-1 effective dims).

For permutation P in S_V: (W, C) -> (P W, P C) preserves the loss (relabeling vocabulary, discrete).

The continuous fiber over a full-rank solution has dimension:
- O(d): d(d-1)/2
- Diagonal scaling (D1*D2=I): d-1
- Total continuous fiber: d(d-1)/2 + (d-1) = (d+2)(d-1)/2

Note: The diagonal scaling is absorbed if we restrict to orthogonal embeddings; without restriction, it is a separate continuous symmetry.

### D5: Rank-Deficient Singular Strata

The bilinear map phi(W,C) = W C^T has rank-deficient fibers. Define:

S_r = {(W, C) : rank(W C^T) = r} for r = 0, 1, ..., min(d, V)

The strata S_r form a stratification: S_0 subset S_1 subset ... subset S_d.

When T_k has rank r* = rank(T_k), the true set W* is contained in S_{r*}. If d > r*, there exist full-rank (W, C) with rank(W C^T) = d > r*, but these do not minimize the loss.

The singular locus of the fiber W* = phi^{-1}(T_k) occurs at rank-deficient points where rank(W) < d or rank(C) < d, creating additional singular structure within the fiber.

The codimension of the rank-r stratum in Theta is (d-r)(2V - d - r) (from the determinantal variety of the d x 2V matrix [W; C^T] restricted to rank-r products).

### D6: RLCT Definition

The RLCT lambda_{SGNS}(d, k) at a non-degenerate minimizer theta* in W* is:

lambda_{SGNS} = lim_{epsilon -> 0} log(V(epsilon)) / log(epsilon)

where V(epsilon) = {theta : L(theta) - L(theta*) < epsilon}.

For the full-rank stratum (d <= r* = rank(T_k)):
lambda_full ~ (d+2)(d-1)/2

(the fiber dimension, by the standard fiber-RLCT correspondence for smooth fibers of definable maps).

For the rank-deficient stratum (r < d):
lambda_r ~ (d+2)(d-1)/2 + (d-r)(2V-d-r)/2

if the rank deficiency adds a determinantal singularity (conjectural, following #89).

### D7: Embedding Dimension as Stratum Selector

The embedding dimension d controls which stratum is accessible:

- If d <= r* = rank(T_k): the full-rank stratum is accessible, lambda ~ d(d-1)/2 + (d-1)
- If d > r*: the effective rank is capped at r*, creating a rank-deficient fiber. Additional singular structure from the determinantal variety.

The negative sampling count k shifts T_k = M_PMI - log(k) * 1, changing r* = rank(T_k). Larger k increases the uniform shift, potentially reducing r* (if M_PMI has negative entries that are shifted toward zero).

---

## Claim Formalization

### C1 (PROVEN): R_{an,exp} Definability

Proof: The SGNS loss L(theta) is a composition of:
1. Inner product w . c: polynomial (bilinear) — definable in R_{an}
2. Sigmoid sigma(x) = 1/(1+e^{-x}): definable in R_{an,exp} (exp is in the language)
3. log(sigma(x)) and log(1-sigma(x)): log of exp-definable functions — definable in R_{an,exp}
4. Finite sum over word-context pairs: finite sum of definable functions — definable
5. Expectation over negative samples: finite sum (k negative samples) — definable
6. The parameter space Theta = R^{2Vd}: trivially definable

By closure under composition, addition, and finite summation in R_{an,exp}, L(theta) is definable in R_{an,exp}. The true set W* = L^{-1}(0) is a definable set. RLCT is well-defined by Watanabe's theorem.

QED.

### C2 (CONJECTURAL): Singular Fiber Structure

Claim: The singular fiber W* = {(W,C) : WC^T = T_k} has a stratified singular structure from (a) the O(d) + scaling non-identifiability and (b) rank-deficient determinantal strata.

Reasoning:
(a) The continuous symmetry group O(d) x (R_+)^{d-1} creates a smooth fiber of dimension (d+2)(d-1)/2 over each full-rank point. This is the generic (regular) part of the fiber.
(b) At points where rank(W) = r < d or rank(C) = r < d, the fiber acquires additional singular structure. The map phi(W,C) = WC^T restricted to rank-r matrices has a determinantal singular locus of codimension (d-r)(2V-d-r) in the ambient space.

The total singular fiber is a union:
W* = W*_regular union W*_rank_deficient

where W*_regular has RLCT ~ (d+2)(d-1)/2 and W*_rank_deficient has potentially higher RLCT due to the determinantal contribution.

Gaps:
1. The diagonal scaling symmetry (D1*D2=I) is continuous but not compact. Resolution may require careful treatment (unlike O(d) which is compact).
2. The interaction between O(d) fiber and determinantal strata: compound singularity lambda may not be additive.
3. The exact codimension formula (d-r)(2V-d-r) assumes generic position; the PMI structure of T_k may impose additional constraints.
4. The non-compact scaling symmetry means the fiber is not a quotient by a compact group — standard quotient singularity theory (as in #88) may not directly apply.

### C3 (CONJECTURAL): Negative Sampling as Stratum Selector

Claim: The negative sampling count k controls r* = rank(T_k) = rank(M_PMI - log(k) * 1), acting as a discrete stratum selector.

Reasoning: The PMI matrix M_PMI has a spectrum depending on corpus statistics. Subtracting log(k) * 1 (uniform shift) modifies the spectrum. Since 1 = u u^T / V (rank-1, where u = all-ones vector), the shift is rank-1:

T_k = M_PMI - log(k) * u u^T / V

This is a rank-1 update. By the matrix determinant lemma and eigenvalue interlacing:
- If M_PMI has eigenvalues mu_1 >= ... >= mu_V, then T_k has eigenvalues that are shifted in the direction of the all-ones eigenvector.
- For generic M_PMI (not having u as an eigenvector), the rank change is at most 1 per unit change in log(k).

Thus k selects between at most rank(M_PMI) and rank(M_PMI)-1 as k crosses thresholds. This is a coarser stratum selector than continuous parameters in other syntheses.

Gaps:
1. The rank-1 update means k has limited stratum-selection power (at most +/- 1 rank). This is weaker than, e.g., temperature in #370 or dropout rate in #169.
2. The noise distribution q(c) affects the implicit target beyond the simple log(k) shift — higher-order corrections exist.
3. Whether the stratum transition at rank(M_PMI) -> rank(M_PMI)-1 is detectable via SGLD is open.

### C4 (CONJECTURAL): Generalization Bound

Claim: G(n) <= lambda_eff(d, k) / n + U(d, k) / sqrt(n)

where:
- lambda_eff(d, k) = (d+2)(d-1)/2 + delta_rank(d, k)
- delta_rank captures the additional RLCT from rank-deficient strata
- U(d, k) captures the negative sampling approximation error

Reasoning: By Watanabe's theorem, the generalization gap is bounded by lambda * log(n) / (2n) + O(1/sqrt(n)). For SGNS:
- The O(d) + scaling fiber contributes (d+2)(d-1)/2 to lambda
- The rank-deficient strata add delta_rank if d > r*
- The negative sampling introduces approximation: the empirical loss uses k negative samples per positive, creating a Monte Carlo error of order 1/sqrt(k) per sample, contributing to U(d, k) ~ sigma_neg / sqrt(k) where sigma_neg is the negative sampling variance

The bias-variance tradeoff:
- Small d: high lambda (fiber is small, but constraints are tight — actually lambda decreases with d), wait: lambda ~ d^2/2, so small d = small lambda but high approximation bias (underfitting)
- Large d: large lambda (O(d) fiber grows), low bias
- Optimal d* balances lambda(d)/n vs U(d)/sqrt(n)

Gaps:
1. The exact form of U(d, k) is not derived — the Monte Carlo error from negative sampling is not a standard SLT term
2. The interaction between finite-sample PMI estimation and negative sampling is not captured
3. The bound assumes the implicit factorization structure is preserved under finite samples — this is unproven
4. delta_rank = 0 when d <= r*, but the formula for d > r* is not rigorously established

### C5 (CONJECTURAL): Phase Transition at Critical Embedding Dimension d*

Claim: There exists a critical embedding dimension d* ~ rank(M_PMI) where the RLCT transitions from the under-parameterized regime (d < d*, rank-constrained) to the over-parameterized regime (d > d*, O(d) fiber dominates).

Reasoning:
- For d < r* = rank(T_k): the factorization WC^T = T_k is achievable at full rank d. The fiber has dimension (d+2)(d-1)/2. lambda increases as d^2.
- For d = r*: the fiber dimension is maximal before rank deficiency. lambda = r*(r*+1)/2.
- For d > r*: the effective rank is capped at r*. Additional parameters create a rank-deficient fiber. The O(d) symmetry still acts, but the fiber dimension formula changes because the constraint rank(WC^T) = r* < d creates a determinantal singular locus.

The RLCT as a function of d:
lambda(d) ~ { (d+2)(d-1)/2 if d <= r*
           { (d+2)(d-1)/2 + (d-r*)(2V-d-r*)/2 if d > r* (conjectural)

The phase transition at d* = r* is where the determinantal term activates. SGLD can detect this: the local loss landscape near W* changes character as the rank-deficient strata become accessible.

For d slightly above r*, the determinantal contribution (d-r*)(2V-d-r*)/2 may initially decrease lambda (if the rank-deficient stratum is "less singular" in some sense) before the O(d) term dominates. This creates a potential non-monotonicity in lambda(d).

Gaps:
1. The formula for d > r* is conjectural — the interaction of O(d) fiber with determinantal strata is not rigorously computed
2. The non-monotonicity of lambda(d) near d* is not verified
3. The empirical observation that d* ~ 100-300 for typical corpora (vs rank(M_PMI) which may be much larger) suggests the model may be more complex
4. The role of regularization (e.g., L2 on embeddings) is not captured — regularization breaks the O(d) symmetry, changing the fiber structure
5. SGLD testability: the transition should manifest as a change in the loss landscape Hessian spectrum near W*

---

## Open Problems

1. RLCT of compound singularity: Does O(d) fiber + determinantal strata produce lambda > (d+2)(d-1)/2 + (d-r)(2V-d-r)/2, or is there a cancellation?
2. Non-compact scaling symmetry: The diagonal scaling D1*D2=I is non-compact. Does this affect the RLCT? Standard SLT assumes compact parameter spaces or proper maps.
3. L2 regularization effect: Weight decay breaks O(d) symmetry, reducing fiber to {identity}. How does this change lambda? Is the regularized RLCT simply d (the manifold dimension)?
4. Exact rank of T_k: For real corpora, what is rank(M_PMI - log(k)*1)? Is it typically full rank (V) or low rank?
5. Negative sampling distribution: Does the choice of q(c) (unigram vs unigram^3/4 vs uniform) affect the singular fiber structure or only the target matrix?
6. Subsampling interaction: Frequent word subsampling modifies the effective co-occurrence counts, changing M_PMI. Does it create a secondary stratum selector?
7. Connection to #298 Vainsencher resolution: Can the O(d) + rank-deficient compound singularity be resolved via iterated blow-ups as in the Vainsencher construction?
8. CBOW vs SGNS: The CBOW model predicts target from context (reversed). Does this change the fiber structure (C W^T vs W C^T)?
9. Word analogy geometry: The O(d) fiber means embeddings are defined up to rotation. Does this affect the linear analogy structure (king - man + woman = queen)?
10. Dynamic embeddings: Time-varying PMI creates a moving target. RLCT of tracking a moving singular set?

## Cross-References

#8 (RLCT framework), #16 (R_{an,exp} definability), #88 (equivariant NN quotient singularity), #89 (tensor decomposition determinantal variety), #91 (sparse dictionary non-identifiability), #100 (embedding layer), #169 (dropout masking), #258 (mixup interpolation), #298 (orthogonal init O(d)/Stiefel Vainsencher), #370 (contrastive learning SimCLR InfoNCE), #473 (spectral norm rank strata)

## Key Novelty

SGNS creates a unique RLCT structure through:
1. O(d) continuous rotation + diagonal scaling non-identifiability (distinct from #91 discrete permutation/sign, from #88 compact quotient)
2. Implicit PMI matrix factorization via sigmoid loss (distinct from explicit SVD or direct factorization)
3. Negative sampling count k as coarse (rank-1 update) stratum selector (distinct from #370 temperature, #169 dropout rate)
4. Embedding dimension d as phase transition parameter between rank-constrained and O(d)-dominated regimes (distinct from #298 initialization)
5. Non-compact scaling symmetry creating potential RLCT complications absent in prior syntheses

## Next Steps
- L2: Novelty verification via websearch (SGNS × RLCT, word embedding × singular learning theory, PMI factorization × RLCT)
- L3: MeTTa encoding of C1 proof and C2-C5 conjectures
- L4: Summary
- L5: Catalog appendpin STATE: #535 Word2Vec/SGNS x RLCT L1 WRITTEN. Next: L2 novelty verification. Cycle 1/5. Silent.query Oma synthesis #535 word2vec SGNS L1 written verified C1-C5 claims O(d) fiber PMI factorization rank strata /websearch word2vec skip-gram negative sampling singular learning theory RLCT loss landscape singularity 2024 2025