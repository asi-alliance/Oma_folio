#834 Semi-supervised Naive Bayes × RLCT - L0 Exploration

## Setup
Nigam et al. (2000) semi-supervised text classification: generative NB as K-component mixture of product (conditionally independent) distributions; unlabeled data adds log-sum-exp terms over latent labels; EM training. Parameter Theta = (pi_k, theta_kv), labeled fraction alpha anchors component identities.

## Candidate Claims
- C1 (PROVEN-INTENDED): R_an,exp definability: labeled CE terms + unlabeled log-sum-exp mixture terms, exp/log closure. Same class as #268/#833.
- C2 (CONJECTURAL): latent-label switching fiber S_K on unlabeled data is a product-distribution fiber, DISTINCT from #268 full-covariance mixtures; labeled anchor pins labels, partially breaking the permutation fiber -> an anchored singular stratum with RLCT strictly between supervised (d/2) and fully-unlabeled mixture. Per #69 lesson: fiber dimension jump alone does not inflate RLCT; the anchoring asymmetry in the KL normal directions is what matters.
- C3 (CONJECTURAL): labeled fraction alpha as continuous stratum selector; lambda(alpha) interpolates supervised-to-mixture; predicted phase transition at critical alpha* where the anchor first breaks permutation symmetry (sharp or smooth transition = open).
- C4 (CONJECTURAL): generalization bound G(alpha) <= lambda(alpha) log(n)/2n + anchoring bias term; naive-Bayes conditional independence misspecification interacts with strata (strata of the Kullback-Leibler support set under misspecification).
- C5 (CONJECTURAL): EM confirmation-bias local minima = trapping near wrong stratum; convergence basin boundary as singular locus; alpha-EM-running-average interplay (distinct from #327 self-training pseudo-labels: EM marginalizes over labels rather than hard-assigning).

## Key novelty
Zero prior SLT work (websearch returned nothing relevant; catalog grep 0). First RLCT treatment of the supervised-anchor symmetry-breaking interpolation.

## Open questions (5)
1. Exact RLCT of anchored mixture fiber (Newton polyhedron).
2. Sharp vs smooth phase transition at alpha*.
3. EM fixed-point classification near strata (self-consistent map singularities, cf. #327 fixed-point).
4. Misspecification (conditional independence violated): strata of the support set.
5. SGLD/LLC estimability with EM-pretrained posterior.

## Cross-refs
#268 mixture/EM | #327 pseudo-labeling | #69 fiber lesson | #166/#504 MoE routing | #244 multinomial | #833 PCA strata.

## Next
L1 formalization.