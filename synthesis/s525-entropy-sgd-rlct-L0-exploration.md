# Synthesis #525: Entropy-SGD × RLCT — L0 Exploration

## Topic
Entropy-SGD (Chaudhari et al., 2019) replaces the pointwise loss L(θ) with a local entropy objective:
F_γ(θ) = -γ · log ∫_{B_ε(θ)} exp(-L(θ')/γ) dθ'

This is a Gibbs distribution over a neighborhood B_ε(θ), effectively smoothing the loss landscape. The RLCT λ governs the volume scaling V({L < t}) ~ t^λ near singularities. Entropy-SGD's γ and ε interact with λ: small γ sharpens (approaches point loss), large γ smooths (desingularizes).

## Key Distinction from Prior Work
- #377 (Gradient Noise Injection): SGLD perturbation adds stochastic noise to gradients — different mechanism, no local entropy averaging
- #420 (Lookahead): Two-phase optimization with weight averaging — no Gibbs smoothing
- #305 (Lion Optimizer): Sign-based momentum — no landscape smoothing
- #169 (Dropout): Stochastic neuron masking — changes fiber structure, not loss smoothing
- #234 (Label Smoothing): Modifies target distribution — changes KL geometry, not local entropy

## Candidate Claims

### C1: R_{an,exp}-Definability
The local entropy F_γ(θ) = -γ log ∫ exp(-L(θ')/γ) dθ' is definable in R_{an,exp} when L is definable, since exp and log are in the structure, and integration over a definable compact neighborhood preserves definability (via definable choice / cell decomposition).

### C2: Regularized RLCT λ(γ) ≤ λ_orig
Entropy-SGD smoothing creates an effective RLCT λ(γ) that is ≤ the original λ. The Gibbs averaging over B_ε(θ) replaces the singular point with a smeared distribution, reducing the effective singularity order. As γ → 0, λ(γ) → λ_orig. As γ → ∞, λ(γ) → d/2 (Gaussian-like, desingularized).

### C3: γ as Stratum Selector — Phase Transition γ*
There exists a critical γ* at which the effective singular locus transitions: for γ > γ*, the dominant singularity is smoothed away; for γ < γ*, the original singularity dominates. This is a phase transition in the free-energy landscape.

### C4: Generalization Bound with λ(γ)
G(γ) ≤ λ(γ)·log(n)/(2n) + bias(γ), where bias(γ) grows with γ (over-smoothing). Optimal γ* minimizes the tradeoff between reduced λ and increased bias.

### C5: SGLD-Testable Phase Transition
The phase transition at γ* is detectable via SGLD: the fluctuation of the local entropy free energy ν_γ = λ(γ) + 2n·Var(L_n) shows a cusp at γ*, analogous to heat capacity at a phase boundary.

## Open Problems
1. Rigorous proof that integration over definable neighborhoods preserves R_{an,exp} definability
2. Monotonicity of λ(γ) in γ — is it always non-increasing?
3. Interaction between ε (neighborhood radius) and γ (temperature) — joint (ε,γ) phase diagram
4. Connection to #377: does gradient noise injection at temperature σ correspond to entropy-SGD at γ=σ²?
5. Multi-well structure: when multiple singularities coexist, does γ select the dominant one?
6. Relation to #173 (SAM): SAM minimizes max loss in ball, Entropy-SGD minimizes log-partition — both smooth, but SAM is worst-case vs entropy-SGD is average-case
7. Deep network architecture dependence of γ*

## Cross-References
#377 (gradient noise), #420 (lookahead), #305 (Lion), #169 (dropout), #234 (label smoothing), #173 (SAM), #224 (temperature scaling), #433 (weight decay), #415 (Muon), #465 (Kaiming init), #298 (orthogonal init), #49 (RG compression)

Next: L1 formalization.