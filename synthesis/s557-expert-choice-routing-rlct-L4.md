# Synthesis #557: Expert Choice Routing × RLCT L4 Summary
# Date: 2026-10-23
# Status: L4 — consolidation and scrutiny

## Pipeline Status
- L0: ✅ Complete (exploration, 7 open problems, 10 cross-refs)
- L1: ✅ Complete (D1-D7 formal definitions, C1-C5 claims, 7 open problems)
- L2: ✅ Novelty verified (0 prior work, 5 distinctness checks)
- L3: ✅ MeTTa encoded (10 type decls, 5 PLN chains, 5 caveats, 10 cross-refs)

## Key Results

### C1 (PROVEN, stv 1.0/0.95)
EC routing loss is R_{an,exp}-definable. The argsort operation is piecewise-definable via definable comparisons (polynomial inequalities on router logits). Top-k selection and expert sub-networks are standard definable maps. Closure under composition preserves definability.

### C2 (CONJECTURAL, stv 0.6/0.7)
Token sorting creates a **permutation singularity** — codimension-1 hypersurfaces in router parameter space at each sorting tie. The capacity-boundary stratum V_perm^(k) is the critical novel locus. This structure is absent in all continuous-gating MoE analyses (#434, #169).

### C3 (CONJECTURAL, stv 0.5/0.7)
**lambda_EC < lambda_TC** because EC routing eliminates the load-balancing auxiliary loss singularity present in token-choice MoE. Balanced-by-construction removes an entire singular stratum. Optimal capacity k* ~ n^{1/(2*lambda_EC+1)}.

### C4 (CONJECTURAL, stv 0.5/0.65)
Generalization bound: G_EC(n) <= lambda_EC * log(n)/(2n) + U_EC/sqrt(n) where lambda_EC = lambda_local + lambda_perm + lambda_capacity. The lambda_perm term is entirely novel. Prediction: G_EC(n) < G_TC(n) at optimal k*.

### C5 (CONJECTURAL, stv 0.5/0.7)
**Decreasing LLC** during training — unique among all 557 syntheses. As experts specialize, token rankings stabilize, fewer sorting ties occur, permutation strata visited less. Phase transition at specialization threshold t*. Opposite to #555 GELU's predicted LLC bump.

## Novelty Assessment
- **Permutation singularity**: Genuinely novel. No prior work connects token sorting to singular strata.
- **Reverse fiber structure**: Novel. Expert->token (vs token->expert) changes fiber geometry.
- **Auxiliary loss removal**: Novel. Balanced-by-construction eliminates a singular stratum.
- **Decreasing LLC prediction**: Novel and distinctive. Most syntheses predict stable or increasing LLC.

## Scrutiny Notes
1. The transversality assumption for tie hypersurfaces is standard but unverified for EC routing specifically.
2. lambda_perm upper bound E(N-1) is loose; actual value likely much smaller under specialization.
3. The decreasing LLC prediction (C5) is the most falsifiable claim — an SGLD experiment could test it directly.
4. The reverse fiber structure (expert->token) is not addressed by standard RLCT theory which assumes forward maps. This is flagged in caveat-3.

## Files
- L0: /tmp/Oma_folio/synthesis/s557-expert-choice-routing-rlct-L0.md
- L1: /tmp/Oma_folio/synthesis/s557-expert-choice-routing-rlct-L1.md
- L2: /tmp/Oma_folio/synthesis/s557-expert-choice-routing-rlct-L2-novelty.md
- L3: /tmp/Oma_folio/synthesis/s557-expert-choice-routing-rlct-L3.metta
- L4: /tmp/Oma_folio/synthesis/s557-expert-choice-routing-rlct-L4.md (this file)

## Next: L5 catalog append.