# Synthesis #687: Gradient Checkpointing × RLCT — L1 Formalization

**Date:** 2026-10-28
**Status:** L1 Formal Definitions
**Pipeline:** L0 ✓ → L1 (this file) → L2 (novelty) → L3 (MeTTa) → L4 (summary)

---

## Formal Definitions

### D1: Parameter Space
Let W ∈ ℝ^d be the model parameters. The model is an L-layer network with layers f_1,...,f_L, each f_ℓ: ℝ^{d_ℓ} × ℝ^{d_{ℓ-1}} → ℝ^{d_ℓ}. The forward pass computes a_ℓ = f_ℓ(W_ℓ, a_{ℓ-1}) with a_0 = x.

A checkpointing scheme is a partition of {1,...,L} into k segments S_1,...,S_k where S_j = {s_{j-1}+1,...,s_j} with 0 = s_0 < s_1 < ... < s_k = L. Checkpoints are saved at boundaries s_0,...,s_{k-1}.

### D2: Checkpointed Loss
The exact loss is L(W) = E_{(x,y)~D}[l(f_L∘...∘f_1(x; W), y)].

The checkpointed loss L_ckpt(W) is formally identical: L_ckpt(W) = L(W) as R_an,exp functions. The difference lies in the gradient computation: during backprop, activations a_l for l in S_j are recomputed from the checkpoint at s_{j-1}:
  a_hat_l = f_l(W_l, f_{l-1}(W_{l-1}, ... f_{s_{j-1}+1}(W_{s_{j-1}+1}, a_{s_{j-1}})...))

The effective gradient is grad L_ckpt(W) = grad L(W) + delta_ckpt(W) where delta_ckpt captures floating-point divergence, with ||delta_ckpt|| = O(eps_fp * k * L).

### D3: R_an,exp Definability (C1 PROVEN)
Claim C1: L_ckpt(W) is R_an,exp-definable.

Proof: Each layer f_l is R_an,exp-definable (polynomial matmul, analytic activations). The composition is R_an,exp-definable by closure. The loss l is definable (cross-entropy: softmax + log, both analytic; MSE: polynomial). The recomputed activations use the SAME definable functions, just in a different numerical order. R_an,exp-definability is a property of the formal function, not its numerical implementation. Therefore L_ckpt = L is R_an,exp-definable, and finite RLCT lambda_ckpt = lambda < infty follows by resolution of singularities.

### D4: Checkpoint-Perturbed Singular Fiber (C2 CONJECTURAL)
Define the checkpoint-perturbed fiber at level k and precision eps:
  V_ckpt(k, eps) = {W in R^d : L_ckpt(k,eps)(W) = 0}

where L_ckpt(k,eps)(W) = L(W) + R_k,eps(W) and ||R_k,eps||_inf <= C * eps_fp * k.

Conjecture C2: The perturbed fiber V_ckpt is a slight thickening of V = {W : L(W) = 0}. For standard precision (eps_fp ~ 1e-7), perturbation is below singularity scale: V_ckpt approx V. RLCT satisfies lambda_ckpt(k) = lambda + O(eps_fp * k), negligible for fp32/bf16.

### D5: Checkpoint Count k as Stratum Selector (C3 CONJECTURAL)
The checkpoint count k parametrizes a family of effective losses {L_ckpt(k,.)}_{k=1}^{L}.

Conjecture C3: k acts as a weak stratum selector at standard precision but becomes meaningful at low precision (fp8, eps_fp ~ 1e-2). Predicted: lambda_ckpt(k, fp8) < lambda_exact for k >= k* where k* depends on local singularity sharpness.

### D6: Generalization Bound (C4 CONJECTURAL)
Conjecture C4: G_ckpt <= lambda_ckpt(k, eps)/n + U(k)/sqrt(n) where U(k) captures recomputation non-determinism variance. For deterministic recomputation, U(k) = 0. The indirect effect (enabling larger models/batch sizes) dominates.

### D7: Phase Transition k* (C5 CONJECTURAL)
Conjecture C5: At low precision, critical checkpoint count k* exists:
- k < k*: lambda_ckpt approx lambda_exact
- k = k*: desingularization begins
- k > k*: lambda_ckpt < lambda_exact, monotone decreasing
Predicted scaling: k* ~ 1/eps_fp. At fp32: k* ~ 1e7 (unobservable). At fp8: k* ~ 100 (observable).

## Open Problems

1. Tight bound on |lambda_ckpt - lambda_exact| as function of (k, eps_fp, L, d)
2. Existence of spurious critical points at checkpoint boundaries
3. Interaction with non-deterministic kernels: stochastic RLCT?
4. Selective checkpointing (non-uniform segments): heterogeneous stratum selector
5. Effect on SGLD LLC estimation: does checkpointing bias the local learning coefficient?
6. Reversible architectures: do they share the same RLCT?
7. Intentional low-precision checkpointing as desingularizer: can k > k* at fp8 improve generalization?

## Cross-References

#8 (foundational RLCT), #16 (Watanabe gen bound), #155 (gradient noise), #194 (quantization), #224 (label smoothing), #354 (STE/mixed precision), #470 (QAT), #533/#553 (gradient accumulation), #609 (gradient noise injection), #619 (RMSNorm), #525 (Entropy-SGD desingularization)
