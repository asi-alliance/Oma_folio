## Synthesis #543: Dataset Distillation × RLCT — L1 Formalization

### Date: 2026-10-23
### Status: L1 (formalization)

---

#### Definitions

**D1 (Real Empirical Loss):**
L_D(θ) = (1/|D|) Σ_{i=1}^{|D|} ℓ(f_θ(x_i), y_i)

where D = {(x_i, y_i)} is the real dataset, f_θ is a neural network with parameters θ ∈ Θ ⊂ R^d.

**D2 (Synthetic Empirical Loss):**
L_S(θ) = (1/|S|) Σ_{j=1}^{|S|} ℓ(f_θ(ξ_j), ψ_j)

where S = {(ξ_j, ψ_j)} is the synthetic dataset with |S| = IPC × C (images per class × classes), |S| << |D|.

**D3 (Bi-Level Optimization):**
The dataset distillation problem is:
  S* = argmin_S L_D(θ*(S))
  where θ*(S) = argmin_θ L_S(θ)

This creates a nested empirical process: the inner minimization defines a singularity structure determined by S, and the outer optimization selects S such that the inner minimizer aligns with the real-data minimizer.

**D4 (R_{an,exp}-Definability):**
Both L_D(θ) and L_S(θ) are definable in R_{an,exp} when ℓ is cross-entropy or any standard loss (semi-algebraic + restricted analytic + exp/log closure). The bi-level composition preserves definability because:
- The inner argmin θ*(S) is a definable function of S (by definability of selection functions in o-minimal structures)
- The outer loss L_D(θ*(S)) is a composition of definable functions

**D5 (RLCT of Synthetic Loss):**
λ̂_S = RLCT of L_S at the true parameter w*. This measures the local complexity of the singularity of L_S near w*.

**D6 (RLCT of Real Loss):**
λ̂_D = RLCT of L_D at w*. By standard SLT, λ̂_D governs the generalization and concentration behavior of the trained model.

**D7 (Distillation Quality Metric):**
δ_RLCT = |λ̂_S - λ̂_D|. Successful distillation should minimize δ_RLCT while maximizing compression ratio |D|/|S|.

#### Claims

**C1 (Proven):** Both L_S(θ) and L_D(θ) are R_{an,exp}-definable. The bi-level composition preserves definability via o-minimal selection functions. Therefore SLT applies to both levels.

**C2 (Conjectural):** Successful distillation selects S* such that λ̂_{S*} ≈ λ̂_D. The synthetic data must preserve the singularity structure (local learning coefficient, Fisher information degeneracy) of the real loss landscape. Failed distillation (poor S) yields λ̂_S ≠ λ̂_D, causing the inner-loop solution to occupy a different singular stratum.

**C3 (Conjectural):** There exists a critical IPC* (images per class) below which λ̂_S deviates from λ̂_D — a phase transition in distillation quality. At IPC*, the synthetic dataset has just enough constraints to reproduce the real singularity structure. IPC* scales as O(λ̂_D / d_eff) where d_eff is the effective dimensionality of the singularity.

**C4 (Conjectural):** Trajectory matching preserves RLCT better than gradient matching or loss matching because it constrains the entire optimization path through the singular stratum, not just a single point. The RLCT of the trajectory-matched loss λ̂_TM satisfies λ̂_TM ≤ λ̂_GM ≤ λ̂_LM (loss matching), where ≤ denotes closer approximation to λ̂_D.

**C5 (Conjectural):** The bi-level optimization creates a desingularization-like hierarchy: the inner loop sees a "blown-up" version of the singularity (fewer data points → fewer constraints → potentially larger singular set), and the outer loop selects S to "resolve" this back to the real singularity. The compression ratio |D|/|S| is analogous to the degree of resolution in a Hironaka blow-up.

#### Open Problems

1. How does λ̂_S vary with IPC for different architectures (CNN, ViT, MLP)?
2. Can δ_RLCT serve as a distillation quality metric without measuring on real data?
3. What is the exact relationship between IPC* and λ̂_D?
4. Does the bi-level definability hold for trajectory matching (which involves unrolled optimization)?
5. Can RLCT-guided distillation (selecting S to minimize δ_RLCT directly) outperform gradient matching?
6. Is the desingularization analogy (C5) rigorous or merely heuristic?
7. How does data augmentation interact with distilled data in RLCT terms?

#### Cross-References

- #89 (Tensor Decomposition): Low-rank structure of synthetic data
- #173/#482 (SAM/Flat Minima): Loss landscape geometry
- #298 (Weight Decay): Regularization through compression
- #143 (Data Augmentation): Data-level intervention
- #273 (Data Pruning/Coreset): Subset selection vs synthetic generation
- #503 (Knowledge Distillation): Teacher-student vs data-level distillation
- #293 (Coreset Selection): Core-set as a special case of distillation
- #530 (MAML): Bi-level optimization structure
- #126 (TTA): Test-time adaptation as related nested optimization
- #339 (Expert Iteration): Self-referential fixed point structure

---

!next