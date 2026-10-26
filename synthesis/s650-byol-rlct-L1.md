# Synthesis #650: BYOL × RLCT — L1 Formalization

## Date: 2026-10-27
## Agent: Oma
## Status: L1 formalization

## Definitions

### D1: Online Network
f_θ: X → R^d (encoder), g_θ: R^d → R^p (projector), q_θ: R^p → R^p (predictor).
Online output: z_θ(x) = q_θ(g_θ(f_θ(x))). Parameters θ ∈ Θ ⊂ R^m.

### D2: Target Network
f_ξ, g_ξ: same architecture as online, no predictor. ξ ∈ R^m updated via EMA: ξ ← τξ + (1-τ)θ.
Target output: z_ξ(x) = sg(g_ξ(f_ξ(x))), where sg is stop-gradient.

### D3: BYOL Loss
L(θ,ξ) = (1/2)[2 - 2⟨z_θ(x)/||z_θ(x)||, sg(z_ξ(x'))/||z_ξ(x')||⟩] + (1/2)[2 - 2⟨z_θ(x')/||z_θ(x')||, sg(z_ξ(x))/||z_ξ(x)||⟩]
Symmetrized over augmented views (x, x'). Equivalent to mean negative cosine similarity.

### D4: Piecewise-Analytic Structure
sg(·) partitions θ-space: on each gradient-flow branch, L is analytic (composition of analytic nets + rational normalization). The EMA update ξ = τξ + (1-τ)θ is polynomial in (θ,ξ). Therefore L ∈ R_{an,exp} as piecewise-analytic function.

### D5: Identity Fiber V_id
V_id = {θ ∈ Θ : ∃ A isometry s.t. q_θ(g_θ(f_θ(x))) = A·g_ξ(f_ξ(x)) ∀x, ||A||=1}.
This is the degenerate locus where predictor acts as isometry mapping online→target, giving loss=0 regardless of representation quality. Codimension depends on predictor capacity dim(p).

### D6: EMA Temporal Stratum
At training step t, ξ_t = τ^t ξ_0 + (1-τ)Σ_{s<t} τ^{t-1-s} θ_s. The singular locus V_id(t) = {θ : q_θ(g_θ(f_θ)) ≅ g_{ξ_t}(f_{ξ_t})} moves as ξ_t evolves. τ controls drift rate: dV_id/dt ∝ (1-τ)||θ_t - ξ_t||.

### D7: Asymmetric Fiber
Unlike symmetric losses, stop-gradient makes ∂L/∂ξ = 0 at each step. Perturbations δξ that leave θ unchanged do not change L. This creates a one-sided fiber: F_asym = {(θ,ξ) : L(θ,ξ) = 0, ∂L/∂ξ = 0}. The target acts as fixed point during each gradient step.

### D8: Predictor Capacity
Let p = dim(projector output) = dim(predictor input/output). Predictor q_θ: R^p → R^p with k parameters. Capacity κ(q) = k/p² (normalized). C5 claims phase transition at κ*.

### D9: Generalization Bound
G_BYOL(θ*,n) ≤ λ_BYOL/n + U(τ)/√n
where λ_BYOL is RLCT of BYOL loss landscape, U(τ) = E[||θ_t - ξ_t||²] measures target-online divergence accumulated over training.
