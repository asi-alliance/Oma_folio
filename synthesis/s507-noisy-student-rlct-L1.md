# Synthesis #507: Noisy Student × RLCT — L1 Formalization (2026-10-22)

## Definitions
- Teacher θ_T, clean data (x_i, y_i). Teacher pseudo-labels ŷ_i = argmax_c p_T(c|x_i).
- Student loss: L_s(θ, ε) = (1/n) Σ_i ℓ(f_θ(a(x_i, ε_i)), ŷ_i), where a is a definable noise map (augmentation/dropout realized by explicit noise variables ε_i).
- Expected loss L̄_s(θ) = E_ε[L_s(θ, ε)] = (heat-type smoothing) e^{(σ²/2)Δ} L_teacher-labeled for isotropic additive noise.

## C1 (PROVEN, definability)
For fixed noise draws, (θ, ε) ↦ L_s(θ, ε) is a composition of definable maps (affine noise injection, ReLU/sigmoid network, CE with fixed targets), hence R_{an,exp}-definable. The finite-sample average over M noise draws is definable; Watanabe regularity holds for the empirical student process. Gap: the infinite-convolution limit L̄_s is not automatically definable — claims below are stated for M-draw empirical losses or under o-minimal heat-approximation assumptions (cf. #261 §C1).

## C2 (CONJECTURAL, noise as desingularizer)
Noise convolution acts as heat semigroup: λ_s(σ) ≤ λ_clean, non-increasing in σ on average. Narrow strata (width < σ) are smoothed out; σ* = sqrt(2·η·ΔE) (from #377 Itô correction) predicts the noise scale at which a stratum of depth ΔE and LR η stops trapping the student. Gaps: monotonicity unproven (λ of a smoothed loss need not be monotone in σ); σ* heuristic transplanted from SGD dynamics, not static.

## C3 (CONJECTURAL, confidence filter as stratum selector)
S_τ = {x_i : max_c p_T(c|x_i) ≥ τ} is a semi-algebraic subset of input space; training restricted to S_τ is a definable-subset restriction (cf. #327 C3, #424 acceptance region). Predicted effect: λ(S_τ) lower than λ(full), τ* phase transition where low-confidence (high-ambiguity) strata enter. Gap: input-space restriction vs parameter-space strata — needs pushforward argument.

## C4 (CONJECTURAL, capacity asymmetry)
Equal-or-larger student with noise: larger fiber dimension d, but measured λ_s ≤ λ_smaller-student under same noise. Generalization gap controlled by λ, not raw capacity. Gap: no theorem bounds λ of a wider net trained on smoothed loss; empirical claim only.

## C5 (CONJECTURAL, iterative RLCT decay)
Round map θ_T^{(r+1)} = argmin L_s(θ; θ_T^{(r)}). Predicted λ(θ^{(r)}) non-increasing in r with diminishing per-round gain, phase transition at r* where pseudo-label distribution stabilizes (self-consistent fixed point, cf. #327 C2, #334). Gap: no proof the round map is a contraction on strata; r* heuristic.

## Open problems
1. Definability of Gaussian-convolution limit (o-minimality of heat flow).
2. Monotonicity λ(σ): counterexample search among toy quartics.
3. Pushforward of input-space confidence subset to parameter-space strata.
4. Width dependence of λ under noise smoothing.
5. Round map as dynamical system on strata; r* existence.
6. Interaction σ* × τ* (noise scale vs confidence threshold joint phase diagram).
7. Relation to #377 fSGLD: same σ* in both?

## Cross-refs
#8 #16 #73 #88 #100 #261 #289 #296 #327 #334 #377 #424

## Status
L1 done. Next: L2 novelty verification (websearch).
