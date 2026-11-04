# Synthesis #651: PAC-Bayes × RLCT — L0 Exploration

## Date: 2026-10-28
## Status: L0 Exploration (Reconstructed from L1-L4)

## Setting
PAC-Bayes generalization bounds give E_q[L] ≤ E_q[L_emp] + sqrt((KL(q||p) + log(2√n/δ)) / (2n))
characterizing the complexity penalty as KL quantity. For regular models KL ~ d/2, but for
singular models (neural networks) the RLCT bridge suggests KL is governed by RLCT λ, not d.

## Claims

C1 PROVEN: R_an,exp-definability of PAC-Bayes bound components.
L_emp is analytic integration of R_an,exp function. KL is integral of analytic densities
over semialgebraic Θ. All components trivially R_an,exp-definable by Tarski-Seidenberg.

C2 CONJECTURAL: KL Singular Fiber. KL(q||p) ~ λ·log(n)/n as n → ∞ for posteriors
concentrating near the true parameter set W₀. The KL fiber F_c = {q : KL(q||p) = c} fibers
over the singular stratum of W₀. Posteriors on lower-RLCT strata achieve lower KL.

C3 CONJECTURAL: Prior as Stratum Selector. Prior p determines which singular strata
the parameter space can reach. Optimal prior p* minimizes λ_eff = min accessible λ(S_k).
U-shaped: p too broad → high KL (accesses high-λ strata), p too narrow → overfitting risk.

C4 CONJECTURAL: λ-Governed Generalization Bound. Modified PAC-Bayes bound:
E_q[L] ≤ E_q[L_emp] + sqrt((λ_eff·log(n)/n + log(2√n/δ)) / (2n)). Replaces d/2 with λ_eff.
Significant: directly replaces dimension d with RLCT λ_eff for singular models.

C5 CONJECTURAL: Phase Transition in Bound Tightness. λ_eff/n vs sample size ratio
creates critical κ* where bound tightness shifts. At κ*, singular regime becomes
tighter than regular regime. Aligns with NXK feature learning transition (#575).

## Open Problems (7)
1. Exact KL asymptotics: leading order only? Higher order terms?
2. Desingularization requirement: for all singular strata or only those with nice resolution?
3. Tractable computation of p*: connection to Wasserstein prior design?
4. Complexity parameter κ alignment with feature learning onset?
5. Subscription of flatness based PAC-Bayes bounds (Neyshabur comparison)?
6. Gibbs posterior identity with WATANABE Gibbs posterior?
7. Data-dependent priors: does data-splitting change λ_eff structure?

## Cross-References (12)
#8 MLP, #16 ReLU, #73 ReLU definability, #169 Dropout, #173 SAM, #433 Weight Decay,
#472 Information Bottleneck, #575 NXK, #599 DPO, #601, #658 Weight Standardization,
#619 RMSNorm, #805, #815

## Next: L1 formalization (already written)