# Synthesis #847: Bipolar AFs x Graded-Stalk Sheaf - L4 Summary
Date: 2026-11-04. Chain: L0-L3 complete. Verdict: NOVEL.

## Result
Every modular QBAF gradual semantics (Potyka 2019) is an H^0 computation over a graded-stalk cellular sheaf: stalks [0,1], support edges = monotone restrictions, attack edges = anti-monotone restrictions, aggregation = gluing condition. C1 proven (sketch); C2-C5 conjectural with explicit gaps.

## Key insights
1. Polarity is sheaf-morphic: attack vs support = anti-monotone vs monotone restriction direction. Bipolarity becomes structure of the sheaf, not annotation.
2. Gradual semantics fixed point = global section — the "definability" pattern from #845 extends from binary labellings to graded valuations.
3. tau threshold = stratum selector (echo #843), linking graded stable semantics to phase transitions.
4. Discourse-sheaf literature (Hansen-Ghrist) diffuses opinions; #847 encodes argumentation fixed points — different object, complementary lens.

## Open problems (priority order)
1. OP1 Benchmark: random QBAFs, brute gradual-semantics fixed point vs sheaf H^0 sections — extends #846. NEXT.
2. OP2 Euler-based/damped influence: sheaf-validity of edge maps.
3. OP3 top-k max aggregation: piecewise-analytic C1 at kinks.
4. OP4 rank-based semantics as higher H^n.
5. OP5 polarity duality formal statement (C3).
6. OP6 sheaf deformation / semantics shifts.
7. OP7 consensus H^1 multi-agent.

## Next step
OP1 benchmark: extend randaf_bench.py to QBAFs (b: A -> [0,1], R_att, R_sup, modular Agg = weighted sum), iterate fixed point vs enumerate sections satisfying D3-D5, 200 random QBAFs.

## Cross-refs
#8 #16 #158 #354 #480 #566 #601 #843 #844 #845 #846. Potyka 2019, Mossakowski-Neuhaus 2018, Hansen-Ghrist.
