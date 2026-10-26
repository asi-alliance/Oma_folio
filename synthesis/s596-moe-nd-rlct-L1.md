# Synthesis #596: MoE-nD (Multi-Axis MoE Compression Routing) × RLCT — L1 Formalization

**Date:** 2026-10-25
**Status:** L1 — Formal Definitions
**Prereq:** L0 (s596-moe-nd-rlct-L0.md, 5045B) VERIFIED

## Formal Definitions

### D1: Compression Configuration Space
Let the KV cache tensor be K ∈ R^{L×n×d} (L layers, n sequence length, d head dim).
A compression configuration c = (e, p_K, p_V) ∈ C where:
- e ∈ {0, 1/n, ..., 1} is the eviction ratio (fraction of KV pairs retained)
- p_K ∈ {2, 4, 8, 16} is the K-precision (bits per element)
- p_V ∈ {2, 4, 8, 16} is the V-precision
The configuration space C = E × P_K × P_V is a finite discrete product space.
The compression operator T_c: R^{L×n×d} → R^{L×n_c×d} applies eviction (top-k selection) and quantization (round-to-nearest with scale s_{p}).

### D2: MoE-nD Router
For each layer l, the router g_l: R^d → Δ^{|C|} is:
  g_l(c | h_l) = softmax(W_g^l · h_l)_c
where h_l is the hidden state at layer l, W_g^l ∈ R^{|C|×d} are routing weights.
The selected configuration per layer: c_l = argmax_c g_l(c | h_l).
The routed output at layer l:
  f_l(θ, x) = Σ_c g_l(c | h_l) · Attention(T_c(K_l), Q_l)

### D3: MoE-nD Loss — R_an,exp Definability (C1 Formal)
The total loss L_{MoE-nD}(θ) = (1/N) Σ_n CE(f(θ, x_n), y_n) where f is the composition of L layers each with routed attention.
- Router g_l: softmax of affine map → analytic → R_an
- T_c: top-k eviction (piecewise, semi-algebraic via order statistics) + quantization (floor function, piecewise-linear) → piecewise definable in R_an
- Attention: softmax(QK^T/√d)V → R_an,exp (as in #545)
- CE: log-softmax → R_an,exp
- Finite sum → R_an,exp
By Watanabe's theorem, RLCT λ_{MoE-nD} exists and is finite. ∎

### D4: Compression-Config-Stratified Singular Fiber (C2 Formal)
For a fixed configuration assignment c = (c_1, ..., c_L):
  V_0(c) = {θ ∈ W : L_{MoE-nD}(θ; c) = 0}
Each c selects a different compression of the KV space → different attention geometry → different zero-loss variety.
The global zero-loss set: V_0^{global} = ∪_c V_0(c) (union over all configuration assignments).
The routing boundary Σ_{c,c'} = {θ : L(θ; c) = L(θ; c')} is the set where two configurations give equal loss — a semi-algebraic hypersurface (generically).
At configuration ties, the effective singular fiber is the intersection V_0(c) ∩ V_0(c'), which may have higher codimension → lower RLCT.

### D5: Per-Layer Depth as Stratum Selector (C3 Formal)
Let L_r be the number of layers with independent routing (routed layers). Define:
  λ(L_r) = RLCT of L_{MoE-nD} with L_r routed layers
- L_r = 0: no routing, standard attention → λ = λ_dense
- L_r = L: all layers routed → maximum stratum fragmentation
Conjecture: λ(L_r) is non-monotone (U-shaped):
  - Low L_r: coarse compression, high redundancy → high λ
  - Optimal L_r*: balanced granularity → low λ
  - High L_r: excessive fragmentation, router noise dominates → high λ
Distinction from #127: #127 routes subnetworks (parameter-space strata), #596 routes compression configs (KV-tensor-space strata).

### D6: Multi-Axis Generalization Bound (C4 Formal)
G_{MoE-nD} ≤ C · √(λ(c*) · d_eff(c*) / n)
where c* = argmin_c λ(c) is the optimal configuration and:
  d_eff(c) = d · e · (p_K / p_max) · (p_V / p_max)
is the effective dimension under compression config c (product of per-axis compression ratios).
Multi-axis hypothesis: d_eff factorizes as product of per-axis ratios.
Cross-axis interaction hypothesis: d_eff = d · e · f(p_K, p_V) where f has interaction terms.
Key gap: whether factorization holds or cross-axis terms dominate.

### D7: Compression Budget Phase Transition (C5 Formal)
Define compression budget B = Σ_l (1 - e_l) · (1 - p_K^l/p_max) · (1 - p_V^l/p_max) (total compression across layers).
Critical budget B* = argmax_B |dλ/dB| (steepest RLCT change).
- B < B*: compression strata barely affect fibers → λ ≈ λ_dense (lossless regime)
- B > B*: compression merges/simplifies singular fibers → λ jumps (lossy regime)
- B = B*: phase transition, optimal compression-accuracy tradeoff
SGLD prediction: LLC estimate λ̂(B) shows sharp transition at B*, analogous to #229 single-axis eviction threshold but in multi-axis product space.

## MeTTa-Ready Claims

```metta
;; C1: R_an,exp definability (PROVEN)
(|- ((==> (Inheritance MoE-nD-Loss R_an_exp) (stv 1.0 0.95))
     ((Inheritance Router-softmax R_an_exp) (stv 1.0 0.9))
     ((Inheritance Compression-op piecewise-definable) (stv 1.0 0.9)))

;; C2: Compression-config stratified fiber (CONJECTURAL)
(|- ((==> (Equality (Loss theta c1) (Loss theta c2)) (Membership theta RoutingBoundary)) (stv 1.0 0.9)))
(|~ ((==> (Inheritance V0-global (Union V0-c)) (stv 0.7 0.8))))

;; C3: Per-layer depth as stratum selector (CONJECTURAL)
(|~ ((==> (Equality L_r L_star) (Minimum (RLCT_fn L_r))) (stv 0.0 0.7)))
(|~ ((MonotoneDecreasing-then-Increasing (RLCT_fn L_r) L_r) (stv 0.0 0.65)))

;; C4: Multi-axis generalization bound (CONJECTURAL)
(|~ ((==> (Inheritance d_eff (Product evict-ratio K-ratio V-ratio)) (stv 0.5 0.7)))

;; C5: Compression budget phase transition (CONJECTURAL)
(|~ ((==> (Equality B B_star) (PhaseTransition RLCT-jump)) (stv 0.55 0.7)))
```

## Open Problems (Refined for L2)

1. **Product vs min RLCT:** Does multi-axis compression give λ_product = ∏_axis λ_axis or λ_product = min_axis λ_axis? Need explicit computation for a toy model.
2. **Cross-axis interaction:** Formal derivation of f(p_K, p_V) — does K-precision affect V-precision stratum geometry through attention score coupling?
3. **Router decision geometry:** Is the routing boundary Σ_{c,c'} generically transverse to V_0(c)? If not, the intersection singularity type changes.
4. **Dead compression configs:** Analog of dead experts — compression policies never selected. Do they create unused strata with λ = ∞ (empty fiber)?
5. **STE inheritance:** Quantization experts inherit #354's forward/backward RLCT split. Does this create a per-axis STE singularity layer on top of the routing singularity?
6. **Load balancing:** #127 C5 predicts load balancing perturbation. Does MoE-nD load balancing (over compression configs) create a regularization effect on λ?
7. **Empirical SGLD:** Can λ(c) be estimated for different MoE-nD configurations on a real model?

## Cross-References

#8 (Adam) #16 (ReLU) #73 #100 #127 (MoE routing) #229 (KV cache eviction) #244 #354 (STE/quantization) #362 (CFG) #375 #381 #420 #434 (MoE framework) #486 #504 #537 (MoE L4) #551 #545 (Sparse attention)

## Lineage

- Generalizes #127 (MoE × RLCT) from subnetwork experts to compression-config experts
- Extends #229 (KV cache eviction × RLCT) from single-axis to multi-axis product stratification
- Inherits #354 (STE × RLCT) forward/backward split per quantization axis

---

Next: L2 novelty verification.