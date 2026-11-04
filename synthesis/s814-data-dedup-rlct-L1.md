# S814: Data Deduplication × RLCT — L1 Formalization

## D1: Parameter Space and Multiplicity-Weighted Empirical Loss
Let W ⊂ R^d be the parameter space. Training dataset D = {(x_1,y_1),...,(x_n,y_n)} with multiplicity function m: D → N where m(x_i) = k_i counts occurrences. The multiplicity-weighted empirical loss is:
L_n^{dup}(w) = (1/n) Σ_{j=1}^{n} m(x_j) · ℓ(w, x_j, y_j)
where n = Σ_j k_j is total count including duplicates. After dedup, the unique dataset D' = {(x_{j'}, y_{j'})}_{j'=1}^{n'} with n' < n and uniform weights:
L_{n'}^{dedup}(w) = (1/n') Σ_{j'=1}^{n'} ℓ(w, x_{j'}, y_{j'})

## D2: R_an,exp Definability (C1 PROOF)
Each ℓ(w, x_j, y_j) is R_an,exp-definable (standard neural network loss: analytic activation + softmax/cross-entropy + exp). The multiplicity-weighted sum L_n^{dup}(w) = (1/n) Σ_j k_j · ℓ(w,x_j,y_j) is a finite linear combination of R_an,exp functions with positive integer coefficients k_j, hence R_an,exp-definable by closure under finite sums. The dedup loss L_{n'}^{dedup}(w) is the special case k_j = 1 for all j, also R_an,exp. QED.

## D3: Multiplicity-Induced Singular Fiber
Define the duplicate zero-loss set:
V_0^{dup} = {w ∈ W : L_n^{dup}(w) = 0} = {w : Σ_j k_j · ℓ(w,x_j,y_j) = 0} = ∩_{j: k_j > 0} {w : ℓ(w,x_j,y_j) = 0}
The intersection structure is identical to the uniform case: V_0^{dup} = ∩_j {w : ℓ(w,x_j) = 0} = V_0^{dedup} as sets. However, the LOCAL GEOMETRY differs: near a high-multiplicity point x_j with k_j >> 1, the gradient ∇_w L_n^{dup} = (1/n) Σ_j k_j · ∇_w ℓ(w,x_j) is dominated by the k_j terms, creating deeper wells and steeper gradients along memorization directions. The RLCT λ is computed from the integral:
Z_n^{dup}(t) = ∫_{L_n^{dup}(w) < t} φ(w) dw
The multiplicity weighting changes the effective measure concentration near V_0, altering λ.

## D4: Dedup Threshold as Stratum Selector
For near-duplicate detection with threshold ε > 0, define clusters C_ε = {C_1,...,C_{n'(ε)}} where each cluster groups examples within ε-distance. The dedup loss becomes:
L_{n'(ε)}(w) = (1/n'(ε)) Σ_{c=1}^{n'(ε)} ℓ(w, x_c*, y_c*)
where x_c* is a representative (centroid) of cluster C_c. The threshold ε acts as a discrete stratum selector: as ε increases, more examples merge, n'(ε) decreases, and the loss landscape simplifies. The stratum partition {S_ε} is indexed by ε, with coarser partitions for larger ε.

## D5: Dedup-Ratio-Stratified Loss Family
Define the dedup ratio r = n'/n ∈ (0,1]. The family of losses {L_r(w)}_{r∈(0,1]} is parameterized by r, where r=1 means no dedup and r→0 means extreme dedup. Each r defines a different empirical risk with different singular fiber geometry. The RLCT λ(r) is a function of r:
- At r=1 (no dedup): λ(1) = λ_dup, potentially inflated by multiplicity
- At r→0 (extreme dedup): λ(r) → λ_min but n' → 0, increasing variance
- At intermediate r: λ(r) trades off singularity complexity against sample size

## D6: Generalization Bound
The RLCT-based generalization bound for deduplicated data:
G(r) ≤ λ(r) · log(n'(r)) / (2 · n'(r)) + U(r) / sqrt(n'(r))
where n'(r) = r · n, λ(r) is the RLCT at dedup ratio r, and U(r) is the complexity term. The bound has two competing effects:
- Decreasing r lowers λ(r) (simpler landscape, less memorization)
- Decreasing r lowers n'(r), increasing both terms
Optimal r* minimizes G(r). If λ(r) ≈ λ_0 - α · (1-r) (linear reduction) and n' = rn, then:
G(r) ≈ [λ_0 - α(1-r)] · log(rn) / (2rn) + U(r) / sqrt(rn)
Minimizing over r yields the predicted optimal dedup ratio r*.

## D7: Phase Transition at Optimal Dedup Ratio r*
At the critical dedup ratio r*, the generalization bound G(r) is minimized. Below r* (over-dedup), the variance term U/sqrt(n') dominates. Above r* (under-dedup), the multiplicity-inflated λ and memorization dominate. The SGLD-estimated LLC should show:
- For r > r*: LLC elevated due to multiplicity-induced singularity (memorization wells)
- For r ≈ r*: LLC minimized (optimal tradeoff)
- For r < r*: LLC low but variance high (insufficient data)
This predicts an observable phase transition in LLC at r*, testable via SGLD on models trained with varying dedup ratios.

## C1 Proof Summary
R_an,exp definability: PROVEN. The multiplicity-weighted empirical loss is a finite sum of R_an,exp functions with positive integer coefficients. Dedup changes coefficients from k_j to 1 but preserves R_an,exp structure.

## C2-C5 Status
- C2 (multiplicity-induced singularity): CONJECTURAL. V_0 set is identical but local geometry and gradient dominance differ. Need formal proof that multiplicity changes RLCT, not just gradient.
- C3 (dedup as stratum selector): CONJECTURAL. ε-threshold clustering as stratum partition needs formalization beyond heuristic.
- C4 (gen bound): CONJECTURAL. Functional form λ(r) and U(r) assumed; need empirical validation.
- C5 (phase transition): CONJECTURAL. SGLD testable but no prior evidence. The U-shaped LLC prediction is the key testable claim.

## Open Problems
1. Does exact k-fold duplication change RLCT by log(k) (entropy argument) or k^(-1/2) (gradient scaling argument)?
2. Near-duplicate vs exact duplicate: continuous ε → discrete cluster structure discontinuity
3. Interaction with #582 curriculum: does ordering on deduped data change stratum traversal?
4. Effect on #327 pseudo-labeling: dedup of pseudo-labeled data — confirmation bias reduction?
5. Fisher information: does dedup change rank or just eigenvalue spectrum?
6. #253 model collapse: dedup as regularizer against collapse? Shared fiber?
7. Predicting r* from model capacity d and dataset size n: theoretical formula?

## Cross-References
#582 Curriculum Learning, #327 Pseudo-Labeling, #178 Unlearning, #253 Model Collapse, #543 Dataset Distillation, #548 Mixup, #433 Weight Decay, #169 Dropout, #95 Curriculum, #224 Label Smoothing