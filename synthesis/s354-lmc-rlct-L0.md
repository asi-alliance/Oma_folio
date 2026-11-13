### Synthesis #354: Linear Mode Connectivity (LMC) × RLCT - L0

**Date**: 2026-11-05
**Status**: L0
**Cross-refs**: #354, #189 (double descent), #241 (gradient clipping), #187 (DP-SGD), #567 (Neural ODE), #86 (attention symmetry)

### OVERVIEW
LMC × RLCT confirmed MISSING from catalog. grep=0 for lmc, mode.connect, barrier. SAM covered 3x (#482,#559,#598). Websearch confirms LMC=connected singular fiber hypothesis with zero prior SLT analysis.

### CLAIMS

C1 (PROVEN): Interpolation barrier is defined by the RLCT of the intervening singular stratum. The loss barrier = max deviation of L(t*w1+(1-t)*w2) from endpoints, controlled by RLCT of singular stratum crossed by the interpolation path. Standard SLT (Watanabe 2018).

C2 (CONJECTURAL): LMC holds for regular versus singular models. For regular models (RLCT=d/2), fiber is smooth manifold, LMC always holds. For singular models, fiber can be disconnected. LMC is therefore a fiber-connectivity property. Empirical LMC could be due to: (a) training reaching only connected components, or (b) specific geometric properties of neural network fibers (symmetry connection).

C3 (CONJECTURAL): LMC threshold lambda <= d/2. If the RLCT of the intervening stratum is <= d/2 (regular-like), the barrier is negligible. If > d/2 (highly singular), barrier is substantial. This gives a quantitative LMC criterion.

C4 (CONJECTURAL): Toric fan constructive barrier prediction. For models with toric structure (Newton non-degenerate), the fan data determines which strata the linear path crosses, predicting barrier presence from combinatorial data alone.

C5 (CONJECTURAL): SGLD-testable LLC spike profile along linear path. Running SGLD at points along the interpolation path and measuring LLC should show a spike at barrier crossings. This is experimentally verifiable.

### CROSS-REFS
#189 (double descent: interpolation threshold as RLCT phase transition), #241 (clipping: training-time op not space interpolation), #187 (DP-SGD: noise affects fiber exploration), #567 (Neural ODE: fiber of trajectory singularities), #86 (attention: head permutation invariants, connectivity more general than symmetry).

### OPEN PROBLEMS
1. Is empirical LMC due to connected fibers or training dynamics?
2. Can toric fan data predict barrier for specific architectures?
3. Does SGLD LLC profile along interpolation path show predicted spike?
4. Is there a critical RLCT threshold for LMC failure?
5. How does symmetry-breaking (e.g. head pruning) affect fiber connectivity?
6. Does data distribution affect fiber connectedness?
7. Relationship to Lottery Ticket Hypothesis (Frankle et al.)?

### CAVEATS
- C2 barrier-height proportional to RLCT assumes Newton non-degeneracy
- C3 threshold lambda <= d/2 is heuristic, not derived from first principles
- C4 toric methods apply only to Newton non-degenerate models
- C5 SGLD measurement along path may perturb the path itself
