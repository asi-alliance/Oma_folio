#482 Sharpness-Aware Minimization (SAM) × RLCT — L1 FORMALIZATION
Date: 2026-10-21
Status: FORMALIZATION

## Definitions

D1 (SAM Loss): L_SAM(w) = max_{||ε||≤ρ} L(w+ε). For empirical loss L(w) = (1/n)Σ l(w, x_i), SAM computes the worst-case loss within an ℓ₂-ball of radius ρ. The inner maximization yields ε*(w) = ρ · ∇L(w)/||∇L(w)|| (first-order approximation).

D2 (Perturbation Fiber): F_ρ(w) = {w' : ||w' - w|| ≤ ρ, L(w') ≥ L_SAM(w) - δ}. The set of perturbed parameters achieving near-maximal loss within radius ρ. For δ→0, this is the set of worst-case perturbations.

D3 (Radius-Stratum Map): σ_ρ: W → Σ where Σ is the stratification of W by RLCT. σ_ρ maps each w to the stratum S_j containing the worst-case perturbation ε*(w). As ρ increases, σ_ρ may cross into deeper (lower-λ) strata — SAM escapes sharp minima.

D4 (SAM-Modified True Set): W*_SAM(ρ) = {w ∈ W* : L_SAM(w) = min_{w'} L_SAM(w')}. Since L_SAM ≥ L pointwise, W*_SAM ⊆ W* (SAM can only make the true set smaller). The SAM true set is the subset of W* lying in the flattest region.

D5 (SAM Generalization Functional): G_SAM(ρ) = λ_SAM(ρ)/n + U_SAM(ρ)/√n where λ_SAM(ρ) is the RLCT of L_SAM at W*_SAM(ρ), and U_SAM(ρ) is the fluctuation functional. Conjecture: λ_SAM(ρ) < λ_standard for ρ = ρ* optimal.

D6 (Flat-Bias Exponent): β(ρ) = λ_SAM(ρ) - λ_standard. β(ρ) ≤ 0 conjecturally for ρ > 0 (SAM lowers effective RLCT by preferring flat regions). β(0) = 0 (degenerates to standard ERM).

D7 (Critical Radius ρ*): The radius at which SAM transitions from over-perturbing (destroying useful minima, λ_SAM rises) to under-perturbing (no flatness benefit, λ_SAM ≈ λ_standard). Conjecture: ρ* ~ c/n^{1/(2λ+1)} where λ is the standard RLCT.

## Claims

C1 (PROVEN): L_SAM is definable in R_an.
Proof: L(w) is analytic (empirical loss of analytic model). The max over a compact ball {||ε|| ≤ ρ} of an analytic function is lower semianalytic (projection of subanalytic set). R_an is closed under projections (Tarski-Seidenberg for o-minimal structures restricted to semianalytic). Therefore L_SAM ∈ R_an → RLCT λ_SAM exists. ∎

C2 (CONJECTURAL): β(ρ) = λ_SAM(ρ) - λ_standard ≤ 0 for ρ > 0.
Gap: The max operation raises L_SAM ≥ L pointwise, which could INCREASE λ (harder to zero out). But SAM's optimization dynamics prefer flat regions, so the REACHED minimum has lower λ. The static λ_SAM of the SAM loss landscape may be ≥ λ_standard, while the dynamical λ_SAM of the trajectory may be ≤ λ_standard. Need to distinguish static vs dynamical RLCT.

C3 (CONJECTURAL): ρ acts as a stratum selector — σ_ρ crosses into lower-λ strata as ρ increases from 0 to ρ*, then into higher-λ (degenerate) strata beyond ρ*.
Gap: The stratum-crossing mechanism is heuristic. Need to formalize the fiber structure of the SAM loss and show that worst-case perturbations align with stratum boundaries. Connection to #173 (SAM × RLCT earlier version, lost): delta-tie strata + sharpness-RLCT anti-correlation at degenerate singularities.

C4 (CONJECTURAL): G_SAM(ρ*) < G_standard, i.e., SAM achieves better generalization. The improvement is ΔG = (λ_standard - λ_SAM(ρ*))/n + (U_standard - U_SAM(ρ*))/√n.
Gap: λ_SAM(ρ*) < λ_standard is not proven (C2 is conjectural). U_SAM may be larger (SAM loss is noisier). Need empirical LLC comparison under SAM vs SGD.

C5 (CONJECTURAL): U-shaped λ_SAM(ρ) with minimum at ρ*. Phase transition at ρ* detectable via SGLD: LLC under SAM should show non-monotone behavior as ρ varies, with minimum at ρ*.
Gap: The U-shape is plausible (too small ρ = no effect, too large ρ = destroys signal) but the critical scaling ρ* ~ n^{-1/(2λ+1)} is analogy-based from early stopping (#236) and weight decay (#222) scaling.

## Open Problems: 7

1. Static vs dynamical RLCT of SAM: which one controls generalization?
2. Does the max operation create new singularity types (non-analytic ridge lines)?
3. Rigorous stratum-crossing proof for σ_ρ
4. Scaling law for ρ*: is it n^{-1/(2λ+1)} or different?
5. Interaction with weight decay (#222): does ρ* shift under L2 regularization?
6. SAM × Lookahead (#420): does the slow-fast dynamic change ρ*?
7. LLC measurement protocol for SAM vs SGD comparison

## Cross-references
#173 (SAM × RLCT v1, lost), #236 (Early Stopping), #222 (Weight Decay), #241 (Gradient Clipping), #169 (Dropout), #420 (Lookahead), #394 (SWA), #173 delta-tie strata, #433 (Weight Decay v2), #213, #226, #227, #232, #354