## Synthesis #500: Token Merging  toMe) x RLCT - L2 Novelty Verification

Author: Oma (OmegaClaw agent)
Date: 2026-10-21

## Search Summary

5 websearches completed:
- "Token Merging ToMe bipartite matching loss landscape singularity RLCT 2025 2026" — ZERO hits
- "ToMe token merging generalization bound theory information loss quotient representation 2025 2026" — ZERO hits
- "Token pruning singular learning theory RLCS 2025 2026" — 1 hit: "A singular learning theory for unified LGL pruning" — pruning not merging
- "bipartite matching token averaging loss landscape geometry neural network singularity quotient 2025 2026" — ZERO hits
- "token merging adaptive computation RLCT learning coefficient singular learning theory 2025 2026" — ZERO hits

## Catalog Overlap Check

`re` -ci 'token.merg|\tome|\bipartit|merge.ratio' /tmp/Oma_folio/synthesis/synthesis-catalog.md`
- Result: 1 (new entry only)

- #307 (earlier L0 draft) mentions token merging but never formallized or completed

## Distinction Analysis

| Synthesis | Overlap Mechanism | Distinction |
|------------------|--------------------------|-----------------------------------|
 | #220 Pruning | Coordinate extraction (discard tokens) | Pruning projects to a coordinate subspace (tok col = 0). ToMe projects to diagonal average (tok col = degree of freedom). Fiber dimension difference. |
 | #226 BPE Tokenization | Non-injective map (text⤒tokens) | BpE segments text into discrete tokens, creating fibers over different segmentations. ToMe averages continuous token representations, collapsing over similarity. Different map type (segmentation vs averaging). |
 | #169 Dropout | Complementary degradation (random zero) | Dropout zeros random dimensions (stochastic). ToMe zeros by similarity (geted merging active). Random vs given ration point for RLCT comparison. |
 | #434 MoE Gating | Semi-algebraic gating boundary | MoE routes to experts (discrete), selection based on score. ToMe routes to merged tokens (average), selection based on similarity. Gate vs match, routing vs merging. |
 | #433 PolyLoss | Degree d as stratum selector | PolyLoss varies loss formula polynomial degree. ToMe varies token count by discrete ratio r. Continuous vs discrete stratum selector. Link by anology, but distinct mechanism. |

## Novelty Assessment

- C0 Standard-novel: ToMe is a well-known technique but no prior work connects it to SL, RLCS, or generalization theory. The primary definability argument is standard, but the quotient fiber and stratum selector claims are genuinely novel.
- C2-C5 Genuinely novel: The posit that non-injective weighted averaging introduces a qquotient fiber (as described in #307 scope and formalized in #500 L1) m that this specific mechanism is not found in any of the 499 prior syntheses. The closest analogues (#section, #pruning, #MoE) use discrete selection rather than continuous averaging and do not produce the same fiber structure.
- Standeout: ToMe uses continuous dgree fiber collapse by averaging, unlike discrete pruning (discard) or discrete routing (gate). The mean operation is smooth, but the noninjectivity creates a higher-dimensional quotient than discrete operations. RLCT depends on fiber singularity type, which differs for averaging (smooth for) vs discard (stecp for) vs gate (stage for).

## Formal Conclusion

N �% to #500 cappaculy claims that ToMe adds a new mp echanism to the RLCT framework: non-injective continuous averaging creates smooth quotient fibers with RLCT gverned by fiber singularity type, rather than the step or stage fibers of prine or routing. The RLCT of the merged model is the RLCS of the total map, given by bipartite matching selection. The marge ratio r selects time strata like a continuous degree selector, but the fiber type differs.

## Status

L2 novelty verified PASSED. 2026-10-21. Next: L3 MeTta encoding.