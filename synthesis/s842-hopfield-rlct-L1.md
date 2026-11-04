# Synthesis #842: Hopfield Networks × RLCT — L1 Formalization

## D1: Parameter Space
Let ξ = (ξ_1,...,ξ_p) ∈ {±1}^{p×n} be stored patterns, n units, load α = p/n. Network state s ∈ {±1}^n (relaxed to s ∈ [-1,1]^n via mean-field). Hebbian weight map W(ξ) = (1/n) Σ_i ξ_i ξ_i^T (polynomial in ξ). Parameters of the learning problem: (ξ, s) with W a derived analytic map.

## D2: Hopfield Energy Loss
E(s; ξ) = -(1/2) s^T W(ξ) s = -(1/2n) Σ_i (s^T ξ_i)^2.
KL-type proxy: L(ξ, s) = E(s; ξ) - min_s E(s; ξ) ≥ 0, or with thermal relaxation, L(ξ) = -log Z(β,ξ)/β + ⟨E⟩_β. Pattern retrieval loss: L_ret(ξ) = (1/p) Σ_i ℓ(ξ_i, argmin over basin) — analytic in the relaxed mean-field variables.

## D3: R_{an,exp} Definability (C1 PROVEN)
E(s;ξ) is polynomial in (s, ξ) — sums of squares of bilinear forms. Hard neurons s = sign(h) are subanalytic; graph of sign is globally subanalytic, so the hard-energy critical-point condition ∇_s E = 0 ∧ s ∈ {-1,+1}^n is a subanalytic set (finite, hence trivially R_{an,exp}). Thermal free-energy involves log Z with Z a finite sum of exp(-βE(s)) over 2^n states — at fixed n, finite sum, definable; relaxed mean-field eliminates the sum. Composition closure → L ∈ R_{an,exp}. QED.

## D4: Singular Fiber — Spurious Minima as Singular Critical Points
V_0 = {ξ : ∃s* ∉ {ξ_i} ∪ spin-glass states with ∇E(s*;ξ) = 0 and Hess E(s*;ξ) degenerate}.
Key: at stored patterns the Hessian H = W - diag(...) has spectrum determined by ξ geometry; mixture states s* = sign(Σ ξ_i)/2 generate zero modes when partial sums cancel (eigenvalue crossings λ_k(ξ) = 0). V_0 is the locus where the energy map's critical structure loses Morse property — exactly Watanabe's singular fiber. Mixture states: generically MORE degenerate (codim smaller, larger λ_loc) than pattern minima.

## D5: Load α as Stratum Selector
Strata S_k = {ξ : # zero-eigenvalue modes at the global critical set = k}. As α = p/n grows, spin-glass mixture states proliferate (AGS theory): the dominant stratum migrates from S_0 (Morse, α < α_c) through S_1, S_2 to a dense singular stratum. α acts as continuous stratum selector, monotone in the expected local RLCT λ̄(α).

## D6: Retrieval Error Bound
G(α, n) ~ λ(α)/log n + U(α)/√n
- λ(α): effective RLCT of the energy fiber at load α — flat (λ ≈ 0-ish local values, Morse regime) for α < α_c, jumps at α_c as spurious-stratum singularities dominate retrieval basins.
- U(α): basin-geometry term — attraction radius shrinkage / SNR degradation from classical AGS analysis.
- Prediction: retrieval failure at α_c is an AIC-like singularity phase transition, not graceful parameter-count degradation.

## D7: Phase Transition at α_c
- α << α_c: Morse regime, patterns = isolated non-degenerate minima, λ ≡ Morse value.
- α ↑ α_c: mixture states become stable (AGS), degenerate critical points proliferate → λ(α) discontinuity/kink.
- α >> α_c: spin-glass dominated, retrieval impossible, global stratum singular.
- Modern Hopfield (Ramsauer): softmax attention energy E = -log Σ exp(β ξ_i^T s) + s^2/2 — log-sum-exp is analytic, strictly convex in retrieval region → desingularized. Bridge to #354 (softmax resolves STE saturation) and #841 (NTK critical-point spectrum).
- SGLD signature: LLC staircase as α crosses α_c (new singular modes activate per mixture state), testable in small simulations.

## Claims Status
- C1 PROVEN: R_{an,exp} definability (polynomial energy + subanalytic hard neuron + finite thermal sum)
- C2 CONJECTURAL: mixture/spin-glass states lie on deeper singular strata than pattern minima
- C3 CONJECTURAL: α as monotone stratum selector, α_c ~ 0.138n is λ(α) phase change
- C4 CONJECTURAL: retrieval bound λ(α)/log n + U(α)/√n, failure as singularity transition
- C5 CONJECTURAL: modern Hopfield log-sum-exp energy = desingularization, strictly lower λ

## Open Problems
1. Compute local RLCT at mixture states (blow-up / resolution needed at eigenvalue-crossing locus).
2. Prove λ(α) monotone via expected degeneracy growth (random ξ, replica/SK techniques).
3. Boltzmann temperature β as desingularization parameter — smooth λ(α,β) phase diagram.
4. Dense associative memory (Krotov–Hopfield, order β > 2): polynomial degree raises singularity hierarchy — RLCT ladder conjecture.
5. Equivalence of modern-Hopfield desingularization (C5) with attention softmax smoothing (#354/#336).
6. SGLD simulation protocol: n = 50–100 units, α sweep, LLC staircase detection at α_c.
7. Connection to energy-based-model synthesis #167: does #167's C3 (free-energy singularity) subsume or contradict C2 here?

## Cross-refs
#8, #16, #167, #185, #229, #336, #354, #394, #480, #566, #841
