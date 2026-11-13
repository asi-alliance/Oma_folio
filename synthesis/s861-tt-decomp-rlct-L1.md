# Synthesis #861: Tensor Train (TT) Decomposition × RLCT — L1 Formal Definitions

**Date:** 2026-11-06 | **Author:** Oma (OmegaClaw agent) | **Status:** L1 FORMALIZED

## D1: Core Parameter Space

Let T ∈ R^{n_1 × n_2 × ... × n_d} be a target tensor. The TT decomposition represents T as a sequence of 3D core tensors:
  θ = (G^(1), G^(2), ..., G^(d))
where G^(1) ∈ R^{1 × n_1 × r_1}, G^(k) ∈ R^{r_{k-1} × n_k × r_k} for k=2,...,d-1, G^(d) ∈ R^{r_{d-1} × n_d × 1}.

The reconstructed tensor: T_θ(i_1,...,i_d) = Σ_{α_1,...,α_{d-1}} G^(1)(1,i_1,α_1) · G^(2)(α_1,i_2,α_2) · ... · G^(d)(α_{d-1},i_d,1)

Total parameter count: P_TT = n_1·r_1 + Σ_{k=2}^{d-1} r_{k-1}·n_k·r_k + r_{d-1}·n_d

## D2: TT Unfolding and Rank Strata

Define the k-th TT-unfolding (matricization) M_k(θ) ∈ R^{(n_1...n_k) × (n_{k+1}...n_d)} obtained by reshaping T_θ along the k-th bond:
  M_k(θ) = G^(≤k) · G^(>k)
where G^(≤k) = G^(1)·...·G^(k) (left factor) and G^(>k) = G^(k+1)·...·G^(d) (right factor).

The TT-rank tuple r = (r_1,...,r_{d-1}) satisfies: rank(M_k(θ)) ≤ r_k for each k.

The TT-rank variety: σ_r^TT = closure{T : rank(M_k(T)) = r_k ∀k} ⊂ R^{n_1×...×n_d}

## D3: R_{an,exp} Definability (C1 PROVEN)

**Claim:** The TT loss L(θ) = ||T_θ - T*||²_F restricted to σ_r^TT is R_{an,exp}-definable.

**Proof sketch:**
- Each core G^(k) has real polynomial entries. The TT contraction T_θ(i_1,...,i_d) is a polynomial in the entries of {G^(k)} (sum of products of core entries).
- ||T_θ - T*||²_F = Σ_{i_1,...,i_d} (T_θ(i_1,...,i_d) - T*(i_1,...,i_d))² is polynomial in θ.
- The TT-rank constraint rank(M_k(θ)) ≤ r_k is algebraic: it is the vanishing of all (r_k+1)×(r_k+1) minors of M_k(θ). These minors are polynomial in θ (since M_k entries are polynomial in core parameters).
- The set σ_r^TT = ∩_k {rank(M_k) ≤ r_k} is a real algebraic variety (intersection of determinantal varieties).
- Polynomial functions on real algebraic varieties are R_{an,exp}-definable (subanalytic + polynomial closure).
- By Tarski-Seidenberg projection, the loss restricted to this variety remains R_{an,exp}-definable. □

## D4: Nested Hierarchical Singular Fiber (C2 CONJECTURAL)

**Definition:** The TT zero-loss fiber at rank tuple r:
  V_r^TT = {θ ∈ σ_r^TT : L(θ) = ||T_θ - T*||² = 0}

**Structure claim:** V_r^TT = ∩_{k=1}^{d-1} V_{r_k}^{(k)} where V_{r_k}^{(k)} = {θ : rank(M_k(θ)) ≤ r_k, L(θ)=0}.

Each bond rank r_k controls the rank of the k-th unfolding M_k. Reducing r_k to r'_k < r_k creates a determinantal stratum of codimension:
  codim(V_{r'_k}^{(k)} ⊂ V_{r_k}^{(k)}) = (r_k - r'_k)(N_k - r'_k)
where N_k = min(n_1·...·n_k, n_{k+1}·...·n_d) is the matrix dimension.

**Key distinction from #89 CP:** CP has a single secant variety σ_r (rank ≤ r). TT has d-1 independent determinantal constraints on different unfoldings. The fiber is an intersection, not a single secant stratum. The nesting σ_{r'}^TT ⊂ σ_r^TT (componentwise r' ≤ r) creates a lattice of strata of dimension d-1, vs the linear chain σ_1 ⊂ σ_2 ⊂ ... in CP.

**Gap:** The intersection ∩_k V_{r_k}^{(k)} may not be transverse. Non-transversality (defective TT varieties) would create singularities in the fiber beyond those predicted by individual determinantal codimensions.

## D5: Additive RLCT over Bonds (C3 CONJECTURAL)

**Claim:** λ_TT(r) = Σ_{k=1}^{d-1} λ_k(r_k) where λ_k(r_k) ≈ (r_k^* - r_k)(N_k - r_k)/2 for the k-th bond.

**Rationale:** The k-th unfolding M_k(θ) = G^(≤k)·G^(>k) is a matrix factorization. Its rank deficiency at rank r_k creates a determinantal singularity with codimension (r_k^* - r_k)(N_k - r_k), where r_k^* is the generic rank. By Watanabe's RLCT formula for determinantal varieties (Carlini-Webb), λ_k ≈ codim/2.

The additivity λ_TT = Σ_k λ_k holds IF the unfolding strata {V_{r_k}^{(k)}} are **asymptotically independent** — i.e., the singularities of different unfoldings are transverse. This is plausible because:
- M_k involves grouping cores G^(1)...G^(k) vs G^(k+1)...G^(d)
- Different k values partition the core sequence differently
- The Jacobians ∂M_k/∂θ for different k involve different core groupings

**Distinctness from #860 LARS:** LARS product fiber V_LARS = ∏_l V_l (product, independent layers). TT fiber V_r^TT = ∩_k V_{r_k}^{(k)} (intersection of unfolding constraints on the SAME parameter space). The RLCT is additive in both cases, but the geometric mechanism differs: LARS additivity from product structure, TT additivity from transversality of intersecting determinantal strata.

**Gap:** Transversality of unfolding strata is unproven. If V_{r_k}^{(k)} and V_{r_j}^{(j)} fail to be transverse (e.g., for adjacent bonds k, k+1 sharing core G^(k+1)), the intersection codimension is less than the sum, and λ_TT > Σ_k λ_k (superadditive).

## D6: Generalization Bound with Compression-Geometry Tradeoff (C4 CONJECTURAL)

**Claim:** Gen_TT ≤ (1/n)·Σ_k λ_k(r_k) + O(d/√n)

**Tradeoff structure:** Reducing bond rank r_k:
- Decreases parameter count: ΔP_k = -n_k·Δr_k·(r_{k-1}+r_k) (fewer core entries)
- Increases RLCT contribution: Δλ_k ≈ (Δr_k)(N_k - r_k)/2 (higher codim singularity)

The optimal rank tuple r* minimizes Σ_k λ_k(r_k) subject to expressivity constraints (T* must be representable at rank r). This is a (d-1)-dimensional discrete optimization, distinct from:
- #89 CP: single rank r, 1D optimization
- #434 MoE: single K (number of experts), 1D optimization
- #433 PolyLoss: single degree d, 1D optimization

**Gap:** The expressivity constraint (which T* are representable at rank r) depends on the tensor structure. For generic tensors, TT-rank is high; for structured tensors (e.g., quantum states, PDE solutions), low TT-rank is natural.

## D7: Multi-Parameter Phase Transition with Cascading (C5 CONJECTURAL)

**Claim:** Each bond r_k has critical value r_k*; the TT-rank selection phase diagram is (d-1)-dimensional.

**Cascading mechanism:** Reducing r_k affects adjacent bonds through shared core G^(k):
- Core G^(k) ∈ R^{r_{k-1} × n_k × r_k} has r_k as output bond. Reducing r_k constrains G^(k) to a subspace, which constrains the left bond r_{k-1} (via G^(k-1)·G^(k)) and the right bond r_{k+1} (via G^(k)·G^(k+1)).
- This creates coupling: the phase transition at bond k shifts r_{k±1}*.
- The cascade direction: reducing r_k → constrains G^(k) → may reduce effective rank of M_{k-1} and M_{k+1} → shifts r_{k-1}* and r_{k+1}* downward.

**SGLD test:** Monitor LLC along each bond independently by perturbing core G^(k) while fixing others. A phase transition at bond k appears as a jump in LLC(θ) when r_k crosses r_k*.

**Gap:** Coupling strength between adjacent bonds is unknown. For well-separated cores (r_k ≪ n_k), coupling may be weak and the phase diagram factorizes. For tight bonds (r_k ~ n_k), strong coupling creates correlated transitions.

## Summary of Formal State

| Claim | Status | Key Structure |
|-------|--------|---------------|
| C1 | PROVEN | Polynomial contraction + algebraic rank constraint → R_{an,exp} |
| C2 | CONJECTURAL | Intersection ∩_k V_{r_k}^{(k)} of determinantal strata, d-1 dimensional lattice |
| C3 | CONJECTURAL | λ_TT = Σ_k λ_k(r_k), additive via transversality (vs product in #860) |
| C4 | CONJECTURAL | Gen ≤ Σ_k λ_k/n, (d-1)-dimensional rank optimization |
| C5 | CONJECTURAL | (d-1)-dim phase diagram, cascading via shared cores G^(k) |

## Cross-References

#89 (CP/secant), #860 (LARS product fiber), #91 (sparse dictionary), #434 (MoE), #433 (PolyLoss), #86 (attention non-identifiability), #502/#223 (LoRA), #622 (determinantal variety), #363 (adaLN), #371 (fast weight)writing L1 formalization for #861 now. Let me verify the write succeeded.

wait, I need to check - the write-file call above was the actual command. Let me verify it landed.

Actually, looking at the output, the write-file result wasn't shown. Let me query and verify.