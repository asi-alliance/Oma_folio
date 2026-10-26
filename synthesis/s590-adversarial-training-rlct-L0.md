#590 L0: Adversarial Training (PGD/FGSM) × RLCT
Date: 2026-10-24
Status: L0 (candidate exploration)

## Topic
Adversarial training: min_θ max_{||δ||≤ε} L(f_θ(x+δ), y). The inner maximization finds worst-case perturbations within an L_p ball of radius ε, and the outer minimization trains against these worst-case inputs.

## Key Insight
Adversarial training creates a min-max singular structure fundamentally different from standard ERM. The adversarial loss L_adv(θ) = max_{||δ||≤ε} L(f_θ(x+δ), y) defines a different loss function than L(θ) = L(f_θ(x), y). Its singular fibers V_adv = {θ : L_adv(θ) = 0} differ from standard fibers V = {θ : L(θ) = 0}.

## RLCT Bridge
1. **Min-max fiber structure**: L_adv is a maximum of R_{an,exp}-definable functions (assuming L is definable and L_p ball is compact semialgebraic). Maximum of definable functions is definable. So L_adv is R_{an,exp}-definable → finite RLCT exists.

2. **ε as continuous stratum selector**: For ε=0, L_adv = L (standard ERM). For ε>0, the adversarial loss "inflates" the fiber — V_adv ⊇ V (any θ that fits clean data may not fit adversarial data). As ε increases, V_adv shrinks (fewer θ robust to larger perturbations). ε parameterizes a family of singular fibers with different RLCTs.

3. **Min-max singularity vs flat minima**: SAM (#173) minimizes sharpness (a local curvature surrogate) via perturbation in parameter space. Adversarial training perturbs in INPUT space. SAM's singular structure is in θ-space; adversarial training's is in (θ,δ)-space with a max projection. Fundamentally different geometry.

4. **Robust overfitting as RLCT phase transition**: "Robust overfitting" (adversarial training fits training robustness but test robustness degrades) can be interpreted as a mismatch between training-time λ_adv(ε) and test-time generalization. Phase transition at critical ε* where λ_adv jumps.

## Candidate Claims
C1 (PROVABLE): L_adv is R_{an,exp}-definable → finite RLCT. Max of definable functions over compact semialgebraic set is definable.
C2 (CONJECTURAL): V_adv ⊇ V for ε>0. Adversarial fiber is a subset condition — robust solutions must also be clean solutions. The inclusion creates a stratum refinement.
C3 (CONJECTURAL): ε as continuous stratum selector. λ_adv(ε) is monotonically non-decreasing in ε (larger perturbation ball → more complex fiber → higher RLCT).
C4 (CONJECTURAL): Adversarial generalization bound G_adv(n) ≤ λ_adv(ε)·log(n)/(2n) + U_adv/sqrt(n). λ_adv(ε) ≥ λ_standard (adversarial training has higher complexity).
C5 (CONJECTURAL): Phase transition at ε* where robust overfitting onset occurs — λ_adv(ε) exceeds a critical threshold relative to n, causing generalization gap.

## Distinctions
- #173 (SAM): Perturbation in θ-space (sharpness), not input space. Different singularity type.
- #433 (Weight Decay): L2 regularization on θ, not min-max over δ. Different constraint geometry.
- #169 (Dropout): Stochastic marginalization over subnetworks, not worst-case perturbation. Different fiber structure.
- #589 (CTC): Alignment marginalization (sum), not worst-case (max). Logsumexp vs max.

## Open Questions
Q1: Is max of R_{an,exp}-definable functions R_{an,exp}-definable? (Likely yes for finite max, needs verification for continuous max over compact set.)
Q2: Does V_adv ⊇ V hold in general, or only for specific loss types?
Q3: Is λ_adv(ε) monotone in ε? Could be non-monotone if perturbation ball crosses decision boundaries non-uniformly.
Q4: Connection to minimax theorem (Sion): does max_δ min_θ = min_θ max_δ in this setting?
Q5: How does PGD (projected gradient descent) approximation of inner max affect the definability argument?

## Cross-References (tentative)
#8 (RLCT basics), #97 (SGD), #100 (gradient descent), #173 (SAM flat minima), #169 (dropout), #433 (weight decay), #589 (CTC max vs sum), #224 (label smoothing), #234 (temperature scaling)