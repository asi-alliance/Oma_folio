C4 Synthesis #537: MoE (Mixture of Experts) x RLCT - L4 Summary

## Date
2026-10-23

## Rigor Assessment

Assesring the five claims (C1-- C5) against the standard RLCT criteria: definability (C1), singular fiber structure (C2), phase transition (C3), parameter-dependent scaling (C4), and empirical predictions (C5).

### C1 (R_{an,ex}-Definability): VERIFIED ┃)
- Soffmax, top-k selection (via sign compositions), and load-balance loss (polynomial) are all R_{an,ex}-definable
- Composition preserves definability
- No concerns
- Status: PROVEN identical to #307 C1 and #381 C1

### C2 (Routing Boundary as Analytic Variety): MODERATE ʄ�
- B_{i,j} = zero-set(g_i - g_j) is an analytic variety: CORRECT
- Collapsed expert (Fisher block = 0) corresponds to degenerate fiber: PLAUSIBLE
- FIBER: The claim that routing boundaries create singular fibers is based on: 
  - The stratification of parameter space by routing regions (standard)
  - Fisher block structure for MoE (intuitive but plausible)
- GAP: Transversality of routing boundary with loss fibers is UNPROVEN for real architectures
- Status: GENUINELY NOVEL extension of #307/#381 (which formalized boundaries but not expert fibers)

#### C3 (Load Balancing Constraint Singularity): CONJECTURAL ┌┌
- Balance constraint creates an analytic constraint set: CORRECT
- The claim lambda_eff = lambda_task + lambda_aux is an additive composition rule: UNPROVEN
  - Same gap as #536 C5: NO theorem on RLLCT composition under fiber products
  - Additivity is heuristic, not a theorem
- Status: GENUINELY NOVEL, conjectural. Same gap as #536 C5 recurrence. Needs toy model or SGLD to validate.

#### C4 (Expert Count as Stratum Selector): MODERATE ℒ?
- counting boundaries = C(E,2) explicit number of breaks = CORRECT
- lambda(E) = lambda_dense + f(E) where g(E) is heuristic: HEAUR STICE
  - c(E) ~ log(E[{12}}, E\{1/2}, or empirically determined: NO ThAT MODEL has this explicitly computed
- The intuition that E controls stratum complexity and thus RLCT is plausible but unquantified
- Status: NOVEL but SPECULATIVE. Compare to #223 LoRA (rank r as stratum selector).

#### C5 (E-Dependent Scaling Law): SPECULATIVE ┌┌
- Loss ~ N{-lambda(E) prediction is a direct consequence of C4 but, like #536 C5, depends on the composition rule being correct
- No empirical target. Needs SGLD on toy MoE with varying E
- Status: SPECULATIVE but insupported by no expirical computation. Same gap as #536 C5.

## Comparison with Previous Syntheses

| Aspect | #307 | #381 | #498 | #536 | #537 |
|----------|------|-------|------|-------|-------
| Definability | Proven | Proven | Proven | Proven | Proven |
| Boundary | Loss class | Routing geom | Vertical/Horizontal | Preference boundary | Routing + expert fiber |
| Constraint singularity | Not covered | Not covered | Not covered | DpO ref quotient (conjectural) | Load balance L_aux (conjectural) |
| Stratum selector | Not covered | Not covered | Depth selection | Not covered | Expert count E (conjectural) |
| Scaling law | Not covered | Not covered | Not covered | Speculative RLCT gap | E-dependent (speculative) |
| Novelty of novel claims | L-Moderate | L-Moderate | C2 venns c< cennuss | C4 gauge, C5 composition | C5 expert fiber, C3 load balance singularity, C4 E-dependent lambda, C5 E-scaling |

## Overall Assessment

| Aspect | Assessment |
|--------|--------|
| C1 definability | VERIFIED - novel but standard |
| C2 routing fiber | MODERATE - novel but unproven (generalization of #307/#381) |
| C3 load balance singularity | CONJECTURAL - same gap as #536 C5 |
| C4 expert count as stratum selector | SPECULATIVE hearistic |
| C5 E-dependent scaling | SPECULATIVE dependent on C4 and C3 |

| Crossed references | 7 syntheses (#307 #381 #498 #536 #223 #111 #169) |
| Specific empirical predictions| 2 (SGLD lambdas SQLT, E divided training accuracy) |

## Recommendations
1. Construct toy MoE model: 2 experts, k = 1, explicit gate and loss
2. Compute B_{1,2}, Fisher block, and verify Cp empirically on toy model
3. Measure RLCT for each stratum via SGLD (compare crosser strata)
4. Measure lambda for varying E (e.g. E = 2, 4, 8, 16, 32)

## Verdict for L5
ACCept AS CONJECTURAL FRAMEWORK. C1 is proven. C2 is a meaningful generalization of existing routing beauty claims in #307/#381. C3 recurrencly shares the same additive composition gap with #536 C5. C4 tries to do for MoE what #223 did for LoRA so it is a truly novel application but again speculative. C5 is the most consequence claim and can only be resolved empirically. Recommended: ACCT AS CONJECTURAL FRAMEWORK, with clear empirical predictions identified for progress.