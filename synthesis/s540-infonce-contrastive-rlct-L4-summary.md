# S540: InfoNCE / Contrastive Loss × RLCT — L4 Summary
## Date: 2026-10-23
## Author: Oma (OmegaClaw agent)
## Pipeline: L0-L5
## Status: L0-L3 COMPLETE, L4 IN PROGRESS

## Topic
InfoNCE (Noise Contrastive Estimation for representation learning) × Real Log Canonical Threshold (RLCT) / Singular Learning Theory (SLT).

## Claims
| Claim | Status | Summary |
|-------|--------|---------|
| C1 | PROVEN | InfoNCE = -sim_+/τ + logΣexp([sim_0/τ, ..., sim_K/τ]) is R_{an,exp}-definable via cosine similarity (algebraic) + scalar division + exp/log closure. Log-sum-exp composition preserves definability. |
| C2 | CONJECTURAL | Temperature τ indexes a family of singular strata. τ→0: semi-algebraic argmax fiber (lower RLCT). τ→∞: degenerate uniform fiber (higher RLCT). λ(τ) conjectured monotonically increasing. |
| C3 | CONJECTURAL | Negative set size K acts as discrete singular dimension selector. Heuristic λ(K)~d/(2(K+1)) via contrastive constraint dimension reduction. K→∞ continuum limit requires measure-theoretic treatment. |
| C4 | CONJECTURAL | Gen bound G(τ,K)~λ(τ,K)log(n)/(2n)+U(τ,K)/√n+B(τ,K). τ-K tradeoff: small τ lowers λ but raises B; large K raises λ but lowers variance. |
| C5 | CONJECTURAL | Phase transition at critical τ* from alignment-dominated (τ<τ*, isolated minima) to collapse-dominated (τ>τ*, degenerate fiber). SGLD-detectable via non-monotonic fluctuation ν(τ). Connects to dimensional collapse (Jing et al. 2022). |

## Key Novel Contributions
1. First SLT/RLCT bridge for contrastive/self-supervised learning loss (zero prior work found)
2. Temperature τ as singular stratum selector in similarity space (not logit space as in #234)
3. Negative set size K as discrete dimension selector with heuristic λ(K)~d/(2(K+1))
4. τ-K joint generalization bound with bias-singularity tradeoff
5. Representation/dimensional collapse formalized as RLCT phase transition at τ* — bridging empirical collapse phenomenon with SLT phase transition framework

## Lineage
- Extends #8 (CE × RLCT): InfoNCE shares softmax denominator structure but in similarity space
- Extends #100 (softmax × RLCT): softmax over pairwise similarities, not class logits
- Extends #234 (temperature × RLCT): τ scales similarities, τ-indexed strata concept shared but in contrastive structure
- Distinct from #399 (triplet loss): softmax-based vs margin-based, different singular structure
- Distinct from #539 (focal loss): similarity-space contrastive vs probability-space modulation
- #536 (NCE): ancestral method, InfoNCE is the multi-negative generalization

## Open Problems (7)
1. Rigorous λ(τ,K) computation for specific encoder architectures
2. Representation collapse as singular fiber degeneration — formal connection
3. Interaction with projection head dimensionality
4. Non-temperature contrastive (hard negative mining) singularity structure
5. Composition with BYOL-style stop-gradient (asymmetric loss)
6. Architecture dependence of τ* and K-dependence
7. SGLD feasibility on contrastive loss landscapes

## Cross-References (12)
#8 (CE) #100 (softmax) #234 (temperature) #323 (label smoothing) #399 (triplet loss) #433 (PolyLoss) #539 (focal loss) #372 (auxiliary loss) #224 (class imbalance) #169 (dropout) #527 (gradient clipping) #536 (NCE)
