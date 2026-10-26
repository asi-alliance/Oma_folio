#481 Data Pruning × RLCT — L1 FORMALIZATION
Date: 2026-10-21
Status: FORMALIZATION

## Definitions

D1 (Pruning Mask): A binary vector m ∈ {0,1}^n selecting samples from training set D = {(x_i,y_i)}_{i=1}^n. Retained set S_m = {i : m_i = 1}, |S_m| = Σ m_i.

D2 (Pruned Empirical Loss): L_m(θ) = (1/|S_m|) Σ_{i∈S_m} ℓ(f_θ(x_i), y_i) where ℓ is per-sample analytic loss. L_m ∈ R_an,exp (sum of analytic functions).

D3 (Pruned True Parameter Set): W_m = {θ ∈ W : L_m(θ) = min_φ L_m(φ)} — the set of minimizers of pruned loss. Different masks give different W_m.

D4 (Pruned Fiber): K_m(θ) = {φ ∈ W : L_m(φ) = L_m(θ)} — level set of pruned loss. Fiber structure depends on retained samples.

D5 (RLCT as Function of Mask): λ(m) = RLCT of (L_m, W_m, prior). Key claim: λ is NOT constant across masks — different subsets produce different singularity structures.

D6 (Redundancy-Informativeness Boundary): Sample i is REDUNDANT if W_{m\{i}} = W_m (removal doesn't change true parameter set). Sample i is INFORMATIVE if W_{m\{i}} ≠ W_m. Critical pruning ratio α* = threshold where redundant samples are exhausted.

D7 (Memorization-Singularity Link): Forgetting score f_i (Sorsorce) counts epochs where sample i transitions learned→forgotten. Hypothesis: f_i correlates with sample's contribution to RLCT — high-f_i samples create local singularities in L_m.

## Claim Formalization

C1 (PROVEN — Definability): L_m(θ) is a finite sum of analytic per-sample losses over retained indices → L_m ∈ R_an. The true parameter set W_m = V(L_m - min L_m) is a real analytic variety → RLCT λ(m) exists by Watanabe's theorem.

C2 (CONJECTURAL — Data-Dependent Fiber Stratification):
- Each mask m defines a distinct empirical loss → distinct W_m → distinct fiber K_m
- REMOVING redundant samples: W_{m\{i}} = W_m → same RLCT → λ flat
- REMOVING informative samples: W_{m\{i}} ⊋ W_m (parameter set grows, underdetermined) → potentially HIGHER RLCT
- BUT: removing hard-to-fit samples may REMOVE singularities → LOWER RLCT
- Net effect: λ(m) depends on WHICH samples removed, not just how many
- Gap: exact stratum structure of {m : λ(m) = c} unknown

C3 (CONJECTURAL — Phase Transition at α*):
- λ(α) flat for α < α* (redundant samples removed, W unchanged)
- λ(α) rises for α > α* (informative samples removed, W grows/singularizes)
- α* = |S_redundant| / n — ratio where all redundant samples exhausted
- Prediction: α* is data-dependent, increases with dataset redundancy
- Gap: α* may not be sharp — smooth crossover possible for finite n

C4 (CONJECTURAL — Generalization Bound):
- Pruned: G_S ~ λ(m)/|S_m| + U(m)/√|S_m| (Watanabe)
- Tradeoff: |S_m| smaller → both terms grow, BUT λ(m) may decrease
  if removed samples created singularities
- Optimal pruning: minimize λ(m)/|S_m| over masks m
- Connection to #220: parameter pruning reduces d (dimension), data pruning
  reduces n (sample count) but changes λ — orthogonal mechanisms
- Gap: optimal mask may be intractable (NP-hard subset selection)

C5 (CONJECTURAL — Memorization-Singularity Correlation):
- High-forgetting samples contribute more to local singularities
- Removing them reduces λ but changes W_m (bias)
- RLCT-optimal pruning ≠ accuracy-optimal pruning
- SGLD-testable: compute LLC on full vs pruned datasets, compare λ
- Gap: correlation strength unknown, may be task/model-dependent

## Cross-references: #220 (parameter pruning), #178 (unlearning), #95 (curriculum), #169 (dropout), #222 (weight decay), #385 (LoRA)
## Open problems: 8 (exact λ(m) stratum structure, α* sharpness, memorization-RLCT correlation strength, optimal mask tractability, data+parameter pruning interaction, scale-dependent α*, lower bound on |S|, connection to influence functions)