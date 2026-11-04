# Synthesis #847: Bipolar AFs x Graded-Stalk Sheaf - L1 Formalization
Date: 2026-11-04. Builds on #845 (Dung set-valued sheaf), #846 benchmark, Potyka 2019 modular semantics.

## Formal definitions
- D1 (BAF): B = (A, R_att, R_sup, b) where b: A -> [0,1] is the base score; graph G_B = (A, R_att ∪ R_sup) with edge labels in {att, sup}.
- D2 (Graded sheaf): cellular sheaf F_B over G_B. Vertex stalk F(v) = [0,1]. Edge stalk F(e) = [0,1]^2 with restriction projections r_v,e : F(e) -> F(v), r_w,e : F(e) -> F(w).
- D3 (Support edge constraint): for e = (u,v) labeled sup, allowed pairs satisfy s(v) >= I_sup(s(u)) where I_sup: [0,1]->[0,1] is monotone (modular influence).
- D4 (Attack edge constraint): for e = (u,v) labeled att, allowed pairs satisfy s(v) <= 1 - I_att(s(u)) (anti-monotone influence; Euler-based damped variants use I_att(x) = x or (1-x) dampings).
- D5 (Aggregation map): vertex gluing constraint s(v) = Agg(b(v), {I(s(u)) : u -> v sup}, {1 - I(s(u)) : u -> v att}) with Agg modular (weighted sum/product, Euler-based clamped linear, or top-k max).
- D6 (Gradual complete semantics): the gradual semantics labelling s*: A -> [0,1] is the (unique, under convergence conditions) fixed point of the D5 update map; define H^0(F_B) := {sections s satisfying all D3-D5 constraints}. C1: s* ∈ H^0(F_B) and under the uniqueness condition s* is the unique section.
- D7 (Graded stable): section s ∈ H^0(F_B) with s(v) ∈ {0,1} for all v and undec-band [τ, 1-τ] empty; τ is a threshold/stratum selector.

## C1 proof structure (PROVABLE)
The modular update equation s(v) = Agg(b(v), sup-contribs, att-contribs) IS the sheaf gluing condition: vertex constraint = aggregation of edge restrictions. Edge maps are compositions of I_sup, I_att, Agg — all definable (polynomial/analytic except top-k; piecewise-analytic for top). Fixed point of update = global section of F_B. Hence every modular QBAF gradual semantics is an H^0 computation. QED sketch.

## C2-C5 (CONJECTURAL, with gaps)
- C2: lfp = minimal section — needs Tarski on section lattice; gap: section space order and update monotonicity for max-aggregation.
- C3: attack/support duality as stalk order-reversal — needs isomorphism formalization.
- C4: τ phase transition for graded stable — echo #843/#845; needs stratum analysis.
- C5: multi-agent consensus H^1 — deferred to distributed-intel OP.

## Open problems
Same 7 as L0 (benchmark extension to QBAFs is priority: brute fixed point vs H^0).

## Cross-refs
#8 #16 #158 #354 #480 #566 #601 #843 #844 #845 #846. Potyka 2019 (AAMAS), Mossakowski-Neuhaus 2018.
