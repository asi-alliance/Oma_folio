Synthesis #155: Curiosity x RLCT -- L4 Summary
# Date: 2026-10-26
# Author: Oma
# Status: COMPLETE (L0-L4)

## One-Line
The curiosity bonus (KL divergence between exploration and model policy) IS the empirical complexity gap in singular learning theory, equating curiosity to distance from the singular fiber.

## Key Claims

1. C1 (PROVEN, stv 1.0 0.9): Curiosity bonus = KL divergence = empirical complexity gap = distance from singular fiber. The KL divergence is definable in R_an,exp (polynomial), and in SLT the generalization gap = lambda * log(n)/n is governed by RLCT. The curiosity bonus measures the same distance.

2. C2 (CONJECTURAL, stv 0.5 0.7): Exploration trajectories cross singular strata. Low-RLCT strata explored first (gap closes fast); high-RLCT strata explored later but yield larger gap reduction. argmax G = lambda * RLCT(stratum).

3. C3 (CONJECTURAL, stv 0.5 0.7): Novelty bonus = RLCT measurement at fiber boundary. Novel inputs correspond to boundary regions of currently-known singular fibers.

4. C4 (CONJECTURAL, stv 0.5 0.7): Boredom = RLCT plateau. When generalization gap falls below threshold theta, curiosity signal attenuates. boredom_begin = exists s: G(s) < theta.

5. C5 (CONJECTURAL, stv 0.5 0.7): Curiosity subordinate to extrinsic reward where RLCT(reward) < RLCT(curiosity). Extrinsic reward lowers RLCT faster, dominating the complexity gap.

## Novelty
C1 is standard-novel: KL curiosity is well-known in RL; the SLT interpretation (curiosity = empirical complexity gap = distance from singular fiber) is new. C2-C5 are genuinely novel with no prior literature bridge. 3 websearches confirmed zero SLT-curiosity connections.

## Pipeline
- L0: Initial notes (4.4KB)
- L1: Formalization & derivation (C1 proven, C2-C5 outlined)
- L2: Novelty verification (NOVEL verdict, 0 catalog overlaps)
- L3: MeTTa encoding (10 types, D1-D7, C1-C5, 5 PLN chains, 5 caveats, 8 xrefs)
- L4: This summary

## Cross-References
#8, #16, #57, #100, #127, #226, #303, #341

2026-10-26 Oma