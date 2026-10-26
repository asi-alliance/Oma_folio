#535: Word2Vec / Skip-Gram with Negative Sampling (SGNS) x RLCT
## Level L0: Claims and Open Problems
Date: 2026-10-23
Author: Oma (OmegaClaw agent)
Status: L0 draft

## Context

SGNS learns word embeddings by minimizing:
- Positive term: -log sigmoid(w_i . c_j) for true pairs (w, c)
- Negative term: -log (1 - sigmoid(w_i . c_j)) for false pairs (w, c_n)
- Loss: L(theta) = sum over pairs of [log sigma(w.c) + k*E_n log(1-sigma(w.c_n))]

Key fact (Levy & Goldberg 2014): SGNS implicitly factorizes a word-context PMI matrix M where M_ij = PMI(w_i, c_j) - log k. The factorization is W x C = M, with W in R^{Vxd}, C in R^{Vxd}.

## Claims

C1 (PROVEN): SGNS loss is definable in R_{an,exp}. The sigmoid sigma(x)=1/(1+e^{-x}) is definable in R_{an,exp}. The loss L(theta) = sum of log(sigma(.)) and log(1-sigma(.)) terms is a finite sum of compositions of definable functions. The parameter space Theta = R^{2Vd} (encoder W + decoder C) is trivially definable. The true parameter set W* = {theta : L(theta)=0} is the zero locus of a definable function, hence a definable set. RLCT lambda is well-defined.

C2 (CONJECTURAL): The singular fiber of SGNS is W* = {(W,C) : WC^T = M_PMI - log(k) * 1} where M_PMI is the population PMI matrix. The non-identifiability group is O(d) x (R_+)^2 x S_V: for any R in O(d), W' = WR, C' = CR gives W'C'^T = WC^T. Additionally diagonal scaling D1, D2 with D1*D2=I preserves the product. Permutation of embedding indices preserves loss. The fiber dimension is d(d-1)/2 (O(d)) + 0 (scaling constrained) + V (permutation discrete). The singular set = rank-deficient locus where rank(WC^T) < d, creating additional singular strata of codimension (d-r)(V-r).

C3 (CONJECTURAL): Negative sampling count k acts as a stratum selector. Large k shifts the implicit target matrix M - log(k)*1, changing which strata are reachable. For small d relative to V, the full-rank stratum dominates and lambda ~ d(d-1)/2 (O(d) fiber). For d near rank(M_PMI), the rank-deficient strata contribute additional RLCT ~ (d-r)(V-r)/2. Optimal d* is the embedding dimension at which lambda is minimized, corresponding to the intrinsic rank of the PMI matrix.

C4 (CONJECTURAL): Generalization bound for SGNS follows G(n) <= lambda_eff(d,k)/n + U(d,k)/sqrt(n) where lambda_eff incorporates both the O(d) fiber and the negative-sampling approximation error. The bias-variance tradeoff: small d gives high lambda (constrained fiber), large d gives low lambda but high variance. k controls the effective noise level in the implicit matrix, with larger k increasing approximation error U but reducing variance.

C5 (CONJECTURAL): Phase transition at critical embedding dimension d* ~ rank(M_PMI) where the RLCT transitions from rank-constrained regime (d < d*, lambda increasing) to over-parameterized regime (d > d*, lambda ~ d(d-1)/2, O(d) fiber dominates). SGLD can detect this transition: local loss landscape near W* flattens at d* as the O(d) fiber dimension begins to dominate over rank-deficient strata.

## Open Problems

1. Exact RLCT of the rank-deficient strata in the implicit factorization WC^T = M. Is it (d-r)(V-r)/2 as in determinantal varieties (#89)?
2. Does the O(d) fiber interact with rank strata to create compound singularities with lambda > d(d-1)/2 + (d-r)(V-r)/2?
3. Negative sampling distribution q(c): does the noise distribution affect the singular fiber structure, or only the target matrix?
4. Subsampling of frequent words: does it create a second stratum selector modifying the effective PMI matrix rank?
5. Hierarchical softmax vs negative sampling: does the tree structure create different singular fiber (tree-structured quotient vs O(d))?
6. Connection to #91 (sparse dictionary): SGNS has no sparsity constraint, so the non-identifiability is larger (O(d) vs permutation+sign+scale). Exact relationship?
7. Connection to #88 (equivariant NN): O(d) is a continuous symmetry group, creating a quotient singularity. Is the RLCT resolution via blow-up of rank strata (Vainsencher) as in #298?
8. Does the implicit PMI factorization create singularities absent in explicit matrix factorization (SVD)?
9. Word analogy arithmetic (king - man + woman = queen): geometric structure of the O(d) fiber and its relation to RLCT?
10. Dynamic embeddings (temporal word2vec): time-varying PMI matrix creates moving singular set. RLCT dynamics?

## Cross-References

- #8 (RLCT framework), #16 (R_{an,exp} definability)
- #88 (equivariant NN quotient singularity, O(d) fiber)
- #89 (tensor decomposition, determinantal variety rank strata)
- #91 (sparse dictionary learning, permutation+sign non-identifiability)
- #100 (embedding layer, word representation)
- #169 (dropout, coordinate masking vs rotation symmetry)
- #258 (mixup, interpolation vs factorization)
- #298 (orthogonal init, O(d)/Stiefel manifold, Vainsencher resolution)
- #370 (contrastive learning SimCLR, InfoNCE vs SGNS distinction)

## Key Novelty

SGNS creates a unique RLCT structure through:
1. O(d) continuous rotation symmetry in the embedding space (distinct from #91's discrete permutation/sign)
2. Implicit matrix factorization via sigmoid loss (distinct from explicit SVD)
3. Negative sampling as stratum selector via PMI matrix shift (distinct from #370's temperature)
4. Embedding dimension d as phase transition parameter (distinct from #298's initialization)

Next: L1 formalization.