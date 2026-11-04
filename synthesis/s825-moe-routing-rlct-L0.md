# Synthesis #825: Mixture of Experts Routing × RLCT - L0 Scoping
# Date: 2026-11-03
# Status: L0 DRAFT
# C1 PROVEN (conjectured), C2-C5 CONJECTURAL

## Architecture: Mixture of Experts (MoE)

MoE layers replace a single dense FFN with K expert networks {E_1, ..., E_K}. A gating network G(x) computes routing weights per token, selecting top-k experts. Output: y = sum_{i in top-k} G(x)_i * E_i(x). Key variants: dense MoE (all experts), sparse MoE (top-k, k << K), expert choice routing (tokens-to-experts), soft merging.

## Claims

**C1 PROVEN**: MoE loss is R_{an,exp}-definable. Gating G(x) = softmax(W_g * x) (exp in R_{an,exp}). Expert outputs E_i(x) = FFN with ReLU/SiLU (subanalytic). Weighted sum is polynomial composition. Top-k selection is piecewise (max/piecewise-linear), subanalytic. L_n = CE(softmax(y), label) uses exp. All components definable, closed under composition.

**C2 CONJECTURAL**: Gating logits G(x) create a data-dependent stratum selector. The softmax temperature in the gate controls the sharpness of expert selection — high temperature = uniform routing (all experts active, high-dimensional fiber, maximal RLCT), low temperature = hard routing (one expert active, low-dimensional fiber, lower RLCT). Temperature tau acts as continuous stratum selector analogous to #839 (Gumbel-Softmax) but in a routing context.

**C3 CONJECTURAL**: Expert collapse (all tokens routed to few experts) corresponds to a degenerate singular fiber where unused experts have zero gradient. This creates a non-transverse singularity: the loss is locally insensitive to unused expert parameters, forming a high-codimension singular locus. The RLCT of the collapsed state is higher than balanced routing because collapsed experts contribute redundant capacity without reducing loss.

**C4 CONJECTURAL**: Generalization bound G_MoE ~ lambda_eff / n + U(routing) / sqrt(n) where lambda_eff depends on routing entropy. High-entropy routing (balanced expert usage) gives lower lambda_eff by distributing the singular structure across K experts. Low-entropy routing (collapse) gives higher lambda_eff by concentrating singularity. Aux losses (load balancing) act as desingularizers — they push the system away from the collapsed fiber.

**C5 CONJECTURAL**: Phase transition at critical routing temperature tau* where the model transitions from dense (all experts, high RLCT) to sparse (k experts, lower RLCT). SGLD LLC shows step decrease at tau*. This is distinct from #839 (Gumbel-Softmax discrete selection) because MoE routing is over continuous expert functions, not discrete categories.

## Open Problems

1. Expert collapse as non-transverse singularity: does the collapsed fiber require desingularization via load-balancing aux loss, and does this reduce RLCT?
2. Top-k selection discontinuity: the argmax/top-k operation is piecewise but non-smooth at routing ties. Does this create additional singular strata at decision boundaries?
3. Expert capacity factor: does the capacity constraint (max tokens per expert) create a hard singular boundary or a soft one?
4. Expert choice routing (tokens select experts vs experts select tokens): does the reversed direction change the singular structure?
5. Soft vs hard routing: does straight-through estimator for top-1 routing create a different singular fiber than soft top-k?
6. Deep MoE (MoE in every layer): does stacking create product fibers across layers (analogous to multi-head Mamba #824 open problem 4)?
7. Scaling K (number of experts): does lambda_eff scale as O(log K) / K, O(1/K), or saturate? Connection to ensemble generalization bounds.

## Cross-References (preliminary)
#839 (Gumbel-Softmax temperature selector), #824 (Mamba input-dependent gating), #169 (dropout as stratum selector), #364 (early exit depth-conditioned selection), #362 (CFG scalar selection), #411 (layer scale), #213 (optimizer modulation), #582 (curriculum data distribution), #134 (attention routing analogy), #507 (noisy student desingularization)

File: /tmp/Oma_folio/synthesis/s825-moe-routing-rlct-L0.md
Next: L1 formalization.