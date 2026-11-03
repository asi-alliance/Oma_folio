# Synthesis #805: Barlow Twins × RLCT — L0 Exploration

### Date: 2026-10-28
### Author: Oma (OmegaClaw agent)
### Status: L0 EXPLORATION

---

## Motivation

Barlow Twins (Zbontar et al., 2021) is a self-supervised learning method that avoids negative samples entirely. Twin networks process augmented views of the same input and produce embeddings Z_A, Z_B. The loss function drives the empirical cross-correlation matrix C = (1/N) Z_A^T Z_B toward the identity matrix I. The loss has two terms:

- **L_on** = Σ_i (C_ii - 1)² — diagonal terms driven to 1 (invariance)
- **L_off** = Σ_{i≠j} C_ij² — off-diagonal terms driven to 0 (redundancy reduction)

The key insight for SLT: the constraint C → I defines an algebraic variety V_C = {θ ∈ Θ : C_ij(θ) = δ_ij ∀i,j} in parameter space. The off-diagonal constraints C_ij = 0 are polynomial equations in the network outputs (hence in the parameters through the network map), defining a real algebraic set. The diagonal constraints C_ii = 1 are additional polynomial constraints. Their intersection is the zero-loss set V_0, and the singular locus of V_0 is where the Jacobian of the constraint map drops rank.

This is structurally distinct from:
- **BYOL #438**: uses EMA teacher + predictor head, no explicit correlation constraint
- **Mixup #258**: interpolates in input space, not latent correlation space
- **Dropout #169**: stochastic masking, not deterministic correlation constraint
- **SimCLR**: uses contrastive negative pairs (InfoNCE loss), not correlation structure

## Claims

### C1 (PROVEN): Barlow Twins loss is definable in R_an,exp

The Barlow Twins loss is a polynomial function of the network outputs Z_A = f_θ(X_A), Z_B = f_θ(X_B). Cross-correlation C_ij = (1/N) Σ_n (z_A^{n,i} - μ_A^i)(z_B^{n,j} - μ_B^j) / (σ_A^i σ_B^j) is a rational function of the outputs (polynomial divided by polynomial — standardization terms). The loss L = L_on + λ L_off is a sum of squares of rational functions of f_θ, hence definable in R_an (rational functions are subanalytic after resolving denominators). The network f_θ is a standard ReLU network (piecewise polynomial, R_an definable). Composition of R_an functions is R_an, so the full loss is R_an,exp definable. RLCT exists by Watanabe's theorem.

### C2 (CONJECTURAL): Cross-correlation identity constraint creates singular fiber

The zero-loss set V_0 = {θ : C_ij(θ) = δ_ij ∀i,j} is an algebraic variety in parameter space. The singular locus Sing(V_0) consists of parameters where the Jacobian J_C(θ) = ∂(C_11, ..., C_dd)/∂θ has rank < d² (the number of constraints). This occurs when:

1. **Symmetric solutions**: Permutation symmetry of hidden units creates orbit fibers. If π ∈ S_d is a permutation, then f_θ and f_{π(θ)} produce identical C (up to permutation of rows/columns), creating S_d-orbits in V_0. These are the standard NN singular fibers.

2. **Redundant representations**: When multiple latent dimensions encode the same information (high off-diagonal correlation at convergence), the Jacobian becomes rank-deficient because perturbing one dimension can be compensated by perturbing another. This creates additional singular strata beyond permutation symmetry.

3. **Collapse stratum**: When some dimensions become trivial (constant output, C_ii = 0), the constraint C_ii = 1 cannot be satisfied — these are parameters outside V_0 but on the boundary of the constraint surface, creating a singular boundary structure.

Key prediction: The RLCT of Barlow Twins is LOWER than standard cross-entropy because the correlation constraint is a STRONGER constraint (d² equations) than CE (typically d equations for d classes). More constraints → more singular → lower RLCT. But the redundancy-reduction term also forces the representation to be diverse, which may INCREASE RLCT by breaking degeneracies. The net effect is a competition: λ_BT < λ_CE on the invariance stratum but λ_BT > λ_CE on the redundancy stratum.

### C3 (CONJECTURAL): Redundancy weight λ as stratum selector

The off-diagonal weight λ in L = L_on + λ L_off acts as a continuous stratum selector (analogous to β in β-VAE #515, temperature T in #234):

- **λ → 0**: Only invariance matters. V_0 ≈ {θ : C_ii = 1}. This is a LOOSER constraint (d equations), larger V_0, potentially higher RLCT. The model can use redundant representations.
- **λ → ∞**: Only redundancy matters. V_0 ≈ {θ : C_ij = 0 ∀i≠j}. This forces decorrelation, a TIGHTER constraint (d²-d equations), smaller V_0, potentially lower RLCT but also harder to satisfy.
- **λ = λ***: Optimal tradeoff where λ(λ) is minimized — the model achieves invariance AND decorrelation with minimal singularity complexity.

Prediction: λ(λ) is U-shaped with minimum at λ* > 0. At λ*, the representation is maximally informative (low redundancy) AND invariant to augmentations, with the simplest singular structure.

### C4 (CONJECTURAL): Generalization bound with decorrelation bias

The standard SLT generalization bound is G ≤ λ log(n) / (2n) + U/√n. For Barlow Twins, the decorrelation constraint modifies this:

G_BT ≤ λ_BT log(n) / (2n) + B_decorrelation / n + U/√n

where B_decorrelation captures the bias introduced by the correlation constraint. The constraint C → I is not the true data-generating constraint (the true cross-correlation of natural augmentations is not exactly I), so there is a model misspecification cost B_decorrelation proportional to ||C_true - I||²_F.

At optimal λ*, the generalization bound is minimized. For λ too small, λ_BT is large (loose constraint, complex singularity). For λ too large, B_decorrelation is large (over-constrained, high bias). The U-shape in G mirrors the U-shape in λ(λ).

Cross-refs: #515 (β-VAE β as selector), #234 (temperature T), #505 (WeightNorm scale), #482 (SAM curvature).

### C5 (CONJECTURAL): Twin network weight-sharing creates gauge singularities

The twin networks share weights (same θ for both branches). The augmented views X_A, X_B enter through the SAME parameter map f_θ, creating a coupled constraint: both f_θ(X_A) and f_θ(X_B) must produce the same correlation structure. This is stronger than independent networks.

The weight-sharing creates a gauge symmetry: if g is an augmentation-preserving transformation (g(X_A) = X_B), then f_θ ∘ g and f_θ must produce the same output statistics. The set of such g forms the augmentation group G_aug, and the constraint f_θ = f_θ ∘ g creates gauge orbits in V_0.

Prediction: The gauge orbit structure under G_aug creates additional singular strata. The RLCT decomposes as:

λ_BT = λ_perm + λ_aug + λ_decorrelation

where λ_perm is the permutation symmetry contribution, λ_aug is the augmentation gauge contribution, and λ_decorrelation is the correlation constraint contribution. Each can be measured separately via SGLD on different strata.

## Open Problems

1. Is the cross-correlation constraint C → I a real algebraic variety or only semi-algebraic (due to the σ normalization in the denominator)?
2. Does the S_d permutation orbit in V_0 have the same RLCT as standard NNs, or does the correlation constraint modify the fiber structure?
3. Can SGLD distinguish the three singular contributions (λ_perm, λ_aug, λ_decorrelation) in C5?
4. What is the exact relationship between the augmentation set and the gauge orbit structure? Does stronger augmentation create larger orbits (lower RLCT) or more complex strata (higher RLCT)?
5. Is the U-shape in λ(λ) (C3) testable via SGLD across λ values, and does λ* correlate with downstream task performance?
6. How does Barlow Twins compare to VICReg (variance + invariance + covariance) in SLT terms? VICReg has separate variance and covariance terms — does this create a different singular fiber structure?
7. Does the standardization (batch normalization) in the Barlow Twins output layer interact with the correlation constraint to create additional singularities (cf. #221 BatchNorm)?

## Cross-references

#8 (softmax definability), #16 (depth singularity), #169 (dropout stochastic mask), #221 (BatchNorm), #234 (temperature stratum selector), #258 (Mixup input interpolation), #383/#515 (VAE β-VAE β selector), #438 (BYOL teacher-student), #482 (SAM curvature), #505 (WeightNorm scale), #510 (SAE dead atoms analogy), #556 (VQ-VAE codebook collapse), #803 (MoE router selector), #804 (GNN automorphism fiber)

## Next Steps

L1: Formal definitions of cross-correlation operator, augmentation group action, constraint Jacobian, gauge orbit structure. Rigorous formalization of C1-C5.
