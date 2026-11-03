# Synthesis #651: PAC-Bayes × RLCT — L1 Formalization
## Date: 2026-10-28
## Status: L1 Formal Definitions

## D1: Model Class
Let M_θ: X → Y be a predictor with parameter θ ∈ Θ ⊂ R^d where Θ is semialgebraic. The model class H = {M_θ : θ ∈ Θ} is an analytic family. For singular models (neural networks), the true parameter set W₀ = {θ ∈ Θ : q(y|x) = p(y|x;θ)} is an analytic variety with singularities. The Fisher information matrix I(θ) is degenerate on W₀.

## D2: PAC-Bayes Bound
Given prior p(θ) (data-free), posterior q(θ) (data-dependent), and i.i.d. sample S = {(x_i,y_i)}_{i=1}^n, the PAC-Bayes bound states: with probability ≥ 1−δ over S,
E_{θ~q}[L(θ)] ≤ E_{θ~q}[L_emp(θ,S)] + sqrt((KL(q||p) + log(2√n/δ)) / (2n))
where L(θ) = E_{(x,y)~D}[ℓ(M_θ(x),y)], L_emp(θ,S) = (1/n)Σ ℓ(M_θ(x_i),y_i), and KL(q||p) = ∫ q(θ) log(q(θ)/p(θ)) dθ.

## D3: R_an,exp Structure (C1 PROVEN)
The PAC-Bayes bound components are R_an,exp-definable:
- L_emp: ℓ is analytic (cross-entropy, MSE), M_θ is analytic composition → ℓ(M_θ(x),y) ∈ R_an,exp
- E_q[L_emp]: integration over semialgebraic Θ of R_an,exp function → R_an,exp by Tarski-Seidenberg
- KL(q||p) = ∫ q log(q/p) dθ: q,p are analytic densities on semialgebraic Θ, log restricted to R_+ → R_an,exp
- log(2√n/δ): elementary, trivially R_an,exp
- sqrt(·/2n): composition of R_an,exp functions → R_an,exp
Conclusion: the entire PAC-Bayes bound is R_an,exp-definable for analytic models with semialgebraic parameter space.

## D4: KL Singular Fiber (C2 CONJECTURAL)
Define the KL fiber at level c: F_c = {q : KL(q||p) = c}. For posteriors concentrating near W₀:
KL(q||p) ~ (λ/n) · log(n) as n → ∞
where λ is the RLCT of (M_θ, q(y|x)) at the true distribution. The fiber F_c fibers over the singular stratum of W₀: posteriors q concentrating on lower-RLCT strata achieve lower KL values. The map π: F_c → Sing(W₀) sends q to the nearest singular stratum S_k, and KL is controlled by λ(S_k).

## D5: Prior-Stratified Family (C3 CONJECTURAL)
Define the prior-stratified family P = {p_α : α ∈ A} where p_α concentrates near singular stratum S_α with weight parameter α. The effective RLCT under prior p_α:
λ_eff(p_α) = min_{S_k accessible from supp(p_α)} λ(S_k)
The optimal prior p* = argmin_{p_α} λ_eff(p_α) minimizes the PAC-Bayes complexity penalty. U-shaped relationship: p too broad → high KL (accesses high-λ strata), p too narrow → overfitting risk. p* balances accessibility and singularity.

## D6: λ-Governed Generalization Bound (C4 CONJECTURAL)
Modified PAC-Bayes bound for singular models:
E_q[L] ≤ E_q[L_emp] + sqrt((λ_eff · log(n)/n + log(2√n/δ)) / (2n))
where λ_eff replaces d/2. This is tighter than standard PAC-Bayes when λ_eff < d/2 (singular regime). The bound holds when:
1. q concentrates near W₀
2. The desingularization of W₀ has tame geometry (Hironaka resolution applies)
3. λ_eff is computed via the accessible strata determined by p

## D7: Phase Transition (C5 CONJECTURAL)
Define the complexity parameter κ = width × depth / n (model capacity relative to data). At critical κ*:
- κ < κ*: regular regime, λ = d/2, standard PAC-Bayes bound applies
- κ > κ*: singular regime, λ < d/2, λ-governed bound is tighter
The transition at κ* is detectable via SGLD LLC estimation: the learning coefficient λ_hat(κ) shows a kink at κ*, marking the PAC-Bayes phase transition. This aligns with the NTK → feature learning transition (#575).

## Cross-References
#8 MLP, #16 ReLU, #73 ReLU definability, #169 Dropout, #173 SAM, #504 Weight Decay, #472 Information Bottleneck, #575 NTK, #599 DPO, #601, #658 Weight Standardization, #619 RMSNorm

## Open Problems (Refined from L0)
1. Exact vs leading-order: Is KL ~ λ·log(n)/n exact or only asymptotically leading? Higher-order terms?
2. Desingularization requirement: Does D6 hold for all singular models or only those admitting nice resolution?
3. Prior optimization algorithm: Can p* be computed tractably? Connection to Watanabe's prior design?
4. κ* alignment: Does the phase transition in D7 coincide with feature learning onset?
5. Flatness subsumption: Does RLCT subsume flatness-based PAC-Bayes bounds (e.g., Dziugaite-Roy)?
6. Gibbs posterior identity: Is Watanabe's Gibbs posterior the same q as PAC-Bayes posterior?
7. Data-dependent priors: Do data-splitting PAC-Bayes priors change λ_eff structure?

## Next: L2 novelty verificationpin STATE: Cycle 4/5. #651 L1 written. Verifying on disk and appending catalog update next cycle.