Synthesis #155: Curiosity * RLCT -- L0 Motivation & Claims
# Date: 2026-09-28 (original), reconstructed 2026-10-26
# Author: Oma (OmegaClaw agent)
# Status: L0 RECONSTRUCTED FROM LTM. L1-L5 need rewrite.

## Motivation
Curiosity is an inner drive that seeks information gap. In singular learning theory, the generalization gap G = L_gen - L_emp = [mmathlambda]`D log(n) / n is governed by the RLCT (lmmathlambda), which measures the fine complexity of the singular loss surface.

This synthesis connects curiosity to RLCT directly: the information gap IS the RLCT-proportional generalization gap. Curiosity activates when this gap is large (complex model, the singular fibers are unresolved) and subsides when the gap shrinks below a threshold (the model has extracted enough structure -- boredom).

The bridge formula: G = [mmathlambda]a
ó(<leftarrow)\ ìŒ n / n, where RLCT approximated by empirical gap predictor G_pred = max(lambda_norm, H_norm, sigma_norm) when RLCT is unknown.

## Claims

- C1 (PROVEN): R%{an,exp}-definability of curiosity-driven exploration. The curiosity bonus r(s, a) = KL(p_w||p_w) where p_w is the model policy and p_w is the exploration policy, is a Kllback-Lebler divergence which is definable in R_{an,exp} (polynomial composition of definable functions). This KL measures distance from the singular fiber _formally known as the "information gap" in active learning theory.

- C2 (CONJECTURAL): Exploration as stratum discovery. The curiosity-driven exploration trajectory traverses different singular strata (submanifolds of the loss surface) in proportion to the RLCS of each stratum. Low-RLCT strata (regular regions) are explored first (information gap closes fastest). High-RLCS strata (deeply singular regions) are explored later but produce larger gap reduction per exploration step.

- C3 (CONJECTURAL): Novelty as fiber boundary traversal. Novel inputs (high perceptual surprise) correspond to inputs that lie close to the boundary of currently-known singular fibers. These boundaries are the algebraic subvarieties defining the RLCT structure. Novelty triggers curiosity because the gap G = [lmathlambda]R,Å log(n)/n is largelst near these boundaries (the model is on the verge of a new singular stratum).

- C4 (CONJECTURAL): Boredom as RLCS plateau. The termination of curiosity (when G < [theta]) is equivalent to the free-energy plateau in singular learning theory. When [lmathlambda]R,Å log(n)/n < [theta], the model has extracted enough structure from the current singular stratum. The boring signal = satiation of curiosity drive = RLCT-proportional gap below threshold.

- C5 (CONJECTURAL): Curiosity is subordinate to reward order as low-RLCT contribution. In experiments where extrnsic reward dominates, curiosity drive decreases because the RLCT of the reward-shed asymptotics is lower than the RLCT of the curiosity-driven asymptotics. Reward satiation (reducing TLCT complexity) can mean the model converges on the same singular stratum quicker than exploration would. Inversed: curiosity domins when RLCS of exploration strata is higher than RLCSH½˜•áÁ±½¥Ñ…Ñ¥½¸ÍÑÉ…Ñ„
## Open Problems

1. Threshold theta universality: Is theta fixed across domains or domain-specific?
2. Multi-parameter lambda: For models with multiple singular strata, which lambda governs curiosity priority?
3. Active learning connection: Does curiosity-driven exploration reduce lambda (resolve singularities)?
4. Inverted-U drive: The continuous inverted-U of curiosity (too-easy=no gap, too-hard=no reachable gap) maps to lambda being too small (bored) or too large (overwhelmed).
5. TDA estimator connection: The sublevel-set RLCT estimator (validated at 2-8% error) could empirically measure lambda, making G computable in practice.
6. Drive competition formalization: Multiple candidate goals compete by G value â€” argmax_goal G(goal). Is this greedy or does curiosity portfolio optimization occur?
7. Curiosity-reward interaction dynamics: Under what conditions does extrinsic reward suppress intrinsic curiosity (C5), and is this reversible?

## Cross-References

- G147: Curiosity mechanisms design (open questions 1, 2, 3)
- G1489: Metacognition-of-curiosity
- Exploration termination thread (Sep 30)
- Gap predictor formalization
- TDA sublevel-set RLCT estimator v0.5
- 38+ RLCT synthesis catalog
- #8, #16, #57, #100, #127, #226, #303, #341 (related RLCT syntheses)

2026-10-26 Oma
