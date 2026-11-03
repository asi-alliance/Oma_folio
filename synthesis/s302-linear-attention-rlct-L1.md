#302 Linear Attention × RLCT - L1 Formalization

## Setup
Let Theta ⊂ R^d be the parameter space of a linear attention model with feature map phi: R^r → R^m, where m << r (rank-deficient projection). The attention output is A(X; W) = phi(QW)(phi(KW)^T)V where Q,K,V are query/key/value projections.

## Formal Claims
- C1: The image Im(phi_W) = {phi(xW) : x ∈ R^r} defines an algebraic variety V_phi ⊂ R^m. The set {W ∈ Theta : rank(phi_W) < m} is an algebraic subvariety of positive codimension. This is definable in R_{an,exp} since phi involves elementary functions.

- C2: The attention map F: Theta → R^{n×d_out} has singular fibers F^{-1}(y) for generic y. By Watanabe's theorem, RLCT(Theta, F) = min{(d - dim V, 2ν)} over singular strata. Where phi is rank-deficient, dim V < m implies RLCT > d/2.

- C3: Let phi_ELU = {phi : uses ELU activation} and phi_ReLU = {phi : uses ReLU}. The RLCT satisfies lambda(phi_ELU) ≥ lambda(phi_ReLU) because ELU's smooth transition at x=0 preserves the singularity (non-analytic point) while ReLU's piecewise linearity partially desingularizes.

- C4: For softmax temperature τ → ∞, the attention distribution approaches uniform (maximum entropy). The corresponding singular fiber has maximal trapping dimension, concentrating gradient flow on the singular stratum where RLCT is largest.

- C5: Define d*(n) = argmin_d {RLCT(d)/n}. The phase transition at d* separates regimes where increasing m (feature dimension) does vs does not reduce generalization gap. For d > d*, lambda(d)/n plateaus.

## Key Definitions
- RLCT = Real Log Canonical Threshold = max codimension of singular strata weighted by multiplicity
- Singular fiber = preimage of a generic point under the model map
- Stratum selector = activation choice determining which singular strata are accessible

## Next
L2 evidence and derivation.