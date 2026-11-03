#841 NTK (Neural Tangent Kernel) × RLCT — L0 Exploration

## Context
NTK describes infinite-width lazy regime where training dynamics are linear in parameters. RLCT (Watanabe's Real Log Canonical Threshold) classifies singularity of loss fibers. The bridge: as width d→∞, NTK kernel degeneracy creates a singular fiber structure that RLCT can classify, and the lazy→feature-learning transition is an RLCT phase transition.

## Candidate Claims

**C1 (Provable):** R_{an,exp} definability of NTK-regime loss.
At finite width, NTK K_NTK(x,x';θ) = ⟨∇_θ f(x), ∇_θ f(x')⟩ is polynomial in θ, hence definable in R_{an,exp}. The NTK-regime training loss L_NTK(θ) = empirical risk under NTK dynamics is definable.

**C2 (Conjectural):** NTK lazy → singular regime transition.
As d→∞, NTK eigenvalue spectrum concentrates (largest eigenvalues dominate), collapsing effective parameter directions. The fiber V_eff = {θ : L(θ) = L*} becomes singular with λ_NTK > λ_full because the kernel imposes an effective rank constraint (analogous to #371 Fast Weight GL(r) gauge fiber, #654 LoRA rank-r constraint). The lazy regime's linear dynamics correspond to a non-degenerate (Morse) fiber; feature-learning regime's nonlinear dynamics correspond to a degenerate (Morse-Bott) fiber with higher RLCT.

**C3 (Conjectural):** Width d as stratum selector.
λ(d) is approximately constant (linear regime) for d >> d*, then transitions to lower λ (feature learning) at d*. The stratum structure V_d = V ∩ {rank constraints from NTK spectrum} creates a filtration indexed by d.

**C4 (Conjectural):** Generalization bound with NTK-singularity correction.
G(d,n) ~ λ(d)/n + U(d)/√n where U(d) captures the NTK eigenvalue decay rate (NTK generalization) that RLCT alone doesn't capture. The bound interpolates between kernel regime (large d, λ linear) and feature-learning regime (small d, λ sublinear).

**C5 (Conjectural):** Phase transition at critical width d*.
λ(d) exhibits a staircase pattern as eigenmodes activate (cf #840 quantization staircase). d* ~ n^{1/(λ_lazy+1)} from RLCT scaling theory. Below d*, the NTK approximation breaks and RLCT decreases (more singular fiber).

## Key Novelty
- NTK eigenvalue degeneracy creates singular fiber structure (distinct from #9 Morse-Bott which was about critical point degeneracy, not kernel spectrum)
- Lazy → feature-learning transition as RLCT phase transition (not just empirical observation)
- Width as stratum selector (cf #654 LoRA rank, #371 Fast Weight GL(r), #480 muP α-parametrization)

## Open Questions
1. Is the NTK eigenvalue collapse exactly captured by RLCT, or only partially?
2. Can d* be predicted from λ_lazy (NTK regime) alone, or does it depend on data geometry?
3. How does the NTK→RLCT bridge interact with #480 muP (feature-learning parametrization)?
4. Does the staircase λ(d) pattern match empirically observed grokking transitions?
5. Is the NTK-regime fiber truly Morse (non-degenerate) or already degenerate for finite d?
6. What is the relationship to #77 (which mentioned lazy regime in a different context)?
7. Does the GP limit (d→∞) correspond to λ → ∞ (maximally non-singular)?

## Cross-References
#9 (Morse-Bott genesis), #77 (lazy regime context), #371 (Fast Weight GL(r) fiber), #480 (muP width parametrization), #654 (LoRA rank-r constraint), #840 (quantization staircase)

## Next Steps
L1 formalization: Define NTK kernel map, eigenvalue strata, λ(d) computation strategy.
Next: L1 formalization.